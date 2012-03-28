From: NeilBrown <neilb@suse.de>
Subject: Re: RAID6 grow failed
Date: Wed, 28 Mar 2012 15:18:28 +1100
Message-ID: <20120328151828.6988d3db@notabene.brown>
References: <CAJ72viP2MLb2tL84P-aK6Rs9eAH4x9Wwd=kVNbmPA=2LAfNLjg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/0FDdDSjVpr/ZypY_a07gqYs"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJ72viP2MLb2tL84P-aK6Rs9eAH4x9Wwd=kVNbmPA=2LAfNLjg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bryan Bush <bbushvt@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/0FDdDSjVpr/ZypY_a07gqYs
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 27 Mar 2012 22:44:18 -0400 Bryan Bush <bbushvt@gmail.com> wrote:

> I hope this is the right place to ask this question.  I have at 8
> drive RAID 6 array that I wanted to grow to 13 drives (adding 5 more).
>  I issued the mdadm command and checked /proc/mdstat and all looked
> well.  However at some point in time a disk failed and that hung my
> system.  Upon reboot the array is inactive and I can't get it to
> reassemble.
>=20
> /proc/mdstat shows this
>=20
> md1 : inactive sdp1[11](S) sdi1[3](S) sdd1[7](S) sdr1[13](S)
> sdg1[1](S) sdc1[6](S) sdq1[12](S) sdn1[9](S) sdo1[10](S) sdh1[2](S)
> sda1[4](S) sdf1[0](S) sdb1[8](S)
>       25395674609 blocks super 1.2
>=20
>=20
> If I look at mdadm -E /dev/sdX1 I see most are State active, while
> some are State clean.
>=20
>=20
> root@diamond:~# mdadm -E /dev/sd[abcdfghinopqr]1
> mdadm: metadata format 01.02 unknown, ignored.
> mdadm: metadata format 00.90 unknown, ignored.

Hmmm... what do you have in /etc/mdadm.conf??


>=20
> Is there anything I can do to get the array back up?

stg1 is the device that failed. so

 mdadm -S /dev/md1
 mdadm -A -f /dev/md1 /dev/sd[abcdefhinopqr]1

should start the array.

Though if the names have changed at all it would be safer to do

  mdadm -Asf /dev/md1 -u fa32e2c5:e7bda20b:32af7c90:c7ee61eb

then mdadm will find the right devices and use them.

When reshape finishes you will need to add sdg1 or a replacement and let it
recover.

NeilBrown


--Sig_/0FDdDSjVpr/ZypY_a07gqYs
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT3KRFDnsnt1WYoG5AQK/thAArTGIWmJ0pDwxyqnRt/Uk7aRWPrYx9qQa
vW/uBnXTjDA7ll/fWXVTiUtqniDCiabciFGuamuJGHnz+L1dgo/buv+adtETe7lC
CNkaMRx98MVh0PIovhZ5V5FDKGFnnvlnAfbOKogAHIHQ6nbFST4F1QXMx0rmAUIV
Sg+7lQv/e4tOwV9NsnU6Aeb0mVTuNPeXpURH5ZQL1sgrDOT7DuInPFRLjpxD4ABK
urq7YdzlsoeWHArPfQ/nda6eO2pqEAOhmr14AJCLfB+s2gRYulUnRnenfETVCvEr
ca0diEToBK2hUH+CboOskSHRwhVrI4nvDMiDnx4TJtofsHhKpHyQyh+jgz+Urkch
JA9XW9A2ggNIYtqwwDVYqtYYESmf0HUI/lBP2Wt+1ht4hz5mEPRQPKX1MqQk4DxN
xcUdIEcpePc2iqp3X7ME8tbDU95S/hwoYH6ISPqzIpi6TJ9ELohatT++PXQ8wbeN
04Pg7EK1uJW9xKF0dnh41shL2DQ0QB7ZAYR6EYICwgXBdeir1g3Wx239MaS/qW1g
Z+JyPvK/r9umHL82GkUhNq/kHqzI2kqZbXC8DQLHHO8yxqC0D1+urKdfdy0cIfAn
LJW2LrDItJ20jgtq2lE58OMyYMcnohhKNder2qjQVKuATgPuuv/k73c9X+PjNaAP
9xdV8jt23e4=
=5xNa
-----END PGP SIGNATURE-----

--Sig_/0FDdDSjVpr/ZypY_a07gqYs--
