From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: DDF Trial Use draft specification now publicly available
Date: Thu, 11 Mar 2004 10:18:28 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040311161828.GB6173@lists.us.dell.com>
References: <20040311154542.GA6173@lists.us.dell.com> <39646.208.27.111.121.1079021333.squirrel@mail.davidoffdotcom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8GpibOaaTibBMecb"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <39646.208.27.111.121.1079021333.squirrel@mail.davidoffdotcom.com>
To: Samuel Davidoff <sam@davidoffdotcom.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--8GpibOaaTibBMecb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


On Thu, Mar 11, 2004 at 11:08:53AM -0500, Samuel Davidoff wrote:
> Are there plans to incorporate this into md, allowing for compatibility
> between software and hardware arrays?

Scott Long and Justin Gibbs from Adaptec have been working on an
"Enhanced MD" which allows for plugging in different metadata formats
to MD, including md-traditional, DDF, and Adaptec's own format.  It
was briefly discussed here a month or so ago.  Unfortunately at the
time, the DDF spec wasn't publicly available yet for review and comment.

Thanks,
Matt

--=20
Matt Domsch
Sr. Software Engineer, Lead Engineer
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com

--8GpibOaaTibBMecb
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFAUJFUIavu95Lw/AkRArs7AJ4hQWaz6bmFHPc9S/aRIzO/rh9XiQCfSrAs
554Mx/vDtCFpZ0Rqm5zNpMs=
=/Qq0
-----END PGP SIGNATURE-----

--8GpibOaaTibBMecb--
