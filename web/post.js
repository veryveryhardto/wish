
(function loadDaumPost() {
  var s = document.createElement('script');
  s.src = '//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js';
  s.async = true;
  document.head.appendChild(s);
})();
function execDaumPostcode() {
  new daum.Postcode({
     onclose: function(data) {
        window.flutter_inappwebview.callHandler('onSelectAddress', data);
                       var roadAddr = data.roadAddress; // 도로명 주소 변수
                       var extraRoadAddr = ''; // 참고 항목 변수

                       // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                       // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                       if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                           extraRoadAddr += data.bname;
                       }
                       // 건물명이 있고, 공동주택일 경우 추가한다.
                       if(data.buildingName !== '' && data.apartment === 'Y'){
                          extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                       }
                       // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                       if(extraRoadAddr !== ''){
                           extraRoadAddr = ' (' + extraRoadAddr + ')';
                       }


                       document.getElementById('sample4_postcode').value = data.zonecode;
                       document.getElementById("sample4_roadAddress").value = roadAddr;
                       document.getElementById("sample4_jibunAddress").value = data.jibunAddress;

                       return data;
                   }
  }).open();
}