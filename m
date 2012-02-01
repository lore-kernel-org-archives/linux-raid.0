From: NeilBrown <neilb@suse.de>
Subject: Re: sb->resync_offset value after resync failure
Date: Thu, 2 Feb 2012 09:19:19 +1100
Message-ID: <20120202091919.1d6dce52@notabene.brown>
References: <CAGRgLy44uKSggEsrU4Fx7op7iVjoPPq-doMdYjxnSGDm6krf9A@mail.gmail.com>
	<20120126115132.75d9d8bd@notabene.brown>
	<CAGRgLy6DWGzWCYjTer2DGv5rpU_78_mPvubKAUv1FiQE40HcbA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/g_Xf/KRgJQE+KL03B3PfWYc"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy6DWGzWCYjTer2DGv5rpU_78_mPvubKAUv1FiQE40HcbA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/g_Xf/KRgJQE+KL03B3PfWYc
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 1 Feb 2012 22:56:56 +0200 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Hi Neil,
> based on your hints I dug some more into resync failure cases, and
> handling of sb->resync_offset and mddev->recovery_cp. Here are aome
> observations:
>=20
> The only cases, in which recovery_cp is set (except setting via sysfs,
> setting bitmap bits via sysfs etc.) are:
> # on array creation, recovery_cp is set to 0 (and bitmap is fully set)
> # recovery_cp becomes MaxSector only if MD_RECOVERY_SYNC (with/without
> REQUESTED) completes successfully. On raid6 this may happen when a
> singly-degraded array completes resync.
> # if resync does not complete successfully (MD_RECOVERY_INTR or
> crash), then recovery_cp remains valid (not MaxSector).
>=20
> # The only real influence that recovery_cp seems to have is:
> 1) abort the assembly if ok_start_degraded is not set
> 2) when loading the superblock, it looks like recovery_cp may cause
> the beginning of the bitmap not being loaded. I did not dig further
> into bitmap at this point.
> 3) resume the resync in md_check_recovery() if recovery_cp is valid.
>=20
> Are these observations valid?

Looks about right.  'recovery_cp' reflects the 'dirty' flag in the superblo=
ck.
'0' means the whole array is dirty.
'MaxSectors' means none of the array is dirty.
other numbers mean that part of the array is dirty, part isn't.

(I should really rename it is 'resync_cp' - 'cp' for 'checkpoint' of course=
).


>=20
> With this scheme I saw several interesting issues:
> # After resync is aborted/interrupted, recovery_cp is updated (either
> to MaxSector or another value). However, the superblock is not updated
> at this point. If there is no additional activity on the array, the
> superblock will not be updated. I saw cases when resync completes
> fine, recovery_cp is set to MaxSector, but not persisted in the
> superblock. If I crash the machine at this point, then after reboot,
> array is still considered as dirty (has valid resync_offset in
> superblock). Is there an option to force the superblock update at this
> point?

My we just need to move the 'skip:' label to before:

	set_bit(MD_CHANGE_DEVS, &mddev->flags);

it is that flag which causes the superblock to be updated.

>=20
> # When resync aborts due to drive failure, then MD_RECOVERY_INTR is
> set, and sync_request() returns mddev->dev_sectors - sector_nr. As a
> result, recovery_cp is set to device size, and that's what I see in my
> raid6 scenario. At this point three things can happen:
> 1) If there is additional drive to resync (like in raid6), then resync
> restarts (from sector 0)

It should really just keep resyncing from where it is up to, shouldn't it?

> 2) If there is a spare, it starts rebuilding the spare, and, as a
> result, persists sb->resync_offset=3D=3Dsb->size in the superblock

Hmm.. that's wrong too.  It make some sense for RAID5 as if there is a spare
recovering we must assume the rest of the array is in-sync.  But not for
RAID6.

> 3) Otherwise, it restarts the resync (due to valid recovery_cp),
> immediately finishes it, and sets recovery_cp=3DMaxSector (but not
> necessarily writes the superblock right away).

This bit seems right - assuming you are referring to the 'raid5, no spare'
case.

> So basically, we can have a rebuilding drive and
> sb->resync_offset=3D=3Dsb->size in the superblock. It will be cleared only
> after rebuild completes and this "empty-resync" happens.
> Are you (we?) comfortable with this behavior? (Due to mdadm issue I
> mentioned earlier, in this case mdadm thinks that array is clean,
> while kernel thinks the array is dirty, while it's actually
> rebuilding).

No, not really.  There do seem to be some bugs there.

>=20
> Now I will answer to your suggestions:
>=20
> >> So one question is: should mdadm compare sb->resync_offset to
> >> MaxSector and not to sb->size? In the kernel code, resync_offset is
> >> always compared to MaxSector.
> >
> > Yes, mdadm should be consistent with the kernel. =C2=A0Patches welcome.
>=20
> I think at this point it's better to consider the array as dirty in
> mdadm, and either let the kernel set MaxSectors in this "empty-resync"
> or set it via mdadm+force. Let's see if I can submit this trivial
> patch.

Sounds reasonable.

>=20
> >> Another question is: whether sb->resync_offset should be set to
> >> MaxSector by the kernel as soon as it starts rebuilding a drive? I
> >> think this would be consistent with what Neil wrote in the blog entry.
> >
> > Maybe every time we update ->curr_resync_completed we should update
> > ->recovery_cp as well if it is below the new ->curre_resync_completed ??
>=20
> I'm not sure it will help a lot. Except for not loading part of the
> bitmap (which I am unsure about), the real value if recovery_cp does
> not really matter. Is this correct?

It is stored in the metadata so if you stop the array in the middle of a
resync, then start the array again, the resync starts from wherever it was =
up
to.  So having a correct value certainly is useful.
(Having a value that is less than the correct value is no a big problem,
have a value that is too big would be bad).

>=20
> >
> >
> >>
> >> Here is the scenario to reproduce the issue I described:
> >> # Create a raid6 array with 4 drives A,B,C,D. Array starts resyncing.
> >> # Fail drive D. Array aborts the resync and then immediately restarts
> >> it (it seems to checkpoint the mddev->recovery_cp, but I am not sure
> >> that it restarts from that checkpoint)
> >> # Re-add drive D to the array. It is added as a spare, array continues=
 resyncing
> >> # Fail drive C. Array aborts the resync, and then starts rebuilding
> >> drive D. At this point sb->resync_offset is some valid value (usually
> >> 0, not MaxSectors and not sb->size).
> >
> > Does it start the rebuilding from the start? =C2=A0I hope it does.
>=20
> Yes, it starts from j=3D=3D0 (and then it goes according to bitmap I guess
> and hope).
>=20
> >
> >> # Stop the array. At this point sb->resync offset is sb->size in all
> >> the superblocks.
> >
> > At some point in there you had a RAID6 with two missing devices, so it =
is
> > either failed or completely in-sync. =C2=A0I guess we assume the latter.
> > Is that wrong?
>=20
> It's not that it's wrong, but if we assume the array is clean, then
> resync_offset should be MaxSectors in the superblock. But it's not, as
> I showed earlier.

Fair enough - it would be better if it were MaxSectors in this case.

>=20
> About exposing ok_start_degraded via sysfs: Is it possible to push
> this value through RUN_ARRAY ioctl? I saw that it can carry
> mdu_param_t, which has max_fault/*unused for now*/ field? Perhaps this
> filed can be used?

I'm not keen on adding more functionality on to the ioctls.
I'd much rather see something via sysfs... Not sure what is best though, I'd
have to have a good think about it.

>=20
> I have another question about md_check_recovery() this code:
> 			if (mddev->safemode &&
> 			    !atomic_read(&mddev->writes_pending) &&
> 			    !mddev->in_sync &&
> 			    mddev->recovery_cp =3D=3D MaxSector) {
> 				mddev->in_sync =3D 1;
> Why mddev->recovery_cp =3D=3D MaxSector is checked here?  This basically
> means that if we have a valid recovery_cp, then in_sync will never be
> set to 1, and this code:
> 	if (mddev->in_sync)
> 		sb->resync_offset =3D cpu_to_le64(mddev->recovery_cp);
> 	else
> 		sb->resync_offset =3D cpu_to_le64(0);
> should always set resync_offset to 0. I saw that "in_sync" basically
> tells whether there are pending/in-flight writes.

If recovery_cp !=3D MaxSector, then the array is not considered to be 'clea=
n'
so we don't want to mark it as 'clean'.
On a graceful shutdown we do get in_sync to 1 - in __md_stop_writes.
Maybe we could do it at other times if the array is idle - not sure.


>=20
> Finally, what would you recommend to do if a raid5 resync fails? At
> this point kernel doesn't fail the array (as you pointed in your
> blog), but it machine reboots, array cannot be re-assembled without
> "force", because it's dirty+has a failed drive. So it's kind
> of...inconsistent?

I don't have a good answer.  The logical thing to do is to cause the
whole array to fail - but I think that would be unpopular.

I'm happy to listen to well-reasoned suggestions, but I don't have any good
suggestion other than the current situation.

Thanks,

NeilBrown



>=20
> Thanks for your help,
>   Alex.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/g_Xf/KRgJQE+KL03B3PfWYc
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTym6Zznsnt1WYoG5AQILLQ/+L3M3ZrUzo2mUrofBpz8ewdwmHOgUYwnh
2gRvnHi30rCyL+pCdt2/U8UQnvhckBm9drnfilixne8Dl8QbjF6wjWEAmofWac/U
BonbTiegY9E/qQQRTf0zp+PCNBmae5q67NXZJ033p0WjH/vY60wSQVhZJvfEM6vE
C6DDJaRLO0LELMwJQHlogYOjA5jixeDKDh7zC9YBgdO9yLBAg+D4cm3U9G1thzK+
lk02DaynJkbmCbLWstjDt2Ikkrisae6JsxOIhnrNLrhShwzNk5Xbd0UvBA1VRkUV
YiRqPFpMFNUUXFHg3swiGm8b/3gLexQo6kdpiXzvE3//zmIWdMPVB8aTwJ8CgbbM
8zJxmRj1P5ANSUR8EakNU0XPeNX5nGakKZHw1wzqHONkXUcdztJei0WLMq1e7lMo
BU+k2hJvxPG6dcxrIjFhao8pJvhEBsM9IUn4Xvi0DyQkImBlr6I6thU48HF5Nhc7
zUfJe1GArwgIL8f8/LBTcyglNJ7fE5WTrVEc026qLkZtEvmFPYEsRpkRm5vtTIx0
UWRnh7D6w8FOhCRsDis29iwbALO2i7+Zgzu7th1R91VPIzRAj+cNN5JcEQ5MvDuf
cf5FKp5RgFSC6OHB0VwghyuU5uMX6kziPDY4Se7dZTKJlNcbv1/pZCDzQ/Ek+vNf
Hmhhbmp+ThI=
=fxdr
-----END PGP SIGNATURE-----

--Sig_/g_Xf/KRgJQE+KL03B3PfWYc--
