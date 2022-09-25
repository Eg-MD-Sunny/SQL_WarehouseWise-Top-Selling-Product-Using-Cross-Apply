select   w.Id [WID]
		,w.Name [WName]
		,r.Id [PVID]
		,r.Name [Product] 
		,r.Qty [SaleQty]
		,r.Price [SalePrice]
from 
	(
		select   w.Id
				,w.Name  
		from Warehouse w
	) w
Cross Apply
	(
		select top 2  pv.Id
					 ,pv.Name 
					 ,Count(tr.salePrice)[Qty]
					 ,Sum(tr.salePrice)[Price]

		from ThingRequest tr
		join Shipment s on s.id = tr.ShipmentId 
		join ProductVariant pv on pv.Id = tr.ProductVariantId 

		where s.ReconciledOn is not null
		and s.ReconciledOn >= '2022-07-25 00:00 +06:00'
		and s.ReconciledOn < '2022-07-26 00:00 +06:00'
		and tr.IsCancelled = 0
		and tr.IsReturned = 0
		and tr.HasFailedBeforeDispatch = 0
		and tr.IsMissingAfterDispatch = 0
		and pv.DistributionNetworkId = 1
		and s.ShipmentStatus not in (1,5,9)
		and w.Id = s.WarehouseId 

		Group by  pv.Id
				 ,pv.Name

	) r
Order by 1,3 desc