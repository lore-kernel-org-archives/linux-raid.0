From: Andre Tomt <andre@tomt.net>
Subject: Unable to fail/remove journal device
Date: Mon, 30 Mar 2020 01:35:56 +0200
Message-ID: <59985bfe-2786-b4a9-64a4-283f5de98f82@tomt.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I'm having a issue here where I am unable to get a journal device 
removed from a raid6 array. From what I could gather from mailing list 
posts and documentation, one should set the journal mode to 
write-through, fail the journal and remove it, then restart the array 
(perhaps with force).

But this isnt working. The journal just gets re-added on array startup. 
I've done this successfully before, in the same way, I think.

I also tried a bigger hammer, wipefs the journal device too, to "make 
sure", the array will come up but refuse any writes.

For now, the journal device has been restored and the array is back to 
read-write, but I really need to get it removed at some point 
(preferably without re-building metadata with --assume-clean)

Any ideas? Is this way just out of date?

mdadm: 4.1-5ubuntu1
kernel: 5.5.13

# cat /proc/mdstat
md2 : active (auto-read-only) raid6 sdm1[0] sde1[11] sdk1[10] sdt1[9] 
sdl1[8] sdc1[7] sdj1[6] sdb1[5] sdu1[4] sds1[3] sdr1[2] sdd1[1] 
nvme0n1p1[12](J)

       58603894400 blocks super 1.2 level 6, 64k chunk, algorithm 2 
[12/12] [UUUUUUUUUUUU]


# echo write-through > /sys/block/md2/md/journal_mode
# mdadm --fail /dev/md2 /dev/nvme0n1p1
mdadm: set /dev/nvme0n1p1 faulty in /dev/md2

# mdadm --remove /dev/md2 /dev/nvme0n1p1

mdadm: hot removed /dev/nvme0n1p1 from /dev/md2

# cat /proc/mdstat
md2 : active (auto-read-only) raid6 sdm1[0] sde1[11] sdk1[10] sdt1[9] 
sdl1[8] sdc1[7] sdj1[6] sdb1[5] sdu1[4] sds1[3] sdr1[2] sdd1[1]

       58603894400 blocks super 1.2 level 6, 64k chunk, algorithm 2 
[12/12] [UUUUUUUUUUUU]


# mdadm --stop /dev/md2

mdadm: stopped /dev/md2


# mdadm --assemble /dev/md2 --force

mdadm: /dev/md2 has been started with 12 drives and 1 journal.
  <-- !?
# cat /proc/mdstat
md2 : active (auto-read-only) raid6 sdm1[0] nvme0n1p1[12](J) sde1[11] 
sdk1[10] sdt1[9] sdl1[8] sdc1[7] sdj1[6] sdb1[5] sdu1[4] sds1[3] sdr1[2] 
sdd1[1]

                                             ^^^
       58603894400 blocks super 1.2 level 6, 64k chunk, algorithm 2 
[12/12] [UUUUUUUUUUUU]


Okay then. Hammer time. Do all that again, wipefs the journal device, 
force start the array:

# mdadm --assemble /dev/md2 --force

mdadm: Journal is missing or stale, starting array read only.

mdadm: /dev/md2 has been started with 12 drives.

# cat /proc/mdstat
md2 : active (read-only) raid6 sdm1[0] sde1[11] sdk1[10] sdt1[9] sdl1[8] 
sdc1[7] sdj1[6] sdb1[5] sdu1[4] sds1[3] sdr1[2] sdd1[1]

       58603894400 blocks super 1.2 level 6, 64k chunk, algorithm 2 
[12/12] [UUUUUUUUUUUU]


Then it is just stuck in read-only.
