From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 00/17] mdadm: SCSI enclosure based array
Date: Wed, 16 Dec 2015 13:01:43 +1100
Message-ID: <87d1u7b188.fsf@notabene.neil.brown.name>
References: <1449015933-255689-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1449015933-255689-1-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: dan.j.williams@intel.com, shli@fb.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Wed, Dec 02 2015, Song Liu wrote:

> These patches by Dan Williams enable creating RAID array based on
> SCSI enclosures.

Is there any background reading available so I can have some idea what
these patches are supposed to do.
I have a vague idea what an "enclosure" is but I didn't know that Linux
knew about them.  Is there a link to the LWN article about them or some
other useful documentation?  "git grep -i enclosur Documentation/"
didn't show anything likely to be useful.

And what is "/dev/disk/by-slot"?? I've never come across it before
and google doesn't help much.  Just these patches and
  http://comments.gmane.org/gmane.linux.scsi/93809

which doesn't seem very conclusive.

So currently I am not able to review these patches.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWcMYHAAoJEDnsnt1WYoG5xo0P/2bHpktAWFkSSWTPAiCuibfr
xt5/kmr2rP70Jljk4qJZASM7ZyJC44gwZ8XyJrl8MckdiMM8urfJ+BRXGiURWwPm
X7RYOynOBKQw3gwXzrVqVS89RVjQ6K2b4XW2Mz5MrvPQ/5NbVF55qrbaf8WMNBiV
aLhFXFmumeyXmcEJBWp546eagTbSftjmWT2ZB00ZV8EdIiJBsqBMo1EEdkG6+oRZ
kKAhplcCJPZMTtCyf0qnP9eaD1xjBvWyCPRVNTUC+VcieJF6SF3+jDizem76czAI
NODWnGgZV+Eg9L0P5anfmhC886Y0PEfxBJs6xZbHNQZxo7qL49jL6isvuVy+rfEE
oC5OouIXVoWcjxyY04LjiGJfSoLHV3Kok/bVdja3Yj64LiKIuOYqaHqR0qw+faNN
ciNAkDA32PVghi7w8YdCB+VAnnLGkVTqS/4cXDuqMTeK6GJNCqbEZUDW1qFhXDfg
LPqv749ucac5ShHpWwi/xitgV35PaxOLQ11ALbE6w5Xg13ZPfEmpcXXXSFeMLAkM
0gkCcTnwxXJjvpPzhU9mmTi8OUF7J/IrQTc6O3C9vBUQYk8TVOcnXlxj3Ah6QrfB
bWkyk3lMKcV7Clbw++ot1h9qyoiadoQ+U8qZkTj4F9HuvN00EV8T5nXU4+7kir8m
QVOMd/k9DlNrsSLy1rvl
=eZf+
-----END PGP SIGNATURE-----
--=-=-=--
