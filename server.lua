-------------------------
--- BadgerStockMarket ---
-------------------------

-- CODE --
--[[
CREATE TABLE IF NOT EXISTS user_stock_data (
	id INTEGER(11) AUTO_INCREMENT PRIMARY KEY, 
	identifier VARCHAR(50), 
	stockAbbrev VARCHAR(16),
	ownCount INTEGER(16)
);

CREATE TABLE IF NOT EXISTS stock_purchase_data (
	id INTEGER(11) AUTO_INCREMENT PRIMARY KEY,
	identifier VARCHAR(50),
	purchasedPrice INTEGER(32),
	stockAbbrev VARCHAR(16),
	isOwned BIT(1)
);
]]--
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent("BadgerStocks:Buy")
AddEventHandler("BadgerStocks:Buy", function(data, cb)
    -- This is the buy stock thing 
    local src = source;
    local xPlayer = ESX.GetPlayerFromId(src);
    local stockAbbrev = data.stock;
    local costPer = data.cost;
    if (xPlayer.getMoney() >= costPer) then 
        -- They can buy it 
        if (GetStockCount(src) < GetAllowedCount(src)) then 
            -- They can buy another one of it 
            BuyStock(src, stockAbbrev, 1, costPer);
            xPlayer.setMoney( (xPlayer.getMoney() - costPer) );
            --TriggerClientEvent("BadgerStocks:SendNotif", src, "<span class='buy'>SUCCESS: Purchased a Share of " .. stockAbbrev .. "</span>");
            TriggerClientEvent('esx:showAdvancedNotification', src, 'Mors Mutual,', 'Stock Purchase:', "You paid ~g~$"..ESX.Math.GroupDigits(costPer).."~s~ for ~y~One Share~s~ of ~r~"..stockAbbrev.."~s~.", 'CHAR_MP_MORS_MUTUAL', 9, false, true, 200);
            TriggerEvent("BadgerStocks:SetupDataID", src);
            --cb('ok');
        else 
            -- They already have the max number of stocks they are allowed 
            --TriggerClientEvent("BadgerStocks:SendNotif", src, "<span class='error'>ERROR: You already have the max number of stocks you " .. "are allowed to own...</span>");
            TriggerClientEvent('esx:showAdvancedNotification', src, 'Mors Mutual,', 'Account Restriction:', "You have reached the maxium amount equities allowed for your account. Consider upgrading today!", 'CHAR_MP_MORS_MUTUAL', 9, false, true, 200);
        end
    else
        TriggerClientEvent('esx:showAdvancedNotification', src, 'Mors Mutual,', 'Insufficient Funds:', "You lack $~g~"..ESX.Math.GroupDigits(costPer).."~s~ in ~r~Capital~s~ ~r~Requirements~s~ for this transaction.", 'CHAR_MP_MORS_MUTUAL', 9, false, true, 200); 
        -- They do not have enough money to afford this 
        --TriggerClientEvent("BadgerStocks:SendNotif", src, "<span class='error'>ERROR: You do not have enough money to afford this...</span>");
    end
end)
RegisterNetEvent("BadgerStocks:Sell")
AddEventHandler("BadgerStocks:Sell", function(data, cb)
    -- This is the sell stock thing 
    local src = source;
    local xPlayer = ESX.GetPlayerFromId(src);
    local stockAbbrev = data.stock;
    local costPer = data.cost;
    local currentHoldings = GetCurrentHolding(src, stockAbbrev);
    if HasStockOwned(src, stockAbbrev, 1) then 
        if currentHoldings >= 1 then 
             -- They own it, sell it 
            SellStock(src, stockAbbrev, 1, costPer);
            xPlayer.setMoney(xPlayer.getMoney() + costPer);
            --TriggerClientEvent("BadgerStocks:SendNotif", src, "<span class='sell'>SUCCESS: Sold a Share of " .. stockAbbrev .. "</span>");
            TriggerClientEvent('esx:showAdvancedNotification', src, 'Mors Mutual,', 'Stock Sale:', "You sold ~y~One Share~s~ of ~r~"..stockAbbrev.."~s~ for ~g~$"..ESX.Math.GroupDigits(costPer).."~s~.", 'CHAR_MP_MORS_MUTUAL', 9, false, true, 200);
            TriggerEvent("BadgerStocks:SetupDataID", src);
        else 
            TriggerClientEvent('esx:showAdvancedNotification', src, 'Mors Mutual,', 'Insufficient Equity:', "You do not have the ~r~Required Amount~s~ of ~g~Shares~s~ for this transaction.", 'CHAR_MP_MORS_MUTUAL', 9, false, true, 200); 
            -- They do not own this stock 
            --TriggerClientEvent("BadgerStocks:SendNotif", src, "<span class='error'>ERROR: You do not own Enough of this stock...</span>");
        end
    else 
        -- They do not own this stock 
        --TriggerClientEvent("BadgerStocks:SendNotif", src, "<span class='error'>ERROR: You do not own any of this stock...</span>");
        TriggerClientEvent('esx:showAdvancedNotification', src, 'Mors Mutual,', 'Insufficient Equity:', "You do not ~g~Own~s~ any ~y~Shares~s~ of ~r~"..stockAbbrev.."~s~.", 'CHAR_MP_MORS_MUTUAL', 9, false, true, 200);
    end 
end)

RegisterNetEvent("BadgerStocks:Buyx10")
AddEventHandler("BadgerStocks:Buyx10", function(data, cb)
    -- This is the buy stock thing 
    local src = source;
    local xPlayer = ESX.GetPlayerFromId(src);
    local stockAbbrev = data.stock;
    local costPer = data.cost;
    local transCost = costPer*10;
    if (xPlayer.getMoney() >= transCost) then 
        -- They can buy it 
        if (GetStockCount(src) < GetAllowedCount(src)) then 
            -- They can buy another one of it 
            BuyStock(src, stockAbbrev, 10, costPer);
            xPlayer.setMoney( (xPlayer.getMoney() - transCost) );
            --TriggerClientEvent("BadgerStocks:SendNotif", src, "<span class='buy'>SUCCESS: Purchased 10 Shares of " .. stockAbbrev .. "</span>");
            TriggerClientEvent('esx:showAdvancedNotification', src, 'Mors Mutual,', 'Stock Purchase:', "You paid ~g~$"..ESX.Math.GroupDigits(transCost).."~s~ for ~y~Ten Shares~s~ of ~r~"..stockAbbrev.."~s~ at ~g~$"..ESX.Math.GroupDigits(costPer).."~s~.", 'CHAR_MP_MORS_MUTUAL', 9, false, true, 200);
            TriggerEvent("BadgerStocks:SetupDataID", src);
            --cb('ok');
        else 
            -- They already have the max number of stocks they are allowed 
            --TriggerClientEvent("BadgerStocks:SendNotif", src, "<span class='error'>ERROR: You already have the max number of stocks you " .. "are allowed to own...</span>");
            TriggerClientEvent('esx:showAdvancedNotification', src, 'Mors Mutual,', 'Account Restriction:', "You have reached the maxium amount equities allowed for your account. Consider upgrading today!", 'CHAR_MP_MORS_MUTUAL', 9, false, true, 200);
        end
    else
        TriggerClientEvent('esx:showAdvancedNotification', src, 'Mors Mutual,', 'Insufficient Funds:', "You lack $~g~"..ESX.Math.GroupDigits(transCost).."~s~ in ~r~Capital~s~ ~r~Requirements~s~ for this transaction.", 'CHAR_MP_MORS_MUTUAL', 9, false, true, 200); 
        -- They do not have enough money to afford this 
        --TriggerClientEvent("BadgerStocks:SendNotif", src, "<span class='error'>ERROR: You do not have enough money to afford this...</span>");
    end
end)
RegisterNetEvent("BadgerStocks:Sellx10")
AddEventHandler("BadgerStocks:Sellx10", function(data, cb)
    -- This is the sell stock thing 
    local src = source;
    local xPlayer = ESX.GetPlayerFromId(src);
    local stockAbbrev = data.stock;
    local costPer = data.cost;
    local transCost = costPer*10;
    local currentHoldings = GetCurrentHolding(src, stockAbbrev);
    if HasStockOwned(src, stockAbbrev, 10) then 
        if currentHoldings >= 10 then 
             -- They own it, sell it 
            SellStock(src, stockAbbrev, 10, costPer);
            xPlayer.setMoney(xPlayer.getMoney() + transCost);
            --TriggerClientEvent("BadgerStocks:SendNotif", src, "<span class='sell'>SUCCESS: Sold 10 Shares of " .. stockAbbrev .. "</span>");
            TriggerClientEvent('esx:showAdvancedNotification', src, 'Mors Mutual,', 'Stock Sale:', "You sold ~y~Ten Shares~s~ of ~r~"..stockAbbrev.."~s~ at ~g~$"..ESX.Math.GroupDigits(costPer).."~s~ for ~g~$"..ESX.Math.GroupDigits(transCost).."~s~.", 'CHAR_MP_MORS_MUTUAL', 9, false, true, 200);
            TriggerEvent("BadgerStocks:SetupDataID", src);
        else 
            -- They do not own this stock 
            --TriggerClientEvent("BadgerStocks:SendNotif", src, "<span class='error'>ERROR: You do not own Enough of this stock...</span>");
            TriggerClientEvent('esx:showAdvancedNotification', src, 'Mors Mutual,', 'Insufficient Equity:', "You do not have the ~r~Required Amount~s~ of ~g~Shares~s~ for this transaction.", 'CHAR_MP_MORS_MUTUAL', 9, false, true, 200);
        end
    else 
        -- They do not own this stock 
        --TriggerClientEvent("BadgerStocks:SendNotif", src, "<span class='error'>ERROR: You do not own any of this stock...</span>");
        TriggerClientEvent('esx:showAdvancedNotification', src, 'Mors Mutual,', 'Insufficient Equity:', "You do not ~g~Own~s~ any ~y~Shares~s~ of ~r~"..stockAbbrev.."~s~.", 'CHAR_MP_MORS_MUTUAL', 9, false, true, 200);
    end 
end)

RegisterNetEvent("BadgerStocks:Buyx100")
AddEventHandler("BadgerStocks:Buyx100", function(data, cb)
    -- This is the buy stock thing 
    local src = source;
    local xPlayer = ESX.GetPlayerFromId(src);
    local stockAbbrev = data.stock;
    local costPer = data.cost;
    local transCost = costPer*100;
    if (xPlayer.getMoney() >= transCost) then 
        -- They can buy it 
        if (GetStockCount(src) < GetAllowedCount(src)) then 
            -- They can buy another one of it 
            BuyStock(src, stockAbbrev, 100, costPer);
            xPlayer.setMoney( (xPlayer.getMoney() - transCost) );
            --TriggerClientEvent("BadgerStocks:SendNotif", src, "<span class='buy'>SUCCESS: Purchased 100 Shares of " .. stockAbbrev .. "</span>");
            TriggerClientEvent('esx:showAdvancedNotification', src, 'Mors Mutual,', 'Stock Purchase:', "You paid ~g~$"..ESX.Math.GroupDigits(transCost).."~s~ for a ~y~Hundred Shares~s~ of ~r~"..stockAbbrev.."~s~ at ~g~$"..ESX.Math.GroupDigits(costPer).."~s~.", 'CHAR_MP_MORS_MUTUAL', 9, false, true, 200);
            TriggerEvent("BadgerStocks:SetupDataID", src);
            --cb('ok');
        else 
            -- They already have the max number of stocks they are allowed 
            --TriggerClientEvent("BadgerStocks:SendNotif", src, "<span class='error'>ERROR: You already have the max number of stocks you " .. "are allowed to own...</span>");
            TriggerClientEvent('esx:showAdvancedNotification', src, 'Mors Mutual,', 'Account Restriction:', "You have reached the maxium amount equities allowed for your account. Consider upgrading today!", 'CHAR_MP_MORS_MUTUAL', 9, false, true, 200);
        end
    else 
        TriggerClientEvent('esx:showAdvancedNotification', src, 'Mors Mutual,', 'Insufficient Funds:', "You lack $~g~"..ESX.Math.GroupDigits(transCost).."~s~ in ~r~Capital~s~ ~r~Requirements~s~ for this transaction.", 'CHAR_MP_MORS_MUTUAL', 9, false, true, 200);
        -- They do not have enough money to afford this 
        --TriggerClientEvent("BadgerStocks:SendNotif", src, "<span class='error'>ERROR: You do not have enough money to afford this...</span>");
    end
end)
RegisterNetEvent("BadgerStocks:Sellx100")
AddEventHandler("BadgerStocks:Sellx100", function(data, cb)
    -- This is the sell stock thing 
    local src = source;
    local xPlayer = ESX.GetPlayerFromId(src);
    local stockAbbrev = data.stock;
    local costPer = data.cost;
    local transCost = costPer*100;
    local currentHoldings = GetCurrentHolding(src, stockAbbrev)
    if HasStockOwned(src, stockAbbrev, 100) then 
        if currentHoldings >= 100 then 
        -- They own it, sell it 
            SellStock(src, stockAbbrev, 100, costPer);
            xPlayer.setMoney(xPlayer.getMoney() + transCost);
            --TriggerClientEvent("BadgerStocks:SendNotif", src, "<span class='sell'>SUCCESS: Sold 100 Shares of " .. stockAbbrev .. "</span>");
            TriggerClientEvent('esx:showAdvancedNotification', src, 'Mors Mutual,', 'Stock Sale:', "You sold a ~y~Hundred Shares~s~ of ~r~"..stockAbbrev.."~s~ at ~g~$"..ESX.Math.GroupDigits(costPer).."~s~ for ~g~$"..ESX.Math.GroupDigits(transCost).."~s~.", 'CHAR_MP_MORS_MUTUAL', 9, false, true, 200);
            TriggerEvent("BadgerStocks:SetupDataID", src);
            --cb('ok');
        else 
            -- They do not own this stock 
            --TriggerClientEvent("BadgerStocks:SendNotif", src, "<span class='error'>ERROR: You do not own Enough of this stock...</span>");
            TriggerClientEvent('esx:showAdvancedNotification', src, 'Mors Mutual,', 'Insufficient Equity:', "You do not have the ~r~Required Amount~s~ of ~g~Shares~s~ for this transaction.", 'CHAR_MP_MORS_MUTUAL', 9, false, true, 200);
        end
    else 
        -- They do not own this stock 
        --TriggerClientEvent("BadgerStocks:SendNotif", src, "<span class='error'>ERROR: You do not own any of this stock...</span>");
        TriggerClientEvent('esx:showAdvancedNotification', src, 'Mors Mutual,', 'Insufficient Equity:', "You do not ~g~Own~s~ any ~y~Shares~s~ of ~r~"..stockAbbrev.."~s~.", 'CHAR_MP_MORS_MUTUAL', 9, false, true, 200);
    end 
end)

RegisterNetEvent("BadgerStocks:Buyx1000")
AddEventHandler("BadgerStocks:Buyx1000", function(data, cb)
    -- This is the buy stock thing 
    local src = source;
    local xPlayer = ESX.GetPlayerFromId(src);
    local stockAbbrev = data.stock;
    local costPer = data.cost;
    local transCost = costPer*1000;
    if (xPlayer.getMoney() >= transCost) then 
        -- They can buy it 
        if (GetStockCount(src) < GetAllowedCount(src)) then 
            -- They can buy another one of it 
            BuyStock(src, stockAbbrev, 1000, costPer);
            xPlayer.setMoney( (xPlayer.getMoney() - transCost) );
            --TriggerClientEvent("BadgerStocks:SendNotif", src, "<span class='buy'>SUCCESS: Purchased 1000 Shares of " .. stockAbbrev .. "</span>");
            TriggerClientEvent('esx:showAdvancedNotification', src, 'Mors Mutual,', 'Stock Purchase:', "You paid ~g~$"..ESX.Math.GroupDigits(transCost).."~s~ for a ~y~Thousand Shares~s~ of ~r~"..stockAbbrev.."~s~ at ~g~$"..ESX.Math.GroupDigits(costPer).."~s~.", 'CHAR_MP_MORS_MUTUAL', 9, false, true, 200);
            TriggerEvent("BadgerStocks:SetupDataID", src);
            --cb('ok');
        else 
            -- They already have the max number of stocks they are allowed 
            --TriggerClientEvent("BadgerStocks:SendNotif", src, "<span class='error'>ERROR: You already have the max number of stocks you " .. "are allowed to own...</span>");
            TriggerClientEvent('esx:showAdvancedNotification', src, 'Mors Mutual,', 'Account Restriction:', "You have reached the maxium amount equities allowed for your account. Consider upgrading today!", 'CHAR_MP_MORS_MUTUAL', 9, false, true, 200);
        end
    else 
        TriggerClientEvent('esx:showAdvancedNotification', src, 'Mors Mutual,', 'Insufficient Funds:', "You lack $~g~"..ESX.Math.GroupDigits(transCost).."~s~ in ~r~Capital~s~ ~r~Requirements~s~ for this transaction.", 'CHAR_MP_MORS_MUTUAL', 9, false, true, 200);
        -- They do not have enough money to afford this 
        --TriggerClientEvent("BadgerStocks:SendNotif", src, "<span class='error'>ERROR: You do not have enough money to afford this...</span>");
    end
end)
RegisterNetEvent("BadgerStocks:Sellx1000")
AddEventHandler("BadgerStocks:Sellx1000", function(data, cb)
    -- This is the sell stock thing 
    local src = source;
    local xPlayer = ESX.GetPlayerFromId(src);
    local stockAbbrev = data.stock;
    local costPer = data.cost;
    local transCost = costPer*1000
    local currentHoldings = GetCurrentHolding(src, stockAbbrev)
    if HasStockOwned(src, stockAbbrev, 1000) then 
        if currentHoldings >= 1000 then
            -- They own it, sell it 
            SellStock(src, stockAbbrev, 1000, costPer);
            xPlayer.setMoney(xPlayer.getMoney() + transCost);
            --TriggerClientEvent("BadgerStocks:SendNotif", src, "<span class='sell'>SUCCESS: Sold 1000 Shares of " .. stockAbbrev .. "</span>");
            TriggerClientEvent('esx:showAdvancedNotification', src, 'Mors Mutual,', 'Stock Sale:', "You sold a ~y~Thousand Shares~s~ of ~r~"..stockAbbrev.."~s~ at ~g~$"..ESX.Math.GroupDigits(costPer).."~s~ for ~g~$"..ESX.Math.GroupDigits(transCost).."~s~.", 'CHAR_MP_MORS_MUTUAL', 9, false, true, 200);
            TriggerEvent("BadgerStocks:SetupDataID", src);
            --cb('ok');
        else 
            -- They do not own this stock 
            --TriggerClientEvent("BadgerStocks:SendNotif", src, "<span class='error'>ERROR: You do not own Enough of this stock...</span>");
            TriggerClientEvent('esx:showAdvancedNotification', src, 'Mors Mutual,', 'Insufficient Equity:', "You do not have the ~r~Required Amount~s~ of ~g~Shares~s~ for this transaction.", 'CHAR_MP_MORS_MUTUAL', 9, false, true, 200);
        end
    else 
        -- They do not own this stock 
        --TriggerClientEvent("BadgerStocks:SendNotif", src, "<span class='error'>ERROR: You do not own any of this stock...</span>");
        TriggerClientEvent('esx:showAdvancedNotification', src, 'Mors Mutual,', 'Insufficient Equity:', "You do not ~g~Own~s~ any ~y~Shares~s~ of ~r~"..stockAbbrev.."~s~.", 'CHAR_MP_MORS_MUTUAL', 9, false, true, 200);
    end 
end)


MySQL.ready(function()
    function BuyStock(src, stockAbbrev, amount, pricePer)
        local ids = ExtractIdentifiers(src);
        local steam = ids.steam;
        if (HasStockOwned(src, stockAbbrev, amount)) then 
            local avgPrice = GetAvgPrice(src, stockAbbrev);
            print(avgPrice,"price results");
            local currentHoldings = GetCurrentHolding(src, stockAbbrev)
            print(currentHoldings,"Holding results");
            local totalHoldings = currentHoldings+amount;
            local newAvgPrice = (currentHoldings*avgPrice+amount*pricePer)/totalHoldings;
            local number = newAvgPrice;
            local rounded = math.floor(number * 100 + 0.5) / 100;
            print(newAvgPrice, "the math works");
            print(amount, "amount puchased");
            print(rounded, "what should be the average");    
            -- They own, increase their own count
            local  sql = "UPDATE `user_stock_data` SET ownCount = (ownCount + @amt) WHERE `identifier` = @steam AND `stockAbbrev` = @stock";
            MySQL.Async.execute(sql, {['@amt'] = amount, ['@steam'] = steam, ['@stock'] = stockAbbrev});
             -- then change the price average
             local  priceAverage = "UPDATE `user_stock_data` SET averagePrice = @averagePrice WHERE `identifier` = @steam AND `stockAbbrev` = @stock";
             MySQL.Async.execute(priceAverage, {['@averagePrice'] = rounded, ['@steam'] = steam, ['@stock'] = stockAbbrev});
        else
            -- They don't have an owned Shares of this, insert 
            local  sql = "INSERT INTO `user_stock_data` VALUES (0, @steam, @stock, @amt, @averagePrice)";
            MySQL.Async.execute(sql, {['@amt'] = amount, ['@steam'] = steam, ['@stock'] = stockAbbrev, ['@averagePrice'] = pricePer});
        end
    end 
    function SellStock(src, stockAbbrev, amount, pricePer)
        local ids = ExtractIdentifiers(src);
        local steam = ids.steam;
        if (HasStockOwned(src, stockAbbrev, amount)) then 
            -- They have enough of this stock, sell it
            local sql = "SELECT ownCount FROM user_stock_data WHERE identifier = @steam AND stockAbbrev = @abbrev";
            local countSQL = MySQL.Sync.fetchAll(sql, {['@steam'] = steam, ['@abbrev'] = stockAbbrev});
            local count = countSQL[1].ownCount;

            -- They own, decrease their own count
            local  newOwnedamount = "UPDATE `user_stock_data` SET ownCount = (ownCount - @amt) WHERE `identifier` = @steam AND `stockAbbrev` = @stock";
            MySQL.Async.execute(newOwnedamount, {['@amt'] = amount, ['@steam'] = steam, ['@stock'] = stockAbbrev});
            if count == 0 then 
                MySQL.Async.execute("DELETE FROM `user_stock_data` WHERE `identifier` = @steam AND `stockAbbrev` = @stock", {
                    ['@steam'] = steam,
                    ['@stock'] = stockAbbrev
                }); 
            end 

            -- Update it, they have more than amount
            --[[MySQL.Async.execute("UPDATE `user_stock_data` SET `ownCount` = @own WHERE stockAbbrev = @stock AND identifier = @steam", {
                ['@own'] = (count - amount),
                ['@steam'] = steam,
                ['@stock'] = stockAbbrev
            });]]
        else
            -- They do not have enough of this stock to sell 
        end
    end 
    function HasStockOwned(src, stockAbbrev, amount) 
        local ids = ExtractIdentifiers(src);
        local steam = ids.steam;
        local sql = "SELECT COUNT(*) FROM user_stock_data WHERE identifier = @steam AND stockAbbrev = @abbrev";
        local count = MySQL.Sync.fetchScalar(sql, {['@steam'] = steam, ['@abbrev'] = stockAbbrev});
        if count > 0 then 
           
            return true;
        end
        return false;
    end 
    function GetStockCount(src)
        local ids = ExtractIdentifiers(src);
        local steam = ids.steam;
        local sql = "SELECT stockAbbrev, ownCount FROM user_stock_data WHERE identifier = @steam AND ownCount > 0";
        local stocks = MySQL.Sync.fetchAll(sql, {['@steam'] = steam});
        local count = 0;
        for i = 1, #stocks do 
            local abbrev = stocks[i].stockAbbrev;
            local owns = stocks[i].ownCount;
            count = count + owns; 
        end
        return count;
    end
    function GetCurrentHolding(src, stockAbbrev)
        local ids = ExtractIdentifiers(src);
        local steam = ids.steam;
        local sql = "SELECT stockAbbrev, ownCount FROM user_stock_data WHERE identifier = @steam";
        local stocks = MySQL.Sync.fetchAll(sql, {['@steam'] = steam});
        local count = 0;
        for i = 1, #stocks do 
            local abbrev = stocks[i].stockAbbrev;
            if abbrev == stockAbbrev then
                local owns = stocks[i].ownCount;
                count = count + owns; 
            end
        end
        return count;
    end    
    function GetAvgPrice(src, stockAbbrev)
        local ids = ExtractIdentifiers(src);
        local steam = ids.steam;
        local sql = "SELECT stockAbbrev, averagePrice FROM user_stock_data WHERE identifier = @steam";
        local stocks = MySQL.Sync.fetchAll(sql, {['@steam'] = steam});
        local priceAvg = 0;
        local count = 0;
        for i = 1, #stocks do 
            local abbrev = stocks[i].stockAbbrev;
            if abbrev == stockAbbrev then
                local owns = stocks[i].averagePrice;
                priceAvg = priceAvg + owns; 
                count = count + 1;
            end
        end
        return priceAvg;
    end
    function GetStocks(src)
        local ids = ExtractIdentifiers(src);
        local steam = ids.steam;
        local sql = "SELECT stockAbbrev, ownCount FROM user_stock_data WHERE identifier = @steam AND ownCount > 0";
        local stocks = MySQL.Sync.fetchAll(sql, {['@steam'] = steam});
        local stockData = {}
        for i = 1, #stocks do 
            local abbrev = stocks[i].stockAbbrev;
            local owns = stocks[i].ownCount;
            if stockData[abbrev] == nil then 
                stockData[abbrev] = owns;
            else
                stockData[abbrev] = stockData[abbrev] + owns; 
            end 
        end
        return stockData;
    end
    function GetStockPurchaseData(src)
        local ids = ExtractIdentifiers(src);
        local steam = ids.steam;
        local sql = "SELECT id, stockAbbrev, averagePrice, ownCount FROM user_stock_data WHERE identifier = @steam AND ownCount > 0 ORDER BY "
        .. "`id` DESC"; 
        local stockData = {}
        local stockDatas = MySQL.Sync.fetchAll(sql, {['@steam'] = steam});
       
        for i = 1, #stockDatas do 
            local id = stockDatas[i].id;
            local abbrev = stockDatas[i].stockAbbrev;
            local pricePurch = stockDatas[i].averagePrice;
            local count = stockDatas[i].ownCount;
            local mrktHoldings = stockDatas[i].averagePrice*stockDatas[i].ownCount;
            local number = mrktHoldings;
            local roundedHoldings = math.floor(number * 100 + 0.5) / 100;
            table.insert(stockData, {id, abbrev, pricePurch, count, roundedHoldings}); 
        end
        return {stockData, pricePurch, count, roundedHoldings};
    end
    RegisterNetEvent('BadgerStockMarket:Server:GetMaxStocks')
    AddEventHandler('BadgerStockMarket:Server:GetMaxStocks', function()
        local src = source;
        local curAmt = 0;
        for permission, amount in pairs(Config.maxStocksOwned) do 
            if IsPlayerAceAllowed(src, permission) then 
                if amount >= curAmt then 
                    curAmt = amount;
                end
            end
        end
        TriggerClientEvent('BadgerStockMarket:Client:SetMaxStocksOwned', src, curAmt)
    end)
    RegisterNetEvent('BadgerStockMarket:Server:GetStockHTML')
    AddEventHandler('BadgerStockMarket:Server:GetStockHTML', function()
        local stockData = {}
        local src = source;
        for stockName, stockInfo in pairs(Config.stocks) do
            local stockLink = stockInfo['link']; 
            local stockTags = stockInfo['tags'];
            local data = nil;
            PerformHttpRequest(tostring(stockLink), function(errorCode, resultData, resultHeaders)
            data = {data=resultData, code=errorCode, headers=resultHeaders};
            end)
            while data == nil do 
            Wait(0);
            end
            if data.data ~= nil then 
                stockData[stockName] = {
                    data = data.data,
                    link = stockLink,
                    tags = stockTags,
                };
            end
        end
        TriggerClientEvent('BadgerStockMarket:Client:GetStockData', src, stockData);
    end)
    function ExtractIdentifiers(src)
        local identifiers = {
            steam = "",
            ip = "",
            discord = "",
            license = "",
            xbl = "",
            live = ""
        }

        --Loop over all identifiers
        for i = 0, GetNumPlayerIdentifiers(src) - 1 do
            local id = GetPlayerIdentifier(src, i)

            --Convert it to a nice table.
            if string.find(id, "steam") then
                identifiers.steam = id
            elseif string.find(id, "ip") then
                identifiers.ip = id
            elseif string.find(id, "discord") then
                identifiers.discord = id
            elseif string.find(id, "license") then
                identifiers.license = id
            elseif string.find(id, "xbl") then
                identifiers.xbl = id
            elseif string.find(id, "live") then
                identifiers.live = id
            end
        end

        return identifiers
    end
end);

function GetAllowedCount(src) 
    local curCount = 0;
    for key, value in pairs(Config.maxStocksOwned) do 
        if value > curCount then 
            -- Check if they have access 
            if IsPlayerAceAllowed(src, key) then 
                curCount = value;
            end
        end
    end
    return curCount;
end
RegisterNetEvent("BadgerStocks:SetupData")
AddEventHandler("BadgerStocks:SetupData", function()
    local src = source;
    local data = GetStockPurchaseData(src);
    TriggerClientEvent("BadgerStocks:SendData", src, data);
end)
RegisterNetEvent("BadgerStocks:SetupDataID")
AddEventHandler("BadgerStocks:SetupDataID", function(src)
    local data = GetStockPurchaseData(src);
    TriggerClientEvent("BadgerStocks:SendData", src, data);
end)
