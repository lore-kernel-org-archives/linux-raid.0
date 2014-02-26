From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: Problem with patch: "reject a re-add request that cannot be
 honoured" (commit bedd86b7773fd97f0d708cc0c371c8963ba7ba9a)
Date: Wed, 26 Feb 2014 15:02:27 +0200
Message-ID: <CAGRgLy6pzRCPjCFT7Pots0QqSC_T_PRqN19-quCxxLoPDjqbfQ@mail.gmail.com>
References: <CAGRgLy6We49bW2gA7S-EOmA8sbaXgQeGuTR5Aqrt4y_KyvOrdw@mail.gmail.com>
	<CAGRgLy5OkpZnfOpPS+16Tiep8eisOu9XnK7EcvZygwg22DVTqQ@mail.gmail.com>
	<20120607212434.4d6211d6@notabene.brown>
	<CAGRgLy55si7a8bY_Xuokqb6=cdOJyk_Wq34_DwmmhbpuQSSQug@mail.gmail.com>
	<20120627172255.40ee3a19@notabene.brown>
	<CAGRgLy5iDmGqi4kFGuJGVjw++cbLBVGK6VgA=znDGiZVTJfYGg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy5iDmGqi4kFGuJGVjw++cbLBVGK6VgA=znDGiZVTJfYGg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>
Cc: Andrei Warkentin <andrey.warkentin@gmail.com>, Yair Hershko <yair@zadarastorage.com>
List-Id: linux-raid.ids

HI Neil,
can you please comment what do you think of this change.

Thanks,
Alex.

On Wed, Feb 19, 2014 at 11:51 AM, Alexander Lyakas
<alex.bolshoy@gmail.com> wrote:
> Hello Neil, Andrei,
> I don't how much you recall of this old discussion.
>
> Basically, the change that you made means that md doesn't update the
> superblock on the recovering device, until recovery completes. As a
> result, when assembling such array, the recovering device has an old
> event count in the superblock and is not picked during assembly. So
> later, user has to re-add it manually.
> This is true for a device that failed and was re-added. For a fresh
> device, saved_raid_disk==-1, so its superblock will still be updated
> (and sucn device will be picked on assembly).
>
> On the other hand, MD updates the superblock of the In_sync devices
> and marks the recovering device as having a valid array slot (not
> 0xFFFF or 0xFFFE, which are treated similarly today).
>
> What do you think of the following change:
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 561a65f..4bbc7e3 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1854,8 +1854,6 @@ retry:
>                         sb->dev_roles[i] = cpu_to_le16(0xfffe);
>                 else if (test_bit(In_sync, &rdev2->flags))
>                         sb->dev_roles[i] = cpu_to_le16(rdev2->raid_disk);
> -               else if (rdev2->raid_disk >= 0)
> -                       sb->dev_roles[i] = cpu_to_le16(rdev2->raid_disk);
>                 else
>                         sb->dev_roles[i] = cpu_to_le16(0xffff);
>         }
>
> Basically, we do not mark the slot of the recovering device, until its
> recovery completes. So during assembly, we will not pick it, as
> before. For a fresh drive, there will be a regression - we will not
> pick it as well on assembly.
>
> The reason I am considering this change is another old discussion that
> we had - considering split-brain resolution, and the proposal I made
> in:
> https://docs.google.com/document/d/1sgO7NgvIFBDccoI3oXp9FNzB6RA5yMwqVN3_-LMSDNE
>
> Basically, when MD marks recovering devices as having a valid raid
> slot in the superblock of In_sync devices, then on array assembly we
> don't know whether sucn device is recovering or In_sync (if it is
> inaccessible during assembly). So we have to assume it is In_sync and
> thus can potentially cause split-brain.
>
>
> What do you think of this change?
>
> Thanks,
> Alex.
>
>
> On Wed, Jun 27, 2012 at 9:22 AM, NeilBrown <neilb@suse.de> wrote:
>> On Thu, 7 Jun 2012 15:47:46 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
>> wrote:
>>
>>> Thanks for commenting, Neil,
>>>
>>> On Thu, Jun 7, 2012 at 2:24 PM, NeilBrown <neilb@suse.de> wrote:
>>> > On Thu, 7 Jun 2012 10:22:24 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
>>> > wrote:
>>> >
>>> >> Hi again Neil, and Andrey,
>>> >>
>>> >> looking at this email thread:
>>> >> http://www.spinics.net/lists/raid/msg36236.html
>>> >> between you and Andrey, the conclusion was:
>>> >> "So the correct thing to do is to *not* update the metadata on the
>>> >> recovering device until recovery completes.  Then if it fails and is
>>> >> re-added, it will look just the same as when it was re-added the first
>>> >> time, and will do a bitmap-based recovery."
>>> >>
>>> >> I have two doubts about this decision:
>>> >> 1) Since the event count on the recovering drive is not updated, this
>>> >> means that after reboot, when array is re-assembled, this drive will
>>> >> not be added to the array, and the user will have to manually re-add
>>> >> it. I agree this is a minor thing.
>>> >
>>> > Still, if it can be fixed it should be.
>>> >
>>> >> 2) There are places in mdadm, which check for recovery_offset on the
>>> >> drive and take decisions based upon that. Specifically, if there is
>>> >> *no* recovery offset, the data on this drive is considered to be
>>> >> consistent WRT to the failure time of the drive. So, for example, the
>>> >> drive can be a candidate for bumping up events during "force
>>> >> assembly". Now, when superblock on such drive is not updated during
>>> >> recovery (so there is *no* recovery offset), mdadm will think that the
>>> >> drive is consistent, while in fact, its data is totally unusable until
>>> >> after recovery completes. That's because we have updated parts of the
>>> >> drive, but did not complete bringing the whole drive in-sync.
>>> >
>>> > If mdadm would consider updating the event count if not recovery had started,
>>> > then surely it is just as valid to do so once some recovery has started, even
>>> > if it hasn't completed.
>>>
>>> The patch you accepted from me ("Don't consider disks with a valid
>>> recovery offset as candidates for bumping up event count") actually
>>> attempts to protect from that:)
>>>
>>> I don't understand why "it is just as valid to do so once some
>>> recovery has started". My understanding is that once recovery of a
>>> drive has started, its data is not consistent between different parts
>>> of the drive, until the recovery completes. This is because md does
>>> bitmap-based recovery, and not kind of journal/transaction-log based
>>> recovery.
>>>
>>> However, one could argue that for force-assembly case, when data
>>> anyways can come up as partially corrupted, this is less important.
>>
>> Exactly.  And mdadm only updates event counts in the force-assembly case so
>> while it might not be ideal, it is the best we can do.
>>
>>>
>>> I would still think that there is value in recoding in a superblock
>>> that a drive is recovering.
>>
>> Probably.  It is a bit unfortunate that if you stop an array that is
>> recovering after a --re-add, you cannot simply 'assemble' it again and
>> get it back to the same state.
>> I'll think more on that.
>>
>> Meanwhile, this patch might address your other problem.  It allows --re-add
>> to work if a non-bitmap rebuild fails and is then re-added.
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index c601c4b..d31852e 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -5784,7 +5784,7 @@ static int add_new_disk(struct mddev * mddev, mdu_disk_info_t *info)
>>                         super_types[mddev->major_version].
>>                                 validate_super(mddev, rdev);
>>                 if ((info->state & (1<<MD_DISK_SYNC)) &&
>> -                   (!test_bit(In_sync, &rdev->flags) ||
>> +                   (test_bit(Faulty, &rdev->flags) ||
>>                      rdev->raid_disk != info->raid_disk)) {
>>                         /* This was a hot-add request, but events doesn't
>>                          * match, so reject it.
>>
>>
>>>
>>> >
>>> >>
>>> >> Can you pls comment on my doubts?
>>> >
>>> > I think there is probably room for improvement here but I don't think there
>>> > are any serious problems.
>>> >
>>> > However I'm about to go on leave for a couple of week so I'm unlikely to
>>> > think about it for a while. I've made a note to look at it properly when I
>>> > get back.
>>> >
>>>
>>> Indeed, don't you think about this while you are resting!
>>
>> :-)
>>
>>
>> Thanks.  I did have a very enjoyable break.
>>
>> NeilBrown
