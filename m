From: Roman Mamedov <rm@romanrm.net>
Subject: Re: Recommendations for RAID setup needed
Date: Tue, 22 Sep 2015 10:03:04 +0500
Message-ID: <20150922100304.2372d85c@natsu>
References: <CAB1R3sjKb-aXJV+4E5t6OsWid4QB+r6aCteZt+F+57=cWLhHWw@mail.gmail.com>
	<55F85E9F.1070100@youngman.org.uk>
	<5600D61A.6000908@suddenlinkmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/7W2DBsPMOVQPELfd.nP_OVu"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5600D61A.6000908@suddenlinkmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/7W2DBsPMOVQPELfd.nP_OVu
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 21 Sep 2015 23:16:26 -0500
"David C. Rankin" <drankinatty@suddenlinkmail.com> wrote:

> This is the exact reason NOT to use btrfs at the moment. The issue is=20
> with the 'snap shotting' feature which can quietly fill your disk with=20
> snap shots to the point of space exhaustion that has resulted in the=20
> complete loss of information in a number of instances.

Snapshots is not something Btrfs "quietly" makes on its own, snapshots are
something *you* create. Snapshots of static and unmodified data are essenti=
ally
free in terms of disk space (due to CoW only the changes from the point
snapshot was taken and further on, will require additional space); and if y=
ou
heavily modify your files and want to also keep a trail of snapshots, it's =
of
course up to you to ensure you have enough disk space for that.

--=20
With respect,
Roman

--Sig_/7W2DBsPMOVQPELfd.nP_OVu
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlYA4QgACgkQTLKSvz+PZwjJnwCfZcCZ2x8jPKG0Tre/J6byjL2S
Z2IAn3zAFDy/g4o6woLalHO2oym6w9ht
=6IRZ
-----END PGP SIGNATURE-----

--Sig_/7W2DBsPMOVQPELfd.nP_OVu--
