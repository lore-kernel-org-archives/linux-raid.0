From: Andre Noll <maan@systemlinux.org>
Subject: Re: Proposal: make RAID6 code optional
Date: Wed, 22 Apr 2009 20:50:07 +0200
Message-ID: <20090422185007.GE13280@skl-net.de>
References: <200904180946.27722.prakash@punnoor.de> <49E98AD2.8060601@msgid.tls.msk.ru> <200904181117.03418.prakash@punnoor.de> <alpine.LNX.2.00.0904181551320.16493@swampdragon.chaosbits.net> <20090418145850.GD28512@mea-ext.zmailer.org> <49EDD11E.2030309@tmr.com> <49EE00F9.6090000@zytor.com> <20090422180051.GD13280@skl-net.de> <87vdowlevi.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Lb0e7rgc7IsuDeGj"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87vdowlevi.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Bill Davidsen <davidsen@tmr.com>, Matti Aarnio <matti.aarnio@zmailer.org>, Jesper Juhl <jj@chaosbits.net>, Prakash Punnoor <prakash@punnoor.de>, Michael Tokarev <mjt@tls.msk.ru>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids


--Lb0e7rgc7IsuDeGj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 20:31, Goswin von Brederlow wrote:
> > Really? Easier than keeping only two 256-byte arrays for exp() and
> > log() and use these at runtime to populate the (dynamically allocated)
> > 64K GF multiplication table? That seems to be really simple and would
> > still shave off 64K of kernel memory for raid5-only users.
> >
> > Andre
>=20
> Oh, you mean when the first raid6 device is started and not when the
> module is loaded.

Yes, that's what I was trying to say.

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--Lb0e7rgc7IsuDeGj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFJ72bfWto1QDEAkw8RAjbqAJ98LnuA3C5ltc+rq34W/eLSCUTiSACgiuYj
Il/XAF5dCal5wiQGoN/ElwI=
=TuCF
-----END PGP SIGNATURE-----

--Lb0e7rgc7IsuDeGj--
