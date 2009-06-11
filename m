From: Michael Ole Olsen <gnu@gmx.net>
Subject: Re: slow mdadm reshape, normal?
Date: Thu, 11 Jun 2009 21:45:52 +0200
Message-ID: <20090611194552.GQ30825@rlogin.dk>
References: <4A303C06.9080409@anonymous.org.uk> <20090610233659.GD30825@rlogin.dk> <20090611081909.GA16250@cthulhu.home.robinhill.me.uk> <20090611160741.GG30825@rlogin.dk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JaUdphvQ2+4F/M7k"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090611160741.GG30825@rlogin.dk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--JaUdphvQ2+4F/M7k
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Here is some new info (iostat) about the 7MB/s slowness on my reshape
with 3x sata disks on pci32bit controller and 6x sata on onboard sata2.

sata_sil and sata_nv


sda                                                                        =
                                                                           =
                                                                           =
                                       =20
200+0 records in                                                           =
                                                                           =
                                                                           =
                                       =20
200+0 records out                                                          =
                                                                           =
                                                                           =
                                       =20
209715200 bytes (210 MB) copied, 2,46597 s, 85,0 MB/s                      =
                                                                           =
                                                                           =
                                       =20
sdb                                                                        =
                                                                           =
                                                                           =
                                       =20
200+0 records in                                                           =
                                                                           =
                                                                           =
                                       =20
200+0 records out                                                          =
                                                                           =
                                                                           =
                                       =20
209715200 bytes (210 MB) copied, 1,66641 s, 126 MB/s                       =
                                                                           =
                                                                           =
                                       =20
sdc                                                                        =
                                                                           =
                                                                           =
                                       =20
200+0 records in                                                           =
                                                                           =
                                                                           =
                                       =20
200+0 records out                                                          =
                                                                           =
                                                                           =
                                       =20
209715200 bytes (210 MB) copied, 2,51205 s, 83,5 MB/s                      =
                                                                           =
                                                                           =
                                       =20
sdd                                                                        =
                                                                           =
                                                                           =
                                       =20
200+0 records in                                                           =
                                                                           =
                                                                           =
                                       =20
200+0 records out                                                          =
                                                                           =
                                                                           =
                                       =20
209715200 bytes (210 MB) copied, 2,33702 s, 89,7 MB/s                      =
                                         =20

Here the 3 of them are the ones on pci32 controller,=20
the other faster ones are on onboard non limited bus.



mfs:/sys/block/md0/md# cat /proc/mdstat=20
Personalities : [raid6] [raid5] [raid4]=20
md0 : active raid5 sdd[7] sdb[8] sda[0] sdi[6] sdh[5] sdg[4] sdf[3] sde[2] =
sdc[1]
      8790830976 blocks super 0.91 level 5, 64k chunk, algorithm 2 [9/9] [U=
UUUUUUUU]
      [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>..........]  reshape =3D 51.1% (74911=
8592/1465138496) finish=3D1652.2min speed=3D7221K/sec
     =20
unused devices: <none>



iostat about 50% in the reshape process:

mfs:/sys/block/md0/md# iostat -x
Linux 2.6.29.3mfs_diskless (mfs)        2009-06-11      _i686_

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0,16    0,00   15,15    6,41    0,00   78,28

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz =
avgqu-sz   await  svctm  %util
sda            3704,06  1627,96   80,37   42,38  3992,51 13379,26   141,52 =
    1,71   13,95   6,20  76,05
sdb              26,39  1082,62   30,03   62,18 13813,39  9170,85   249,26 =
    0,21    2,23   1,78  16,43
sdc            3724,00  1631,34   70,22   39,28  4072,93 13382,07   159,40 =
    2,28   20,79   7,90  86,48
sdd              23,03  1108,80   28,68   36,31 11215,20  9173,71   313,71 =
    0,84   12,87   8,40  54,63
sde            3632,20  1616,12  166,13   55,42  4102,69 13387,29    78,94 =
    0,75    3,39   1,29  28,48
sdf            3630,85  1615,61  166,97   55,42  4097,89 13383,03    78,60 =
    0,71    3,18   1,24  27,60
sdg            3625,92  1614,66  168,60   56,45  4071,61 13383,51    77,56 =
    0,65    2,88   1,17  26,36
sdh            3615,89  1613,62  168,65   57,71  3991,22 13385,10    76,77 =
    0,63    2,76   1,15  26,09
sdi            1457,20  3823,78   66,63   90,17 12200,35  5030,01   109,88 =
    0,74    4,69   2,16  33,89
md0               0,00     0,00    0,01  720,25     0,09 25050,75    34,78 =
    0,00    0,00   0,00   0,00
dm-0              0,00     0,00    0,01  720,25     0,08 25050,75    34,78 =
   15,42   21,41   0,25  17,96
dm-1              0,00     0,00    0,00    0,00     0,00     0,00     8,00 =
    0,00    7,95   3,21   0,00

sda,sdc,sdd =3D addon pci sata_sil pci32 card
the rest are onboard sata2 controller.

seems there is a lot of wait for those disks, and that it is the pci contro=
ller which is the cause

there seems to be only 2-4ms wait time for onboard sata disks, but 12-20ms =
on addon pci board.

also the %util is almost 100% on each of the 3 disks on the pci controller

but I still don't understand it, but somehow the whole system must be waiti=
ng for the pci bus :)

it seems there is 21ms wait time for each request due to this pci slowness.=
 (await is in miliseconds)

might be the controller that isnt so fast to do simultaneous read and write=
s,=20
perhaps because its NCQ support might be bad?

so I don't really have more ideas, except to buy a new controller card from=
 a better brand (Adaptec) :(

Im planning another reshape and I dont want it to take 3 days again.

Best Regards,
Michael Ole Olsen


On Thu, 11 Jun 2009, Michael Ole Olsen wrote:

> Thanks
>=20
> I was just hoping for something like 127MB/s divided by 3 =3D 42MB/s whic=
h=20
> is the practical limit of the pci bus assuming each disk gets its equal
> share.
>=20
> 6MB/s is only 14% of that, so I wonder where the lost bandwidth goes :)
>=20
> The reshape takes only 10-15% cpu or so on my 3ghz cpu so dont think that=
 is
> the bottleneck.
>=20
> Might be interesting to test a pci network controller at the same time ha=
d I
> installed one before the build, that way i could see if the pci bus reall=
y got
> congested.
>=20
>=20
> On Thu, 11 Jun 2009, Robin Hill wrote:
>=20
> > On Thu Jun 11, 2009 at 01:36:59AM +0200, Michael Ole Olsen wrote:
> >=20
> > > the slow disks (them with 85MB/s) in the posting are the one on the p=
ci 4x sata controller
> > >=20
> > > the 32bit pci sata (sata_sil) controller has 3 disks connected
> > >=20
> > > the onboard sata2 6x sata connectors have 6 disks connected=20
> > > (p5n32-e sli motherboard), i believe all these are sata2 and not shar=
ed with
> > > an ide controller.
> > >=20
> > > so only the pci controller should have bus limitations, but i wonder =
why it is
> > > that slow on reshape compared to build.
> > >=20
> > The build was reading (sequentially) from all drives and writing
> > (sequentially) only to one, whereas a reshape is reading from and
> > writing to all the drives (including seeking between reads & writes).
> > This means it is inevitably a lot slower.  In addition, you're now using
> > 3 rather than 2 drives on the PCI bus, which will increase the
> > congestion.
> >=20
> > Cheers,
> >     Robin
> > --=20
> >      ___       =20
> >     ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
> >    / / )      | Little Jim says ....                            |
> >   // !!       |      "He fallen in de water !!"                 |
>=20
>=20

--JaUdphvQ2+4F/M7k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQIcBAEBAgAGBQJKMV7uAAoJECXlragqp/ZIJWgP/1mi4X6HOpPEZlU+8SjEDHL8
2blzY/ajenlRtYDM+ves5NRWFtmsx//ZXzl1HhWbpYtw/XeQwj87RNFA8bRwN4yI
qDbQutB2uRXCYRg6/GHdcxx0x18PiE4eG0lvu5pz+JTECG8ge/wuNq9Pvaezhhj3
E9EVgAak9rvRRTLZCX5tPSgI4bX+2YwIe3bgUQC/pKRrD5izLcy1+Xv6s3Ex0KQC
IVglQV5DjyjxcgkGzweZnyM/N7AY6HEv4rZNu3ZY2XDSk8MjSGVA5BWnn6Pg1K36
nq1AidceCMnPEZVzRftFo2IpZnOZzpzi/5C/unOJI162D4TFldIRWSsqInz8i4to
OernMYF7dr1Afh2LQlp5ez0u54u65u/VFddRAaaFa4uAaAFa2sq2kcFBKyUJcfzw
CGZ5W6e18yEEVupDouIH0vUk4p47rW0FhsQ/nok8oXeEuBzUkd7xVUt5TswhrzIg
kvb4dYRvGktafG3dx6r6FjSMT89yvMYU+ZUWBdU0FUMcNdk0YMTwTv3ttAHjDXbs
B4+/w1sD0AnhK18b+mDOwXut8qldFAK5DU5WsPx2LCWtJcU51CqKGPvo7raCaNr7
g+5wuv/8GZz/3x89hOnQRGwDy5UsU9BbpXD5VWUfRmH1A7NA+8A9SLZN3r9KbLas
KwTRsf0LMGGDpLR3LRgG
=i2bG
-----END PGP SIGNATURE-----

--JaUdphvQ2+4F/M7k--
