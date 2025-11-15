(function(){
    const params = new URLSearchParams(window.location.search);
    const redirectUrl = params.get("redirect") || "";
    if(redirectUrl){
        window.location.href = redirectUrl;
    } else {
        console.log("[hook.js] No redirect URL provided.");
    }
})();
