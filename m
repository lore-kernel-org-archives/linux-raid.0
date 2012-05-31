From: Andy Smith <andy@strugglers.net>
Subject: Can extremely high load cause disks to be kicked?
Date: Thu, 31 May 2012 08:31:58 +0000
Message-ID: <20120531083158.GE3867@bitfolk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

Last night a virtual machine on one of my servers was a victim of
DDoS. Given that the machine is routing packets to the VM, the
extremely high packets per second basically overwhelmed the CPU and
caused a lot of "BUG: soft lockup - CPU#0 stuck for XXs!" spew in
the logs.

So far nothing unusual for that type of event. However, a few
minutes in, I/O errors started to be generated which caused three of
the four disks in the raid10 to be kicked. Here's an excerpt:

May 30 18:24:49 blahblah kernel: [36534478.879311] BUG: soft lockup - CPU#0 stuck for 86s! [swapper:0]
May 30 18:24:49 blahblah kernel: [36534478.879311] Modules linked in: bridge ipv6 ipt_LOG xt_limit ipt_REJECT ipt_ULOG xt_multiport xt_tcpudp iptable_filter ip_tables x_tables ext2 fuse loop pcspkr i2c_i801 i2c_core container button evdev ext3 jbd mbcache dm_mirror dm_log dm_snapshot dm_mod raid10 raid1 md_mod ata_generic libata dock ide_pci_generic sd_mod it8213 ide_core e1000e mptsas mptscsih mptbase scsi_transport_sas scsi_mod thermal processor fan thermal_sys [last unloaded: scsi_wait_scan]
May 30 18:24:49 blahblah kernel: [36534478.879311] CPU 0:
May 30 18:24:49 blahblah kernel: [36534478.879311] Modules linked in: bridge ipv6 ipt_LOG xt_limit ipt_REJECT ipt_ULOG xt_multiport xt_tcpudp iptable_filter ip_tables x_tables ext2 fuse loop pcspkr i2c_i801 i2c_core container button evdev ext3 jbd mbcache dm_mirror dm_log dm_snapshot dm_mod raid10 raid1 md_mod ata_generic libata dock ide_pci_generic sd_mod it8213 ide_core e1000e mptsas mptscsih mptbase scsi_transport_sas scsi_mod thermal processor fan thermal_sys [last unloaded: scsi_wait_scan]
May 30 18:24:49 blahblah kernel: [36534478.879311] Pid: 0, comm: swapper Not tainted 2.6.26-2-xen-amd64 #1
May 30 18:24:49 blahblah kernel: [36534478.879311] RIP: e030:[<ffffffff802083aa>]  [<ffffffff802083aa>]
May 30 18:24:49 blahblah kernel: [36534478.879311] RSP: e02b:ffffffff80553f10  EFLAGS: 00000246
May 30 18:24:49 blahblah kernel: [36534478.879311] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffff802083aa
May 30 18:24:49 blahblah kernel: [36534478.879311] RDX: ffffffff80553f28 RSI: 0000000000000000 RDI: 0000000000000001
May 30 18:24:49 blahblah kernel: [36534478.879311] RBP: 0000000000631918 R08: ffffffff805cbc38 R09: ffff880001bc7ee0
May 30 18:24:49 blahblah kernel: [36534478.879311] R10: 0000000000631918 R11: 0000000000000246 R12: ffffffffffffffff
May 30 18:24:49 blahblah kernel: [36534478.879311] R13: ffffffff8057c580 R14: ffffffff8057d1c0 R15: 0000000000000000
May 30 18:24:49 blahblah kernel: [36534478.879311] FS:  00007f65b193a6e0(0000) GS:ffffffff8053a000(0000) knlGS:0000000000000000
May 30 18:24:49 blahblah kernel: [36534478.879311] CS:  e033 DS: 0000 ES: 0000
May 30 18:24:49 blahblah kernel: [36534478.879311] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
May 30 18:24:49 blahblah kernel: [36534478.879311] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
May 30 18:24:49 blahblah kernel: [36534478.879311] 
May 30 18:24:49 blahblah kernel: [36534478.879311] Call Trace:
May 30 18:24:49 blahblah kernel: [36534478.879311]  [<ffffffff8020e79d>] ? xen_safe_halt+0x90/0xa6
May 30 18:24:49 blahblah kernel: [36534478.879311]  [<ffffffff8020a0ce>] ? xen_idle+0x2e/0x66
May 30 18:24:49 blahblah kernel: [36534478.879311]  [<ffffffff80209d49>] ? cpu_idle+0x97/0xb9
May 30 18:24:49 blahblah kernel: [36534478.879311] 
May 30 18:24:59 blahblah kernel: [36534488.966594] mptscsih: ioc0: attempting task abort! (sc=ffff880039047480)
May 30 18:24:59 blahblah kernel: [36534488.966810] sd 0:0:1:0: [sdb] CDB: Synchronize Cache(10): 35 00 00 00 00 00 00 00 00 00
May 30 18:24:59 blahblah kernel: [36534488.967163] mptscsih: ioc0: task abort: SUCCESS (sc=ffff880039047480)
May 30 18:24:59 blahblah kernel: [36534488.970208] mptscsih: ioc0: attempting task abort! (sc=ffff8800348286c0)
May 30 18:24:59 blahblah kernel: [36534488.970519] sd 0:0:2:0: [sdc] CDB: Synchronize Cache(10): 35 00 00 00 00 00 00 00 00 00
May 30 18:24:59 blahblah kernel: [36534488.971033] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8800348286c0)
May 30 18:24:59 blahblah kernel: [36534488.974146] mptscsih: ioc0: attempting target reset! (sc=ffff880039047e80)
May 30 18:24:59 blahblah kernel: [36534488.974466] sd 0:0:0:0: [sda] CDB: Synchronize Cache(10): 35 00 00 00 00 00 00 00 00 00
May 30 18:25:00 blahblah kernel: [36534489.490138] mptscsih: ioc0: target reset: SUCCESS (sc=ffff880039047e80)
May 30 18:25:00 blahblah kernel: [36534489.493027] mptscsih: ioc0: attempting target reset! (sc=ffff880034828080)
May 30 18:25:00 blahblah kernel: [36534489.493027] sd 0:0:3:0: [sdd] CDB: Synchronize Cache(10): 35 00 00 00 00 00 00 00 00 00
May 30 18:25:00 blahblah kernel: [36534490.003961] mptscsih: ioc0: target reset: SUCCESS (sc=ffff880034828080)
May 30 18:25:00 blahblah kernel: [36534490.010870] end_request: I/O error, dev sdd, sector 581022718
May 30 18:25:00 blahblah kernel: [36534490.010870] md: super_written gets error=-5, uptodate=0
May 30 18:25:00 blahblah kernel: [36534490.010870] raid10: Disk failure on sdd5, disabling device.
May 30 18:25:00 blahblah kernel: [36534490.010870] raid10: Operation continuing on 3 devices.
May 30 18:25:00 blahblah kernel: [36534490.016887] end_request: I/O error, dev sda, sector 581022718
May 30 18:25:00 blahblah kernel: [36534490.017058] md: super_written gets error=-5, uptodate=0
May 30 18:25:00 blahblah kernel: [36534490.017212] raid10: Disk failure on sda5, disabling device.
May 30 18:25:00 blahblah kernel: [36534490.017213] raid10: Operation continuing on 2 devices.
May 30 18:25:00 blahblah kernel: [36534490.017562] end_request: I/O error, dev sdb, sector 581022718
May 30 18:25:00 blahblah kernel: [36534490.017730] md: super_written gets error=-5, uptodate=0
May 30 18:25:00 blahblah kernel: [36534490.017884] raid10: Disk failure on sdb5, disabling device.
May 30 18:25:00 blahblah kernel: [36534490.017885] raid10: Operation continuing on 1 devices.
May 30 18:25:00 blahblah kernel: [36534490.021015] end_request: I/O error, dev sdc, sector 581022718
May 30 18:25:00 blahblah kernel: [36534490.021015] md: super_written gets error=-5, uptodate=0

At this point the host was extremely upset. sd[abcd]5 were in use in
/dev/md3, but there were three other mdadm arrays using the same
disks and they were okay, so I wasn't suspecting actual hardware
failure as far as the disks went.

I used --add to add the devices back into md3, but they were added
as spares. I was stumped for a little while, then I decided to
--stop md3 and --create it again with --assume-clean. I got the
device order wrong the first few times but eventually I got there.

I then triggered a 'repair' at sync_action, and once that had
finished I started fscking things. There was a bit of corruption but
on the whole it seems to have been survivable.

Now, is this sort of behaviour expected when under incredible load?
Or is it indicative of a bug somewhere in kernel, mpt driver, or
even flaky SAS controller/disks?

Controller: LSISAS1068E B3, FwRev=011a0000h
Motherboard: Supermicro X7DCL-3
Disks: 4x SEAGATE  ST9300603SS      Version: 0006

While I'm familiar with the occasional big DDoS causing extreme CPU
load, hung tasks, CPU soft lockups etc., I've never had it kick
disks before. But I only have this one server with SAS and mdadm
whereas all the others are SATA and 3ware with BBU.

Root cause of failure aside, could I have made recovery easier? Was
there a better way than --create --assume-clean?

If I had done a --create with sdc5 (the device that stayed in the
array) and the other device with the closest event count, plus two
"missing", could I have expected less corruption when on 'repair'?

Cheers,
Andy
