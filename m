From: NeilBrown <neilb@suse.de>
Subject: Re: arch/86: AVX RAID5 xor checksumming
Date: Wed, 11 Apr 2012 06:14:42 +1000
Message-ID: <20120411061442.2f839c77@notabene.brown>
References: <1334078551-6859-1-git-send-email-james.t.kukunas@linux.intel.com>
	<4F846FBC.9060503@zytor.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ezuCh74pRIGaxdDL5+mhvF/"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4F846FBC.9060503@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jim Kukunas <james.t.kukunas@linux.intel.com>, x86@kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/ezuCh74pRIGaxdDL5+mhvF/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 10 Apr 2012 10:37:00 -0700 "H. Peter Anvin" <hpa@zytor.com> wrote:

> On 04/10/2012 10:22 AM, Jim Kukunas wrote:
> > Hi Folks,
> >=20
> > The following patch adds an AVX implementation of the RAID5 xor checksu=
mming
> > functions.
> >=20
> > Based on xor_speed, the AVX implementation appears to be ~32% faster th=
an the
> > SSE implementation on my i7 2600:
> >=20
> >         generic_sse: 15088.000 MB/sec
> > 	avx: 19936.000 MB/sec
> >=20
> > Thanks.
> >=20
>=20
> I think this (and the SSSE3 patches for RAID-6) should go in via the
> RAID tree.  Neil, do you agree?

I'm happy to take the SSSE3 RAID-6 patches as they only affect lib/raid6, b=
ut
I felt that this one - being purely in arch/x86 - should probably go via the
x86 tree.
However I'm flexible and if you (collectively) are happy with these patches
going in through my tree, I'll do that.

Thanks,
NeilBrown

>=20
> However,
>=20
> Acked-by: H. Peter Anvin <hpa@zytor.com>
>=20
> 	-hpa


--Sig_/ezuCh74pRIGaxdDL5+mhvF/
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT4SUuDnsnt1WYoG5AQKcQg//WLW+nSBKgGQ2RiuNVOScaNX6xzotJ6Lt
Ls9eE/X3ePBJrnmXv3N6O3qd6t42ppvHOzj+Tc2Dz+yxQ9vsfJ6cs+STq7+qx5wZ
CHlTUKW8hhohdVqMq9QsMCMqeDDdWM3a01derNKD5BDpIDsvGYRB/yFuQT32mnxT
ho2NgcRW7bBr7TkbQsZ1u+SaG6IdApaYmTbhEXnr6j+9ev1ckj3lVzYOkNp8zdws
xC77zHQWhCEw6TZUETbgIARp4WVWPYYTAe1JGdopfrqDnh1eW6K7Gb85Nq0NfwFi
2A/ZLJBzcAtWz8sWMXrKDGMlI5FHmRtSLAMbZPUzvOID1X7Be4Ov8LqNyPmz+Hq7
i0Sc2VLA3IxoHJMteKFWDoQpfX5IQcRk54nQWLqc6ZOD113Kl/0Tn5NDhAQv0OX2
NXwhyeN334ddSfpLTfvvbwI5NIsr6pLKVNo1K3Ws1cqXDG/vEOqa6odYq1r6J3Ft
jXlxtXFt5wR4oqHheJ5t2NzSm2+pOGQF96nraBAMDxIEO+RYEZbFPXhJeUnsS/NW
h4t0+yu3dMKXghyMVvLUXiMHA/zdBjaZaZh7XDWlsKvWW822gCFsv2QwkLAmq3Pi
REtKpIpzRd8h0sZUOW5jB7zcI0Kf4EoQdyNF2O8gw7xoLS8TJFJo7UH4PuvT42OZ
fttCUhu7occ=
=D6zq
-----END PGP SIGNATURE-----

--Sig_/ezuCh74pRIGaxdDL5+mhvF/--
