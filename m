From: Eduard Rozenberg <eduardr@pobox.com>
Subject: Lost mdadm RAID6 array and tried everything, hoping for any other
 suggestions you may have
Date: Thu, 22 Sep 2011 15:07:02 -0700
Message-ID: <4E7BB186.1010104@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I've had very good luck with mdadm RAID1 over the years and it's really 
helped out.
More recently I got a bit more adventurous and tried out RAID6, but 
after my recent
experience with it I'm considering writing my take on "RAID6 considered 
dangerous" :)

Quick summary:

* Slackware 64 13.37, Linux 2.6.37.6, on Shuttle XPC 4gb ram

* RAID6 array, 8 active drives in a chassis connected via 2 esata cables 
to a shuttle pc,
    12TB total, worked fine for several months. Esata controller w/port 
multiplier support.

* Couple of days back, noticed array was down, with second half of the 
drives shown as
    down. Assumption - 1 cable or esata controller port hickuped, taking 
4 drives out of the array,
    or something happened due to the hot temps that day

* /proc/mdstat showed (S) next to some (or all, can't remember) of the 
drives in the array -
    I think that means spare, but I had no spares defined for the array 
so it seemed weird

* Rebooted machine and checked smartctl status, all 8 drives in chassis 
showed OK status,
    and they were all accessible using gdisk and fd00 partitions 
appeared fine.

* Tried to reassemble normally, then with force, nothing happened - no 
errors, array just
    didn't come up. Did not try --assume-clean (to my regret). Maybe 
would have worked,
    will never know.

* Took some internet advice and tried --create to recreate the array, 
however I forgot which
    chunk size I used so I tried several times with different chunk 
sizes (some resync took place
    each time). Could not find any info on Internet about whether the 
resyncs blew away my data.

* After each mdadm array recreate, tried to mount the array but failed 
with missing superblock

* dd'd a few gb's from the array and tried to grep text in a failed 
attempt to determine chunk size

* Tried testdisk utility to attempt to locate file system structures 
after recreating array with various
    chunk sizes, didn't let utility finish but it didn't seem to be 
doing anything useful

* R-Studio - tried using it, didn't seem it would do anything useful for me

At this point the key questions I'm aware of:

* Did recreating array with various chunk sizes blow away my data/file 
system structures
   (I did not use --assume-clean when recreating array)

* If the data is still ok, is there a way to determine the chunk size 
that was used? I'm hoping
    the metadata version and bitmap options used would not affect being 
able to recover
    the array, because I don't remember which metadata and bitmap 
options I used if any.

* Given the correct chunk size, if I recreate the array, is there some 
way to convince mount to
    mount the array, or some way of fixing the ext4 structure, or any 
other way to get the data of
    the array other than the file carving utilities that dump everything 
in a bunch of random
    directories.

I'm well aware RAID != backups and I had a backup but it was a few 
months old unfortunately.
I didn't expect at all this failure mode of having half the disks 
disappear and having the array
be so hard to recover. Most of the Internet information is focused on 
array creation and mgmt,
and I found precious little information on recovery, some of which was 
wrong and dangerous.
At this point I do consider RAID6 to be dangerous and will avoid it  
where possible. It just makes
recovery so much harder when the file system and data is broken up into 
little pieces.

Thanks in advance for any tips.

Regards,
--Ed
