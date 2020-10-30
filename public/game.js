function countdown (time, update, done) {
    var start = new Date().getTime();
    var interval = setInterval(function() {
        var now = time-(new Date().getTime()-start);
        if (now <= 0) {
            clearInterval(interval);
            done();
        }
        else update(Math.ceil(now/1000));
    }, 100); // the smaller this number, the more accurate the timer will be
}

//
// countdown (
//     25000, // milliseconds
//     function (seconds_left) {  // update
//         document.getElementById('timer').innerHTML = seconds_left;
//     },
//     function () {  // timer done, automatically skip
//        document.getElementById("skip").click()
//     }
// );


function rejectEnterKey(elem) {
    if (event.keyCode==13) {
        if (elem.value.trim()) {
            console.log(elem.value);
            var req = new XMLHttpRequest();
            req.open("POST", "/search")
            req.send(elem.value.trim())
        }
        event.preventDefault();
        return false;
    }
}
