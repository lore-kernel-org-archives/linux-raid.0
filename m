From: "nurit" <nurit@exanet.com>
Subject: multipath personality kernel oops when starting a virtual path with one of the physical paths unavailable
Date: Thu, 25 Apr 2002 16:59:49 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4913AB320D31DC4798D6FEF5F557351F07ABE4@hawk.exanet-il.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: "Linux-Raid (E-mail)" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> hi,
> 
> I'm using md multipath personality on linux 2.4.14 .
> 
> I'm seeing consistent kernel oops in the following
> configuration/scenario:
> 
I use 2 volumes each using 2 physical paths over qlogic2300 FC HBAs.

> our raidtab file:
> #############################################
> raiddev                 /dev/md0
> raid-level              multipath
> nr-raid-disks           2
> nr-spare-disks          0
> #chunk-size             4
> device                  /dev/scsi/host2/bus0/target0/lun0/part3
> raid-disk               0
> device                  /dev/scsi/host4/bus0/target0/lun0/part3
> spare-disk               1
> #############################################
> raiddev                 /dev/md2
> raid-level              multipath
> nr-raid-disks           2
> nr-spare-disks          0
> #chunk-size             4
> device                  /dev/scsi/host3/bus0/target0/lun0/part3
> raid-disk               0
> device                  /dev/scsi/host5/bus0/target0/lun0/part3
> raid-disk              1
> 
> 
> The syslog:
Apr 25 15:13:51 10.17.0.1 kernel: Attached scsi disk sda at scsi2,
channel 0, id 0, lun 0 
Apr 25 15:13:51 10.17.0.1 kernel: Attached scsi disk sdb at scsi2,
channel 0, id 0, lun 1 
Apr 25 15:13:51 10.17.0.1 kernel: Attached scsi disk sdc at scsi4,
channel 0, id 0, lun 0 
Apr 25 15:13:51 10.17.0.1 kernel: Attached scsi disk sdd at scsi4,
channel 0, id 0, lun 1 
Apr 25 15:13:51 10.17.0.1 kernel: Attached scsi disk sde at scsi5,
channel 0, id 0, lun 0 
Apr 25 15:13:51 10.17.0.1 kernel: Attached scsi disk sdf at scsi5,
channel 0, id 0, lun 1 
Apr 25 15:13:51 10.17.0.1 kernel: SCSI device sda: 70311936 512-byte
hdwr sectors (36000 MB) 
Apr 25 15:13:51 10.17.0.1 kernel: Partition check: 
Apr 25 15:13:51 10.17.0.1 kernel:  /dev/scsi/host2/bus0/target0/lun0: p3

Apr 25 15:13:51 10.17.0.1 kernel: SCSI device sdb: 70311936 512-byte
hdwr sectors (36000 MB) 
Apr 25 15:13:51 10.17.0.1 kernel:  /dev/scsi/host2/bus0/target0/lun1: p3

Apr 25 15:13:51 10.17.0.1 kernel: SCSI device sdc: 70311936 512-byte
hdwr sectors (36000 MB) 
Apr 25 15:13:51 10.17.0.1 kernel:  /dev/scsi/host4/bus0/target0/lun0: p3

Apr 25 15:13:51 10.17.0.1 kernel: SCSI device sdd: 70311936 512-byte
hdwr sectors (36000 MB) 
Apr 25 15:13:51 10.17.0.1 kernel:  /dev/scsi/host4/bus0/target0/lun1: p3

Apr 25 15:13:51 10.17.0.1 kernel: SCSI device sde: 70311936 512-byte
hdwr sectors (36000 MB) 
Apr 25 15:13:51 10.17.0.1 kernel:  /dev/scsi/host5/bus0/target0/lun0: p3

Apr 25 15:13:51 10.17.0.1 kernel: SCSI device sdf: 70311936 512-byte
hdwr sectors (36000 MB) 
Apr 25 15:13:51 10.17.0.1 kernel:  /dev/scsi/host5/bus0/target0/lun1: p3

Apr 25 15:13:51 10.17.0.1 kernel: md: multipath personality registered
as nr 7 

> Apr 25 15:16:54 10.17.0.1 modprobe: modprobe: Can't locate module
> block-major-248
> Apr 25 15:16:54 10.17.0.1 kernel: md: could not lock [dev f8:b0],
> zero-size? Marking faulty.
> Apr 25 15:16:54 10.17.0.1 kernel: md: could not import [dev f8:b0]!
> Apr 25 15:16:54 10.17.0.1 kernel: md: autostart [dev f8:b0] failed!
> Apr 25 15:16:54 10.17.0.1 kernel: XFS: SB read failed 
> Apr 25 15:16:54 10.17.0.1 kernel: I/O error in filesystem ("md(9,2)")
> meta-data dev 0x902 block 0x0
> Apr 25 15:16:54 10.17.0.1 kernel:        ("xfs_readsb") error 5 buf
> count 512  
> 
> Apr 25 15:16:59 10.17.0.1 kernel:  [events: 00000008]
> Apr 25 15:16:59 10.17.0.1 kernel:  [events: 00000008]
> Apr 25 15:16:59 10.17.0.1 kernel: md: autorun ...
> Apr 25 15:16:59 10.17.0.1 kernel: md: considering
> scsi/host5/bus0/target0/lun0/part3 ...
> Apr 25 15:16:59 10.17.0.1 kernel: md:  adding
> scsi/host5/bus0/target0/lun0/part3 ...
> Apr 25 15:16:59 10.17.0.1 kernel: md: created md2
> Apr 25 15:16:59 10.17.0.1 kernel: md:
> bind<scsi/host5/bus0/target0/lun0/part3,1>
> Apr 25 15:16:59 10.17.0.1 kernel: md: running:
> <scsi/host5/bus0/target0/lun0/part3>
> Apr 25 15:16:59 10.17.0.1 kernel: md:
> scsi/host5/bus0/target0/lun0/part3's event counter: 00000008
> Apr 25 15:16:59 10.17.0.1 kernel: md2: former device sdg3 is
> unavailable, removing from array!
> Apr 25 15:16:59 10.17.0.1 kernel: md2: former device
> scsi/host4/bus0/target0/lun0/part3 is unavailable, removing from
> array!
> Apr 25 15:17:00 10.17.0.1 kernel: md:
> unbind<scsi/host5/bus0/target0/lun0/part3,0>
> Apr 25 15:17:00 10.17.0.1 kernel: md:
> export_rdev(scsi/host5/bus0/target0/lun0/part3)
> Apr 25 15:17:00 10.17.0.1 kernel: md2: max total readahead window set
> to 124k
> Apr 25 15:17:00 10.17.0.1 kernel: md2: 1 data-disks, max readahead per
> data-disk: 124k
> Apr 25 15:17:01 10.17.0.1 kernel: Unable to handle kernel NULL pointer
> dereference at virtual address 0000003c
> Apr 25 15:17:01 10.17.0.1 kernel:  printing eip:
> Apr 25 15:17:01 10.17.0.1 kernel: f88366ab
> Apr 25 15:17:01 10.17.0.1 kernel: *pde = 00000000
> Apr 25 15:17:01 10.17.0.1 kernel: Oops: 0000
> Apr 25 15:17:01 10.17.0.1 kernel: CPU:    1
> Apr 25 15:17:01 10.17.0.1 kernel: EIP:
> 0010:[usb-ohci:sohci_device_operations+113215/81754549]    Not tainted
> Apr 25 15:17:01 10.17.0.1 kernel: EIP:    0010:[<f88366ab>]    Not
> tainted
> Apr 25 15:17:01 10.17.0.1 kernel: EFLAGS: 00010246
> Apr 25 15:17:01 10.17.0.1 kernel: eax: 00000000   ebx: f7ebf894   ecx:
> 00000000   edx: f759a000
> Apr 25 15:17:01 10.17.0.1 kernel: esi: f7ebf880   edi: f7ebf894   ebp:
> 00000000   esp: f37add60
> Apr 25 15:17:01 10.17.0.1 kernel: ds: 0018   es: 0018   ss: 0018
> Apr 25 15:17:01 10.17.0.1 kernel: Process raidstart (pid: 2179,
> stackpage=f37ad000)
> Apr 25 15:17:01 10.17.0.1 kernel: Stack: c50f79e0 c0305e6c c0146bdf
> f7ffe470 00000000 00000000 f7ebf894 0000000a
> Apr 25 15:17:01 10.17.0.1 kernel:        f36e8000 ffffffff c02aa5c2
> f759a000 c037dabf 0000007c 00000000 0000000a
> Apr 25 15:17:01 10.17.0.1 kernel:        ffffffff 00000002 000061a5
> c01155db 000061a5 000061a5 00000282 00000001
> Apr 25 15:17:01 10.17.0.1 kernel: Call Trace: [destroy_inode+31/48]
> [vsnprintf+674/1056] [call_console_drivers+219/240] [printk+296/320]
> [md:md_update_sb+3598/11904]
> Apr 25 15:17:01 10.17.0.1 kernel: Call Trace: [<c0146bdf>]
> [<c02aa5c2>] [<c01155db>] [<c0115788>] [<f882043e>]
> Apr 25 15:17:01 10.17.0.1 kernel:
> [md:__insmod_md_S.rodata_L8096+3424/8896]
> [md:__insmod_md_S.rodata_L8096+3360/8896] [md:md_update_sb+4364/11904]
> [call_console_drivers+219/240] [md:md_update_sb+5222/11904]
> [md:__insmod_md_S.rodata_L8096+1344/8896]
> Apr 25 15:17:01 10.17.0.1 kernel:    [<f8824740>] [<f8824700>]
> [<f882073c>] [<c01155db>] [<f8820a96>] [<f8823f20>]
> Apr 25 15:17:01 10.17.0.1 kernel:    [md:md_update_sb+5797/11904]
> [md:md_update_sb+6196/11904] [md:md_update_sb+10186/11904]
> [blkdev_open+37/48] [devfs_open+223/464] [dentry_open+230/400]
> Apr 25 15:17:01 10.17.0.1 kernel:    [<f8820cd5>] [<f8820e64>]
> [<f8821dfa>] [<c013a0e5>] [<c0167f5f>] [<c01333e6>]
> Apr 25 15:17:01 10.17.0.1 kernel:    [dput+65/336] [filp_open+77/96]
> [blkdev_ioctl+38/64] [sys_ioctl+455/512] [system_call+51/56]
> Apr 25 15:17:01 10.17.0.1 kernel:    [<c0145a21>] [<c01332ed>]
> [<c013a226>] [<c01418b7>] [<c0106f5b>]
> Apr 25 15:17:01 10.17.0.1 kernel:
> Apr 25 15:17:01 10.17.0.1 kernel: Code: 8b 55 3c 85 d2 0f 84 45 01 00
> 00 6a 00 8b 84 24 c8 00 00 00
> Apr 25 15:17:01 10.17.0.1 pcp: Note: computed HZ=100
> Apr 25 15:17:01 10.17.0.1 kernel:  XFS: SB read failed
> Apr 25 15:17:01 10.17.0.1 kernel: I/O error in filesystem ("md(9,0)")
> meta-data dev 0x900 block 0x0
> Apr 25 15:17:01 10.17.0.1 kernel:        ("xfs_readsb") error 5 buf
> count 512
> 
> 
> The scenario is:
> boot machine - including insmod md, multipath, qla2x00
> start md2
> start md0
> 
What we see is that "start md2" failed because one of it's paths
(/dev/scsi/host3/bus0/target0/lun0/part3) wasn't recognized at all after
qla2x00 was loaded (see syslog). BTW, why does the md reports "Can't
locate module block-major-248" ? 
The "start md0" process did find its disks, but md then started with
commands related to md2 and then we get a kernel oops in process
raidstart.

> does anyhow have any clue as to the reason this is happening?
> 
Thanks,
Nurit
