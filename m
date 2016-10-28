From: V <viswesh.vichu@gmail.com>
Subject: Re: Resync issue in RAID1
Date: Thu, 27 Oct 2016 23:07:08 -0700
Message-ID: <CAF9xHmTGFXvQnKX5ZK5+ino4977SpHxMffCc0YPMxJGEhwGLuw@mail.gmail.com>
References: <CAF9xHmRCKzBXE5_tdqNY9BJJn7LyC8bOv8OaFXpxc1BvGUTCeQ@mail.gmail.com>
 <8760odt93j.fsf@notabene.neil.brown.name> <CAF9xHmQfUDOYFNa1uehqsz=arx-x24DuavX1sdBY313mdt0GEw@mail.gmail.com>
 <87r371rp0d.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87r371rp0d.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Is there any reason, why this happens in the resync flow. Normally the
upper layer driver tries to align with device block size for the
request. So could there be an issue in this path ?

Thanks,
V

On Thu, Oct 27, 2016 at 11:01 PM, NeilBrown <neilb@suse.com> wrote:
> On Fri, Oct 28 2016, V wrote:
>
>> Hi Neil,
>>
>> Thanks for the response. But during this phase, why is the scsi driver
>> complaining about bad block number ?
>>
>> Oct 18 03:52:56  kernel: [  52.869378] sd 0:0:0:0: [sda] Bad block
>> number requested
>
> Because md is asking to read blocks are offsets which are not a multiple
> of 8 sectors.
>
> NeilBrown
>
>
>> Oct 18 03:52:56  kernel: [  52.869414] sd 0:0:0:0: [sda] Bad block
>> number requested
>> Oct 18 03:52:56  kernel: [  52.869436] sd 0:0:0:0: [sda] Bad block
>> number requested
>> Oct 18 03:52:56  kernel: [  52.869465] sd 0:0:0:0: [sda] Bad block
>> number requested
>> Oct 18 03:52:56  kernel: [  52.869503] sd 0:0:1:0: [sdb] Bad block
>> number requested
>>
>> Thanks,
>> V
>>
>> On Thu, Oct 27, 2016 at 9:01 PM, NeilBrown <neilb@suse.com> wrote:
>>> On Sat, Oct 22 2016, V wrote:
>>>
>>>> Hi,
>>>>
>>>> I am facing an issue during RAID1 resync. I have an ubuntu
>>>> 4.4.0-31-generic running with raid1 configured with 2 disks as active
>>>> and 2 as spares. On the first powercycle, after installing RAID, i see
>>>> the following messages in kern.log
>>>>
>>>>
>>>> My disks are configured with 4K sector size (both logical and
>>>> physical) (sda and sdb are active disks for this raid)
>>>>
>>>>
>>>> ===========
>>>> Oct 18 03:52:56  kernel: [   52.869113] md: using 128k window, over a
>>>> total of 51167104k.
>>>> Oct 18 03:52:56  kernel: [   52.869114] md: resuming resync of md2 from checkpoint.
>>>
>>> This line (above) combined with ...
>>>
>>>> Oct 18 03:52:56  kernel: [   52.869536] md/raid1:md2: sda: unrecoverable I/O read error for block 3
>>>
>>> this line suggests that when you shut down, md had already started a
>>> resync, and it had checkpointed at block '3'.
>>>
>>> The subsequent error are:
>>>
>>>> Oct 18 03:52:56  kernel: [   52.869692] md/raid1:md2: sda: unrecoverable I/O read error for block 131
>>>> Oct 18 03:52:56  kernel: [   52.869837] md/raid1:md2: sda: unrecoverable I/O read error for block 259
>>>> Oct 18 03:52:56  kernel: [   52.870022] md/raid1:md2: sda: unrecoverable I/O read error for block 387
>>>
>>> which are every 128 blocks (aka sectors) from '3'.
>>> I know what caused that.  The patch below will stop it happening again.
>>>
>>> You might be able get your array working again by stopping it
>>> and assembling with --update=resync.
>>> That will reset the checkpoint to 0.
>>>
>>> NeilBrown
>>>
>>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>>> index 2cf0e1c00b9a..aa2ca23463f4 100644
>>> --- a/drivers/md/md.c
>>> +++ b/drivers/md/md.c
>>> @@ -8099,7 +8099,8 @@ void md_do_sync(struct md_thread *thread)
>>>             mddev->curr_resync > 2) {
>>>                 if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
>>>                         if (test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
>>> -                               if (mddev->curr_resync >= mddev->recovery_cp) {
>>> +                               if (mddev->curr_resync >= mddev->recovery_cp &&
>>> +                                   mddev->curr_resync > 3) {
>>>                                         printk(KERN_INFO
>>>                                                "md: checkpointing %s of %s.\n",
>>>                                                desc, mdname(mddev));
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
