from pyramid.view import view_config, notfound_view_config
from pyramid.renderers import render_to_response
import os
from pyramid.response import FileResponse
password='protein'

if os.path.isdir(os.path.join('pymol_ngl_transpiler_app','temp')):
    for file in os.listdir(os.path.join('pymol_ngl_transpiler_app','temp')):
        os.remove(os.path.join('pymol_ngl_transpiler_app','temp',file))
else:
    os.mkdir(os.path.join('pymol_ngl_transpiler_app','temp'))

@notfound_view_config(renderer="../templates/404.mako")
@view_config(route_name='admin', renderer='../templates/admin.mako', http_cache=0)
@view_config(route_name='clash', renderer="../templates/clash.mako")
@view_config(route_name='custom', renderer="../templates/custom.mako")
@view_config(route_name='home', renderer="../templates/welcome.mako")
@view_config(route_name='pymol', renderer="../templates/main.mako")
@view_config(route_name='docs', renderer="../templates/docs.mako")
@view_config(route_name='sandbox', renderer="../templates/sandbox.mako")
@view_config(route_name='imagetoggle', renderer="../templates/image.mako")
@view_config(route_name='pdb', renderer="../templates/pdb.mako")
def my_view(request):
    user = request.user
    return {'project': 'Michalanglo',
            'user': user}


@view_config(route_name='markup', renderer="../templates/markup.mako")
def markup_view(request):
    settings = {'project': 'Michelanglo', 'user': request.user} #useless for now.
    if request.GET and 'version' in request.GET and request.GET['version'] == 'old':
        return render_to_response("../templates/markup_old.mako",settings, request)
    return settings

from ..pages import Page

@view_config(route_name='userdata', renderer="../templates/user_protein.mako")
def userdata_view(request):
    pagename = request.matchdict['id']
    page = Page(pagename)
    settings = page.load()
    settings['user'] = request.user
    user = request.user
    if user:
        if user.role == 'admin':
            settings['editable'] = True
        elif pagename in user.get_owned_pages():
            settings['editable'] = True
        elif pagename in user.get_visited_pages():
            settings['editable'] = False
        else:
            user.add_visited_page(pagename)
            request.dbsession.add(user)
            settings['visitors'].append(user.name)
            page.save()
            settings['editable'] = False
            print(user.visited_pages)
    else:
        settings['editable'] = False
    return settings




@view_config(route_name='save_pdb')
def save_pdb(request):
    filename=request.session['file']
    raise NotImplementedError
    return FileResponse(filename, content_disposition='attachment; filename="{}"'.format(request.POST['name']))

@view_config(route_name='save_zip')
def save_zip(request):
    raise NotImplementedError
