/// Loads the feature viewer.
// <%text>

////////////////////////////////// MAke buttons

const add_uniprot = () => {
    if (myData.proteins[0].chain_definitions !== undefined) {
        let chains = myData.proteins[0].chain_definitions
                                .filter(d => d.uniprot !== undefined);
        chains.map(({name, chain, uniprot}) => `<button type="button" class="btn btn-outline-info w-100" onclick="show_uniprot('${uniprot}','${chain}')"><i class="far fa-align-center"></i> ${name} (chain ${chain}, ${uniprot})</button>`)
              .forEach(el => $('#uniprot_btns').append(el));
        chains.map(({name, chain, uniprot}) => `<div class="modal fade" id="${uniprot}_modal" tabindex="-1" role="dialog" aria-hidden="true">
                                                  <div class="modal-dialog modal-lg modal-dialog-centered" role="document">
                                                    <div class="modal-content">
                                                      <div class="modal-header">
                                                        <h5 class="modal-title" id="exampleModalLongTitle">${uniprot} &mdash; ${name}</h5>
                                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                                          <span aria-hidden="true">&times;</span>
                                                        </button>
                                                      </div>
                                                      <div class="modal-body">
                                                        <div id="fv_${uniprot}"></div>
                                                      </div>
                                                    </div>
                                                  </div>
                                                </div>`)
            .forEach(el => $('body').append($(el)));

        $('body').append('<link rel="stylesheet" href="/static/feature.css" async>',
                         '<script src="https://cdnjs.cloudflare.com/ajax/libs/d3/3.5.17/d3.js"><\/script>',
                         '<script src="https://cdn.rawgit.com/calipho-sib/feature-viewer/v1.0.0/dist/feature-viewer.min.js" async><\/script>');


    }
};
add_uniprot();


////////////////////////////////// Loading triggered
window.UniprotData = {};
window.show_uniprot = (uniprotValue, chain) => {
    const loadFV = (uniprotValue) => {$('#fv_'+uniprotValue).html('');
                                        $('#fv_'+uniprotValue).off();
                                        m.off('shown.bs.modal');
                                        m.on('shown.bs.modal', e => eval(UniprotData[uniprotValue]));
                                        setTimeout((uniprotValue) => {
                                            $('.domain').css('cursor','pointer');
                                            $('.domain').click(function (event) {
                                                //fnucleotidephosphatebindingregion_116_119
                                                let p = $(this).attr('id').split('_');
                                                let sele = p[1]+'-'+p[2]+':'+myData.currentChain;
                                                if (NGL.specialOps.isValid('viewport',sele)) {
                                                    NGL.specialOps.showDomain('viewport', sele);
                                                    $(`#${uniprotValue}_modal`).modal('hide');
                                                } else {
                                                    ops.addToast('outer','Selection out of bounds', 'Unfortunately the structure does not conver that', 'bg-warning');
                                                }
                                            });
                                            $('.modified').css('cursor','pointer');
                                            $('.modified').click(function (event) {
                                                //fnucleotidephosphatebindingregion_116_119
                                                let p = $(this).attr('id').split('_');
                                                let sele = p[1]+':'+myData.currentChain;
                                                if (NGL.specialOps.isValid('viewport',sele)) {
                                                    NGL.specialOps.showResidue('viewport', sele);
                                                    $(`#${uniprotValue}_modal`).modal('hide');
                                                } else {
                                                    ops.addToast('outer','Selection out of bounds', 'Unfortunately the structure does not conver that', 'bg-warning');
                                                }
                                            });

                                        },1000, uniprotValue);
    };
    myData.currentChain = chain;
    const m = $(`#${uniprotValue}_modal`);
    m.modal('show');
    if (UniprotData[uniprotValue] === undefined) {
        $.post({
            url: "/choose_pdb",
            data: {
                'item': 'get_uniprot',
                'uniprot': uniprotValue,
                'fv': '#fv_'+uniprotValue,
                'no_pdb': true
            },
            success: msg => {UniprotData[uniprotValue] = msg;
                            loadFV(uniprotValue);
                            },
            error: ops.addErrorToast
        });
    }
    else {
        loadFV(uniprotValue);
    }
};

// </%text>