From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: RAID5 with two drive sizes question
Date: Wed, 6 Jun 2012 10:16:27 +0600
Message-ID: <20120606101627.5cf8ecbc@natsu>
References: <4FCE4199.7030705@gmx.net>
	<20120605233953.2086cc4c@natsu>
	<4FCE60F3.4040606@gmx.net>
	<20120606015950.585d5454@natsu>
	<4FCE6DCD.7030207@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/irc48taFXNFu5o_dC7po11O"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FCE6DCD.7030207@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: "Joachim Otahal (privat)" <Jou@gmx.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/irc48taFXNFu5o_dC7po11O
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 05 Jun 2012 15:36:29 -0500
Stan Hoeppner <stan@hardwarefreak.com> wrote:

> > Except this would not make any sense even as a thought experiment. You =
don't
> > want a configuration where two or more areas of the same physical disk =
need to
> > be accessed in parallel for any read or write to the volume. And it's p=
retty
> > easy to avoid that.
>=20
> You make a good point but your backing argument is incorrect:  XFS by
> design, by default, writes to 4 equal sized regions of a disk in parallel.

I said: "...need to be accessed in parallel for any read or write".

With XFS you mean allocation groups, however I don't think that if you write
any large file sequentially to XFS, it will always cause drive's head to ju=
mp
around between four areas because the file is written "in parallel", striped
to four different locations, which is the main problem that we're trying to
avoid.

XFS allocation groups are each a bit like an independent filesystem, to all=
ow
for some CPU- and RAM-access-level parallelization. However spinning devices
and even SSDs can't really read or write quickly enough "in parallel", so
parallel access to different areas of the same device is used in XFS not for
*any read or write*, but only in those cases where that can be beneficial f=
or
performance -- and even then, likely managed carefully either by XFS or by
lower level of I/O schedulers to minimize head movements.

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/irc48taFXNFu5o_dC7po11O
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk/O2ZsACgkQTLKSvz+PZwjQ9QCfRlgykAvxNNj4I/4w4Iyz/Djg
OpIAnjeEmw7y9w8cnbt9iRfemJgeiu2H
=L8mt
-----END PGP SIGNATURE-----

--Sig_/irc48taFXNFu5o_dC7po11O--
