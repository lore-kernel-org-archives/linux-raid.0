From: =?windows-1250?Q?Rainer_F=FCgenstein?= <rfu@oudeis.org>
Subject: kernel: BUG: soft lockup - CPU#1 stuck for 60s! [md0_raid5:1614]
Date: Thu, 15 Oct 2015 15:38:30 +0200
Message-ID: <1092031595.20151015153830@oudeis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1250
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

my  NAS-like  server with 5*3TB SATA drives in RAID5 configuration was
running  without  problems  for  what seems an eternity; since about 3
weeks it keeps freezing every other day with the following error:

# grep soft /var/log/messages
Oct 15 11:26:49 alfred kernel: BUG: soft lockup - CPU#1 stuck for 60s! [md0_raid5:1614]
Oct 15 11:26:49 alfred kernel:  [<ffffffff8005e298>] call_softirq+0x1c/0x28
Oct 15 11:26:49 alfred kernel:  [<ffffffff80012583>] __do_softirq+0x51/0x133
Oct 15 11:26:49 alfred kernel:  [<ffffffff8005e298>] call_softirq+0x1c/0x28
Oct 15 11:26:49 alfred kernel:  [<ffffffff8006d63a>] do_softirq+0x2c/0x7d
Oct 15 11:27:49 alfred kernel: BUG: soft lockup - CPU#1 stuck for 60s! [md0_raid5:1614]
Oct 15 11:27:49 alfred kernel:  [<ffffffff8005e298>] call_softirq+0x1c/0x28
Oct 15 11:27:49 alfred kernel:  [<ffffffff80012583>] __do_softirq+0x51/0x133
Oct 15 11:27:49 alfred kernel:  [<ffffffff8005e298>] call_softirq+0x1c/0x28
Oct 15 11:27:49 alfred kernel:  [<ffffffff8006d63a>] do_softirq+0x2c/0x7d
Oct 15 11:28:49 alfred kernel: BUG: soft lockup - CPU#1 stuck for 60s! [md0_raid5:1614]
Oct 15 11:28:49 alfred kernel:  [<ffffffff8005e298>] call_softirq+0x1c/0x28
Oct 15 11:28:49 alfred kernel:  [<ffffffff80012583>] __do_softirq+0x51/0x133
Oct 15 11:28:49 alfred kernel:  [<ffffffff8005e298>] call_softirq+0x1c/0x28
Oct 15 11:28:49 alfred kernel:  [<ffffffff8006d63a>] do_softirq+0x2c/0x7d
[...]
this  is  only  part  of  the story, check the end of this message for
a detailed log.

sometimes the server recovers after 60+ seconds, sometimes it requires
a hard reset (causing mdraid to re-sync the whole array).

IIRC,  it  started  when  a  drive  in  the  array  failed  with "SATA
connection  timeouts" (kind of). this drive has been replaced by a new
one, but yet the  CPU lockups keep coming.

I  suspect  that  aging  hardware  slowly starts to fail, but not sure
which part (drives? SATA controller? cables? NIC? CPU? ...)

here's some info that might be useful:
# uname -a
Linux alfred 2.6.18-406.el5 #1 SMP Tue Jun 2 17:25:57 EDT 2015 x86_64 x86_64 x86_64 GNU/Linux

# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sdb1[7] sdf1[3] sdc1[5] sde1[0] sdd1[8]
      11721061376 blocks super 1.2 level 5, 64k chunk, algorithm 2 [5/5] [UUUUU]
      [=>...................]  resync =  5.2% (154579584/2930265344) finish=3347.7min speed=13816K/sec

unused devices: <none>

excerpt:
ata9: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata9.00: ATA-8: WDC WD30EZRX-00MMMB0, 80.00A80, max UDMA/133
ata9.00: 5860533168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata9.00: configured for UDMA/133
sdb : very big device. try to use READ CAPACITY(16).
SCSI device sdb: 5860533168 512-byte hdwr sectors (3000593 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: drive cache: write back
sdb : very big device. try to use READ CAPACITY(16).
SCSI device sdb: 5860533168 512-byte hdwr sectors (3000593 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: drive cache: write back
 sdb: sdb1
sd 4:0:0:0: Attached scsi disk sdb
sd 4:0:0:0: Attached scsi generic sg1 type 0
  Vendor: ATA       Model: WDC WD30EZRX-00D  Rev: 80.0
  Type:   Direct-Access                      ANSI SCSI revision: 05

# lspci
00:00.0 Host bridge: Intel Corporation Atom Processor D4xx/D5xx/N4xx/N5xx DMI Bridge (rev 02)
00:02.0 VGA compatible controller: Intel Corporation Atom Processor D4xx/D5xx/N4xx/N5xx Integrated Graphics Controller (rev 02)
00:1c.0 PCI bridge: Intel Corporation NM10/ICH7 Family PCI Express Port 1 (rev 01)
00:1c.1 PCI bridge: Intel Corporation NM10/ICH7 Family PCI Express Port 2 (rev 01)
00:1c.2 PCI bridge: Intel Corporation NM10/ICH7 Family PCI Express Port 3 (rev 01)
00:1c.3 PCI bridge: Intel Corporation NM10/ICH7 Family PCI Express Port 4 (rev 01)
00:1d.0 USB controller: Intel Corporation NM10/ICH7 Family USB UHCI Controller #1 (rev 01)
00:1d.1 USB controller: Intel Corporation NM10/ICH7 Family USB UHCI Controller #2 (rev 01)
00:1d.2 USB controller: Intel Corporation NM10/ICH7 Family USB UHCI Controller #3 (rev 01)
00:1d.3 USB controller: Intel Corporation NM10/ICH7 Family USB UHCI Controller #4 (rev 01)
00:1d.7 USB controller: Intel Corporation NM10/ICH7 Family USB2 EHCI Controller (rev 01)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e1)
00:1f.0 ISA bridge: Intel Corporation NM10 Family LPC Controller (rev 01)
00:1f.2 SATA controller: Intel Corporation NM10/ICH7 Family SATA Controller [AHCI mode] (rev 01)
00:1f.3 SMBus: Intel Corporation NM10/ICH7 Family SMBus Controller (rev 01)
01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 03)
05:00.0 SCSI storage controller: Marvell Technology Group Ltd. MV88SX6081 8-port SATA II PCI-X Controller (rev 09)

# cat /proc/cpuinfo
[...]
processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 28
model name      :          Intel(R) Atom(TM) CPU D510   @ 1.66GHz
stepping        : 10
cpu MHz         : 1666.686
cache size      : 512 KB
physical id     : 0
siblings        : 2
core id         : 1
cpu cores       : 2
apicid          : 2
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx lm constant_tsc pni monitor ds_cpl tm2 ssse3 cx16 xtpr lahf_lm
bogomips        : 3333.36
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

 = = = detailed log:

Oct 15 11:27:49 alfred kernel: BUG: soft lockup - CPU#1 stuck for 60s! [md0_raid5:1614]
Oct 15 11:27:49 alfred kernel: CPU 1:
Oct 15 11:27:49 alfred kernel: Modules linked in: ip6table_filter ip6_tables ebtable_nat ebtables ipt_MASQUERADE iptable_nat ip_
nat xt_state ip_conntrack nfnetlink ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables bridge autofs4 ipv6 xfrm_nalgo crypto
_api xfs loop dm_multipath scsi_dh raid456 xor video backlight sbs power_meter hwmon i2c_ec dell_wmi wmi button battery asus_acp
i acpi_memhotplug ac parport_pc lp parport sg i2c_i801 i2c_core serio_raw tpm_tis pcspkr tpm sata_mv r8169 tpm_bios shpchp mii d
m_raid45 dm_message dm_region_hash dm_mem_cache dm_snapshot dm_zero dm_mirror dm_log dm_mod usb_storage ahci libata sd_mod scsi_
mod ext3 jbd uhci_hcd ohci_hcd ehci_hcd
Oct 15 11:27:49 alfred kernel: Pid: 1614, comm: md0_raid5 Not tainted 2.6.18-406.el5 #1
Oct 15 11:27:49 alfred kernel: RIP: 0010:[<ffffffff881d35a2>]  [<ffffffff881d35a2>] :r8169:rtl8169_interrupt+0x248/0x26f
Oct 15 11:27:49 alfred kernel: RSP: 0018:ffff81007eec7df8  EFLAGS: 00000206
Oct 15 11:27:49 alfred kernel: RAX: 0000000000000040 RBX: ffff81007de0a000 RCX: 0000000000000042
Oct 15 11:27:49 alfred kernel: RDX: 00000000ffe2001d RSI: ffffffff80047254 RDI: ffff81007de0a180
Oct 15 11:27:49 alfred kernel: RBP: ffff81007eec7d70 R08: 0000000000000003 R09: ffffffff8005e298
Oct 15 11:27:49 alfred kernel: R10: 0000000000000001 R11: 0000000000000060 R12: ffffffff8005dc9e
Oct 15 11:27:49 alfred kernel: R13: 0000000000000040 R14: ffffffff800796ae R15: ffff81007eec7d70
Oct 15 11:27:49 alfred kernel: FS:  0000000000000000(0000) GS:ffff81007ef179c0(0000) knlGS:0000000000000000
Oct 15 11:27:49 alfred kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Oct 15 11:27:49 alfred kernel: CR2: 00002b0a2bbba30c CR3: 00000000547e8000 CR4: 00000000000006a0
Oct 15 11:27:49 alfred kernel:
Oct 15 11:27:49 alfred kernel: Call Trace:
Oct 15 11:27:49 alfred kernel:  <IRQ>  [<ffffffff881d356b>] :r8169:rtl8169_interrupt+0x211/0x26f
Oct 15 11:27:49 alfred kernel:  [<ffffffff80010dc0>] handle_IRQ_event+0x51/0xa6
Oct 15 11:27:49 alfred kernel:  [<ffffffff800becc5>] __do_IRQ+0xfb/0x15b
Oct 15 11:27:49 alfred kernel:  [<ffffffff8006d4c5>] do_IRQ+0xe9/0xf7
Oct 15 11:27:49 alfred kernel:  [<ffffffff8005d625>] ret_from_intr+0x0/0xa
Oct 15 11:27:49 alfred kernel:  [<ffffffff8005e298>] call_softirq+0x1c/0x28
Oct 15 11:27:49 alfred kernel:  [<ffffffff80012583>] __do_softirq+0x51/0x133
Oct 15 11:27:49 alfred kernel:  [<ffffffff8005e298>] call_softirq+0x1c/0x28
Oct 15 11:27:49 alfred kernel:  [<ffffffff8006d63a>] do_softirq+0x2c/0x7d
Oct 15 11:27:49 alfred kernel:  [<ffffffff8005dc9e>] apic_timer_interrupt+0x66/0x6c
Oct 15 11:27:49 alfred kernel:  <EOI>  [<ffffffff80064b30>] _spin_unlock_irqrestore+0x8/0x9
Oct 15 11:27:49 alfred kernel:  [<ffffffff88075d16>] :scsi_mod:scsi_dispatch_cmd+0x207/0x2b1
Oct 15 11:27:49 alfred kernel:  [<ffffffff8807b926>] :scsi_mod:scsi_request_fn+0x2c3/0x392
Oct 15 11:27:49 alfred kernel:  [<ffffffff8014af49>] elv_insert+0xac/0x1c4
Oct 15 11:27:49 alfred kernel:  [<ffffffff8000c21c>] __make_request+0x47f/0x4ce
Oct 15 11:27:49 alfred kernel:  [<ffffffff8001c84f>] generic_make_request+0x211/0x228
Oct 15 11:27:49 alfred kernel:  [<ffffffff8001b125>] bio_alloc_bioset+0x89/0xd9
Oct 15 11:27:49 alfred kernel:  [<ffffffff800a3d99>] keventd_create_kthread+0x0/0xc4
Oct 15 11:27:49 alfred kernel:  [<ffffffff8003368c>] submit_bio+0xe6/0xed
Oct 15 11:27:49 alfred kernel:  [<ffffffff80222dfe>] md_update_sb+0x1af/0x23a
Oct 15 11:27:49 alfred kernel:  [<ffffffff8022812e>] md_check_recovery+0x15d/0x454
Oct 15 11:27:49 alfred kernel:  [<ffffffff8833549f>] :raid456:raid5d+0x15/0x182
Oct 15 11:27:49 alfred kernel:  [<ffffffff8003b13b>] prepare_to_wait+0x34/0x61
Oct 15 11:27:49 alfred kernel:  [<ffffffff80225acc>] md_thread+0xf8/0x10e
Oct 15 11:27:49 alfred kernel:  [<ffffffff800a3fb1>] autoremove_wake_function+0x0/0x2e
Oct 15 11:27:49 alfred kernel:  [<ffffffff802259d4>] md_thread+0x0/0x10e
Oct 15 11:27:49 alfred kernel:  [<ffffffff80032c1d>] kthread+0xfe/0x132
Oct 15 11:27:49 alfred kernel:  [<ffffffff8005dfc1>] child_rip+0xa/0x11
Oct 15 11:27:49 alfred kernel:  [<ffffffff800a3d99>] keventd_create_kthread+0x0/0xc4
Oct 15 11:27:49 alfred kernel:  [<ffffffff80032b1f>] kthread+0x0/0x132
Oct 15 11:27:49 alfred kernel:  [<ffffffff8005dfb7>] child_rip+0x0/0x11
Oct 15 11:27:49 alfred kernel:

Oct 15 11:28:14 alfred kernel: INFO: task pdflush:10294 blocked for more than 120 seconds.
Oct 15 11:28:14 alfred kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 15 11:28:14 alfred kernel: pdflush       D ffff810002536420     0 10294     27         10375  1706 (L-TLB)
Oct 15 11:28:14 alfred kernel:  ffff81006318baa0 0000000000000046 0000000000000003 0000000082147ce0
Oct 15 11:28:14 alfred kernel:  00900000000000d8 000000000000000a ffff8100614ff040 ffffffff8031db60
Oct 15 11:28:14 alfred kernel:  00004a61ef4e2a4e 0000000000008115 ffff8100614ff228 000000006166ea40
Oct 15 11:28:14 alfred kernel: Call Trace:
Oct 15 11:28:14 alfred kernel:  [<ffffffff80224647>] md_write_start+0xf2/0x108
Oct 15 11:28:14 alfred kernel:  [<ffffffff800a3fb1>] autoremove_wake_function+0x0/0x2e
Oct 15 11:28:14 alfred kernel:  [<ffffffff883cce08>] :xfs:xfs_page_state_convert+0x4f7/0x546
Oct 15 11:28:14 alfred kernel:  [<ffffffff88335db1>] :raid456:make_request+0x4e/0x4e3
Oct 15 11:28:14 alfred kernel:  [<ffffffff8001c84f>] generic_make_request+0x211/0x228
Oct 15 11:28:14 alfred kernel:  [<ffffffff800238ac>] mempool_alloc+0x31/0xe7
Oct 15 11:28:14 alfred kernel:  [<ffffffff8003368c>] submit_bio+0xe6/0xed
Oct 15 11:28:14 alfred kernel:  [<ffffffff883ce805>] :xfs:_xfs_buf_ioapply+0x1f2/0x254
Oct 15 11:28:14 alfred kernel:  [<ffffffff883ce8a0>] :xfs:xfs_buf_iorequest+0x39/0x64
Oct 15 11:28:14 alfred kernel:  [<ffffffff883b89e2>] :xfs:xlog_bdstrat_cb+0x16/0x3c
Oct 15 11:28:14 alfred kernel:  [<ffffffff883b99e4>] :xfs:xlog_sync+0x218/0x3ad
Oct 15 11:28:14 alfred kernel:  [<ffffffff883ba744>] :xfs:xlog_state_sync_all+0xb9/0x1d9
Oct 15 11:28:14 alfred kernel:  [<ffffffff883bacc7>] :xfs:_xfs_log_force+0x59/0x68
Oct 15 11:28:14 alfred kernel:  [<ffffffff883bace1>] :xfs:xfs_log_force+0xb/0x3f
Oct 15 11:28:14 alfred kernel:  [<ffffffff883c6587>] :xfs:xfs_syncsub+0x33/0x226
Oct 15 11:28:14 alfred kernel:  [<ffffffff800a3d99>] keventd_create_kthread+0x0/0xc4
Oct 15 11:28:14 alfred kernel:  [<ffffffff883d3cad>] :xfs:xfs_fs_write_super+0x1b/0x21
Oct 15 11:28:14 alfred kernel:  [<ffffffff800e8c5a>] sync_supers+0x80/0xe1
Oct 15 11:28:14 alfred kernel:  [<ffffffff8005697a>] pdflush+0x0/0x1fb
Oct 15 11:28:14 alfred kernel:  [<ffffffff800cdca0>] wb_kupdate+0x3e/0x16a
Oct 15 11:28:14 alfred kernel:  [<ffffffff8005697a>] pdflush+0x0/0x1fb
Oct 15 11:28:14 alfred kernel:  [<ffffffff80056acb>] pdflush+0x151/0x1fb
Oct 15 11:28:14 alfred kernel:  [<ffffffff800cdc62>] wb_kupdate+0x0/0x16a
Oct 15 11:28:14 alfred kernel:  [<ffffffff80032c1d>] kthread+0xfe/0x132
Oct 15 11:28:14 alfred kernel:  [<ffffffff8005dfc1>] child_rip+0xa/0x11
Oct 15 11:28:14 alfred kernel:  [<ffffffff800a3d99>] keventd_create_kthread+0x0/0xc4
Oct 15 11:28:14 alfred kernel:  [<ffffffff80032b1f>] kthread+0x0/0x132
Oct 15 11:28:14 alfred kernel:  [<ffffffff8005dfb7>] child_rip+0x0/0x11
Oct 15 11:28:14 alfred kernel:
Oct 15 11:28:14 alfred kernel: INFO: task md0_resync:13543 blocked for more than 120 seconds.
Oct 15 11:28:14 alfred kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 15 11:28:14 alfred kernel: md0_resync    D ffff810037f117f0     0 13543     27               10375 (L-TLB)
Oct 15 11:28:14 alfred kernel:  ffff81004dad3c50 0000000000000046 0000000000000001 0000000000000000
Oct 15 11:28:14 alfred kernel:  ffff81007eb6f5f0 000000000000000a ffff81005fe63080 ffff810037f117f0
Oct 15 11:28:14 alfred kernel:  00004a613eedffb5 00000000003a50b4 ffff81005fe63268 0000000000000003
Oct 15 11:28:14 alfred kernel: Call Trace:
Oct 15 11:28:14 alfred kernel:  [<ffffffff8002e493>] __wake_up+0x38/0x4f
Oct 15 11:28:14 alfred kernel:  [<ffffffff880756c0>] :scsi_mod:scsi_done+0x0/0x18
Oct 15 11:28:14 alfred kernel:  [<ffffffff88330dc5>] :raid456:get_active_stripe+0x242/0x4bd
Oct 15 11:28:14 alfred kernel:  [<ffffffff8008f4f9>] default_wake_function+0x0/0xe
Oct 15 11:28:14 alfred kernel:  [<ffffffff88335ccc>] :raid456:sync_request+0x6c0/0x757
Oct 15 11:28:14 alfred kernel:  [<ffffffff8807b9a0>] :scsi_mod:scsi_request_fn+0x33d/0x392
Oct 15 11:28:14 alfred kernel:  [<ffffffff801583ef>] __next_cpu+0x19/0x28
Oct 15 11:28:14 alfred kernel:  [<ffffffff80225f46>] md_do_sync+0x464/0x84b
Oct 15 11:28:14 alfred kernel:  [<ffffffff800a3d99>] keventd_create_kthread+0x0/0xc4
Oct 15 11:28:14 alfred kernel:  [<ffffffff80225acc>] md_thread+0xf8/0x10e
Oct 15 11:28:14 alfred kernel:  [<ffffffff800a3d99>] keventd_create_kthread+0x0/0xc4
Oct 15 11:28:14 alfred kernel:  [<ffffffff802259d4>] md_thread+0x0/0x10e
Oct 15 11:28:14 alfred kernel:  [<ffffffff80032c1d>] kthread+0xfe/0x132
Oct 15 11:28:14 alfred kernel:  [<ffffffff8005dfc1>] child_rip+0xa/0x11
Oct 15 11:28:14 alfred kernel:  [<ffffffff800a3d99>] keventd_create_kthread+0x0/0xc4
Oct 15 11:28:14 alfred kernel:  [<ffffffff80032b1f>] kthread+0x0/0x132
Oct 15 11:28:14 alfred kernel:  [<ffffffff8005dfb7>] child_rip+0x0/0x11
Oct 15 11:28:14 alfred kernel:

tnx & cu

-- 
Best regards,
 Rainer                          mailto:rfu@oudeis.org

