window.onload = function(){
    var howtoplay = document.getElementById("how-to-play-selection");
    var modal = document.getElementById("how-to-play-box");
    var close = document.getElementById("close");

    howtoplay.onclick = function() {
        modal.classList.remove("hidden");
    }

    close.onclick = function() {
        modal.classList.add("hidden");
    }
}
