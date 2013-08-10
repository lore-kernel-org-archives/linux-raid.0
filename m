From: Carsten Aulbert <Carsten.Aulbert@aei.mpg.de>
Subject: Re: Recovering from two almost simultaneously failed devices in RAID1
Date: Sat, 10 Aug 2013 19:39:39 +0200
Message-ID: <52067ADB.8080100@aei.mpg.de>
References: <52066A7A.5050007@aei.mpg.de> <52066B43.1010901@aei.mpg.de>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms020001000502030207000900"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52066B43.1010901@aei.mpg.de>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is a cryptographically signed message in MIME format.

--------------ms020001000502030207000900
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

*sigh*

Thanks to me being at home and only IPMI access with relatively high
latencies, I did not manage to boot into single user mode and the system
booted up normally - luckily for me, both md and ext4 tell me, the file
system is safe and ok.


# mdadm --detail /dev/md2
/dev/md2:
        Version : 1.2
  Creation Time : Fri Jul 27 11:58:50 2012
     Raid Level : raid1
     Array Size : 250050533 (238.47 GiB 256.05 GB)
  Used Dev Size : 250050533 (238.47 GiB 256.05 GB)
   Raid Devices : 2
  Total Devices : 2
    Persistence : Superblock is persistent

    Update Time : Sat Aug 10 19:38:01 2013
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           Name : gitmaster:2  (local to host gitmaster)
           UUID : 7cb262a7:54496605:238cc0bf:6fa6a3e9
         Events : 61

    Number   Major   Minor   RaidDevice State
       0       8       49        0      active sync   /dev/sdd1
       1       8       33        1      active sync   /dev/sdc1


I think I got really lucky (still running checks on the git repositories
on this md).

Anyone who experienced such a problem with SSDs (or HDDs) being
disconnected like this?

Cheers

Carsten


--------------ms020001000502030207000900
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIE8DCC
BOwwggPUoAMCAQICAk/QMA0GCSqGSIb3DQEBBQUAMDYxCzAJBgNVBAYTAkRFMRMwEQYDVQQK
EwpHZXJtYW5HcmlkMRIwEAYDVQQDEwlHcmlkS2EtQ0EwHhcNMTMwNTA2MTU1OTM4WhcNMTQw
NjA1MTU1OTM4WjA9MRMwEQYDVQQKEwpHZXJtYW5HcmlkMQwwCgYDVQQLEwNBRUkxGDAWBgNV
BAMTD0NhcnN0ZW4gQXVsYmVydDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAJzM
vu6K/4EHUx/JuCoansTOW8cSyuPbvElm7IfuuEfXHJ1/m/Lbkv/C7oA+0Pvk4WCOLBx1OVUk
4vVZ0Lq6G9ekTgeZVaqFvHXKlFdUvdp3b5/nlAGc3z7GaDG/F6LdI5Iu374cTdeSvkuNseRg
KZP6Qq4GIMAZZ2hv1JC/xDxZs/59ACuL0IsjmdZPEiR8uiF01ZejehmdFiPJJP8at+PJgnoW
hW21Gh72CYI3CjvfB37Q5fUOqF1gMsfJmsJokwYfLLy8BcWbmP5BQ8IOL42F2RsuPTctnnbS
hhYj73Qyp4/Mxzeg1r34ZevEqM1pX6ceW7I/7Aos8HmhbcW71KMCAwEAAaOCAfswggH3MAwG
A1UdEwEB/wQCMAAwDgYDVR0PAQH/BAQDAgSwMB0GA1UdDgQWBBTeMPDcRbuXT/FdxHmf8kNH
EWVOVjAfBgNVHSMEGDAWgBTGdckorNEL/Dz/ubUe0187gGISNDAlBgNVHREEHjAcgRpDYXJz
dGVuLkF1bGJlcnRAYWVpLm1wZy5kZTAcBgNVHRIEFTATgRFncmlka2EtY2FAa2l0LmVkdTA1
BgNVHR8ELjAsMCqgKKAmhiRodHRwOi8vZ3JpZC5memsuZGUvY2EvZ3JpZGthLWNybC5kZXIw
KAYDVR0gBCEwHzAPBg0rBgEEAZQ2qywBAQEIMAwGCiqGSIb3TAUCAgEwEQYJYIZIAYb4QgEB
BAQDAgWgME4GCWCGSAGG+EIBDQRBFj9DZXJ0aWZpY2F0ZSBpc3N1ZWQgdW5kZXIgQ1AvQ1BT
IHYuIDEuOCBhdCBodHRwOi8vZ3JpZC5memsuZGUvY2EwJAYJYIZIAYb4QgECBBcWFWh0dHA6
Ly9ncmlkLmZ6ay5kZS9jYTAzBglghkgBhvhCAQgEJhYkaHR0cDovL2dyaWQuZnprLmRlL2Nh
L2dyaWRrYS1jcHMucGRmMDMGCWCGSAGG+EIBAwQmFiRodHRwOi8vZ3JpZC5memsuZGUvY2Ev
Z3JpZGthLWNybC5kZXIwDQYJKoZIhvcNAQEFBQADggEBALkdDvMzLkK1EpFkRPxEA4GpbYyy
5p59V9057HT/QUYvD7rO5KiayiRoDqgKeDW59Fek1N5W0d2IuN+j+VWLDqlBI1THd33F3Dqc
08Me/q6OkpHDjhCDnuH353n2gyxnsmXEEMozhx4onJbX0N3kZxjgNKEiP9R+zOq6Qq+CgKFS
O5w/wdtCTQ5Tpfr/n90KWYwVQ2er5dnKowu6j9YIj/dD8jJGk3T13rgzdnRzWtSQhjP8YIRf
ql08NsUgDShjNiBo289K7fpBNdVLGNI/pIA8P1ratofCGBPvMdjp+cjhulQX5//qS1ctP0ux
8MhY3kBMGynLkwibH5MiLfVSip0xggLOMIICygIBATA8MDYxCzAJBgNVBAYTAkRFMRMwEQYD
VQQKEwpHZXJtYW5HcmlkMRIwEAYDVQQDEwlHcmlkS2EtQ0ECAk/QMAkGBSsOAwIaBQCgggFn
MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTEzMDgxMDE3Mzkz
OVowIwYJKoZIhvcNAQkEMRYEFGmHGUHLIaiwVDhCGY1cfjEUeRxtMEsGCSsGAQQBgjcQBDE+
MDwwNjELMAkGA1UEBhMCREUxEzARBgNVBAoTCkdlcm1hbkdyaWQxEjAQBgNVBAMTCUdyaWRL
YS1DQQICT9AwTQYLKoZIhvcNAQkQAgsxPqA8MDYxCzAJBgNVBAYTAkRFMRMwEQYDVQQKEwpH
ZXJtYW5HcmlkMRIwEAYDVQQDEwlHcmlkS2EtQ0ECAk/QMGwGCSqGSIb3DQEJDzFfMF0wCwYJ
YIZIAWUDBAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYI
KoZIhvcNAwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwDQYJKoZIhvcNAQEBBQAEggEA
EhV1oc7aGAUxlXp0d0AaBDlTIS/s2/8zkDf1HGJP3hNg46zJi16AU30k/zddLTjXVKlhE8s4
1oZ9Do+g/yj1gU+6cHuomVxM5o5G+PZnR7L8ww8S7/NP4ZX4pUp2AGnrr/OASoewSgd2oYw1
rtSt1qi/S08HRSAFNoRblZs9J4v8w8UmsbS8HTVxkM8ls0AK08SBisi99+mKQB9vySxEIMl5
Wt7vxFQ9/uk3ALHHORuienSOYl4qklma9UnAjAc3X3598cAWYF9k2XsTfpKdZefIzakobmYh
jJeLWRcb3u1NTX40vcJloTCbcDFD0JqwntifKXJ+iJNFJeo1I17IPwAAAAAAAA==
--------------ms020001000502030207000900--
