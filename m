From: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Subject: GPT corruption on Primary Header, backup OK, fixing primary nuked
 array -- help?
Date: Mon, 25 Jul 2016 19:52:59 -0500
Message-ID: <5796B46B.6060905@suddenlinkmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil, all,

  I really stepped in it this time. I have had a 3T raid1 array with 2 disks
sdc/sdd that has worked fine since the new disks were partitioned and the arrays
were created in August of last year. (simple 2-disk, raid1, ext4 - no
encryption) Current kernel info on Archlinux is:

# uname -a
Linux valkyrie 4.6.4-1-ARCH #1 SMP PREEMPT Mon Jul 11 19:12:32 CEST 2016 x86_64
GNU/Linux

When the disks were partitioned originally and the arrays created, listing the
partitioning showed no partition table problems. Today, a simple check of the
partitioning by listing the partitions on sdc with 'gdisk -l /dev/sdc' brought
up a curious error:

# gdisk -l /dev/sdc
GPT fdisk (gdisk) version 1.0.1

Caution: invalid main GPT header, but valid backup; regenerating main header
from backup!

Caution! After loading partitions, the CRC doesn't check out!
Warning! Main partition table CRC mismatch! Loaded backup partition table
instead of main partition table!

Warning! One or more CRCs don't match. You should repair the disk!

Partition table scan:
  MBR: protective
  BSD: not present
  APM: not present
  GPT: damaged

****************************************************************************
Caution: Found protective or hybrid MBR and corrupt GPT. Using GPT, but disk
verification and recovery are STRONGLY recommended.
****************************************************************************
Disk /dev/sdc: 5860533168 sectors, 2.7 TiB
Logical sector size: 512 bytes
Disk identifier (GUID): 3F835DD0-AA89-4F86-86BF-181F53FA1847
Partition table holds up to 128 entries
First usable sector is 34, last usable sector is 5860533134
Partitions will be aligned on 2048-sector boundaries
Total free space is 212958 sectors (104.0 MiB)

Number  Start (sector)    End (sector)  Size       Code  Name
   1            8192      5860328334   2.7 TiB     FD00  Linux RAID

(sdd showed the same - it was probably fine all along and just the result of
creating the arrays, but that would be par for my day...)

Huh? All was functioning fine, even with the error -- until I tried to "fix" it.
First, I searched for possible reasons on how the primary GPT table became
corrupt. The reasons range from some non-GPT aware app tried to access the table
(not anything I can think of here) or perhaps the Gigabyte "virtual bios" wrote
a copy of the bios within the larger GPT table causing the issue, see:
https://francisfisher.me.uk/problem/2014/warning-about-large-hard-discs-gpt-and-gigabyte-motherboards-such-as-ga-p35-ds4/)
That sounds flaky, but I do have a Gigabyte GA-990FXA-UD3 Rev. 4 board.

So after reading the posts, and reading the unix.stackexchange, superuser, etc.
posts on the subject:

 http://www.rodsbooks.com/gdisk/repairing.html
 http://askubuntu.com/questions/465510/gpt-talbe-corrupt-after-raid1-setup
 https://ubuntuforums.org/showthread.php?t=1956173
 ...

and various parted bugs about the opposite:

 https://lists.gnu.org/archive/html/bug-parted/2015-07/msg00003.html

I came up with a plan to:

 - boot the Archlinux recovery cd 20160301 release CD
 - use gdisk /dev/sdd; r; v; c; w; to correct the table
 - --fail and --remove the disk from the array, and
 - readd the new disk, let it sync, then do the same for /dev/sdc

(steps 1 & 2 went fine, but that's where I screwed up...).

Now I'm left with an array (/dev/md4) in an inactive and probably
un-salvageable. The data on the disks is backed up, so if there is no way to
assemble and recover the data, I'm only out the time to recopy it. If I can save
that, fine, but it isn't pressing. The current array state is:

# cat /proc/mdstat
Personalities : [raid1]
md1 : active raid1 sdb6[1] sda6[0]
      52396032 blocks super 1.2 [2/2] [UU]

md0 : active raid1 sdb5[1] sda5[0]
      511680 blocks super 1.2 [2/2] [UU]

md3 : active raid1 sdb8[1] sda8[0]
      2115584 blocks super 1.2 [2/2] [UU]

md2 : active raid1 sdb7[1] sda7[0]
      921030656 blocks super 1.2 [2/2] [UU]
      bitmap: 0/7 pages [0KB], 65536KB chunk

md4 : inactive sdc[0](S)
      2930135512 blocks super 1.2

unused devices: <none>

This is where I'm stuck. I've got the primary partition table issue on sdd
fixed, I have not touched sdc (it is in the same state it was, when it was
functioning with the complaint about the primary gpt partition table. I have
tried activating the array with sdd1 "missing", but no joy. After correcting the
partition table on sdd, it still contains the original partition, but I cannot
get it (or sdc) to assemble in degraded or raid mode.

I need help. Is there anything I can try to salvage the array? (at least one
disk of the array?) If not, is there a way I can activate (or at least mount
either sdc or sdd? -- it would be easier to dump the data rather than copying
from multiple sources. It's ~258G, not huge, but not small)

I know worst case is to wipe both disks (gdisk /dev/sd[cd] x; z; yes; yes) and
start over, but with one disk of md4 that I haven't touched, it seems like I
should be able to recover something?

If the answer is just no, no, ..., then what is the best approach? zap with
gdisk, wipe the superblocks and start over?

If you need any other information that I haven't included, just let me know. I
have the binary dumps of partition tables from sdc and sdd (from gdisk written
to disk before any changes to sdd). Anyway, if there is anything else, just let
me know and I'll post it.

The server on which this array resides is running (this was just a data array,
the boot, root, and home arrays are fine (they are mbr). I've just commented the
mdadm.conf and fstab entries for the effected array.

Last, but less important, any idea where this primary GPT corruption originated?
(or was it fine all along and the error just a result of them being members of
the array?) There are numerous posts over the last year related to:

    "invalid main GPT header, but valid backup"

(and relating to raid1)

but not many answers as to why. (if this was just a normal gdisk response from a
raided disk, then there is a lot of 'bad' info out there. What is my best
approach for attempting recovery from this self-created mess? Thanks.


-- 
David C. Rankin, J.D.,P.E.
