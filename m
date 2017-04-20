From: NeilBrown <neilb@suse.com>
Subject: Re: [md PATCH] md: handle read-only member devices better.
Date: Fri, 21 Apr 2017 07:54:30 +1000
Message-ID: <87h91isq21.fsf@notabene.neil.brown.name>
References: <87a87lutj7.fsf@notabene.neil.brown.name> <20170413054723.2spvhtze6bljkaop@kernel.org> <877f2muvmc.fsf@notabene.neil.brown.name> <20170420202306.zcsx4prawtqyapfy@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170420202306.zcsx4prawtqyapfy@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Linux-RAID <linux-raid@vger.kernel.org>, Nanda Kishore Chinnaram <Nanda_Kishore_Chinna@dell.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 20 2017, Shaohua Li wrote:

> On Sat, Apr 15, 2017 at 02:45:31PM +1000, Neil Brown wrote:
>> On Wed, Apr 12 2017, Shaohua Li wrote:
>>=20
>> > On Thu, Apr 13, 2017 at 08:53:48AM +1000, Neil Brown wrote:
>> >>=20
>> >> 1/ If an array has any read-only devices when it is started,
>> >>    the array itself must be read-only
>> >> 2/ A read-only device cannot be added to an array after it is
>> >>    started.
>> >> 3/ Setting an array to read-write should not succeed
>> >>    if any member devices are read-only
>> >
>> > Didn't get these. We call md_import_device() first to open under layer=
 disk. We
>> > always use FMOD_READ|FMOD_WRITE to open the disk. So if the disk is ro,
>> > md_import_device should fail, we don't add the disk to the array. Why =
would we
>> > have such issues?
>> >
>>=20
>> Because life isn't always as simple as we might like it to be. :-(
>>=20
>> md_import_device() calls lock_rdev() which calls blkdev_get_by_dev().
>>=20
>> blkdev_get_by_dev() doesn't pay much attention to the mode, nor does
>> blkdev_get() which it calls.  The main place where FMODE_WRITE could be
>> rejected on a read-only device is in the device's 'open()' function.  A
>> few open functions do check for read-only, but it isn't at all
>> consistent.
>> scsi/sd.c does, block/loop.c doesn't, nor does nvme.  Most drivers seem
>> to ignore the mode.
>>=20
>> blkdev_get_by_path() has
>>=20
>> 	if ((mode & FMODE_WRITE) && bdev_read_only(bdev)) {
>> 		blkdev_put(bdev, mode);
>> 		return ERR_PTR(-EACCES);
>> 	}
>>=20
>> so when you open a device by path name you always get this check, but
>> not when you open a device by device-number like md does.
>> It is worth having a look at
>> Commit: e51900f7d38c ("block: revert block_dev read-only check")
>> from 2011.  The bdev_read_only() check was in blkdev_get() for a while,
>> but it was moved out because doing that broke md and dm and others.
>>=20
>> So at present, callers of blkdev_get_by_dev() need to do their own
>> bdev_read_only() tests before writing.
>> We could discuss where in md.c is the best place to put them, but unless
>> you want to take on a largish project to 'fix' (or audit) all callers of
>> blkdev_get_by_dev(), they need to go in md somewhere.
>
> It's unfortunate we need the hack, but anyway I applied this. I'm wonding=
 how
> useful a ro array is. At least ro array with .sync_request is dangerous b=
ecause
> we could read inconsistent data.

For a RAID0, a ro array is as useful as any other ro device.

For RAID1 etc it isn't so obvious, but the code tries to do the
correct thing I think.  e.g. if a RAID1 is not known to be in-sync, then
reads will all come from the "first" device, so data should not
inconsistent.
If that first device fails, you will start getting reads from the second
device, which could be a problem.
I think it is better to allow access despite possible problems rather
than denying the possibility of read-only access altogether.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlj5LhYACgkQOeye3VZi
gbmfCQ/+P/LNhceWZkwK15yEV2FoLx6miLipK3cFPh3iAuszIrUTucwY0qzfgH5S
X963NJ4fNgIxOVpTez9HNS3wCkTaLfUBHA/wnisFjii8cFZ9EJ9sYH/rktgFvXlx
ouuF1fxoOSg1zd4EjFw144ukQUlfZUL6+jzX3nRQLRssmUL0aXmfKW41AwgklcOS
wcgXIKyPttMR14VvMcOfbnJ1/gWKt0VCxGSLsGaCpe/EPTrVO0iwTEo45CkDrZKS
u8jGiJxJB7JyNXeoEyGjzPLmNynixN7Izq9QG5kOk1h3Z5moYLjnAV+e9asl5Iwk
76sb/xD4zYZacstAIhOoqZ6Jo+2KKryVqLZkAolZNQjxZgoIkayOs0SuOYxN9f4z
VDo8NvVHVXGjO78dtjX+vQLsPlf0F+Pcz1+fR9RMUMxnlh/xUbcuf88cXtHCsffy
6bBKbX+01YgMcm1Tz9slbyWsGQkGGWxYen6y0SG+iELNjuhJJwRsySNe3isTSMC5
CNVPGQiErYBn9hE82nUBpJ5MjQg8WtiKRtcTz8vIyo/C6bkoPTIIzpx8FUCtlztB
WqqZwU0sYjye4Lx4mvYN8VUtsasx0hYydnIfcKr0gydT4Wx6DaDgtjhfWGU+YR64
17wo0yZdAA1OrN4sJYb8vsKiCTjWfGuGXDnnup/ibcRfux6JZ7s=
=vTDZ
-----END PGP SIGNATURE-----
--=-=-=--
