From: Neil Brown <neilb@suse.com>
Subject: Re: [PATCH 0/3] improve mdadm support of write journal
Date: Thu, 22 Oct 2015 12:22:29 +1100
Message-ID: <877fmf1yui.fsf@notabene.neil.brown.name>
References: <1445452516-2816184-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1445452516-2816184-1-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, hch@infradead.org, dan.j.williams@intel.com, kernel-team@fb.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

Song Liu <songliubraving@fb.com> writes:

> Per discussion in
>
> http://marc.info/?l=linux-raid&m=144522071120149
>
> and related threads, the following patches add more support
> for write journal (test script, man page, small refactoring).
>
> Song Liu (3):
>   mdadm: refactor write journal code in Assemble and Incremental
>   mdadm: Add description of write journal to md.4
>   mdadm: add test script for raid456 journal
>
>  Assemble.c           | 24 +++++---------------
>  Incremental.c        | 25 ++++++--------------
>  md.4                 | 20 ++++++++++++++++
>  mdadm.h              |  6 ++---
>  super1.c             | 19 +++-------------
>  test                 |  9 ++++++++
>  tests/20raid5journal | 64 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  7 files changed, 111 insertions(+), 56 deletions(-)
>  create mode 100644 tests/20raid5journal
>
> --
> 2.4.6
Thanks for these.  I have applied these patches and pushed them out.

I did make one small change.
The two entries you added to 'struct mdinfo' you put at the end, which
is in a section labeled:
	/* Device info for mdmon: */
They don't really fit there.  I moved them earlier.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWKDpVAAoJEDnsnt1WYoG5YVoQALd6rHWeNxYTtn8WbhCMJJEU
BeCiNmiwocr0FjrCX334ETZt4ouLPSOgltV0JK50qSyEBSz/DsgFgwbQJv4iEVle
LJAok2wz+DafVRE1BHpp3W/bRco8RuBXVQJrZkQugUgVk7wcImkaS4brokPvjIFb
Ka6twx4IIbTBsvHhKg9DWqZ6HM9CFbIRrJrPXw9YSdy+Rk79jB/MmW2Nw+XLEQev
usT9iNfwQUDLnMNUzIAjJpM50MeitD0uTgyGmLBHBWJ9/pTWmc34fy3age3r3hge
Newx1AowdHji/Zo4DVVoA21qC1vQSsUHj7+fsrEioZKi95/Ezjs4IR5gMUaCGP4/
/bsR8rbA6FB+uDNZB+WzHav+RejpSC76l8Gmiv6LxxPMURyRXaLEpIeGytqmvsfb
+AQEhEDDiOrhHLsmiWjB73E6XYEvUjrI6W2ZuvQT42OK407JHjGRX3TwciIVlXSg
VX3aGlsxu2K7BZKwPExUseujNBG3n7D4RgoQhtOzDiZIMGw4tswMUUXnakJanIWl
cVG4F49/FxZg7bo3ztVe3JT1Ep/V8ObhJxPazRsD22QU2tFHwbBsKuSqSmGSKMu8
9/o7myUSI/QZgyVSPyfob76Z9Ijwk7qI2/xIvsNpo4+BZGg175Q83QfNLt6kytVz
VzHrDlCBZ9YeCg8jKmV4
=bjlj
-----END PGP SIGNATURE-----
--=-=-=--
