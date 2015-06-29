From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Subject: Re: [Bug 100491] New: Oops under bitmap_start_sync [md_mod] at boot
Date: Mon, 29 Jun 2015 08:28:24 -0400
Message-ID: <559139E8.9020008@gmail.com>
References: <12832_1435266173_558C6C7D_12832_48_1_bug-100491-1606@https.bugzilla.kernel.org/> <20150628205347.GA18403@sli.dy.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms020208050405080900030001"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150628205347.GA18403@sli.dy.fi>
Sender: linux-raid-owner@vger.kernel.org
To: Sami Liedes <sami.liedes@iki.fi>, Goldwyn Rodrigues <rgoldwyn@suse.com>, Neil Brown <neilb@suse.de>, bugzilla-daemon@bugzilla.kernel.org
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

This is a cryptographically signed message in MIME format.

--------------ms020208050405080900030001
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-06-28 16:53, Sami Liedes wrote:
> On Thu, Jun 25, 2015 at 09:02:45PM +0000, bugzilla-daemon@bugzilla.kern=
el.org wrote:
>> https://bugzilla.kernel.org/show_bug.cgi?id=3D100491
>>
>>              Bug ID: 100491
>>             Summary: Oops under bitmap_start_sync [md_mod] at boot
> [...]
>> Reading all physical valumes.  This may take a while...
>> Found volume group "rootvg" using metadata type lvm2
>> device-mapper: raid: Device 0 specified for rebuild: Clearing superblo=
ck
>> md/raid1:mdX: active with 1 out of 2 mirrors
>> mdX: invalid bitmap file superblock: bad magic
>> md-cluster module not found.
>> mdX: Could not setup cluster service (256)
>> BUG: unable to handle kernel NULL pointer dereference at 0000000000000=
100
>> IP: [<ffffffff8159e4a9>] _raw_spin_lock_irq+0x29/0x70
>> PGD 0
>> Oops: 0002 [#1] PREEMPT SMP
> [...]
>
> I'm marking this as a regression in bugzilla, since this seems to
> prevent booting on 4.1.0 at least in certain circumstances (namely
> those which I have; I wonder if any raid1 recovery works?) while 4.0.6
> boots correctly.
I can confirm having the same issue with the MD code being used through=20
dm-raid.
>
> I bisected this down to one of four commits. Well, assuming that the
> problem was caused by changes in drivers/md; a fair assumption, I
> think. The commits are:
>
> $ git bisect view --oneline
> f9209a3 bitmap_create returns bitmap pointer
> 96ae923 Gather on-going resync information of other nodes
> 54519c5 Lock bitmap while joining the cluster
> b97e9257 Use separate bitmaps for each nodes in the cluster
My own bisect turned up the same set of commits, although I wouldn't=20
have the time to go any further with it until next weekend.
>
> The crash happens whether or not CONFIG_MD_CLUSTER is enabled.
Again, same here.



--------------ms020208050405080900030001
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIGuDCC
BrQwggScoAMCAQICAxBuVTANBgkqhkiG9w0BAQ0FADB5MRAwDgYDVQQKEwdSb290IENBMR4w
HAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmlu
ZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZzAeFw0xNTAz
MjUxOTM0MzhaFw0xNTA5MjExOTM0MzhaMGMxGDAWBgNVBAMTD0NBY2VydCBXb1QgVXNlcjEj
MCEGCSqGSIb3DQEJARYUYWhmZXJyb2luN0BnbWFpbC5jb20xIjAgBgkqhkiG9w0BCQEWE2Fo
ZW1tZWxnQG9oaW9ndC5jb20wggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQCdD/zW
2rRAFCLnDfXpWxU1+ODqRVUgzHvrRO7ADUxRo1CBDc3JSX5TIW2OGmQ3DAKGOACp8Z0sgxMc
B05tzAZ/M7m4jajVrwwdVCdrwVGxTdAai7Kwg4ZCVfyMVhcwo8R2eW3QahBx34G0RKumK9sZ
ZQSQ+zULAzpY6uz7T1sAk/erMoivRXF6u8WvOsLkOD1F/Xyv1ZccSUG5YeDgZgc0nZUBvyIp
zXSHjgWerFkrxEM3y2z/Ff3eL1sgGYecV/I1F+I5S01V7Kclt/qRW10c/4JEGRcI1FmrJBPu
BtMYPbg/3Y9LZROYN+mVIFxZxOfrmjfFZ96xt/TaMXo8vcEKtWcNEjhGBjEbfMUEm4aq8ygQ
4MuEcpJc8DJCHBkg2KBk13DkbU2qNepTD6Uip1C+g+KMr0nd6KOJqSH27ZuNY4xqV4hIxFHp
ex0zY7mq6fV2o6sKBGQzRdI20FDYmNjsLJwjH6qJ8laxFphZnPRpBThmu0AjuBWE72GnI1oA
aO+bs92MQGJernt7hByCnDO82W/ykbVz+Ge3Sax8NY0m2Xdvp6WFDY/PjD9CdaJ9nwQGsUSa
N54lrZ2qMTeCI9Vauwf6U69BA42xgk65VvxvTNqji+tZ4aZbarZ7el2/QDHOb/rRwlCFplS/
z4l1f1nOrE6bnDl5RBJyW3zi74P6GwIDAQABo4IBWTCCAVUwDAYDVR0TAQH/BAIwADBWBglg
hkgBhvhCAQ0ESRZHVG8gZ2V0IHlvdXIgb3duIGNlcnRpZmljYXRlIGZvciBGUkVFIGhlYWQg
b3ZlciB0byBodHRwOi8vd3d3LkNBY2VydC5vcmcwDgYDVR0PAQH/BAQDAgOoMEAGA1UdJQQ5
MDcGCCsGAQUFBwMEBggrBgEFBQcDAgYKKwYBBAGCNwoDBAYKKwYBBAGCNwoDAwYJYIZIAYb4
QgQBMDIGCCsGAQUFBwEBBCYwJDAiBggrBgEFBQcwAYYWaHR0cDovL29jc3AuY2FjZXJ0Lm9y
ZzAxBgNVHR8EKjAoMCagJKAihiBodHRwOi8vY3JsLmNhY2VydC5vcmcvcmV2b2tlLmNybDA0
BgNVHREELTArgRRhaGZlcnJvaW43QGdtYWlsLmNvbYETYWhlbW1lbGdAb2hpb2d0LmNvbTAN
BgkqhkiG9w0BAQ0FAAOCAgEAGvl7xb42JMRH5D/vCIDYvFY3dR2FPd5kmOqpKU/fvQ8ovmJa
p5N/FDrsCL+YdslxPY+AAn78PYmL5pFHTdRadT++07DPIMtQyy2qd+XRmz6zP8Il7vGcEDmO
WmMLYMq4xV9s/N7t7JJp6ftdIYUcoTVChUgilDaRWMLidtslCdRsBVfUjPb1bF5Ua31diKDP
e0M9/e2CU36rbcTtiNCXhptMigzuL3zJXUf2B9jyUV8pnqNEQH36fqJ7YTBLcpq3aYa2XbAH
Hgx9GehJBIqwspDmhPCFZ/QmqUXCkt+XfvinQ2NzKR6P3+OdYbwqzVX8BdMeojh7Ig8x/nIx
mQ+/ufstL1ZYp0bg13fyK/hPYSIBpayaC76vzWovkIm70DIDRIFLi20p/qTd7rfDYy831Hjm
+lDdCECF9bIXEWFk33kA97dgQIMbf5chEmlFg8S0e4iw7LMjvRqMX3eCD8GJ2+oqyZUwzZxy
S0Mx+rBld5rrN7LsXwZ671HsGqNeYbYeU25e7t7/Gcc6Bd/kPfA+adEuUGFcvUKH3trDYqNq
6mOkAd8WO/mQadlc3ztS++XDMhmIpfBre9MPAr6usqf+wc+R8Nk9KLK39kEgrqVfzc/fgf8L
MaD4rHnusdg4gca6Yi+kNrm99anw7SwaBrBvULYBp7ixNRUhaYiNW4YjTrYxggShMIIEnQIB
ATCBgDB5MRAwDgYDVQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5v
cmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEW
EnN1cHBvcnRAY2FjZXJ0Lm9yZwIDEG5VMAkGBSsOAwIaBQCgggH1MBgGCSqGSIb3DQEJAzEL
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE1MDYyOTEyMjgyNFowIwYJKoZIhvcNAQkE
MRYEFKkfJ4Ty6Cc50bONagnCxUxIPbV9MGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQBDGBgzCBgDB5MRAwDgYD
VQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMT
GUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2Fj
ZXJ0Lm9yZwIDEG5VMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAwDgYDVQQKEwdSb290IENB
MR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2ln
bmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDEG5V
MA0GCSqGSIb3DQEBAQUABIICAIsEQ0wL4B/S0FsByN3Rpoo450G0i7AxOese4SU/5dPbayjJ
4NxlpWKoIlikGbR76ZRiOfpc9h0XnFrI/LHKJ8iIzLcWkY2nMs0deg/ZGumjlvbW18iVBIzs
DKb4Uz+mEmMXhInKC6LMqOLFq6DdmfhE34a+2qdNoOfXmSyked/SDL88TCwXRS9nh+6QrJKb
JkwtGZL0KsLppTKDv9wiTkLp5c9daEIkBwjX0M25Ks7DVsGkNyiIsaxJfPvST/XBJYRMbtcF
SclL7QFv/KA2FhEFjNQTIH+DwOTBvb89H6DlGDpyX3uGzAlUg912b6sF2RVaFUOQhgOcBjKA
i8HeohjtwtfKShEX0rpukXvJroKc9hB5urGzlmbhFGmktsoUQjEQ42nGZM0qVJsrDhpv1Am7
SnQbbtWsNTZ8U1z5Mv1gkRqb3pEoQ0EWflKtRoWNpXiDpHTWhWqBKynhoHh9zJkxZxakIG+1
HcBK/4wG1f9WGsnT3mqi0TeddQ5IEjKn2ZZtINEMggyfZHTPgKZg+nw/0ajtB3X8T+Lzxe/z
Z12vm1UBlqlqPOA6Fz20ehoUsIlta90easxhDOAZtzFbC4IDSGvagKzJpFqGlrgWRt3FkgF9
jOoHSBDyMLD23d8kQPZ/Bg+hy6CzhwyJDJF166+tKOFJ2VqSc+voMMgUjradAAAAAAAA
--------------ms020208050405080900030001--
