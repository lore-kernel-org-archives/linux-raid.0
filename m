From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 0/3] mdadm: re-add journal to array with bad journal
Date: Fri, 11 Dec 2015 09:05:47 +1100
Message-ID: <87si3ac62s.fsf@notabene.neil.brown.name>
References: <1449018805-320020-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1449018805-320020-1-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: dan.j.williams@intel.com, shli@fb.com, hch@infradead.org, kernel-team@fb.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Wed, Dec 02 2015, Song Liu <songliubraving@fb.com> wrote:

> These patches try to recreate missing/faulty journal in mdadm. Since
> the array is readonly with journal missing, it is necessary to
> restart the array after recreating journal.
>
> Song Liu (3):
>   add sysfs_array_state to struct mdinfo
>   [mdadm] recreate journal in mdadm
>   make .spec file work

I didn't get that third patch???

The patches generally look good, but it bothers me that you have to stop
and restart the array for the added journal to work.  Can we just teach
the kernel to accept a new journal on an active array, and then use that
functionality in mdadm?
That is certainly what I want in the longer term and I'm not sure it
makes sense to have a half-way "--add-journal" that doesn't do the whole
job.

Thanks,
NeilBrown


>
>  Assemble.c                  |  8 +++++++-
>  Manage.c                    | 32 +++++++++++++++++++++++++++++++-
>  ReadMe.c                    |  3 ++-
>  mdadm.c                     |  8 ++++++++
>  mdadm.h                     |  5 +++++
>  mdadm.spec                  |  8 ++++----
>  super1.c                    |  3 ++-
>  sysfs.c                     |  7 +++++++
>  udev-md-raid-assembly.rules |  2 +-
>  9 files changed, 67 insertions(+), 9 deletions(-)
>
> --
> 2.4.6

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWafc7AAoJEDnsnt1WYoG5KroP/jRU2lW/378Z6mQiY4a9JRtC
LjHC0A3wqeUXc0Ty9j2JVs/8bYWFUsrELYuiIivjCoGXvmTot2QQ148Zcj4gFOMx
rLImT62Qr67bsLpZsoWO+QwZEp+EbWyXoKuhIHV6TtVb96j0HPFovZJ2B93fMUr4
ZvKrBXPz3BcDdg8NMWH+d1ZybhFpKXkmWB8zD+8ursoKtwKRwX5kTSAs2wLx0eq+
njZZWA8vNUrr5gM7JKNZwPElfgDZ+bqW+Mg3I1K4JzaBm7EDbOgg7t/2b2cCg3R3
va3CxtBCvG3Zfu3tXPdNQOH69M6ZMHHuT77lZQSNmpD+YerihUOc2IMMc9NULyTy
MciCEFYwGZT77IKkDzY2y8xzJk+CPl6ft814yXOsDkKVV8GJEeZbPCxTyU5Bj6bx
dCT7N/ZPoFl5au1aWFkJgOzfnaaFGZZ2B9oMQFxLhRKW0phJe3NL1MvJd6qKmTTn
vLCSzYEcXPWeY8rWkcuOJtZ5MDJp2AXSoHthCD9mM6SUBUotGnPHwTg+oIlDR73N
knt5tc4KQIE6W96n1mPlhty8H55yUc5JeO1iT9V7VXd66RSDnW7drkGWHHG3V071
7KWDBZ/s/j9bunHzaVc+bGoVsI9q6u5mNdILpAytJx1wEbLgZ//cE6u6KM8wqVCy
ntYSR8xkgD/Bmc3PTN5j
=LJdk
-----END PGP SIGNATURE-----
--=-=-=--
