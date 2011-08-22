From: Piotr Legiecki <piotrlg@pum.edu.pl>
Subject: Re: RAID10 failed with two disks
Date: Mon, 22 Aug 2011 14:52:50 +0200
Message-ID: <4E525122.7090607@pum.edu.pl>
References: <4E5231EE.3010001@pum.edu.pl>	<20110822210903.2582bcfd@notabene.brown>	<4E5240BE.1050807@pum.edu.pl> <20110822220129.5b2928ff@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110822220129.5b2928ff@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown pisze:
> It looks like sde1 and sdf1 are unchanged since the "failure" which happened
> shortly after 3am on Saturday.  So the data on them is probably good.

And I think so.

> It looks like someone (you?) tried to create a new array on sda1 and sdb1
> thus destroying the old metadata (but probably not the data).  I'm surprised
> that mdadm would have let you create a RAID10 with just 2 devices...   Is
> that what happened?  or something else?

Well, its me of course ;-) I've tried to run the array. It of course 
didn't allo me to create RAID10 on two disks only, so I have used mdadm 
--create .... missing missing parameters. But it didn't help.


> Anyway it looks as though if you run the command:
> 
>   mdadm --create /dev/md4 -l10 -n4 -e 0.90 /dev/sd{a,b,e,d}1 --assume-clean

Personalities : [raid1] [raid10]
md4 : active (auto-read-only) raid10 sdf1[3] sde1[2] sdb1[1] sda1[0]
       1953519872 blocks 64K chunks 2 near-copies [4/4] [UUUU]

md3 : active raid1 sdc4[0] sdd4[1]
       472752704 blocks [2/2] [UU]

md2 : active (auto-read-only) raid1 sdc3[0] sdd3[1]
       979840 blocks [2/2] [UU]

md0 : active raid1 sdd1[0] sdc1[1]
       9767424 blocks [2/2] [UU]

md1 : active raid1 sdd2[0] sdc2[1]
       4883648 blocks [2/2] [UU]

Hura, hura, hura! ;-) Well, wonder why it didn't work for me ;-(


> there is a reasonable change that /dev/md4 would have all your data.
> You should then
>    fsck -fn /dev/md4

fsck issued some errors
....
Illegal block #-1 (3126319976) in inode 14794786.  IGNORED.
Error while iterating over blocks in inode 14794786: Illegal indirect 
block found
e2fsck: aborted

md4 is read-only now.

> to check that it is all OK.  If it is you can
>    echo check > /sys/block/md4/md/sync_action
> to check if the mirrors are consistent.  When it finished 
>    cat /sys/block/md4/md/mismatch_cnt
> will show '0' if all is consistent.
> 
> If it is not zero but a small number, you can feel safe doing
>     echo repair > /sys/block/md4/md/sync_action
> to fix it up.
> If it is a big number.... that would be troubling.

A bit of magic as I can see. Would it not be reasonable to put those 
commands in mdadm?

>> And does layout (near, far etc) influence on this rule: adjacent disk 
>> must be healthy?
> 
> I didn't say adjacent disks must be healthy.  Is said you cannot have
> adjacent disks both failing.  This is not affected by near/far.
> It is a bit more subtle than that though.  It is OK for 2nd and 3rd to both
> fail.  But not 1st and 2nd or 3rd and 4th.

I see. Just like ordinary RAID1+0. First and second pair of the disks 
are RAID1, when both disks in that pair fail the mirror is dead.

Wonder what happens when I create RAID10 on 6 disks? So we have got: 
sda1+sdb1 = RAID1
sdc1+sdd1 = RAID1
sde1+sdf1 = RAID1
Those three RAID1 are striped together in RAID0?
And assuming each disk is 1TB, I have 3TB logical space?
In such situation still the adjacent disks of each RAID1 both must not 
fail.


And I still wonder why it happened? Hardware issue (motherboard)? Or 
kernel bug (2.6.26 - debian/lenny)?


Thank you very nice for help.

Regards
Piotr
