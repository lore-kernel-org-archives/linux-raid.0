From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: What's the typical RAID10 setup?
Date: Wed, 2 Feb 2011 09:25:08 +0000
Message-ID: <20110202092508.GA18517@cthulhu.home.robinhill.me.uk>
References: <20110131203725.GB2283@www2.open-std.org>
 <AANLkTimxCkxkg6xuz8FgFf0=u4KY=0M=6+afnxLzT+Tu@mail.gmail.com>
 <AANLkTi=+rPzaNTKAjB=QUEGsbUcwfN8uijm96DoY_4FA@mail.gmail.com>
 <AANLkTinM6FkJtxL8dNpoy-haGqNsZVfLDwmvZcshTEYQ@mail.gmail.com>
 <AANLkTi=kUGc8bjisn69BEEkZr6kcHUyfKnVZzNtgaJf3@mail.gmail.com>
 <20110131225235.GA11775@www2.open-std.org>
 <ii8lcv$3jg$1@dough.gmane.org>
 <AANLkTin1MPYZGMuL75c=_q+ndeiz0F5+eCRudpDdTwu9@mail.gmail.com>
 <4D4883A3.6030605@hardwarefreak.com>
 <AANLkTikcOA3hSwx29H++sayJ4PcY00_mQBw91TyYXO05@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tKW2IUtsqtDRztdT"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTikcOA3hSwx29H++sayJ4PcY00_mQBw91TyYXO05@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue Feb 01, 2011 at 09:12:11PM -0200, Roberto Spadim wrote:

> but the best algorithm is time based (minimize time to access data)
>=20
And what do you think takes the time accessing the data?  In a rotating
disk, it's moving the heads - that's why the current strategy is nearest
head.  In an SSD there's no head movement, so access time should be the
same for accessing any data, making it pretty much irrelevant which
strategy is used.

Cheers,
    Robin

--tKW2IUtsqtDRztdT
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEARECAAYFAk1JIvQACgkQShxCyD40xBLxFgCgsW3/NXDbbr9gmoCNxhGzV/4w
IuQAoICJdWTzwjRtUcakvyrV3hCcImFI
=MLBw
-----END PGP SIGNATURE-----

--tKW2IUtsqtDRztdT--
