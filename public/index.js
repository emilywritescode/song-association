window.onload = function(){
    var howtoplay = document.getElementById("how-to-play-selection");
    var howtoplay_box = document.getElementById("how-to-play-box");
    var close = document.getElementById("close_howtoplay");

    howtoplay.onclick = function() {
        howtoplay_box.classList.remove("hidden");
    }

    close_howtoplay.onclick = function() {
        howtoplay_box.classList.add("hidden");
    }

    var credits = document.getElementById("credits-selection");
    var credits_box = document.getElementById("credits-box");
    var close = document.getElementById("close-credits");

    credits.onclick = function() {
        credits_box.classList.remove("hidden");
    }

    close_credits.onclick = function() {
        credits_box.classList.add("hidden");
    }
}
