From: "David F." <df7729@gmail.com>
Subject: Re: MDADM 3.3 broken?
Date: Tue, 19 Nov 2013 16:35:44 -0800
Message-ID: <CAGRSmLs8AXqTG9Y0YU46vtpb2q08-2ApknBHVPF75FXPJu7C0Q@mail.gmail.com>
References: <CAGRSmLviYJtCfNiARKW0FvrJ0BUDrvhPnQy2drzbkf95-Gfpag@mail.gmail.com>
	<528A7721.8080604@arcor.de>
	<CAGRSmLvRVQtrkYPLS8NfRS+DvyS0xZ72cwVdLygb0w5KbVrARA@mail.gmail.com>
	<20131119110110.396b2af3@notabene.brown>
	<528BBFEB.7050202@arcor.de>
	<20131120105115.27494ab6@notabene.brown>
	<CAGRSmLsAALx=kJFiB6_b_yeb66qMZCa+4brg8Aejeaf031_JPg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRSmLsAALx=kJFiB6_b_yeb66qMZCa+4brg8Aejeaf031_JPg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Martin Wilck <mwilck@arcor.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

FWIW, we confirmed that it appears to be the old RAID1 data it was
finding - when the partition is below half the size it didn't find it
in the partition, when resized just beyond half the size (of the RAID0
md drive), it then started finding it in the partition.

Also, was Cisco's information useful for why their cisco server (using
lsi)  RAID5 won't assembly?  Do you think the patch deals with that as
well?

On Tue, Nov 19, 2013 at 4:22 PM, David F. <df7729@gmail.com> wrote:
> Okay, I'll have them build it and try.
>
> Another note on the last reason meta data may be in the partition -
> that system has the raid changed from 0 to 1 all the time so perhaps
> the old meta data at the end of drive 0 from RAID1 ends up in the
> middle of the partition when it's RAID0. ?
>
> On Tue, Nov 19, 2013 at 3:51 PM, NeilBrown <neilb@suse.de> wrote:
>> On Tue, 19 Nov 2013 20:45:47 +0100 Martin Wilck <mwilck@arcor.de> wrote:
>>
>>> On 11/19/2013 01:01 AM, NeilBrown wrote:
>>> > On Mon, 18 Nov 2013 15:13:58 -0800 "David F." <df7729@gmail.com> wrote:
>>> >
>>> >
>>> >> output of 'mdadm --assemble --scan --no-degraded -v' (mdadm 3.2.6):
>>> > ...
>>> >> mdadm: no RAID superblock on /dev/sdc2
>>> >
>>> >
>>> >
>>> >>
>>> >> output1 of 'mdadm --assemble --scan --no-degraded -v' (mdadm 3.3 -
>>> >> note using /dev/sdc2, not /dev/sdc):
>>> > .....
>>> >> mdadm: /dev/sdc2 is identified as a member of /dev/md/imsm0, slot -1.
>>> >
>>> > So there is the problem.  mdadm 3.2.6 sees no RAID superblock on sdc2, while
>>> > mdadm 3.3 does (but should not).
>>> >
>>> >
>>> > However that code hasn't changed!
>>> >
>>> > load_super_imsm() still starts with:
>>> >
>>> >
>>> >     if (test_partition(fd))
>>> >             /* IMSM not allowed on partitions */
>>> >             return 1;
>>>
>>> Well not quite - you changed that code in commit b31df436 "intel,ddf:
>>> don't require partitions when ignore_hw_compat is set". Maybe there's
>>> something wrong with that ignore_hw_compat logic?
>>>
>>> In the strace I don't see indication of test_partition having been
>>> called, that's another hint in that direction.
>>>
>>
>> Yes... I seems I was accidentally looking at an old version of mdadm.
>>
>> I've just committed the following patch which should fix the problem.
>>
>> (git clone git://neil.brown.name/mdadm/ ; cd mdadm ; make;make install)
>>
>> Thanks,
>> NeilBrown
>>
>> From 357ac1067835d1cdd5f80acc28501db0ffc64957 Mon Sep 17 00:00:00 2001
>> From: NeilBrown <neilb@suse.de>
>> Date: Wed, 20 Nov 2013 10:49:14 +1100
>> Subject: [PATCH] IMSM metadata really should be ignored when found on
>>  partitions.
>>
>> commit b31df43682216d1c65813eae49ebdd8253db8907
>> changed load_super_imsm to not insist on finding a partition if
>> ignore_hw_compat was set.
>> Unfortunately this is set for '--assemble' so arrays could get
>> assembled badly.
>>
>> The comment says this was to allow e.g. --examine of image files.
>> A better fixes for this is to change test_partitions to not report
>> a regular file as being a partition.
>> The errors from the BLKPG ioctl are:
>>
>>  ENOTTY : not a block device.
>>  EINVAL : not a whole device (probably a partition)
>>  ENXIO  : partition doesn't exist (so not a partition)
>>
>> Reported-by: "David F." <df7729@gmail.com>
>> Signed-off-by: NeilBrown <neilb@suse.de>
>>
>> diff --git a/super-intel.c b/super-intel.c
>> index 7b2406866493..c103ffdd2dd8 100644
>> --- a/super-intel.c
>> +++ b/super-intel.c
>> @@ -4423,7 +4423,7 @@ static int load_super_imsm(struct supertype *st, int fd, char *devname)
>>         struct intel_super *super;
>>         int rv;
>>
>> -       if (!st->ignore_hw_compat && test_partition(fd))
>> +       if (test_partition(fd))
>>                 /* IMSM not allowed on partitions */
>>                 return 1;
>>
>> diff --git a/util.c b/util.c
>> index 5f95f1f97c02..b29a3ee7ce47 100644
>> --- a/util.c
>> +++ b/util.c
>> @@ -307,7 +307,7 @@ int test_partition(int fd)
>>         if (ioctl(fd, BLKPG, &a) == 0)
>>                 /* Very unlikely, but not a partition */
>>                 return 0;
>> -       if (errno == ENXIO)
>> +       if (errno == ENXIO || errno == ENOTTY)
>>                 /* not a partition */
>>                 return 0;
>>
