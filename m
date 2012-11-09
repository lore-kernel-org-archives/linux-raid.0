From: Paul Menzel <pm.debian@googlemail.com>
Subject: Re: [PATCH] lib/raid6: Add AVX2 optimized recovery functions
Date: Fri, 09 Nov 2012 12:46:35 +0100
Message-ID: <1352461595.4387.9.camel@mattotaupa>
References: <1352411264-5156-1-git-send-email-james.t.kukunas@linux.intel.com>
	 <1352460945.4387.7.camel@mattotaupa>
	 <ead47490-afc3-48f1-871f-ba421eac3dd5@email.android.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-OzpBzk89PwsC4+NGx4kJ"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <ead47490-afc3-48f1-871f-ba421eac3dd5@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jim Kukunas <james.t.kukunas@linux.intel.com>, Linux Raid <linux-raid@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids


--=-OzpBzk89PwsC4+NGx4kJ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Am Freitag, den 09.11.2012, 12:39 +0100 schrieb H. Peter Anvin:
> Sorry, we cannot share those at this time since the hardwarenis not yet r=
eleased.

Too bad. Then I suggest an additional run time switch to enable and
disable that code path. So people later can easily test themselves.


Thanks,

Paul

--=-OzpBzk89PwsC4+NGx4kJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAlCc7RsACgkQPX1aK2wOHVjBZACcCcoeoNd3qRoPMocl+sqITwVY
sbEAn1od1PuMz4zBlRNWVVkE0gq+MV4X
=vL8B
-----END PGP SIGNATURE-----

--=-OzpBzk89PwsC4+NGx4kJ--
