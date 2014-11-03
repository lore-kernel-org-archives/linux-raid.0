From: Caspar Smit <c.smit@truebit.nl>
Subject: Re: Trying to get POLICY working
Date: Mon, 3 Nov 2014 10:43:29 +0100
Message-ID: <CADvHm=bE0zcLbDhcdQFfQG8in1Udb7gWcvR-rb9JeUoFaV-v5w@mail.gmail.com>
References: <CADvHm=ZLp08Ydp+P=gn+bu1=GgVORx0TSJoRU33z3UNubwQryQ@mail.gmail.com>
	<20141101112001.344e5f20@notabene.brown>
	<20141103125416.629a4810@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20141103125416.629a4810@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

Actually BOTH your answers were correct, thank you for that.

1) Your hunge was correct as my disk contained a partition table (in
my case an msdos label) and was not added with the error in my first
mail:

mdadm: no RAID superblock on /dev/sdd.

mdadm -E /dev/sdd shows:

/dev/sdd:
   MBR Magic : aa55

So it finds 'something' but clearly unusable to mdadm.

Wiping the partition table and trying again resulted in a different
error message:

mdadm: no recognisable superblock on /dev/sdd.

Which is better but still the disk was not added to the array.

2) To make it work i also needed the domain=default in the POLICY setting.

It still gave me the:

mdadm: no recognisable superblock on /dev/sdd.

But now the disk got added to the array and started rebuilding.

Note: ONLY setting the domain=default in POLICY without clearing the
partition table results in:
mdadm: no RAID superblock on /dev/sdd. and the disk will not be added
so BOTH measures were needed.

Note2: I didn't need the spare-group directive so I think
domain=default is a special case were all disks and arrays are placed
in the same domain.


Furthermore i found out something which i think should not happen
(bug?) or maybe i am wrong:

With a working clean array:

# more /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sdd[3] sdc[1] sdb[0]
      203776 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/3] [UUU]

# mdadm --fail /dev/md0 /dev/sdd
mdadm: set /dev/sdd faulty in /dev/md0

# mdadm --remove /dev/md0 /dev/sdd
mdadm: hot removed /dev/sdd from /dev/md0

# mdadm --incremental /dev/sdd
mdadm: failed to add /dev/sdd to /dev/md/0: Invalid argument.

So when it actually finds a device with an MD superblock it doesn't
add it, is this expected behavior as the disk was failed (so probably
not a good idea to add it back) or is this a bug?

Kind regards,
Caspar


2014-11-03 2:54 GMT+01:00 NeilBrown <neilb@suse.de>:
> On Sat, 1 Nov 2014 11:20:01 +1100 NeilBrown <neilb@suse.de> wrote:
>
>> On Fri, 31 Oct 2014 16:19:04 +0100 Caspar Smit <c.smit@truebit.nl> wrote:
>>
>> > Hi all,
>> >
>> > I'm trying to get the POLICY framework of mdadm working but I can't seem to.
>> >
>> > As i understand in the man page of mdadm the Incremental and POLICY
>> > directives could allow adding a new disk without MD superblock as
>> > spare to an already active array:
>> >
>> > "Note that mdadm will normally only add devices to an array which were
>> > previously working (active or spare) parts of that array.  The support
>> > for automatic inclusion of a new drive as a spare in some array
>> > requires a configuration through POLICY in config file."
>> >
>> > Furthermore:
>> >
>> > "If no md metadata is found, the device may be still added to an array
>> > as a spare if POLICY allows."
>> >
>> >
>> > To get the basics working I created a system with 3 disks /dev/sdb,
>> > /dev/sdc and /dev/sdd
>> >
>> > Created a RAID5 with one missing disk:
>> >
>> > mdadm -C /dev/md0 -l 5 -n 3 /dev/sd[b-c] missing
>> >
>> > I set the POLICY in mdadm.conf to:
>> >
>> > POLICY action=force-spare
>> >
>> > This should add any device (passed through mdadm --incremental) as
>> > spare no matter what (Am i correct?)
>>
>> That is the theory, yes.
>>
>> >
>> > Now when I do:
>> >
>> > #mdadm --incremental /dev/sdd
>> > mdadm: no RAID superblock on /dev/sdd.
>>
>> The message suggests that 'guess_super' found something on the device, but
>> it didn't turn out to be something useful.... not very helpful I know.
>>
>> What does "mdadm --examine /dev/sdd" report?
>> I suspect there is a partition table and that is causing the confusion.
>> Try removing the partition table (dd /dev/zero to the device for a few K).
>> Then try again.
>>
>> Probably need a fix like:
>>
>> diff --git a/Incremental.c b/Incremental.c
>> index c9372587f518..3156190c4603 100644
>> --- a/Incremental.c
>> +++ b/Incremental.c
>> @@ -196,7 +196,7 @@ int Incremental(struct mddev_dev *devlist, struct context *c,
>>       policy = disk_policy(&dinfo);
>>       have_target = policy_check_path(&dinfo, &target_array);
>>
>> -     if (st == NULL && (st = guess_super(dfd)) == NULL) {
>> +     if (st == NULL && (st = guess_super_type(dfd, guess_array)) == NULL) {
>>               if (c->verbose >= 0)
>>                       pr_err("no recognisable superblock on %s.\n",
>>                              devname);
>>
>>
>> and probably should improve the error messages...
>>
>> Thanks for the report.  Please let me know if that works, and what other
>> difficulties you hit.
>
> Actually, don't bother.  I must have been asleep.
>
> Your problem is that you haven't defined a 'domain'.
> A new spare needs to be assigned to a 'domain', and it will be attached to
> any array in the same domain, as needed.
>
> You can give all devices the domain "default" with
>
>    POLICY domain=default
>
> The domain of an array is inherited from the member devices, or can be set
> with "spare-group=" in mdadm.conf.
>
> So
>
>    POLICY domain=default action=force-spare
>
> should make it work for you.
>
> NeilBrown
