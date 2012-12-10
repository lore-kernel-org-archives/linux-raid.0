From: Joe Lawrence <Joe.Lawrence@stratus.com>
Subject: MD Raid1, ext4 and write same
Date: Mon, 10 Dec 2012 17:09:10 -0500 (EST)
Message-ID: <alpine.DEB.2.02.1212101704450.30895@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Joe Lawrence <joe.lawrence@stratus.com>
List-Id: linux-raid.ids

Hi all,

I have run into an issue running MD Raid 1 with 3.7rc7 and trying to 
mount a newly created ext4 FS.  It seems that the act of mounting ext4 
(among other FS operations I imagine) is creating WRITE SAME cmds that I 
don't believe MD currently supports.

Find my config setup below, along with repro steps and potential analysis.  
Perhaps I'm doing something wrong, but everything leads me to believe that 
MD is not properly handling these commands as passed down from the block 
layer.  The result are plain WRITE cmds that result in the driver claiming 
adapter status of MPI2_IOCSTATUS_INVALID_SGL (invalid scatter gather list 
I presume?).

Setup: 
* Fedora 17
* Kernel version: 3.7.0-rc7
* mdadm version: mdadm - v3.2.6 - 25th October 2012
* LSISAS2008: FWVersion(12.00.00.00), ChipRevision(0x03), 
BiosVersion(07.23.01.00)

Repro:
Create a RAID1 pair with an internal bitmap between two SAS disk 
partitions.  Create an ext4 filesystem, then mount it.

mdadm --verbose --create /dev/md105 --bitmap=internal --level=1 \
      --raid-devices=2 /dev/sdr1 /dev/sdu1
mkfs.ext4 /dev/md105
mount /dev/md105 /mnt/md105

Immediately after mounting (the initial mount), the message log reports:

EXT4-fs (md105): mounted filesystem with ordered data mode. Opts: (null)
sd 2:0:1:0: [sdu] Unhandled error code
sd 2:0:1:0: [sdu]  
Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
sd 2:0:1:0: [sdu] CDB: 
Write(10): 2a 00 00 04 39 08 00 10 00 00
end_request: I/O error, dev sdu, sector 276744
sd 1:0:1:0: [sdr] Unhandled error code
sd 1:0:1:0: [sdr]  
Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
sd 1:0:1:0: [sdr] CDB: 
Write(10): 2a 00 00 04 39 08 00 10 00 00
end_request: I/O error, dev sdr, sector 276744
md/raid1:md105: Disk failure on sdr1, disabling device.
md/raid1:md105: Operation continuing on 1 devices.
md105: WRITE SAME failed. Manually zeroing.
sd 2:0:1:0: [sdu] Unhandled error code
sd 2:0:1:0: [sdu]  
Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
sd 2:0:1:0: [sdu] CDB: 
Write(10): 2a 00 00 04 49 08 00 10 00 00
end_request: I/O error, dev sdu, sector 280840
md105: WRITE SAME failed. Manually zeroing.
sd 2:0:1:0: [sdu] Unhandled error code
sd 2:0:1:0: [sdu]  
Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
sd 2:0:1:0: [sdu] CDB: 
Write(10): 2a 00 00 04 59 08 00 10 00 00
end_request: I/O error, dev sdu, sector 284936
md105: WRITE SAME failed. Manually zeroing.

(mpt2sas log_info msgs trimmed.)


Relevent Commit History:

* block: Implement support for WRITE SAME
commit 4363ac7c13a9a4b763c6e8d9fdbfc2468f3b8ca4

Adds lim->max_write_same_sectors = UINT_MAX; to blk_set_stacking_limits()
  Called by drivers/md/md.c :: md_alloc()

Adds max_write_same_sectors limit check in blk_set_stacking_limits()
  Called by drivers/md/raid1.c :: raid1_add_disk(), run()

The net effect is the max_write_same_sectors limit associated with the MD 
device is the minimum of its component block devices. (In my case, both
component disks, 
/sys/block/sdX/device/scsi_disk/W:X:Y:Z/max_write_same_blocks report 
65536.)


* block: Make blkdev_issue_zeroout use WRITE SAME
commit 579e8f3c7b2ecf7db91398d942d76457a3ddba21

Adds a wrapper around blkdev_issue_zeroout() to create a WRITE SAME 
cmd if the block device's request queue limits max_write_same_sectors > 0.
  Called by ext4_init_inode_table during initial MD Raid1 ext4 mount.

In combination with the previous commit, ext4_init_inode_table will fire 
off WRITE SAME cmds, highlighting MD Raid1 non-support for this command.


I did try a potential fix that I will post seperately that zeroes out the 
max_write_same_sectors for the MD device before merging the component 
limits.  With that in place I could mount / copy / read with no issues.

Regards,

-- Joe
