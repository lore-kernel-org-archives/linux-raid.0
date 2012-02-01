From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: sb->resync_offset value after resync failure
Date: Wed, 1 Feb 2012 22:56:56 +0200
Message-ID: <CAGRgLy6DWGzWCYjTer2DGv5rpU_78_mPvubKAUv1FiQE40HcbA@mail.gmail.com>
References: <CAGRgLy44uKSggEsrU4Fx7op7iVjoPPq-doMdYjxnSGDm6krf9A@mail.gmail.com>
	<20120126115132.75d9d8bd@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120126115132.75d9d8bd@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Neil,
based on your hints I dug some more into resync failure cases, and
handling of sb->resync_offset and mddev->recovery_cp. Here are aome
observations:

The only cases, in which recovery_cp is set (except setting via sysfs,
setting bitmap bits via sysfs etc.) are:
# on array creation, recovery_cp is set to 0 (and bitmap is fully set)
# recovery_cp becomes MaxSector only if MD_RECOVERY_SYNC (with/without
REQUESTED) completes successfully. On raid6 this may happen when a
singly-degraded array completes resync.
# if resync does not complete successfully (MD_RECOVERY_INTR or
crash), then recovery_cp remains valid (not MaxSector).

# The only real influence that recovery_cp seems to have is:
1) abort the assembly if ok_start_degraded is not set
2) when loading the superblock, it looks like recovery_cp may cause
the beginning of the bitmap not being loaded. I did not dig further
into bitmap at this point.
3) resume the resync in md_check_recovery() if recovery_cp is valid.

Are these observations valid?

With this scheme I saw several interesting issues:
# After resync is aborted/interrupted, recovery_cp is updated (either
to MaxSector or another value). However, the superblock is not updated
at this point. If there is no additional activity on the array, the
superblock will not be updated. I saw cases when resync completes
fine, recovery_cp is set to MaxSector, but not persisted in the
superblock. If I crash the machine at this point, then after reboot,
array is still considered as dirty (has valid resync_offset in
superblock). Is there an option to force the superblock update at this
point?

# When resync aborts due to drive failure, then MD_RECOVERY_INTR is
set, and sync_request() returns mddev->dev_sectors - sector_nr. As a
result, recovery_cp is set to device size, and that's what I see in my
raid6 scenario. At this point three things can happen:
1) If there is additional drive to resync (like in raid6), then resync
restarts (from sector 0)
2) If there is a spare, it starts rebuilding the spare, and, as a
result, persists sb->resync_offset=3D=3Dsb->size in the superblock
3) Otherwise, it restarts the resync (due to valid recovery_cp),
immediately finishes it, and sets recovery_cp=3DMaxSector (but not
necessarily writes the superblock right away).
So basically, we can have a rebuilding drive and
sb->resync_offset=3D=3Dsb->size in the superblock. It will be cleared o=
nly
after rebuild completes and this "empty-resync" happens.
Are you (we?) comfortable with this behavior? (Due to mdadm issue I
mentioned earlier, in this case mdadm thinks that array is clean,
while kernel thinks the array is dirty, while it's actually
rebuilding).

Now I will answer to your suggestions:

>> So one question is: should mdadm compare sb->resync_offset to
>> MaxSector and not to sb->size? In the kernel code, resync_offset is
>> always compared to MaxSector.
>
> Yes, mdadm should be consistent with the kernel. =A0Patches welcome.

I think at this point it's better to consider the array as dirty in
mdadm, and either let the kernel set MaxSectors in this "empty-resync"
or set it via mdadm+force. Let's see if I can submit this trivial
patch.

>> Another question is: whether sb->resync_offset should be set to
>> MaxSector by the kernel as soon as it starts rebuilding a drive? I
>> think this would be consistent with what Neil wrote in the blog entr=
y.
>
> Maybe every time we update ->curr_resync_completed we should update
> ->recovery_cp as well if it is below the new ->curre_resync_completed=
 ??

I'm not sure it will help a lot. Except for not loading part of the
bitmap (which I am unsure about), the real value if recovery_cp does
not really matter. Is this correct?

>
>
>>
>> Here is the scenario to reproduce the issue I described:
>> # Create a raid6 array with 4 drives A,B,C,D. Array starts resyncing=
=2E
>> # Fail drive D. Array aborts the resync and then immediately restart=
s
>> it (it seems to checkpoint the mddev->recovery_cp, but I am not sure
>> that it restarts from that checkpoint)
>> # Re-add drive D to the array. It is added as a spare, array continu=
es resyncing
>> # Fail drive C. Array aborts the resync, and then starts rebuilding
>> drive D. At this point sb->resync_offset is some valid value (usuall=
y
>> 0, not MaxSectors and not sb->size).
>
> Does it start the rebuilding from the start? =A0I hope it does.

Yes, it starts from j=3D=3D0 (and then it goes according to bitmap I gu=
ess
and hope).

>
>> # Stop the array. At this point sb->resync offset is sb->size in all
>> the superblocks.
>
> At some point in there you had a RAID6 with two missing devices, so i=
t is
> either failed or completely in-sync. =A0I guess we assume the latter.
> Is that wrong?

It's not that it's wrong, but if we assume the array is clean, then
resync_offset should be MaxSectors in the superblock. But it's not, as
I showed earlier.

About exposing ok_start_degraded via sysfs: Is it possible to push
this value through RUN_ARRAY ioctl? I saw that it can carry
mdu_param_t, which has max_fault/*unused for now*/ field? Perhaps this
filed can be used?

I have another question about md_check_recovery() this code:
			if (mddev->safemode &&
			    !atomic_read(&mddev->writes_pending) &&
			    !mddev->in_sync &&
			    mddev->recovery_cp =3D=3D MaxSector) {
				mddev->in_sync =3D 1;
Why mddev->recovery_cp =3D=3D MaxSector is checked here?  This basicall=
y
means that if we have a valid recovery_cp, then in_sync will never be
set to 1, and this code:
	if (mddev->in_sync)
		sb->resync_offset =3D cpu_to_le64(mddev->recovery_cp);
	else
		sb->resync_offset =3D cpu_to_le64(0);
should always set resync_offset to 0. I saw that "in_sync" basically
tells whether there are pending/in-flight writes.

=46inally, what would you recommend to do if a raid5 resync fails? At
this point kernel doesn't fail the array (as you pointed in your
blog), but it machine reboots, array cannot be re-assembled without
"force", because it's dirty+has a failed drive. So it's kind
of...inconsistent?

Thanks for your help,
  Alex.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
