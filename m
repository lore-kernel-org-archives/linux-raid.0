From: NeilBrown <neilb@suse.de>
Subject: Re: Understanding raid array status: Active vs Clean
Date: Mon, 23 Jun 2014 12:01:02 +1000
Message-ID: <20140623120102.7d85ac52@notabene.brown>
References: <CAG__1a4MRV6gJL38XLAurtoSiD3rLBTmWpcS5HYvPpSfPR88UQ@mail.gmail.com>
	<20140529151658.3bfc97e5@notabene.brown>
	<1C901CF6-75BD-4B54-9F5D-7E2C35633CBC@gmail.com>
	<20140529160623.5b9e37e5@notabene.brown>
	<CAG__1a5j-0O7LOb6opz4MLPCjbxRNDXiaG6W=Xxt3JJ9eXfRRA@mail.gmail.com>
	<CAG__1a5XK1yt70ox_12hLjpBpY=YRcaJ6-MYHiEJ_RTpxFujoA@mail.gmail.com>
	<20140618150326.GA28569@cthulhu.home.robinhill.me.uk>
	<CAG__1a7m2BakDGUtP==YunzmBr8WDXVVv4i2WE=sYhBNKYjM1w@mail.gmail.com>
	<CAG__1a7zGbxzkR_a2ci4rw3xacxGYt07aBiAsFjGPYowXBPCcQ@mail.gmail.com>
	<CAG__1a4kX1gM+ntmcLkevCm6kwVbgSMGmPi-ec6+b1RGKznouw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/LgE=GCtK.N7OaEYGVcphSJ_"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAG__1a4kX1gM+ntmcLkevCm6kwVbgSMGmPi-ec6+b1RGKznouw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: George Duffield <forumscollective@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/LgE=GCtK.N7OaEYGVcphSJ_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 22 Jun 2014 16:32:31 +0200 George Duffield
<forumscollective@gmail.com> wrote:

> Can anyone give me some hints as to why this array would remain Active
> rather than report Clean?  Any help/ insights much appreciated.

It is a mystery.

>=20
> On Wed, Jun 18, 2014 at 6:04 PM, George Duffield
> <forumscollective@gmail.com> wrote:
> > # cat /sys/block/md0/md/safe_mode_delay returns:
> >
> > 0.203
> >
> > changing the value to 0.500:
> > # echo 0.503 > /sys/block/md0/md/safe_mode_delay
> >
> > makes no difference to the array state.

What if you write a smaller number?  e.g. 0.1

What does /sys/block/md0/md/array_state show?
If you "echo clean" into that file, does that "fix" it?
Does it stay fixed if you write to the array?

NeilBrown


--Sig_/LgE=GCtK.N7OaEYGVcphSJ_
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU6eKXjnsnt1WYoG5AQItOw//cGe08+gZ+WESyx8bPa3Dp7TS+IBn62Jd
ngSNb35CRBDqAMxy/9jeDagETn4GTbTrKPPsvmK9oxHSg6e6pZyirH+c6QU0Hipc
IE/tJppP6YefVu6HB44UmWUYRNtWBtRbPn+xYrU6n6X5YUuJ3SaP0FZH91DpxWmR
+pY6l2c51gBCv0c6n+u6Hw8BfyAU+gLDDaLq7CsasyUn6CaJr1UA958mUJRmqy4W
UrMfkgLsZhwfUKQTDwv+V9G9tLKNLeJQ0u/SpcEoDAkklGfmFLKg8z6JcIBHDyzB
NmbwgGczg5HXCl8IaLT5F7BCBC+Y78/RPsKv824LE/skoNfCkilDbHKfwJt7t2ig
juJdgkmzKLuyckuY3tAswOsZi60zxPH9E4cYaxHAPsAww7ivspQ+kdsl7XVOJFRT
fQsxfhbdukU6/Bi7Bkv2ORw8yDSIOv8HXrFzR+T0+mJeGTBSqNd3B6oXaY1o0SrT
0hJdMWxPBx2iQD5WJAPhhZ6ZSB1hqmdvZJhQUf6JR+Qul0f9yb6syximVKV1254K
oU5RzNvDEw81MQrnz6NEA5BTKHP/jZNfCrcPDBmsyCSpG7O3UaTErYgu0Am5kOoP
5kxWmP4D9AGje2ud+hbheLR5c8vn4Jw+2mionUrkKFLyr/6CjjhuM38g87apT93B
ASk+kG2QDOw=
=QKh8
-----END PGP SIGNATURE-----

--Sig_/LgE=GCtK.N7OaEYGVcphSJ_--
