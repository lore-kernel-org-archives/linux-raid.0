From: "Andrei E. Warkentin" <andrey.warkentin@gmail.com>
Subject: Re: 1.X metadata: Resuming an interrupted incremental recovery for RAID1.
Date: Wed, 12 Oct 2011 02:58:00 -0400
Message-ID: <CANz0V+5imRWcTyO5L2-=7Qu8nZ+TdSKxPZZ9xFQ2Q1YES3bOgA@mail.gmail.com>
References: <CANz0V+567wM8dfW0-3mQbWhJjNHf_j4qxH0Da9Agi9xYggAJmA@mail.gmail.com>
	<20111012140517.595f60f8@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111012140517.595f60f8@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

2011/10/11 NeilBrown <neilb@suse.de>:
>> 1) Add another SB feature - MD_FEATURE_IN_RECOVERY.
>> 2) MD_FEATURE_IN_RECOVERY is set in in super_1_sync if
>> rdev->saved_raid_disk !=3D -1 and mddev->bitmap.
>> 3) MD_FEATURE_IN_RECOVERY is unset in super_1_sync otherwise.
>> 4) If MD_FEATURE_IN_RECOVERY is for the 'default' case in
>> super_1_validate, set the In_Sync bit, causing an
>> =C2=A0 =C2=A0 incremental recovery to happen.
>
> We probably do need another flag somewhere, as we have two different =
states
> over-lapping.
> The first time you re-added a device, it's recovery_offset was MAX an=
d it's
> event_count was old, but not older than the bitmap.
> So we could do a bitmap-based recovery.
>
> When it was re-added we would have updated the metadata to have a new=
er event
> count, but a lower recovery_offset. =C2=A0So it is no longer clear fr=
om the
> metadata that a bitmap-based recovery is allowed.
> We could leave the old metadata, but then the bitmap-based resync wou=
ld
> restart from the beginning.
> You want the bitmap-based-resync to restart from recovery_offset whic=
h is a
> new state. =C2=A0So maybe we do need a new flag.
>

I think for the 99% case (i.e. a recovery actually started, and was
interrupted), we can get away
with just an additional feature flag. The other percent I'll describe
further below in detail.

>> The only case left is dealing with the 'spare' transition - in which
>> case I also need to remember rdev->saved_raid_disk someplace
>> in the superblock (and restore raid_disk and the In_Sync bit in
>> super_1_validate as well). =C2=A0If I understand correctly,
>> sb->resync_offset is a
>> safe place, since it's disregarded for a bitmapped rdev.
>
> You've lost me ... and I was coping so well too!
>
> What "spare transition". =C2=A0I cannot see a point in the process wh=
ere the
> metadata would get marked as being a spare...

In md.c:add_new_disk(), you have code like this -
                ...
                rdev->raid_disk =3D -1;   // <---- make me a spare
                err =3D bind_rdev_to_array(rdev, mddev);
                if (!err && !mddev->pers->hot_remove_disk) {
                        ...
                }
                if (err)
                        export_rdev(rdev);
                else
                        sysfs_notify_dirent_safe(rdev->sysfs_state);
                md_update_sb(mddev, 1);    // <----- now a spare
                ...

And I have verified (by injecting an -EIO after the first SB update,
with SystemTap), that after that md_update_sb,
the superblock metadata reflects the rdev being a spare.

I didn't trace it diligently enough, but I would guess that the
transition of the SB metadata to a 'role' (active, but recovering)
happens when md_check_recovery() calls remove_and_add_spares(), which
calls pers->hot_add_disk in the degraded path. Does that sound right?

If you have an I/O error due to the drive going away sometime during
the SB update *after* the path in add_new_disk (i.e. the the rdev is a
spare), then
re-adding will cause a full sync, because the logic will have no idea
that the drive belonged to the array before. Now, this is a pretty
unlikely occurrence (when compared to the chance of, say, a network
issue while actually recovering 2TB of data), but it can still happen.

The first thing that came to mind was persisting rdev->saved_raid_disk
in SB, and since I didn't want to add a new field, stuffing it inside
something that wasn't used in incremental recovery. I believe
sb->resync_offset has these properties. I think it would be better to
have a separate field for this, of course. I thought about having some
runtime flag (like In_Incremental or something), but the point is,
beyond raid1, raid5.c and raid10.c need the actual saved raid role to
decide if a full resync or incremental is used. I haven't tried, but I
would guess both raid5.c and raid10.c could be affected as well.

> <thinks....>
>
> I think that if a spare being bitmap-recovered fails and then gets re=
-added,
> then we have to start the bitmap-recovery from the beginning. =C2=A0i=
=2Ee. we cannot
> use the recovery_offset. =C2=A0This is because it is entirely possibl=
e that while
> the device was missing the second time, a write went to an address be=
fore
> recovery_offset and so there is a new bit, which the recovery has to =
handle.
>
> So the correct thing to do is to *not* update the metadata on the rec=
overing
> device until recovery completes. =C2=A0Then if it fails and is re-add=
ed, it will
> look just the same as when it was re-added the first time, and will d=
o a
> bitmap-based recovery.
> Only when the bitmap-based recovery finishes should the metadata be u=
pdated
> with a new event count, and then the bitmap can start forgetting thos=
e old
> bits.
>
> Credible?
> </thinks>

I think you are spot on. If MD_FEATURE_IN_RECOVERY is set in the SB,
the recovery_offset should be disregarded and recovery
should start at sector zero. In fact, I've verified that in the
*current case*, that full recovery that follows the interrupted
incremental actually starts at
recovery_offset, so it's broken right now.

I think the bitmap can surely forget the bits as the chunks are synced
across. After all, if the device is missing after the failed
incremental, new writes would be reflected in the write-intent bitmap,
and thus eventually make it across, no? (as long as recovery_offset is
0, of course)

Anyway, thanks for thinking about this. I hope I am not being too
loopy, I am almost positive I missed at least one of the million
corner cases here =3DP.

I'll submit the patch for the 99% case tomorrow (that just involves
setting and clearing the MD_FEATURE_IN_RECOVERY) for review.

A
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
