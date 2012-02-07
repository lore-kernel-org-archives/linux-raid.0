From: NeilBrown <neilb@suse.de>
Subject: Re: sb->resync_offset value after resync failure
Date: Tue, 7 Feb 2012 11:55:11 +1100
Message-ID: <20120207115511.619f44e7@notabene.brown>
References: <CAGRgLy44uKSggEsrU4Fx7op7iVjoPPq-doMdYjxnSGDm6krf9A@mail.gmail.com>
	<20120126115132.75d9d8bd@notabene.brown>
	<CAGRgLy6DWGzWCYjTer2DGv5rpU_78_mPvubKAUv1FiQE40HcbA@mail.gmail.com>
	<20120202091919.1d6dce52@notabene.brown>
	<CAGRgLy75f6Q8Gi0NBiMMFmNz5MSWQdiAaMLRFJUYPzFezMM-pw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/EbSxMVC=aEsy50k_3rGkVtq"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy75f6Q8Gi0NBiMMFmNz5MSWQdiAaMLRFJUYPzFezMM-pw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/EbSxMVC=aEsy50k_3rGkVtq
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 6 Feb 2012 13:41:57 +0200 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Hi Neil,
>=20
> >> # After resync is aborted/interrupted, recovery_cp is updated (either
> >> to MaxSector or another value). However, the superblock is not updated
> >> at this point. If there is no additional activity on the array, the
> >> superblock will not be updated. I saw cases when resync completes
> >> fine, recovery_cp is set to MaxSector, but not persisted in the
> >> superblock. If I crash the machine at this point, then after reboot,
> >> array is still considered as dirty (has valid resync_offset in
> >> superblock). Is there an option to force the superblock update at this
> >> point?
> >
> > My we just need to move the 'skip:' label to before:
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0set_bit(MD_CHANGE_DEVS, &mddev->flags);
> >
> > it is that flag which causes the superblock to be updated.
>=20
> Thanks for the hint, will try it. For production though I'm a bit
> afraid to recompile my own kernel at this point.
>=20
> >
> >>
> >> # When resync aborts due to drive failure, then MD_RECOVERY_INTR is
> >> set, and sync_request() returns mddev->dev_sectors - sector_nr. As a
> >> result, recovery_cp is set to device size, and that's what I see in my
> >> raid6 scenario. At this point three things can happen:
> >> 1) If there is additional drive to resync (like in raid6), then resync
> >> restarts (from sector 0)
> >
> > It should really just keep resyncing from where it is up to, shouldn't =
it?
> According to the code:
> 		else if (!mddev->bitmap)
> 			j =3D mddev->recovery_cp;
> if the array has a bitmap, then it starts from j=3D=3D0.

Good point.  When there is a bitmap the recovery_cp number if irrelevant as
the bitmap stores equivalent information with might finer detail.

>=20
> >
> >> 2) If there is a spare, it starts rebuilding the spare, and, as a
> >> result, persists sb->resync_offset=3D=3Dsb->size in the superblock

I just looked into this and tested it and I don't agree.
->resync_offset does not get set to sb->size.  It gets set to the value that
curr_resync got up to which is correct ..  or fairly close, it should really
be curr_resync_completed.

So I don't think there is a big problem there.

> >
> > Hmm.. that's wrong too. =C2=A0It make some sense for RAID5 as if there =
is a spare
> > recovering we must assume the rest of the array is in-sync. =C2=A0But n=
ot for
> > RAID6.
> >
> >> 3) Otherwise, it restarts the resync (due to valid recovery_cp),
> >> immediately finishes it, and sets recovery_cp=3DMaxSector (but not
> >> necessarily writes the superblock right away).
> >
> > This bit seems right - assuming you are referring to the 'raid5, no spa=
re'
> > case.
> Yes, and also to raid6 with two drives failed during resync.

Yes.

>=20
> >> > Maybe every time we update ->curr_resync_completed we should update
> >> > ->recovery_cp as well if it is below the new ->curre_resync_complete=
d ??
> >>
> >> I'm not sure it will help a lot. Except for not loading part of the
> >> bitmap (which I am unsure about), the real value if recovery_cp does
> >> not really matter. Is this correct?
> >
> > It is stored in the metadata so if you stop the array in the middle of a
> > resync, then start the array again, the resync starts from wherever it =
was up
> > to. =C2=A0So having a correct value certainly is useful.
> > (Having a value that is less than the correct value is no a big problem,
> > have a value that is too big would be bad).
>=20
> Neil, as I pointed out earlier, it looks like resync always starts
> from j=3D=3D0, if there is a bitmap. So there is no real importance for
> the exact value of recovery_cp (I think). Only whether it is MaxSector
> or not. Am I missing something?

Yes, when you have a bitmap recovery_cp is much less important.

>=20
> >
> >>
> >> I have another question about md_check_recovery() this code:
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 if (mddev->safemode &&
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 !atomic_read(&mddev->writes_pending) &&
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 !mddev->in_sync &&
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 mddev->recovery_cp =3D=3D MaxSector) {
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mddev->in_sync =3D 1;
> >> Why mddev->recovery_cp =3D=3D MaxSector is checked here? =C2=A0This ba=
sically
> >> means that if we have a valid recovery_cp, then in_sync will never be
> >> set to 1, and this code:
> >> =C2=A0 =C2=A0 =C2=A0 if (mddev->in_sync)
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sb->resync_offset =3D=
 cpu_to_le64(mddev->recovery_cp);
> >> =C2=A0 =C2=A0 =C2=A0 else
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sb->resync_offset =3D=
 cpu_to_le64(0);
> >> should always set resync_offset to 0. I saw that "in_sync" basically
> >> tells whether there are pending/in-flight writes.
> >
> > If recovery_cp !=3D MaxSector, then the array is not considered to be '=
clean'
> > so we don't want to mark it as 'clean'.
> > On a graceful shutdown we do get in_sync to 1 - in __md_stop_writes.
> > Maybe we could do it at other times if the array is idle - not sure.
>=20
> It looks like I am missing something. If 'in_sync'=3D=3D0, then
> resync_offset will always be 0 in the superblock. If 'in_sync'=3D=3D1,
> then recovery_cp will be in the superblock. But the code in
> md_check_recovery() only sets in_sync=3D1 if there is no recovery_cp. If
> there is a valid recovery_cp, then in_sync will not be set to 1 and
> the superblock will always contain 0. That's why I am wondering why we
> are checking recovery_cp here? To end up having a valid recovery_cp in
> the superblock...we need recovery_cp=3D=3DMaxSectors. Strange?

->resync_offset is only really meaningful and useful after a clean shutdown
of the array.  The clean-shutdown code path uses a different rule for=20
setting in_sync to 1.  In that case you do get a useful value written to
->resync_offset.


>=20
> Can you please answer two more questions?
>=20
> 1) When testing the sb->resync offset patch with the latest version of
> mdadm, some of my unit tests failed due to failure in "--add".
> Debugging with strace reveals following:
> write_bitmap1() calls awrite() with 4096b buffer that was allocated on
> the stack in this function, and is not aligned. However, the fd in use
> was opened with O_RDWR|O_EXCL|O_DIRECT. As a result, write() fails
> with errno=3D=3DEINVAL. This appears to be regression at least vs
> mdadm-3.1.5, in which aligned buffer was used.
> Portions of strace:
> open("/dev/sdj", O_RDWR|O_EXCL|O_DIRECT) =3D 4
> ...
> ioctl(4, BLKSSZGET, 0x7fffa70b98d4)     =3D 0
> write(4, "bitm\4\0\0\0G*8\34m\245\261\253\34\341\312\3\214S\203\247\200\0=
\0\0\0\0\0\0"...,
> 512) =3D -1 EINVAL (Invalid argument)
> The buffer pointer at this point is 0x7fffa70b9930 (clearly not aligned t=
o 512).
> Do you want me to perhaps prepare a patch, which simply __aligns__ the
> buffer on the stack?

Hmmm... I messed that up, didn't I?
I think I'd rather fix awrite so that it *always* does an aligned write.

I'll make a patch - thanks.

>=20
> 2) Why in md_check_recovery(), rebuilding a spare is preferrable over
> resyncing the parity by this code:
> 		} else if ((spares =3D remove_and_add_spares(mddev))) {
> 			clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
> 			clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
> 			clear_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
> 			set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
> 		} else if (mddev->recovery_cp < MaxSector) {
> 			set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
> 			clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
>=20
> This leads to situation, in which array "remembers" that it has to
> complete resync (in sb->resync_offset), but after the spare completes
> rebuilding, the bitmap is cleared, and subsequent resync starts and
> immediately completes. Was that decision to prefer rebuild over resync
> intentional?

Yes.

In most cases rebuilding the spare will bring the array back into sync anyw=
ay.

Also rebuilding a spare will do more to improve redundancy than a resync.

There might be room for improvement here for RAID6 - if the array is dirty
and degrade we should both resync and recover at the same time ... and it is
possible that we already do.  I'd need to look more closely at the code to =
be
sure.

Thanks,
NeilBrown


--Sig_/EbSxMVC=aEsy50k_3rGkVtq
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTzB2bznsnt1WYoG5AQJ40RAAkROkVZK1bh8MJDkyT8DUSW90uNBCVR1l
wqKRnaIzPEJg6exRGy++j5r/xQlZD63vwBU0HSpJAe/8sdXxxBGgmWJPCLPmgLMQ
mjb2iR/qVpje4mPLJ2JrQJYT/S9MzdXpV/eKHziJqWfXCEUsKJr4wvN41jGRrRUe
V/12szU8KqBlkjUksRz4xJIUvuEjMW0UhbuXKY4NQNOJ//+8kcitvGNzpDWUeDID
a31bwYACWbMHnhzAt+RrFhu70p9LV0TFpCYuhSYraconWO6xfBINQauW7h6biCKj
OT5Xo4Yp3zSVGAo/V+SUo81jdo+Yro9dBKGO9kgAPeXlvapI6t/CznM0N8SRp6G9
Dy/bxkryDDD2qNBji03R7d4HXD1gtYs0kN67DyVAk6dSwKk/1AwiHxAk7c2E6Dh7
wJx8u+VQpKvVCroKw8Y76KtwKskVg0S3IyO2T1s6k0oQJMT7D2jhW6sbcovMEXPW
n+Zh3mGE1f0JXDiGEHMFi5Bm4xYgR4nG+tRDQlSfQjvuswWnc2l4NjZPOC+IBaoJ
SVJfj4Zu7EaomPJmi7KDp/qzVNBBN8pmz7qS59I+Wp9OLEIGZeRA7M7gAf4c8W8t
NUrim05T+wUuA/JyIc6kxCSWiO3Yd+adVSk/pbdUs/bBYLVd9FZg2WZmTi9GNzQA
jKPcG21KGpE=
=+F53
-----END PGP SIGNATURE-----

--Sig_/EbSxMVC=aEsy50k_3rGkVtq--
