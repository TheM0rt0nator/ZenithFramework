local ReplicatedStorage = game:GetService("ReplicatedStorage")

local loadModule = table.unpack(require(ReplicatedStorage.ZenithFramework))

return function()
	local RoduxStore = loadModule("RoduxStore")
	local Table = loadModule("Table")
	local Chess = loadModule("Chess")

	local playerId = 1

    describe("playerData Reducer", function()
		it("should set a player session in the playerData table in Rodux", function()
			local setPlayerSession = loadModule("setPlayerSession")
			local data = {}
			expect(function()
				RoduxStore:dispatch(setPlayerSession(playerId, data))
			end).never.to.throw()
			expect(RoduxStore:getState().playerData[tostring(playerId)]).to.equal(data)
		end)

		it("should set an index in the players data to a given value", function()
			local setPlayerData = loadModule("setPlayerData")
			expect(function()
				RoduxStore:dispatch(setPlayerData(playerId, "Level", 2))
			end).never.to.throw()
			expect(RoduxStore:getState().playerData[tostring(playerId)].Level).to.equal(2)
		end)

		it("should add an inventory item to an inventory table in the players data", function()
			local addInventoryItem = loadModule("addInventoryItem")

			local newItem = {
				name = "Hammer";
				Level = 1;
			}

			expect(function()
				RoduxStore:dispatch(addInventoryItem(playerId, "TestInventory", "Tools", newItem))
			end).never.to.throw()
			expect(RoduxStore:getState().playerData[tostring(playerId)].TestInventory.Tools).to.be.ok()
			expect(Table.contains(RoduxStore:getState().playerData[tostring(playerId)].TestInventory.Tools, newItem)).to.be.ok()
		end)

		it("should change an inventory item in an inventory table in the players data", function()
			local changeInventoryItem = loadModule("changeInventoryItem")

			local itemToChange = {
				name = "Hammer";
				Level = 1;
			}
			local newItem = {
				name = "Hammer";
				Level = 2;
			}
			expect(function()
				RoduxStore:dispatch(changeInventoryItem(playerId, "TestInventory", "Tools", itemToChange, newItem))
			end).never.to.throw()
			expect(Table.contains(RoduxStore:getState().playerData[tostring(playerId)].TestInventory.Tools, newItem)).to.be.ok()
		end)
	end)

	describe("chessState Reducer", function()
		it("should set a chess game to the given data table, with an index of a combination of the two IDs", function()
			local setChessGame = loadModule("setChessGame")

			local chess = Chess.new()
			local data = {
				state = chess.state;
				move = 0;
				p1Col = 1;
			}

			expect(function()
				RoduxStore:dispatch(setChessGame(1, 2, data))
			end).never.to.throw()
			expect(RoduxStore:getState().chessState["1,2"]).to.be.ok()
			expect(RoduxStore:getState().chessState["1,2"].move).to.equal(0)
		end)
	end)
end