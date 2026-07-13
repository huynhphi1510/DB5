INSERT INTO Country (CountryID, CountryName) VALUES
('C01', 'North'),
('C02', 'Central'),
('C03', 'South');

INSERT INTO Province (ProvinceID, ProvinceName, Population, Area, CountryID) VALUES
('P01', 'Ha Noi',      8435700,  3359.8, 'C01'),
('P02', 'Lao Cai',      733300,  6364.0, 'C01'),
('P03', 'Quang Ninh',  1346900,  6178.2, 'C01'),
('P04', 'Nghe An',     3327800, 16490.0, 'C02'),
('P05', 'Da Nang',     1230800,  1284.9, 'C02'),
('P06', 'Gia Lai',     1513800, 15510.8, 'C02'),
('P07', 'Ho Chi Minh', 9038600,  2061.0, 'C03'),
('P08', 'Dong Nai',    3236200,  5907.2, 'C03'),
('P09', 'Binh Phuoc',  1020800,  6877.0, 'C03');


INSERT INTO Border (ProvinceID, NationID) VALUES
('P01', 'C02'),
('P03', 'C02'),
('P04', 'C01'),
('P04', 'C03'),
('P06', 'C03'),
('P07', 'C02');

INSERT INTO Neighbor (ProvinceID, NeighborID) VALUES
('P01', 'P02'), ('P02', 'P01'),
('P02', 'P03'), ('P03', 'P02'),
('P03', 'P04'), ('P04', 'P03'),
('P04', 'P05'), ('P05', 'P04'),
('P05', 'P06'), ('P06', 'P05'),
('P06', 'P07'), ('P07', 'P06'),
('P07', 'P08'), ('P08', 'P07'),
('P08', 'P09'), ('P09', 'P08');