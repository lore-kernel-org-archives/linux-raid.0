From: Diego Guella <diego.guella@deviltechnologies.com>
Subject: Re: raid1 bitmap and multiple removed disks
Date: Thu, 24 Nov 2016 09:46:14 +0100
Message-ID: <7457f7df-c9fe-ffcd-173d-5e8c559386fb@deviltechnologies.com>
References: <ce2ba842-22f0-eebf-856c-f07d38574489@deviltechnologies.com>
 <87fumhbu41.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87fumhbu41.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,


Il 24/11/2016 01:26, NeilBrown ha scritto:
> On Wed, Nov 23 2016, Diego Guella wrote:
>
>> (2nd attempt: the previous one didn't make it)
>> Hi,
>>
>> I am using linux raid1 for a double-purpose: redundancy and backup.
>>
>> I have a raid1 array of 5 disks, 3 of which are kept for backup purposes.
>> Let's call disks A, B, C, D, E.
>> Disks A and B are _always_ connected to the system.
>> Disks C, D, E are backup disks.
>> Here follows a description of how I use the backup disks.
>> This morning I connect disk C, and let it resync.
>> Tomorrow morning, I shut down the system, remove disk C and keep it away
>> as a daily backup.
>> I connect the next disk (D), then start up the system.
>> Linux raid1 recognizes the "old" disk and does not allow it to enter the
>> array (this is evidenced by system logs).
>> I then add disk D to the array, and let it resync.
> So this would be a full resync - right?
By "let it resync" I mean:
- mdadm /dev/md1 -a /dev/sdX
- (watch /proc/mdstat until it finishes)
I don't touch the raid1 until the resync finishes.

The first time disk D is added to the array (suppose it is a brand new 
disk), yes, it is a full resync (~20 hours).
BUT if D is not brand new, and it has already been part of this raid1 
"rotation", the resync is clearly not a full resync:
- mdadm says "re-adding /dev/sdX", although i told it "mdadm /dev/md1 -a 
/dev/sdX"
- watching /proc/mdstat (or better, looking at dmesg), the resync takes 
a hour or two, depending on how much the data is changed.


>> The next day, I connect the next disk (E), and so on, rotating them.
>> The "connect and disconnect" is always performed when the system is
>> powered off, although sometimes I hot-connect the disk with the system
>> already powered up.
>> The purpose of this is to have an emergency backup: I can disconnect ALL
>> disks from the system and connect only one of the daily backups, going
>> "back to the past"(TM).
>>
>> This array has a write-intent bitmap, in order to speed up the resync
>> (it is a 4TB array, and sometimes it needs nearly 20 hours to resync
>> without bitmaps due to system load).
>>
>> This worked flawlessly (for some years) until some days ago, when the
>> array suffered a strange inconsistency, and the filesystem nearly gone
>> nuts in about 20 minutes of uptime. I will elaborate more on this
>> later.
> Did you ever test your backups?
Of course.
I tested this "raid1 backup system" back some years ago, with Debian 
Lenny, artificially destroying the / partition, to the point where the 
system would not boot. Then, I took one of the "backup" disks, throw it 
in as the only disk in the system, and powered up the system. All was 
working, effectively going "back to the past"(TM).

More recently, occasionally I needed to go "back to the past"(TM) to 
recover some accidentally-deleted files to a temporary flash drive, and 
I even needed to go "back to the past"(TM) because of a bad system 
update: I then zeroed out the superblocks of all the other devices, and 
resynced them to the backup, bringing up full redundancy from a backup.

The most recent "back to the past"(TM) was some days ago.
This is what I called "I will elaborate more on this later" in my 
previous mail:
- I changed the bitmap-chunk: disks A, B, C had a new bitmap-chunk while 
disks D, E (the backups) had the old bitmap-chunk (they were detached 
and offline).
- A, B, C completely resynced
- power down
- remove C; insert D
- power up
- mdadm /dev/md1 -a /dev/sdD
- kernel panic in 20 minutes

This episode was my fault: I *thought* the RAID1 was smart enough to 
recognize the different bitmap-chunks and adapt them, but I was wrong. 
The array resynced completely in some minutes (or at least, it *thought* 
it was resynced), and then probably the filesystem read some (old) block 
from disk D and boom!
I should have zeroed out the superblock of any device that didn't 'see' 
(read: was online) the bitmap-chunk change.

Moreover, since that episode spawned many doubts in my mind, I ran a 
checkarray 2 days ago on /dev/md1: the result was 0 mismatch_cnt.


>> Since that problem happened, some questions come to my mind:
>> What raid1 bitmaps allow me to do?
> - accelerate resync after a crash.
> - accelerate recovery when you remove a drive and re-add it.
>
>> Can they record _correctly_ the state of multiple removed disks, in
>> order to overwrite only out-of-sync chunks of multiple removed disks?
> All that is recorded is the set of regions which have been written to
> since the array was last in a non-degraded state.
Hmm... My array is a 5-devices array. This is because I have 5 
components total: 2 online and 3 backups (actually: 2 online, 1 
resyncing, and 2 backups).
That's needed (I performed tests many years ago) because if I set it 
(for example) as a 3-devices array, bitmap were not working: every time 
I added a backup disk, raid1 performed a full resync (many many hours).

So: my array is _always_ in a degraded state (and it cannot _ever_ be 
non-degraded, at least until I leave it as a 5-devices array: I don't 
have enough SATA ports to connect every component).
Does this change anything?


>> In other words, am I allowed to do what I described above?
> If the recovery that happened when you swapped drives was not a full
> recovery, then probably not.
The recovery was full once the disk was brand new, then it seems to 
become "known" to the array, and after the first full resync it performs 
a bitmap-driven resync.
Does this change anything?


>> If not, can I change something in my actions in order to have a daily
>> backup using raid1?
> I wrote something about this a few years ago...
>   http://tracking.deviltechnologies.com/f/a/VPRXX7FggKxkR6o3483qZw~~/AAB-JAA~/RgRaF9yFP0EIAOwbEIOkxRJXA3NwY1gEAAAAAFkGc2hhcmVkYQNuZXdgDTUyLjM4LjE5MS4yMTlCCgADBak2WPlRlulSGmxpbnV4LXJhaWRAdmdlci5rZXJuZWwub3JnCVEEAAAAAEQxaHR0cDovL3Blcm1hbGluay5nbWFuZS5vcmcvZ21hbmUubGludXgucmFpZC8zNTA3NEcCe30T
>
> or this thread
>    http://tracking.deviltechnologies.com/f/a/4RW-JGI-J1MY0p25SXWrZw~~/AAB-JAA~/RgRaF9yFP0EIAOwbEIOkxRJXA3NwY1gEAAAAAFkGc2hhcmVkYQNuZXdgDTUyLjM4LjE5MS4yMTlCCgADBak2WPlRlulSGmxpbnV4LXJhaWRAdmdlci5rZXJuZWwub3JnCVEEAAAAAEQvaHR0cDovL3d3dy5zcGluaWNzLm5ldC9saXN0cy9yYWlkL21zZzM1NTMyLmh0bWxHAnt9Ew~~

OK, I read that thread. Thanks for pointing me to that.
_IF_ that's the only solution, I prefer to give up on bitmaps: I don't 
like the idea of the stacked raid1 arrays because it's not flexible 
enough for me.
With a single plain raid1 array I can grow the number of RAID devices in 
the future to an unknown number; while using a stacked one I need to 
know in advance how many devices will participate in the array.

However, from that same thread, Phil Turmel wrote:

> This is a problem.  MD only knows about two disk.  You have three.  When two disks are in place and sync'ed, the bitmaps will essentially stay cleared.
> When you swap to the other disk, its bitmap is also clear, for the same reason.  I'm sure mdadm notices the different event counts, but the clear bitmap would leave mdadm little or nothing to do to resync, as far as it knows.  But lots of writes have happened in the meantime, and they won't get copied to the freshly inserted drive.  Mdadm will read from both disks in parallel when there are parallel workloads, so one workload would get current data and the other would get stale data.
> If you perform a "check" pass after swapping and resyncing, I bet it finds many mismatches.  It definitely can't work as described.
> I'm not sure, but this might work if you could temporarily set it up as a triple mirror, so each disk has a unique slot/role.

In my case, MD knows about all disks: I have 5 disks, and /dev/md1 is a 
5-devices raid1 array.
Moreover, my array is _never_ non-degraded, and I even performed a 
checkarray which returned 0 mismatch_cnt.


I'm not trolling there, I just want to learn and understand what's 
happening, since I relied on this behavior for _years_ now.

I can even perform some tests (non-destructive: this is a production 
system), and I may even be able to arrange some destructive tests at 
home if needed (I need to check how many spare disks I have).
This production system actually have 3 raid1 arrays set up in the same 
way (every drive has 3 partitions for these arrays): one for swap, one 
for /, and one for /home.
The / array is relatively small (about 13 GB), so I may even be able to 
dd many of them out, saving them in order to perform binary compares, 
and other things like that.


Please note:
I _never_ use "mdadm -f" or "mdadm -r". I _always_ power off the system 
when removing devices from the raid1.


Thanks for your reply,
Diego Guella

