local modified={};
local sessions = {
  "i6F5ciuiIFFF4F37D57BxZW7", 
  "MQyDG5qBhqEd3R3jPQd7uRyW"
}

for i,k in ipairs(KEYS) do
    local val = redis.call('GET', k);
    if type(val) == "string" then
      for j=1, #sessions do
          local f = string.find(val, sessions[j])
          if f ~= nil then
              modified[#modified + 1] = k
              redis.call('EXPIRE', k, 1)
          end
      end
    end
end

return modified;
