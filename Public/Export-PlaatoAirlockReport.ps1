function Export-PlaatoAirlockReport {

    <#
        .NAME
        Export-PlaatoAirlockReport

        .SYNOPSIS
        Export PLAATO Airlock compressed *.gz report

        .PARAMETERS
        authToken, metric, path

        .INPUTS
        System.String

        .OUTPUTS
        System.String

        .EXAMPLE
        Export-PlaatoAirlockReport -authToken $authToken -metric $metric -path $path

        .RELATED LINKS
        https://intercom.help/plaato/en/articles/5004724-get-history-data

    #>

    [CmdletBinding()][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string]$authToken,

        [Parameter(Mandatory=$true)]
        [ValidateSet('bpm','temperature','specific_gravity')]
        [string]$metric,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string]$path

    )
        
        Begin {

            $uri = "http://plaato.blynk.cc/${authToken}/data/"
    
            $header = @{
                'Content-Type' = 'application/json'
                'Accept-Encoding' = 'gzip, compress, br'
            }
            
            $pins = [ordered]@{

                bpm                 = 'v102'
                temperature         = 'v103'
                specific_gravity    = 'v106'

            }

            $webObj = New-Object System.Net.WebClient
            
        }
    
        Process {
    
            try {
                     
                $reqUri = "$($uri)$($pins[$metric])"

                if (!$path) {
                        
                    $params = @{
                        uri     = $reqUri
                        headers = $header
                        method  = 'GET'
                    }
                        
                    $response = Invoke-Webrequest @params
                    $path = "$($env:HOMEPATH)$($response.BaseResponse.ResponseUri.LocalPath)"
                    ($webObj).DownloadFile($reqUri, $path)

                    Write-Host "Downloading historical $($metric) data to $($path)" -ForegroundColor Green

                }

                else { ($webObj).DownloadFile($uri, $path) }

            }

            catch [Exception]{

                throw

            }

        } 

        End {
    
        }

}
