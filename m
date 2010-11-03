From: Roman Mamedov <roman@rm.pp.ru>
Subject: Re: Determining which spindle is out of order
Date: Thu, 4 Nov 2010 03:26:27 +0500
Message-ID: <20101104032627.056cb83b@natsu>
References: <loom.20101103T115828-494@post.gmane.org>
	<4CD1DA2E.5060205@turmel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/.Y9QBQuz=ran3CeqIks9LGt"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CD1DA2E.5060205@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Nat Makarevitch <Shelso@makarevitch.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/.Y9QBQuz=ran3CeqIks9LGt
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 03 Nov 2010 21:54:54 +0000
Phil Turmel <philip@turmel.org> wrote:

> I wrote a little script that would tell me device name and serial number =
for
> each host port on my motherboard, along with anything else that lists a s=
csi
> host in sysfs.

Thanks for the great script. However it was partially failing for me at fir=
st,
with error messages like "Corporation: command not found" or "Technology:
command not found", failing to get most of the data properly. Turns out my
"udevadm info" output for my controllers contains non-quoted values with
spaces, which do not "eval" correctly:

E: ID_VENDOR_FROM_DATABASE=3DnVidia Corporation
E: ID_VENDOR_FROM_DATABASE=3DJMicron Technology Corp.

As you do not use any of those further in the function anyway, I just added=
 |
'grep -v " "' after "cut", and it worked fine afterwards.

--=20
With respect,
Roman

--Sig_/.Y9QBQuz=ran3CeqIks9LGt
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkzR4ZMACgkQTLKSvz+PZwhDrQCfZb/8e4ysx9/QLxZtXPoW7qu4
UKYAn1Oz9EidkBU1+hlchN/s16lVJM3Z
=BjKo
-----END PGP SIGNATURE-----

--Sig_/.Y9QBQuz=ran3CeqIks9LGt--
