From: David Nedved <david_nedved@yahoo.com>
Subject: new IDE drive returning errors - is drive bad?
Date: Thu, 1 Apr 2004 14:20:25 -0800 (PST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040401222025.75979.qmail@web40712.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi All,

Thanks very much for the two people who helped me figure out my problem
with autostarting RAIDs yesterday.  I have my system up and booting off
the SCSI RAID but cannot get a second RAID built out of new 120GB
Seagate IDE drives.  The drives seem to work fine, but a power failure
caused the RAID to need rebuilding, and the drives don't seem to be
able to handle the sustained I/O.  After about 15 minutes of
rebuilding, the rebuild fails due to drive errors.  I've tried
connecting the drives to both my HPT366 controller and the primary IDE
controller with the same results.  I saw that some of the messages were
DMA related to I tried using hdparm to turn DMA off on the drives, and
other than making it take approx 10x as long to fail, no big change.

This is a RedHat9 box fully updated running the latest kernel:
2.4.20-30.9smp.

Is this certainly a failure in the drive, or is there anything else I
can try before going through all the hassles of getting another drive? 
Does it look like it's just hdb that's bad?

Contents of messages during the failure are at the end of the message.

Thanks in advance!  Please copy me off the list as I'm not subscribed.

David

<with DMA turned on>

Apr  1 11:08:29 celeri kernel: md: syncing RAID array md2
Apr  1 11:08:29 celeri kernel: md: minimum _guaranteed_ reconstruction
speed: 100 KB/sec/disc.
Apr  1 11:08:29 celeri kernel: md: using maximum available idle IO
bandwith (but not more than 10000 KB/sec) for reconstruction.
Apr  1 11:08:29 celeri kernel: md: using 124k window, over a total of
117218176 blocks.
Apr  1 11:08:30 celeri kernel: md: hdb1 [events: 00000001]<6>(write)
hdb1's sb offset: 117218176
Apr  1 11:26:35 celeri kernel: hdb: dma_intr: status=0x51 { DriveReady
SeekComplete Error }
Apr  1 11:26:35 celeri kernel: hdb: dma_intr: error=0x40 {
UncorrectableError }, LBAsect=21622756, high=1, low=4845540,
sector=21622624
Apr  1 11:26:35 celeri kernel: end_request: I/O error, dev 03:41 (hdb),
sector 21622624
Apr  1 11:26:35 celeri kernel: raid1: Disk failure on hdb1, disabling
device.
Apr  1 11:26:35 celeri kernel: ^IOperation continuing on 1 devices
Apr  1 11:26:35 celeri kernel: raid1: mirror resync was not fully
finished, restarting next time.
Apr  1 11:26:35 celeri kernel: md: updating md2 RAID superblock on
device
Apr  1 11:26:35 celeri kernel: md: hdd1 [events: 00000002]<6>(write)
hdd1's sb offset: 117218176
Apr  1 11:26:35 celeri kernel: md: recovery thread got woken up ...
Apr  1 11:26:35 celeri kernel: md2: no spare disk to reconstruct array!
-- continuing in degraded mode
Apr  1 11:26:35 celeri kernel: md: (skipping faulty hdb1 )

<without DMA>
similar lines other than the following three:

Apr  1 13:23:53 celeri kernel: APIC error on CPU0: 08(02)
Apr  1 15:55:02 celeri kernel: hdb: read_intr: status=0x59 { DriveReady
SeekComplete DataRequest Error }
Apr  1 15:55:02 celeri kernel: hdb: read_intr: error=0x40 {
UncorrectableError }, LBAsect=21622751, high=1,
low=4845535, sector=21622688



=====
david_nedved@yahoo.com

__________________________________
Do you Yahoo!?
Yahoo! Small Business $15K Web Design Giveaway 
http://promotions.yahoo.com/design_giveaway/
