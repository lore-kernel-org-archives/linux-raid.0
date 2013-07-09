From: NeilBrown <neilb@suse.de>
Subject: Re: Extending a =?UTF-8?B?NMOXM1Ri?= RAID10
Date: Wed, 10 Jul 2013 07:24:39 +1000
Message-ID: <20130710072439.02e4288e@notabene.brown>
References: <20130709182222.GA3952@fishbowl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/.Wj_gMNKJY3mqkSRAo6GJhc"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130709182222.GA3952@fishbowl>
Sender: linux-raid-owner@vger.kernel.org
To: martin f krafft <madduck@madduck.net>
Cc: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/.Wj_gMNKJY3mqkSRAo6GJhc
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 9 Jul 2013 20:22:22 +0200 martin f krafft <madduck@madduck.net> wro=
te:

> Hello,
>=20
> We have a RAID10 across 4 3TB drives (metadata version 1.2,
> 2 offset-copies, bitmaps), with LVM on top. We are running out of
> space, but we don't really want to invest in 4 new 4TB drives right
> now.
>=20
> Is it possible to replace only two of the 3TB drives with 4TB drives
> and get an extra terrabyte into the array somehow?
>=20
> Anything I tried so far on a test system didn't work. I can add the
> new devices to the RAID, but if I try to grow the array to the new
> size, I get:
>=20
>   mdadm: component size of /dev/md2 unchanged at X
>=20
> Do I have to fail two drives, create a new RAID10, add a new LVM PV
> on it, and pvmove the data over, all the while hoping that none of
> the four disks die =E2=80=94 even though there is a backup (the two failed
> drives), that's a one-shot backup and that is too risky.
>=20
> That said, it isn't even possible to have a RAID10 across 2x2 pairs
> of disks with different sizes, is it? Why not? I'd really rather
> avoid pulling two RAID1s together with LVM, although I guess that is
> essentially the same as RAID10.

Hi Martin.

Now you cannot have any array-with-redundancy using different amounts of
different devices.  All devices must contribute equally to the array (this
doesn't apply to RAID0 or Linear, only RAID1 and higher numbers).

This is because the definition of a "spare" device would become more
complicated.  You would need two different sized spares, or have to choose
whether it is OK to use a "big" spare to replace a "small" device, or maybe
have an array with a spare and a failed device and not be able to rebuild
because the spare isn't big enough.

It really is much easier to just say "no".

To get the sort of flexibility you want you would need to have two separate
RAID1s which are combined with LVM.

NeilBrown

--Sig_/.Wj_gMNKJY3mqkSRAo6GJhc
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUdx/mDnsnt1WYoG5AQLXkw/7B3X7HI7Pmbg79s6O22l6muQxqfk6wl59
qloWexUm5KhvLneaJgDuulEiO2sO0bcKearfU0UOFE4KAvxSq60fBN6EGAxs1wgA
BhBX8eLxFpA7Zchyukfbw6+GFurIACDGnW26+fAUGSAg2fDlWvxOt2RJauiMUpQT
DaHQjQtJjjrysZb8hV+T2NrU/s10RGeH0XjEUNzl8uATMUz38Rjw4FyEE/r8iNla
LbWEyn45AY1T957V8CI2CE8CJHImTtel2CZlr1ewzwl03JiM1QipgQapiBUreOqO
8V4lzHg6llR72rTtwoQUxvv7LVR29OaxIoruJ+G4bh9WWfy5RCjn0DmTnu0nSRXE
npYPoWJ1rDny1kS9D4AhT876n+32AaR6/gv0MrtwWBVvseRJ2OjiakjBCrfftpBe
WGWtXsdHbNCGeC0nwO2ddSMX1xYjQiJk05iyGP5wRy0/Fu152QlSCsJODqlWhMZk
C3shvpoLHqHtQLHxPcVqWV3dCcWFJV7EfKkY33xGyBpXuYwluBLDe/74gLYmDIlj
58fqfSnCvob3mnUtH7v7ZhmK2b/b+xxqwciBKHGzbA1zJnzOU3At34e5lvQSqJlo
eA/0OmhEexmoUg+KzZkKZaIa+kRoJoXFb6kB8Tx1Bn6iQdxn2U4WdoExgFPnmhim
riCDTpl06vk=
=loPk
-----END PGP SIGNATURE-----

--Sig_/.Wj_gMNKJY3mqkSRAo6GJhc--
