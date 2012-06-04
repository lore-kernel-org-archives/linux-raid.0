From: NeilBrown <neilb@suse.de>
Subject: Re: How to use replacement?
Date: Mon, 4 Jun 2012 17:12:07 +1000
Message-ID: <20120604171207.555e2f83@notabene.brown>
References: <201206040953190009422@gmail.com>
	<20120604121136.0edfd95e@notabene.brown>
	<201206041434216404880@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/f8dkgliEOJl1ak.4bpXgWHB"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201206041434216404880@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/f8dkgliEOJl1ak.4bpXgWHB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 4 Jun 2012 14:34:28 +0800 majianpeng <majianpeng@gmail.com> wrote:

> >On Mon, 4 Jun 2012 09:53:21 +0800 majianpeng <majianpeng@gmail.com> wrot=
e:
> >
> >> Hi:
> >> 	At present, md is supporting replacement.
> >> 	In function: state_store()
> >> >   } else if (cmd_match(buf, "replacement")) {
> >> >		/* Can only set a device as a replacement when array has not
> >> >		 * yet been started.  Once running, replacement is automatic
> >> >		 * from spares, or by assigning 'slot'.
> >> >		 */
> >> 		I can using spare disk.But how to use slot?
> >
> >If you want to ensure that a particular device becomes a replacement for=
 a
> >particular other device, then
> >  cd /sys/block/mdX/md
> >  echo frozen > sync_action
> >  echo NN:MM > new_dev  # where NN is major and MM is minor of new device
>=20
> If the array had a persistent superblock, the operation returned error.
> The message like:
> [  262.934070] md: sde does not have a valid v1.2 superblock, not importi=
ng!
> How can do it ?
>=20

You need to write a superblock out to the device first.
mdadm already does this when adding a spare to an array, and it is
a similar operation.

NeilBrown


--Sig_/f8dkgliEOJl1ak.4bpXgWHB
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT8xfxznsnt1WYoG5AQJIDw/+OIY5NQcjZNGrE/bwh7jP1X/eS61qqSQQ
9xsdvCEdcWCJ6pEWHfMbQFZ5tW18ugiWSt/8yiQwgW5oSBNLEP2cd5nlwkkbS6nt
vUrTjI+PLBVbn3T7xX8ahWBG/f8AJ6ZdlknRFY7jVnYFhxqbWFp+G6Y54C5HZGpa
wh1AKGDwDoU2ZWSafbq5RTcnZe0R7yY9O0RYjjZbmeJ3VncvcZ8qFk6n2Prh215g
v0QtJnWFFT4FK6i0eIwy4+kbKUFYin89nKtWv1cUp51RiRkzFYbOl+PWv9btYScv
fgcXmdhlb/4d/PmNUbdb+OyRiaRqsAZA/Qele53x2Di581fimtnBvy4bLbZjJr2Y
eE+sA+3DVBtJE3S+RbkHLuoPX5y7I1WdMOht1vOXe+u9kwq3hihIVGji7/Higfo0
4T5xQiLiUQlc994SkUSH/3MkPhdEH6DPSR7UhVuuGDh1w8sBBGTMJSeh16wh1IXZ
hsCeGGUwUEI638fdtIJZwxGtvO6L2j6RPJZMIElgxd917Hfmqyo8XoAjSQ4XOo6b
yqj3S4DthLNvOyZTo7Q+PmqfvdVpZ59t6XBhj/RvlV8jKKvGpdb6HpWM3fybcbad
GjPkb5alC6GHx3ewnvCT/7SGZwrwBFLi0k1mWhvXx1ZaGhPYS5i1tM8HGQjuI0XD
tbPG/sHUjZU=
=h+08
-----END PGP SIGNATURE-----

--Sig_/f8dkgliEOJl1ak.4bpXgWHB--
