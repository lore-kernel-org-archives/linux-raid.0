From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Subject: md: oops on dropping bitmaps from an array
Date: Mon, 30 Nov 2009 15:00:24 +0100
Message-ID: <200911301500.24223.a.miskiewicz@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


After reading http://etbe.coker.com.au/2008/01/28/write-intent-bitmaps/=
 wanted=20
to check
bitmaps, turned these on but  http://blog.liw.fi/posts/write-intent-bit=
maps/=20
caused me to do

mdadm --grow --bitmap=3Dnone /dev/md3

which ended with the oops below:

2.6.31.5, raid10 array

[2500705.083965] BUG: unable to handle kernel NULL pointer dereference =
at=20
(null)                                                                 =
           =20
[2500705.090142] IP: [<ffffffffa001387a>] bitmap_daemon_work+0x20a/0x50=
0=20
[md_mod]                                                               =
            =20
[2500705.090142] PGD 0                                                 =
                                                                       =
              =20
[2500705.090142] Oops: 0002 [#1] SMP                                   =
                                                                       =
              =20
[2500705.090142] last sysfs file:=20
/sys/devices/pci0000:00/0000:00:1e.0/0000:09:0c.0/local_cpus           =
                                                   =20
[2500705.090142] CPU 5                                                 =
                                                                       =
              =20
[2500705.090142] Modules linked in: pppoe pppox ppp_generic slhc config=
s=20
tcp_diag inet_diag ipmi_watchdog netconsole configfs sit tunnel4 sch_sf=
q ext3=20
jbd mbcache raid1 dm_mod e1000=20
e1000e ipmi_devintf ipmi_si ipmi_msghandler 8021q garp stp xfs exportfs=
 sd_mod=20
crc_t10dif mptsas mptscsih mptbase scsi_transport_sas scsi_mod raid10 m=
d_mod=20
[last unloaded: scsi_wait_scan]                                        =
                                                             =20
[2500705.090142] Pid: 1423, comm: md2_raid10 xid: #0 Not tainted 2.6.31=
=2E5-0.3=20
#1 S5000VSA                                                            =
       =20
[2500705.090142] RIP: 0010:[<ffffffffa001387a>]  [<ffffffffa001387a>]=20
bitmap_daemon_work+0x20a/0x500 [md_mod]                                =
               =20
[2500705.090142] RSP: 0018:ffff8801d6cffca0  EFLAGS: 00010046          =
                                                                       =
              =20
[2500705.090142] RAX: 0000000000000000 RBX: ffff8801b8aaff00 RCX:=20
ffff8801d76c82a0                                                       =
                   =20
[2500705.090142] RDX: 0000000000000001 RSI: 0000000000000246 RDI:=20
ffff8801b8aaff54                                                       =
                   =20
[2500705.090142] RBP: ffff8801d6cffcf0 R08: 0000000000000000 R09:=20
0008e260c60a0f7c                                                       =
                   =20
[2500705.090142] R10: 6f983d4c554e7d25 R11: 00000000ffffffff R12:=20
0000000000000000                                                       =
                   =20
[2500705.090142] R13: ffffea00040c4fa0 R14: 0000000000000246 R15:=20
0000000000000800                                                       =
                   =20
[2500705.090142] FS:  0000000000000000(0000) GS:ffff8800280af000(0000)=20
knlGS:0000000000000000                                                 =
              =20
[2500705.090142] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b     =
                                                                       =
              =20
[2500705.090142] CR2: 0000000000000000 CR3: 0000000107e95000 CR4:=20
00000000000006e0                                                       =
                   =20
[2500705.090142] DR0: 0000000000000000 DR1: 0000000000000000 DR2:=20
0000000000000000                                                       =
                   =20
[2500705.090142] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:=20
0000000000000400
[2500705.090142] Process md2_raid10 (pid: 1423, threadinfo ffff8801d6cf=
e000,=20
task ffff8801d6cf23a0)
[2500705.090142] Stack:
[2500705.090142]  ffff8801d6cffce0 ffff8801b8aaff54 ffff8800280c0140=20
faadb9534992dcbd
[2500705.090142] <0> ffff8800139dcd00 ffff8801d76c8000 ffff8801d90f5368=
=20
00000000000005b1
[2500705.090142] <0> ffff8801d6cffe80 ffff8801d90f5350 ffff8801d6cffd30=
=20
ffffffffa000da6b
[2500705.090142] Call Trace:
[2500705.090142]  [<ffffffffa000da6b>] md_check_recovery+0x3b/0x5c0 [md=
_mod]
[2500705.090142]  [<ffffffffa0024074>] cleanup_module+0x2d34/0x4140 [ra=
id10]
[2500705.090142]  [<ffffffff8146adff>] ? schedule_timeout+0x15f/0x220
[2500705.090142]  [<ffffffff81062740>] ? process_timeout+0x0/0x40
[2500705.090142]  [<ffffffffa000b9f4>] md_register_thread+0x1b4/0x2b0 [=
md_mod]
[2500705.090142]  [<ffffffff81074c50>] ? autoremove_wake_function+0x0/0=
x60
[2500705.090142]  [<ffffffffa000b9a0>] ? md_register_thread+0x160/0x2b0=
=20
[md_mod]
[2500705.090142]  [<ffffffff81074746>] kthread+0xb6/0xc0
[2500705.090142]  [<ffffffff810042da>] child_rip+0xa/0x20
[2500705.090142]  [<ffffffff81074690>] ? kthread+0x0/0xc0
[2500705.090142]  [<ffffffff810042d0>] ? child_rip+0x0/0x20
[2500705.090142] Code: e8 ac ee ff ff 8b 7b 50 85 ff 0f 85 8b 01 00 00 =
48 8b=20
7d b8 e8 a8 97 45 e1 49 8b 55 20 49 89 c6 48 8b 43 78 8d 14 95 01 00 00=
 00=20
<0f> b3 10 48 8b 4b 30 4c 89 e6 48 8d=20
55 c4 48 89 df 83 e9 09 48
[2500705.090142] RIP  [<ffffffffa001387a>] bitmap_daemon_work+0x20a/0x5=
00=20
[md_mod]
[2500705.090142]  RSP <ffff8801d6cffca0>
[2500705.090142] CR2: 0000000000000000
[2500705.090142] ---[ end trace 5a64b46437e34911 ]---

--=20
Arkadiusz Mi=C5=9Bkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
