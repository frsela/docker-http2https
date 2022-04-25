local ngx_re = require "ngx.re"
local res, err = ngx_re.split(ngx.var.arg_host, "/", nil, nil, 2)
ngx.var.targetHost = res[1]
ngx.var.targetPath = res[2]

local args = ngx.req.get_uri_args()
args.host = nil
ngx.req.set_uri_args(args)

local resolver = require "resty.dns.resolver"
local r, err = resolver:new{
            nameservers = {"8.8.8.8", {"8.8.4.4", 53} },
            retrans = 5,  -- 5 retransmissions on receive timeout
            timeout = 2000,  -- 2 sec
}

if not r then
            ngx.say("failed to instantiate the resolver: ", err)
            return
end

local answers, err, tries = r:query(ngx.var.targetHost, nil, {})
if not answers then
            ngx.say("failed to query the DNS server: ", err)
            ngx.say("retry history:\n  ", table.concat(tries, "\n  "))
            return
end

if answers.errcode then
            ngx.status = 400
            ngx.say("server returned error code: ", answers.errcode, ": ", answers.errstr)
end

for i, ans in ipairs(answers) do
            ngx.log(ngx.ERR, "[DEBUG] DNS Answer ", ans.address)
            ngx.var.targetIP = ans.address
end
