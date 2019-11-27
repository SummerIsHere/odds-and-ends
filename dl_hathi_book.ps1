# dl_HO208.sh
# Windows PowerShell Script
# This code will download a book from the Hathi Trust to the current directory as a series of pdf files, one per page
# After a failed download, the script will wait and retry a few times, but is relatively rough, results not guaranteed
# Main site: https://www.hathitrust.org/

#A wrapper so that messages show up properly when code is copy/pasted
if(1 -eq 1){

#bid:		ID of the book to be downloaded
#bkprefix:	Prefix of the pdf files to be downloaded
#pagenum:	Number of pages in the book

<#
$bid="uc1.31822005668470";
$bkprefix="HO 208 Sixth Edition (UCSD)";
$pagenum = 120;

# HO 208 alternate
$bid="mdp.39015018437965"
$bkprefix="HO 208 Sixth Edition (UMich)";
$pagenum = 126;



# HO 211 Ageton Third Edition
$bid="mdp.39015018437908"
$bkprefix="HO 211 Ageton Third Edition (1943)"
$pagenum = 64


$bkprefix = "A Complete Set of Nautical Tables (Norie) 12th Edition (1848)"
$bid = "nyp.33433008137444"
$pagenum = 502

$bkprefix = "A new and complete epitome of practical navigation (Norie) 17th Edition (1860)"
$bid = "nyp.33433008137485"
$pagenum = 786
#>

<#
# HO 211 Ageton First Edition
$bid="umn.31951000497346w"
$bkprefix="HO 211 Ageton First Edition (1932)"
$pagenum = 52




$bkprefix = "A Complete Set of Nautical Tables (Norie) 2nd Edition (1810)"
$bid = "nyp.33433008137501"
$pagenum = 350

$bkprefix = "A Complete Set of Nautical Tables (Norie, 1803)"
$bid = "nyp.33433008137477"
$pagenum = 328

$bkprefix = "A new and complete epitome of practical navigation (Norie, 1805)"
$bid = "nyp.33433008138145"
$pagenum = 652

$bkprefix = "A new and complete epitome of practical navigation (Norie) 15th Edition (1852)"
$bid = "hvd.hn7uty"
$pagenum =780

$bkprefix = "A new and complete epitome of practical navigation (Norie) 14th Edition (1848)"
$bid = "njp.32101054772734"
$pagenum = 784


 #>


Write-Host (get-date).ToShortDateString() (get-date).ToShortTimeString()": CURRENT SETTINGS";
Write-Host (get-date).ToShortDateString() (get-date).ToShortTimeString()" - bid: $bid";
Write-Host (get-date).ToShortDateString() (get-date).ToShortTimeString()" - PDF Prefix: $bkprefix";
Write-Host (get-date).ToShortDateString() (get-date).ToShortTimeString()" - Num. of Pages: $pagenum";

#TODO: Add code that will detect the error message coming from a website so that we can automatically detect when we have downloaded the last page of a book
for ($i=1; $i -le $pagenum; $i++) {
	Write-Host (get-date).ToShortDateString() (get-date).ToShortTimeString()": Start of loop $i of $pagenum"
	
	#Set up number suffix $p with leading zeros to enable sorting of downloaded pdf files
	#To do: expand to three or four digits
	$p=''
	If($i -le 9){
		$p="00$i";
	} Elseif($i -le 99 -And $i -ge 10) {
		$p="0$i";
	} Else{
		$p=$i;
	}
	
	#Assign Parameters for this specific download
	$url="https://babel.hathitrust.org/cgi/imgsrv/download/pdf?id=$bid;orient=0;size=100;seq=$i;attachment=0";
	$pdf="$bkprefix $p.pdf";


	Write-Host (get-date).ToShortDateString() (get-date).ToShortTimeString()": Suffix for $i of $pagenum set as $p";
	Write-Host (get-date).ToShortDateString() (get-date).ToShortTimeString()": URL to be used is $url";
	
	# If the file is already there, skip to next one
	if([System.IO.File]::Exists("$pwd\$pdf")){
		Write-Host (get-date).ToShortDateString() (get-date).ToShortTimeString()": $pdf already exists, skipping...";
		continue;
	}

	Write-Host (get-date).ToShortDateString() (get-date).ToShortTimeString()": Waiting 15 seconds";
	Start-Sleep -s 15;
	
	$Stoploop = $false
	[int]$Retrycount = "0"
	do {
		Write-Host (get-date).ToShortDateString() (get-date).ToShortTimeString()": Start of do statement before try";
		try {
			Write-Host (get-date).ToShortDateString() (get-date).ToShortTimeString()": Attempting download";
			Invoke-WebRequest -OutFile $pdf -Uri $url;
			Write-Host (get-date).ToShortDateString() (get-date).ToShortTimeString()": Job completed for $pdf";
			$Stoploop = $true;
			}
		catch {
			if ($Retrycount -gt 3){
				Write-Host (get-date).ToShortDateString() (get-date).ToShortTimeString()": Could not download after $Retrycount retrys, moving on...";
				$Stoploop = $true;
			}
			else {
				#With each successive retry, double the waiting time before retrying
				$w = [math]::pow(2,$Retrycount)*60;
				Write-Host Write-Host (get-date).ToShortDateString() (get-date).ToShortTimeString()": Error:";
				Write-Host $error[0];
				Write-Host (get-date).ToShortDateString() (get-date).ToShortTimeString()": Could not download to $pdf, retrying in $w seconds...";
				Start-Sleep -s $w ;
				$Retrycount = $Retrycount + 1;
			}
		}
	}
	While ($Stoploop -eq $false);
	Write-Host (get-date).ToShortDateString() (get-date).ToShortTimeString()": Onwards to next i regardless of success"
}
Write-Host (get-date).ToShortDateString() (get-date).ToShortTimeString()": Finished! To combine pdfs together, use a program like pdfsam (has a free version): http://www.pdfsam.org/download-pdfsam-basic/";
Write-Host (get-date).ToShortDateString() (get-date).ToShortTimeString()": Just watch out for the installer including programs you don't want.";
}

