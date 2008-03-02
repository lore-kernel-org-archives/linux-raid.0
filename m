From: Michael Guntsche <mike@it-loops.com>
Subject: Re: Setting up md-raid5: observations, errors, questions
Date: Sun, 2 Mar 2008 21:18:32 +0100
Message-ID: <0A9F05DB-D9AA-4EF7-B313-C2C332CEE2F0@it-loops.com>
References: <bb145bd20803020423m14efea1by6e3e38bb8d0decb8@mail.gmail.com> <20080302134836.GB20333@cthulhu.home.robinhill.me.uk> <bb145bd20803020617i77113488h53ead5af3b10e48@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v753)
Content-Type: multipart/signed; micalg=sha1; boundary=Apple-Mail-1-696129998; protocol="application/pkcs7-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <bb145bd20803020617i77113488h53ead5af3b10e48@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--Apple-Mail-1-696129998
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=US-ASCII;
	delsp=yes;
	format=flowed


On Mar 2, 2008, at 15:17, Christian Pernegger wrote:

>> - the array does not continue to sync to the "spare" created during
> array creation automagically, it just sits there:
>
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> [raid4] [raid10]
> md0 : active raid5 sdb[0] sde[4] sdd[2] sdc[1]
>       2930285568 blocks super 1.0 level 5, 1024k chunk, algorithm 2  
> [4/3] [UUU_]
>       bitmap: 3/466 pages [12KB], 1024KB chunk
>

Are you by any chance running of an initramfs? If you do, then please  
check
/sys/module/md_mod/parameters/start_ro. The mdadm hook scripts, at  
least in debian unstable set, this to
1 resulting in stopped automatic resync.


> P. S: BTW, mdadm segfaults at the end of --assemble, too
> mdadm[3635]: segfault at 0000000000000000 rip 0000000000412d2c rsp
> 00007fffd6f371f0 error 4

I did not have a problem at --assemble but in my case --monitor just  
segfaulted during startup so this may be the same problem.
Check if you have ARRAY entries in your /etc/mdadm/mdadm.conf, if yes  
make sure they represent your current configuration.
If there are no entries or if you are not sure if they are for your  
current setup delete them and  call mdadm-startall afterwards so they  
get recreated. ALSO update your initramfs so that the new config file  
gets used. This fixed the segfaults for me.

Kind regards,
Michael


--Apple-Mail-1-696129998
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
AW8wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMDgwMzAyMjAxODMz
WjAjBgkqhkiG9w0BCQQxFgQU4y2oybrWybiFlL1kLv3ynqnigtgwgYUGCSsGAQQBgjcQBDF4MHYw
YjELMAkGA1UEBhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAq
BgNVBAMTI1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBAhAXeGafW9tpYlIyv1f3
vGU1MIGHBgsqhkiG9w0BCRACCzF4oHYwYjELMAkGA1UEBhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBD
b25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJ
c3N1aW5nIENBAhAXeGafW9tpYlIyv1f3vGU1MA0GCSqGSIb3DQEBAQUABIIBABYGkFR0TNWVxJ3I
/vBDaCogtLwzmIGQEJyg2pX/saN5UhHLhCMjGWGFnwmY5L4e3RxR87vaD5+XN+Eg4ZEA3Pzz/0hz
4Sp8O4htVLOxWgRVb+UTkngkjXSuZhkW4pnO0OZhNModYNQpfbAB+L8R17UZsdkqwSgWTvW+d9i+
IoiM9ga0OAIjYp4gQ8fDCgvKRg38f2+y1zQL8/pkQ0A0SI5k/isjtvWOpHbgZzMBvLUYWZbC05Em
CbB7+tL1a9goy0+Gncp5vKUbkJPOk4gjB7F4G/mTmt4IUqrMY+VQx1610Q21d1eQHPNjM0EHJcxe
zHDgn8u/pICQz2tTDz5t7kUAAAAAAAA=

--Apple-Mail-1-696129998--
