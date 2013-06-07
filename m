From: =?UTF-8?B?QXJrYWRpdXN6IEJ1YmHFgmE=?= <arkadiusz.bubala@open-e.com>
Subject: Call trace when creating new array in MegaRAID Storage Manager
Date: Fri, 07 Jun 2013 17:10:11 +0200
Message-ID: <51B1F7D3.4010507@open-e.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello,
I've got a problem with megaraid_sas driver and MegaRAID Storage=20
Manager.  When I create new array I get following call trace:

[  200.476010] BUG: unable to handle kernel NULL pointer dereference at=
=20
00000000000000b8
[  200.524556] IP: [<ffffffff814f1b37>] scsi_device_put+0x17/0x60
[  200.560613] PGD 5f794c067 PUD 6005de067 PMD 0
[  200.588325] Oops: 0000 [#1] SMP
[  200.608430] CPU 0
[  200.619792] Modules linked in: iscsi_scst(O) scst_vdisk(O) scst(O)=20
libcrc32c ext2 drbd(O) iscsi_tcp libiscsi_tcp libiscsi=20
scsi_transport_iscsi mpt2sas(O) scsi_transport_sas raid_class mptctl=20
mptbase bonding sg megaraid_sas(O) e1000e(O) usbserial uhci_hcd ohci_hc=
d=20
ehci_hcd aufs [last unloaded: megaraid_sas]
[  200.790885]
[  200.800069] Pid: 9569, comm: kworker/0:2 Tainted: G           O=20
3.4.47-oe64-00000-gbfd7af9 #28 Intel Corporation S1200BTL/S1200BTL
[  200.872854] RIP: 0010:[<ffffffff814f1b37>]  [<ffffffff814f1b37>]=20
scsi_device_put+0x17/0x60
[  200.953484] RSP: 0000:ffff88060052ddc0  EFLAGS: 00010286
[  201.016078] RAX: 0000000000000000 RBX: ffff8805f7a7c800 RCX:=20
0000000000011af4
[  201.090009] RDX: 0000000000011af3 RSI: 0000000000016558 RDI:=20
ffff8805f7a7c800
[  201.163762] RBP: ffff88060052ddd0 R08: 0000000000011af3 R09:=20
ffff880606c02400
[  201.237587] R10: ffffffff813d7bc5 R11: 00000000000163c0 R12:=20
ffff8805f7a7c800
[  201.311429] R13: ffff8806007084f0 R14: ffff880600708000 R15:=20
0000000000000000
[  201.385714] FS:  0000000000000000(0000) GS:ffff880607000000(0000)=20
knlGS:0000000000000000
[  201.466474] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  201.533205] CR2: 00000000000000b8 CR3: 00000006005c6000 CR4:=20
00000000000407f0
[  201.609236] DR0: 0000000000000000 DR1: 0000000000000000 DR2:=20
0000000000000000
[  201.684749] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:=20
0000000000000400
[  201.760140] Process kworker/0:2 (pid: 9569, threadinfo=20
ffff88060052c000, task ffff880602196740)
[  201.845650] Stack:
[  201.890482]  ffff8805f7a7c800 0000000000000004 ffff88060052de50=20
ffffffffa005336c
[  201.969957]  ffff88060052de10 ffff8805fdb50500 0000000000000000=20
ffffffff81420b20
[  202.049881]  ffff880600d31800 ffff880606c10400 ffff88060052de50=20
ffffffff8141b1c0
[  202.130160] Call Trace:
[  202.180506]  [<ffffffffa005336c>] megasas_aen_polling+0x28c/0x610=20
[megaraid_sas]
[  202.262680]  [<ffffffff81420b20>] ? bit_clear_margins+0x1b0/0x1b0
[  202.336430]  [<ffffffff8141b1c0>] ? fb_flashcursor+0x70/0x130
[  202.407431]  [<ffffffff810a030d>] process_one_work+0x10d/0x3a0
[  202.479553]  [<ffffffffa00530e0>] ? megasas_get_pd_list+0x400/0x400=20
[megaraid_sas]
[  202.563224]  [<ffffffff810a178a>] worker_thread+0xea/0x280
[  202.634822]  [<ffffffff810a16a0>] ? manage_workers+0x190/0x190
[  202.707888]  [<ffffffff810a5879>] kthread+0x99/0xb0
[  202.774324]  [<ffffffff817bb2e4>] kernel_thread_helper+0x4/0x10
[  202.846916]  [<ffffffff810a57e0>] ? flush_kthread_worker+0xb0/0xb0
[  202.921219]  [<ffffffff817bb2e0>] ? gs_change+0x13/0x13
[  202.989922] Code: 48 89 df c7 04 24 00 00 00 00 e8 a5 8f c1 ff e9 38=
=20
fe ff ff 55 48 89 e5 48 83 ec 10 4c 89 64 24 08 48 89 1c 24 49 89 fc 48=
=20
8b 07 <48> 8b 80 b8 00 00 00 48 8b 18 48 85 db 74 0d 48 89 df e8 12 f3
[  203.221134] RIP  [<ffffffff814f1b37>] scsi_device_put+0x17/0x60
[  203.293178]  RSP <ffff88060052ddc0>
[  203.350741] CR2: 00000000000000b8
[  203.406629] ---[ end trace cad1ef4253f2e576 ]---
[  203.470420]  sdb: unknown partition table
[  203.534405] sd 9:2:0:0: [sdb] Attached SCSI disk
[  203.614925] BUG: unable to handle kernel paging request at=20
fffffffffffffff8
[  203.691122] IP: [<ffffffff810a51ab>] kthread_data+0xb/0x20
[  203.758475] PGD 1c0e067 PUD 1c0f067 PMD 0
[  203.817698] Oops: 0000 [#2] SMP
[  203.871369] CPU 0
[  203.882735] Modules linked in: iscsi_scst(O) scst_vdisk(O) scst(O)=20
libcrc32c ext2 drbd(O) iscsi_tcp libiscsi_tcp libiscsi=20
scsi_transport_iscsi mpt2sas(O) scsi_transport_sas raid_class mptctl=20
mptbase bonding sg megaraid_sas(O) e1000e(O) usbserial uhci_hcd ohci_hc=
d=20
ehci_hcd aufs [last unloaded: megaraid_sas]
[  204.225102]
[  204.270216] Pid: 9569, comm: kworker/0:2 Tainted: G      D    O=20
3.4.47-oe64-00000-gbfd7af9 #28 Intel Corporation S1200BTL/S1200BTL
[  204.414715] RIP: 0010:[<ffffffff810a51ab>]  [<ffffffff810a51ab>]=20
kthread_data+0xb/0x20
[  204.499868] RSP: 0000:ffff88060052d928  EFLAGS: 00010092
[  204.569199] RAX: 0000000000000000 RBX: ffff880602196ae0 RCX:=20
ffffffff81e59e40
[  204.650245] RDX: 00000009ff57d93d RSI: 0000000000000000 RDI:=20
ffff880602196740
[  204.730791] RBP: ffff88060052d928 R08: 0000000000000000 R09:=20
0000000000000000
[  204.810732] R10: 0000000000000400 R11: 0000000000000000 R12:=20
0000000000000000
[  204.890208] R13: ffff8806038c0000 R14: ffff8806070136c0 R15:=20
0000000000000000
[  204.969578] FS:  0000000000000000(0000) GS:ffff880607000000(0000)=20
knlGS:0000000000000000
[  205.055405] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  205.126798] CR2: fffffffffffffff8 CR3: 000000060135e000 CR4:=20
00000000000407f0
[  205.206848] DR0: 0000000000000000 DR1: 0000000000000000 DR2:=20
0000000000000000
[  205.286878] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:=20
0000000000000400
[  205.366482] Process kworker/0:2 (pid: 9569, threadinfo=20
ffff88060052c000, task ffff880602196740)
[  205.456472] Stack:
[  205.505785]  ffff88060052d958 ffffffff8109ec35 0000000000000009=20
ffff880602196ae0
[  205.589335]  0000000000000009 ffff8806038c0000 ffff88060052da78=20
ffffffff817b16d9
[  205.672548]  ffff880602089130 ffff880602089100 000000000052d9a8=20
00000000000136c0
[  205.754879] Call Trace:
[  205.806271]  [<ffffffff8109ec35>] wq_worker_sleeping+0x15/0x80
[  205.878483]  [<ffffffff817b16d9>] __schedule+0x579/0x860
[  205.947281]  [<ffffffff810f4d02>] ? call_rcu_sched+0x12/0x20
[  206.018419]  [<ffffffff817b1ce5>] schedule+0x45/0x60
[  206.085229]  [<ffffffff8108961b>] do_exit+0x67b/0x980
[  206.152329]  [<ffffffff810867d5>] ? kmsg_dump+0xb5/0x100
[  206.220896]  [<ffffffff817b3907>] oops_end+0xe7/0xf0
[  206.286749]  [<ffffffff81070a43>] no_context+0x1b3/0x2c0
[  206.354142]  [<ffffffff81070e0d>] __bad_area_nosemaphore+0x12d/0x210
[  206.427816]  [<ffffffff810b233f>] ? finish_task_switch+0x4f/0xe0
[  206.499589]  [<ffffffff81070f8e>] bad_area_nosemaphore+0xe/0x10
[  206.571075]  [<ffffffff817b5f3e>] do_page_fault+0x29e/0x4d0
[  206.639632]  [<ffffffff8115abb7>] ? kfree+0x37/0x120
[  206.703332]  [<ffffffff813d7bc5>] ? kobject_release+0x55/0x90
[  206.770813]  [<ffffffff814ff9c6>] ?=20
scsi_device_dev_release_usercontext+0x186/0x1a0
[  206.849512]  [<ffffffff813d7a75>] ? kobject_put+0x35/0x70
[  206.915042]  [<ffffffff814c2552>] ? put_device+0x12/0x20
[  206.979323]  [<ffffffff814ff9d3>] ?=20
scsi_device_dev_release_usercontext+0x193/0x1a0
[  207.057596]  [<ffffffff817b2d65>] page_fault+0x25/0x30
[  207.119899]  [<ffffffff813d7bc5>] ? kobject_release+0x55/0x90
[  207.185406]  [<ffffffff814f1b37>] ? scsi_device_put+0x17/0x60
[  207.250384]  [<ffffffffa005336c>] megasas_aen_polling+0x28c/0x610=20
[megaraid_sas]
[  207.325800]  [<ffffffff81420b20>] ? bit_clear_margins+0x1b0/0x1b0
[  207.393399]  [<ffffffff8141b1c0>] ? fb_flashcursor+0x70/0x130
[  207.459086]  [<ffffffff810a030d>] process_one_work+0x10d/0x3a0
[  207.525397]  [<ffffffffa00530e0>] ? megasas_get_pd_list+0x400/0x400=20
[megaraid_sas]
[  207.602349]  [<ffffffff810a178a>] worker_thread+0xea/0x280
[  207.666389]  [<ffffffff810a16a0>] ? manage_workers+0x190/0x190
[  207.732026]  [<ffffffff810a5879>] kthread+0x99/0xb0
[  207.791813]  [<ffffffff817bb2e4>] kernel_thread_helper+0x4/0x10
[  207.858499]  [<ffffffff810a57e0>] ? flush_kthread_worker+0xb0/0xb0
[  207.926139]  [<ffffffff817bb2e0>] ? gs_change+0x13/0x13
[  207.987161] Code: 55 65 48 8b 04 25 c0 c6 00 00 48 8b 80 48 03 00 00=
=20
48 89 e5 8b 40 f0 c9 c3 66 66 66 90 66 66 90 48 8b 87 48 03 00 00 55 48=
=20
89 e5 <48> 8b 40 f8 c9 c3 66 66 66 90 66 66 66 90 66 66 66 90 66 66 90
[  208.197951] RIP  [<ffffffff810a51ab>] kthread_data+0xb/0x20
[  208.262038]  RSP <ffff88060052d928>
[  208.313041] CR2: fffffffffffffff8
[  208.362669] ---[ end trace cad1ef4253f2e577 ]---
[  208.420739] Fixing recursive fault but reboot is needed!

RAID is created but server hangs and needs hard reboot. I'm using=20
Intel(R) RAID Controller SRCSAS144E but problem occurs only on several=20
machines.

Resignation from removing device from the scsi bus when host is scanned=
=20
helped.  Below is mentioned workaround:


Index: megaraid_sas_base.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- megaraid_sas_base.c    (wersja 29950)
+++ megaraid_sas_base.c    (kopia robocza)
@@ -6800,7 +6800,6 @@
                      }
                  } else {
                      if (sdev1) {
-                        scsi_remove_device(sdev1);
                          scsi_device_put(sdev1);
                      }
                  }
@@ -6820,7 +6819,6 @@
                      }
                  } else {
                      if (sdev1) {
-                        scsi_remove_device(sdev1);
                          scsi_device_put(sdev1);
                      }
                  }

--=20
Best regards
Arkadiusz Buba=C5=82a
Open-E Poland Sp. z o.o.
www.open-e.com

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
