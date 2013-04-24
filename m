From: NeilBrown <neilb@suse.de>
Subject: Re: RAID50 boot problems
Date: Wed, 24 Apr 2013 22:12:19 +1000
Message-ID: <20130424221219.5fa086e3@notabene.brown>
References: <20130424165201.67cc9d1e@notabene.brown>
	<1164635.0.1366802387038.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/9.D/J6c=QFU4JwbUDo4iyru"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1164635.0.1366802387038.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: Roman Mamedov <rm@romanrm.ru>, linux-raid <linux-raid@vger.kernel.org>, Alexander Zvyagin <zvyagin.alexander@gmail.com>
List-Id: linux-raid.ids

--Sig_/9.D/J6c=QFU4JwbUDo4iyru
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wed, 24 Apr 2013 13:19:47 +0200 (CEST) Roy Sigurd Karlsbakk
<roy@karlsbakk.net> wrote:

> > > > /lib/udev/rules.d/64-md-raid.rules is here
> > > > http://paste.ubuntu.com/5592227/
> > >
> > > Bug tested positive also on Ubuntu Precise (12.04) and reported to
> > > https://bugs.launchpad.net/ubuntu/+source/mdadm/+bug/1171945
> >=20
> > This will run "mdadm --incremental $tempnode" on any device for which
> > ID_FS_TYPE is set to "linux_raid_member", which certainly seems
> > reasonable.
> >=20
> > What does:
> > udevadm info --query=3Dproperty --path=3D/dev/mdXXX | grep ID_FS_TYPE
> >=20
> > report for the raid5 arrays?
>=20
> root@raidtest:~# udevadm info --query=3Dproperty --path=3D/dev/md0
> device path not found
> root@raidtest:~# udevadm info --query=3Dproperty --path=3D/dev/md1
> device path not found

Sorry, that should be --name, not --path.

>=20
> > Looking bug report I see that md0 and md1 have
> > ID_FS_TYPE=3Dlinux_raid_member
> >=20
> > So that should be working.
> >=20
> > The fact that rootdelay=3D10 makes a difference suggests that it is
> > successfully assembling the raid0, but just taking a bit too long.
> > Maybe the script in the initrd needs "udevadm settle" just before it
> > attempts
> > to mount.
> >=20
> > Can you look inside the initrd and see if "udevadm settle" is used
> > anywhere?
>=20
> mdadm settle doesn't seem to be used there. I really don't know my way ar=
ound the bootup scripts that well, so I'm unsure where to add it=E2=80=A6

Can you put your initrd (or initramfs or whatever Ubuntu calls it) somewhere
that I can down load it?  Or just email it to me, it's probably only about
10Meg.

NeilBrown


--Sig_/9.D/J6c=QFU4JwbUDo4iyru
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUXfMIznsnt1WYoG5AQJHhQ/+Nn+93cclJRaoZiO1esOHPcpETUlnTa1m
Pe/gP+nmrJUZpnmRnAIzkuQsQkQdLQhlGo+MG/4dXxS7U+HVC1/rMKEZo1nE+y+F
AimUSJWOcsFhK9VkCrMO7KG5CF0c6mGHk+VTvFxVKUr/M7gXmy92XemWFq5xPFoS
G+qtJnkXcNjTFjGQNFGFsBuMmyij+0jeB499C75xrF+/rLXxDjyhwSry6cMuc6wE
o9h3wl4FP2zH+XSK+cGYariojKg4A/8q3CheJTaedfkGdIaMsz2oaFFDMJ6l7pNW
T3IfuD9V8wjJC+D4w671q/VH6eL5to2L63Oy4aNr5ue2nJSYWErgU3T/jzS5Qc3Y
6vO3UXJpzwyCjPNtxFc0kAYDcWMFF8+LC8CjmqFLNVCOtgLsrH9Exp0lvB1qJ8V8
NBBwrFeXc6NaX/WqwxICvknYNEwKNSPG8N2X6waQ+mazEeBG7PGtAEYACl+NmUui
xBV1ZKzzgLeguHp0w1Bc13NsxUX2dqy7OwDfv8lTcCiiNSxElu5smao7mJ/gGFtA
LTnLlIL4yL86a2EM0APMG3ZqNB9eYvBLKD2i80fAcGWWr8MhTAqwh2Us61AFrlsd
gkzAwGgSkEYPRcnAdjK1OIkmdHezqHs6QkaTM2GvNnQnKdE7q9ofZGkKLnDdUDgR
qHCevse3hEo=
=UooI
-----END PGP SIGNATURE-----

--Sig_/9.D/J6c=QFU4JwbUDo4iyru--
