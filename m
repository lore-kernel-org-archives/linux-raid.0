From: "Dorau, Lukasz" <lukasz.dorau@intel.com>
Subject: RE: ISW fakeraid: fail to add back a disk previously removed
Date: Wed, 6 Nov 2013 14:08:19 +0000
Message-ID: <D9FFE20C522965449E182ACE73889AEB1A67F5CF@IRSMSX105.ger.corp.intel.com>
References: <CAC9WiBj5UO76MN3s0TgTLVKVAXJzY+eBxCMCYJWTp0JgdYogaQ@mail.gmail.com>
	<CAC9WiBiz+PTNQtv00RZUoBS30CaZwST+9W9K1SiPsVuze2MEcA@mail.gmail.com>
 <CAC9WiBjdLKmZ5koOr7R6yuYUiOYdVLDGjiRGssg8kK5RQ1fr0A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature";
	micalg=SHA1; boundary="----=_NextPart_000_0215_01CEDB02.063EA770"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC9WiBjdLKmZ5koOr7R6yuYUiOYdVLDGjiRGssg8kK5RQ1fr0A@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>
Cc: NeilBrown <neilb@suse.de>, "Williams, Dan J" <dan.j.williams@intel.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

------=_NextPart_000_0215_01CEDB02.063EA770
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wednesday, November 06, 2013 10:06 AM Francis Moreau <francis.moro@gmail.com>
wrote:
> Hi Neil,
>
> So far now answer, I'm adding you in the thread since it seems a
> critical issue, hope you don't mind.
>
> Thanks
>
> On Mon, Oct 28, 2013 at 7:18 AM, Francis Moreau <francis.moro@gmail.com>
> wrote:
> > Hi,
> >
> >
> > [ Adding Dan Williams in CC since it appears to be the author of the
> > intel fake raid support. ]
> >
> >
> > On Wed, Oct 23, 2013 at 11:24 AM, Francis Moreau <francis.moro@gmail.com>
> wrote:
> >> Hello,
> >>
> >> I'm testing ISW fake-raid with mdadm 3.3 and I can't add back a disk
> >> to a container previously marked as failed and removed.
> >>
> >> Also I'm testing ISW inside a VM so I'm not sure my test case is valid.
> >>
> >> So basically my ISW array was created with dmraid. I then installed my
> >> system on this array and rebooted to switch to mdadm. So far so good
> >> everything seems to work perfectly:
> >>
> >> # export IMSM_NO_PLATFORM=1
> >>
> >> # cat /proc/mdstat
> >> Personalities : [raid1]
> >> md126 : active raid1 sda[1] sdb[0]
> >>       2092375 blocks super external:/md127/0 [2/2] [UU]
> >>
> >> md127 : inactive sda[1](S) sdb[0](S)
> >>       6306 blocks super external:imsm
> >>
> >> unused devices: <none>
> >>
> >> # mdadm -E /dev/sdb
> >> /dev/sdb:
> >>           Magic : Intel Raid ISM Cfg Sig.
> >>         Version : 1.1.00
> >>     Orig Family : ef92cdd9
> >> [ ... ]
> >>
> >> Now I'm marking sda as failed and remove it:
> >>
> >> # mdadm --fail /dev/md126 sda
> >> # mdadm --remove /dev/md127 sda
> >>
> >> everything works fine until I add back sda to the container:
> >>
> >> # mdadm --add /dev/md127 /dev/sda
> >> mdadm: add /dev/sda
> >>
> >> # cat /proc/mdstat
> >> Personalities : [raid1]
> >> md126 : active raid1 sdb[0]
> >>       2092375 blocks super external:/md127/0 [2/1] [_U]
> >>
> >> md127 : inactive sda[1](S) sdb[0](S)
> >>       6306 blocks super external:imsm
> >>
> >> sda is not added anymore to the array md126 and therefore no resynchro
> happens.
> >>
> >> # mdadm -E /dev/sda
> >> /dev/sda:
> >>    MBR Magic : aa55
> >> Partition[0] :      3612577 sectors at         2048 (type 83)
> >> Partition[1] :       560133 sectors at      3616767 (type 05)
> >>
> >> Could anybody tell me if that's expected and if so could you englight me ?
> >>

Hi Francis,

If you created a RAID array with mdadm, it would work correctly - recovery would 
start.
The IMSM metadata is not supported in dmraid anymore and mdadm does not have to 
work correctly with array created and started with dmraid.

Lukasz


------=_NextPart_000_0215_01CEDB02.063EA770
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"

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
7P75p4oipMaLNqd/YGa8K1lVyd4axolI7XJn2yH0Kcuiuk+2r4xciCUez50WqsGNy3BmIWkABPqP
2ZH7D+H3egNjUDMgLC6ixrpLcP5NqmByskqbccAh4wfa9Fba6TSsjah5vV+t/4muxeythylO7JeB
cCgNq85oM6Ky6Ls5s3E3gHbvUlhlOCSMfdoFFmotIJb+OOrsRU9Q6gitGArubtCZmR6LCNXa1/8c
HI/2/ztZzeoF9T0uJ/eNJ4B29K7VPPz/XTvw1vMM7sNDKaPTD9cxAgMBAAGjggLkMIIC4DALBgNV
HQ8EBAMCB4AwPAYJKwYBBAGCNxUHBC8wLQYlKwYBBAGCNxUIhsOMdYSZ5VGD/YEohY6fU4KRwAln
gd69OZXwQwIBZAIBCDAdBgNVHQ4EFgQUNbc5JYFJSRu6D/aP3lFE7JYUmZ0wHwYDVR0jBBgwFoAU
HmkqtNwo/kcYTiELP7ysES/wmPUwgckGA1UdHwSBwTCBvjCBu6CBuKCBtYZUaHR0cDovL3d3dy5p
bnRlbC5jb20vcmVwb3NpdG9yeS9DUkwvSW50ZWwlMjBFeHRlcm5hbCUyMEJhc2ljJTIwSXNzdWlu
ZyUyMENBJTIwNEEuY3Jshl1odHRwOi8vY2VydGlmaWNhdGVzLmludGVsLmNvbS9yZXBvc2l0b3J5
L0NSTC9JbnRlbCUyMEV4dGVybmFsJTIwQmFzaWMlMjBJc3N1aW5nJTIwQ0ElMjA0QS5jcmwwge8G
CCsGAQUFBwEBBIHiMIHfMGkGCCsGAQUFBzAChl1odHRwOi8vd3d3LmludGVsLmNvbS9yZXBvc2l0
b3J5L2NlcnRpZmljYXRlcy9JbnRlbCUyMEV4dGVybmFsJTIwQmFzaWMlMjBJc3N1aW5nJTIwQ0El
MjA0QS5jcnQwcgYIKwYBBQUHMAKGZmh0dHA6Ly9jZXJ0aWZpY2F0ZXMuaW50ZWwuY29tL3JlcG9z
aXRvcnkvY2VydGlmaWNhdGVzL0ludGVsJTIwRXh0ZXJuYWwlMjBCYXNpYyUyMElzc3VpbmclMjBD
QSUyMDRBLmNydDAfBgNVHSUEGDAWBggrBgEFBQcDBAYKKwYBBAGCNwoDDDApBgkrBgEEAYI3FQoE
HDAaMAoGCCsGAQUFBwMEMAwGCisGAQQBgjcKAwwwSQYDVR0RBEIwQKAmBgorBgEEAYI3FAIDoBgM
Fmx1a2Fzei5kb3JhdUBpbnRlbC5jb22BFmx1a2Fzei5kb3JhdUBpbnRlbC5jb20wDQYJKoZIhvcN
AQEFBQADggEBACF0FbaPgcaLSfbc3S29c3zsR9sPW9Xrl6yMKfyjg7VM1WlvacFO9vmlvXfYQ0Zj
jlFMIQz9XAUt9YJ6UnrWyqsnczvAxeqdRnUULT/7tJH+N5QP1S2vptindTTgWllZ3Bx976g8slTM
yP2bEhDXNpdzCiE30OUuC0XiZsFgzcHCHwcCLPOdyCKnlXJzVlEr09OBl2Q3hL7eFWUT0o627HIl
x3wNEhDPlM8Lf/RGpu3yqnpjhF4KzydESP5iDmzKZbI9hmLbqSCJux4lxTl1i69wgPwCg0Hj7HDt
qNYDf0bI7yfiSK9VBjfP9er70hhsPAJAhV+lUd/T+FNr/2ToEGkwggZpMIIFUaADAgECAgoZI0YY
AAAAADIwMA0GCSqGSIb3DQEBBQUAMHkxCzAJBgNVBAYTAlVTMQswCQYDVQQIEwJDQTEUMBIGA1UE
BxMLU2FudGEgQ2xhcmExGjAYBgNVBAoTEUludGVsIENvcnBvcmF0aW9uMSswKQYDVQQDEyJJbnRl
bCBFeHRlcm5hbCBCYXNpYyBJc3N1aW5nIENBIDRBMB4XDTEzMTAxNzA5MzYyM1oXDTE2MTAwMTA5
MzYyM1owPzEWMBQGA1UEAxMNRG9yYXUsIEx1a2FzejElMCMGCSqGSIb3DQEJARYWbHVrYXN6LmRv
cmF1QGludGVsLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBANI2BQhjkLfTUbFv
qz3+TGK0V1joJB9WPl+8CHHqt0q0IaMfbTw+vohehyggdvbBIs1pz3hkDB9QGmzdO1SXfHvNGdkl
uICCN32/Df6SogQZk1iIomWhAInMAvDK1HE0fsnH1QrAoWTCmlhIiFG80LYPo33weGj2qm+vGb4O
NgDNedAg7cxToxymfsiZFmL9LUNMSmcRwBtLInfObOQz0kVRt4NG7HoijEtL5vN6M9Rw7w79QMfq
/nQRbkznn3NFAsxEM+mXHSO5bnRKk2rP0+NspgyVr4OjgY1ru9NHGTGDm/tiu9yoGMZn/gFu3qeF
xNVjTTTe+zfUZBXGoG642L8CAwEAAaOCAyswggMnMAsGA1UdDwQEAwIEMDA9BgkrBgEEAYI3FQcE
MDAuBiYrBgEEAYI3FQiGw4x1hJnlUYP9gSiFjp9TgpHACWeEudlBh4T/TgIBZAIBDTBEBgkqhkiG
9w0BCQ8ENzA1MA4GCCqGSIb3DQMCAgIAgDAOBggqhkiG9w0DBAICAIAwBwYFKw4DAgcwCgYIKoZI
hvcNAwcwHQYDVR0OBBYEFGwUQ+HKUQFIg6D3L2t2rGrufc4BMB8GA1UdIwQYMBaAFB5pKrTcKP5H
GE4hCz+8rBEv8Jj1MIHJBgNVHR8EgcEwgb4wgbuggbiggbWGVGh0dHA6Ly93d3cuaW50ZWwuY29t
L3JlcG9zaXRvcnkvQ1JML0ludGVsJTIwRXh0ZXJuYWwlMjBCYXNpYyUyMElzc3VpbmclMjBDQSUy
MDRBLmNybIZdaHR0cDovL2NlcnRpZmljYXRlcy5pbnRlbC5jb20vcmVwb3NpdG9yeS9DUkwvSW50
ZWwlMjBFeHRlcm5hbCUyMEJhc2ljJTIwSXNzdWluZyUyMENBJTIwNEEuY3JsMIHvBggrBgEFBQcB
AQSB4jCB3zBpBggrBgEFBQcwAoZdaHR0cDovL3d3dy5pbnRlbC5jb20vcmVwb3NpdG9yeS9jZXJ0
aWZpY2F0ZXMvSW50ZWwlMjBFeHRlcm5hbCUyMEJhc2ljJTIwSXNzdWluZyUyMENBJTIwNEEuY3J0
MHIGCCsGAQUFBzAChmZodHRwOi8vY2VydGlmaWNhdGVzLmludGVsLmNvbS9yZXBvc2l0b3J5L2Nl
cnRpZmljYXRlcy9JbnRlbCUyMEV4dGVybmFsJTIwQmFzaWMlMjBJc3N1aW5nJTIwQ0ElMjA0QS5j
cnQwHwYDVR0lBBgwFgYIKwYBBQUHAwQGCisGAQQBgjcKAwQwKQYJKwYBBAGCNxUKBBwwGjAKBggr
BgEFBQcDBDAMBgorBgEEAYI3CgMEMEkGA1UdEQRCMECgJgYKKwYBBAGCNxQCA6AYDBZsdWthc3ou
ZG9yYXVAaW50ZWwuY29tgRZsdWthc3ouZG9yYXVAaW50ZWwuY29tMA0GCSqGSIb3DQEBBQUAA4IB
AQBuPyvWgVnWwVqJTPYRRIr2oSofGE90vHGQLra1z70xeVKuhyMDL2KtBh/jT41kQIw9w9ml6v39
mKTw8HLwOTo27oI+PTLVhvhdgkc6pI7WWzVNUtgwmvub/CmltbCGz2/ay2RB77YKZqS5RWmMRIBZ
B39+ZQgAqXQeGvcUDQEeBO5u5+Bc21NLENQLUqhargnyMVqjSmbFjTX9u3N7hujowcjvtvLbGWHO
ufgul5yZxp0cRt6/i2ISF1K8eQ2Og0ZY6dwFow8FL9NVwIlQTV9/dQjv2dWqvssz9qVJRDjb4tKY
1VEDKyeTOUbUk41fBcZtwlOymhxug7hHG4HKpPPHMYIDvDCCA7gCAQEwgYcweTELMAkGA1UEBhMC
VVMxCzAJBgNVBAgTAkNBMRQwEgYDVQQHEwtTYW50YSBDbGFyYTEaMBgGA1UEChMRSW50ZWwgQ29y
cG9yYXRpb24xKzApBgNVBAMTIkludGVsIEV4dGVybmFsIEJhc2ljIElzc3VpbmcgQ0EgNEECChkl
E1UAAAAAMjEwCQYFKw4DAhoFAKCCAgkwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG
9w0BCQUxDxcNMTMxMTA2MTQwODE4WjAjBgkqhkiG9w0BCQQxFgQUA7Rg0I0J5l5VN+SZXhsyw0q6
ZDwwcgYJKoZIhvcNAQkPMWUwYzALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAoGCCqGSIb3DQMH
MAsGCWCGSAFlAwQBAjAHBgUrDgMCGjALBglghkgBZQMEAgMwCwYJYIZIAWUDBAICMAsGCWCGSAFl
AwQCATCBmAYJKwYBBAGCNxAEMYGKMIGHMHkxCzAJBgNVBAYTAlVTMQswCQYDVQQIEwJDQTEUMBIG
A1UEBxMLU2FudGEgQ2xhcmExGjAYBgNVBAoTEUludGVsIENvcnBvcmF0aW9uMSswKQYDVQQDEyJJ
bnRlbCBFeHRlcm5hbCBCYXNpYyBJc3N1aW5nIENBIDRBAgoZI0YYAAAAADIwMIGaBgsqhkiG9w0B
CRACCzGBiqCBhzB5MQswCQYDVQQGEwJVUzELMAkGA1UECBMCQ0ExFDASBgNVBAcTC1NhbnRhIENs
YXJhMRowGAYDVQQKExFJbnRlbCBDb3Jwb3JhdGlvbjErMCkGA1UEAxMiSW50ZWwgRXh0ZXJuYWwg
QmFzaWMgSXNzdWluZyBDQSA0QQIKGSNGGAAAAAAyMDANBgkqhkiG9w0BAQEFAASCAQBkq4QAtG+5
/cr/XnimFi1ACfMS5QIf6y6OElp7jzvEN2bIDNTpBavgYdrZ5Qszj+0X/h+yWXT98pWDRX2wrP0W
RHEkXnXAmcy18sUTedVvOePvvYMhTlN2qU2j55i/lEip8hfCoRuC6KUsi+hegAqiJ7PFz/hCydsP
whZTrk46yOhhlN7Z9y/Ob3F6rURetZvViAXgeh+3sHehtf0DB0ZkU85LSHizBltMccAQSOszl2f0
hMrhZZrTj1u5Pt4vNY+cARMnVCzuN4nlKCYWFHJNwCDIGcxP0b+jAd/OEVMJDdjjJaCs0smn8NQ9
ELuNmo8zmKJ9cFvYbZ5QbOSxhspoAAAAAAAA

------=_NextPart_000_0215_01CEDB02.063EA770--
