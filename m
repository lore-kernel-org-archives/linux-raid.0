From: Sharif Islam <mislam@uiuc.edu>
Subject: Linear RAID Failure
Date: Wed, 28 Apr 2004 15:58:33 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40901AF9.90406@uiuc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a linear RAID setup with 6 drives(~120GB) on RH advanced server 
with 2.4.21-4.ELsmp.

DEVICE /dev/hde4 /dev/hdf4 /dev/hdg2 /dev/hdh2 /dev/hdk2 /dev/hdl2
ARRAY /dev/md0 level=linear num-devices=6

I noticed the following errors on syslog:

Apr 27 14:51:43 hdl: set_geometry_intr: status=0x51 { DriveReady 
SeekComplete Error }
Apr 27 14:52:18 hdl: recal_intr: error=0x00 { }
Apr 27 14:52:38 hdl: dma_timer_expiry: dma status == 0x41
Apr 27 14:52:48 hdl: error waiting for DMA
Apr 27 14:52:48 hdl: dma timeout retry: status=0x58 { DriveReady 
SeekComplete DataRequest }
Apr 27 14:52:53 hdl: status timeout: status=0xd1 { Busy }
[....]
Apr 27 14:54:26 set_rtc_mmss: can't update from 1 to 54
Apr 27 14:55:27 set_rtc_mmss: can't update from 2 to 55
Apr 27 14:56:28 set_rtc_mmss: can't update from 3 to 56
[.....]
Apr 28 04:06:33 end_request: I/O error, dev 39:02 (hdk), sector 145151511
Apr 28 04:06:33 end_request: I/O error, dev 39:42 (hdl), sector 101026704
Apr 28 04:06:33 end_request: I/O error, dev 39:02 (hdk), sector 145675792
Apr 28 04:06:37 end_reqc: unable to read inode block - inode=78561309, 
block=157122562
Apr 28 04:06:37 end_request: I/O error, dev 39:02 (hdk), sector 2807312
Apr 28 04:06:37 EXT3-fs error (device md(9,0)): ext
[....]

I did a reboot this morning. The array didn't get started. I saw the 
following error:
md0: former device hdk2 is unavailable, removing from array!
md0: former device hdl2 is unavailable, removing from array!
md0: max total readahead window set to 124k
md0: 1 data-disks, max readahead per data-disk: 124k
md: md0, array needs 6 disks, has 4, aborting.
linear: disks are not ordered, aborting!

I did a force start with :
mdadm -Afs /dev/md0 then a mount. The array came up fine. I am not sure 
if there were any data loss. I am currently doing a e2fsck -ycc 
/dev/md0. It will probably take another couple hours to get it done. I 
did notice several of these during the e2fsck.

Error reading block 175767553 (Attempt to read block from filesystem 
resulted in short read) while reading inode and block bitmaps.  Ignore 
error? yes

Force rewrite? yes
[....]

This is my DMA settings:
hdparm -d /dev/hd{e,f,g,h,k,l}

/dev/hde:
  using_dma    =  1 (on)
/dev/hdf:
  using_dma    =  1 (on)
/dev/hdg:
  using_dma    =  1 (on)
/dev/hdh:
  using_dma    =  1 (on)
/dev/hdk:
  using_dma    =  0 (off)
/dev/hdl:
  using_dma    =  0 (off)

What should I do at this point?

I have the data backed up from yesterday. Should I replace the hdk and 
hdl? Can I just do a remove from the linear raid and add the new disks? 
Or I need to recreate the array.

Thanks .
