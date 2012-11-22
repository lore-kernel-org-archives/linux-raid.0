From: Carsten Aulbert <Carsten.Aulbert@aei.mpg.de>
Subject: Re: split brain mode after reboot
Date: Thu, 22 Nov 2012 07:20:11 +0100
Message-ID: <50ADC41B.6090409@aei.mpg.de>
References: <50AB8EED.4000005@aei.mpg.de> <20121121082252.3a9bb7db@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms020009080608050006080703"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121121082252.3a9bb7db@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, "gerrit.kuehn@aei.mpg.de" <gerrit.kuehn@aei.mpg.de>
List-Id: linux-raid.ids

This is a cryptographically signed message in MIME format.

--------------ms020009080608050006080703
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi Neil

On 11/20/2012 10:22 PM, NeilBrown wrote:
>=20
> Expected - probably. Wanted - no.
>=20

good :)

> I think one half gets assembled by "mdadm --incremental" run from
> udev, and the other by a subsequence "mdadm -As" or similar.
>=20
> mdadm-3.3, which is still under development, has a fix for this so
> that --incremental and --assemble don't trip over each other.
>=20
> http://git.neil.brown.name/?p=3Dmdadm.git;a=3Dcommitdiff;h=3D0431869cec=
4c673309d9aa

Great,
>=20
I think we'll wait for 3.3 and try to backport it to our
current production systems.

Thanks!

Carsten
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlCtxBsACgkQvfAZOV3797y6ZACgk/puEYU+C2AX+SCVJz5ZhY83
QaIAnRCpHW6zK2PYS6CU8+XiCkJwoQZ+
=3DMnXg
-----END PGP SIGNATURE-----


--------------ms020009080608050006080703
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
MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTEyMTEyMjA2MjAx
MVowIwYJKoZIhvcNAQkEMRYEFBqaGVPn+jkUSSPaErxgVyqFjW09MEsGCSsGAQQBgjcQBDE+
MDwwNjELMAkGA1UEBhMCREUxEzARBgNVBAoTCkdlcm1hbkdyaWQxEjAQBgNVBAMTCUdyaWRL
YS1DQQICQwMwTQYLKoZIhvcNAQkQAgsxPqA8MDYxCzAJBgNVBAYTAkRFMRMwEQYDVQQKEwpH
ZXJtYW5HcmlkMRIwEAYDVQQDEwlHcmlkS2EtQ0ECAkMDMGwGCSqGSIb3DQEJDzFfMF0wCwYJ
YIZIAWUDBAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYI
KoZIhvcNAwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwDQYJKoZIhvcNAQEBBQAEggEA
uSYfGLhh+MoeQJQa/4HCgRrbZL+nsCN0BoEqF4PTpBfkN6Z7PEKxTLrltKo53FPM0AkSSAkK
hvivrFalJH9BTbFzTrLY5VfPobbWZQuh86UTQUAZyc9DidBR/sRpE7FcPRiafp6v9E7pUvcm
P0kNKW0L+Qf0uMfY/Oh9hAJLal3EMEV45Vt6p0ApSFwcWaJdybxRwAUVb0QETJjZpUrovqSk
OxE9Nmfbzdlmrxa7akgTVnkZTefuLqh6YeXsq1sZvBEJDRsGf4LdL+gbccTg8OS+lWoPT8DV
D9fdI5h7xw/bQa+pHPuw0Y4eZnaSTnyPADUIBHcXnsDLKOGTc9xLLQAAAAAAAA==
--------------ms020009080608050006080703--
