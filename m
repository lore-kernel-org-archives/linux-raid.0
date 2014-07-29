From: NeilBrown <neilb@suse.de>
Subject: Re: Crash during recover
Date: Tue, 29 Jul 2014 20:48:06 +1000
Message-ID: <20140729204806.48632819@notabene.brown>
References: <026c01cfab18$2f479960$8dd6cc20$@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/8wSwpmhBKCrvp1nWkNuB62W"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <026c01cfab18$2f479960$8dd6cc20$@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Matthias Appel <appel.matthias@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/8wSwpmhBKCrvp1nWkNuB62W
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 29 Jul 2014 12:30:53 +0200 "Matthias Appel"
<appel.matthias@gmail.com> wrote:

> Hi all,
>=20
> I have a problem with my 4 disk software raid 5.
> I had a defective disk which I identified and changed and the rebuild
> started.
>=20
> But somewhere around 6pm the machine crashed and I had to reset it this
> morning.
> The problem is the raid won't start because it complains about missing
> drives.
>=20
> I did mdadm -examine and saw the event counter on one disk was slightly o=
ff
> and obviously two disks fell off the raid the same time, giving me ..AA l=
ike
> you see down below.
>=20
> I tried to force assemble the array and I got the message about the event
> counter being adjusted.
> I assumed the raid would start now, like multiple times before I had same
> issues with multiple failing drives/controllers
>=20
> But this time not....I says that the raid is missing 2 disks but examine
> looks not this bad AFAIKS.
> I read the recovery wiki entry, but there it tells me to recreate the arr=
ay
> without initial sync but I don't want to go this way because I think this
> should only be the last resort.
>=20
> Can anybody look at the mdadm --examine of my disks and tell me why my ra=
id
> is complaining about missing disks and how to recover from this issue:
>=20
> If you need some more information, pleas tell me, what you need and I will
> try to get it!
>=20
> Thanks in advance,
>=20
> Matthias
>=20

Looks like it should start.  What version of mdadm and kernel do you have?
What does:

   mdadm -V
   uname -a
   mdadm -A /dev/md0 --force -vvv /dev/sd[abe]

report?

NeilBrown


--Sig_/8wSwpmhBKCrvp1nWkNuB62W
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU9d75jnsnt1WYoG5AQKK0BAAgoALYJr2tZG/M5to9bTaS6nm6yxDUMVm
P7PnzFJCwxXRqtLMhTEFJoBDwMgjOTSv1tzr6c95H1U79ZTxFqR5MyuluMVV8XsR
09LVGgWCdKg66MM1E+5dE05XKCBQJIkqEG+46vspGivn0MZN5d6njHA/ZYu4x1k7
l7yABYG2NQiDPfKy7lpe3wLXmyF6YR2caajXJzVuROlUlsdbiul0oBcCEdNoTrBY
Y0HFOnOokfa9YKB60hj+27cFzPwbuTl46pfHKwHxZuCVXvpW+zOVHlp9rP4+XCEc
J9RAK3YmjOe+SUXoZvz4XpMPZ3ic6WTjSJEwoOfEExjjJq0wKLMTbsEWAqAVTt6O
ZpeY/a6TYHQwwwUG6myK6TmGLmDg24kxCUehvC7uaTCNcTUkz5ota8ZmDpMXTF+K
tiYFeDcpFDnCH+3Hx70NoaH/UyXM9D5JrsXZ75ZyAyeNZ8dTBk2cPWDYwSdjf92X
A6GkXfJ1VKNa3qdNezujFFx96aqA+i2vhGHEuParnUcYrnjymd7V+uB5ETocF9T8
R7o+v0UXuIrGCdwRbVMYB61Lf8JM13M6cqNzG18Ty+qW4fRh0OW2bjkrLuyhMNJq
h84ydJHUK4vWuY7OZGixhljZGqYWw7/dWIta8mFdFiRQjiHtvS/7HYwLSVXtT8rx
RjmL4ZFvxW8=
=raDy
-----END PGP SIGNATURE-----

--Sig_/8wSwpmhBKCrvp1nWkNuB62W--
