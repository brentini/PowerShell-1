﻿function New-DjoinFile
{
    <#
    .SYNOPSIS
        Function to generate a blob file accepted by djoin.exe tool (offline domain join)
    
	.DESCRIPTION
        Function to generate a blob file accepted by djoin.exe tool (offline domain join)
	
		This function can create a file compatible with djoin with the Blob initially provisionned.
	
	.PARAMETER Blob
		Specifies the blob generated by djoin
	
	.PARAMETER DestinationFile
		Specifies the full path of the file that will be created
	
		Default is c:\temp\djoin.tmp
    
	.EXAMPLE
        New-DjoinFile -Hash $hash -DestinationFile C:\temp\test.tmp
    
	.NOTES
        Francois-Xavier.Cat
        LazyWinAdmin.com
        @lazywinadm
        github.com/lazywinadmin
    
	.LINK
        https://msdn.microsoft.com/en-us/library/system.io.fileinfo(v=vs.110).aspx
    #>
	[Cmdletbinding()]
	PARAM (
		[Parameter(Mandatory = $true)]
		[System.String]$Blob,
		[Parameter(Mandatory = $true)]
		[System.IO.FileInfo]$DestinationFile = "c:\temp\djoin.tmp"
	)
	
	PROCESS
	{
		TRY
		{
			# Create a byte object
			$bytechain = New-Object -TypeName byte[] -ArgumentList 2
			# Add the first two character for Unicode Encoding
			$bytechain[0] = 255
			$bytechain[1] = 254
			
			# Creates a write-only FileStream
			$FileStream = $DestinationFile.Openwrite()
			
			# Append Hash as byte
			$bytechain += [System.Text.Encoding]::unicode.GetBytes($Blob)
			# Append two extra 0 bytes characters
			$bytechain += 0
			$bytechain += 0
			
			# Write back to the file
			$FileStream.write($bytechain, 0, $bytechain.Length)
			
			# Close the file Stream
			$FileStream.Close()
		}
		CATCH
		{
			$Error[0]
		}
	}
}