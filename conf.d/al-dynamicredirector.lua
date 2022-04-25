local balancer = require "ngx.balancer"

local host = ngx.var.targetIP
local port = 443

ngx.log(ngx.ERR, "[DEBUG] Redirecting to ", host)

local ok, err = balancer.set_current_peer(host, port)
if not ok then
            ngx.log(ngx.ERR, "Failed to set the peer: ", err)
end
