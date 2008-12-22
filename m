From: Richard Scobie <richard@sauce.co.nz>
Subject: md raid not starting
Date: Mon, 22 Dec 2008 14:32:05 +1300
Message-ID: <494EEE15.6050501@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

  Have installed a Fedora 9 system and added an Adaptec SCSI card with 2 
drives which are setup as an md RAID1.

After rebooting this RAID (md5) is not starting, as it appears from the 
boot messages that the SCSI drives are not yet ready.

How can I re order things to get this working - things are fine if I 
manually assemble the RAID and mount the XFS filesystem on it.

mdadm.conf

ARRAY /dev/md1 level=raid1 num-devices=2 
UUID=3cf9f628:040d973d:563daf00:6da845f4
ARRAY /dev/md2 level=raid1 num-devices=2 
UUID=f9083769:0177d5e0:57fd33b6:e462ea07
ARRAY /dev/md0 level=raid1 num-devices=2 
UUID=c8596959:1fd54b3b:4409423a:86337bfd
ARRAY /dev/md3 level=raid1 num-devices=2 
UUID=e6d0c240:48b46610:4a6643bf:f5fc7e04
ARRAY /dev/md4 level=raid1 num-devices=2 
UUID=29f85f0d:9ff9d921:505adc3f:7d8f7f3c
ARRAY /dev/md5 level=raid1 num-devices=2 
UUID=50a8a91e:1aec324a:b10b09cd:82dda111


md1, md2 and md3 are built on sda and sdb which are SATA drives and 
appear much earlier in the log.

Part of dmesg:

aic7xxx 0000:04:01.0: PCI INT A -> GSI 48 (level, low) -> IRQ 48
scsi4 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
<Adaptec 29160 Ultra160 SCSI adapter>
aic7892: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs

scsi 4:0:0:0: Direct-Access SEAGATE ST373455LW 0003 PQ: 0 ANSI: 3
scsi4:A:0:0: Tagged Queuing enabled. Depth 4
scsi target4:0:0: Beginning Domain Validation
scsi target4:0:0: wide asynchronous
scsi target4:0:0: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 63)
scsi target4:0:0: Ending Domain Validation
scsi 4:0:1:0: Direct-Access SEAGATE ST373455LW 0003 PQ: 0 ANSI: 3
scsi4:A:1:0: Tagged Queuing enabled. Depth 4
scsi target4:0:1: Beginning Domain Validation
scsi target4:0:1: wide asynchronous
scsi target4:0:1: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 63)
scsi target4:0:1: Ending Domain Validation
md: md1 stopped.
md: bind<sda2>
md: bind<sdb2>
raid1: raid set md1 active with 2 out of 2 mirrors
md: md2 stopped.
md: bind<sda3>
md: bind<sdb3>
raid1: raid set md2 active with 2 out of 2 mirrors
md: md3 stopped.
md: bind<sda5>
md: bind<sdb5>
raid1: raid set md3 active with 2 out of 2 mirrors
md: md5 stopped.
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: 
dm-devel@redhat.com
device-mapper: multipath: version 1.0.5 loaded
EXT3 FS on md4, internal journal
kjournald starting. Commit interval 5 seconds
EXT3 FS on md3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting. Commit interval 5 seconds
EXT3 FS on md2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
SGI XFS with ACLs, security attributes, large block numbers, no debug 
enabled
SGI XFS Quota Management subsystem
XFS: SB read failed
Adding 1003896k swap on /dev/md0. Priority:-1 extents:1 across:1003896k
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
firmware: requesting intel-ucode/0f-02-05
firmware: requesting intel-ucode/0f-02-05
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ADDRCONF(NETDEV_UP): eth0: link is not ready
e1000: eth0: e1000_watchdog: NIC Link is Up 1000 Mbps Full Duplex, Flow 
Control: RX/TX
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
sd 4:0:0:0: [sdc] 143374744 512-byte hardware sectors (73408 MB)
sd 4:0:0:0: [sdc] Write Protect is off
sd 4:0:0:0: [sdc] Mode Sense: ab 00 10 08
sd 4:0:0:0: [sdc] Write cache: enabled, read cache: enabled, supports 
DPO and FUA
sd 4:0:0:0: [sdc] 143374744 512-byte hardware sectors (73408 MB)
sd 4:0:0:0: [sdc] Write Protect is off
sd 4:0:0:0: [sdc] Mode Sense: ab 00 10 08
sd 4:0:0:0: [sdc] Write cache: enabled, read cache: enabled, supports 
DPO and FUA
sdc: sdc1
sd 4:0:0:0: [sdc] Attached SCSI disk
sd 4:0:0:0: Attached scsi generic sg3 type 0
sd 4:0:1:0: [sdd] 143374744 512-byte hardware sectors (73408 MB)
sd 4:0:1:0: [sdd] Write Protect is off
sd 4:0:1:0: [sdd] Mode Sense: ab 00 10 08
sd 4:0:1:0: [sdd] Write cache: enabled, read cache: enabled, supports 
DPO and FUA
sd 4:0:1:0: [sdd] 143374744 512-byte hardware sectors (73408 MB)
sd 4:0:1:0: [sdd] Write Protect is off
sd 4:0:1:0: [sdd] Mode Sense: ab 00 10 08
sd 4:0:1:0: [sdd] Write cache: enabled, read cache: enabled, supports 
DPO and FUA
sdd: sdd1
sd 4:0:1:0: [sdd] Attached SCSI disk
sd 4:0:1:0: Attached scsi generic sg4 type 0


Thanks,

Richard
