From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 0/6] raid5-cache fixes
Date: Thu, 08 Oct 2015 14:18:19 +1100
Message-ID: <87egh66oas.fsf@notabene.neil.brown.name>
References: <cover.1443973492.git.shli@fb.com> <87mvvu6rfr.fsf@notabene.neil.brown.name> <20151008025603.GA3007253@devbig084.prn1.facebook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20151008025603.GA3007253@devbig084.prn1.facebook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: linux-raid@vger.kernel.org, Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

Shaohua Li <shli@fb.com> writes:
>
> please hold 5 currently. I'm a little confused about the In_sync bit.
> It's quite tricky to handle this bit. For example, if both In_sync and
> Journal bits are set, I'll need move checking the 'Journal' bit ahead of
> checking the 'In_sync' in super_1_sync (current patch haven't done it
> yet, it's a bug). There are similar cases in mdadm too. This makes me
> thinking about What's the exact role for the In_sync bit for journal
> disk. The comments in the bit definition doesn't give an answer. We can
> use the Faulty bit for error handling. Any thoughts?

"In_sync" effectively means that recovery_offset == MaxSector.  It means
all data which should be on the device is on the device (except as
described in the bad-block log).
It is set at array-creation time or when recovery completes, and is
cleared when an error is detected.  It is useful for differentiating
between a spare being added (without In_sync) or a recently failed
device being re-added (with In_sync).

None of this really relates to the Journal.  So as you say, it doesn't
mean much to set that flag for the log.

Maybe r5l_log_disk_error() should check Error rather than In_sync.  Was
there a reason you didn't do that in the first place?

I'll drop that patch.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWFeB7AAoJEDnsnt1WYoG5TWQP/2cMeSLrzg824Cc7oXQ+sWEf
EotCbeI675HQZOZNk1asvmrMr23Km3A3laOxEd7pDJfLK8WEO6H5sYNteHKnbX6m
sQVYfmbsJ+4xz6cDcIeTogB9hjIKxGXF7sMSmXgOxkzHLlDKIqhX/EK+hqH6rn05
UP+JeA29M2jINANWQEIpChapDszHuJQIEXwSf1NNbQzlamb9rZR/2/vniY+/vl3V
AeHTnQWszc9qsY9Q7f9WEvcFvB92SmYrV0B2vIkmxwsl+/JAJnTLOTAEnsKV+9ke
6zVEzZdratUROWeE6VFnRQwQ6dCZQTXouBQIq9E1alK27uxVMCQJN03AhwjnlgFm
u5rk4bGg9xsjhw8fRU0Lxf2jV12lkQKZCE0jgjcoftCCVhR6VU/4G+hxosKNBwce
3+4iHnueO/Kf2wNQVRuJkGrErW1eSk7B/YZ/2kuUQ3yj72QafKxfky+8lAv9JCM2
IZznaJ1mwd15ZutOhivL5ilxm/vv2WbWhlLC8Qozp3HezbKdmIlK56OgPLecpvB9
FwyGQHZJqRaPDVjgToqyYNCz+i8cN+gUqrz3cEpvOO2dOSRxmY4OJ6TNlK3SUmOq
gxVlC3PaFiagSAJMZSkHNnAC34t4pPxSKjj/oHfZApo9dCb7o8elI4JFdH6POZ6x
5th+GfF3/Y1U3hzh0yEB
=qsm2
-----END PGP SIGNATURE-----
--=-=-=--
