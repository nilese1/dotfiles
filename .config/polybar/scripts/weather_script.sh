#!/bin/bash

# Get your zip code automatically
TOKEN_PATH="$HOME/.config/polybar/scripts/api-token"
ZIP_API_TOKEN=$(cat "$TOKEN_PATH")
ZIP_CODE="$(curl -sH "Authorization: Bearer $ZIP_API_TOKEN" https://ipinfo.io/postal)"

# Fetch the weather data
WEATHER_JSON=$(curl -s "https://wttr.in/${ZIP_CODE}?format=j1")

# Use jq to parse the JSON and extract fields
QUOTES_TEMP_C=$(echo "$WEATHER_JSON" | jq '.current_condition[0].temp_F')
WEATHER_DESC=$(echo "$WEATHER_JSON" | jq -r '.current_condition[0].weatherDesc[0].value')

# Function to assign an emoji to a weather condition
get_weather_emoji() {
    local desc="$1"
    case "$desc" in
        "Sunny") echo "☀️" ;;
        "Clear") echo "🌙" ;;
        "Partly cloudy") echo "⛅️" ;;
        "Cloudy"|"Overcast") echo "☁️" ;;
        "Mist") echo "🌫️" ;;
        "Patchy rain possible"|"Light rain shower"|"Light rain") echo "🌦️" ;;
        "Thundery outbreaks possible") echo "⛈️" ;;
        "Blowing snow"|"Blizzard"|"Patchy snow possible"|"Patchy sleet possible"|"Light snow showers") echo "🌨️" ;;
        "Fog"|"Freezing fog") echo "🌁" ;;
        "Patchy light drizzle"|"Light drizzle") echo "🌧️" ;;
        "Heavy rain"|"Heavy rain at times"|"Moderate rain"|"Moderate rain at times") echo "🌧️" ;;
        "Moderate or heavy snow showers"|"Heavy snow"|"Patchy heavy snow"|"Moderate snow"|"Patchy moderate snow") echo "❄️" ;;
        "Moderate or heavy sleet showers"|"Light sleet showers"|"Light sleet") echo "🌨️" ;;
        "Moderate or heavy rain shower") echo "🌧️" ;;
        "Torrential rain shower") echo "🌊" ;;
        "Patchy light rain with thunder"|"Moderate or heavy rain with thunder") echo "⛈️" ;;
        "Patchy light snow with thunder"|"Moderate or heavy snow with thunder") echo "⛈️❄️" ;;
        *) echo "❓" ;;
    esac
}

remove_quotes() {
    echo "$1" | tr -d '"'
}

# Get the emoji for the current weather condition
WEATHER_EMOJI=$(get_weather_emoji "$WEATHER_DESC")
TEMP_C=$(remove_quotes "$QUOTES_TEMP_C")

# Output the weather emoji and temperature
echo "${WEATHER_EMOJI} ${TEMP_C}°F"
