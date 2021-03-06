### boostrapping issue --> moved here.

class UserPages:
    user = property(lambda self: self.__self__)
    dbsession = property(lambda self: self.user.__self__.dbsession)


    def _filter_pages(self, pages):
        query = self.dbsession.query(Page).filter(Page.identifier in pages)
        return [page for page in query if page.existant]



    def _add_pagename(self, pagename, group='visited_pages'):
        pages = self._get_pages(group)
        pages.append(pagename)
        setattr(self,group, ' '.join(pages))
        #return self

    def _add_page(self, page, group='visited_pages'):
        pages = self._get_pages(group)
        pages.append(page)
        setattr(self,group, ' '.join(pages))
        #return self

    def add_visited_page(self,pagename):
        self._add_page(pagename, 'visited_pages')
        return self

    def add_owned_page(self,pagename):
        self._add_page(pagename, 'owned_pages')
        return self

    def get_owned_pages(self):
        return self._get_pages('owned_pages')

    def get_visited_pages(self):
        return list(set(self._get_pages('visited_pages')) - set(self.get_owned_pages()))

    def _get_pages(self, group='visited_pages'):
        # for p in [Page(pagename) for pagename in user.owned_pages.split()] if p.exists()
        if getattr(self, group):
            return self._filter_pages(getattr(self, group).split())
        else:
            return []

    ############### these methods return not list of string but list of Page instatnces.
    def _get_loaded_pages(self, group='visited_pages'):
        pagelist = []
        if group == 'visited_pages':
            fun = self.get_visited_pages
        else:
            fun = self.get_owned_pages
        for pagename in fun():
            page = Page(pagename)
            if page.encrypted:
                page.settings = {'title': '***********', 'description': 'This page is encrypted.'}
            else:
                page.load()
            pagelist.append(page)
        return pagelist

    def get_visited_loaded_pages(self):
        return self._get_loaded_pages(group='visited_pages')

    def get_owned_loaded_pages(self):
        return self._get_loaded_pages(group='owned_pages')

    visited = property(get_visited_pages)
    owned = property(get_owned_pages)

class old_Page:
    def __init__(self, identifier, key=None):
        self.identifier = identifier.replace('\\', '/').replace('*', '').split('/')[-1]
        self.unencrypted_path = os.path.join('michelanglo_app', 'user-data', self.identifier + '.p')
        self.encrypted_path = os.path.join('michelanglo_app', 'user-data', self.identifier + '.ep')
        self.thumb = os.path.join('michelanglo_app', 'user-data', self.identifier + '.png')
        if key:
            self.path = self.encrypted_path
        else:
            self.path = self.unencrypted_path
        self.settings = {}
        if key:
            self.key = key.encode('utf-8')
        else:
            self.key = None

    def exists(self, try_both=False):
        if try_both:
            if os.path.exists(self.unencrypted_path) or os.path.exists(self.encrypted_path):
                return True
        elif os.path.exists(self.path):
            return True
        else:
            return False

    def is_password_protected(self, raise_error=False):
        path_exists = os.path.exists(os.path.join('michelanglo_app', 'user-data', self.identifier + '.p'))
        epath_exists = os.path.exists(os.path.join('michelanglo_app', 'user-data', self.identifier + '.ep'))
        if path_exists and not epath_exists:
            return False
        elif not path_exists and epath_exists:
            return True
        else:
            if raise_error:
                raise FileExistsError
            else:
                return False

    def load(self, die_on_error=False):
        if self.exists():
            if not self.is_password_protected():
                with open(self.path, 'rb') as fh:
                    self.settings = pickle.load(fh)
            elif self.key:
                with open(self.path, 'rb') as fh:
                    cryptic = fh.read()
                    decryptic = self._decrypt(cryptic)
                    self.settings = pickle.loads(decryptic)
            else:
                raise ValueError('No key provided.')
        else:
            if die_on_error:
                raise FileNotFoundError(self.identifier)
            else:
                print(self.identifier, 'not found')
        return self.settings

    def save(self, settings=None):
        ## sort things out
        if not settings:
            settings = self.settings
        if 'description' not in settings:
            settings['description'] = '## Description\n\nEditable text. press pen to edit.'
        if 'title' not in settings:
            settings['title'] = 'User submitted structure'
        for fun, keys in ((list, ('editors', 'visitors', 'authors')),
                          (bool, ('image', 'uniform_non_carbon', 'verbose', 'validation', 'save', 'public',
                                  'confidential')),
                          (str, (
                          'viewport', 'stick', 'backgroundcolor', 'loadfun', 'proteinJSON', 'pdb', 'description',
                          'title', 'data_other'))):
            for key in keys:
                if key not in settings:
                    settings[key] = fun()
        # metadata
        settings['date'] = str(datetime.datetime.now())
        settings['page'] = self.identifier
        settings['key'] = self.key  # is this wise??
        ## write
        with open(self.path, 'wb') as fh:
            if not self.key:
                pickle.dump(settings, fh)
            else:
                uncryptic = pickle.dumps(settings)
                cryptic = self._encrypt(uncryptic)
                fh.write(cryptic)
        return True

    def delete(self):
        if os.path.exists(self.encrypted_path):
            os.remove(self.encrypted_path)
            return True
        elif os.path.exists(self.unencrypted_path):
            os.remove(self.unencrypted_path)
            return True
        else:
            return False

    @staticmethod
    def sanitise_URL(page):
        return page.replace('\\', '/').replace('*', '').split('/')[-1]

    @staticmethod
    def sanitise_HTML(code):
        def substitute(code, pattern, message):
            code = re.sub(f'<[^>]*?{pattern}[\s\S]*?>', message, code, re.IGNORECASE | re.MULTILINE | re.DOTALL)
            pseudo = re.sub('''(<[^>]*?)['`"][\s\S]*?['`"]''', r'\1', code,
                            re.IGNORECASE | re.MULTILINE | re.DOTALL)
            print(pseudo)
            if re.search(f'<[^>]*?{pattern}[\s\S]*?>', pseudo):  # go extreme.
                print('here!', pattern)
                code = re.sub(pattern, message, code, re.IGNORECASE | re.MULTILINE | re.DOTALL)
            return code

        code = re.sub('<!--*?-->', 'COMMENT REMOVED', code)
        for character in ('\t', '#x09;', '&#x0A;', '&#x0D;', '\0'):
            code = code.replace(character, ' ' * 4)
        code = code.replace(character, ' ' * 4)
        for tag in ('script', 'iframe', 'object', 'link', 'style', 'meta', 'frame', 'embed'):
            code = substitute(code, tag, tag.upper() + ' BLOCKED')
        for attr in ('javascript', 'vbscript', 'livescript', 'xss', 'seekSegmentTime', '&{', 'expression'):
            code = substitute(code, attr, attr.upper() + ' BLOCKED')
        code = substitute(code, 'on\w+', 'ON-EVENT BLOCKED')
        for letter in range(65, 123):
            code = substitute(code, f'&#0*{letter};', 'HEX ENCODED LETTER BLOCKED')
            code = substitute(code, f'&#x0*{letter:02X};', 'HEX ENCODED LETTER BLOCKED')
        return code

    # https://stackoverflow.com/questions/42568262/how-to-encrypt-text-with-a-password-in-python
    def _encrypt(self, source, encode=False):
        key = SHA256.new(self.key).digest()  # use SHA-256 over our key to get a proper-sized AES key
        IV = Random.new().read(AES.block_size)  # generate IV
        encryptor = AES.new(key, AES.MODE_CBC, IV)
        padding = AES.block_size - len(source) % AES.block_size  # calculate needed padding
        source += bytes([padding]) * padding  # Python 2.x: source += chr(padding) * padding
        data = IV + encryptor.encrypt(source)  # store the IV at the beginning and encrypt
        return base64.b64encode(data).decode("latin-1") if encode else data

    def _decrypt(self, source, decode=False):
        if decode:
            source = base64.b64decode(source.encode("latin-1"))
        key = SHA256.new(self.key).digest()  # use SHA-256 over our key to get a proper-sized AES key
        IV = source[:AES.block_size]  # extract the IV from the beginning
        decryptor = AES.new(key, AES.MODE_CBC, IV)
        data = decryptor.decrypt(source[AES.block_size:])  # decrypt
        padding = data[-1]  # pick the padding value from the end; Python 2.x: ord(data[-1])
        if data[-padding:] != bytes([padding]) * padding:  # Python 2.x: chr(padding) * padding
            raise ValueError("Invalid padding...")
        return data[:-padding]  # remove the padding





    def remove_visited_page(self, pagename):
        self.visited_pages = self.visited_pages.replace(pagename,'')

    def remove_owned_page(self, pagename):
        self.visited_pages = self.visited_pages.replace(pagename,'')

    def add_visited_page(self, pagename):
        self.visited_pages += ' ' + pagename

    def add_owned_page(self, pagename):
        self.owned_pages += ' ' + pagename

    def set_owned_pages(self, pagenames):
        self.owned_pages = ' '.join(pagenames)

    def set_visited_pages(self, pagenames):
        self.visited_pages = ' '.join(pagenames)

    def get_owned_pages(self):
        return self.owned_pages.split()

    def get_visited_pages(self):
        return list(set(self.visited_pages.split()) - set(self.owned_pages.split()))

    def select_owned_pages(self, request):
        pagenames = self.get_owned_pages
        pages = self.select_list(request, pagenames)

    def select_visited_pages(self, request):
        pages = self.get_visited_pages
        return Page.select_list(request, pages)