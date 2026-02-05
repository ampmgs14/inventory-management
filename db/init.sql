-- =========================
-- RESET
-- =========================
DROP TABLE IF EXISTS asset_values;
DROP TABLE IF EXISTS asset_fields;
DROP TABLE IF EXISTS assets;
DROP TABLE IF EXISTS asset_types;

-- =========================
-- CORE SCHEMA
-- =========================
CREATE TABLE asset_types (
    id SERIAL PRIMARY KEY,
    name TEXT UNIQUE NOT NULL,
    label TEXT NOT NULL
);

CREATE TABLE assets (
    id SERIAL PRIMARY KEY,
    asset_type_id INT REFERENCES asset_types(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE asset_fields (
    id SERIAL PRIMARY KEY,
    asset_type_id INT REFERENCES asset_types(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    label TEXT NOT NULL,
    data_type TEXT,
    filterable BOOLEAN DEFAULT false
);

CREATE TABLE asset_values (
    asset_id INT REFERENCES assets(id) ON DELETE CASCADE,
    field_id INT REFERENCES asset_fields(id) ON DELETE CASCADE,
    value TEXT,
    PRIMARY KEY (asset_id, field_id)
);

-- =========================
-- ASSET TYPES
-- =========================
INSERT INTO asset_types (name,label) VALUES
('laptops','Laptops');

-- =========================
-- FIELDS (LAPTOPS)
-- =========================
INSERT INTO asset_fields (asset_type_id,name,label,data_type,filterable)
SELECT id,'vendor','Vendor','string',true FROM asset_types WHERE name='laptops';
INSERT INTO asset_fields (asset_type_id,name,label,data_type,filterable)
SELECT id,'model','Model','string',true FROM asset_types WHERE name='laptops';
INSERT INTO asset_fields (asset_type_id,name,label,data_type,filterable)
SELECT id,'cpu','CPU','string',false FROM asset_types WHERE name='laptops';
INSERT INTO asset_fields (asset_type_id,name,label,data_type,filterable)
SELECT id,'ram_gb','RAM (GB)','number',true FROM asset_types WHERE name='laptops';
INSERT INTO asset_fields (asset_type_id,name,label,data_type,filterable)
SELECT id,'storage_gb','Storage (GB)','number',false FROM asset_types WHERE name='laptops';
INSERT INTO asset_fields (asset_type_id,name,label,data_type,filterable)
SELECT id,'os','OS','string',true FROM asset_types WHERE name='laptops';
INSERT INTO asset_fields (asset_type_id,name,label,data_type,filterable)
SELECT id,'serial_number','Serial','string',true FROM asset_types WHERE name='laptops';

-- =========================
-- CREATE 45 LAPTOP ASSETS
-- =========================
INSERT INTO assets (asset_type_id)
SELECT t.id
FROM asset_types t
CROSS JOIN generate_series(1,45)
WHERE t.name='laptops';

-- =========================
-- SOURCE DATA (FLAT, LIKE YOUR TABLE)
-- =========================
WITH src AS (
  SELECT row_number() OVER () rn, *
  FROM (VALUES
    ('Dell','Inspiron 14','Intel i5-1135G7',8,512,'Windows 11','DEL-IN14-001'),
    ('Dell','Inspiron 15','Intel i5-1135G7',8,256,'Windows 10','DEL-IN15-002'),
    ('Dell','Inspiron 15','Intel i7-1165G7',16,512,'Windows 11','DEL-IN15-003'),
    ('Dell','Inspiron 14','Intel i5-1235U',8,512,'Windows 11','DEL-IN14-004'),
    ('Dell','Inspiron 16','Intel i7-1255U',16,512,'Windows 11','DEL-IN16-005'),
    ('Dell','Latitude 3420','Intel i5-1145G7',8,512,'Windows 11','DEL-LAT-006'),
    ('Dell','Latitude 3520','Intel i5-1135G7',16,512,'Windows 11','DEL-LAT-007'),
    ('Dell','Latitude 3520','Intel i7-1165G7',16,512,'Windows 11','DEL-LAT-008'),
    ('Dell','Latitude 3420','Intel i5-1235U',8,256,'Windows 11','DEL-LAT-009'),
    ('Dell','Vostro 14','Intel i5-1135G7',8,512,'Windows 10','DEL-VOS-010'),
    ('Dell','Vostro 15','Intel i7-1165G7',16,512,'Windows 11','DEL-VOS-011'),
    ('Dell','Vostro 14','Intel i5-12450H',16,512,'Windows 11','DEL-VOS-012'),
    ('Dell','Inspiron 13','Intel i5-1135G7',8,256,'Windows 11','DEL-IN13-013'),
    ('Dell','Inspiron 14','Intel i7-1255U',16,512,'Windows 11','DEL-IN14-014'),
    ('HP','Pavilion 14','Intel i5-1135G7',8,512,'Windows 11','HP-PAV-015'),
    ('HP','Pavilion 15','Intel i5-12450H',16,512,'Windows 11','HP-PAV-016'),
    ('HP','Pavilion 14','Intel i7-1165G7',16,512,'Windows 11','HP-PAV-017'),
    ('HP','Pavilion 15','Intel i5-1135G7',8,256,'Windows 10','HP-PAV-018'),
    ('HP','ProBook 440','Intel i5-1135G7',8,512,'Windows 11','HP-PB-019'),
    ('HP','ProBook 450','Intel i5-1145G7',16,512,'Windows 11','HP-PB-020'),
    ('HP','ProBook 440','Intel i7-1165G7',16,512,'Windows 11','HP-PB-021'),
    ('HP','ProBook 450','Intel i5-1235U',8,256,'Windows 11','HP-PB-022'),
    ('HP','EliteBook 840','Intel i5-1145G7',16,512,'Windows 11','HP-EB-023'),
    ('HP','EliteBook 840','Intel i7-1185G7',16,512,'Windows 11','HP-EB-024'),
    ('HP','15s','Intel i5-1135G7',8,512,'Windows 11','HP-15S-025'),
    ('HP','15s','Intel i7-1165G7',16,512,'Windows 11','HP-15S-026'),
    ('HP','14s','Intel i5-12450H',16,512,'Windows 11','HP-14S-027'),
    ('Lenovo','IdeaPad 3','Intel i5-1135G7',8,512,'Windows 11','LEN-ID3-028'),
    ('Lenovo','IdeaPad 3','Intel i5-1235U',8,256,'Windows 11','LEN-ID3-029'),
    ('Lenovo','IdeaPad 5','Intel i7-1165G7',16,512,'Windows 11','LEN-ID5-030'),
    ('Lenovo','IdeaPad Slim 5','Intel i5-12450H',16,512,'Windows 11','LEN-SL5-031'),
    ('Lenovo','IdeaPad Slim 3','Intel i5-1135G7',8,512,'Windows 10','LEN-SL3-032'),
    ('Lenovo','ThinkPad E14','Intel i5-1135G7',8,512,'Windows 11','LEN-E14-033'),
    ('Lenovo','ThinkPad E14','Intel i7-1165G7',16,512,'Windows 11','LEN-E14-034'),
    ('Lenovo','ThinkPad E15','Intel i5-1145G7',16,512,'Windows 11','LEN-E15-035'),
    ('Lenovo','ThinkPad L14','Intel i5-1235U',8,512,'Windows 11','LEN-L14-036'),
    ('Lenovo','ThinkPad L15','Intel i7-1255U',16,512,'Windows 11','LEN-L15-037'),
    ('Lenovo','ThinkBook 14','Intel i5-1135G7',8,512,'Windows 11','LEN-TB14-038'),
    ('Lenovo','ThinkBook 15','Intel i7-1165G7',16,512,'Windows 11','LEN-TB15-039'),
    ('Dell','Inspiron 15','Intel i5-12450H',16,512,'Windows 11','DEL-IN15-040'),
    ('HP','Pavilion 14','Intel i5-1235U',8,512,'Windows 11','HP-PAV-041'),
    ('Lenovo','IdeaPad 5','Intel i5-1135G7',8,512,'Windows 11','LEN-ID5-042'),
    ('Dell','Vostro 15','Intel i5-1135G7',8,512,'Windows 11','DEL-VOS-043'),
    ('HP','ProBook 440','Intel i5-12450H',16,512,'Windows 11','HP-PB-044'),
    ('Lenovo','ThinkPad E15','Intel i5-1135G7',8,512,'Windows 11','LEN-E15-045')
  ) AS t(vendor,model,cpu,ram_gb,storage_gb,os,serial)
)

INSERT INTO asset_values (asset_id, field_id, value)
SELECT a.id, f.id,
       CASE f.name
         WHEN 'vendor' THEN s.vendor
         WHEN 'model' THEN s.model
         WHEN 'cpu' THEN s.cpu
         WHEN 'ram_gb' THEN s.ram_gb::text
         WHEN 'storage_gb' THEN s.storage_gb::text
         WHEN 'os' THEN s.os
         WHEN 'serial_number' THEN s.serial
       END
FROM assets a
JOIN asset_types t ON t.id=a.asset_type_id AND t.name='laptops'
JOIN src s ON s.rn=a.id
JOIN asset_fields f ON f.asset_type_id=t.id;

-- asset type
INSERT INTO asset_types (name,label)
VALUES ('servers','Servers')
ON CONFLICT (name) DO NOTHING;

-- fields
INSERT INTO asset_fields (asset_type_id,name,label,data_type,filterable)
SELECT id,'vendor','Vendor','string',true FROM asset_types WHERE name='servers';
INSERT INTO asset_fields (asset_type_id,name,label,data_type,filterable)
SELECT id,'model','Model','string',true FROM asset_types WHERE name='servers';
INSERT INTO asset_fields (asset_type_id,name,label,data_type,filterable)
SELECT id,'cpu','CPU','string',false FROM asset_types WHERE name='servers';
INSERT INTO asset_fields (asset_type_id,name,label,data_type,filterable)
SELECT id,'ram_gb','RAM (GB)','number',true FROM asset_types WHERE name='servers';
INSERT INTO asset_fields (asset_type_id,name,label,data_type,filterable)
SELECT id,'storage_gb','Storage (GB)','number',false FROM asset_types WHERE name='servers';
INSERT INTO asset_fields (asset_type_id,name,label,data_type,filterable)
SELECT id,'os','OS','string',true FROM asset_types WHERE name='servers';
INSERT INTO asset_fields (asset_type_id,name,label,data_type,filterable)
SELECT id,'ip_address','IP','string',true FROM asset_types WHERE name='servers';

-- assets
INSERT INTO assets (asset_type_id)
SELECT t.id FROM asset_types t
CROSS JOIN generate_series(1,10)
WHERE t.name='servers';

-- data
WITH src AS (
  SELECT row_number() OVER () rn, *
  FROM (VALUES
    ('Dell','PowerEdge R640','Xeon Silver 4210',64,2048,'Ubuntu 20.04','10.0.0.10'),
    ('Dell','PowerEdge R650','Xeon Gold 5218',128,4096,'RHEL 9','10.0.0.11'),
    ('HPE','DL380 Gen10','Xeon Silver 4210',64,2048,'Ubuntu 22.04','10.0.0.12'),
    ('HPE','DL360 Gen10','Xeon Silver 4210',128,4096,'RHEL 8','10.0.0.13'),
    ('Lenovo','SR650','Xeon Silver 4210',128,4096,'Ubuntu 22.04','10.0.0.14'),
    ('Lenovo','SR630','Xeon Silver 4210',64,2048,'Ubuntu 20.04','10.0.0.15'),
    ('Dell','PowerEdge R740','Xeon Gold 6130',128,4096,'Windows Server 2022','10.0.0.16'),
    ('Dell','PowerEdge R540','Xeon Silver 4210',64,2048,'Rocky 9','10.0.0.17'),
    ('HPE','ML350 Gen10','Xeon Silver 4210',64,2048,'Windows Server 2019','10.0.0.18'),
    ('Lenovo','ST550','Xeon Silver 4210',128,4096,'Windows Server 2022','10.0.0.19')
  ) AS t(vendor,model,cpu,ram_gb,storage_gb,os,ip)
)
INSERT INTO asset_values (asset_id,field_id,value)
SELECT a.id,f.id,
CASE f.name
  WHEN 'vendor' THEN s.vendor
  WHEN 'model' THEN s.model
  WHEN 'cpu' THEN s.cpu
  WHEN 'ram_gb' THEN s.ram_gb::text
  WHEN 'storage_gb' THEN s.storage_gb::text
  WHEN 'os' THEN s.os
  WHEN 'ip_address' THEN s.ip
END
FROM assets a
JOIN asset_types t ON t.id=a.asset_type_id AND t.name='servers'
JOIN src s ON s.rn = a.id - (SELECT min(id) FROM assets WHERE asset_type_id=t.id)
JOIN asset_fields f ON f.asset_type_id=t.id;


INSERT INTO asset_types (name,label)
VALUES ('switches','Switches')
ON CONFLICT (name) DO NOTHING;

INSERT INTO asset_fields (asset_type_id,name,label,data_type,filterable)
SELECT id,'vendor','Vendor','string',true FROM asset_types WHERE name='switches';
INSERT INTO asset_fields (asset_type_id,name,label,data_type,filterable)
SELECT id,'model','Model','string',true FROM asset_types WHERE name='switches';
INSERT INTO asset_fields (asset_type_id,name,label,data_type,filterable)
SELECT id,'ports','Ports','number',true FROM asset_types WHERE name='switches';
INSERT INTO asset_fields (asset_type_id,name,label,data_type,filterable)
SELECT id,'firmware','Firmware','string',true FROM asset_types WHERE name='switches';
INSERT INTO asset_fields (asset_type_id,name,label,data_type,filterable)
SELECT id,'management_ip','Mgmt IP','string',true FROM asset_types WHERE name='switches';

INSERT INTO assets (asset_type_id)
SELECT t.id FROM asset_types t
CROSS JOIN generate_series(1,8)
WHERE t.name='switches';

WITH src AS (
  SELECT row_number() OVER () rn, *
  FROM (VALUES
    ('Cisco','Catalyst 2960',24,'15.2','10.1.0.10'),
    ('Cisco','Catalyst 9200',48,'17.3','10.1.0.11'),
    ('HPE','Aruba 2530',24,'YA.16','10.1.0.12'),
    ('Dell','N1548',48,'6.6','10.1.0.13'),
    ('Cisco','Catalyst 3650',24,'16.6','10.1.0.14'),
    ('HPE','2930F',48,'WC.16','10.1.0.15'),
    ('Dell','N2024',24,'6.5','10.1.0.16'),
    ('Cisco','Catalyst 9300',48,'17.6','10.1.0.17')
  ) AS t(vendor,model,ports,fw,ip)
)
INSERT INTO asset_values (asset_id,field_id,value)
SELECT a.id,f.id,
CASE f.name
  WHEN 'vendor' THEN s.vendor
  WHEN 'model' THEN s.model
  WHEN 'ports' THEN s.ports::text
  WHEN 'firmware' THEN s.fw
  WHEN 'management_ip' THEN s.ip
END
FROM assets a
JOIN asset_types t ON t.id=a.asset_type_id AND t.name='switches'
JOIN src s ON s.rn = a.id - (SELECT min(id) FROM assets WHERE asset_type_id=t.id)
JOIN asset_fields f ON f.asset_type_id=t.id;

-- =========================
-- PRINTERS
-- =========================
INSERT INTO asset_types (name,label)
VALUES ('printers','Printers')
ON CONFLICT (name) DO NOTHING;

INSERT INTO asset_fields (asset_type_id,name,label,data_type,filterable)
SELECT id,'vendor','Vendor','string',true FROM asset_types WHERE name='printers';
INSERT INTO asset_fields (asset_type_id,name,label,data_type,filterable)
SELECT id,'model','Model','string',true FROM asset_types WHERE name='printers';
INSERT INTO asset_fields (asset_type_id,name,label,data_type,filterable)
SELECT id,'printer_type','Type','string',true FROM asset_types WHERE name='printers';
INSERT INTO asset_fields (asset_type_id,name,label,data_type,filterable)
SELECT id,'color_supported','Color','string',true FROM asset_types WHERE name='printers';
INSERT INTO asset_fields (asset_type_id,name,label,data_type,filterable)
SELECT id,'location','Location','string',true FROM asset_types WHERE name='printers';
INSERT INTO asset_fields (asset_type_id,name,label,data_type,filterable)
SELECT id,'serial_number','Serial','string',true FROM asset_types WHERE name='printers';

INSERT INTO assets (asset_type_id)
SELECT t.id FROM asset_types t
CROSS JOIN generate_series(1,8)
WHERE t.name='printers';

WITH src AS (
  SELECT row_number() OVER () rn, *
  FROM (VALUES
    ('HP','LaserJet Pro M404','Laser','Yes','IT Room','PRN-001'),
    ('HP','LaserJet 1020','Laser','No','Accounts','PRN-002'),
    ('Canon','PIXMA G3010','Inkjet','Yes','HR','PRN-003'),
    ('Brother','HL-L2351DW','Laser','No','Admin','PRN-004'),
    ('Epson','EcoTank L3150','Inkjet','Yes','Reception','PRN-005'),
    ('Ricoh','MP 2014','Laser','No','Finance','PRN-006'),
    ('HP','DeskJet 2331','Inkjet','Yes','Support','PRN-007'),
    ('Canon','LBP2900','Laser','No','IT Room','PRN-008')
  ) AS t(vendor,model,ptype,color,loc,serial)
)
INSERT INTO asset_values (asset_id,field_id,value)
SELECT a.id,f.id,
CASE f.name
  WHEN 'vendor' THEN s.vendor
  WHEN 'model' THEN s.model
  WHEN 'printer_type' THEN s.ptype
  WHEN 'color_supported' THEN s.color
  WHEN 'location' THEN s.loc
  WHEN 'serial_number' THEN s.serial
END
FROM assets a
JOIN asset_types t ON t.id=a.asset_type_id AND t.name='printers'
JOIN src s ON s.rn = a.id - (SELECT min(id) FROM assets WHERE asset_type_id=t.id)
JOIN asset_fields f ON f.asset_type_id=t.id;

-- =========================
-- IoT MICROCONTROLLERS
-- =========================
INSERT INTO asset_types (name,label)
VALUES ('iot_microcontrollers','IoT Microcontrollers')
ON CONFLICT (name) DO NOTHING;

INSERT INTO asset_fields (asset_type_id,name,label,data_type,filterable)
SELECT id,'vendor','Vendor','string',true FROM asset_types WHERE name='iot_microcontrollers';
INSERT INTO asset_fields (asset_type_id,name,label,data_type,filterable)
SELECT id,'board_name','Board','string',true FROM asset_types WHERE name='iot_microcontrollers';
INSERT INTO asset_fields (asset_type_id,name,label,data_type,filterable)
SELECT id,'chipset','Chipset','string',true FROM asset_types WHERE name='iot_microcontrollers';
INSERT INTO asset_fields (asset_type_id,name,label,data_type,filterable)
SELECT id,'connectivity','Connectivity','string',true FROM asset_types WHERE name='iot_microcontrollers';
INSERT INTO asset_fields (asset_type_id,name,label,data_type,filterable)
SELECT id,'flash_kb','Flash (KB)','number',false FROM asset_types WHERE name='iot_microcontrollers';
INSERT INTO asset_fields (asset_type_id,name,label,data_type,filterable)
SELECT id,'assigned_project','Project','string',true FROM asset_types WHERE name='iot_microcontrollers';

INSERT INTO assets (asset_type_id)
SELECT t.id FROM asset_types t
CROSS JOIN generate_series(1,8)
WHERE t.name='iot_microcontrollers';

WITH src AS (
  SELECT row_number() OVER () rn, *
  FROM (VALUES
    ('Espressif','ESP32 DevKit','ESP32','WiFi+BLE',4096,'Smart Lock'),
    ('Espressif','ESP8266 NodeMCU','ESP8266','WiFi',4096,'Weather Station'),
    ('Arduino','Uno','ATmega328P','None',32,'Training'),
    ('Arduino','Nano','ATmega328P','None',32,'Prototype'),
    ('Raspberry Pi','Pico','RP2040','None',2048,'Robotics'),
    ('ST','Nucleo F401','STM32F401','None',512,'Motor Control'),
    ('Espressif','ESP32-S3','ESP32-S3','WiFi+BLE',8192,'AI Camera'),
    ('Nordic','nRF52840 DK','nRF52840','BLE',1024,'Wearables')
  ) AS t(vendor,board,chip,conn,flash,proj)
)
INSERT INTO asset_values (asset_id,field_id,value)
SELECT a.id,f.id,
CASE f.name
  WHEN 'vendor' THEN s.vendor
  WHEN 'board_name' THEN s.board
  WHEN 'chipset' THEN s.chip
  WHEN 'connectivity' THEN s.conn
  WHEN 'flash_kb' THEN s.flash::text
  WHEN 'assigned_project' THEN s.proj
END
FROM assets a
JOIN asset_types t ON t.id=a.asset_type_id AND t.name='iot_microcontrollers'
JOIN src s ON s.rn = a.id - (SELECT min(id) FROM assets WHERE asset_type_id=t.id)
JOIN asset_fields f ON f.asset_type_id=t.id;

-- =========================
-- SMART TVs
-- =========================
INSERT INTO asset_types (name,label)
VALUES ('smart_tvs','Smart TVs')
ON CONFLICT (name) DO NOTHING;

INSERT INTO asset_fields (asset_type_id,name,label,data_type,filterable)
SELECT id,'vendor','Vendor','string',true FROM asset_types WHERE name='smart_tvs';
INSERT INTO asset_fields (asset_type_id,name,label,data_type,filterable)
SELECT id,'model','Model','string',true FROM asset_types WHERE name='smart_tvs';
INSERT INTO asset_fields (asset_type_id,name,label,data_type,filterable)
SELECT id,'screen_size','Screen Size (inch)','number',true FROM asset_types WHERE name='smart_tvs';
INSERT INTO asset_fields (asset_type_id,name,label,data_type,filterable)
SELECT id,'resolution','Resolution','string',true FROM asset_types WHERE name='smart_tvs';
INSERT INTO asset_fields (asset_type_id,name,label,data_type,filterable)
SELECT id,'os','OS','string',true FROM asset_types WHERE name='smart_tvs';
INSERT INTO asset_fields (asset_type_id,name,label,data_type,filterable)
SELECT id,'location','Location','string',true FROM asset_types WHERE name='smart_tvs';

INSERT INTO assets (asset_type_id)
SELECT t.id FROM asset_types t
CROSS JOIN generate_series(1,6)
WHERE t.name='smart_tvs';

WITH src AS (
  SELECT row_number() OVER () rn, *
  FROM (VALUES
    ('Samsung','Crystal UHD','55','4K','Tizen','Conference Room'),
    ('LG','WebOS TV','65','4K','webOS','Board Room'),
    ('Sony','Bravia X75','50','4K','Android TV','Lobby'),
    ('Mi','TV 5X','43','4K','Android TV','Training Room'),
    ('OnePlus','Y Series','55','4K','Android TV','HR Hall'),
    ('Samsung','Frame','65','4K','Tizen','CEO Cabin')
  ) AS t(vendor,model,size,res,os,loc)
)
INSERT INTO asset_values (asset_id,field_id,value)
SELECT a.id,f.id,
CASE f.name
  WHEN 'vendor' THEN s.vendor
  WHEN 'model' THEN s.model
  WHEN 'screen_size' THEN s.size
  WHEN 'resolution' THEN s.res
  WHEN 'os' THEN s.os
  WHEN 'location' THEN s.loc
END
FROM assets a
JOIN asset_types t ON t.id=a.asset_type_id AND t.name='smart_tvs'
JOIN src s ON s.rn = a.id - (SELECT min(id) FROM assets WHERE asset_type_id=t.id)
JOIN asset_fields f ON f.asset_type_id=t.id;
