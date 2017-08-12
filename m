From: Sarah Newman <srn@prgmr.com>
Subject: mpt3sas + raid10 kicked drives at reboot
Date: Sat, 12 Aug 2017 13:53:11 -0700
Message-ID: <0d5f3973-b9c6-bcfe-63c7-4d6c62529bfb@prgmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

With mostly vanilla 4.9.31 it looks like I had some problem with mpt3sas + md RAID10 on a device named md127. Because it happened at reboot I assume
there was some kind of race condition rather than there being a hardware issue.

md127 has an internal bitmap. There was also a DBRD device running on top of md127. I have a RAID1 on the same drives and there was no issue with it.
I had half of the drives on a 9200-8i card and half of the drives on a 9300-8i card. From my notes, the 9300-8i is the one that threw the drives. All
the drives on the 9300-8i were kicked and none of the ones on the 9200-8i were.

I will be looking into updates related to the 9300-8i but if anyone has insights as to why it would have happened with the RAID10 and not the RAID1
device I'd appreciate it.

init: Re-executing /sbin/init
[4780009.765708] EXT4-fs (md0): re-mounted. Opts: (null)
Please stand by while rebooting the system...
[4780010.980443] sd 8:0:2:0: [sdf] Synchronizing SCSI cache
[4780010.980788] sd 8:0:1:0: [sde] Synchronizing SCSI cache
[4780010.981089] sd 8:0:0:0: [sdd] Synchronizing SCSI cache
[Fri Aug 11 19:05:43 2017][4780010.981374] sd 7:0:2:0: [sdc] Synchronizing SCSI cache
[4780010.981614] sd 7:0:1:0: [sdb] Synchronizing SCSI cache
[4780010.981840] sd 7:0:0:0: [sda] Synchronizing SCSI cache
[4780010.982281] mpt3sas_cm0: sending message unit reset !!
[4780014.248128] drbd resource0: Discarding network configuration.
[4780014.248511] sd 8:0:2:0: [sdf] tag#0 FAILED Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[4780014.248750] sd 8:0:2:0: [sdf] tag#0 CDB: Synchronize Cache(10) 35 00 00 00 00 00 00 00 00 00
[4780014.248967] blk_update_request: I/O error, dev sdf, sector 20973584
[4780014.249123] md: super_written gets error=-5
[4780014.249231] md/raid10:md127: Disk failure on sdf2, disabling device.
[4780014.249231] md/raid10:md127: Operation continuing on 5 devices.
[4780014.249573] sd 8:0:1:0: [sde] tag#1 FAILED Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[4780014.249800] sd 8:0:1:0: [sde] tag#1 CDB: Synchronize Cache(10) 35 00 00 00 00 00 00 00 00 00
[4780014.250028] blk_update_request: I/O error, dev sde, sector 20973584
[4780014.250188] md: super_written gets error=-5
[4780014.250294] md/raid10:md127: Disk failure on sde2, disabling device.
[4780014.250294] md/raid10:md127: Operation continuing on 4 devices.
[4780014.250596] sd 8:0:0:0: [sdd] tag#2 FAILED Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[4780014.250808] sd 8:0:0:0: [sdd] tag#2 CDB: Synchronize Cache(10) 35 00 00 00 00 00 00 00 00 00
[4780014.251033] blk_update_request: I/O error, dev sdd, sector 20973584
[4780014.251201] md: super_written gets error=-5
[4780014.251307] md/raid10:md127: Disk failure on sdd2, disabling device.
[4780014.251307] md/raid10:md127: Operation continuing on 3 devices.
[4780014.253458] drbd resource0: Connection closed
[4780014.253816] drbd resource0: conn( Disconnecting -> StandAlone )
[4780014.254057] drbd resource0: receiver terminated
[4780014.254210] drbd resource0: Terminating drbd_r_resource
[4780034.718113] mpt3sas_cm0: _base_wait_for_doorbell_ack: failed due to timeout count(15000), int_status(c0000000)!
[4780034.718369] mpt3sas_cm0: message unit reset: FAILED
[4780034.718491] mpt3sas_cm0: sending diag reset !!
[4780035.690689] mpt3sas_cm0: diag reset: SUCCESS
[4780036.746631] mpt2sas_cm0: sending message unit reset !!
[4780036.747997] mpt2sas_cm0: message unit reset: SUCCESS
[4780037.019600] reboot: Restarting system

Thanks, Sarah
