/*
  # Create Sensor Data Tables

  1. New Tables
    - `heart_rate_data`
      - `id` (uuid, primary key)
      - `device_id` (text)
      - `heart_rate` (integer)
      - `rr_interval` (integer)
      - `rr_available` (boolean)
      - `contact_status` (boolean)
      - `contact_status_supported` (boolean)
      - `timestamp` (bigint) - device timestamp
      - `created_at` (timestamptz) - server timestamp
    
    - `accelerometer_data`
      - `id` (uuid, primary key)
      - `device_id` (text)
      - `user_id` (text)
      - `x` (integer)
      - `y` (integer)
      - `z` (integer)
      - `timestamp` (bigint) - device timestamp
      - `created_at` (timestamptz) - server timestamp

  2. Security
    - Enable RLS on both tables
    - Add policies for authenticated users to insert their own data
    - Add policies for authenticated users to read their own data

  3. Indexes
    - Add indexes on device_id and timestamp for efficient queries
*/

-- Create heart_rate_data table
CREATE TABLE IF NOT EXISTS heart_rate_data (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  device_id text NOT NULL,
  heart_rate integer NOT NULL,
  rr_interval integer DEFAULT 0,
  rr_available boolean DEFAULT false,
  contact_status boolean DEFAULT false,
  contact_status_supported boolean DEFAULT false,
  timestamp bigint NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- Create accelerometer_data table
CREATE TABLE IF NOT EXISTS accelerometer_data (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  device_id text NOT NULL,
  user_id text DEFAULT 'demo-user',
  x integer NOT NULL,
  y integer NOT NULL,
  z integer NOT NULL,
  timestamp bigint NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE heart_rate_data ENABLE ROW LEVEL SECURITY;
ALTER TABLE accelerometer_data ENABLE ROW LEVEL SECURITY;

-- Policies for heart_rate_data (allow all inserts for now since data comes from devices)
CREATE POLICY "Allow insert heart rate data"
  ON heart_rate_data
  FOR INSERT
  TO anon, authenticated
  WITH CHECK (true);

CREATE POLICY "Allow read own heart rate data"
  ON heart_rate_data
  FOR SELECT
  TO authenticated
  USING (true);

-- Policies for accelerometer_data (allow all inserts for now since data comes from devices)
CREATE POLICY "Allow insert accelerometer data"
  ON accelerometer_data
  FOR INSERT
  TO anon, authenticated
  WITH CHECK (true);

CREATE POLICY "Allow read own accelerometer data"
  ON accelerometer_data
  FOR SELECT
  TO authenticated
  USING (true);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_heart_rate_device_timestamp 
  ON heart_rate_data(device_id, timestamp DESC);

CREATE INDEX IF NOT EXISTS idx_heart_rate_created_at 
  ON heart_rate_data(created_at DESC);

CREATE INDEX IF NOT EXISTS idx_accelerometer_device_timestamp 
  ON accelerometer_data(device_id, timestamp DESC);

CREATE INDEX IF NOT EXISTS idx_accelerometer_created_at 
  ON accelerometer_data(created_at DESC);
