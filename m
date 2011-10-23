From: NeilBrown <neilb@suse.de>
Subject: Re: MD devnode still present after 'remove' udev event, and mdadm
 reports 'does not appear to be active'
Date: Mon, 24 Oct 2011 09:55:30 +1100
Message-ID: <20111024095530.4536414b@notabene.brown>
References: <CAGRgLy4K-sFpeHhu_f+7-F8Fa_L1OP7ki0X-_9858BbBQrnWOA@mail.gmail.com>
	<20110830072557.428fab35@notabene.brown>
	<CAGRgLy5D+yZJArP9Y=x6N5NnozckQnyF7eaLFo8hgbBxPwzn4w@mail.gmail.com>
	<20110921150323.0ef402c9@notabene.brown>
	<CAGRgLy7fKegKw6j-36o0uchTF35F4hT8NvujW4ghb5av-onCGQ@mail.gmail.com>
	<20110925201510.24e0f468@notabene.brown>
	<CAGRgLy6Ew-mDK-u+Gz9Ae8gKzjC+qJBxM_=Xm6x=VBJBPeOaeg@mail.gmail.com>
	<20111012144531.7479596a@notabene.brown>
	<CAGRgLy5rkhfqnYHTt89f8QkigYPHDFdcciP2ZQp1tkcYq2wqNg@mail.gmail.com>
	<20111020105623.7f8038c9@notabene.brown>
	<CAGRgLy5mJ=WcnMiApw8+0AZ+AR=Hb72RdgEMCoVsN+5Vp=_CTg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Qjvp0TMX5cC.T9JQ4sE79oI"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy5mJ=WcnMiApw8+0AZ+AR=Hb72RdgEMCoVsN+5Vp=_CTg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Qjvp0TMX5cC.T9JQ4sE79oI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 23 Oct 2011 11:03:14 +0200 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Thanks, Neil.
> To end this long email thread: what is "more important": update time
> or event count? Or perhaps they are updated simultaneously?
>=20

They are updated simultaneously.

There is no sense that one is more important than the other, but if you know
something about the recent history of the array, then combining that
knowledge with these details might provide you with more precise information
of some sort.

NeilBrown

--Sig_/Qjvp0TMX5cC.T9JQ4sE79oI
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTqSbZznsnt1WYoG5AQLrZhAAi+EqYUCp050zWVe32uA49aKCthuRRGfQ
tWtFYLxY/GhgIAu0s7CyMnrdZmY7gYjdyt2R6ssm1WiMv0gfi+XItmXXLwNsxB5E
Gp5Hr0KefDtDyqi7Pv335/HLlGGKNStXbiRBFS0G9+uBtnr2jYlE8rUywKdLN4gi
BOLydUv+hoHrM//dZB4i4IDx1IGeO7oRFNzFL6awsf6G9+DHpPRjvp2GhkGqmw9D
Jsk/ij1JWvRu9R/46t2omNxdodcPDQ36zw5fKg8R5bhC1NyBiQHvBJaqmxKDe8h1
4R1BgjfFTBUYYFroz8pswYd1eUiFB3IUSMbz/NJIotUhCEsTJ+GuK9fU1bAew/yx
Ewxlu14x1QMKMV7gJkvhhk2P4XvbfVf1hpPFlixFvoiRkitHKWFXXcZe+wwhtVgA
OL0UxfiE8F4UPODwqqHA+HmpHV3ago64jc94gJY4Pu3m14NpIZjHIQUk+iqXXuZa
9uYLh751eN9VPlX686C41jcms8A/fBukMTlHY7FGvzstrhlnVy085QAH8hv06Kye
Ln2jY9pyX2kJh75UZoYDeXOGdhL9Q2Qp5eVN9IlFxyS935uhpY4Eqizluk4Nnu4l
SUAx7FEV1RqgodMZO0wBcQi8r0rDuGxZJWo4Jg2/XEFWE7x6vURJPRT1770z9elP
3XvqvgbVv0c=
=MT7i
-----END PGP SIGNATURE-----

--Sig_/Qjvp0TMX5cC.T9JQ4sE79oI--
