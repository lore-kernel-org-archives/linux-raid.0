From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] raid5-cache: add journal hot add/remove support
Date: Wed, 16 Dec 2015 14:42:27 +1100
Message-ID: <87y4cv9hzw.fsf@notabene.neil.brown.name>
References: <48dfb85817d51f68d8da85368711ed14f945caa4.1450159900.git.shli@fb.com> <87r3inb3eh.fsf@notabene.neil.brown.name> <20151216013310.GA741432@devbig084.prn1.facebook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20151216013310.GA741432@devbig084.prn1.facebook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: linux-raid@vger.kernel.org, Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Wed, Dec 16 2015, Shaohua Li wrote:

>> And I'm a bit uncertain about setting rdev->raid_disk to
>> mddev->raid_disks.
>> I thought we decided that "Journal" devices had a different namespace
>> for raid_disk than data disks, so ->raid_disk of 0 was appropriate?
>> Setting the journal raid_disk to mddev->raid_disks might cause problems
>> when we ultimately support reshaping an array with a journal.
>
> 0 will introduce confusion in sysfs entry, eg, which disk should
> xxx/md/rd0 point to? Create a special sys file? This appears the only
> reason we don't use 0.

sysfs_link_rdev already avoids the "rd%d" link of Replacement devices.
Change it and sysfs_unlink_rdev to ignore the Journal device too.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWcN2jAAoJEDnsnt1WYoG58o4P/j6zahTvcnMCHnb/P2Upo8os
7aRA+E9GbRk+3JLgmhtD+pC60S7DXZoU7htTPKuW5c5mwxSNcHwMg6NVwu78/50o
wcC0tQSbxTst6S6Zxh93xvU1fEZkmG7k8mlqoMSdQMw0j2ucarrkoB9MDnWgGPM2
Vng8K2cNs4XDQIeGOYV0POXLr5yk++FeI9uIYMyZqNukWGiPXMp2OxpYsmaMsuEZ
w8rD+QYXokPc3qUleUhFTPOBdn9NGoVwQsWTzQYdIGKE9ZgODLIivOZB7eS6n0vx
+J7DOGEwS14VjhwMtyLjBYe7iEr8EXEHMZXAv+evQRRecxFz4zTAaiQthCaAQeZt
EGQJRsgNCfsZwAuMwPqIvY1Av0WCSqg9oec9VJltdhn69e9dU2gZkREJ1JyMP7vG
qWSHKqE98MW0zHWHUve2DXlLVUDvIhJELxXReVP+acOnWaoFRkWJIAzGO5Ic3aVu
dUnduo4Z99WzUa/EYtGPqOiLbWAo3Ch7oTk1jAv5AYh0RVkZ0qt/8Er32y74KkSU
x87gHKkLGtDrEgG3+1F9/8L36XUNGofeg+t0PZ15xULk6ChbfWSny6GrSKn3FqSI
c3MjEROmYy/76Avk/YUutMVTY5l8yG99NPi+x7HiCojglXMnOptMnme0q8cn6K32
Cncu3Y9K9Rs+wq/m/tRs
=VwOE
-----END PGP SIGNATURE-----
--=-=-=--
