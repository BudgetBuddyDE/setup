-- Benutzer erstellen
INSERT INTO "user" (uuid, email, name, surname, password, created_at)
VALUES ('f70e3c36-33f9-45a7-ae45-ff2760f92a95', 'user1@example.com', 'Max', 'Mustermann', 'hashed_password1', NOW());

-- Füge ein Benutzeravatar ein
INSERT INTO user_avatar (owner, file_name, mimetype, created_at)
VALUES ('f70e3c36-33f9-45a7-ae45-ff2760f92a95', 'avatar.jpg', 'image/jpeg', NOW());

-- Füge ein Benutzer-Feedback ein
INSERT INTO user_feedback (owner, rating, title, message, created_at)
VALUES ('f70e3c36-33f9-45a7-ae45-ff2760f92a95', 5, 'Tolle Plattform', 'Ich liebe diese Plattform!', NOW());

-- Kategorien erstellen
INSERT INTO category (owner, name, description, created_at)
VALUES
    ('f70e3c36-33f9-45a7-ae45-ff2760f92a95', 'Lebensmittel', 'Einkäufe im Supermarkt', NOW()),
    ('f70e3c36-33f9-45a7-ae45-ff2760f92a95', 'Kleidung', 'Mode und Bekleidung', NOW()),
    ('f70e3c36-33f9-45a7-ae45-ff2760f92a95', 'Miete', 'Monatliche Mietzahlung', NOW()),
    ('f70e3c36-33f9-45a7-ae45-ff2760f92a95', 'Transport', 'Fahrtkosten und Verkehr', NOW());

-- Zahlungsmethoden erstellen
INSERT INTO payment_method (owner, name, address, description, created_at)
VALUES
    ('f70e3c36-33f9-45a7-ae45-ff2760f92a95', 'Kreditkarte', '1234-5678-9012-3456', 'Hauptzahlungsmethode', NOW()),
    ('f70e3c36-33f9-45a7-ae45-ff2760f92a95', 'PayPal', 'user1@example.com', 'Alternative Zahlungsmethode', NOW());

-- Transaktionen für Benutzer 1
INSERT INTO transaction (owner, category, payment_method, receiver, description, transfer_amount, created_at)
VALUES
    ('f70e3c36-33f9-45a7-ae45-ff2760f92a95', 1, 1, 'Empfänger 1', 'Transaktion 1', 50.00, NOW()),
    ('f70e3c36-33f9-45a7-ae45-ff2760f92a95', 2, 2, 'Empfänger 2', 'Transaktion 2', 75.00, NOW()),
    ('f70e3c36-33f9-45a7-ae45-ff2760f92a95', 3, 1, 'Empfänger 3', 'Transaktion 3', 30.00, NOW()),
    ('f70e3c36-33f9-45a7-ae45-ff2760f92a95', 4, 1, 'Empfänger 4', 'Transaktion 4', 40.00, NOW());

-- Abonnements für Benutzer 1
INSERT INTO subscription (owner, category, payment_method, paused, execute_at, receiver, description, transfer_amount, created_at)
VALUES
    ('f70e3c36-33f9-45a7-ae45-ff2760f92a95', 1, 1, false, 15, 'Empfänger A', 'Abonnement 1', 20.00, NOW()),
    ('f70e3c36-33f9-45a7-ae45-ff2760f92a95', 2, 2, false, 10, 'Empfänger B', 'Abonnement 2', 30.00, NOW());
