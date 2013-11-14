From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm --fail requires writeable drive.
Date: Thu, 14 Nov 2013 11:44:49 +1100
Message-ID: <20131114114449.27f3c746@notabene.brown>
References: <52836DD1.8080605@mpstor.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/9S53qi0w5xpXfUMxR+zwAvp"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52836DD1.8080605@mpstor.com>
Sender: linux-raid-owner@vger.kernel.org
To: Benjamin ESTRABAUD <be@mpstor.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/9S53qi0w5xpXfUMxR+zwAvp
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 13 Nov 2013 12:17:21 +0000 Benjamin ESTRABAUD <be@mpstor.com> wrote:

> Hi,
>=20
> I noticed that mdadm --fail will only work if a disk is present and is=20
> writeable.
>=20
> mdadm's Manage.c seems to first make sure the drive can be "stat"ed=20
> before proceeding (which will fail if the drive is gone), and then=20
> seemingly try to write "Faulty" to the drive's superblock as well as=20
> notifying MD of the drive failure.
>=20
> However, in many cases, a drive must be set faulty because it has gone=20
> offline. MD will do a very good job to set the drive faulty itself,=20
> provided that IOs are running on the array. If no IOs are running on the=
=20
> array, removing a drive and then trying to set it as failed will not=20
> work. Trying to "-r" the drive will also fail since the drive is not yet=
=20
> marked as failed, so deemed still in use.
>=20
> Looking through the code it seemed to me that MD could be told to fail a=
=20
> drive even if that drive was no longer present (the /dev/sdX device node=
=20
> file still is in this case), in the same way as remove works. Would that=
=20
> be possible? Am I missing something here?

Does
  mdadm /dev/mdXX --fail detached

do what you want?

NeilBrown

--Sig_/9S53qi0w5xpXfUMxR+zwAvp
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUoQdATnsnt1WYoG5AQLl2BAAg8NZF2srdCyApu/gIXxSrMxG+/RdnjJ4
NkMNEqDPzCRswkczd/qQcjGMQbcogbYD2Rfazxi1mSknRfRPk7SQwhOhL6kwOGlC
6oFZ7dZER9wLXxhJawi/eJOaMMaP5ycHGvpJt2beIIuOZ98UNlkRl5v/SmhuGPLo
Jo5XiYRFg7cB57WhHcFSSoQ/Tyb09jKjZk8mx+3I3U5fVRO1zSfeS7WT1Lp+Ykpq
41t8irC635tHr7hZEINHddUxkumX3iA2I5Nzy/+/XkJ69bPYBNbwvmbVHTG3kBg4
jdIbowLTGOHQQzzldPt44ThpQJxkiU3q4IsT5bObWReEXfrsjvpf5hG85GXzXaM9
qA7MelCqMjhnWLYtRzSKl594LDqxM+VwtvL/0DyudEgf00k7JMV81Lg4rgSxNK38
gMxirrMEbdGhtvyqp2j+HjyterQ7N4vm7rH+MKkTEfQ4c+hvDrDdi5tIRofhJWmL
lw8/uJb8wzhusVx2mBlUHOu6GGUiWgnEXMeSZHtTXs8j1cOF1PdKtl4y5leIEHWa
HWiOLRW/oC+Yf+OpZBzJk0YydjdeaQyelqGjEB+0iEA/xxfvIfTcsYveASlD+v/I
yGEd4a4xmw8XIFdI3XyPs+SV4QwuWOLbxUCRG+/mGfICHSSoL9RG8W8prQObP594
3fyGqiA/bcs=
=x9hb
-----END PGP SIGNATURE-----

--Sig_/9S53qi0w5xpXfUMxR+zwAvp--
