From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH v2 0/2] mdadm: re-add journal to array with bad journal
Date: Wed, 16 Dec 2015 12:45:50 +1100
Message-ID: <87fuz3b1yp.fsf@notabene.neil.brown.name>
References: <1450143823-1145846-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1450143823-1145846-1-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: dan.j.williams@intel.com, shli@fb.com, hch@infradead.org, kernel-team@fb.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Tue, Dec 15 2015, Song Liu wrote:

> These patches enable recreation of missing/faulty journal. This requires
> kernel changes as well, which Shaohua will send out later.
>
> Song Liu (2):
>   add sysfs_array_state to struct mdinfo
>   [mdadm] recreate journal in mdadm
>
>  Manage.c | 42 +++++++++++++++++++++++++++++++++++++++---
>  ReadMe.c |  1 +
>  mdadm.c  |  8 ++++++++
>  mdadm.h  |  5 +++++
>  super1.c |  3 ++-
>  sysfs.c  |  7 +++++++
>  6 files changed, 62 insertions(+), 4 deletions(-)
>
> --
> 2.4.6

applied, thanks.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWcMJOAAoJEDnsnt1WYoG5nZ4P/ie58BI7k/dVUDqXTOF9VPmZ
UqMTqAHxzbdbLy3CmPxUKG7j3Dw4TsqJNOY3L0V5wW14qrKEhvXBgkmU5v5NcGNQ
8qZcr+csjQ7ebmysO5v4wxcJfSL/TmB07GliErY3d+ax5lRmbjuKkfde/5kVucDz
aC+b+00YKUFbbo+CspJ2V8SpwWUCMkgO0Ob+b8Iaq4mXNcWswq1paEjOcG3964z+
ve+ugFgplxSVsmLu75F0+ARvvS/20QH31xIbIdLAe4bg8/xCbGrNmJeJMk1ceQvB
XTt9gZTWpzXIUbXzXKRf0W5DsUFKz0sJMbpGtgkviMukQxpWik7UYFcA6qSRK0xD
zAxp6WHsuessZkAJpqnsL95ti7Yo2WwO/02+ZOmxT0GX6d2NZmKhZeLvvoQNQtsc
KSqAyWjQEgfLNNDRGEPfRZPGxjp10t1I87Fr389Z+SS0M6VKYpH+hQ7YwsaolI5q
t40aPyNU0hBUNUzHDyYbhsX2pL/cPtJnNpkzA7zyVd+OD6QWEf2vS53aV+80rmPE
r+Ql91wUzx+ED+sEgu+3lKHCPuSyJ+qS85tvF/95BT/Ol/pSifswlyY/UC4V4BO0
4O8FPQxZ0Dp5HZeBn4auIn1DZDLilov67A0mfWgOgMOQiUaNe4D1RFjQxsy98Ieu
rIDsB4qcv5hha9kh283A
=jHH5
-----END PGP SIGNATURE-----
--=-=-=--
