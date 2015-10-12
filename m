From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 0/9] raid5-cache fixes
Date: Mon, 12 Oct 2015 17:17:19 +1100
Message-ID: <874mhw1uhc.fsf@notabene.neil.brown.name>
References: <cover.1444360850.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1444360850.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

Shaohua Li <shli@fb.com> writes:

> Hi,
>
> some fixes for raid5-cache/md. Mainly supports trim, handle IO error and
> handling array assemble with missing/faulty disks.
> patch 1: fix a bug
> patch 2: support trim

These two I've replied to separately.

> patch 3-4, IO error handling
> patch 5-9, handle assemble issue when journal disk is missing/faulty

These I am happy with (I think, it is getting late, my brain slows
down...)
I was going to apply them but they depend on the trim support to apply
cleanly.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWG1BvAAoJEDnsnt1WYoG5tycP/ReQwOn2xnpZ9fVlqL6yB22W
MyIIQewtd+4c/M7J+MpDy3Y6nLPGHYA2/VC95LYakcQxrgOsPfo5yzx3P0vMqRfy
2yN3WnS8cGKrVC1X2zlOqJtZ7wfjIza1rZF30ARRxJERhbX7PmmXwjfOUASv8/oX
27jk2VzxwvkkkYTE4swlza/Bjgr1Y2rZZYBZAWRR4z2h2KKsMNzJ8/uBdJWuRv+h
DQV57ripbA4/Kj5/IL2e/fe742w8FAeamjvYksY3yMBpIfElHLA6KAX8+4bDqIUt
3TCRUTwGs4tHxoa3a1rVCrBTu9C9DYC8dSjwPH77nw9eb5/PbUGN5QRDGTyYFnlX
XAiXOY6Wl0CFVLqZTFVxz7eSk7DpKZVIkDqwfquJ41KeAnRs8lzbf2NqlTeVb40Q
OVRpLq1wwXnlO7xNtUdAm5m6UVH2/fxn7doG/8Ke1zO6tDcPZ93KHjybX23Z+Xc3
usPtjEGhcqnCN+QapG7QPKdzcEOg6rXEaKOOqKWht2SyPT/H+LVXXDBFmrZOD0fm
RGg9RkuScCEzfoZfclo4dreREOXejU7QalgtvbpjY6KWrxZwR4fnxVLw15wvCMaX
wTiX14MSHtvFcyYp2YO5usZSg+gcIMyWM/p8fX+hWGgyE0meabDvKUBqicoiXmZh
+xXkssWyhc3YUsgU/69D
=O7rF
-----END PGP SIGNATURE-----
--=-=-=--
