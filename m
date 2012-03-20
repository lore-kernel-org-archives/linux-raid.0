From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 00/11] Various cleanups and minor fixes
Date: Wed, 21 Mar 2012 08:11:30 +1100
Message-ID: <20120321081130.239d577a@notabene.brown>
References: <1332262456-5109-1-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/_KPXnlorFUzVyB+m6rSMd7O"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1332262456-5109-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/_KPXnlorFUzVyB+m6rSMd7O
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 20 Mar 2012 17:54:05 +0100 Jes.Sorensen@redhat.com wrote:

> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>=20
> Hi,
>=20
> This patch set implements a number of smaller cleanups, as well as
> fixing a couple of cases where we don't zero out the full buffer we
> just obtained via malloc.

All applied and push out - thanks.  There were a few conflict which some
stuff I was working on, but nothing serious.

>=20
> The most controversial is probably patch 06 which caches the device
> block size for aligned read/writes in super1.c to avoid calling the
> ioctl() on each write.

Yeah, it's a bit ugly, but seems reasonable.

>=20
> I also introduced some generalized ROUND_UP macros to avoid the manual
> pointer and size manipulation in various places.
>=20
> The ddf code I am unable to test as I don't have any raids with ddf
> layout, but it does compile.
>=20
> Cheers,
> Jes

I think it might be nearly time for 3.2.4.  Do you have any thoughts about
that?

Thanks,
NeilBrown


>=20
>=20
> Jes Sorensen (11):
>   super1.c don't keep recalculating bitmap pointer
>   Define and use SUPER1_SIZE for allocations
>   init_super1() memset full buffer allocated for superblock
>   match_metadata_desc1(): Use calloc instead of malloc+memset
>   Use 4K buffer alignment for superblock allocations
>   Use struct align_fd to cache fd's block size for aligned reads/writes
>   match_metadata_desc0(): Use calloc instead of malloc+memset
>   Generalize ROUND_UP() macro and introduce matching ROUND_UP_PTR()
>   super1.c: use ROUND_UP/ROUND_UP_PTR
>   super-intel.c: Use ROUND_UP() instead of manually coding it
>   __write_init_super_ddf(): Use posix_memalign() instead of static
>     aligned buffer
>=20
>  mdadm.h       |    8 ++--
>  super-ddf.c   |   19 ++++++----
>  super-intel.c |    2 +-
>  super0.c      |    6 ++--
>  super1.c      |  111 +++++++++++++++++++++++++++++++++++----------------=
------
>  5 files changed, 87 insertions(+), 59 deletions(-)
>=20


--Sig_/_KPXnlorFUzVyB+m6rSMd7O
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT2jygjnsnt1WYoG5AQJmUQ/5AZbgvkY+e2Iu5D9Rn8Cb8ia1AcZJVCp6
9OU+inZOXw5DC2PCcy+GiP2gdqSALPkhO46EwkKvOhbCLYLTNjbO8Y3Dz46uyKQT
VF8s5amWABD3XkghSWxnRNWpkgSbcqXxzezbTCu7ReAn+KNh/U+21RWHCocaFMD+
VSCld0GtPxu5yA7Eesyr46/ADEUGMVWA0pGXbQxaNz23+4M1RCGcLCPqBKswZbdI
WPctKx8a+3ZurhvTrEmvj72nHgDJE4kLfBFCRtGuXJnFcKcY2p6QqGhhzY2Hpkg9
8FKKgd1CEVFd9U+FjUogKOYGKg5WdAxA5QMvNY5DRKczxlc3BK4gnlEI/0lmJNXb
0ca/o2/LKCyTnZHm8OBKSOfyGbY44EZhSJjvms15t2Xkv4W8H9rIx0TTot05651W
AMG8Qj8OgBPAhgYEhD1VDNRXPXP7UJ4ZvScQwA6YbMFHDCf56kBkY/ocl0iikZsb
8i8eq9ZwohOAs/RaV2ZChP+NVqxOVh6ItevXtzzsEadvV0/z4o7lKUZOfVi/KYlX
M1jlnmykYwK5k1Q3m1ViNRgJ8WSPFpQk/4524CGBPongBiEjRMVpb86TQY5Zqavm
iuHrtUtcQ1/hW9HT1Pxbp44vOnhMUJl5lSvL6lc7SzC/AuhfjU86cGS6KKiwQCRt
jd3MI+OEYTU=
=Uock
-----END PGP SIGNATURE-----

--Sig_/_KPXnlorFUzVyB+m6rSMd7O--
