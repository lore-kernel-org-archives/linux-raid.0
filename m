From: Arne Brutschy <abrutschy@xylon.de>
Subject: raid 5 crash and data loss
Date: Tue, 1 Jul 2003 16:42:47 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1937891098.20030701164247@xylon.de>
Reply-To: Arne Brutschy <abrutschy@xylon.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'm having some problems with my raid 5 device. The device is build
from 6 120gb ide disks. Last week, one of the disks (hdf) failed (due an
error in the hotswap rack, _NEVER_ buy cheap ones!!). As result the
channel got resetted. The problem is, that there are two disks on each
channel (I know, shame on me, but it's not possible to get 8 drives in
my server with a channel per drive (no free pci slots)). So the second
drive (hde) on the channel went down. I got an kernel panic and the
whole system hung.

I restarted the server. The raid couldn't be started because of
"kicking non fresh hde from array". The superblock on hde was out of
sync. But I didn't wrote any data to the raid, so it should be fine.
I used "mdadm -A /dev/md5 --force /dev/hd[c-h]5" to start up the
array. hde got added again, hdf was marked as failed, md6 was running.
I removed the faulty rack, reconnected hdf and the array started rebuilding.

The problem is that the data seems to be gone, or at least damaged.
I'm running reiserfs on the device, and reiserfsck reports "no
filesystem on disk".

Is there any possibility to get at least parts of the data back? I had
something around 450gb on the disk. :(

Can someone explain what was problem? I thought I was doing the right
thing and I have no idea at what point things went wrong.

Regards,
Arne Brutschy

PS: sorry for the long logs, but perhaps its neccessary

***LOG***

crash

Jun 26 20:14:24 gonzo kernel: hde: dma_timer_expiry: dma status == 0x61
Jun 26 20:14:34 gonzo kernel: hde: timeout waiting for DMA
Jun 26 20:14:34 gonzo kernel: PDC202XX: Primary channel reset.
Jun 26 20:14:34 gonzo kernel: hde: timeout waiting for DMA
Jun 26 20:14:34 gonzo kernel: hde: (__ide_dma_test_irq) called while not waiting
Jun 26 20:14:59 gonzo kernel: hdf: dma_timer_expiry: dma status == 0x40
Jun 26 20:14:59 gonzo kernel: hdf: timeout waiting for DMA
Jun 26 20:14:59 gonzo kernel: PDC202XX: Primary channel reset.
Jun 26 20:14:59 gonzo kernel: hdf: timeout waiting for DMA
Jun 26 20:14:59 gonzo kernel: hdf: (__ide_dma_test_irq) called while not waiting
Jun 26 20:14:59 gonzo kernel: hde: status timeout: status=0xd0 { Busy }
Jun 26 20:14:59 gonzo kernel:
Jun 26 20:14:59 gonzo kernel: PDC202XX: Primary channel reset.
Jun 26 20:14:59 gonzo kernel: hde: drive not ready for command
Jun 26 20:15:34 gonzo kernel: ide2: reset timed-out, status=0xd0
Jun 26 20:15:34 gonzo kernel: hdf: status error: status=0x50 { DriveReady SeekComplete }
Jun 26 20:15:34 gonzo kernel:
Jun 26 20:15:34 gonzo kernel: hdf: no DRQ after issuing WRITE
Jun 26 20:15:34 gonzo kernel: hde: status timeout: status=0xd0 { Busy }
Jun 26 20:15:34 gonzo kernel:
Jun 26 20:15:34 gonzo kernel: PDC202XX: Primary channel reset.
Jun 26 20:15:34 gonzo kernel: hde: drive not ready for command
Jun 26 20:16:04 gonzo kernel: ide2: reset timed-out, status=0xd0
Jun 26 20:16:04 gonzo kernel: hdf: status error: status=0x50 { DriveReady SeekComplete }
Jun 26 20:16:04 gonzo kernel:
Jun 26 20:16:04 gonzo kernel: hdf: no DRQ after issuing WRITE
Jun 26 20:16:04 gonzo kernel: blk: queue c0340408, I/O limit 4095Mb (mask 0xffffffff)
Jun 26 20:16:04 gonzo kernel: end_request: I/O error, dev 21:05 (hde), sector 159991808
Jun 26 20:16:04 gonzo kernel: raid5: Disk failure on hde5, disabling device. Operation continuing on 5 devices
Jun 26 20:16:04 gonzo kernel: md: updating md5 RAID superblock on device
Jun 26 20:16:04 gonzo kernel: md: hdh5 [events: 00000020]<6>(write) hdh5's sb offset: 120060736
Jun 26 20:16:04 gonzo kernel: md: recovery thread got woken up ...
Jun 26 20:16:04 gonzo kernel: md5: no spare disk to reconstruct array! -- continuing in degraded mode
Jun 26 20:16:04 gonzo kernel: md: recovery thread finished ...
Jun 26 20:16:04 gonzo kernel: md: hdg5 [events: 00000020]<6>(write) hdg5's sb offset: 120053568
Jun 26 20:16:04 gonzo kernel: md: hdf5 [events: 00000020]<6>(write) hdf5's sb offset: 120060736
..
Jun 26 20:16:34 gonzo kernel: hdf: lost interrupt
Jun 26 20:16:34 gonzo kernel: hdf: status error: status=0x50 { DriveReady SeekComplete }
Jun 26 20:16:34 gonzo kernel:
Jun 26 20:16:34 gonzo kernel: hdf: no DRQ after issuing WRITE
Jun 26 20:16:34 gonzo kernel: end_request: I/O error, dev 21:05 (hde), sector 159991816
Jun 26 20:16:34 gonzo kernel: hdf: status error: status=0x50 { DriveReady SeekComplete }
Jun 26 20:16:34 gonzo kernel:
Jun 26 20:16:34 gonzo kernel: hde: DMA disabled
Jun 26 20:16:34 gonzo kernel: PDC202XX: Primary channel reset.
Jun 26 20:16:34 gonzo kernel: hdf: no DRQ after issuing WRITE
Jun 26 20:17:04 gonzo kernel: ide2: reset timed-out, status=0xd0
Jun 26 20:17:04 gonzo kernel: hdf: status error: status=0x50 { DriveReady SeekComplete }
Jun 26 20:17:04 gonzo kernel:
Jun 26 20:17:04 gonzo kernel: hdf: no DRQ after issuing WRITE
Jun 26 20:17:04 gonzo kernel: end_request: I/O error, dev 21:05 (hde), sector 159991824
Jun 26 20:17:04 gonzo kernel: hdf: status error: status=0x50 { DriveReady SeekComplete }
Jun 26 20:17:04 gonzo kernel:
Jun 26 20:17:04 gonzo kernel: hdf: no DRQ after issuing WRITE
Jun 26 20:17:34 gonzo kernel: hdf: lost interrupt
Jun 26 20:17:34 gonzo kernel: hdf: status error: status=0x50 { DriveReady SeekComplete }
Jun 26 20:17:34 gonzo kernel:
Jun 26 20:17:34 gonzo kernel: hdf: no DRQ after issuing WRITE
Jun 26 20:17:34 gonzo kernel: end_request: I/O error, dev 21:05 (hde), sector 159988056
Jun 26 20:17:34 gonzo kernel: hdf: status error: status=0x50 { DriveReady SeekComplete }
Jun 26 20:17:34 gonzo kernel:
Jun 26 20:17:34 gonzo kernel: PDC202XX: Primary channel reset.
Jun 26 20:17:34 gonzo kernel: hdf: no DRQ after issuing WRITE
Jun 26 20:18:04 gonzo kernel: ide2: reset timed-out, status=0xd0
Jun 26 20:18:04 gonzo kernel: blk: queue c0340544, I/O limit 4095Mb (mask 0xffffffff)
Jun 26 20:18:04 gonzo kernel: end_request: I/O error, dev 21:45 (hdf), sector 159991832
Jun 26 20:18:04 gonzo kernel: raid5: Disk failure on hdf5, disabling device. Operation continuing on 4 devices
Jun 26 20:18:04 gonzo kernel: end_request: I/O error, dev 21:05 (hde), sector 159988064
Jun 26 20:18:04 gonzo kernel: end_request: I/O error, dev 21:45 (hdf), sector 159991840
Jun 26 20:18:04 gonzo kernel: end_request: I/O error, dev 21:45 (hdf), sector 159991848
Jun 26 20:18:04 gonzo kernel: end_request: I/O error, dev 21:45 (hdf), sector 159991856
Jun 26 20:18:04 gonzo kernel: end_request: I/O error, dev 21:45 (hdf), sector 159991864
Jun 26 20:18:04 gonzo kernel: end_request: I/O error, dev 21:45 (hdf), sector 6976
Jun 26 20:18:04 gonzo kernel: end_request: I/O error, dev 21:45 (hdf), sector 240121472
Jun 26 20:18:04 gonzo kernel: md: recovery thread got woken up ...
Jun 26 20:18:04 gonzo kernel: md: updating md5 RAID superblock on device
Jun 26 20:18:04 gonzo kernel: md: hdh5 [events: 00000021]<6>(write) hdh5's sb offset: 120060736
Jun 26 20:18:04 gonzo kernel: md: write_disk_sb failed for device hdf5
Jun 26 20:18:04 gonzo kernel: md: (skipping faulty hde5 )
Jun 26 20:18:04 gonzo kernel: md: hdd5 [events: 00000021]<6>(write) hdd5's sb offset: 117246400
Jun 26 20:18:05 gonzo kernel: md: hdc5 [events: 00000021]<6>(write) hdc5's sb offset: 117246400
Jun 26 20:18:05 gonzo kernel: md: hdg5 [events: 00000021]<6>(write) hdg5's sb offset: 120053568
Jun 26 20:18:05 gonzo kernel: md: errors occurred during superblock update, repeating
Jun 26 20:18:05 gonzo kernel: md: updating md5 RAID superblock on device
Jun 26 20:18:05 gonzo kernel: md: hdh5 [events: 00000022]<6>(write) hdh5's sb offset: 120060736
Jun 26 20:18:05 gonzo kernel: md: (skipping faulty hdf5 )
Jun 26 20:18:05 gonzo kernel: md: (skipping faulty hde5 )
Jun 26 20:18:05 gonzo kernel: md: hdd5 [events: 00000022]<6>(write) hdd5's sb offset: 117246400
Jun 26 20:18:05 gonzo kernel: md: hdg5 [events: 00000022]<6>(write) hdg5's sb offset: 120053568
Jun 26 20:18:05 gonzo kernel: md: hdc5 [events: 00000022]<6>(write) hdc5's sb offset: 117246400
Jun 26 20:18:05 gonzo kernel: md: (skipping faulty hdf5 )
Jun 26 20:18:05 gonzo kernel: md: (skipping faulty hde5 )
Jun 26 20:18:05 gonzo kernel: md: hdd5 [events: 00000022]<6>(write) hdd5's sb offset: 117246400
Jun 26 20:18:05 gonzo kernel: md5: no spare disk to reconstruct array! -- continuing in degraded mode
Jun 26 20:18:05 gonzo kernel: md: recovery thread finished ...
Jun 26 20:18:05 gonzo kernel: md: hdc5 [events: 00000022]<6>(write) hdc5's sb offset: 117246400
Jun 26 20:18:05 gonzo kernel: journal-601, buffer write failed
Jun 26 20:18:05 gonzo kernel: kernel BUG at prints.c:334!
Jun 26 20:18:05 gonzo kernel: invalid operand: 0000
Jun 26 20:18:05 gonzo kernel: CPU:    0
Jun 26 20:18:05 gonzo kernel: EIP:    0010:[<c019fa58>]    Tainted: P
Jun 26 20:18:05 gonzo kernel: EFLAGS: 00010282
Jun 26 20:18:05 gonzo kernel: eax: 00000024   ebx: def60800   ecx: 00000001   edx: c02b5ffc
Jun 26 20:18:05 gonzo kernel: esi: 00000000   edi: def60800   ebp: 00000007   esp: c1591ec0
Jun 26 20:18:05 gonzo kernel: ds: 0018   es: 0018   ss: 0018
Jun 26 20:18:05 gonzo kernel: Process kupdated (pid: 7, stackpage=c1591000)
Jun 26 20:18:05 gonzo kernel: Stack: c027c8f5 c0327220 def60800 e0b1460c c01aadba def60800 c0289520 00001000
Jun 26 20:18:05 gonzo kernel:        da263780 0000000a 00000008 00000000 ceac7880 00000000 00000014 c9675000
Jun 26 20:18:05 gonzo kernel:        00000004 c01aeee1 def60800 e0b1460c 00000001 00000006 e0b1d1bc 00000004
Jun 26 20:18:05 gonzo kernel: Call Trace:    [<c01aadba>] [<c01aeee1>] [<c01ae095>] [<c019c8b0>] [<c013f64b>]
Jun 26 20:18:06 gonzo kernel:   [<c013eb2c>] [<c013ee21>] [<c0105000>] [<c0105000>] [<c010577e>] [<c013ed50>]
Jun 26 20:18:06 gonzo kernel:
Jun 26 20:18:06 gonzo kernel: Code: 0f 0b 4e 01 8e fa 27 c0 85 db 74 0e 0f b7 43 08 89 04 24 e8

after crash

Jun 27 00:08:09 gonzo kernel: md: running: <hdh5><hdg5><hdf5><hde5><hdd5><hdc5>
Jun 27 00:08:09 gonzo kernel: md: hdh5's event counter: 00000022
Jun 27 00:08:09 gonzo kernel: md: hdg5's event counter: 00000022
Jun 27 00:08:09 gonzo kernel: md: hdf5's event counter: 0000001f
Jun 27 00:08:09 gonzo kernel: md: hde5's event counter: 0000001f
Jun 27 00:08:09 gonzo kernel: md: hdd5's event counter: 00000022
Jun 27 00:08:09 gonzo kernel: md: hdc5's event counter: 00000022
Jun 27 00:08:09 gonzo kernel: md: superblock update time inconsistency -- using the most recent one
Jun 27 00:08:09 gonzo kernel: md: freshest: hdh5
Jun 27 00:08:09 gonzo kernel: md: kicking non-fresh hdf5 from array!
Jun 27 00:08:09 gonzo kernel: md: unbind<hdf5,5>
Jun 27 00:08:09 gonzo kernel: md: export_rdev(hdf5)
Jun 27 00:08:09 gonzo kernel: md: kicking non-fresh hde5 from array!
Jun 27 00:08:09 gonzo kernel: md: unbind<hde5,4>
Jun 27 00:08:09 gonzo kernel: md: export_rdev(hde5)
Jun 27 00:08:09 gonzo kernel: md5: removing former faulty hde5!
Jun 27 00:08:09 gonzo kernel: md5: removing former faulty hdf5!

