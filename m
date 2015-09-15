From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 02/12] raid5-cache: free I/O units earlier
Date: Tue, 15 Sep 2015 10:07:12 +0200
Message-ID: <87zj0o5cnj.fsf@notabene.neil.brown.name>
References: <1442038638-6947-1-git-send-email-hch@lst.de> <1442038638-6947-3-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1442038638-6947-3-git-send-email-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Shaohua Li <shli@fb.com>
Cc: linux-raid@vger.kernel.org, Kernel-team@fb.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

Christoph Hellwig <hch@lst.de> writes:

> +	sector_t reclaimable;

sector_t is unsigned (u64 or "unsigned long"), so

> +	BUG_ON(reclaimable < 0);

This could only be a compiler bug.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJV99GwAAoJEDnsnt1WYoG5e9cQAKIiih5PXLadOSUUKTt4CCtv
HnPliuImcn7ICtzR62d+d7heRypK+ODZNS92atBJoWSXa22rLwtS+l266Y6K3va6
Wzle3BxDp0DeTUu7snsLAU5MNhFLHopcvyFwXhgInORySw4XfCECV9+QuyQKSyH2
az/PcvqPIDg1vJYcxFquONNVxgtA8MlsHCjoWYtbX19VNgbYU5FmTg81G4DxDjDn
mp05DAZv6yqth9Buxhxdq4ZzLC+COaVILrKl2yH9Gw5j3HDV+37wfdcq08fck81B
NYIySF6VE5Axwi4kcH+32Fto7RHXX3DYFacYJWYHJ27d6Bh5IHkRcPjdui1xZV2q
OrvnAZ9rhopRO8jJDhECt1SQPrwlzqfNPT191TxeXQttL37xmIoluGl02yp5ALuX
FNVNYzwrZexrz75F1s/VRnxccLgxHzt0qToZT7iiWSUSwyph07r6Xd5tgkSmPEHZ
bbCDIRTZZC1oGtcAnQ4759y5jggMxiXQsbvIJm4RrMNSKbpVIa0eDL4pWf4rDN+g
jlGcYjGcFhK3St3S+hUxpKwoc6dD8GhGMJH5Qioh2EuUCTdXthsJzLcvJ+PCsVTB
sVnZN7VExbdcTOt08t+bqAcndSl/p5WyvJQMhgZEcZJz3CrFlLws6ZBsmUd6gJFy
qD9D28edUU1eEt0DB1Tb
=8Grf
-----END PGP SIGNATURE-----
--=-=-=--
