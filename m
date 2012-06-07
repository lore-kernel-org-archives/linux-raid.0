From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: Problem with patch: "reject a re-add request that cannot be
 honoured" (commit bedd86b7773fd97f0d708cc0c371c8963ba7ba9a)
Date: Thu, 7 Jun 2012 15:47:46 +0300
Message-ID: <CAGRgLy55si7a8bY_Xuokqb6=cdOJyk_Wq34_DwmmhbpuQSSQug@mail.gmail.com>
References: <CAGRgLy6We49bW2gA7S-EOmA8sbaXgQeGuTR5Aqrt4y_KyvOrdw@mail.gmail.com>
	<CAGRgLy5OkpZnfOpPS+16Tiep8eisOu9XnK7EcvZygwg22DVTqQ@mail.gmail.com>
	<20120607212434.4d6211d6@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120607212434.4d6211d6@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: andrey.warkentin@gmail.com, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thanks for commenting, Neil,

On Thu, Jun 7, 2012 at 2:24 PM, NeilBrown <neilb@suse.de> wrote:
> On Thu, 7 Jun 2012 10:22:24 +0300 Alexander Lyakas <alex.bolshoy@gmai=
l.com>
> wrote:
>
>> Hi again Neil, and Andrey,
>>
>> looking at this email thread:
>> http://www.spinics.net/lists/raid/msg36236.html
>> between you and Andrey, the conclusion was:
>> "So the correct thing to do is to *not* update the metadata on the
>> recovering device until recovery completes. =A0Then if it fails and =
is
>> re-added, it will look just the same as when it was re-added the fir=
st
>> time, and will do a bitmap-based recovery."
>>
>> I have two doubts about this decision:
>> 1) Since the event count on the recovering drive is not updated, thi=
s
>> means that after reboot, when array is re-assembled, this drive will
>> not be added to the array, and the user will have to manually re-add
>> it. I agree this is a minor thing.
>
> Still, if it can be fixed it should be.
>
>> 2) There are places in mdadm, which check for recovery_offset on the
>> drive and take decisions based upon that. Specifically, if there is
>> *no* recovery offset, the data on this drive is considered to be
>> consistent WRT to the failure time of the drive. So, for example, th=
e
>> drive can be a candidate for bumping up events during "force
>> assembly". Now, when superblock on such drive is not updated during
>> recovery (so there is *no* recovery offset), mdadm will think that t=
he
>> drive is consistent, while in fact, its data is totally unusable unt=
il
>> after recovery completes. That's because we have updated parts of th=
e
>> drive, but did not complete bringing the whole drive in-sync.
>
> If mdadm would consider updating the event count if not recovery had =
started,
> then surely it is just as valid to do so once some recovery has start=
ed, even
> if it hasn't completed.

The patch you accepted from me ("Don't consider disks with a valid
recovery offset as candidates for bumping up event count") actually
attempts to protect from that:)

I don't understand why "it is just as valid to do so once some
recovery has started". My understanding is that once recovery of a
drive has started, its data is not consistent between different parts
of the drive, until the recovery completes. This is because md does
bitmap-based recovery, and not kind of journal/transaction-log based
recovery.

However, one could argue that for force-assembly case, when data
anyways can come up as partially corrupted, this is less important.

I would still think that there is value in recoding in a superblock
that a drive is recovering.

>
>>
>> Can you pls comment on my doubts?
>
> I think there is probably room for improvement here but I don't think=
 there
> are any serious problems.
>
> However I'm about to go on leave for a couple of week so I'm unlikely=
 to
> think about it for a while. I've made a note to look at it properly w=
hen I
> get back.
>

Indeed, don't you think about this while you are resting!

Alex.


>
>>
>> Thanks,
>> Alex.
>>
>>
>> On Wed, Jun 6, 2012 at 7:09 PM, Alexander Lyakas <alex.bolshoy@gmail=
=2Ecom> wrote:
>> > Hi Neil,
>> > it looks like we are hitting an issue with this patch.
>> > Kernel is stock ubuntu-precise (3.2.0-23 36), mdadm is v3.2.3. (We=
 are
>> > aware that this version of mdadm has an issue of unaligned writes,=
 so
>> > we backported the fix to it into this version).
>> >
>> > We are testing the following simple scenario:
>> > # 2-way raid1 with a missing drive
>> > # a fresh drive (no superblock) is added (not re-added) to the rai=
d,
>> > and the raid happily starts rebuilding it
>> > # at some point in time, this drive fails, so rebuild aborts, driv=
e is
>> > kicked out.
>> > # later the drive recovers and "mdadm remove & re-add" is attempte=
d
>> > # re-add fails
>> >
>> > Some debugging suggests the following:
>> >
>> > - The superblock of the drive to be re-added looks like this:
>> >
>> > =A0Avail Dev Size : 10483712 (5.00 GiB 5.37 GB)
>> > =A0 =A0 Array Size : 10483688 (5.00 GiB 5.37 GB)
>> > =A0Used Dev Size : 10483688 (5.00 GiB 5.37 GB)
>> > =A0 =A0Data Offset : 2048 sectors
>> > =A0 Super Offset : 8 sectors
>> > Recovery Offset : 100096 sectors
>> > =A0 =A0 =A0 =A0 =A0State : clean
>> > =A0Resync Offset : N/A sectors
>> > =A0 =A0Device UUID : d9114d02:76153894:87aaf09d:c55da9be
>> > Internal Bitmap : 8 sectors from superblock
>> > =A0 =A0Update Time : Wed Jun =A06 18:36:55 2012
>> > =A0 =A0 =A0 Checksum : 94468c9d - correct
>> > =A0 =A0 =A0 =A0 Events : 192
>> > =A0 Device Role : Active device 1
>> > =A0 Array State : AA ('A' =3D=3D active, '.' =3D=3D missing)
>> >
>> >
>> > So the drive has a valid recovery offset (MD_FEATURE_RECOVERY_OFFS=
ET
>> > set) and a valid role.
>> >
>> > - The "re-add" path of mdadm performs calls getinfo_super1(), whic=
h performs:
>> > role =3D __le16_to_cpu(sb->dev_roles[__le32_to_cpu(sb->dev_number)=
]);
>> > ...
>> > info->disk.state =3D 6; /* active and in sync */
>> > info->disk.raid_disk =3D role;
>> >
>> > So at this point, MD_DISK_ACTIVE and MD_DISK_SYNC are set.
>> >
>> > - mdadm issues ADD_NEW_DISK, which arrives to add_new_disk() in th=
e kernel
>> > - the kernel performs:
>> > if (!mddev->persistent) {
>> > ... // not relevant to our case
>> > } else
>> > =A0 =A0 =A0 =A0super_types[mddev->major_version].
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0validate_super(mddev, rdev);
>> >
>> > - validate_super() performs:
>> > =A0 =A0 =A0 =A0if ((le32_to_cpu(sb->feature_map) &
>> > =A0 =A0 =A0 =A0 =A0 =A0 MD_FEATURE_RECOVERY_OFFSET))
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rdev->recovery_offset =3D le64_to_c=
pu(sb->recovery_offset);
>> > =A0 =A0 =A0 =A0else
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0set_bit(In_sync, &rdev->flags);
>> > =A0 =A0 =A0 =A0rdev->raid_disk =3D role;
>> >
>> > So In_sync flag is not set, because we have a recovery offset.
>> >
>> > - Then the code introduced by the patch does:
>> > =A0 =A0 =A0 =A0if ((info->state & (1<<MD_DISK_SYNC)) &&
>> > =A0 =A0 =A0 =A0 =A0 =A0(!test_bit(In_sync, &rdev->flags) ||
>> > =A0 =A0 =A0 =A0 =A0 =A0 rdev->raid_disk !=3D info->raid_disk)) {
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* This was a hot-add request, but =
events doesn't
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * match, so reject it.
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0export_rdev(rdev);
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EINVAL;
>> > =A0 =A0 =A0 =A0}
>> >
>> > So the first part of "OR" succeeds and we abort.
>> >
>> > An observation: this problem only happens with a fresh drive
>> > apparently. If drive that was already In_sync fails and then is
>> > re-added, kernel does not update its superblock until recovery
>> > completes. So its superblock has no valid recovery_offset, and thi=
s
>> > problem doesn't happen. The code that skips updating the superbloc=
k
>> > was added as part of this email thread:
>> > http://www.spinics.net/lists/raid/msg36275.html. However, I did no=
t
>> > dig deeper why the superblock gets updated in my case. But the
>> > scenario above repros easily.
>> >
>> > Q1: Can you confirm that my analysis is correct?
>> > Q2: Is this an expected behavior? I would assume that no, because =
the
>> > same case for a failed drive (not a fresh drive) works fine
>> > Q3: How would you recommend to handle this?
>> >
>> > Thanks!
>> > Alex.
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
