From: Neil Sedger <linux-raid@moley.org.uk>
Subject: RAID0 - one drive's superblock is corrupt
Date: Tue, 23 Jul 2002 23:33:54 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3D3DD9D2.7030501@moley.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all.

I've had a 140gb RAID0 consisting of various drive makes/sizes for a 
year or so - running on a Red Hat 7.1, Kernel 2.4.2, raidtools-0.90-20. 
All drives have been on a Promise ATA-100 controller.

The RAID0 was originally created with 'persistant-superblock 1' and has 
auto-started itself fine every time until now.

But now I get kernel messages:

kernel: autodetecting RAID arrays
kernel: (read) hde1's sb offset: 45030080hde: dma_intr: status=0x51 { 
DriveReady SeekComplete Error }
kernel: hde: dma_intr: error=0x40 { UncorrectableError }, 
LBAsect=90060223, sector=90060160
kernel: end_request: I/O error, dev 21:01 (hde), sector 90060160
kernel: md: disabled device hde1, could not read superblock.
kernel: md: could not read hde1's sb, not importing!
kernel: could not import hde1!

Am I correct that hde1 - the first partition in RAID0 - has had its 
superblock corrupted?

'badblocks' reports that that sector, and a few others around it, are 
damaged.

 From reading the HOWTO it seems that the superblock is not actually 
required - its just a convenience thing so the kernel can start the raid 
without needing /etc/raidtab. Is that right?

So, I've tried bypassing the superblocks by editing /etc/raidtab, 
setting persistant-superblock to 0, then doing 'raid0run'.
This says its started the RAID OK, I can mount its filesystem (ext2, 
readonly at this time), some files are OK but if I delve too far into 
the filesystem I get errors and kernel messages:

kernel: attempt to access beyond end of device
kernel: 09:00: rw=0, want=326333420, limit=143733920


running e2fsck on it (in read-only mode) produces loads of inode errors, 
eventually exiting with

Error while iterating over blocks in inode 2932821: Illegal indirect 
block found




...so I thought I could try replacing the superblock. From reading the 
HOWTO and man page I think I should be able to do that with 'mkraid':


[root@giles /]# mkraid /dev/md0
handling MD device /dev/md0
analyzing super-block
disk 0: /dev/hde1, 45030163kB, raid superblock at 45030080kB
mkraid: aborted, see the syslog and /proc/mdstat for potential clues.


syslog said:
kernel: hde: read_intr: status=0x59 { DriveReady SeekComplete 
DataRequest Error }
kernel: hde: read_intr: error=0x40 { UncorrectableError }, 
LBAsect=90060223, sector=90060160
kernel: end_request: I/O error, dev 21:01 (hde), sector 90060160





Its an IBM Deskstar 40gb. IBM provide a test program which also includes 
a 'sector repair' option, so I tried that (you have to put it on a 
floppy boot with it). Its scan results agreed with 'badblocks' - it then 
offered to try sector repair. At this point I accepted - but after a 
good go it said sector repair failed.




I accept that my RAID is on its last legs and needs rebuilding after a 
low-level format or drive replacement. I also accept that the few 
corrupted sectors mean I'll lose a few files. But I'd like to access the 
  rest of the 140gb RAID0 to salvage data off elsewhere.


Any suggestions?


Thanks
Neil

