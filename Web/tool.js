function $(selecter){
    let dom = document.querySelectorAll(selecter);
    return dom.length == 1?dom[0]:dom;
}
function Ajax({method = "POST", async = true, data = null, type = "json", url = "",
    ontimeout = e => { }, onprogress = e => { }, onuprogress = e => { } }={}) {
    return new Promise((resolve, reject) => {
        let dataType = type;
        let rspType;
        switch (type) {
            case "image":
            case "video":
                rspType = "blob"; method = "GET";
                break;
            case "config":
                rspType = "json"; method = "GET";
                break;
            case "script":
                rspType = "text"; method = "GET";
                break;
            default:
                rspType = type;
                break;
        }

        let xhr = new XMLHttpRequest();
        xhr.open(method, url, async);
        if (async) xhr.responseType = rspType;//异步时配置请求类型
        xhr.setRequestHeader("Content-type", "application/x-www-four-urlencoded;charset=UTF-8");
        xhr.onload = function (e) {
            if (this.status == 404) return reject(this);
            if (this.status == 200 || this.status == 304) {
                let rsp = this.response;
                if (!async && type == "json")
                    rsp = JSON.parse(rsp);
                else if (dataType == "image") {
                    rsp = new Image();
                    rsp.src = window.URL.createObjectURL(this.response);
                    rsp.onload = e => window.URL.revokeObjectURL(rsp.src);
                } else if (dataType == "video") {
                    rsp = document.createElement("video");
                    rsp.src = window.URL.createObjectURL(this.response);
                    rsp.onload = e => window.URL.revokeObjectURL(rsp.src);
                } else if (dataType == "script") {
                    let sblock = document.createElement("script");
                    sblock.textContent = rsp;
                    document.body.appendChild(sblock);
                }
                resolve(rsp);
            }
        };
        xhr.ontimeout = ontimeout;
        xhr.onerror = reject;
        xhr.upload.onprogress = onuprogress;
        xhr.onprogress = (e) => onprogress.call(this, e.total, e.loaded);

        xhr.send(data);
    });
}