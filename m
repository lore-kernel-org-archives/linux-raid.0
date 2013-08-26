From: NeilBrown <neilb@suse.de>
Subject: Re: Accesses to not yet running array
Date: Mon, 26 Aug 2013 15:30:21 +1000
Message-ID: <20130826153021.6075fb8b@notabene.brown>
References: <CAC9WiBgjEQxe_uymD6WW3Oj5Bm6aYD-RBD-8m3G40c1y3HUb0Q@mail.gmail.com>
	<20130821090634.413491d8@notabene.brown>
	<CAC9WiBiYYOjCVaa5tKVC7Lnkz7fcB2wHM0v2wdQUi=1Ufku5gA@mail.gmail.com>
	<CAC9WiBjBGD0J5vSe+q7y+UVGp2+++Ac++zeQ_=LUz9eQ-kCffA@mail.gmail.com>
	<5217B364.1070704@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/fU7_GgYAU7OBP5wzKP+JEhK"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5217B364.1070704@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: Francis Moreau <francis.moro@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/fU7_GgYAU7OBP5wzKP+JEhK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 23 Aug 2013 21:09:24 +0200 Martin Wilck <mwilck@arcor.de> wrote:

> On 08/23/2013 12:00 PM, Francis Moreau wrote:
>=20
> > [ adding Martin in CC since it seems related to DDF... ]
>=20
> I reproduced it here. The problem is that mdmon isn't running. Simply
> try running "mdmon /dev/md127", and the mount should proceed.
>=20
> You'd avoid the problem by running "mdadm -IR /dev/sda" in the first plac=
e.
>=20
> @Neil: This is unexpected, I think we need some code to start mdmon if
> necessary in Manage_run. I considered coming up with a patch, but you
> can do it much quicker, I think.
>

I've changed Manage_run() to call the same code that "mdadm -IRs" call, but
asking to just run the one array, not all arrays.
This should  do what is expected (I hope).

NeilBrown

--Sig_/fU7_GgYAU7OBP5wzKP+JEhK
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUhrn7Tnsnt1WYoG5AQLDchAAtv0KZS0UxsE3B8DW9VZxhMihJR/M9Quf
Q/uk0ftvQ1cflRlHia02agItobAfQk6F8vFWk5AHMpcjpmlAtUQKmcZzdtLmJ6z8
gLC52m23miY271q6Ozflspah4e76NtCzWXk5K7thIxLhzRNZE1EAALLSpzjpN1BJ
D2YqbDLCQEerYuievXgJ7yI7hihRNHeahvvETwTULzrJq/E2dzU86FYn+m+p5lvZ
Ogm06Hvf+aepugQtcKwzDenP6gyi1zzhvpjT3t/OHKGpEaJkPF+BX1JO/to2UVyF
NUtWMT8HnKOB1RCS7ik2MqPQFb6Dgtk/TckdW8RMClm5zY+pstEeMxYLCIKlsTsB
nXe/GJczBC9vgmslVXfDWqUY2Yv9IkY/1N3fTFIXStnUYBR4GgumuP4w7Jb3MpzO
GA6MQ9RxYgErcPYOj/lY6v+wmwIyCKKlxWLiX6sEmPBeiApkXeoiIm9Gu4yWduGg
9HDNzHDFINlSCoWUy4VMejU2UAXEB/RVIj2H2Z+a63goYmrOaCC+jy+ULGEhqaQK
REPIVk0Dh9u8hn4jdqXO8Q80hh6biC1lRbzaRwwEQfr9MRDE/+LOtqaNzs1cwF4W
B2FPc88zoT80v+F+aaQJhe+4vGcJAbme++77Ip/HXUdadpLXcbmav2uEwd12EwNy
+hoi3Z437Io=
=cDSK
-----END PGP SIGNATURE-----

--Sig_/fU7_GgYAU7OBP5wzKP+JEhK--
