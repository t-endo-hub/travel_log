

  // ジャンルセレクトボックスのオプションを作成
  function appendOption(genre) {
    var html = `<option value='${genre.id}' data-genre='${genre.id}'>${genre.name}</option>`;
    return html;
  }

  // 子ジャンルの表示作成
  function appendChidrenBox(insertHTML) {
    var childSelectHtml = '';
    childSelectHtml = `<div id='children_wrapper'>
                        <select id='child_genre' class='form-control' name='[children_id]'>
                          <option value='---' data-genre='---'>---</option>
                          ${insertHTML}
                        </select>
                        <i class='fas fa-chevron-down'></i>
                      </div>`;
    $('.genre-form').append(childSelectHtml);
  }

  // 孫ジャンルの表示作成
  function appendGrandchidrenBox(insertHTML) {
    var grandchildSelectHtml = '';
    grandchildSelectHtml = `<div id='grandchildren_wrapper'>
                              <select id='grandchild_genre' class='form-control' name='[grandchildren_id]'>
                                <option value='---' data-genre='---'>---</option>
                                ${insertHTML}
                              </select>
                              <i class='fas fa-chevron-down'></i>
                            </div>`;
    $('.genre-form').append(grandchildSelectHtml);
  }

  // 親ジャンル選択後のイベント
  $('#parent-genre').on('change', function() {
    var parentGenre = document.getElementById('parent-genre').value; // 選択された親ジャンルの名前を取得
    if (parentGenre != '---') {
      // 親ジャンルが初期値でないことを確認
      $.ajax({
        url: '/user/get_genre/children',
        type: 'GET',
        data: {
          parent_id: parentGenre,
        },
        dataType: 'json',
      })
        .done(function(children) {
          $('#children_wrapper').remove(); // 親が変更された時、子以下を初期値にする
          $('#grandchildren_wrapper').remove();
          var insertHTML = '';
          children.forEach(function(child) {
            insertHTML += appendOption(child);
          });
          console.log(insertHTML);
          appendChidrenBox(insertHTML);
        })
        .fail(function() {
          alert('ジャンル取得に失敗しました');
        });
    } else {
      $('#children_wrapper').remove(); // 親ジャンルが初期値になった時、子以下を削除
      $('#grandchildren_wrapper').remove();
    }
  });

  // 子ジャンル選択後のイベント
  $('.genre-form').on('change', '#child_genre', function() {
    var childId = $('#child_genre option:selected').data('genre'); // 選択された子ジャンルのidを取得
    if (childId != '---') {
      // 子ジャンルが初期値でないことを確認
      $.ajax({
        url: '/user/get_genre/grandchildren',
        type: 'GET',
        data: {
          child_id: childId,
        },
        dataType: 'json',
      })
        .done(function(grandchildren) {
          if (grandchildren.length != 0) {
            $('#grandchildren_wrapper').remove(); // 子が変更された時、孫以下を初期値にする
            var insertHTML = '';
            grandchildren.forEach(function(grandchild) {
              insertHTML += appendOption(grandchild);
            });
            appendGrandchidrenBox(insertHTML);
          }
        })
        .fail(function() {
          alert('ジャンル取得に失敗しました');
        });
    } else {
      $('#grandchildren_wrapper').remove(); // 子ジャンルが初期値になった時、孫以下を削除
    }
  });
