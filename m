From: Christoph Anton Mitterer <calestyo@scientia.net>
Subject: Re: shown disk sizes
Date: Tue, 23 Jul 2013 18:26:10 +0200
Message-ID: <1374596770.8463.23.camel@heisenberg.scientia.net>
References: <1374071867.25339.14.camel@heisenberg.scientia.net>
	 <20130718094327.7d46949e@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="sha512";
	protocol="application/x-pkcs7-signature";
	boundary="=-D5aC47UfuMYmQpkTvZ5n"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130718094327.7d46949e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-D5aC47UfuMYmQpkTvZ5n
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2013-07-18 at 09:43 +1000, NeilBrown wrote:=20
> > --examine gives for both devices:
> > Avail Dev Size : 20969472 (10.00 GiB 10.74 GB)
> >      Array Size : 20969328 (10.00 GiB 10.74 GB)
> >   Used Dev Size : 20969328 (10.00 GiB 10.74 GB)
> >     Data Offset : 2048 sectors
> >    Super Offset : 8 sectors
> >=20
> > =3D> Avail is the available payload size on each component device,... s=
o
> > given that we have the first 2048S for the superblock/bitmap/etc... tha=
t
> > fits exactly.
> >=20
> > =3D> Why is the array size / used dev size smaller?
>=20
> Good question.  Not easy to answer ... it is rather convoluted.  Differen=
t
> bits of code try to reserve space for things differently and they don't e=
nd
> up agreeing.  I might try to simplify that.


I played a bit more around here,... and got even more confused:

Made two files for losetup:
-rw-r--r--  1 root root 524288000 Jul 23 17:41 image1
-rw-r--r--  1 root root 524288000 Jul 23 17:41 image2

And a RAID1 out of it:
mdadm --create /dev/md/raid3 --verbose --metadata=3D1.2 --size=3Dmax
--level=3Draid1  --name=3Draid3  --raid-devices=3D2 /dev/loop0 /dev/loop1

Examine says:
# mdadm --examine /dev/loop0
/dev/loop0:
Avail Dev Size : 1023488 (499.83 MiB 524.03 MB)
     Array Size : 511680 (499.77 MiB 523.96 MB)
  Used Dev Size : 1023360 (499.77 MiB 523.96 MB)
    Data Offset : 512 sectors
   Super Offset : 8 sectors


Fines, so 524288000/512 - 512S =3D exactly the 1023488 Avail Dev size
Array Size is in 1K and Used Dev Size in S, so these are identical.

Questions
1) How does mdadm choose the data alignment? It seems to also use
completely "odd" numbers like 262144 sectors

2) Again, some sectors (here 128 S) are missing... :(


Now I did some fun:
cat /dev/md/raid > image
-rw-r--r--  1 root root 523960320 Jul 23 17:43 image
=3D> which is just the ArraySize / Used Dev Size... hurray...
I edited that file with an hexeditor with the following changes:=20
# hd i
00000000  43 41 4c 45 53 54 59 4f  5f 42 45 47 49 4e 00 00  |CALESTYO_BEGIN=
..|
00000010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |..............=
..|
*
1f3afff0  00 00 00 00 43 41 4c 45  53 54 59 4f 5f 45 4e 44  |....CALESTYO_E=
ND|
1f3b0000

and wrote it back (cat image > /dev/md/raid).

Of course I couldn't resist to stop the raid and directly read the
losetup image files:
# hd image1=20
00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |..............=
..|
*
00001000  fc 4e 2b a9 01 00 00 00  00 00 00 00 00 00 00 00  |.N+...........=
..|
00001010  99 05 68 13 83 97 70 53  bd 98 b6 9e 04 9c 1a 79  |..h...pS......=
.y|
00001020  6c 63 67 2d 6c 72 7a 2d  70 75 70 70 65 74 3a 72  |lcg-lrz-puppet=
:r|
00001030  61 69 64 33 00 00 00 00  00 00 00 00 00 00 00 00  |aid3..........=
..|
00001040  ed a2 ee 51 00 00 00 00  01 00 00 00 00 00 00 00  |...Q..........=
..|
00001050  80 9d 0f 00 00 00 00 00  00 00 00 00 02 00 00 00  |..............=
..|
00001060  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |..............=
..|
*
00001080  00 02 00 00 00 00 00 00  00 9e 0f 00 00 00 00 00  |..............=
..|
00001090  08 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |..............=
..|
000010a0  00 00 00 00 00 00 00 00  d4 58 14 b3 8c 07 e4 88  |.........X....=
..|
000010b0  fa f7 61 90 83 2b 4c 0d  00 00 00 00 00 00 00 00  |..a..+L.......=
..|
000010c0  2c a4 ee 51 00 00 00 00  13 00 00 00 00 00 00 00  |,..Q..........=
..|
000010d0  ff ff ff ff ff ff ff ff  c3 52 2b 16 80 00 00 00  |.........R+...=
..|
000010e0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |..............=
..|
*
00001100  00 00 01 00 fe ff fe ff  fe ff fe ff fe ff fe ff  |..............=
..|
00001110  fe ff fe ff fe ff fe ff  fe ff fe ff fe ff fe ff  |..............=
..|
*
00001200  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |..............=
..|
*
00002000  62 69 74 6d 04 00 00 00  35 c5 62 da cf d2 21 ea  |bitm....5.b...=
!.|
00002010  1a e5 49 74 92 7b 49 2e  00 00 00 00 00 00 00 00  |..It.{I.......=
..|
00002020  00 00 00 00 00 00 00 00  80 9d 0f 00 00 00 00 00  |..............=
..|
00002030  00 00 00 00 00 00 00 04  05 00 00 00 00 00 00 00  |..............=
..|
00002040  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |..............=
..|
*
00002100  ff ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff  |..............=
..|
*
00002200  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |..............=
..|
*
00040000  43 41 4c 45 53 54 59 4f  5f 42 45 47 49 4e 00 00  |CALESTYO_BEGIN=
..|
00040010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |..............=
..|
*
1f3efff0  00 00 00 00 43 41 4c 45  53 54 59 4f 5f 45 4e 44  |....CALESTYO_E=
ND|
1f3f0000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |..............=
..|
*
1f400000

(they are the same (especially the addresses) except some places in the
header)

Okay here we go: 0x00040000 =3D 262144 B =3D 512 S... hurray... the data
starts at the data offset (who'd have expected this? :P)

The total size: 0x1f400000 =3D 524288000 B =3D 1024000 S, which is just the
size of my losetup image files

Total size 0x1f400000 - 0x0x00040000 =3D 524025856 B =3D 1023488 S, which i=
s
again the Avail Size... (i.e. NOT the array size)

And the 1f400000-1f3f0000 are just the "missing" 128S.
Jihaw...

3) Stupid question... are these 128S kept free for the 0.9/1.0
superblock-in-the-end disease? ;)
If so,... I'd have expected that this region is at least 64K and at most
128K large,... but I've also had this:
# mdadm --examine /dev/loop3
/dev/loop3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 968d9b80:d8714965:c3cb34cd:4d2952e6
           Name : lcg-lrz-puppet:raid2  (local to host lcg-lrz-puppet)
  Creation Time : Tue Jul 23 17:15:23 2013
     Raid Level : raid1
   Raid Devices : 2

Avail Dev Size : 1048313856 (499.88 GiB 536.74 GB)
     Array Size : 524156736 (499.87 GiB 536.74 GB)
  Used Dev Size : 1048313472 (499.87 GiB 536.74 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : bbcfa311:0e61c19a:5eafe78e:f53b1c15

Internal Bitmap : 8 sectors from superblock
    Update Time : Tue Jul 23 17:15:23 2013
       Checksum : 23cbc3d7 - correct
         Events : 0

=3D> and there we have 384 S...



I was working on some spreadsheat which should give one, starting from a
few variables like first sector of the MD's component device partition,
and so on... and especially the desired (usabel) array size... the
necessary size for the the component device.
Obviously, as long as I can't calculate how the size of the superblock
comes together... I have no real chance


Cheers,
Chris.

--=-D5aC47UfuMYmQpkTvZ5n
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgMFADCABgkqhkiG9w0BBwEAAKCCEP4w
ggV1MIIDXaADAgECAgMBAYIwDQYJKoZIhvcNAQEFBQAwVDEUMBIGA1UEChMLQ0FjZXJ0IEluYy4x
HjAcBgNVBAsTFWh0dHA6Ly93d3cuQ0FjZXJ0Lm9yZzEcMBoGA1UEAxMTQ0FjZXJ0IENsYXNzIDMg
Um9vdDAeFw0xMjA3MjMxNDU2NDVaFw0xNDA3MjMxNDU2NDVaMHwxITAfBgNVBAMTGENocmlzdG9w
aCBBbnRvbiBNaXR0ZXJlcjEkMCIGCSqGSIb3DQEJARYVY2FsZXN0eW9Ac2NpZW50aWEubmV0MTEw
LwYJKoZIhvcNAQkBFiJtYWlsQGNocmlzdG9waC5hbnRvbi5taXR0ZXJlci5uYW1lMIIBIjANBgkq
hkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqv+F91K5vyBwiGFMqj6wTehWdqZnfFeXqT8g5b3qrXWL
ywSzcoD9xtyoRqAgOCX+PSmBpm6pPhe31VnBtc3HcBMe4rSico9/Z2H9h1l6IMVEnyhabWzoKbE3
BFrsYJGthJCbhK072G8AhCk+5p+L+knLhQXN0Ph7MJbdY26o3M4vjsXFNbJL8TOYxo80cGD1LIh2
SUZFqaIG24TVmTW8F4jD5Z9/NEwJa8kQK+VBNHUntXYNah4Reh0jSsGnq9Pg3Hf4KC+F0IR8QgBm
SnwitMFUX9UnhLEvRQxjDI1tm+h6RxfjlV7moI68Ulh7bcdPhM/z2Q16XmaY12rc85pSRQIDAQAB
o4IBJjCCASIwDAYDVR0TAQH/BAIwADBWBglghkgBhvhCAQ0ESRZHVG8gZ2V0IHlvdXIgb3duIGNl
cnRpZmljYXRlIGZvciBGUkVFIGhlYWQgb3ZlciB0byBodHRwOi8vd3d3LkNBY2VydC5vcmcwQAYD
VR0lBDkwNwYIKwYBBQUHAwQGCCsGAQUFBwMCBgorBgEEAYI3CgMEBgorBgEEAYI3CgMDBglghkgB
hvhCBAEwMgYIKwYBBQUHAQEEJjAkMCIGCCsGAQUFBzABhhZodHRwOi8vb2NzcC5jYWNlcnQub3Jn
MEQGA1UdEQQ9MDuBFWNhbGVzdHlvQHNjaWVudGlhLm5ldIEibWFpbEBjaHJpc3RvcGguYW50b24u
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
+G8T/HNZ92ZCdB6K4/jc0m+YnMtHmJVABfvpAgMBAAGjgb8wgbwwDwYDVR0TAQH/BAUwAwEB/zBd
BggrBgEFBQcBAQRRME8wIwYIKwYBBQUHMAGGF2h0dHA6Ly9vY3NwLkNBY2VydC5vcmcvMCgGCCsG
AQUFBzAChhxodHRwOi8vd3d3LkNBY2VydC5vcmcvY2EuY3J0MEoGA1UdIARDMEEwPwYIKwYBBAGB
kEowMzAxBggrBgEFBQcCARYlaHR0cDovL3d3dy5DQWNlcnQub3JnL2luZGV4LnBocD9pZD0xMDAN
BgkqhkiG9w0BAQQFAAOCAgEAfwiIodoaUEnaifuhCHLzivcexDq0eVsgMLFF3sJd02Vp8cJdVFQ8
hV+5e0KRwpn9G1Gbq0aloRBTnm2IrHNuLDOm8PSe4HXBPohFqeFmQ/5WWtF6QXj3QNpKOvELW6W7
FgbmwueTuYVNl0+xHjhDgO+bDYzvuKdgAIdXfR5EHMsj75s8mZ2vtSkcRXkWlk0nbfEcbMPCVWSz
vBTi86QfHjL8JxUFz90urj6CYXvwIRAY9kTqUzn53NCaIODGu+C7Wk/EmcgHvbW9otsuYg1CNEG8
/4uK9VEiqogwAOKw1Ly+ZbrVA1d5m+jcyE34UO2RpVIooqz7Nlg+6ZQrkVCHG9Ze1ozM9w8QDFJO
0BZh5eUKbL8Xx3JGV5yY9WxgY3pvXrlOL8i5ubtqhbyYDe35PpeENJSuAK+h5eeSbk698+LZFItc
0usBbKAXpS0Q65x6Sr297s797SJAq3A4iPUKh2rCqwVgyUgF2lPB3kR3arPzPDztgLymOEopJF/+
WTubJXpWYwBkuV2kYn1XNk+tg+8fklOgjndX3eVhET0jAJBMPPqjYJMEo6819g5qj09KYKeFBWxG
oY/0x3bjoVlX93GyxG4UXG1tQWbfG5Ox1ADD7svPPD0hgKlfY2X83eBfpPQr8IVxQdRnJfsasZeu
1pmCE0HSbqUbmSeA5wupqAAxggLtMIIC6QIBATBbMFQxFDASBgNVBAoTC0NBY2VydCBJbmMuMR4w
HAYDVQQLExVodHRwOi8vd3d3LkNBY2VydC5vcmcxHDAaBgNVBAMTE0NBY2VydCBDbGFzcyAzIFJv
b3QCAwEBgjANBglghkgBZQMEAgMFAKCCAWMwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkq
hkiG9w0BCQUxDxcNMTMwNzIzMTYyNjEwWjBPBgkqhkiG9w0BCQQxQgRAfA3yMhSpcpKnHmkHHzn2
/fbeBa90b+Kv/qNFHViDekcJ7UFO8VYQCRV34TjD5yFZUdl0rYUviTSd7vyE/DxWXDBqBgkrBgEE
AYI3EAQxXTBbMFQxFDASBgNVBAoTC0NBY2VydCBJbmMuMR4wHAYDVQQLExVodHRwOi8vd3d3LkNB
Y2VydC5vcmcxHDAaBgNVBAMTE0NBY2VydCBDbGFzcyAzIFJvb3QCAwEBgjBsBgsqhkiG9w0BCRAC
CzFdoFswVDEUMBIGA1UEChMLQ0FjZXJ0IEluYy4xHjAcBgNVBAsTFWh0dHA6Ly93d3cuQ0FjZXJ0
Lm9yZzEcMBoGA1UEAxMTQ0FjZXJ0IENsYXNzIDMgUm9vdAIDAQGCMA0GCSqGSIb3DQEBAQUABIIB
AH6z6JN4deuvMYr9pfFIhYBvhGdKOPTFvr+501vJ5NR18v50xxDSNkQXhruh6AWQBDvoqXrt7XZT
JtoUgvxDG2oYh77BU2XtkZoXKYc3FXI/zPc2x7RB7EYmRyxPTMOHrz+k3gYFSLIzELII3s7a24um
qk5Wj2v7+fjlUYYRVK5s3yKPKtmH0GVXTbDfY/Z5EEbxfL8tfGQXIZmIbR7gWLYrWSQ8Y3/xp9ga
Z2IgGGSyRLyniASVKpRRYEVQjL4Jv74BmT/IrjIOsLnNgqVCLKxDEDtsmqMuQ5J1c1XxypIip7wR
oS0jR3pgJON/4aTKWu+54INGDyeqE3ki2GtoNtIAAAAAAAA=


--=-D5aC47UfuMYmQpkTvZ5n--

