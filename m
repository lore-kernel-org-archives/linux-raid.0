From: Wilson Jonathan <piercing_male@hotmail.com>
Subject: Growing array, duplicating data, shrinking array questions.
Date: Thu, 21 Nov 2013 18:09:57 +0000
Message-ID: <BLU0-SMTP1655B70AE4DF50100E9817198E10@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I think I know what I need to do to perform the operations I want, but
wanted to check here first.

I currently have 2 disks used to hold OS/swap/(empty)home/somedata
partitions (500G) and a six drive raid 6 (1TB, single partition not
whole drive) setup.

What I want to do is replace the 6 drives with 4 3TB WD REDs, and also
to move the OS and stuff onto the 4 3TB drives.

At the moment the 500GB drives are partitioned as following.

GPT: 
1MB (Bios boot)
210MB RAID1 (boot)
24GB  RAID1 (root) (current live boot)
8GB   *SWAP
54GB  RAID1 (root2) (new install, will replace root)
11GB  RAID1 (home)
XXGB  RAID1 (data)
The swap is amalgamated into 16GB total swap.

(root) and (root2) are different versions of debian, (root) is my
current "live" and (root2) is my "testing" by the end of this excersize
(root) will no longer exist, and (root2) will become my "live."

My idea is to fail and remove one of the RAID6 devices, then put the 3TB
in its place and format it, using gptfdisk, as the following.

GPT:
1MB (Bios boot)
210MB RAID1 (boot)
84GB  RAID1 (root2)
16GB  RAID1 (*swap)
XXGB  Space unused, to push the last partition to the end of the disk.
1TB   RAID6 (raid6)

From what I have read I can grow the (boot) (root2) by increasing the
number of devices, even though (root2) is larger on the new disk it will
be added and only the first 54GB will synced; basically increase the
number of devices from 2 to 3.

I will also add/update the boot loader/mbr to the new drive.

By adding in the raid6 partition it will be re-synced as if it were the
original failed drive being replaced.

I then replicate this process for the other 3 disks.
eg (boot) (root2) no-devices=4
...=5
...=6

and obviously adding in a replacement for the failed/removed RAID6 1TB
drive with the RAID6 partition (raid6) and updating the (bios boot)/mbr

I will create a new RAID1 (*swap) when all the 4 devices are in place.

Also I will then create a RAID6 partition on the 4 drives empty space
unused partition (new6).

Once this is done, and checked if all working ok...

I will then fail and remove both the original, 500GB, RAID1 (boot)
(root) (root2) drives, then grow the raids down to ..devices=4

I believe I will then need to grow the (root2) ..size=max to extend it
from 54GB to 84GB, check the file system, grow the file system, then
check it again.

I will then copy all the data from the (raid6) to (new6) run a check to
see if they are identical, and then bring down and delete (raid6) remove
the last 2 remaining 1TB drives, put them into USB caddies (from whence
they originally came, was cheaper than buying the raw drives) and then
backup to them.

Finally I will delete all the 4 (raid6) partitions, I will also change
the size of the (new6) partition to include the now deleted (raid6)
space. (I'm assuming changing the partition end will not affect the data
contained within) for all 4 drives, then grow the partition ..size=max,
check the file system, grow the file system, final check...

Finally I will update the mdadm.conf in both the (root) and (root2)
directory to take note of changes.. create the swap on the (*swap) and
also change the (root) and (root2) fstab to take note of the file system
changes and the new swap partition...

...to keep things clean, I will change the files slightly differently
for both "/" so that (root) will no longer see (root2) and also the
reverse, once all is complete (root) will no longer be used and will be
removed... 

..then check that they both boot ok, finally delete the now unused (bios
boot) (boot) (root2) from the 500GB drives, do some house keeping and if
all has gone to plan then I can finally breath again.

Is there anything I've got in the above that looks wrong, or is a
disaster in the making as I've miss understood something?

Actually, thinking about it... will I need to update the initramfs at
any point, for example when I delete the (root) from within (root2) as
my final stage after all housekeeping, and also once I have updated
everything in (root) such as fstab and mdadm.conf?



