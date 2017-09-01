local modified={};

for i,k in ipairs(KEYS) do
    local val = redis.call('GET', k);
    if type(val) == "string" then
          local f = string.find(val, "error_message")
          if f ~= nil then
              modified[#modified + 1] = k
              redis.call('EXPIRE', k, 1)
          end
    end
end

return modified;
