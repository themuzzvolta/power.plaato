function Get-PlaatoAirlock {

    <#
        .NAME
        Get-PlaatoAirlock

        .SYNOPSIS
        Get current detail for PLAATO airlock

        .PARAMETERS
        authToken

        .INPUTS
        System.String

        .OUTPUTS
        System.Object

        .EXAMPLE
        Get-PlaatoAirlock -authToken $authToken

        .RELATED LINKS
        https://intercom.help/plaato/en/articles/5004721-pins-plaato-airlock

    #>

    [CmdletBinding()][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$authToken

    )
        
        Begin {

            $uri = "http://plaato.blynk.cc/${authToken}/get/"
    
            $header = @{
                'Content-Type' = 'application/json'
                'Accept-Encoding' = 'gzip, compress, br'
            }

            $pins = [ordered]@{

                bpm                 = 'v102'
                temperature         = 'v103'
                volume              = 'v104'
                original_gravity    = 'v105'
                specific_gravity    = 'v106'
                abv                 = 'v107'
                temperature_unit    = 'v108'
                volume_unit         = 'v109'
                bubbles             = 'v110'
                co2                 = 'v119'

            }
            
        }
    
        Process {
    
            try {
                
                $data = [ordered]@{}

                $pins.GetEnumerator() | ForEach-Object {

                    $params = @{
                            uri     = "$($uri)$($_.value)"
                            headers = $header
                            method  = 'GET'
                    }

                    $response = Invoke-RestMethod @params
                    $data[$_.key] = $($response)
 
                }

                return [psCustomObject]$data

            }

            catch [Exception]{

                throw

            }

        } 

        End {
    
        }

} 
