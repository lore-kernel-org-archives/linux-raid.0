From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 0/7 v2] MD linear/0/1/10/5 TRIM support
Date: Mon, 13 Aug 2012 11:51:57 +1000
Message-ID: <20120813115157.2c8fe2d6@notabene.brown>
References: <20120810025113.050392766@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/j1GsxY3aofamzEnS68NuI=k"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120810025113.050392766@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fusionio.com>
Cc: linux-raid@vger.kernel.org, axboe@kernel.dk, shli@kernel.org
List-Id: linux-raid.ids

--Sig_/j1GsxY3aofamzEnS68NuI=k
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 10 Aug 2012 10:51:13 +0800 Shaohua Li <shli@fusionio.com> wrote:

> This is the patchset to support MD discard, which I refresh against latest
> kernel. It's pretty straightforward for raid linear/0/1/10. The raid456 d=
iscard
> support is tricky, please see the log in the patches for details.
>=20
> Previously when I posted the patches out, people complain SATA SSD discard
> request merge error. Now a patch to disable discard request merge is in J=
ens's
> tree. We don't have this issue any more.

I've applied 1 to 5 (linear,raid0,raid1,raid10), though '1' will probably
need to go through Jens' tree.

The RAID5 changes need a bit more work as described in a separate email.

Thanks,
NeilBrown


--Sig_/j1GsxY3aofamzEnS68NuI=k
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUChdvTnsnt1WYoG5AQIyOQ//Z0ln7kjLTkJk3c7Yae3HFQGD2KLCl0hF
19ommRfXxBjEMVhu25FfML9rIy7ZhsN4vqiqcXKJIKaz3xrCpQjHP0JReQwaQxa1
fOHkyxAjFQxvQ7LepRBGb/CNYGTYniqNBpL5p5zVFhPUT/xvZ1yKNVN6ncrtMSzq
x8oWmkgZ+DYbM+ccfEOgUuE+6DtMxhYwzC3AD/Des0dW3g+5OGWNA5nJrNFEXVh6
gss7em1SLabr81outNpKmK16m/3DykaugiDikH+kK92rPdKdqyoxYWzen+PuLGx0
yCXY0M3oAIxtPboeHs2qGCobyMuNzhQ48W8W2fhh+EXWrNRxUBc0+0JMHD4cqPFZ
wSdzHXSpkYtNZF/E/5hDgsEF8txmY1gwFg8PW67E/iEwaDH/vbdTqPcOMYhM10Cg
2CR1VPhRnIHHt2Tkf4F/9ZPwwyJSlgRJcJmsDXzweTL2tnDC4CWjHRqJMJ36DVqL
JnekzGoxhLXh05eUaOqLdNcegD5LCZdbwTfGgu1gzTXUyMdB+3/i8F++l5zBOMQB
J5/3acGs56jUmVAo3kgE3+s4648DSDyxOHblwuVN3r0wOQHMJRJbhGxNYiPwJIvP
2UU9+TTy0JhYMjpHxK+edtuAQk+0jToQgKUyZi5leEvMOE8wHIl3+hl+CW0CfBp8
hkwAeuXxB2k=
=EC7Z
-----END PGP SIGNATURE-----

--Sig_/j1GsxY3aofamzEnS68NuI=k--
