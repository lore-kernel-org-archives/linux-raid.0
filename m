From: Robey Holderith <robey@flaminglunchbox.net>
Subject: out of sync raid 5 + xfs = kernel startup problem
Date: Tue, 12 Apr 2005 21:59:58 -0400
Message-ID: <425C7D1E.30708@flaminglunchbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

My raid5 system recently went through a sequence of power outages.  When 
everything came back on the drives were out of sync.  No big issue... 
just sync them back up again.  But something is going wrong.  Any help 
is appreciated.  dmesg provides the following (the network stuff is 
mixed in):

md: raid5 personality registered as nr 4
raid5: automatically using best checksumming function: generic_sse
   generic_sse:  2444.000 MB/sec
raid5: using function: generic_sse (2444.000 MB/sec)
md: md driver 0.90.1 MAX_MD_DEVS=256, MD_SB_DISKS=27
NET: Registered protocol family 2
IP: routing cache hash table of 8192 buckets, 64Kbytes
TCP: Hash tables configured (established 262144 bind 65536)
NET: Registered protocol family 1
NET: Registered protocol family 10
IPv6 over IPv4 tunneling driver
NET: Registered protocol family 17
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.
VFS: Mounted root (ext2 filesystem) readonly.
Freeing unused kernel memory: 164k freed
md: raidstart(pid 220) used deprecated START_ARRAY ioctl. This will not 
be supported beyond 2.6
md: could not bd_claim sdf2.
md: autorun ...
md: considering sdd2 ...
md:  adding sdd2 ...
md:  adding sde2 ...
md:  adding sdf2 ...
md:  adding sdc2 ...
md:  adding sdb2 ...
md:  adding sda2 ...
md: created md0
md: bind<sda2>
md: bind<sdb2>
md: bind<sdc2>
md: bind<sdf2>
md: bind<sde2>
md: bind<sdd2>
md: running: <sdd2><sde2><sdf2><sdc2><sdb2><sda2>
md: kicking non-fresh sdd2 from array!
md: unbind<sdd2>
md: export_rdev(sdd2)
md: md0: raid array is not clean -- starting background reconstruction
raid5: device sde2 operational as raid disk 4
raid5: device sdf2 operational as raid disk 3
raid5: device sdc2 operational as raid disk 2
raid5: device sdb2 operational as raid disk 1
raid5: device sda2 operational as raid disk 0
raid5: cannot start dirty degraded array for md0
RAID5 conf printout:
 --- rd:6 wd:5 fd:1
 disk 0, o:1, dev:sda2
 disk 1, o:1, dev:sdb2
 disk 2, o:1, dev:sdc2
 disk 3, o:1, dev:sdf2
 disk 4, o:1, dev:sde2
raid5: failed to run raid set md0
md: pers->run() failed ...
md: do_md_run() returned -22
md: md0 stopped.
md: unbind<sde2>
md: export_rdev(sde2)
md: unbind<sdf2>
md: export_rdev(sdf2)
md: unbind<sdc2>
md: export_rdev(sdc2)
md: unbind<sdb2>
md: export_rdev(sdb2)
md: unbind<sda2>
md: export_rdev(sda2)
md: ... autorun DONE.
XFS: SB read failed
Unable to handle kernel NULL pointer dereference at 0000000000000000 RIP:
<ffffffff802c4d5d>{raid5_unplug_device+13}
PML4 3f691067 PGD 3f6ad067 PMD 0
Oops: 0000 [1]
CPU 0
Pid: 226, comm: mount Not tainted 2.6.10
RIP: 0010:[<ffffffff802c4d5d>] <ffffffff802c4d5d>{raid5_unplug_device+13}
RSP: 0018:000001003f66dab8  EFLAGS: 00010216
RAX: ffffffff802c4d50 RBX: 000001003f66daa0 RCX: 000001003f66dad8
RDX: 000001003f66dad8 RSI: 0000000000000000 RDI: 000001003fcacd10
RBP: 0000000000000000 R08: 0000000000000034 R09: 0000010002134b00
R10: 0000000000000200 R11: ffffffff802c4d50 R12: 000001003f66dad8
R13: 0000000000000001 R14: 000001003f440640 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffffffff8042d300(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000000101000 CR4: 00000000000006e0
Process mount (pid: 226, threadinfo 000001003f66c000, task 000001003f42eef0)
Stack: 0000000000000001 000001003f66daa0 000001003f66daa0 ffffffff8023c91a
       000001003f66dad8 000001003f66dad8 0000000000000005 000001003f6b7000
       0000000000000005 000001003f6b7800
Call Trace:<ffffffff8023c91a>{xfs_flush_buftarg+442} 
<ffffffff80231511>{xfs_mount+2465}
       <ffffffff80242560>{linvfs_fill_super+0} 
<ffffffff80242560>{linvfs_fill_super+0}
       <ffffffff80242613>{linvfs_fill_super+179} 
<ffffffff80242560>{linvfs_fill_super+0}
       <ffffffff802502d3>{snprintf+131} <ffffffff8024f40e>{strlcpy+78}
       <ffffffff801613fa>{sget+730} <ffffffff801619f0>{set_bdev_super+0}
       <ffffffff80242560>{linvfs_fill_super+0} 
<ffffffff80161b50>{get_sb_bdev+272}
       <ffffffff80161def>{do_kern_mount+111} 
<ffffffff8017596c>{do_mount+1548}
       <ffffffff80142c3e>{find_get_page+14} 
<ffffffff801438bc>{filemap_nopage+396}
       <ffffffff8015086c>{do_no_page+972} 
<ffffffff80150a00>{handle_mm_fault+320}
       <ffffffff801198b7>{do_page_fault+583} 
<ffffffff80146bdf>{__get_free_pages+31}
       <ffffffff80175d47>{sys_mount+151} 
<ffffffff8010cfaa>{system_call+126}
      

Code: 48 8b 5d 00 9c 8f 04 24 fa e8 b5 00 fb ff 85 c0 74 61 8b 43
RIP <ffffffff802c4d5d>{raid5_unplug_device+13} RSP <000001003f66dab8>
CR2: 0000000000000000
 <6>eth1: link up, 100Mbps, full-duplex, lpa 0x41E1
eth1: no IPv6 routers present

This may be posted to the wrong group... or perhaps it needs to be 
posted to both raid and xfs.  Any insights are welcomed.

-Robey

