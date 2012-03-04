From: NeilBrown <neilb@suse.de>
Subject: Re: md:Badsector must in valid range of component device.
Date: Sun, 4 Mar 2012 20:32:41 +1100
Message-ID: <20120304203241.40a407e3@notabene.brown>
References: <201203011906162346140@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/p/oqJ4V8uIsb5bZnSSR/LAf"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201203011906162346140@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/p/oqJ4V8uIsb5bZnSSR/LAf
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 1 Mar 2012 19:11:16 +0800 "majianpeng" <majianpeng@gmail.com> wrote:

> >From 98de4803f7ae4ad49b680db4889bbcd1534c5303 Mon Sep 17 00:00:00 2001
> From: majianpeng <majianpeng@gmail.com>
> Date: Thu, 1 Mar 2012 15:49:56 +0800
> Subject: [PATCH] md:Badsector must in valid range of component device.

Why must bad sector be in the valid range?

i.e. I don't think this patch is necessary.

Thanks,
NeilBrown


--Sig_/p/oqJ4V8uIsb5bZnSSR/LAf
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT1M2uTnsnt1WYoG5AQLu2g//XdgicBsV3MyQZJUA48WzBsIR7K20zsYC
iohUCzkUId1KJQYKBa6B1UoYthED1o/D4ovrWEO6YEpEKq+ojh+QylTd3Ub3AtWC
ZBuQ6b0Vzyn9BlyDhSITnfmGxXhPwWp0ECSIWP61vCuRsdJWJAOARHgTtoPjxjgh
P7eMAWJL6UsWcV7lDBVq06WIRMDy5T4thuUaVdaaF+F5SBPgi0XI35HjMUWIvx/s
5bqSJEpA2p2rWY5i1hnWmLPpg4sWT+d6q5L7C6+5xr5GIcNbMXnwRy1C0avalLQA
tGH4evpM5iwz/LWbqVXOhoLHpUPGG5/N2xDM128iBsJHaZmqmIaLGHsScLSW9EeZ
DJRO/wbWSHrmsETZdaeL39bihz8s8qoMnmHu86J8dqg6m8xj03+owHhpwg3H+0MA
5SvAe/69FZ8ELhcBz7KOB/3DQxQbyx49XUWLSeRiVbllhVPnc/tZ7C1sqs5HnhXH
T8yj+HHVZVzqBD70S/6SjsLQBA3Zw9hroajZISBpfCq4tWztASWNSCEB98fCYF05
bDfeAiL1EL7dsaibYbcQItMgWZfebLXEtY0ZYvFqXWy+t6Ob1ye7CqogneGTCCbq
Yn1s4onegXdmw0XD4GBwwtEEqbSpEEe+Wmn9zBBAqi8qb8WyfIPTX25HxMHfhFqQ
rjMIkr2Vs4M=
=ESJa
-----END PGP SIGNATURE-----

--Sig_/p/oqJ4V8uIsb5bZnSSR/LAf--
