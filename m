From: "Michael Paul" <radius.mp@verizon.net>
Subject: Lost in RAID.. Trying to mirror a raid-0 array
Date: Sun, 26 Jan 2003 20:48:43 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <016001c2c5bf$5eba2c80$1400020a@mike>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



     Hi there...

 Recently subscribed and hoping for some help. Be forwarned, this post will
be a little long. Also, I want to make sure that everyone knows that I have
read all of the raid tools docs that I could find, and I've been working on
this for quite some time. As will become apparent, I am also fairly new to
linux. :/

 First, some background. I was running W2K advanced server on my home file
server for quite some time with good success. I had been wanting to try
linux for quite some time so when I had a sdram failure that started
corrupting data, my opportunity arrived. <g>

Hardware Info: This computer is an amalgam of lots of old hard drives, ide
and scsi controller cards, etc. The system currently has 14 hard drives in
it. 4 are scsi, the rest ide. The scsi drives run on a Diamond Fireport 40
scsi controller card, 3 of the ide drives run on the motherboard controller,
4 drives run on a Promise Ultra 100 PCI (non-raid) controller card and the
remaining 3 drives run on a Promise Ultra 133 TX2 (non-raid) controller
card. The system is a SMP P2-300 with 896MB of RAM on a Tyan Tiger 100
motherboard. All of the drives, controller cards, etc, are all working
properly. I doubt the problems I am having have to do with the hardware.
However, I could be wrong. It wouldn't be the first time. <g> Also, FYI,
most of the drives are all different sizes, in case that matters.

OS: Currently running a totally stock installation of Red Hat 7.3 with
kernel version 2.4.18-3smp. From what I can tell, my raid tools version is
1.00.2. All of the drives to be used in the raid arrays were converted to fd
partition type using fdisk.

Objective: I am trying to create a raid-linear array out of 10 of these
drives. The drives have a combined capacity of 179GB. I also have a Western
Digital WD2000JB 200GB IDE (hdk) drive. The goal is to mirror the
raid-linear device to hdk. The remaining 3 drives in the system are used for
/boot, /home, /var, etc..  With w2k adv server, I had to create dynamic
partitions on each disk, then I could create a spanned archive. However, I
could not mirror the spanned archive and I had to use a backup type program
called Second Copy.

Problems: Many! <g>  The first problem is in creating the raid-linear. The
linear gets created with no errors or other problems. After making the
filesystem and mounting the array, the total capacity of the array is
limited by the size of the first disk in the array. For example, the first
disk in my raidtab file is a 17gb ide drive. Doing df from the commant
prompt after the array is created results in a total capacity of 16gb.
Unless I am doing something very wrong in the raidtab file, I can't figure
out why it's doing this. Perhaps a bug?

Second problem: The workaround to the above problem was to create a raid-0
array instead of linear. After the array is mounted, the free space is
reported correctly. Now that I've gotten past that problem, I made the
raid-1 array as md1. After spending 27 hours resyncing the drives, the
testing begins. <g>  The mirror doesn't work. Again, I am assuming that I am
doing something wrong, but I haven't been able to find any documentation
outlining what I am trying to do. I can mount both md0 and md1 and write
files to them. Except whatever files I write do not get mirrored. I have
tried writing files to md0 (raid-0) first and to md1 (raid-1) first with the
same results.

Misc Note: As an experiment, I decided to make 11 partitions on hdk. 10 for
mirrors and one for the extra space on the drive. After all, why waste it,
right? <g>  I then made 10 different raid-1 arrays, and then made a
raid-linear array (md10) out of md0-md9. I still had the fre space issure,
but this seemed to work from a mirroring standpoint. However, I had no way
to verify this. When files were written to md10, the corresponding disk
LED's lit up, but I was unable to individually mount any of the individual
mirror arrays to check for files. I am confident that if I did it this way
again, but used raid-0 instead of linear, the free space issue would again
be resolved. But the inability to easily check to see if data was being
mirrored, and the difficulty in recovering the data from hdk makes this
solution less than optimal, IMHO. The preferable solution would be to fix
the linear array free space issue, then mirror the linear array. Also,
sometime during the raid-1 resync process, the following errors show in
/var/log/messages:

01:48:40 localhost kernel: hdf: dma_intr: status 0x51 ( DriveReady
SeekComplete Error )
01:48:40 localhost kernel: hdf: dma_intr: error = 0x04 (DriveStatusError )
01:48:43 localhost kernel: hdf: dma_intr: status 0x51 ( DriveReady
SeekComplete Error )
01:48:43 localhost kernel: hdf: dma_intr: error = 0x04 (DriveStatusError )

  Also, as another note, these errors only seem to occur when I try to build
the raid-0 array first, then the mirror. They also only occur during the
resync process.

 Any ideas? I'm basically stuck at this point, unable to get things working
properly. I've read all the docs I can find but haven't found any possible
solutions. I don't know if there are issues with the kernel version or
raidtools version I am using. Hopefully someone here can help me. <g> If you
need any more info, please do not hesitate to ask. For your convenience, my
current raidtab file is pasted below in it's entirety. If anyone has some
tips as to how to streamline my raidtab file a little better (unneeded
options, missing options, etc) please let me know! <g>

Thanks!
Michael

raiddev /dev/md0
raid-level 0
nr-raid-disks 10
persistent-superblock 1
chunk-size 16
device /dev/hdb
raid-disk 0
device /dev/hdc
raid-disk 1
device /dev/hde
raid-disk 2
device /dev/hdf
raid-disk 3
device /dev/hdg
raid-disk 4
device /dev/hdh
raid-disk 5
device /dev/hdi
raid-disk 6
device /dev/hdj
raid-disk 7
device /dev/sdc
raid-disk 8
device /dev/sdd
raid-disk 9

raiddev /dev/md1
raid-level 1
nr-raid-disks 2
nr-spare-disks 0
persistent-superblock 1
chunk-size 16
device /dev/md0
raid-disk 0
device /dev/hdk1
raid-disk 1

 One more note: For /dev/md1, I have tried swapping around md0 and md1 in
the raidtab file with the same result both ways.


