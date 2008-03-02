From: Michael Guntsche <mike@it-loops.com>
Subject: Re: Strange RAID-5 rebuild problem
Date: Sun, 2 Mar 2008 11:20:58 +0100
Message-ID: <0D90EC1B-DE2A-4A9B-A63C-323838FF937A@it-loops.com>
References: <656D8E57-804D-4A63-B9CA-D3C899616F61@it-loops.com> <3816592D-B75C-4B00-B3B7-65AE3B403DB0@it-loops.com> <20080301222326.GA20435@cthulhu.home.robinhill.me.uk> <2BABB51E-7701-44D4-AD07-6394CCF77941@it-loops.com> <A5F6B52A-00BB-4096-9A8D-367F61989186@it-loops.com> <244F7F54-081B-462E-A0AD-8E5E1056B90B@it-loops.com> <47CA7CE0.9050702@msgid.tls.msk.ru>
Mime-Version: 1.0 (Apple Message framework v753)
Content-Type: multipart/signed; micalg=sha1; boundary=Apple-Mail-1-660275813; protocol="application/pkcs7-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47CA7CE0.9050702@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-raid@vger.kernel.org, Robin Hill <robin@robinhill.me.uk>
List-Id: linux-raid.ids


--Apple-Mail-1-660275813
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=UTF-8;
	delsp=yes;
	format=flowed


On Mar 2, 2008, at 11:09, Michael Tokarev wrote:

> Michael Guntsche wrote:
> []
>> Answering myself here after reading through the manapges, this =20
>> seems to be a regression. Furthermore this may yield to some nasty =20=

>> data corruption, well at least I think it will.
>> * --stop the array while resyncing.
>> * set start_ro to 1
>> * Start the array, automatic reconstruction does not start even =20
>> after the data is been written to the ARRAY
>
> You can't write any data to a read-only array.
>

 =46rom the manpage:

md_mod.start_ro=3D1
This  tells  md  to start all arrays in read-only mode.  This is a =20
soft read-only
that will automatically switch to read-write on the first write =20
request.  However
until that write request, nothing is written to any device by md, and =20=

in particu=E2=80=90
lar, no resync or recovery operation is started.

So apparently it does switch to read-write on the first write =20
request, but the rebuild is not continuing.

Kind regards,
Michael


--Apple-Mail-1-660275813
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
AW8wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMDgwMzAyMTAyMDU5
WjAjBgkqhkiG9w0BCQQxFgQUv6fi8ITnYN0XBfinytfHRCpZAW4wgYUGCSsGAQQBgjcQBDF4MHYw
YjELMAkGA1UEBhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAq
BgNVBAMTI1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBAhAXeGafW9tpYlIyv1f3
vGU1MIGHBgsqhkiG9w0BCRACCzF4oHYwYjELMAkGA1UEBhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBD
b25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJ
c3N1aW5nIENBAhAXeGafW9tpYlIyv1f3vGU1MA0GCSqGSIb3DQEBAQUABIIBAK76aLu5rGekgZwv
4ci4dknyDfm819i5ejbFDlrIUAXYK+OY5miwkyPGPWMXPe6JpVA+EYYHYgvSsBpqn3vvzBFRTa2m
leqB+ey4wQCaDC52u9CFchtxgHqMcmAw92aq2Jt70McbOpN+cH6K/1kill7IKvi1muYEDHAS2Jk1
yAoq+jFCONwNgmNEoUa/S4aORVHxV/bLnSXAtFBLUdqnA5h6VWvv8t5y1f6sekcysSy//1quet9j
QJBv1jZx56xT7gxkmlITG8LcVZa5lZC8f7AOhQyD/ZOzMYjkrnkcNGSOxxWfLcSDItfVOnouhfs1
0zvgQ/GKDmggf6CSe5vO3LkAAAAAAAA=

--Apple-Mail-1-660275813--
