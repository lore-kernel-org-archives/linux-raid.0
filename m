From: likewhoa <likewhoa@weboperative.com>
Subject: Re: Best way to create RAID-6 for swap partition - existing one
 failed
Date: Wed, 18 May 2011 16:59:56 -0400
Message-ID: <1305752396.10481.3.camel@darkside>
References: <12577.16388.qm@web65103.mail.ac2.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-OoKjezK1tQgUZAmWaLll"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <12577.16388.qm@web65103.mail.ac2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gavin Flower <gavinflower@yahoo.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.de, mb@gem.win.co.nz
List-Id: linux-raid.ids


--=-OoKjezK1tQgUZAmWaLll
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Content-Transfer-Encoding: quoted-printable

read 'man 2 swapon' for info on the -p flag.

On Wed, 2011-05-18 at 13:32 -0700, Gavin Flower wrote:
> --- On Thu, 19/5/11, likewhoa <likewhoa@weboperative.com> wrote:
>=20
> > From: likewhoa <likewhoa@weboperative.com>
> > Subject: Re: Best way to create RAID-6 for swap partition - existing on=
e failed
> > To: "Gavin Flower" <gavinflower@yahoo.com>
> > Cc: linux-raid@vger.kernel.org
> > Date: Thursday, 19 May, 2011, 7:57
> > Why not just let the kernel handle
> > the stripping for you, IMO using
> > dmraid is overkill for swap when it can all be handled by
> > the kernel
> > itself with 'swap -p1 /dev/sda1' for example.
> [...]
>=20
> Could you please tell where to read up on that, URL or man page.  I do no=
t know where to apply your suggestion, nor the meaning of the '-p1' option.
>=20
> I should have said the original problem was associated with hibernation. =
 (I also have 2 other desk tops that don't use RAID for swap.)
>=20
> For now, I'll leave the swap as is - but, I will rethink how I implement =
swap when I upgrade to Fedora 15.
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=-OoKjezK1tQgUZAmWaLll
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQEcBAABAgAGBQJN1DNMAAoJEANL4SLpFTLyYp0IALA7ALziDc/PFxEBYlXvPuqk
ejEhBfLkLMFEUMFoF0nwErNkXMtnU/brHP9pxtA6uAde69X0PgwvQG51vryo67SR
u4nUYCvtLxe6uR/wOLjFyBLX0cTZ9dmBiaIjv0ZN6H8KUJxlHve68C8XaevpIuE3
N1vC5JwWregAXFfAIM5lOSfd5HPCEtJcOdArjvFqKPNuKpHWuOmhVlFmb6nC0tz5
qluu+H0v1MgTEdY/r+d4ZXMTlxsXj8d1f542tIz1OZJQRjTf1owSeWtpbXZxpFlT
AmVWvyPgU9aC2bGQ0EI8XWu5wNqYxZJd/oTNcS3MH7tN1GMSmR7PifANmCuVTh0=
=/9la
-----END PGP SIGNATURE-----

--=-OoKjezK1tQgUZAmWaLll--

