From: NeilBrown <neilb@suse.de>
Subject: Re: Data Offset
Date: Mon, 25 Jun 2012 16:25:15 +1000
Message-ID: <20120625162515.654759ed@notabene.brown>
References: <CAFhY2CjQAutSxzJ-7e+G-1Jw-U6JsFjBBHOmiqOxkhkZy6kd9g@mail.gmail.com>
	<20120605154427.192566af@notabene.brown>
	<CAFhY2CiDTMRSV2wFCMhT9ZstUkHkJS7E0p7SP-ssfqwaquo+0w@mail.gmail.com>
	<20120610074531.65eaed81@notabene.brown>
	<CAFhY2CgxkjH6JvJzvQt9XT0oawntK7YoTFqnXQJGzvqthD8XpQ@mail.gmail.com>
	<4FD86179.1080209@pierre-beck.de>
	<4FD88C50.1000104@turmel.org>
	<4FD8D439.10406@pierre-beck.de>
	<4FD8D7EE.5000805@turmel.org>
	<4FD8DA4A.8030800@pierre-beck.de>
	<20120613184945.GA7307@lazy.lzy>
	<CAFhY2ChB03GWOSWjX=YAEkZSLiqQp6LZUhqcnPVfpbpeL3iJ0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/N8w53o2dIQP/1726BKC8gcX"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFhY2ChB03GWOSWjX=YAEkZSLiqQp6LZUhqcnPVfpbpeL3iJ0w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: freeone3000 <freeone3000@gmail.com>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Pierre Beck <mail@pierre-beck.de>, Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/N8w53o2dIQP/1726BKC8gcX
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 19 Jun 2012 22:56:48 -0500 freeone3000 <freeone3000@gmail.com> wrot=
e:

> Thanks a lot for your help. I have my data back! Played a few movie
> files off of the mounted drive, and they all worked perfect. Sorry for
> being such a dunce with the block sizes.
>=20
> `/dev/sdc3:2048s /dev/sdb3:2048s /dev/sde:2048s /dev/sdd3:1024s
> missing` mounted the drive successfully. Now, is there a way to
> "normalize" my drives so I can mount it without running through this
> guesswork again? Or that I can re-create my array using a standard
> mdadm?

No.  But maybe with Linux-3.6 is out.

Of course you only need the 'guess work' etc if something serious goes wrong
again.  Hopefully it won't.

NeilBrown


>=20
> On Wed, Jun 13, 2012 at 1:49 PM, Piergiorgio Sartor
> <piergiorgio.sartor@nexgo.de> wrote:
> >
> > Hi all,
> >
> > On Wed, Jun 13, 2012 at 08:22:02PM +0200, Pierre Beck wrote:
> > > I wonder if LVM activation can be done without writing to the array?
> > > IIRC it updates at least some timestamp ...
> >
> > we tried setting the array itself read only,
> > which prevent (or it should) anybody above,
> > filesystem or LVM, to perform writes...
> >
> > Neveretheless, the result was a bit "strange",
> > namely a kernel BUG() or similar, we had to
> > reset the PC.
> >
> > I'm not sure if this was caused by other issue,
> > since the PC was in a not really healty state,
> > or a direct consequence of md device in r/o.
> >
> > bye,
> >
> > --
> >
> > piergiorgio
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.html
>=20
>=20
>=20
>=20
> --
> James Moore
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/N8w53o2dIQP/1726BKC8gcX
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT+gESznsnt1WYoG5AQLBpA//YKQSB8ucnr2UvVYOoYzXP88jMcGvQOzy
wnfM96fII+j0X+1gVbCXdc6gLpDeZY6uRRaecIjLJpyFsK0dZf1lc0wN09AB/s+P
/9OkPXblU7PwtdTjIhIIJZLIxZPOYIxSl1DbqxuBvZg1VanqhF2SpeEjfb88mwVa
cZ9yYmNERrztURlbhjgEY5/y5AkBe489ZZ6bpZnBjAI1HzBjMQuyLVhwzKm2K7ek
1a2BFiP94WH+8dPT/CRFHpQ3KpOb7nPXg7Tgkw5uej76KczCzwbW4mdnoEGrJ5B+
LuoPpmeGsTNIYixeO5BK8a/P2zXOqIWYECSuM1VlN6ar3GMDE4aTLL8m4ne0RfSx
vy9IMh52JRlXGoBNcdt3m68Gv3457+kfIQhqJxwLR7uaFiM03CFDbNJk/SC5jLO8
XhHWwm7elzLjGcwQb9VbntvBa04w4pzHmGgNlNL3xCcS0c5NZpZXdNL/LjvhGVQ1
IQKFPXr2fPKiFUgp9ID6SzqjSk0dSf5lZbrHk7D0bTTlJMCmGbEqDOwvSq2md0no
jgQM/lC5ZqFF3r5M4wFHTZkaJPo/beyy/afEkKn3a1QI390Na/JsYI9d3aGVLVZk
GD2PoE5yi4GN3iLRD89D5rNmjGJ95pmTu4ZeXb9yU1XwPf0ZlBQmbe2OEvMtCJTv
LUSAqiH+Wys=
=zSSK
-----END PGP SIGNATURE-----

--Sig_/N8w53o2dIQP/1726BKC8gcX--
