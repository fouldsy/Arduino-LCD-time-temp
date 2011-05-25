#include <Wire.h>
#include <LiquidCrystal.h>
#include <RTClib.h>

RTC_DS1307 RTC;

int sensorPin = 0;      // Set our temperature sensor pin
LiquidCrystal lcd(0);   // Initialize our LCD

void setup () {
  lcd.begin(16, 2);      // Set up LCD as 16x2 screen

  Wire.begin();          // Start our wire and real time clock
  RTC.begin();
  
  if (! RTC.isrunning()) {                       // Make sure RTC is running
    Serial.println("RTC is NOT running!");
    //RTC.adjust(DateTime(__DATE__, __TIME__));  // Uncomment to set the date and time
  }
}

void loop () {
  
  DateTime now = RTC.now();  // Read in what our current datestamp is from RTC
  
  int reading = analogRead(sensorPin);                   // Read in value from our temp sensor
  
  float voltage = reading * (5.0 / 1024.0);              // Calculate the voltage
  float temperatureC = (voltage - 0.5) * 100;            // Calculate degrees celsius
  float temperatureF = (temperatureC * 9.0 / 5.0) + 32;  // Convert to degrees farenheit
  
  lcd.clear();                            // Clear the LCD screen
  if (now.hour() < 10) lcd.print("0");    // Check if we need to add leading zero
  lcd.print(now.hour(), DEC);             // Output current hour
  lcd.print(":");
  if (now.minute() < 10) lcd.print("0");  // Check if we need to add leading zero
  lcd.print(now.minute(), DEC);           // Output current minute
  lcd.print(":");
  if (now.second() < 10) lcd.print("0");  // Check if we need to add leading zero
  lcd.print(now.second(), DEC);           // Output current second
  
  lcd.setCursor(0, 1);      // Move cursor to our second line
  lcd.print(temperatureC);  // Output the temp in celsius
  lcd.print((char)223);     // Output the degrees character
  lcd.print("C ");
  lcd.print(temperatureF);  // Output the temp in farenheit
  lcd.print((char)223);     // Output the degrees character
  lcd.print("F");
  
  delay(5000);    // Wait 5 seconds before looping
}
