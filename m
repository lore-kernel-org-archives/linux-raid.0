From: Jinpu Wang <jinpu.wang@profitbricks.com>
Subject: [BUG] MD/RAID1 hung forever on freeze_array
Date: Fri, 25 Nov 2016 14:30:32 +0100
Message-ID: <CAMGffE=1kp7gMhG+dFxTvhD6VkRuSfbuXbf9vYSWwGG+=vvhDA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>
Cc: Neil Brown <neilb@suse.de>, Nate Dailey <nate.dailey@stratus.com>
List-Id: linux-raid.ids

Hi,

I'm hitting hung task in mdx_raid1 when running test, I can reproduce
it easily with my tests below:

I create one md with one local loop device and one remote scsi
exported by SRP. running fio with mix rw on top of md, force_close
session on storage side. mdx_raid1 is wait on free_array in D state,
and a lot of fio also in D state in wait_barrier.

[  335.154711] blk_update_request: I/O error, dev sdb, sector 8
[  335.154855] md: super_written gets error=3D-5
[  335.154999] md/raid1:md1: Disk failure on sdb, disabling device.
               md/raid1:md1: Operation continuing on 1 devices.
[  335.155258] sd 1:0:0:0: rejecting I/O to offline device
[  335.155402] blk_update_request: I/O error, dev sdb, sector 80
[  335.155547] md: super_written gets error=3D-5
[  340.158828] scsi host1: ib_srp: reconnect succeeded
[  373.017608] md/raid1:md1: redirecting sector 616617 to other mirror: loo=
p1
[  373.110527] md/raid1:md1: redirecting sector 1320893 to other mirror: lo=
op1
[  373.117230] md/raid1:md1: redirecting sector 1564499 to other mirror: lo=
op1
[  373.127652] md/raid1:md1: redirecting sector 104034 to other mirror: loo=
p1
[  373.135665] md/raid1:md1: redirecting sector 1209765 to other mirror: lo=
op1
[  373.145634] md/raid1:md1: redirecting sector 51200 to other mirror: loop=
1
[  373.158824] md/raid1:md1: redirecting sector 755750 to other mirror: loo=
p1
[  373.169964] md/raid1:md1: redirecting sector 1681631 to other mirror: lo=
op1
[  373.178619] md/raid1:md1: redirecting sector 1894296 to other mirror: lo=
op1
[  373.186153] md/raid1:md1: redirecting sector 1905016 to other mirror: lo=
op1
[  374.364370] RAID1 conf printout:
[  374.364377]  --- wd:1 rd:2
[  374.364379]  disk 0, wo:1, o:0, dev:sdb
[  374.364381]  disk 1, wo:0, o:1, dev:loop1
[  374.437099] RAID1 conf printout:
[  374.437103]  --- wd:1 rd:2
snip


[  810.266112] sysrq: SysRq : Show Blocked State
[  810.266235]   task                        PC stack   pid father
[  810.266362] md1_raid1       D ffff88022d927c48     0  4022      2 0x0000=
0000
[  810.266487]  ffff88022d927c48 ffff8802351a0000 ffff8800b91bc100
000000008010000e
[  810.266747]  ffff88022d927c30 ffff88022d928000 0000000000000001
ffff880233b49b70
[  810.266975]  ffff880233b49b88 ffff8802325d5a40 ffff88022d927c60
ffffffff81810600
[  810.267203] Call Trace:
[  810.267322]  [<ffffffff81810600>] schedule+0x30/0x80
[  810.267437]  [<ffffffffa01342c1>] freeze_array+0x71/0xc0 [raid1]
[  810.267555]  [<ffffffff81095480>] ? wake_atomic_t_function+0x70/0x70
[  810.267669]  [<ffffffffa013578b>] handle_read_error+0x3b/0x570 [raid1]
[  810.267816]  [<ffffffff81185783>] ? kmem_cache_free+0x183/0x190
[  810.267929]  [<ffffffff81094e36>] ? __wake_up+0x46/0x60
[  810.268045]  [<ffffffffa0136dcd>] raid1d+0x20d/0xfc0 [raid1]
[  810.268159]  [<ffffffff81813043>] ? schedule_timeout+0x1a3/0x230
[  810.268274]  [<ffffffff8180fe77>] ? __schedule+0x2e7/0xa40
[  810.268391]  [<ffffffffa0211839>] md_thread+0x119/0x120 [md_mod]
[  810.268508]  [<ffffffff81095480>] ? wake_atomic_t_function+0x70/0x70
[  810.268624]  [<ffffffffa0211720>] ? find_pers+0x70/0x70 [md_mod]
[  810.268741]  [<ffffffff81075614>] kthread+0xc4/0xe0
[  810.268853]  [<ffffffff81075550>] ? kthread_worker_fn+0x150/0x150
[  810.268970]  [<ffffffff8181415f>] ret_from_fork+0x3f/0x70
[  810.269114]  [<ffffffff81075550>] ? kthread_worker_fn+0x150/0x150
[  810.269227] fio             D ffff8802325137a0     0  4212   4206 0x0000=
0000
[  810.269347]  ffff8802325137a0 ffff88022de3db00 ffff8800ba7bb400
0000000000000000
[  810.269574]  ffff880233b49b00 ffff880232513788 ffff880232514000
ffff880233b49b88
[  810.269801]  ffff880233b49b70 ffff8800ba7bb400 ffff8800b5f5db00
ffff8802325137b8
[  810.270028] Call Trace:
[  810.270138]  [<ffffffff81810600>] schedule+0x30/0x80
[  810.270282]  [<ffffffffa0133727>] wait_barrier+0x117/0x1f0 [raid1]
[  810.270396]  [<ffffffff81095480>] ? wake_atomic_t_function+0x70/0x70
[  810.270513]  [<ffffffffa0135d72>] make_request+0xb2/0xd80 [raid1]
[  810.270628]  [<ffffffffa02123fc>] md_make_request+0xec/0x230 [md_mod]
[  810.270746]  [<ffffffff813f96f9>] ? generic_make_request_checks+0x219/0x=
500
[  810.270860]  [<ffffffff813fc851>] blk_prologue_bio+0x91/0xc0
[  810.270976]  [<ffffffff813fc230>] generic_make_request+0xe0/0x1b0
[  810.271090]  [<ffffffff813fc362>] submit_bio+0x62/0x140
[  810.271209]  [<ffffffff811d2bbc>] do_blockdev_direct_IO+0x289c/0x33c0
[  810.271323]  [<ffffffff81810600>] ? schedule+0x30/0x80
[  810.271468]  [<ffffffff811cd620>] ? I_BDEV+0x10/0x10
[  810.271580]  [<ffffffff811d371e>] __blockdev_direct_IO+0x3e/0x40
[  810.271696]  [<ffffffff811cdfb7>] blkdev_direct_IO+0x47/0x50
[  810.271828]  [<ffffffff81132cbf>] generic_file_read_iter+0x44f/0x570
[  810.271949]  [<ffffffff811ceaa0>] ? blkdev_write_iter+0x110/0x110
[  810.272062]  [<ffffffff811cead0>] blkdev_read_iter+0x30/0x40
[  810.272179]  [<ffffffff811de5a6>] aio_run_iocb+0x126/0x2b0
[  810.272291]  [<ffffffff8181209d>] ? mutex_lock+0xd/0x30
[  810.272407]  [<ffffffff811ddd04>] ? aio_read_events+0x284/0x370
[  810.272521]  [<ffffffff81183c29>] ? kmem_cache_alloc+0xd9/0x180
[  810.272665]  [<ffffffff811df438>] ? do_io_submit+0x178/0x4a0
[  810.272778]  [<ffffffff811df4ed>] do_io_submit+0x22d/0x4a0
[  810.272895]  [<ffffffff811df76b>] SyS_io_submit+0xb/0x10
[  810.273007]  [<ffffffff81813e17>] entry_SYSCALL_64_fastpath+0x12/0x66
[  810.273130] fio             D ffff88022fa6f730     0  4213   4206 0x0000=
0000
[  810.273247]  ffff88022fa6f730 ffff8800b549a700 ffff8800af703400
0000000002011200
[  810.273475]  ffff880236001700 ffff88022fa6f718 ffff88022fa70000
ffff880233b49b88
[  810.273702]  ffff880233b49b70 ffff8800af703400 ffff88022f843700
ffff88022fa6f748
[  810.273958] Call Trace:
[  810.274070]  [<ffffffff81810600>] schedule+0x30/0x80
[  810.274183]  [<ffffffffa0133727>] wait_barrier+0x117/0x1f0 [raid1]
[  810.274300]  [<ffffffff81095480>] ? wake_atomic_t_function+0x70/0x70
[  810.274413]  [<ffffffffa0135d72>] make_request+0xb2/0xd80 [raid1]
[  810.274537]  [<ffffffff81408f15>] ? __bt_get.isra.7+0xd5/0x1b0
[  810.274650]  [<ffffffff81094feb>] ? finish_wait+0x5b/0x80
[  810.274766]  [<ffffffff8140917f>] ? bt_get+0x18f/0x1b0
[  810.274881]  [<ffffffffa02123fc>] md_make_request+0xec/0x230 [md_mod]
[  810.274998]  [<ffffffff813f96f9>] ? generic_make_request_checks+0x219/0x=
500
[  810.275144]  [<ffffffff813fc851>] blk_prologue_bio+0x91/0xc0
[  810.275257]  [<ffffffff813fc230>] generic_make_request+0xe0/0x1b0
[  810.275373]  [<ffffffff813fc362>] submit_bio+0x62/0x140
[  810.275486]  [<ffffffff811d2bbc>] do_blockdev_direct_IO+0x289c/0x33c0
[  810.275607]  [<ffffffff811cd620>] ? I_BDEV+0x10/0x10
[  810.275721]  [<ffffffff811d371e>] __blockdev_direct_IO+0x3e/0x40
[  810.275843]  [<ffffffff811cdfb7>] blkdev_direct_IO+0x47/0x50
[  810.275956]  [<ffffffff81132e8c>] generic_file_direct_write+0xac/0x170
[  810.276073]  [<ffffffff8113301d>] __generic_file_write_iter+0xcd/0x1f0
[  810.276187]  [<ffffffff811ce990>] ? blkdev_close+0x30/0x30
[  810.276332]  [<ffffffff811cea17>] blkdev_write_iter+0x87/0x110
[  810.276445]  [<ffffffff811de6d0>] aio_run_iocb+0x250/0x2b0
[  810.276560]  [<ffffffff8181209d>] ? mutex_lock+0xd/0x30
[  810.276673]  [<ffffffff811ddd04>] ? aio_read_events+0x284/0x370
[  810.276786]  [<ffffffff81183c29>] ? kmem_cache_alloc+0xd9/0x180
[  810.276902]  [<ffffffff811df438>] ? do_io_submit+0x178/0x4a0
[  810.277015]  [<ffffffff811df4ed>] do_io_submit+0x22d/0x4a0
[  810.277131]  [<ffffffff811df76b>] SyS_io_submit+0xb/0x10
[  810.277244]  [<ffffffff81813e17>] entry_SYSCALL_64_fastpath+0x12/0x66
I dump r1conf in crash:
struct r1conf {
  mddev =3D 0xffff88022d761800,
  mirrors =3D 0xffff88023456a180,
  raid_disks =3D 2,
  next_resync =3D 18446744073709527039,
  start_next_window =3D 18446744073709551615,
  current_window_requests =3D 0,
  next_window_requests =3D 0,
  device_lock =3D {
    {
      rlock =3D {
        raw_lock =3D {
          val =3D {
            counter =3D 0
          }
        }
      }
    }
  },
  retry_list =3D {
    next =3D 0xffff8800b5fe3b40,
    prev =3D 0xffff8800b50164c0
  },
  bio_end_io_list =3D {
    next =3D 0xffff88022fcd45c0,
    prev =3D 0xffff8800b53d57c0
  },
  pending_bio_list =3D {
    head =3D 0x0,
    tail =3D 0x0
  },
  pending_count =3D 0,
  wait_barrier =3D {
    lock =3D {
      {
        rlock =3D {
          raw_lock =3D {
            val =3D {
              counter =3D 0
            }
          }
        }
      }
    },
    task_list =3D {
      next =3D 0xffff8800b51d37e0,
      prev =3D 0xffff88022fbbb770
    }
  },
  resync_lock =3D {
    {
      rlock =3D {
        raw_lock =3D {
          val =3D {
            counter =3D 0
          }
        }
      }
    }
  },
  nr_pending =3D 406,
  nr_waiting =3D 100,
  nr_queued =3D 404,
  barrier =3D 0,
  array_frozen =3D 1,
  fullsync =3D 0,
  recovery_disabled =3D 1,
  poolinfo =3D 0xffff88022d829bb0,
  r1bio_pool =3D 0xffff88022b4512a0,
  r1buf_pool =3D 0x0,
  tmppage =3D 0xffffea0008c97b00,
  thread =3D 0x0,
  cluster_sync_low =3D 0,
  cluster_sync_high =3D 0
}

every time nr_pending is 1 bigger then (nr_queued + 1), so seems we
forgot to increase nr_queued somewhere?

I've noticed (commit ccfc7bf1f09d61)raid1: include bio_end_io_list in
nr_queued to prevent freeze_array hang. Seems it fixed similar bug.

Could you give your suggestion?


--=20
Jinpu Wang
Linux Kernel Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Tel:       +49 30 577 008  042
Fax:      +49 30 577 008 299
Email:    jinpu.wang@profitbricks.com
URL:      https://www.profitbricks.de

Sitz der Gesellschaft: Berlin
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
Gesch=C3=A4ftsf=C3=BChrer: Achim Weiss
