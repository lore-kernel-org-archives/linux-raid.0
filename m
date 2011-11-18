From: NeilBrown <neilb@suse.de>
Subject: Re: Reshape 3-drive RAID1 into 3-drive RAID-5
Date: Fri, 18 Nov 2011 13:24:50 +1100
Message-ID: <20111118132450.3299aec8@notabene.brown>
References: <CAK2H+ed1M=_N5rW5Y72Cm0_74ii=-9dCMsB7xJR4FGMST4rCjA@mail.gmail.com>
	<4EC2D58F.3070508@turmel.org>
	<20111116104045.74041bdf@notabene.brown>
	<CAK2H+ee27ukAK08X+ZVPh6t-KH+A0013DR657PJtsuTbq=95gw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/imH+GPNcwMXAI1/Sc9Z4BSB"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK2H+ee27ukAK08X+ZVPh6t-KH+A0013DR657PJtsuTbq=95gw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Phil Turmel <philip@turmel.org>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/imH+GPNcwMXAI1/Sc9Z4BSB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 17 Nov 2011 13:44:04 -0800 Mark Knecht <markknecht@gmail.com> wrote:


> Hi all,
>    After reading through your responses and going over the man pages I
> got started. Here's the set of commands I have executed so far:
>=20
> mdadm /dev/md6 --fail /dev/sdc6 --remove /dev/sdc6
> mdadm --zero-superblock /dev/sdc6
> mdadm --grow /dev/md6 --raid-devices=3D2
>=20
> At this point I appear to have a good 2-drive RAID-1:
>=20
> md6 : active raid1 sda6[0] sdb6[1]
>       247416933 blocks super 1.1 [2/2] [UU]
>=20
> The next command was supposed to convert it to RAID-5 but doesn't work
> for me so far:
>=20
> c2stable ~ # mdadm --grow /dev/md6 --level=3D5
> mdadm: /dev/md6: could not set level to raid5
> c2stable ~ #

This is because:

> /dev/md6:
>         Version : 1.1
>   Creation Time : Thu Apr 15 10:45:35 2010
>      Raid Level : raid1
>      Array Size : 247416933 (235.96 GiB 253.35 GB)
                    ^^^^^^^^^


This number is not a multiple of a usable chunk size.  I keep forgetting
about that issue.  I'll get mdadm to be more helpful in a future release.

You need to reduce the size of the array a little bit first.  That might me=
an
shrinking a filesystem that you have on it.

If you reduce it by 101K it will be a multiple of 1M which is good.

If the filesystem is extX, you can use resize2fs to make the filesystem
smaller first.  If it is something else ... you might have difficulty.

Once you think you are ready I would:

 mdadm -G /dev/md6 --size 241618M

 fsck /dev/md6  # just to me sure - if something is wrong you can
                # still increase the size again and nothing will be
                # lost
 mdadm -G /dev/md6 --level 5

NeilBrown



--Sig_/imH+GPNcwMXAI1/Sc9Z4BSB
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTsXB9znsnt1WYoG5AQIGkxAAo0XJeBoYA7BdfvaRUl5MCWRUB/ewy4IK
VQg/e44+8jV7uG5fP3C+xf+HmTiGWWxscQdE2vmDSKAiZ54XT29T93qBRLDF5/Sg
ljawdx5poaBC+4MwGApVGFWXNMXZbL4NpBHFk3uSsCuQCvxzIDabPwrcaNtuMYIA
T0Atydd9amy3RKf5gp+1O0IaWiAUngCeryuLlu3/DPcap9sBLsLHoa4XEmMo+mTH
WZX9SxooMlZcJ8YP/XTG7vlTrQIFD1btr6oKnE8kfPBnW5MIhzS3I93gd0w9UNjQ
4dvd1lSAYpEPJ1BNTaAJ7o4V14MbcNRKoSIW85qLi3leoQP/uZSh/OBevDoWaOO4
48OYo8+rQDaWCe6e15n3CdUb4aa6YTtvs3bVxqUB+LLE1pKdTFGss/gij/vjzZ1g
zY82uOFcNw9z2c83MC2Ya+f9JU1VjuQkhxPlHtXw5cIhFVdF0fttQjyC5u+Dtk1J
Jf4GDwsIFVJBnSNnJIgezkO1CIgBmy68aUYluVUbGUi5StH2YhzzFyWJLk5Xx2by
ob0sIZXbIYXm8HK3uMjnPfSKqyYStIAtrKXzJOG0WfAEVqpWNnzI4mNBeJQTorLi
sBAnSvlBWvFjYzxnI48pO03sPmDioeJwZBmKyTXpo4Kf4bUaODkpOL7+ONqdz3eZ
UM/IFLKb2fQ=
=PSoi
-----END PGP SIGNATURE-----

--Sig_/imH+GPNcwMXAI1/Sc9Z4BSB--
