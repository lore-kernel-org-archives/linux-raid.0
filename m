From: Shaohua Li <shli@kernel.org>
Subject: Re: [RFC 1/2]raid1: only write mismatch sectors in sync
Date: Tue, 31 Jul 2012 16:12:04 +0800
Message-ID: <CANejiEWZk6JcErw9Y6cqpotYMypQA_jvv8N0612FBq81Lo8jVQ@mail.gmail.com>
References: <20120726080150.GA21457@kernel.org>
	<20120731155304.11c40f9b@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120731155304.11c40f9b@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2012/7/31 NeilBrown <neilb@suse.de>:
> On Thu, 26 Jul 2012 16:01:50 +0800 Shaohua Li <shli@kernel.org> wrote:
>
>> Write has some impacts to SSD:
>> 1. wear out flash. Frequent write can speed out the progress.
>> 2. increase the burden of garbage collection of SSD firmware. If no space
>> left for write, SSD firmware garbage collection will try to free some space.
>> 3. slow down subsequent write. After write SSD to some extents (for example,
>> write the whole disk), subsequent write will slow down significantly (because
>> almost every write invokes garbage collection in such case).
>>
>> We want to avoid unnecessary write as more as possible. raid sync generally
>> involves a lot of unnecessary write. For example, even two disks don't have
>> any data, we write the second disk for the whole disk size.
>>
>> To reduce write, we always compare raid disk data and only write mismatch part.
>> This means sync will have extra IO read and memory compare. So this scheme is
>> very bad for hard disk raid and sometimes SSD raid too if mismatch part is
>> majority. But sometimes this can be very helpful to reduce write, in that case,
>> since sync is rare operation, the extra IO/CPU usage is worthy paying. People
>> who want to use the feature should understand the risk first. So this ability
>> is off by default, a sysfs entry can be used to enable it.
>>
>> Signed-off-by: Shaohua Li <shli@fusionio.com>
>> ---
>>  drivers/md/md.c    |   41 +++++++++++++++++++++++++++++++
>>  drivers/md/md.h    |    3 ++
>>  drivers/md/raid1.c |   70 +++++++++++++++++++++++++++++++++++++++++++++++++----
>>  3 files changed, 110 insertions(+), 4 deletions(-)
>>
>> Index: linux/drivers/md/md.h
>> ===================================================================
>> --- linux.orig/drivers/md/md.h        2012-07-25 13:51:00.353775521 +0800
>> +++ linux/drivers/md/md.h     2012-07-26 10:36:38.500740552 +0800
>> @@ -325,6 +325,9 @@ struct mddev {
>>  #define      MD_RECOVERY_FROZEN      9
>>
>>       unsigned long                   recovery;
>> +#define MD_RECOVERY_MODE_REPAIR              0
>> +#define MD_RECOVERY_MODE_DISCARD     1
>> +     unsigned long                   recovery_mode;
>
> You have not documented the meaning of these two flags at all, and I don't
> feel up to guessing.
>
> The patch looks more complex that it should be.  The behaviour you are
> suggesting is exactly the behaviour you get when MD_RECOVERY_REQUESTED is
> set, so at most I expect to see a few places where that flag is tested
> changed to test something else as well.
>
> How would this be used?  It affects resync and resync happens as soon as the
> array is assembled.  So when and how would you set the flag which says
> "prefer reads to writes"?  It seems like it needs to be set in the metadata.
>
> BTW RAID10 already does this - it reads and compares for a normal sync.  So
> maybe just tell people to use raid10 if they want this behaviour?

It's true, the behavior likes MD_RECOVERY_REQUESTED, ie, read all disks,
only do write if two disk data not match. But I hope it works as soon as the
array is assembled. Surely we can set in the metadata, but I didn't want to
enable it by default, since even with SSD, the read-compare-write isn't optimal
some times, because it involves extra IO read and memory compare.

It appears MD_RECOVERY_REQUESTED assumes disks are insync.
It doesn't read disk !insync, so it doesn't work for assemble.

In my mind, user frozen the sync first (with sync_action setting), and then
enable read-compare-write, and finally continue the sync. I can't stop
a recovery and set MD_RECOVERY_REQUESTED, so I added a flag.
Anyway, please suggest what the preferred way for this.

The second patch is for a special case. two disks data don't match, but
disk1 data are all 0. I'd like to do trim for disk2, instead of write
0 to disk2,
this can be helpful for SSD.

Good to know raid10 already does read-compare-write. From the comments,
looks it only supports resync not recovery.

Thanks,
Shaohua
