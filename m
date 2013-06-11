From: Richard Laager <rlaager@wiktel.com>
Subject: Re: Prevent Autodetection
Date: Tue, 11 Jun 2013 05:33:55 -0500
Message-ID: <1370946835.26636.40.camel@watermelon.coderich.net>
References: <1370943382.26636.39.camel@watermelon.coderich.net>
	 <CAFCYAscJyrFi0oTPn1v9Ey8LXgwHvt=pbWOe0SqMq2-WT5GGVA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-GH6eanjnkBNjx8nU+6hQ"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFCYAscJyrFi0oTPn1v9Ey8LXgwHvt=pbWOe0SqMq2-WT5GGVA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Johnson <jeff.johnson@aeoncomputing.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-GH6eanjnkBNjx8nU+6hQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-06-11 at 03:18 -0700, Jeff Johnson wrote:
> Did you try changing the disk partition types from 'fd' (Linux MD
> autodetect) to something like '83' (Linux)?

I did not with the msdos partition table, but I performed the equivalent
with GPT ("set 2 raid off" in parted).

--=20
Richard

--=-GH6eanjnkBNjx8nU+6hQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlG2/RMACgkQbfU6uV4fG86v5wCfZ6Sz2WTcb/Ao/geZtUUfeIkf
SiAAn354LHuTPss0e6ZguG51Wld3FwEH
=BYOD
-----END PGP SIGNATURE-----

--=-GH6eanjnkBNjx8nU+6hQ--

