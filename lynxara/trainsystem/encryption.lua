local Encryption = {}

Encryption.Encrypt = function(text, key)
    local encrypted = ""
    for i = 1, string.len(text) do
        local char = string.byte(text, i)
        encrypted = encrypted .. string.char(char + key[i % #key])
    end
    return encrypted
end

Encryption.Decrypt = function(text, key)
    local decrypted = ""
    for i = 1, string.len(text) do
        local char = string.byte(text, i)
        decrypted = decrypted .. string.char(char - key[i % #key])
    end
    return decrypted
end

return Encryption