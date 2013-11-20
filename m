From: NeilBrown <neilb@suse.de>
Subject: Re: MDADM 3.3 broken?
Date: Wed, 20 Nov 2013 11:48:33 +1100
Message-ID: <20131120114833.695fc9d4@notabene.brown>
References: <CAGRSmLviYJtCfNiARKW0FvrJ0BUDrvhPnQy2drzbkf95-Gfpag@mail.gmail.com>
	<528A7721.8080604@arcor.de>
	<CAGRSmLvRVQtrkYPLS8NfRS+DvyS0xZ72cwVdLygb0w5KbVrARA@mail.gmail.com>
	<20131119110110.396b2af3@notabene.brown>
	<528BBFEB.7050202@arcor.de>
	<20131120105115.27494ab6@notabene.brown>
	<CAGRSmLsAALx=kJFiB6_b_yeb66qMZCa+4brg8Aejeaf031_JPg@mail.gmail.com>
	<CAGRSmLs8AXqTG9Y0YU46vtpb2q08-2ApknBHVPF75FXPJu7C0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/GB.pA.Vkq5przOpWYtx=sWz"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRSmLs8AXqTG9Y0YU46vtpb2q08-2ApknBHVPF75FXPJu7C0Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "David F." <df7729@gmail.com>
Cc: Martin Wilck <mwilck@arcor.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/GB.pA.Vkq5przOpWYtx=sWz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 19 Nov 2013 16:35:44 -0800 "David F." <df7729@gmail.com> wrote:

> FWIW, we confirmed that it appears to be the old RAID1 data it was
> finding - when the partition is below half the size it didn't find it
> in the partition, when resized just beyond half the size (of the RAID0
> md drive), it then started finding it in the partition.
>=20
> Also, was Cisco's information useful for why their cisco server (using
> lsi)  RAID5 won't assembly?  Do you think the patch deals with that as
> well?
>=20
>

You did say something about Cisco in the original post but it wasn't at all
clear what you were asking or what the context was.

Could you please spell it all out.  You said something about dmraid reporti=
ng
something.  Showing the output of dmraid in that case wouldn't hurt.
And show the output of "mdadm --examine /dev/device" for any relevant device
is often a good idea.

NeilBrown

--Sig_/GB.pA.Vkq5przOpWYtx=sWz
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUowG4Tnsnt1WYoG5AQLrLQ/+KXjjdGj485GVGXyNm/arEIl4Hu+UhBdE
wiXjR3PV0t5ZerEhbx+2hS0UQx/gDWItEeJyb5XBT4rqqKKE3OP6ik0ADXs5vh0f
IMPwLkM/rBuStUZlu3PoFFZms5p+xskEpBfkBq8fPaKPHMdjqkuikv+a0DkhGQ0R
FQqqGIl+/XS1q6rzL9InI0SpTmg29E2Qc0pLuTA1s4zWzWJAJp9MUNLCwT+ImVM7
JBlhCwFA3tMXdwYAXpF8Nnahr0ks5uzcVPizhq4Xt5gRt2TGWWu2tESeo39t7Jf2
T5xV5e2N9ssYYiloqdT+l7Y7/ezMmgkrkaT87h1LezeaqCwpVeP0brI/EKddJZ+Q
Je9FNKcG2zwA5pYkkivJlpLm2uSxhNeew2DYXatjoIare9VyMhZ4wYiAoT/MRNVH
bLDkxrjw4PR7SX7VpHzXi3l9xhiM6ZXYdRMBxCyXjnNPbi+XZ9PGqHqOz4fNwjyo
K4iGlIKpdI3i9Y4v10MGPTWDn8aUQj7NMu5PmgnWzeTVgNgOKQatt8ZRgJs4e+ID
iXKjZmvOausyTZX6PcTN6POlxrDW5j828uM8FR03TZBRhGIkp18zOL0GURHoSKH4
KhmB3fIJbwE5Slbdk84iaFxYcThkY3TZ9YnwCoUTxgLRqRxUUb9KSuzgMEo6nTAs
J68PpRFFdZI=
=69DU
-----END PGP SIGNATURE-----

--Sig_/GB.pA.Vkq5przOpWYtx=sWz--
