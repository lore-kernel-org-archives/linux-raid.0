From: NeilBrown <neilb@suse.de>
Subject: Re: Raid 6, 9 1.5T days drives, 2 "fail" one after the other
Date: Tue, 19 Feb 2013 11:39:35 +1100
Message-ID: <20130219113935.4f93e24a@notabene.brown>
References: <1360181237-11760-1-git-send-email-jmaggard10@gmail.com>
	<20130207115328.6b07ade9@notabene.brown>
	<4575dbf6-5f48-446b-b144-84912415ba7e@email.android.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/uU=L3TLsHKTAC.9oGo3DIrt"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4575dbf6-5f48-446b-b144-84912415ba7e@email.android.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dragos Dobrescu <dragos@mpigani.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/uU=L3TLsHKTAC.9oGo3DIrt
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 07 Feb 2013 10:39:53 -0500 Dragos Dobrescu <dragos@mpigani.org> wro=
te:

> Hi,
> I need some help.
> I noticed the server was in recovery mode. It had just dropped a "faulty"=
 drive. I checked the drive and it looked like it was working. When the rec=
overy was done I added the drive back, after recreating the partition.=20
>=20
> As soon as I did it, mdadm informed me that it redropped it and dropped a=
nother drive at the same time. I removed both driver and added a brand new =
drive (second is on the way) which the system accepted and started recovery=
.=20
>=20
> What I don't understand is that I plugged the drives on another computer =
with sata-USB adapter and performed a full smart checkup which returned suc=
cessful, minus a few bad sectors and some warnings of pas over heating.
>  What is going on?=20
> Thank you for your help.
>=20
> Dragos
>=20

No one replied?  I felt sure someone else would.

Maybe you  have a problem with your driver card, or with a cable, or
something.

Normally if md stops a driver there will be messages in the kernel log about
access failures.  Do you still have all the logs from when this  happened?
Are there any messages from the kernel?

NeilBrown


--Sig_/uU=L3TLsHKTAC.9oGo3DIrt
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUSLJxznsnt1WYoG5AQLt8Q//cvAL9AYmr9cf8uGi3YTvpeER0lhy6ij/
3J1eHRk+HJnvgJIHumfZ22LbEGSbPkQsM3r+vC0VOU9lDq0wjhrQK9IU4am59rD/
dzf0J03uZIw6dtGe0F3Kt8W9rYWgGs/ldU0rzufz7he6hWuznzEYhcUXp7OSeHOY
Stzqgo9bu8IYDErbwWrLwlY4tWKADheez16lF78W3sbSkcGN2WPTsB9CzoO/FdmJ
yuz3TSuTTuxAMYjCay4U1QdN8w+bvoUqzFhKvaLlYjKWflY57LB5aRPv6YCmj9Tl
ym8N7jverg6HtNy6NiTNHTFuS2oCuN+n2EOIjH49P4fqgw8ao31Ob/7lzNqzmie+
Ekoi/YHWVVf14ihdFQo1kyxq+LDvqbtImUtao55dGzD0wEiEnaaUXfQxvHL5JtPS
Fcr3dHBtkDKfb3cMwYvRaL9iobdtM/6usAX5lU63kP/bUG/LBe1vEeNEWDljUHvz
k1Ij9p5Hugm8Y04ApKywH6WZFLpspw7/yNHKYHDeS7QSUFQjDszaOjjeegRxCxk4
Sh0ol4VK4stAPsYzimdBRCmEkSy5DbBOw1BqfN/wM22l7rEW1rfNVOnPHrzqIys1
8fV04YBOzN7qcbpKYtXnKEVVOXVFd5rMhtZWn8yigE+YKYk2id/8GQPfbzuNpVN3
DIcVHtVIdxU=
=MPBx
-----END PGP SIGNATURE-----

--Sig_/uU=L3TLsHKTAC.9oGo3DIrt--
