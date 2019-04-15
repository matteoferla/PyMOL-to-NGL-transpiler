<!DOCTYPE html>
<html lang="en">
<%page args="bootstrap='4', remote=False, no_user=False, public=True, confidential=False, no_analytics=False"/>

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="Michelanglo, a simple way to create NGL views for webpages and for sharing">
    <meta name="author" content="Matteo Ferla">
    <link rel="icon" href="/static/NGL.png">
    %if not public:
        <meta name="robots" content="none">
    %endif

    <title>Michelanglo</title>
    % if bootstrap == 'materials':
        <link href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.3.1/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/mdbootstrap/4.7.6/css/mdb.min.css" rel="stylesheet">
    % else:
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
    % endif

    <!-- Custom styles for this scaffold -->
    <link href="/static/theme.css" rel="stylesheet">
    <!--<link rel="stylesheet" href="https://pro.fontawesome.com/releases/v5.6.3/css/all.css" integrity="sha384-LRlmVvLKVApDVGuspQFnRQJjkv0P7/YFrw84YYQtmYG4nK8c+M+NlmYDCv0rKWpG" crossorigin="anonymous">-->
    <link rel="stylesheet" href="https://www.matteoferla.com/Font-Awesome-Pro/css/all.min.css" crossorigin="anonymous">
    <link rel="stylesheet" href="https://www.matteoferla.com/bootstrap-tourist/bootstrap-tourist.css">
    <style>

.footer {
    position: absolute;
    bottom: 0;
    width: 100%;
    /* Set the fixed height of the footer here */
    height: 60px;
    line-height: 60px; /* Vertically center the text there */
    background-color: #f5f5f5;
}

html {
    position: relative;
    min-height: 100%;
    overflow-y:scroll;
}

body {
  /* Margin bottom by footer height */
    margin-bottom: 60px;
}

main {
    /* bg image*/
  /* Use "linear-gradient" to add a darken background effect to the image (photographer.jpg). This will make the text easier to read */
  background-image: linear-gradient(rgba(255, 255, 255, 0.9), rgba(255, 255, 255, 0.9)), url('/static/background_blur.png');

  /* Set a specific height */
  height: 50%;

  /* Position and center the image to scale nicely on all screens */
  background-position: center;
  background-repeat: no-repeat;
  background-size: cover;
  position: relative;
}

pre {

    background:gainsboro;
    color: darkslategrey;
    font-family: monospace;
}

.custom-file-label:after {
    color: #fff;
    background-color: #1e7e34;
    border-color: #1c7430;
    pointer: cursor;
}

.popover{
    max-width: 90vw; /* Max Width of the popover (depending on the container!) */
}

.protein {
    width:100%;
    height: 0;
    padding-bottom: 100%;
}

.prolink {
	color: mediumseagreen;
}

.prolink:hover {
	color: seagreen;
	cursor: pointer;
	text-decoration: underline;
}

.clipboard {
    color: orchid;
}

.clipboard:hover {
    color: darkorchid;
	cursor: pointer;
	text-decoration: underline;
}

.confidential-ribbon{
  z-index: 1050;
  width: 200px;
  background: #e43;
  position: fixed;
  top: 25px;
  left: -50px;
  text-align: center;
  line-height: 50px;
  letter-spacing: 1px;
  color: #f0f0f0;
  transform: rotate(-45deg);
  -webkit-transform: rotate(-45deg);
  box-shadow: 0 0 3px rgba(0,0,0,.3);
}



    </style>

    <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
      <script src="//oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
      <script src="//oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>
    <![endif]-->
</head>
<body>
%if confidential:
    <div class="confidential-ribbon shadow"><i class="far fa-user-secret"></i> Confidential</div>
%endif
<div class="position-absolute w-100 d-flex flex-column p-4" id="toaster">
</div>

<main role='main' class="container-fluid p-0 w-100 mx-0">
    ${ next.body() }
</main>

<footer class="footer">
      <div class="container">
          <span class="text-muted"><small><a href="https://www.schrodinger.com/" target="_blank">PyMOL <i class="far fa-external-link-square"></i></a> is a trademark of <a href="https://pymol.org/2/" target="_blank">Schr&ouml;dinger , LLC <i class="far fa-external-link-square"></i></a>. The authors are not affiliated or involved in any way with PyMOL or Schr&ouml;dinger. Data is not kept for commercial or analytic purposes.</small></span>
      </div>
    </footer>


<!-- Bootstrap core JavaScript
================================================== -->
<!-- Placed at the end of the document so the pages load faster -->
<script src="https://code.jquery.com/jquery-3.3.1.min.js" integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8=" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
% if bootstrap == 'materials':
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/mdbootstrap/4.7.6/js/mdb.min.js"></script>
% endif
<script src="https://unpkg.com/ngl@2.0.0-dev.34/dist/ngl.js" type="text/javascript"></script>
% if not remote:
    <script type="text/javascript" src="/static/ngl.extended.js"></script>
% else:
    <script type="text/javascript" src="https://www.matteoferla.com/ngl.extended.js"></script>
% endif
<script src="https://cdnjs.cloudflare.com/ajax/libs/clipboard.js/2.0.0/clipboard.min.js"></script>

<script src="https://www.matteoferla.com/bootstrap-tourist/bootstrap-tourist.js"></script>
<%block name="script"/>
% if not no_user:
    <%include file="login/user_modal.mako"/>
% endif

<script type="text/javascript">
    $('[data-toggle="popover"]').popover();
    $('[data-toggle="tooltip"]').tooltip();
    $('#menu').on('shown.bs.popover', function () {
        $('.popover a').hover(function () {$('.popover-header').html($(this).attr('title'))});
    });
% if not no_user:
    <%include file="login/user_icon_bar.js"/>
    <%include file="login/user_modal.js"/>
    <%include file="toast.js"/>
% endif
</script>

% if not no_analytics:
<!-- Global site tag (gtag.js) - Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=UA-66652240-5"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'UA-66652240-5');
</script>
% endif


</body>
</html>