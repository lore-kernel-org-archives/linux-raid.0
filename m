From: Christoph Anton Mitterer <calestyo@scientia.net>
Subject: unexpected speed difference at RAID initialisation
Date: Sat, 09 May 2015 00:47:19 +0200
Message-ID: <1431125239.6206.11.camel@scientia.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="sha-512";
	protocol="application/x-pkcs7-signature";
	boundary="=-nbZ/YYm6aD8iLRJQc6gb"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-nbZ/YYm6aD8iLRJQc6gb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hey.

I'm just deploying some new servers at the faculty, where I made the
following strange observation, which I cannot explain.

All nodes have exactly the same hardware (all recent stuff, some 15k=E2=82=
=AC
Dell servers with 16 disks =C3=A1 6 TB, plenty of CPU), the same
BIOS/firmware config, the same OS (Debian jessie, except the kernel
4.0.0 from experimental and btrfs-tools 4.0 from sid) with identical
config.

The discs are connected via some Dell PERC RAID controller but for
testing they're exported as JBODs.

Nothing except some standard daemons (haveged, irqbalance and that like)
are running on these nodes.


I created an MD RAID6 over all disks via:
mdadm --create /dev/md/data-test-raid --verbose --metadata=3D1.2
--size=3Dmax --chunk=3D512K --level=3Draid6 --bitmap=3Dinternal
--name=3Ddata-test-raid --raid-devices=3D16
--spare-devices=3D0 /dev/sda /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf /=
dev/sdg /dev/sdh /dev/sdi /dev/sdj /dev/sdk /dev/sdl /dev/sdm /dev/sdn /dev=
/sdo /dev/sdp
basically at the same time (few seconds difference) on both nodes.


But looking at the initial rebuild on two nodes, one can see substantial
speed differences:
node A:=20
# cat /proc/mdstat=20
Personalities : [raid6] [raid5] [raid4]=20
md127 : active raid6 sdp[15] sdo[14] sdn[13] sdm[12] sdl[11] sdk[10] sdj[9]=
 sdi[8] sdh[7] sdg[6] sdf[5] sde[4] sdd[3] sdc[2] sdb[1] sda[0]
      82045479936 blocks super 1.2 level 6, 512k chunk, algorithm 2 [16/16]=
 [UUUUUUUUUUUUUUUU]
      [=3D=3D=3D=3D=3D>...............]  resync =3D 28.8% (1691996416/58603=
91424) finish=3D841.8min speed=3D82526K/sec
      bitmap: 32/44 pages [128KB], 65536KB chunk

unused devices: <none>

node B:=20
# cat /proc/mdstat=20
Personalities : [raid6] [raid5] [raid4]=20
md127 : active raid6 sdp[15] sdo[14] sdn[13] sdm[12] sdl[11] sdk[10] sdj[9]=
 sdi[8] sdh[7] sdg[6] sdf[5] sde[4] sdd[3] sdc[2] sdb[1] sda[0]
      82045479936 blocks super 1.2 level 6, 512k chunk, algorithm 2 [16/16]=
 [UUUUUUUUUUUUUUUU]
      [=3D=3D=3D=3D>................]  resync =3D 20.1% (1180137984/5860391=
424) finish=3D1496.2min speed=3D52132K/sec
      bitmap: 36/44 pages [144KB], 65536KB chunk

unused devices: <none>

(again taken with only few seconds in between).

As you can see it already shows different speed (~80000K/s for node A
and ~50000K/s for node B).


dmesg on A gives:
[ 8333.919976] md: bind<sda>
[ 8333.920285] md: bind<sdb>
[ 8333.920553] md: bind<sdc>
[ 8333.920831] md: bind<sdd>
[ 8333.921092] md: bind<sde>
[ 8333.921344] md: bind<sdf>
[ 8333.921593] md: bind<sdg>
[ 8333.921853] md: bind<sdh>
[ 8333.922093] md: bind<sdi>
[ 8333.922377] md: bind<sdj>
[ 8333.922694] md: bind<sdk>
[ 8333.922973] md: bind<sdl>
[ 8333.923235] md: bind<sdm>
[ 8333.923502] md: bind<sdn>
[ 8333.923744] md: bind<sdo>
[ 8333.923941] md: bind<sdp>
[ 8334.002228] raid6: sse2x1    2651 MB/s
[ 8334.070159] raid6: sse2x2    7676 MB/s
[ 8334.138090] raid6: sse2x4   13690 MB/s
[ 8334.206027] raid6: avx2x1   18736 MB/s
[ 8334.273958] raid6: avx2x2   21984 MB/s
[ 8334.341893] raid6: avx2x4   24764 MB/s
[ 8334.341904] raid6: using algorithm avx2x4 (24764 MB/s)
[ 8334.341923] raid6: using avx2x2 recovery algorithm
[ 8334.342962] async_tx: api initialized (async)
[ 8334.343648] xor: automatically using best checksumming function:
[ 8334.381855]    avx       : 30433.000 MB/sec
[ 8334.386213] md: raid6 personality registered for level 6
[ 8334.386235] md: raid5 personality registered for level 5
[ 8334.386255] md: raid4 personality registered for level 4
[ 8334.428030] md/raid:md127: not clean -- starting background reconstructi=
on
[ 8334.428133] md/raid:md127: device sdp operational as raid disk 15
[ 8334.428157] md/raid:md127: device sdo operational as raid disk 14
[ 8334.428180] md/raid:md127: device sdn operational as raid disk 13
[ 8334.428203] md/raid:md127: device sdm operational as raid disk 12
[ 8334.428226] md/raid:md127: device sdl operational as raid disk 11
[ 8334.428248] md/raid:md127: device sdk operational as raid disk 10
[ 8334.428272] md/raid:md127: device sdj operational as raid disk 9
[ 8334.428294] md/raid:md127: device sdi operational as raid disk 8
[ 8334.428756] md/raid:md127: device sdh operational as raid disk 7
[ 8334.429108] md/raid:md127: device sdg operational as raid disk 6
[ 8334.429450] md/raid:md127: device sdf operational as raid disk 5
[ 8334.429754] md/raid:md127: device sde operational as raid disk 4
[ 8334.430062] md/raid:md127: device sdd operational as raid disk 3
[ 8334.430329] md/raid:md127: device sdc operational as raid disk 2
[ 8334.430595] md/raid:md127: device sdb operational as raid disk 1
[ 8334.430845] md/raid:md127: device sda operational as raid disk 0
[ 8334.432415] md/raid:md127: allocated 0kB
[ 8334.432749] md/raid:md127: raid level 6 active with 16 out of 16 devices=
, algorithm 2
[ 8334.433021] RAID conf printout:
[ 8334.433022]  --- level:6 rd:16 wd:16
[ 8334.433023]  disk 0, o:1, dev:sda
[ 8334.433024]  disk 1, o:1, dev:sdb
[ 8334.433025]  disk 2, o:1, dev:sdc
[ 8334.433026]  disk 3, o:1, dev:sdd
[ 8334.433027]  disk 4, o:1, dev:sde
[ 8334.433028]  disk 5, o:1, dev:sdf
[ 8334.433029]  disk 6, o:1, dev:sdg
[ 8334.433030]  disk 7, o:1, dev:sdh
[ 8334.433031]  disk 8, o:1, dev:sdi
[ 8334.433032]  disk 9, o:1, dev:sdj
[ 8334.433032]  disk 10, o:1, dev:sdk
[ 8334.433033]  disk 11, o:1, dev:sdl
[ 8334.433034]  disk 12, o:1, dev:sdm
[ 8334.433035]  disk 13, o:1, dev:sdn
[ 8334.433036]  disk 14, o:1, dev:sdo
[ 8334.433037]  disk 15, o:1, dev:sdp
[ 8334.433257] created bitmap (44 pages) for device md127
[ 8334.437094] md127: bitmap initialized from disk: read 3 pages, set 89423=
 of 89423 bits
[ 8334.492393] md127: detected capacity change from 0 to 84014571454464
[ 8334.492438] md: md127 switched to read-write mode.
[ 8334.518862] md: resync of RAID array md127
[ 8334.519677] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[ 8334.520329] md: using maximum available idle IO bandwidth (but not more =
than 200000 KB/sec) for resync.
[ 8334.521357] md: using 128k window, over a total of 5860391424k.


and on B:
[ 8269.297090] md: bind<sda>
[ 8269.297414] md: bind<sdb>
[ 8269.297689] md: bind<sdc>
[ 8269.297957] md: bind<sdd>
[ 8269.298230] md: bind<sde>
[ 8269.298487] md: bind<sdf>
[ 8269.298753] md: bind<sdg>
[ 8269.299006] md: bind<sdh>
[ 8269.299260] md: bind<sdi>
[ 8269.299522] md: bind<sdj>
[ 8269.299778] md: bind<sdk>
[ 8269.300061] md: bind<sdl>
[ 8269.300326] md: bind<sdm>
[ 8269.300543] md: bind<sdn>
[ 8269.300912] md: bind<sdo>
[ 8269.301123] md: bind<sdp>
[ 8269.372959] raid6: sse2x1    2622 MB/s
[ 8269.440892] raid6: sse2x2    4685 MB/s
[ 8269.508815] raid6: sse2x4    9777 MB/s
[ 8269.576747] raid6: avx2x1   16486 MB/s
[ 8269.644680] raid6: avx2x2   21875 MB/s
[ 8269.712615] raid6: avx2x4   25242 MB/s
[ 8269.712632] raid6: using algorithm avx2x4 (25242 MB/s)
[ 8269.712652] raid6: using avx2x2 recovery algorithm
[ 8269.713686] async_tx: api initialized (async)
[ 8269.714400] xor: automatically using best checksumming function:
[ 8269.752579]    avx       : 30506.000 MB/sec
[ 8269.757308] md: raid6 personality registered for level 6
[ 8269.757339] md: raid5 personality registered for level 5
[ 8269.757365] md: raid4 personality registered for level 4
[ 8269.782660] md/raid:md127: not clean -- starting background reconstructi=
on
[ 8269.782767] md/raid:md127: device sdp operational as raid disk 15
[ 8269.782797] md/raid:md127: device sdo operational as raid disk 14
[ 8269.782827] md/raid:md127: device sdn operational as raid disk 13
[ 8269.782855] md/raid:md127: device sdm operational as raid disk 12
[ 8269.782884] md/raid:md127: device sdl operational as raid disk 11
[ 8269.782912] md/raid:md127: device sdk operational as raid disk 10
[ 8269.782941] md/raid:md127: device sdj operational as raid disk 9
[ 8269.782969] md/raid:md127: device sdi operational as raid disk 8
[ 8269.783539] md/raid:md127: device sdh operational as raid disk 7
[ 8269.783965] md/raid:md127: device sdg operational as raid disk 6
[ 8269.784395] md/raid:md127: device sdf operational as raid disk 5
[ 8269.784776] md/raid:md127: device sde operational as raid disk 4
[ 8269.785106] md/raid:md127: device sdd operational as raid disk 3
[ 8269.785425] md/raid:md127: device sdc operational as raid disk 2
[ 8269.785718] md/raid:md127: device sdb operational as raid disk 1
[ 8269.786012] md/raid:md127: device sda operational as raid disk 0
[ 8269.787672] md/raid:md127: allocated 0kB
[ 8269.788026] md/raid:md127: raid level 6 active with 16 out of 16 devices=
, algorithm 2
[ 8269.788349] RAID conf printout:
[ 8269.788351]  --- level:6 rd:16 wd:16
[ 8269.788352]  disk 0, o:1, dev:sda
[ 8269.788354]  disk 1, o:1, dev:sdb
[ 8269.788355]  disk 2, o:1, dev:sdc
[ 8269.788356]  disk 3, o:1, dev:sdd
[ 8269.788357]  disk 4, o:1, dev:sde
[ 8269.788358]  disk 5, o:1, dev:sdf
[ 8269.788359]  disk 6, o:1, dev:sdg
[ 8269.788360]  disk 7, o:1, dev:sdh
[ 8269.788361]  disk 8, o:1, dev:sdi
[ 8269.788362]  disk 9, o:1, dev:sdj
[ 8269.788364]  disk 10, o:1, dev:sdk
[ 8269.788365]  disk 11, o:1, dev:sdl
[ 8269.788366]  disk 12, o:1, dev:sdm
[ 8269.788367]  disk 13, o:1, dev:sdn
[ 8269.788368]  disk 14, o:1, dev:sdo
[ 8269.788369]  disk 15, o:1, dev:sdp
[ 8269.788589] created bitmap (44 pages) for device md127
[ 8269.791496] md127: bitmap initialized from disk: read 3 pages, set 89423=
 of 89423 bits
[ 8269.807348] md127: detected capacity change from 0 to 84014571454464
[ 8269.807896] md: md127 switched to read-write mode.
[ 8269.808387] md: resync of RAID array md127
[ 8269.808685] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[ 8269.808980] md: using maximum available idle IO bandwidth (but not more =
than 200000 KB/sec) for resync.
[ 8269.809504] md: using 128k window, over a total of 5860391424k.


There's a bigger difference at:
[ 8334.341904] raid6: using algorithm avx2x4 (24764 MB/s)
vs.
[ 8269.712632] raid6: using algorithm avx2x4 (25242 MB/s)

How are these numbers determined?


Further:
node A:
# ps ax  | grep md127
  7550 ?        S    273:47 [md127_raid6]
  7552 ?        D     79:43 [md127_resync]


node B:
# ps ax  | grep md127
  7494 ?        R    251:30 [md127_raid6]
  7495 ?        D     63:48 [md127_resync]



Any ideas where this performance difference could come from?


Thanks,
Chris.

--=-nbZ/YYm6aD8iLRJQc6gb
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgMFADCABgkqhkiG9w0BBwEAAKCCEZIw
ggW/MIIDp6ADAgECAgMCOakwDQYJKoZIhvcNAQENBQAwVDEUMBIGA1UEChMLQ0FjZXJ0IEluYy4x
HjAcBgNVBAsTFWh0dHA6Ly93d3cuQ0FjZXJ0Lm9yZzEcMBoGA1UEAxMTQ0FjZXJ0IENsYXNzIDMg
Um9vdDAeFw0xNDA2MTIxNjM2MThaFw0xNjA2MTExNjM2MThaMHwxITAfBgNVBAMTGENocmlzdG9w
aCBBbnRvbiBNaXR0ZXJlcjEkMCIGCSqGSIb3DQEJARYVY2FsZXN0eW9Ac2NpZW50aWEubmV0MTEw
LwYJKoZIhvcNAQkBFiJtYWlsQGNocmlzdG9waC5hbnRvbi5taXR0ZXJlci5uYW1lMIIBIjANBgkq
hkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA4phP/j9vT9dZT+k3ffHxvRWMOuzBnu5O3Fl4y2+WL7pL
rfLiEhWzGXhHvjSqpt4vCNSdqy43453nnu8+hMb+uEtqSIL1AHU5eLhuDNVN9S4bt9E7nA2WKYBU
LCUi/xCD/GL7ToyJNwhrhzcCZ7pXSc3xVqFoC4f6weU9ExhoEZQNRpTM0BFCOi4fRxvKFNnUYgjK
hqy0Ta5H0Xx86mAp0Q4dxoD7mhI5iTF6TRkUheELxF24JCuAf04M89Cwft6DRH1FpJ3yvgW2B5U5
aFSL4ZnF4N/wyCB7Dkm1rQ7RCAvw5btkf0VdPnU7ccDCx8HEc2nxK/lbCjrznvh3sa1CCwIDAQAB
o4IBcDCCAWwwDAYDVR0TAQH/BAIwADBWBglghkgBhvhCAQ0ESRZHVG8gZ2V0IHlvdXIgb3duIGNl
cnRpZmljYXRlIGZvciBGUkVFIGhlYWQgb3ZlciB0byBodHRwOi8vd3d3LkNBY2VydC5vcmcwDgYD
VR0PAQH/BAQDAgOoMEAGA1UdJQQ5MDcGCCsGAQUFBwMEBggrBgEFBQcDAgYKKwYBBAGCNwoDBAYK
KwYBBAGCNwoDAwYJYIZIAYb4QgQBMDIGCCsGAQUFBwEBBCYwJDAiBggrBgEFBQcwAYYWaHR0cDov
L29jc3AuY2FjZXJ0Lm9yZzA4BgNVHR8EMTAvMC2gK6AphidodHRwOi8vY3JsLmNhY2VydC5vcmcv
Y2xhc3MzLXJldm9rZS5jcmwwRAYDVR0RBD0wO4EVY2FsZXN0eW9Ac2NpZW50aWEubmV0gSJtYWls
QGNocmlzdG9waC5hbnRvbi5taXR0ZXJlci5uYW1lMA0GCSqGSIb3DQEBDQUAA4ICAQBefctiLgGl
e5baspuozyA4k7Up7SVhGHbif6pQfoFc/9Thx9GXnYpX+U64PMyWBfWwHZIy52Vg0RVkvPi1t6mi
GyBfoSpC6ooR0bKWtUIogw/ymqKWlTLVR8kbLqRmRk4juMtCXG2K3yMygX/rjkuUSuFj2Bjpkmzg
CtMojbUMYbszePmhQ7DJ62YEdtKpcjN94QAsI5GWlIAbs3KJazAcaNCRJeXCLcUMchyKHJA+NXH5
az/ekBxBMBzJP2An20PP88UI4JW18z31KiG9UVGa2uO4l4aWgVe2GnhNEdCD/o48msJEWKAt5vl2
yMqr7ihmNPocU2+/FW0xPe/vftdOTD9pgXdSGf4prdD+23q2YvpalOCzr2p8yCJZNVBPMxAP4mL0
3OEktXza4wohqAmceXKfGUNwRGBaPvtIGnPrpLhCQ+2YJDg8g1UEsk23bKyZlJWeKJyVqOBsDJmj
aBsN/qKhQFnav+zQdqGhMeaSisF/53mD3gyVYg2JRl18apgGbg32kyLmomqa0JbhnY3Dc3FVtZfe
+P+s2Cyep3pVKvFer2llRoGm8TwraG5Yhyx8Oq/1qETpstjbURJOVBLDCV4AjOEUj0ZnE/tEo/DK
yexgGaViNvjp+IZdFdJhYmsVjw4Q3vG7O0pfsLiYEyQjeDgjNEWDfa5/MufPywIfxzCCBb8wggOn
oAMCAQICAwI5qTANBgkqhkiG9w0BAQ0FADBUMRQwEgYDVQQKEwtDQWNlcnQgSW5jLjEeMBwGA1UE
CxMVaHR0cDovL3d3dy5DQWNlcnQub3JnMRwwGgYDVQQDExNDQWNlcnQgQ2xhc3MgMyBSb290MB4X
DTE0MDYxMjE2MzYxOFoXDTE2MDYxMTE2MzYxOFowfDEhMB8GA1UEAxMYQ2hyaXN0b3BoIEFudG9u
IE1pdHRlcmVyMSQwIgYJKoZIhvcNAQkBFhVjYWxlc3R5b0BzY2llbnRpYS5uZXQxMTAvBgkqhkiG
9w0BCQEWIm1haWxAY2hyaXN0b3BoLmFudG9uLm1pdHRlcmVyLm5hbWUwggEiMA0GCSqGSIb3DQEB
AQUAA4IBDwAwggEKAoIBAQDimE/+P29P11lP6Td98fG9FYw67MGe7k7cWXjLb5Yvukut8uISFbMZ
eEe+NKqm3i8I1J2rLjfjneee7z6Exv64S2pIgvUAdTl4uG4M1U31Lhu30TucDZYpgFQsJSL/EIP8
YvtOjIk3CGuHNwJnuldJzfFWoWgLh/rB5T0TGGgRlA1GlMzQEUI6Lh9HG8oU2dRiCMqGrLRNrkfR
fHzqYCnRDh3GgPuaEjmJMXpNGRSF4QvEXbgkK4B/Tgzz0LB+3oNEfUWknfK+BbYHlTloVIvhmcXg
3/DIIHsOSbWtDtEIC/Dlu2R/RV0+dTtxwMLHwcRzafEr+VsKOvOe+HexrUILAgMBAAGjggFwMIIB
bDAMBgNVHRMBAf8EAjAAMFYGCWCGSAGG+EIBDQRJFkdUbyBnZXQgeW91ciBvd24gY2VydGlmaWNh
dGUgZm9yIEZSRUUgaGVhZCBvdmVyIHRvIGh0dHA6Ly93d3cuQ0FjZXJ0Lm9yZzAOBgNVHQ8BAf8E
BAMCA6gwQAYDVR0lBDkwNwYIKwYBBQUHAwQGCCsGAQUFBwMCBgorBgEEAYI3CgMEBgorBgEEAYI3
CgMDBglghkgBhvhCBAEwMgYIKwYBBQUHAQEEJjAkMCIGCCsGAQUFBzABhhZodHRwOi8vb2NzcC5j
YWNlcnQub3JnMDgGA1UdHwQxMC8wLaAroCmGJ2h0dHA6Ly9jcmwuY2FjZXJ0Lm9yZy9jbGFzczMt
cmV2b2tlLmNybDBEBgNVHREEPTA7gRVjYWxlc3R5b0BzY2llbnRpYS5uZXSBIm1haWxAY2hyaXN0
b3BoLmFudG9uLm1pdHRlcmVyLm5hbWUwDQYJKoZIhvcNAQENBQADggIBAF59y2IuAaV7ltqym6jP
IDiTtSntJWEYduJ/qlB+gVz/1OHH0Zedilf5Trg8zJYF9bAdkjLnZWDRFWS8+LW3qaIbIF+hKkLq
ihHRspa1QiiDD/KaopaVMtVHyRsupGZGTiO4y0JcbYrfIzKBf+uOS5RK4WPYGOmSbOAK0yiNtQxh
uzN4+aFDsMnrZgR20qlyM33hACwjkZaUgBuzcolrMBxo0JEl5cItxQxyHIockD41cflrP96QHEEw
HMk/YCfbQ8/zxQjglbXzPfUqIb1RUZra47iXhpaBV7YaeE0R0IP+jjyawkRYoC3m+XbIyqvuKGY0
+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
AukCAQEwWzBUMRQwEgYDVQQKEwtDQWNlcnQgSW5jLjEeMBwGA1UECxMVaHR0cDovL3d3dy5DQWNl
cnQub3JnMRwwGgYDVQQDExNDQWNlcnQgQ2xhc3MgMyBSb290AgMCOakwDQYJYIZIAWUDBAIDBQCg
ggFjMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE1MDUwODIyNDcx
OVowTwYJKoZIhvcNAQkEMUIEQCzoY7JppTzQOZju2jDLTVdT8SJhsU6jd8WnlwrDpvjv/zKQJ9se
AKKexao1xjMeatCw96y2MoZibzutmWoydjYwagYJKwYBBAGCNxAEMV0wWzBUMRQwEgYDVQQKEwtD
QWNlcnQgSW5jLjEeMBwGA1UECxMVaHR0cDovL3d3dy5DQWNlcnQub3JnMRwwGgYDVQQDExNDQWNl
cnQgQ2xhc3MgMyBSb290AgMCOakwbAYLKoZIhvcNAQkQAgsxXaBbMFQxFDASBgNVBAoTC0NBY2Vy
dCBJbmMuMR4wHAYDVQQLExVodHRwOi8vd3d3LkNBY2VydC5vcmcxHDAaBgNVBAMTE0NBY2VydCBD
bGFzcyAzIFJvb3QCAwI5qTANBgkqhkiG9w0BAQEFAASCAQC5STeAAFTHMFCyq9bpjPdqkYF9/9Yh
P91MgF6BsmrxLXWfjcHuc94MVa7nsRJhxVK1u6iOmdIRh/WirOJH7v3jSSDbyuHqb3nK80J1wfEO
zvtfcYDd6XUgWiWnCHXs3viIGEa3EJhRU3c5z6u8r7OE5dO+RXrU8kwddztNYgL0R7hdxrzs8z3Z
7leGSuXGOtZROInI/oCXMH0jelkF62Dnw91nuUkN2zUvad9TgCzP2Iar0FfkfNL2xENXvZn8gRv1
Zansuq7w7brXGmIGIQuAxzChVUEO/OiSZ6aEasuvvlCuTNEh2l0UXQmyiXp5ebWMwGQ6B0gVdRY4
brjTy/ypAAAAAAAA


--=-nbZ/YYm6aD8iLRJQc6gb--

