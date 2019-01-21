<%inherit file="layout.mako"/>

<h1>${title}</h1>

<div class='container-fluid'>
	<div class='row'>
		<div class='col-8'>
			<div id="viewport"style="width:100%; height: 0; padding-bottom: 100%;"></div>
		</div>
		<div class='col-4'>
            <div class="card">
                <div class="card-body">
                    <h3>Description</h3>
                    <div class="float-right"><button type="button" class="btn btn-primary" id="edit_btn" data-target="#edit_modal" data-toggle="modal"><i class="far fa-edit"></i></button></div>
                        <p>${description}</p>
                        <hr/>
                        <button type="button" class="btn btn-success" id="save"><i class="far fa-camera"></i></button> Save image</div>
                        <hr/>
                        <p>Credits.</p>
                    </div>
                </div>
        </div>
    </div>
</div>

<div class="modal fade" tabindex="-1" role="dialog" id="edit_modal">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title"><i class="far fa-pen-alt"></i> Edit</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <div class="input-group mb-3">
          <div class="input-group-prepend">
            <span class="input-group-text" id="title-addon1">Title</span>
          </div>
          <input type="text" class="form-control" value="${title}" aria-label="Title" aria-describedby="title-addon1" id="edit_title">
        </div>
          <div class="input-group mb-3">
              <div class="input-group-prepend">
                <span class="input-group-text">Description</span>
              </div>
              <textarea class="form-control" aria-label="With textarea" value="${description}" id="edit_description"></textarea>
            </div>
        <div class="modal-footer">
        <button type="button" class="btn btn-primary" id="edit_submit">Save changes</button>
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Discard</button>
      </div>
    </div>
  </div>
</div>
    </div>


<%block name='script'>
<script type="text/javascript" id="code">
${code}
$( document ).ready(function () {
    $('#save').click(function () {
       stage.makeImage( {trim: true, antialias: true, transparent: false }).then(function (img) {window.img=img; NGL.download(img);});
    });
    $('#edit_submit').click(function () {
        $.ajax({
            url: "/edit_user-page",
            type: 'POST',
            dataType: 'json',
            data: {
                'title': $('#edit_title').val(),
                'description': $('#edit_description').val(),
                'code': $('#code').html(),  //in future I will make an edit code modal.
                'page': $(location).attr("href").split('/').pop().split('.')[0]  //just in case someone wants to API it...
            },
            success: function(result) {location.reload();}

        });
    });



});
</script>
</%block>
