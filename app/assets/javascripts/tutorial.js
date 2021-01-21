$(function() {
  $('#tutorial').click(function() {
    introJs()
      .setOptions({
        nextLabel: '次 →',
        prevLabel: '← 前',
        skipLabel: 'スキップ',
        doneLabel: '終了',
        exitOnOverlayClick: false,
        showStepNumbers: false,
        steps: [
          {
            intro:
              '<b>TaBi Shareへようこそ！</b><br>簡単にTaBi Shareの使い方をご紹介します！',
          },
          {
            element: '#introjs-step1',
            intro: 'キーワード検索をすることが出来ます。',
          },
          {
            element: '#introjs-step2',
            intro: 'ジャンルから絞り込むことが出来ます。',
          },
          {
            element: '#introjs-step3',
            intro: '利用シーンから絞り込むことが出来ます。',
          },
          {
            element: '#introjs-step4',
            intro: '都道府県から絞り込むことが出来ます。',
          },
          {
            element: '#introjs-step5',
            intro: '現在地から周辺スポットを探すことが出来ます。',
          },
          {
            element: '#introjs-step6',
            intro: '観光スポット登録ははこちらから行えます。',
          },
        ],
      })
      .start();
  });
});

