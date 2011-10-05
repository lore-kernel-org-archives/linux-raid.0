From: NeilBrown <neilb@suse.de>
Subject: Re: potentially lost largeish raid5 array..
Date: Wed, 5 Oct 2011 13:13:16 +1100
Message-ID: <20111005131316.27314c0b@notabene.brown>
References: <201109221950.36910.tfjellstrom@shaw.ca>
	<20110923151108.08c1199f@notabene.brown>
	<201109222322.57040.tfjellstrom@shaw.ca>
	<201109230209.36209.thomas@fjellstrom.ca>
	<20110923191539.110b7be1@notabene.brown>
	<4E7E5266.5040205@shiftmail.org>
	<20110925201025.53bc87f7@notabene.brown>
	<4E87A06E.6080109@shiftmail.org>
	<4E8898C4.8060803@shiftmail.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/__ph/H+_uQ.U4Cizdjmob8e"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E8898C4.8060803@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Aapo Laine <aapo.laine@shiftmail.org>
Cc: Kristleifur =?ISO-8859-1?B?RGHwYXNvbg==?= <kristleifur@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/__ph/H+_uQ.U4Cizdjmob8e
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 02 Oct 2011 19:00:52 +0200 Aapo Laine <aapo.laine@shiftmail.org>
wrote:

> On 10/02/11 01:21, Aapo Laine wrote:
> > Actually we could even open a new mailing list or maybe there is=20
> > something better in web 2.0, like a wiki, for these MD code=20
> > explanations. Explanations in a wiki can be longer, there can be user=20
> > discussions, and such lines of comments do not need to be pushed as=20
> > far as Linus.
>=20
> Sorry, I wrote this before reading other replies. Kristleifur already=20
> proposed what might be optimal, that is, GitHub

Anyone who wants to is welcome to create a kernel tree on github, apply
patches, and send me pull requests. To just email me patches.
However the patches arrive I will need to review them at least until I have
enough experience with the person to have good reason to trust their patche=
s.
Typically the extent of review will drop as a history of good patches grows
until I just pull any that looks vaguely credible.

I don't think we need any new infrastructure to allow this.  We just need
people with an interest to create and submit patches.

If someone says "I've created some patches but they aren't getting into
mainline because ...." of some reason, maybe because I keep ignoring them or
losing them in mail inbox or something, then it might be time to look at
technology solutions to make it easier for new contributors to get patches
in.  But until those new contributors are trying there isn't much point
making it easier for them.

Thanks,
NeilBrown



>=20
> > I think concentrating all code explanation requests, discussions,=20
> > and/or at least the answers, onto something like a wiki could prevent=20
> > double-questions. Unfortunately I know nothing about wikis or other=20
> > web 2.0 technologies. Maybe someone in this ML can suggest a solution?
>=20
> Ditto
>=20
> +1 on the github
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/__ph/H+_uQ.U4Cizdjmob8e
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOi708G5fc6gV+Wb0RApxIAJ9fJqsp97haz+H0HI6hTdjT/V0WiwCeMGEV
7KlY1vAkPm/6w+oARmKKI1k=
=EgH7
-----END PGP SIGNATURE-----

--Sig_/__ph/H+_uQ.U4Cizdjmob8e--
