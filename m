From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] Fix race between --create and --incremental
Date: Thu, 1 May 2014 17:17:10 +1000
Message-ID: <20140501171710.038e1323@notabene.brown>
References: <1397056499-6743-1-git-send-email-artur.paszkiewicz@intel.com>
	<20140410103337.30c9dc7c@notabene.brown>
	<5347BF2D.1030609@intel.com>
	<5360E36A.2030402@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/+xFzQIBV1UniWYwuG1v8l8R"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5360E36A.2030402@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/+xFzQIBV1UniWYwuG1v8l8R
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 30 Apr 2014 13:50:02 +0200 Artur Paszkiewicz
<artur.paszkiewicz@intel.com> wrote:

> On 04/11/2014 12:08 PM, Artur Paszkiewicz wrote:
> > On 04/10/2014 02:33 AM, NeilBrown wrote:
> >> On Wed,  9 Apr 2014 17:14:59 +0200 Artur Paszkiewicz
> >> <artur.paszkiewicz@intel.com> wrote:
> >>
> >>> This modifies locking in Create to eliminate a situation where
> >>> --incremental can assemble a device between write_init_super() and
> >>> add_disk(), which causes Create to fail.
> >>>
> >>> It sporadically occurs e.g. when metadata is written on a device,
> >>> causing an udev change event which triggers mdadm --incremental.
> >>>
> >>> Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> >>
> >> Thanks for the patch.
> >> I've taken the liberty of changing it a little.  I didn't like the
> >> fact that
> >> we dropped the lock and then took it again.  It probably doesn't
> >> matter, but
> >> it feels cleaner to hold it the whole time.
> >>
> >> So this is the result.  Let me know if you disagree at all.
> >=20
> > Hello Neil,
> >=20
> > Your changes are OK, thanks.
>=20
> Hello Neil,
>=20
> Are you going to apply this patch?

I had, but I hadn't pushed it out.
I have now.

NeilBrown

--Sig_/+xFzQIBV1UniWYwuG1v8l8R
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU2H09znsnt1WYoG5AQJjbhAApCz8ArIOG7CJoO+iSzzFKiTpKXS3vN/s
ARrYXdxwc3CFi8xRRiXAuZZdC9zNigNmwMwnBsU0jnlyiyo69GB0UNEQqnbD0VQH
mvR7LZVCyt8yQ5QYj2yeO4f6QMRIG7gg6xmsWz0jwFveX2rTQO3A1WcUVImyRdOf
2HOF1JGqy0U1WsDsfjeo43FkiS6pFns/GkFRkqPiy8XtWJiIad2YWSddrUgAtkJg
yLdtiAIpX6V5G9SNVevnPKDO3y2wlIAD8w7vo/8s2Vbc5JKFA/l6fKcCONLTATPz
9zmpIAqnBV5N4grlLW//UvtZZyjht8JqVn4nRurA7qaBT0gqM2F9VPwwwJ4tYFsL
Z6XxN3YUiLDVWJyBBJncwu/mCkVncRu14P8sVfhpukn8lVcT/D4ei54n/7cYdxGp
O8LtW4I7s+H8yJO6mQ6HOkogjUKRXepduPQ5ZIHxpcbnGrq9c5uITj17knAsWI1o
AsvA814+cdoX4vpsjH+A01fIPRCoNkODAzXP3T+oDT9xfJ4aSZW5i5tJ7zIqHif9
X9SthoYEZUlMK2G3X3rP+kH7FxqTpR1fREw6Ws2AHr05ej3APrRuvIu0+7CLJ8Em
r0HxxW96W3lbcDTRhTN9kqTH/i5oO8gQ7y6i5+R15bh1hQibSqmjh52pz7AKfRlG
uXCqH5wkFKQ=
=yQg5
-----END PGP SIGNATURE-----

--Sig_/+xFzQIBV1UniWYwuG1v8l8R--
