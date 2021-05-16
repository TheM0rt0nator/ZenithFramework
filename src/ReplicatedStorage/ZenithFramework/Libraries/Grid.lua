-- Creates a grid object with useful methods
-- Author: TheM0rt0nator

local Grid = {}
Grid.__index = Grid

-- Creates a new grid object
function Grid.new(w, h, cellRefType)
    assert(typeof(w) == "number" and typeof(h) == "number", "Width and height need to be of type number")

    local self = setmetatable({}, Grid)

    self.w = w
    self.h = h

    if cellRefType and cellRefType == "LetterNum" then
        self:CreateLetterNumCells()
    else
        self:CreateNumberedCells()
    end

    return self
end

-- Creates a table containing the numbered grid reference of each cell in a table {w, h} (e.g. {1, 1})
function Grid:CreateNumberedCells()
    self.numberedCells = {}

    for w = 1, self.w do
        for h = 1, self.h do
            table.insert(self.numberedCells, {w, h})
        end
    end
end

-- Creates a table containing the letter num grid reference of each cell in a table {w, h} (e.g. {a, 1})
function Grid:CreateLetterNumCells()
    self.letterNumCells = {}

    for w = 1, self.w do
        local letter = string.char(w + 96)
        for h = 1, self.h do
            table.insert(self.letterNumCells, {letter, h})
        end
    end
end

return Grid