From: Patrik Jonsson <patrik@ucolick.org>
Subject: Raid5 resize "testing opportunity"
Date: Wed, 17 May 2006 14:32:59 -0700
Message-ID: <446B968B.6050606@ucolick.org>
References: <20060501152229.18367.patches@notabene>	<200605021938.45254.a1426z@gawab.com>	<17495.62433.136481.543828@cse.unsw.edu.au>	<200605030700.23515.a1426z@gawab.com> <17502.61577.874881.753541@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD6EE3C8348A053F70271200A"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17502.61577.874881.753541@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD6EE3C8348A053F70271200A
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi all,

For Neil's benefit (:-) I'm about to test the raid5 resize code by
trying to grow our 2TB raid5 from 8 to 10 devices. Currently, I'm
running a 2.6.16-rc4-mm2 kernel.  Is this current enough to support the
resize? (I suspect not.) If I upgrade to 2.6.17-rc4-mm1, would that do
it, or is it even in stable 2.6.16.16?

Thanks,

/Patrik


--------------enigD6EE3C8348A053F70271200A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFEa5aQT+KvsdUW5p8RAmD9AKCW2+EpxFsr/tqxA4dGDSmfOxqqMQCgiJL+
Liw5Ks6/kwJ3yDAIgD0oYHA=
=6NT+
-----END PGP SIGNATURE-----

--------------enigD6EE3C8348A053F70271200A--
