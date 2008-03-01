From: Michael Guntsche <mike@it-loops.com>
Subject: Re: Strange RAID-5 rebuild problem
Date: Sat, 1 Mar 2008 23:41:02 +0100
Message-ID: <2BABB51E-7701-44D4-AD07-6394CCF77941@it-loops.com>
References: <656D8E57-804D-4A63-B9CA-D3C899616F61@it-loops.com> <3816592D-B75C-4B00-B3B7-65AE3B403DB0@it-loops.com> <20080301222326.GA20435@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0 (Apple Message framework v753)
Content-Type: multipart/signed; micalg=sha1; boundary=Apple-Mail-1-618279212; protocol="application/pkcs7-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080301222326.GA20435@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Robin Hill <robin@robinhill.me.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--Apple-Mail-1-618279212
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=US-ASCII;
	delsp=yes;
	format=flowed

	
On Mar 1, 2008, at 23:23, Robin Hill wrote:

> It's started up in read-only mode (which is the safe option - it
> prevents any accidental damage).  It should switch to write mode (and
> start syncing) when it's mounted.  You can also force the mode change
> using 'mdadm -w /dev/md1'.
>

mdadm -w /dev/md1 works if I call it after assembling.
If do not call it, mount the array and start writing to it, it  
changes to "active"
but the rebuild process does not kick in.

The only way it works for me now is.
* Stop the array
* assemble it again with mdadm --assemble --scan
* Call mdadm -w /dev/md1
--Apple-Mail-1-618279212
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
AW8wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMDgwMzAxMjI0MTAy
WjAjBgkqhkiG9w0BCQQxFgQUK4wheOpGds2V3sqHdAV87JlN8uYwgYUGCSsGAQQBgjcQBDF4MHYw
YjELMAkGA1UEBhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAq
BgNVBAMTI1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBAhAXeGafW9tpYlIyv1f3
vGU1MIGHBgsqhkiG9w0BCRACCzF4oHYwYjELMAkGA1UEBhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBD
b25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJ
c3N1aW5nIENBAhAXeGafW9tpYlIyv1f3vGU1MA0GCSqGSIb3DQEBAQUABIIBALXOFHBru8Fznm7a
VsdNUt7ckMTi5LYVS08jlw41DbdaeuD/UsHVk6Kf+XUuDX3pdppf/nVWXIPMh//u60zjddbyf76o
Kx6o1OBXWBKHgN90ueaxIXLK7Bho3hsSCqM7DvMGARz7kZQpv3/nLsucecM/NW/O9ADm0lr3coog
NQn/uFNplHJ31QO5OzoM7vlo+3HH1zaz5JQiYyuy8fBssfWbVSv+FlwusvSf/C7x1YJUXN2jfY5g
kQboSSj2VMy6l3e4xG/MpPLR58HWpF4UjyVIP7fhpn5nXIXYu6YMa25K+FxCh0FObouNbbcfTwLn
42OTUPNjmhkAuo0AG8WaBbAAAAAAAAA=

--Apple-Mail-1-618279212--
