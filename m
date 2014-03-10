From: NeilBrown <neilb@suse.de>
Subject: Re: I've made a bit of a mess in my raid setup
Date: Mon, 10 Mar 2014 13:51:33 +1100
Message-ID: <20140310135133.1d67df6b@notabene.brown>
References: <CAFRU1XuCKyfL7uMa0wJj0dUjHyhBDp933_O4+TsQk33KM6brUA@mail.gmail.com>
	<531AF967.60500@grumpydevil.homelinux.org>
	<CAFRU1XsTdqVZ8bHumH3m-xfTK1M6u29U4H3ZDKNa_TZ=gKR_tg@mail.gmail.com>
	<531B0229.7030800@grumpydevil.homelinux.org>
	<CAFRU1XueM=bR0XXxskgwSGAcM_eXsDrsTVdF9V6GBvP9eZNs2w@mail.gmail.com>
	<531B1098.8080305@grumpydevil.homelinux.org>
	<531B6EA2.8080702@gmail.com>
	<CAFRU1Xs+hKhsJnRap2cARc=Z8W13sftna728WLJs3MGOM+VZag@mail.gmail.com>
	<531C1F3B.8050308@gmail.com>
	<CAFRU1Xsoxq679xd7vp60eKsOmM_QSdKLwE8BJ+TxAFoTQqJVYQ@mail.gmail.com>
	<CAFRU1Xui7cNnbOrqq8oFJAwU5UZ7vRuz3LHg160x9Auiz+jRfA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/qJf_m/JARP27MNIm8Ucz6/R"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFRU1Xui7cNnbOrqq8oFJAwU5UZ7vRuz3LHg160x9Auiz+jRfA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Federico Foschini <undicizeri@gmail.com>
Cc: Can Jeuleers <can.jeuleers@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/qJf_m/JARP27MNIm8Ucz6/R
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 9 Mar 2014 11:34:56 +0100 Federico Foschini <undicizeri@gmail.com>
wrote:

> Hello,
> I've consolidated the state of the system, these are the details:
>=20
> http://pastebin.com/k7wGpw8F

(why do people insist on use pastebin rather than just including all the in=
fo
directly in the email !?!?!)

Based on this info the first thing to do it
  mdadm /dev/md1 --add /dev/md0

and wait for it to rebuild.

Then you need to make sure it starts properly on reboot...

What do you  have  in
   /etc/mdadm.conf
(or maybe /etc/mdadm/mdadm.conf on ubuntu) ??

What is in that file in the initrd?

 zcat /boot/initrd | cpio -i --to-stdout etc/mdadm.conf

md0 needs to be listed before md1.  If not you should  change that.

However it could just be that Ubuntu's boot process is broken for multi-lev=
el
arrays - it is easy to get wrong and not often tested.


>=20
> Notice how /dev/md0 has the Name : petra:md1 and /dev/md1 doesn't have
> any superblock. Also it appears there is an old mdadm superblock on
> /dev/sda1 with my previous array configuration.

md1 does not have a superblock because it is not part of any array.
The components that make up md1 have superblocks.

As suggested  by others,
  mdadm --zero-super /dev/sda1
will remove that old superblock.

You can also remove the partition tables from /dev/sd[ab]1 with
  dd if=3D/dev/zero count=3D1 > /dev/sda1
etc.

NeilBrown

>=20
> So now what I'm trying to achive is this configuration: removing the
> hold partitions /dev/sda1 and /dev/sdb1 with the old superblock (by
> the way how is it possible i'm using an array with /dev/sda and
> /dev/sdb while these devices contains an old partition?) Configuring
> correctly the raid 1 array with /dev/sdd and /dev/md0
>=20
> 2014-03-09 9:31 GMT+01:00 Federico Foschini <undicizeri@gmail.com>:
> > Done and rebooted. I'm in the same condition as before. Also when I
> > update the initrd a message said "/dev/md1 doesn't appear to be
> > active"
> >
> > 2014-03-09 8:58 GMT+01:00 Can Jeuleers <can.jeuleers@gmail.com>:
> >> On 03/08/2014 09:23 PM, Federico Foschini wrote:
> >>> What is going on? Why /dev/md1 is now inactive and /dev/sdd is busy?
> >>
> >> I don't know Federico, but have you tried updating your initrd and
> >> rebooting? So that the assembly that takes place at boot uses the same
> >> configuration as it would post-boot?
> >>
> >
> >
> >
> > --
> > Federico Foschini.
>=20
>=20
>=20


--Sig_/qJf_m/JARP27MNIm8Ucz6/R
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUx0otTnsnt1WYoG5AQKGNxAAmyaxidC4tCKAtxYAHzT/y98+6abRYibB
Hre5qDzWQHx4UpvlqOVAXJTS3gHCX03GGeQHRS3FH17FjgzoYV8kFv/BJg3tyDj5
Sxo28w4gVY/APPOd1n/zR0AWX90WeUrSGd+A6FnwvGRsFuSUPXDfD1MWUdb54al8
Wd3HYuOu1kIEkTG4FUeI2c3xUMeOC5TrTdIkrczjLFQDJsWC14QR/I8eYXs8aMR7
opAKSfw8+pBp4Sg9B5d9D1B34fBV+o5bZoZy4ahBlFJTXPg66ffY7RB10cw9/7pe
a1RKToPWBoyWAW4UCYpEd+kcKKZ/8YIDM6nKCzyut/Qt4zcl8lrGudqt4ee1iOVY
2UdTk1wZIbVRnbt4RbhJID4bcDzCe1gyU6ESg46g0ue71B6OkoFz0SN/oo+zkSlr
HLZq1FYCZMFFZWBatXMvUxZvI4uGoD+5HSnakergn/JXtChpzRhiGKKsGrcz9Ico
j9S054b5uugpOXkiwJc8iZuh1ReevCmtPwKejMzefrMXovpX/dXHe1o3QptNHqIv
ahlMxRmTAmJ8G+8LFqhpXILLE0LKZqiOurOOYCzxm73xdIlxXB2yV2yA6++87E47
qmAd+G53Evwi9S4+f05DZ4SOuZzgk5DsNS47q6JWh+VRvtdwm2Uj5O6BCJ7x1nK3
RZZgde8fpEo=
=EcUq
-----END PGP SIGNATURE-----

--Sig_/qJf_m/JARP27MNIm8Ucz6/R--
