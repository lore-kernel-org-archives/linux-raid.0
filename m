From: Carsten Aulbert <Carsten.Aulbert@aei.mpg.de>
Subject: split brain mode after reboot
Date: Tue, 20 Nov 2012 15:08:45 +0100
Message-ID: <50AB8EED.4000005@aei.mpg.de>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms050303020509080100030305"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: "gerrit.kuehn@aei.mpg.de" <gerrit.kuehn@aei.mpg.de>
List-Id: linux-raid.ids

This is a cryptographically signed message in MIME format.

--------------ms050303020509080100030305
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi all

a colleague of mine created a raid 1 on a fairly recent machine

Kernel 3.5.0-sabayon

mdadm - v3.2.3 - 23rd December 2011

During operation sda seemed to have been disconnected by the
system/motherboard/whatever but this was not detected before a reboot
was done, after the reboot, sda re-appeared but of course with a much
older version of the mirror:

Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5]
[raid4] [multipath] [faulty]
md126 : active raid1 sdb1[1]
      4194240 blocks [2/1] [_U]

md127 : active raid1 sdb3[1]
      235808704 blocks [2/1] [_U]

md0 : active raid1 sda1[0]
      4194240 blocks [2/1] [U_]

md1 : active raid0 sda2[0] sdb2[1]
      8387584 blocks 512k chunks

md2 : active raid1 sda3[0]
      235808704 blocks [2/1] [U_]

unused devices: <none>

As no vital information were on these disks, my question for the list is
just if this is an expected/wanted behavior after such an event and what
one could do to prevent this (besides monitoring via mdadm).

Cheers

Carsten

--=20
Dr. Carsten Aulbert - Max Planck Institute for Gravitational Physics
Callinstrasse 38, 30167 Hannover, Germany
phone/fax: +49 511 762-17185 / -17193
https://wiki.atlas.aei.uni-hannover.de/foswiki/bin/view/ATLAS/WebHome


--------------ms050303020509080100030305
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
MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTEyMTEyMDE0MDg0
NVowIwYJKoZIhvcNAQkEMRYEFHl1FeHsCoOxydFKMi7M0fvR5GtOMEsGCSsGAQQBgjcQBDE+
MDwwNjELMAkGA1UEBhMCREUxEzARBgNVBAoTCkdlcm1hbkdyaWQxEjAQBgNVBAMTCUdyaWRL
YS1DQQICQwMwTQYLKoZIhvcNAQkQAgsxPqA8MDYxCzAJBgNVBAYTAkRFMRMwEQYDVQQKEwpH
ZXJtYW5HcmlkMRIwEAYDVQQDEwlHcmlkS2EtQ0ECAkMDMGwGCSqGSIb3DQEJDzFfMF0wCwYJ
YIZIAWUDBAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYI
KoZIhvcNAwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwDQYJKoZIhvcNAQEBBQAEggEA
0klT3gQQMBzh57fpTP8PEPgX+3EY+TK/E4XiCjS/lspmB8b5NbY+oS8s7PB/jNmwlL9Kg+fy
aYhvhlKp4gzWl7q1BhoZcMFFckp4+XAww0J8gZ5WK372tSNY3SIffMEgwUlmwbxbp6A9xq8B
PLHgx/aPGvpDyBVpR/tfvpE3OGJNM0wL8m5Z0pa+OzyVHSSqhvj+6nxz0ZzbcrXswQLqJqZB
gOKg4cy4Ny19aIer7A/+b30pjJKqJgetVs9YWwDAszEDUij9gtaDSK6RqEE4z+bDdyMEHqYu
/TF+LKOCxu32cTlzYa0YcnX3B+2fY/KIXGSQMCIzMd6m1TJYDajqewAAAAAAAA==
--------------ms050303020509080100030305--
