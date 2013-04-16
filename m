From: Carsten Aulbert <Carsten.Aulbert@aei.mpg.de>
Subject: Re: Use RAID-6!
Date: Tue, 16 Apr 2013 22:05:53 +0200
Message-ID: <516DAF21.5040409@aei.mpg.de>
References: <15345091.8.1366130671716.JavaMail.root@zimbra> <516DABF2.5050409@tigertech.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms020406070400030102050706"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <516DABF2.5050409@tigertech.com>
Sender: linux-raid-owner@vger.kernel.org
To: Robert L Mathews <lists@tigertech.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is a cryptographically signed message in MIME format.

--------------ms020406070400030102050706
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi

On 04/16/2013 09:52 PM, Robert L Mathews wrote:
> I personally don't even trust RAID 6. All our servers use three-disk
> RAID 1 setups, with disks from at least two different manufacturers to
> prevent against firmware bricking (although this is becoming more and
> more difficult as the industry consolidates).

The problem I find with RAID1 is that it won't protect you against
silent corruptions (same as RAID5). What do you do if you do a through
check and both drives claim a data block is valid and intact, but data
differs? Do you trust disk1 or disk2?

In that respect I think RAID1 is a step into the wrong direction :(

Cheers

Carsten


--------------ms020406070400030102050706
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIE8DCC
BOwwggPUoAMCAQICAkMDMA0GCSqGSIb3DQEBBQUAMDYxCzAJBgNVBAYTAkRFMRMwEQYDVQQK
EwpHZXJtYW5HcmlkMRIwEAYDVQQDEwlHcmlkS2EtQ0EwHhcNMTIwNTAyMTQwMjI1WhcNMTMw
NjAxMTQwMjI1WjA9MRMwEQYDVQQKEwpHZXJtYW5HcmlkMQwwCgYDVQQLEwNBRUkxGDAWBgNV
BAMTD0NhcnN0ZW4gQXVsYmVydDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAOuh
d5sXP9180l8F34z/ywkRt/cVUoZjHh4bumhIZbz8O+PQ6QDI8mbgFwoDPQAmmEs4lKV8F0Ur
gRls+gEob+JybAepOFiZVa1YnLRnnvNcpKwi0fs7MIpvqUxCacIcc63UTD8A4/1N74zE2KpZ
g1TDqaW5ypQpKk9bUXBnhrg19j5PN1Ch2DRPO9jzJXW13uRL1OfNoOZoANHheegtfCj1mwzp
2naGvZea0EpqndKfUUHBrg9OQIwQJemXhWiJzJMv27l93+uSfvy2zvNXgXDFZr40p33Vx07C
OD8UI0vela6idGxzwJ74aoQpvp7dSUEIgVFCgXCCXgvY/FxXk6UCAwEAAaOCAfswggH3MAwG
A1UdEwEB/wQCMAAwDgYDVR0PAQH/BAQDAgSwMB0GA1UdDgQWBBSFaeVx9/3sSuG3fOgfU56/
LWDaKzAfBgNVHSMEGDAWgBTGdckorNEL/Dz/ubUe0187gGISNDAlBgNVHREEHjAcgRpDYXJz
dGVuLkF1bGJlcnRAYWVpLm1wZy5kZTAcBgNVHRIEFTATgRFncmlka2EtY2FAa2l0LmVkdTA1
BgNVHR8ELjAsMCqgKKAmhiRodHRwOi8vZ3JpZC5memsuZGUvY2EvZ3JpZGthLWNybC5kZXIw
KAYDVR0gBCEwHzAPBg0rBgEEAZQ2qywBAQEHMAwGCiqGSIb3TAUCAgEwEQYJYIZIAYb4QgEB
BAQDAgWgME4GCWCGSAGG+EIBDQRBFj9DZXJ0aWZpY2F0ZSBpc3N1ZWQgdW5kZXIgQ1AvQ1BT
IHYuIDEuNyBhdCBodHRwOi8vZ3JpZC5memsuZGUvY2EwJAYJYIZIAYb4QgECBBcWFWh0dHA6
Ly9ncmlkLmZ6ay5kZS9jYTAzBglghkgBhvhCAQgEJhYkaHR0cDovL2dyaWQuZnprLmRlL2Nh
L2dyaWRrYS1jcHMucGRmMDMGCWCGSAGG+EIBAwQmFiRodHRwOi8vZ3JpZC5memsuZGUvY2Ev
Z3JpZGthLWNybC5kZXIwDQYJKoZIhvcNAQEFBQADggEBABK8nPkhGS1HzzGlCfI5CaFT19za
d0H3tGc5OueBHxBO8DWyB3M1v1YyaOEDEvkL1Y1+RDAnYvoXgvgBQnGMWuy4SEnMpm1wIIMs
pFM1Q1pPqJ+GdwYdmkwkVy4fs8TkDAy6AYkoGa7Cnxai1KlLHtxCS26uIiUcEhSmdMZOQT4w
rYbtX1mQGZpg4BJ8YgjP1oazYCiHaQcumVYSOHb+HJQuAy35eBr6/82OHrF28V+UoN9EYuU7
1RqAS9dtP6i7z34V7Tlx0zyzL99IyF5ZZMF6a18q7K9jrkXlTRYYcpGMMeH51XGe5hB1az5o
fR7i8PzrlBwH5cn5BHDfjWHbcOgxggLOMIICygIBATA8MDYxCzAJBgNVBAYTAkRFMRMwEQYD
VQQKEwpHZXJtYW5HcmlkMRIwEAYDVQQDEwlHcmlkS2EtQ0ECAkMDMAkGBSsOAwIaBQCgggFn
MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTEzMDQxNjIwMDU1
M1owIwYJKoZIhvcNAQkEMRYEFEIxXKjIWp1toIqec9TZwA79+oTCMEsGCSsGAQQBgjcQBDE+
MDwwNjELMAkGA1UEBhMCREUxEzARBgNVBAoTCkdlcm1hbkdyaWQxEjAQBgNVBAMTCUdyaWRL
YS1DQQICQwMwTQYLKoZIhvcNAQkQAgsxPqA8MDYxCzAJBgNVBAYTAkRFMRMwEQYDVQQKEwpH
ZXJtYW5HcmlkMRIwEAYDVQQDEwlHcmlkS2EtQ0ECAkMDMGwGCSqGSIb3DQEJDzFfMF0wCwYJ
YIZIAWUDBAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYI
KoZIhvcNAwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwDQYJKoZIhvcNAQEBBQAEggEA
D9npylfnl/Dg75CWFZ3SFTp/cWA/9kAQKBNNgMG0TxapR+CAsQUMX2cPQg3sImupl3zXe1MX
b9nIrfp0kUEqCRN3igr28Sn9tL/iTmpFnazU5oPZ/a3UOjNhz1IfWR0Q+WjvSINLEwS8TdDa
w9YfYbZIK0KR4rcCCXWKO/4DCaHTccLKNgNFLcm/4OZJ9GOWJajgI8vcEK4t0ndDNXy1J6Sx
nCuuhlZEkRpYZd9gdpjXK6fpGGrEqLaHK/hr95bmBKKXIus9gHsUCSa8Wonh3isV610zYzqj
P+jS2V2swjRbC4Obv6YsWtd4rX60qhuC3F85QG/iiFrNFtJyj0wkLQAAAAAAAA==
--------------ms020406070400030102050706--
