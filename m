From: Andre Noll <maan@systemlinux.org>
Subject: Re: Proposal: make RAID6 code optional
Date: Wed, 22 Apr 2009 20:00:51 +0200
Message-ID: <20090422180051.GD13280@skl-net.de>
References: <200904180946.27722.prakash@punnoor.de> <49E98AD2.8060601@msgid.tls.msk.ru> <200904181117.03418.prakash@punnoor.de> <alpine.LNX.2.00.0904181551320.16493@swampdragon.chaosbits.net> <20090418145850.GD28512@mea-ext.zmailer.org> <49EDD11E.2030309@tmr.com> <49EE00F9.6090000@zytor.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cQXOx3fnlpmgJsTP"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <49EE00F9.6090000@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Bill Davidsen <davidsen@tmr.com>, Matti Aarnio <matti.aarnio@zmailer.org>, Jesper Juhl <jj@chaosbits.net>, Prakash Punnoor <prakash@punnoor.de>, Michael Tokarev <mjt@tls.msk.ru>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids


--cQXOx3fnlpmgJsTP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 10:23, H. Peter Anvin wrote:

> We could use vmalloc() and generate the tables at initialization time.
> However, having a separate module which exports the raid6 declaration
> and uses the raid5 module as a subroutine library seems easier.

Really? Easier than keeping only two 256-byte arrays for exp() and
log() and use these at runtime to populate the (dynamically allocated)
64K GF multiplication table? That seems to be really simple and would
still shave off 64K of kernel memory for raid5-only users.

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--cQXOx3fnlpmgJsTP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFJ71tTWto1QDEAkw8RAp4vAJ9iLsVZNoHj6MTjnutXYcFpLjmolQCfTVbP
X4pqty735DnfZ05u0XDEmMY=
=F0Ey
-----END PGP SIGNATURE-----

--cQXOx3fnlpmgJsTP--
