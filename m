From: Matthijs Kooijman <matthijs@stdin.nl>
Subject: Re: MD Raid1 hangs system on read error (3.10)
Date: Mon, 6 Oct 2014 07:32:51 +0200
Message-ID: <20141006053250.GD1452@login.tika.stderr.nl>
References: <20141005092700.GA1452@login.tika.stderr.nl>
 <20141006110833.5028706c@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="ZJcv+A0YCCLh2VIg"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141006110833.5028706c@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--ZJcv+A0YCCLh2VIg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Neil,

> You are running 3.10.3.  It contains a bug that was fixed in 3.10.32.
>=20
> http://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commi=
t/?id=3D9f2d289933e60ec726a7a9522e2dcdfdc82c58de
>=20
> So if you upgrade your kernel, the problem should be gone.
Great, I was hoping things were so simple :-)

I already thought I tried upgrading the kernel at some point, but it
seems I upgraded some older kernel package I had installed. Just
confirmed that all the crashes happened using 3.10.3, so you're most
certainly right.

Thanks!

Gr.

Matthijs

--ZJcv+A0YCCLh2VIg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJUMimCAAoJEDeYrxWhVlZYyNEP/0GEoIStEPZuGK/rbiA7so1g
/UDJDHOOwrJddpUuhOklJqGOBxSgn+qvjoXZUqCWdJDXZQKMADUsP3ZF0GHpMCts
KA8jobD4g/o+GmRDdZDTZwNmZmgPuSQZOD6MrQ758RQGfpkhI0TYnhYFBIDYmYLn
hrtQEUexvAtUF3K2Ddn2zjnm/+FeS/gqai2ZARKcuPAHkojCIj8NTnA7GJhSsZh0
3E7KcNZId/OTiWnABZZcXO3vhu2d6BY6oL+blsw+5dbT/Mp9Jtp+Ds0EGsRdH7Zc
A3XleCjRPB5rnnq/ZqqnMAhA1I0Uh8df67Ys4/EzOrd6u8q6sRDr5up5Xm6g8/DO
y//GZThNSUX+q7C2epdTOB29B5KhBR5Uj8k8KHCmVHa7owmN8US4T1GIycvxmAPJ
oH5KZetn16PohN4z2oZs117pK0hZPYPq6skDOJr8oEcabWmbUaFC4qCps4tmBmsE
rf9ZRzGXoxIgkPPD49lnmlZbiocQJxZq5x6aBjIouVyq7UV7dpx+o5K1o/bb2Je9
HHWtAgVUjOgp+m33tKkae0H3+gDFVAQT1p60KqI96ehhSR2+zG8DRlv+Qucd7Pje
yo90bS/52O5fi5MQ/l6ggpGs3jobN9PfBjChXzK/8q/TAU/M6fCQ8qmXaBeQszXd
O7+py6cwUeqsHratGyiM
=uGAk
-----END PGP SIGNATURE-----

--ZJcv+A0YCCLh2VIg--
