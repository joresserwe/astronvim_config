local M = {}

-- 색상 변경 (refer: loctvl842/monokai-pro.nvim)

local function hex_to_rgb(hex)
  hex = string.lower(hex)
  return {
    r = tonumber(hex:sub(2, 3), 16),
    g = tonumber(hex:sub(4, 5), 16),
    b = tonumber(hex:sub(6, 7), 16),
  }
end

local function rgb_to_hex(rgb)
  local red = string.format("%02x", rgb.r)
  local green = string.format("%02x", rgb.g)
  local blue = string.format("%02x", rgb.b)
  return "#" .. red .. green .. blue
end

M.rgba = function(red, green, blue, alpha, base)
  local base_rgb = hex_to_rgb(base)

  red = (1 - alpha) * base_rgb.r + alpha * red
  green = (1 - alpha) * base_rgb.g + alpha * green
  blue = (1 - alpha) * base_rgb.b + alpha * blue

  return rgb_to_hex { r = red, g = green, b = blue }
end

-- alpha가 클수록 hexColor에 가까워 진다
M.blend = function(hexColor, alpha, base)
  local rgb = hex_to_rgb(hexColor)
  return M.rgba(rgb.r, rgb.g, rgb.b, alpha, base)
end

M.extend_hex = function(hexColor, base)
  local hex6 = string.sub(hexColor, 1, 7)
  local alpha = tonumber(string.sub(hexColor, 8, 9), 16) / 255
  return M.blend(hex6, alpha, base)
end

return M
