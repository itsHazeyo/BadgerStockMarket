-------------------------
--- BadgerStockMarket ---
-------------------------
ESX = nil

Citizen.CreateThread(function ()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)
Citizen.CreateThread(function()
	-- This is the thread for sending resource name 
	Citizen.Wait(1000)
	local rname = GetCurrentResourceName();
	SendNUIMessage({
		resourcename = rname;
	});
end)
RegisterNetEvent("BadgerStocks:SendNotif")
AddEventHandler("BadgerStocks:SendNotif", function(notif)
	SendNUIMessage({
		notification = notif;
	});
end)
RegisterNetEvent("BadgerStocks:SendData")
AddEventHandler("BadgerStocks:SendData", function(data)
	SendNUIMessage({
		theirStockData = data;
	});
end)

RegisterNUICallback("BadgerStocks:Buy", function(data, cb)
 TriggerServerEvent("BadgerStocks:SetupData");
	cb(TriggerServerEvent("BadgerStocks:Buy", data, function(callback) return callback end))
end)

RegisterNUICallback("BadgerStocks:Sell", function(data, cb)
 TriggerServerEvent("BadgerStocks:SetupData");
	cb(TriggerServerEvent("BadgerStocks:Sell", data, function(callback) return callback end))
end)

RegisterNUICallback("BadgerStocks:Buyx10", function(data, cb)
 TriggerServerEvent("BadgerStocks:SetupData");
	cb(TriggerServerEvent("BadgerStocks:Buyx10", data, function(callback) return callback end))
end)

RegisterNUICallback("BadgerStocks:Sellx10", function(data, cb)
 TriggerServerEvent("BadgerStocks:SetupData");
	cb(TriggerServerEvent("BadgerStocks:Sellx10", data, function(callback) return callback end))
end)

RegisterNUICallback("BadgerStocks:Buyx100", function(data, cb)
 TriggerServerEvent("BadgerStocks:SetupData");
	cb(TriggerServerEvent("BadgerStocks:Buyx100", data, function(callback) return callback end))
end)

RegisterNUICallback("BadgerStocks:Sellx100", function(data, cb)
 TriggerServerEvent("BadgerStocks:SetupData");
	cb(TriggerServerEvent("BadgerStocks:Sellx100", data, function(callback) return callback end))
end)

RegisterNUICallback("BadgerStocks:Buyx1000", function(data, cb)
 TriggerServerEvent("BadgerStocks:SetupData");
	cb(TriggerServerEvent("BadgerStocks:Buyx1000", data, function(callback) return callback end))
end)

RegisterNUICallback("BadgerStocks:Sellx1000", function(data, cb)
 TriggerServerEvent("BadgerStocks:SetupData");
	cb(TriggerServerEvent("BadgerStocks:Sellx1000", data, function(callback) return callback end))
end)

maxStocksOwned = 20; -- The max stocks the user is allowed to own 
RegisterNetEvent('BadgerStockMarket:Client:SetMaxStocksOwned')
AddEventHandler('BadgerStockMarket:Client:SetMaxStocksOwned', function(maxStocks)
	maxStocksOwned = maxStocks;
end)
stockData = nil;
RegisterNetEvent('BadgerStockMarket:Client:GetStockData')
AddEventHandler('BadgerStockMarket:Client:GetStockData', function(stockD)
	stockData = stockD;
end)
RegisterCommand('stocks', function(source, args, rawCommand)
	-- Toggle on and off stocks phone 
	TriggerServerEvent('BadgerStockMarket:Server:GetStockHTML');
	SetNuiFocus(true, true);
	TriggerServerEvent('BadgerStockMarket:Server:GetMaxStocks');
	SendNUIMessage({
		maxStocksAllowed = maxStocksOwned;
	});
	SendNUIMessage({
		show = true;
	});
	TriggerServerEvent("BadgerStocks:SetupData");
	while stockData == nil do 
		Wait(500);
		SendNUIMessage({
			stockData = stockData;
		});
	end
	if stockData ~= nil then 
		SendNUIMessage({
			stockData = stockData;
		});
	end
end)
RegisterNUICallback('BadgerPhoneClose', function(data, cb)
	SetNuiFocus(false, false)
	if (cb) then 
		cb('ok')
	end
end)
