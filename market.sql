/* Top clientes con más facturas*/
SELECT c.nombre || ' ' || c.apellido AS NOMBRE_APELLIDO
FROM cliente c
LEFT JOIN factura f ON c.id=f.cliente_id
GROUP BY c.id,c.nombre,c.apellido
ORDER BY COUNT(f.id) DESC;

/*Top clientes que más gastaron*/
SELECT c.nombre || ' ' || c.apellido AS NOMBRE_APELLIDO
FROM cliente c
LEFT JOIN factura f ON c.id = f.cliente_id
LEFT JOIN factura_detalle fd ON f.id = fd.factura_id  
LEFT JOIN producto p ON fd.producto_id = p.id 
GROUP BY NOMBRE_APELLIDO
HAVING SUM(fd.cantidad * p.precio) IS NOT NULL
ORDER BY SUM(fd.cantidad * p.precio) DESC;

/*Top monedas más utilizadas*/

SELECT m.nombre AS Nombre_Moneda
FROM factura f
RIGHT JOIN moneda m on f.moneda_id = m.id
GROUP BY m.nombre 
ORDER BY COUNT (moneda_id) DESC;

/*Top proveedor de productos*/

SELECT p.nombre AS Nombre_Proveedor
FROM proveedor p 
LEFT JOIN producto pt on p.id = pt.proveedor_id
GROUP BY p.nombre
ORDER BY count(pt.id);

/*Productos más vendidos*/
SELECT p.nombre AS Nombre_Producto
FROM producto p
LEFT JOIN factura_detalle fd ON fd.producto_id = p.id
GROUP BY p.nombre
ORDER BY COALESCE (SUM(fd.cantidad),0) DESC;

/*Productos menos vendidos*/
SELECT p.nombre AS Nombre_Producto
FROM producto p
LEFT JOIN factura_detalle fd ON fd.producto_id = p.id
GROUP BY p.nombre
ORDER BY COALESCE (SUM(fd.cantidad),0) ;

/*Consulta que muestre fecha de emisión de factura, nombre y apellido del cliente,
nombres de productos de esa factura, cantidades compradas, nombre de tipo de factura 
de una factura específica
*/

SELECT f.fecha_emision,c.nombre || c.apellido AS Nombre_Apellido,
COALESCE (p.nombre, 'SIN NOMBRE' )AS Nombre_Producto , 
COALESCE (fd.cantidad, 00) AS Cantidad_Comprada, 
ft.nombre AS Nombre_Factura
FROM factura f 
LEFT JOIN cliente c on f.cliente_id = c.id
LEFT JOIN factura_detalle fd on f.id = fd.factura_id
RIGHT JOIN producto p on fd.producto_id = p.id
LEFT JOIN factura_tipo ft on f.factura_tipo_id = ft.id
ORDER BY f.fecha_emision, f.id, Nombre_Apellido
;


/*Montos de facturas ordenadas según totales*/
SELECT f.id AS "ID FACTURA" , COALESCE (SUM(fd.cantidad * p.precio),0) AS "MONTO FACTURA"
FROM factura f
LEFT JOIN factura_detalle fd ON f.id = fd.factura_id  
LEFT JOIN producto p ON fd.producto_id = p.id 
GROUP BY f.id
ORDER BY COALESCE (SUM(fd.cantidad * p.precio),0) DESC;

/*Mostrar el iva 10% de los montos totales de facturas (suponer que todos 
los productos tienen IVA 10%)*/

SELECT f.id AS "ID FACTURA",
COALESCE(SUM(fd.cantidad * p.precio * 0.1), 0) AS "Total con IVA 10%"
FROM factura f
LEFT JOIN factura_detalle fd ON f.id = fd.factura_id  
LEFT JOIN producto p ON fd.producto_id = p.id 
GROUP BY f.id
ORDER BY COALESCE(SUM(fd.cantidad * p.precio * 0.1), 0) DESC;





