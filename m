From: NeilBrown <neilb@suse.com>
Subject: Re: [md PATCH] md: handle read-only member devices better.
Date: Sat, 15 Apr 2017 14:45:31 +1000
Message-ID: <877f2muvmc.fsf@notabene.neil.brown.name>
References: <87a87lutj7.fsf@notabene.neil.brown.name> <20170413054723.2spvhtze6bljkaop@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170413054723.2spvhtze6bljkaop@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Linux-RAID <linux-raid@vger.kernel.org>, Nanda Kishore Chinnaram <Nanda_Kishore_Chinna@dell.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 12 2017, Shaohua Li wrote:

> On Thu, Apr 13, 2017 at 08:53:48AM +1000, Neil Brown wrote:
>>=20
>> 1/ If an array has any read-only devices when it is started,
>>    the array itself must be read-only
>> 2/ A read-only device cannot be added to an array after it is
>>    started.
>> 3/ Setting an array to read-write should not succeed
>>    if any member devices are read-only
>
> Didn't get these. We call md_import_device() first to open under layer di=
sk. We
> always use FMOD_READ|FMOD_WRITE to open the disk. So if the disk is ro,
> md_import_device should fail, we don't add the disk to the array. Why wou=
ld we
> have such issues?
>

Because life isn't always as simple as we might like it to be. :-(

md_import_device() calls lock_rdev() which calls blkdev_get_by_dev().

blkdev_get_by_dev() doesn't pay much attention to the mode, nor does
blkdev_get() which it calls.  The main place where FMODE_WRITE could be
rejected on a read-only device is in the device's 'open()' function.  A
few open functions do check for read-only, but it isn't at all
consistent.
scsi/sd.c does, block/loop.c doesn't, nor does nvme.  Most drivers seem
to ignore the mode.

blkdev_get_by_path() has

	if ((mode & FMODE_WRITE) && bdev_read_only(bdev)) {
		blkdev_put(bdev, mode);
		return ERR_PTR(-EACCES);
	}

so when you open a device by path name you always get this check, but
not when you open a device by device-number like md does.
It is worth having a look at
Commit: e51900f7d38c ("block: revert block_dev read-only check")
from 2011.  The bdev_read_only() check was in blkdev_get() for a while,
but it was moved out because doing that broke md and dm and others.

So at present, callers of blkdev_get_by_dev() need to do their own
bdev_read_only() tests before writing.
We could discuss where in md.c is the best place to put them, but unless
you want to take on a largish project to 'fix' (or audit) all callers of
blkdev_get_by_dev(), they need to go in md somewhere.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljxpWsACgkQOeye3VZi
gbmRjBAAhq3aB49WnY5gGv97g7CrKaoThYXWQdRG+JDGcDAe6vjUu5Msz09SWo2l
pfOexrHNj7r/KqiqBLzuwK6QvhvAw649Y47S+11D95YUmjibhFF4Kni5e+1hB1RV
jm2BwFbq8JWAHH2QhdrBMWqlmrP4FwHz1HtEs6/ESEicPmfPaktRp9wfXlHyLMSN
Qu84U8d19WZMB1ZhvCU+Ofr7o3kEWwpXfaSVvqjlZh9g/18gNS4DFoIZQQSyQJ2i
vg0rIoBk7kMPxmG7ZxRADT44fdByQSmpOhHhQn/Hew16OOQg0prN7W7yO3fo9tj3
dWV9zUNupG6l6PlkMrQ/DfkYdO4X+16+E+gALQFg00XbjhVBIA6yW4FlXPGMPjpv
PjLsn11JMSkAOTd1MILUq9hN2sye8W3aZ0Ja0cbp5RpJqsDKzcp8RIYwAu8QLwq/
mIF+VCBc7mic12xZlPGbcp/BjPnGma2bZbM0ngIe6/zCz6aZXtcnmwQVchZH0Dm6
a6CE9n0qQciHdDrKR4wH/cFoz6qbzvD7vBxjMh4vojc+V4X5sBjcGmsSeirTY+ab
rTaDXMHY31PgjYtASDvxc4+0r3PV8D7x/973z7/IkdQ+UPt8loZm4Mqwd6KRXpSu
lD18rQjOhlhAfvsJDqy23wVrXo9WeWMtXG3gCWTCRpvceBiHbWg=
=2zdf
-----END PGP SIGNATURE-----
--=-=-=--
