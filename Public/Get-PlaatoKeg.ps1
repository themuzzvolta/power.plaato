function Get-PlaatoKeg {

    <#
        .NAME
        Get-PlaatoKeg

        .SYNOPSIS
        Get current detail for PLAATO Keg

        .PARAMETERS
        authToken

        .INPUTS
        System.String

        .OUTPUTS
        System.Object

        .EXAMPLE
        Get-PlaatoKeg -authToken $authToken

        .RELATED LINKS
        https://intercom.help/plaato/en/articles/5004722-pins-plaato-keg

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

                pour                = 'v47'
                percent_beer_left   = 'v48'
                pouring             = 'v49'
                amount_left         = 'v51'
                raw_temperature     = 'v56'
                last_pour           = 'v59'
                empty_keg_weight    = 'v62'
                beer_style          = 'v64'
                original_gravity    = 'v65'
                final_gravity       = 'v66'
                keg_date            = 'v67'
                abv                 = 'v68'
                temp_with_unit      = 'v69'
                unit_type           = 'v71'
                mass_unit           = 'v73'
                beer_left_unit      = 'v74'
                measure_unit        = 'v75'
                max_keg_volume      = 'v76'
                wifi_strength       = 'v81'
                volume_unit         = 'v82'
                leak_detection      = 'v83'
                min_temperature     = 'v86'
                max_temperature     = 'v87'
                beer_co2_mode       = 'v88'
                scale_sensitivity   = 'v89'
                firmware_version    = 'v93'

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
