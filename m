From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: Question about mdadm commit d6508f0cfb60edf07b36f1532eae4d9cddf7178b
 "be more careful about add attempts"
Date: Tue, 8 Nov 2011 18:23:49 +0200
Message-ID: <CAGRgLy5WaOAg2R0FW1=cPgn+sK+PA_=T=GrLj+KWb5HVxbndzQ@mail.gmail.com>
References: <CAGRgLy6Q9Qq8TeykEseXX45goi4kS8wOwrUOo1+tNZyxdyFHkw@mail.gmail.com>
	<20111027085125.747691a9@notabene.brown>
	<CAGRgLy7biNy4Tj9wXhBosjC4QNy7dXC2aoimu7ezGqdL82Axxg@mail.gmail.com>
	<20111031101649.657a1ab3@notabene.brown>
	<CAGRgLy7G_M=FtdZ9mmDvxxN52+AF+L=0+OaEP=dK7Z+Z5YBYKw@mail.gmail.com>
	<20111031201933.314d130f@notabene.brown>
	<CAGRgLy5zkfy2bfrJnC_eKQ_-VAcdaKCyeSounjZ3FjBb83T0mQ@mail.gmail.com>
	<20111102095204.024dc6b2@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111102095204.024dc6b2@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

1)
after looking at this more I see the following: on ADD_NEW_DISK
sequence (to a running array, not during assembly) in the kernel, the
desc_nr is loaded from the superblock of the disk to be added in
super_1_load():
	if (sb->level =3D=3D cpu_to_le32(LEVEL_MULTIPATH))
		rdev->desc_nr =3D -1;
	else
		rdev->desc_nr =3D le32_to_cpu(sb->dev_number);
And later, in bind_rdev_to_array() it is indeed checked that desc_nr is=
 unique.

However, at least for 1.2 arrays, I believe this is too restrictive,
don't you think? If the raid slot (not desc_nr) of the device being
re-added is *not occupied* yet, can't we just select a free desc_nr
for the new disk on that path?
Or perhaps, mdadm on the re-add path can select a free desc_nr
(disc.number) for it (just as it does for --add), after ensuring that
the slot is not occupied yet? Where it is better to do it?
Otherwise, the re-add fails, while it can perfectly succeed (only pick
a different desc_nr).

2)
About your suggestion of setting the In_sync flag via sysfs, I think
it's too dangerous to blindly set it, so I am not going to do it. Let
the kernel look at event count and decide.

3)
So it looks like at present, my best way to add (not re-add) a disk
into a specific slot is the following:
- borrow some code from mdadm to initialize the superblock of the new
disk, as belonging to this array (init_super).
- use the sysfs to do what you suggested before:
echo frozen > sync_action
echo $major:$minor > new_dev
echo $slot > dev-$DEVNAME/slot
echo idle > sync_action

Does this makes sense?

Thanks!

Alex.




On Wed, Nov 2, 2011 at 12:52 AM, NeilBrown <neilb@suse.de> wrote:
> On Tue, 1 Nov 2011 18:26:14 +0200 Alexander Lyakas <alex.bolshoy@gmai=
l.com>
> wrote:
>
>> Hi Neil,
>> I hope you don't find my questions too pesky; I hope as time goes, I
>> will be able to contribute as well, and not just ask for information=
=2E
>
> Enquiring minds should always be encouraged!
>
>>
>> What you suggested works great, but only if the drive already has a
>> valid superblock. This is according to md_import_device(), which cal=
ls
>> super_1_load(). Although it calls it with NULL refdev, but it still
>> performs basic validity checks of the superblock. So it is needed to
>> have functionality of write_init_super() of mdadm (perhaps can be an
>> mdadm operation, not sure how dangerous this is to expose such
>> functionality).
>
> Correct. =A0With v1.x metadata - and even more so with DDF and IMSM -=
 the
> kernel does not know everything about the metadata and cannot create =
new
> superlocks. =A0At best it can edit what is there.
>
> As for adding things to mdadm - =A0you just need a genuine use-case.
> I can see it could be valid to add a '--role' option to --add so you =
can add
> a device to a specific slot. =A0I doubt it would be used much, but if=
 there was
> a concrete need I wouldn't object.
>
>
>>
>> Another question I was digging for, is to find a spot where kernel
>> determines whether it is going to do a bitmap-based reconstruction o=
r
>> a full reconstruction. Can you verify that I found it correctly, or =
I
>> am way off?
>>
>> In super_1_validate():
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ev1 < mddev->bitmap->events_cleared)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> This means that the array bitmap was cleared after the drive was
>> detached, so we bail right out, and do not set rdev->raid_disk, and
>> leave all flags off. In that case, eventually, we will need full
>> reconstruction.
>> Otherwise, after we decide that this drive is an active device (not
>> failed or spare):
>> if ((le32_to_cpu(sb->feature_map) & =A0MD_FEATURE_RECOVERY_OFFSET))
>> =A0 =A0 rdev->recovery_offset =3D le64_to_cpu(sb->recovery_offset);
>> else
>> =A0 =A0 set_bit(In_sync, &rdev->flags);
>> Here we might or might not set the In_sync flag.
>>
>
> Yes. 'In_sync' effectively means that recovery_offset =3D=3D MAX.
>
>
>> Then in slot_store() and in add_new_disk(), we set the important fla=
g
>> for that matter:
>> if (test_bit(In_sync, &rdev->flags))
>> =A0 =A0 rdev->saved_raid_disk =3D slot;
>> else
>> =A0 =A0 rdev->saved_raid_disk =3D -1;
>>
>> And later, in hot_add_disk (like raid5_add_disk, raid1_add_disk), we
>> check this flag and set/not set the fullsync flag. And in
>> raid1_add_disk, like you said, the slot doesn't matter, any valid
>> saved_raid_disk is good.
>>
>> Is this correct? If yes, then in the sequence you suggested, we will
>> always do full reconstruction. Because new_dev_store() and
>> slot_store() sequence do not call validate_super(), so In_sync is
>> never set, so saved_raid_disk remains -1. This is perfectly fine.
>
> Yes, this is all correct.
> In the sequence I suggested you could add
> =A0 echo insync > dev-$DEVNAME/state
> before
> =A0 echo $slot > dev-$DEVNAME/slot
>
> and it would result in saved_raid_disk being set.
>
> NeilBrown
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
