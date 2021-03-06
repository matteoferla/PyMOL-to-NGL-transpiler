<div class="float-right d-flex flex-row">
    #### filled by JS in layout.mako
    <span id="user" class="my-2 mr-3"></span>
<div class="d-flex flex-column" style="width: 42px;">
    <button class="btn btn-outline-secondary my-1 d-none d-lg-block" type="button"
            title="Menu"
            id="menu"
            data-container="body"
            data-toggle="popover"
            data-placement="left"
            data-trigger="focus"
            data-html="true"
            data-content='<div class="list-group list-group-flush">
                            <%
                            menu_opts = (('Home','/','far fa-home'),
                               ('Your pages','/personal','far fa-unlock'),
                               ('Convert PyMol file','/pymol','far fa-hammer'),
                               ('Convert PDB file','/pdb','far fa-wrench'),
                               ('Name to PDB', '/name', 'far fa-id-badge'),
                               ('VENUS', '/venus', 'far fa-radar'),
                               ('Convert custom mesh','/custom','far fa-mortar-pestle'),
                               ('Primary documentation','/docs','far fa-books'),
                               ('Gallery','/gallery','far fa-palette'),
                               ('Github repository','https://github.com/matteoferla/PyMOL-to-NGL-transpiler','fab fa-github')
                               )
                            %>
                            %for txt, link, ico in menu_opts:
                                %if (link and current_page and current_page in link) or (current_page == 'home' and link == '/'):
                                        <a role="button" class="list-group-item list-group-item-dark"><i class="${ico}"></i> ${txt}</a>
                                %else:
                                        <a role="button" class="list-group-item list-group-item-action" href="${link}"><i class="${ico}"></i> ${txt}</a>
                                %endif
                            %endfor
                            </div>
                         '>
        <i class="far fa-bars"></i></button>
    <button class="btn btn-outline-secondary my-1 d-lg-none d-block" type="button" data-toggle="modal" data-target="#menu_modal">
        <i class="far fa-bars"></i></button>
    <button class="btn btn-outline-secondary my-1" type="button" data-toggle="modal" data-target="#chat_modal" id="chat_modal_btn">
        <i class="far fa-comments"></i>
    </button>
</div>
</div>
#### title toggling is in layout.mako
<%include file="chat.mako"/>


<div class="modal" tabindex="-1" role="dialog" id="menu_modal">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">Menu</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <div class="list-group list-group-flush">
                <%
                menu_opts = (('Home','/','far fa-home'),
                   ('Convert PyMol file','/pymol','far fa-hammer'),
                   ('Convert PDB file','/pdb','far fa-wrench'),
                   ('Name to PDB', '/name', 'far fa-id-badge'),
                   ('Convert custom mesh','/custom','far fa-mortar-pestle'),
                   ('Primary documentation','/docs','far fa-books'),
                   ('Gallery','/gallery','far fa-palette'),
                   ('Github repository','https://github.com/matteoferla/PyMOL-to-NGL-transpiler','fab fa-github')
                   )
                %>
                %for txt, link, ico in menu_opts:
                    %if (link and current_page and current_page in link) or (current_page == 'home' and link == '/'):
                            <a role="button" class="list-group-item list-group-item-dark"><i class="${ico}"></i> ${txt}</a>
                    %else:
                            <a role="button" class="list-group-item list-group-item-action" href="${link}"><i class="${ico}"></i> ${txt}</a>
                    %endif
                %endfor
                </div>
      </div>
    </div>
  </div>
</div>

