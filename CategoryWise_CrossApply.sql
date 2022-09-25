select C.ID,C.Name,P.Id [ProductID],P.Name [ProductName]

from
	(
		select c.Id, c.Name 
		from Category c
	)C
Cross Apply
	(
		select top 5 pv.Id,
				pv.name
		from ProductVariant pv 
		join ProductVariantCategoryMapping pvcm on pv.Id = pvcm.ProductVariantId 

		where C.Id = pvcm.CategoryId 
	) P