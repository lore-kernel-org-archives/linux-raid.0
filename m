From: Michael Guntsche <mike@it-loops.com>
Subject: Re: Severe slowdown with LVM on RAID, alignment problem?
Date: Sat, 1 Mar 2008 22:26:14 +0100
Message-ID: <84E2E8E9-9E43-497E-9680-CC0377A8BEDF@it-loops.com>
References: <872d9b69db95a1b08319e935595743cc@localhost> <47C7E086.5080203@rabbit.us> <47C9C086.4020805@tmr.com>
Mime-Version: 1.0 (Apple Message framework v753)
Content-Type: multipart/signed; micalg=sha1; boundary=Apple-Mail-3-613791725; protocol="application/pkcs7-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47C9C086.4020805@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--Apple-Mail-3-613791725
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=US-ASCII;
	delsp=yes;
	format=flowed


On Mar 1, 2008, at 21:45, Bill Davidsen wrote:

>> blockdev --setra 65536 <your lv device>
>>
>> and run the tests again. You are almost certainly going to get the  
>> results you are after.
>
> I will just comment that really large readahead values may cause  
> significant memory usage and transfer of unused data. My  
> observations and some posts indicate that very large readahead and/ 
> or chunk size may reduce random access performance. I believe you  
> said you had 512MB RAM, that may be a factor as well.
>

I did not set such a large read-ahead. I had a look at the md0 device  
which had a value of 3072 and set this on the LV device as well.  
Performance really improved after this.

>
> Unless you are planning to use this machine mainly for running  
> benchmarks, I would tune it for your actual load and a bit of worst  
> case avoidance.
>

The last part is exactly what I am aiming at right now.
I tried to keep my changes to a bare minimum.

* Change chunk size to 256K
* Align the physical extent of the LVM to it
* Use the same parameters for mkfs.xfs that are choosen autmatically  
by mkfs.xfs if called on the md0 device itself.

* Set the read-ahead of the LVM block device to the same value as the  
md0 device
* Change the stripe_cache_size to 2048


With these settings applied to my setup here, RAID+XFS and RAID+LVM 
+XFS perform nearly identical and that was my goal from the beginning.

Now I am off to figure out what's happening during the initial  
rebuild of the RAID-5 but see my other mail for this.

Once again, thank you all for your valuable input and support.

Kind regards,
Michael
--Apple-Mail-3-613791725
Content-Transfer-Encoding: base64
Content-Type: application/pkcs7-signature;
	name=smime.p7s
Content-Disposition: attachment;
	filename=smime.p7s

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIGIzCCAtww
ggJFoAMCAQICEBd4Zp9b22liUjK/V/e8ZTUwDQYJKoZIhvcNAQEFBQAwYjELMAkGA1UEBhMCWkEx
JTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQ
ZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBMB4XDTA3MTAzMTE2MDMwMVoXDTA4MTAzMDE2MDMw
MVowQzEfMB0GA1UEAxMWVGhhd3RlIEZyZWVtYWlsIE1lbWJlcjEgMB4GCSqGSIb3DQEJARYRbWlr
ZUBpdC1sb29wcy5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC/D9ePLG2ZNk/Z
NXTRfUq7Rs+3k5M/nqmZ8riQYRnt8sCTj6o/fPS4qjaDf9jRfgbxViROiShFWMoBNJkKg91doJFk
FYdive8ujFfKpPR6FVGu8rN/sHUZM/gowZUcqDyIMAJVr7iiWhQYxP3U4hmprJsmUaGkjBU37Bcw
vJnEZ4gDCgYiZLiHUACDDfsl2xl5r6XvtXV9TsjWA3eQSeju68nQFP0PjFU+UtYfr3z1nFMJpuzE
xStjCEZ+EkYBOHK+RmBaOLEfF2Rq8175oaX5ScotY61s7wjADYesS//bvdcZ11jf/R+UCE90p8iC
Y1TjqqRv+zMc+VpyfG1dt9ELAgMBAAGjLjAsMBwGA1UdEQQVMBOBEW1pa2VAaXQtbG9vcHMuY29t
MAwGA1UdEwEB/wQCMAAwDQYJKoZIhvcNAQEFBQADgYEAgVh3S3v4j1ydxqgc/DWXcO5RRnyfLTjU
bJwYwTdaQVuykeXrT+2ITDIpOpVEqZ7xV/N9aKMM/izyQ8oMvw/J13TUm1N77kNCp5jYy1S+Ntuz
bCdOdFVA5tFVn/nMfmK1Is6NjK+0GmryYPEpn8vaP9ZGy57wCpKZrwmytgm3oPQwggM/MIICqKAD
AgECAgENMA0GCSqGSIb3DQEBBQUAMIHRMQswCQYDVQQGEwJaQTEVMBMGA1UECBMMV2VzdGVybiBD
YXBlMRIwEAYDVQQHEwlDYXBlIFRvd24xGjAYBgNVBAoTEVRoYXd0ZSBDb25zdWx0aW5nMSgwJgYD
VQQLEx9DZXJ0aWZpY2F0aW9uIFNlcnZpY2VzIERpdmlzaW9uMSQwIgYDVQQDExtUaGF3dGUgUGVy
c29uYWwgRnJlZW1haWwgQ0ExKzApBgkqhkiG9w0BCQEWHHBlcnNvbmFsLWZyZWVtYWlsQHRoYXd0
ZS5jb20wHhcNMDMwNzE3MDAwMDAwWhcNMTMwNzE2MjM1OTU5WjBiMQswCQYDVQQGEwJaQTElMCMG
A1UEChMcVGhhd3RlIENvbnN1bHRpbmcgKFB0eSkgTHRkLjEsMCoGA1UEAxMjVGhhd3RlIFBlcnNv
bmFsIEZyZWVtYWlsIElzc3VpbmcgQ0EwgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBAMSmPFVz
VftOucqZWh5owHUEcJ3f6f+jHuy9zfVb8hp2vX8MOmHyv1HOAdTlUAow1wJjWiyJFXCO3cnwK4Va
qj9xVsuvPAsH5/EfkTYkKhPPK9Xzgnc9A74r/rsYPge/QIACZNenprufZdHFKlSFD0gEf6e20Txh
BEAeZBlyYLf7AgMBAAGjgZQwgZEwEgYDVR0TAQH/BAgwBgEB/wIBADBDBgNVHR8EPDA6MDigNqA0
hjJodHRwOi8vY3JsLnRoYXd0ZS5jb20vVGhhd3RlUGVyc29uYWxGcmVlbWFpbENBLmNybDALBgNV
HQ8EBAMCAQYwKQYDVR0RBCIwIKQeMBwxGjAYBgNVBAMTEVByaXZhdGVMYWJlbDItMTM4MA0GCSqG
SIb3DQEBBQUAA4GBAEiM0VCD6gsuzA2jZqxnD3+vrL7CF6FDlpSdf0whuPg2H6otnzYvwPQcUCCT
cDz9reFhYsPZOhl+hLGZGwDFGguCdJ4lUJRix9sncVcljd2pnDmOjCBPZV+V2vf3h9bGCE6u9uo0
5RAaWzVNd+NWIXiC3CEZNd4ksdMdRv9dX2VPMYIDEDCCAwwCAQEwdjBiMQswCQYDVQQGEwJaQTEl
MCMGA1UEChMcVGhhd3RlIENvbnN1bHRpbmcgKFB0eSkgTHRkLjEsMCoGA1UEAxMjVGhhd3RlIFBl
cnNvbmFsIEZyZWVtYWlsIElzc3VpbmcgQ0ECEBd4Zp9b22liUjK/V/e8ZTUwCQYFKw4DAhoFAKCC
AW8wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMDgwMzAxMjEyNjE1
WjAjBgkqhkiG9w0BCQQxFgQUsiKjFljtB3WdOY5UVocvGd2yUXwwgYUGCSsGAQQBgjcQBDF4MHYw
YjELMAkGA1UEBhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAq
BgNVBAMTI1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBAhAXeGafW9tpYlIyv1f3
vGU1MIGHBgsqhkiG9w0BCRACCzF4oHYwYjELMAkGA1UEBhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBD
b25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJ
c3N1aW5nIENBAhAXeGafW9tpYlIyv1f3vGU1MA0GCSqGSIb3DQEBAQUABIIBALlVGyYxmwx/L8eH
FSBxBKLiISc/6Zn3xQQ+BmdCP5x2PMvsOru+hrrkRrR75UAh7JqlaVnAFEh7cerfVsm/ruXiWJ83
4oCEoIzEyGHy8gogFCEIEtIQ8+51hsgk6tcPUiEtJHsIkSsJrvI8am3TwXpJuOvU8Eti8FVkHQPs
NEkC2z+vJ4u6M5HVkBKtqojKHzBh7zkz14h/xfVQ3rwzUA23vqn6A+yIUBPl3djEYs86vBGt6bNG
a9e/zsGs8K/CYGMBt4vC0rdQtFDsxZ9TLZyqP5T7wGpxz40xMH5zBeRi/apiBtfhJvZxSVyrZEZa
whAV8qmhJi38/i7Qtb9yQqkAAAAAAAA=

--Apple-Mail-3-613791725--
