$OPENWEATHER_API_KEY = ""

$ciudades = @(
    @{ Nombre = "Madrid";     Lat = "40.4168"; Lon = "-3.7038" },
    @{ Nombre = "Navalmoral de la Mata";  Lat = "39.9369387"; Lon = "-5.5620179" },
    @{ Nombre = "Cáceres";   Lat = "39.4282320"; Lon = "-6.4378180" }
)


$resultados = @()

foreach ($ciudad in $ciudades) {
    $uri = "https://api.openweathermap.org/data/2.5/weather?lat=$($ciudad.Lat)&lon=$($ciudad.Lon)&appid=$OPENWEATHER_API_KEY&units=metric&lang=es"
    
    Write-Host "Consultando: $($ciudad.Nombre) - $uri"

    try {
        $response = Invoke-RestMethod -Uri $uri

        if ($response.name) {
            $resultados += [PSCustomObject]@{
                Ciudad     = $response.name
                Temperatura = $response.main.temp
                Clima       = $response.weather[0].description
                Humedad     = $response.main.humidity
                Viento_kmh  = [math]::Round($response.wind.speed * 3.6, 2)
            }
        } else {
            Write-Host "No se encontró información el tiempo para: $($ciudad.Nombre)"
        }
    } catch {
        Write-Host "Error obteniendo datos para: $($ciudad.Nombre)"
    }
}
 
$resultados | Export-Csv -Path ".\tiempo_ciudades.csv" -NoTypeInformation -Encoding UTF8

Write-Host "CSV generado con los datos del tiempo."
