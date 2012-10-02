if(typeof DEPLOYED === 'undefined') {
    OG.widgets_url = 'https://og-stage-widgets.s3.amazonaws.com';
    var require = function() {
        var rest, i, callback, path = arguments[0];
        var newScript = document.createElement("script");
        newScript.src = [OG.widgets_url, path].join('/');
        rest = [].slice.call(arguments, 1);
        if (rest.length > 0) {
            callback = require;
            for (i = 0; i < rest.length; i++) {
                callback = callback.bind(null, rest[i]);
            }
            newScript.onload = callback;
        }

        var oldScript = document.getElementsByTagName("script")[0];
        oldScript.parentNode.insertBefore(newScript, oldScript);
    };
}
