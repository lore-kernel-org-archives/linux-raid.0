From: Michael Guntsche <mike@it-loops.com>
Subject: Re: LVM performance
Date: Mon, 10 Mar 2008 02:21:06 +0100
Message-ID: <953393E4-D918-4854-B5D6-07A2D738D6B0@it-loops.com>
References: <aebf5d970802161958x17a9da92r25663703dc0df05f@mail.gmail.com>	<18360.8065.335494.142060@tree.ty.sabi.co.UK>	<20080217074526.29d3c5c5@hardcode42.net>	<20080218062604.05ae4821@szpak>	<aebf5d970802180438w7a4d40ban3f66ee1dbc38d259@mail.gmail.com>	<20080218154203.6e2d1483@szpak>	<47BB30DF.1080006@student.tuwien.ac.at>	<18364.6868.854623.613958@tree.ty.sabi.co.UK>	<47BED119.4070000@student.tuwien.ac.at> <18384.63840.605334.155518@tree.ty.sabi.co.UK> <47D440D6.90509@student.tuwien.ac.at> <8D0FC34E-F0B0-4BAF-A466-2C8BC439E7FF@it-loops.com> <47D47264.4070404@student.tuwien.ac.at> <47D4819E.5010807@sauce.co.nz> <7F70AB26-25B7-4127-A3A9-62D104B7A80F@it-loops.com> <47D4880F.8050309@sauce.co.nz>
Mime-Version: 1.0 (Apple Message framework v919.2)
Content-Type: multipart/signed; boundary=Apple-Mail-1--828400324; micalg=sha1; protocol="application/pkcs7-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47D4880F.8050309@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--Apple-Mail-1--828400324
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit


On Mar 10, 2008, at 1:59, Richard Scobie wrote:

>
> When a filesystem is created on a logical volume device, mkfs.xfs  
> will automatically query the logical volume for appropriate sunit  
> and swidth values."


If it is a "striped" logical volume it will do that, but since you are  
creating the LVM on ONE PV namely the md device itself  there will be  
no way for the LVM to stripe it.
Of course you could create two MDs and create a LVM stripe acroos  
those too, but I do not think there is any benefit in that.

Kind regards,
Michael
--Apple-Mail-1--828400324
Content-Disposition: attachment;
	filename=smime.p7s
Content-Type: application/pkcs7-signature;
	name=smime.p7s
Content-Transfer-Encoding: base64

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
AW8wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMDgwMzEwMDEyMTA2
WjAjBgkqhkiG9w0BCQQxFgQUPLgVO7VixmfO8tQwzM+glOOg6oQwgYUGCSsGAQQBgjcQBDF4MHYw
YjELMAkGA1UEBhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAq
BgNVBAMTI1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBAhAXeGafW9tpYlIyv1f3
vGU1MIGHBgsqhkiG9w0BCRACCzF4oHYwYjELMAkGA1UEBhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBD
b25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJ
c3N1aW5nIENBAhAXeGafW9tpYlIyv1f3vGU1MA0GCSqGSIb3DQEBAQUABIIBAHS7oYRJRdv7/ba0
gfPamKypg0Zu3Utac4r7webgztC0e7fbPgHsEMrFkzfHVyEqWZRU5H4rs3RSSQn6sh6Go9qZTtxX
Mb2ImIv6LAyq52HSe8MECIVAFrF2/uT7mzRGHAEkKhjd6yNtuBkOIz0as5/BTPqihZqvmz5641MA
UNzFqiPRcCW+7eQGKOffD+qRkG3iFla3IhNRuq57NoQ9b0Hnzb4lBDZEitkD20St+PBNjzrpgsFm
MU7DBv49+RMTc2jq5mLa3rEjWSDbWp98nsDFp3Me1TsLJYNGRCQKwG1o9CPDoO1/Qj0dsrphS0+G
rjIuFRj9LAZV1WV2HAYDtl0AAAAAAAA=

--Apple-Mail-1--828400324--
