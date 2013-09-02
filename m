From: NeilBrown <neilb@suse.de>
Subject: Re: question about mdmon --takeover
Date: Mon, 2 Sep 2013 18:10:35 +1000
Message-ID: <20130902181035.79408f97@notabene.brown>
References: <CAC9WiBgFPSeKGBYxYCkw8DHk4dS6=aBhCeiMGgkj2eNgtY0asw@mail.gmail.com>
	<20130805165908.2d1e291b@notabene.brown>
	<CAC9WiBhab-Acx+U0NWAxki+M9sXccdEPBj=LyLPYQv3XQ_Nnxg@mail.gmail.com>
	<CAC9WiBgunq0nHC2s1sOk=2zdTwDCJZN_5VOUgqA27r1s+0PNKQ@mail.gmail.com>
	<20130902120403.374b0895@notabene.brown>
	<CAC9WiBgmYX4JuxRAHvB7pa3udi7NAN8Ys42iWRYu49OF_wcPbA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/v0ZtX4NzHQ.wDX+xzV1=iMo"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC9WiBgmYX4JuxRAHvB7pa3udi7NAN8Ys42iWRYu49OF_wcPbA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>
Cc: Martin Wilck <mwilck@arcor.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/v0ZtX4NzHQ.wDX+xzV1=iMo
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 2 Sep 2013 09:56:26 +0200 Francis Moreau <francis.moro@gmail.com>
wrote:

> Hi Neil,
>=20
> On Mon, Sep 2, 2013 at 4:04 AM, NeilBrown <neilb@suse.de> wrote:
> > On Sat, 31 Aug 2013 22:21:36 +0200 Francis Moreau <francis.moro@gmail.c=
om>
> > wrote:
> >
> >> Hello Martin,
> >>
> >> I'm adding you in the discussion because you might have an idea on
> >> what's going on with my array which is using DDF metadata.
> >
> > Hi Francis,
> >  I think this problem will be fixed by Martin's latest patch set.
> > The root cause seems to be that safe_mode_delay isn't being set properly
> > which is the same root cause as the other problem you had.
> >
>=20
> That's correct, this patch fixes this issue as well.

Thanks.

>=20
> May I ask you when the 3.3 release is planned ?

I was waiting for a confirmation from you and one other from Martin.
So you have just brought it closer.

Tuesday or Wednesday I expect.

NeilBrown

--Sig_/v0ZtX4NzHQ.wDX+xzV1=iMo
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUiRH+znsnt1WYoG5AQI8zxAAtkfSF0dPFYL9EysuT5RiGTo5mdqMgv1y
99bhZ2CFcdAyqg3QyCanle1ZpY+ruzFIsT5anOp2soOkhYtKK3Sw599VUzCw02j+
iJBMTH/cyvJ98tq1Wk/tLPlU+GrQzpo6WXv9z3y0djRsqHGbLsRmox2IAZf6fvzw
K71i7i5e0o+Uvpn6t9oR6L0/WNfHPbhi1qaHH31vYnQKkC4CQxJfA9ep08x/qlD8
aXQMhjqUvvZWrpGJrrwl9YBxwsAQEzHdxAJR7HBxOD1lkemJ1eKd5qwoXE5W7k2q
EHtmRIEi3Kkvqj0ETRo3o064ExzsUVQPLVFrw8QFdGb2W9xu1rTIhGFR0QV57IjM
KU1SboWPUIRLbSCFqMPc9JzJ3I3P08gJ3+6V3cEwI1DmAry+P3tClgRRp7M5afcM
3HZLS5j8CGiqDg4hbzsoeOasklmCUITtfIwgLJToJbVY4QoT/ioMvXGpClJ0xu3V
d4DrvY1W4bhtlVBu6G3yzDzVarc/beD7jSPbXxEkpmvs27Z8sGfTOpC31cvkB/rA
9U8DmoDY19wQRr/p/EXlmUAGbfua0HkTw1yriPNU1eX3Ll8pMETfXGzpAmFxM7eI
KuiC/lNZb3OtFsmKzr6KZPqvZ5+ZL8zYiR9SlC3BUBREmFqeQREzLIE17hCIhGBX
f6iFzWk/Ztg=
=UNyC
-----END PGP SIGNATURE-----

--Sig_/v0ZtX4NzHQ.wDX+xzV1=iMo--
