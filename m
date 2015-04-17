From: hui jiao <simonjiaoh@gmail.com>
Subject: Re: mdadm hang when one subdev error(raid1)
Date: Fri, 17 Apr 2015 17:56:55 +0800
Message-ID: <CAEuG+XJbMqyQ4_nS=ZKEoDW0shQgLgEqNirxx=xNBa6yH_Y=_w@mail.gmail.com>
References: <55fb513d.5f1b.14cc6426c67.Coremail.xizhiyong18@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <55fb513d.5f1b.14cc6426c67.Coremail.xizhiyong18@163.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?5bit5pm65YuH?= <xizhiyong18@163.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

The md42 is trying to update on-disk superblock, but the operation
doesn't finish. During this peroid, the configuration lock is holded
by md42_raid1 thread, all other operations which need the lock will
wait, such as -D --fail --remove.

what's the status of the subdev now? is it suspended?
check and resume it:
[root@node0 ~]# cat /sys/block/dm-0/dm/suspended
1
[root@node0 ~]# dmsetup resume /dev/dm-0
[root@node0 ~]# cat /sys/block/dm-0/dm/suspended
0

On Fri, Apr 17, 2015 at 3:23 PM, =E5=B8=AD=E6=99=BA=E5=8B=87 <xizhiyong=
18@163.com> wrote:
> hi all:
>
>       I create some raid1-device by mdadm, when one subdev error, all=
 mdadm related operation just hang there, process state was D.
>       The backgroud is a physical disk was error, so a subdev which i=
s part of the error disk created by device mapper must be errorred, the=
n i did the command  'mdadm --fail'  to fail the subdev from the md dev=
ice, I found it not responsable, just hang there=E3=80=81I tryed 'mdadm=
 --remove', even 'mdadm -D', all hang there. Later, I found not just md=
adm operation hang on the problem md device, all mdadm operation on the=
 machine connot be excute.
>       I wana find out what's the problem is, is it a bug of raid when=
 disk error occur=EF=BC=8C or a problem of my system, because when i fo=
und the mdadm hang, the errored disk(/dev/sdp)just missing from my syst=
em, I said the disk was error judging from the error log in raid card l=
og.
>       Can anyone give me a help=EF=BC=9F
>       thanks.
>
>       uname -a :Linux **-***-***-** 3.10.45-****-amd64 #1 SMP Tue Jul=
 1 01:52:20 UTC 2014 x86_64 GNU/Linux
>       mdadm --version:mdadm - v3.2.5 - 18th May 2012
>       kern.log:
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.561205] kvm          =
   D ffff88407f313f40     0 11581      1 0x00000000
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.561209]  ffff88356e84=
6080 0000000000000082 0000000000000092 ffff881fe2d6a080
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.561215]  000000000001=
3f40 ffff882849dfdfd8 ffff882849dfdfd8 ffff88356e846080
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.561219]  ffffffff8139=
958c ffff881cac478000 ffff882849dfdcb0 ffff881cac478290
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.561224] Call Trace:
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.561233]  [<ffffffff81=
39958c>] ? _raw_spin_unlock_irqrestore+0xc/0xd
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.561266]  [<ffffffffa0=
2efff0>] ? md_write_start+0x131/0x147 [md_mod]
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.561271]  [<ffffffff81=
059c2f>] ? abort_exclusive_wait+0x79/0x79
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.561275]  [<ffffffffa0=
5c2762>] ? make_request+0x37/0xa63 [raid1]
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.561284]  [<ffffffffa0=
2f4b7e>] ? md_make_request+0xee/0x1df [md_mod]
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.561295]  [<ffffffffa0=
006902>] ? dm_request+0x150/0x163 [dm_mod]
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.561300]  [<ffffffff81=
1b3efc>] ? generic_make_request+0x96/0xd5
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.561304]  [<ffffffff81=
1b4c79>] ? submit_bio+0x10a/0x13b
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.561307]  [<ffffffff81=
1b6b0a>] ? blkdev_issue_flush+0x86/0xc4
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.561311]  [<ffffffff81=
13b298>] ? blkdev_fsync+0x2b/0x37
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.561315]  [<ffffffff81=
134a43>] ? do_fsync+0x2b/0x50
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.561318]  [<ffffffff81=
134c4f>] ? SyS_fdatasync+0xb/0xf
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.561356]  [<ffffffff81=
39ea69>] ? system_call_fastpath+0x16/0x1b
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.561367] INFO: task md=
52_raid1:39767 blocked for more than 120 seconds.
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.563976] "echo 0 > /pr=
oc/sys/kernel/hung_task_timeout_secs" disables this message.
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.566971] md52_raid1   =
   D ffff88407f233f40     0 39767      2 0x00000000
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.566975]  ffff883e60fa=
9810 0000000000000046 ffff883e60fa9810 ffff881fe2d620c0
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.566981]  000000000001=
3f40 ffff883d61523fd8 ffff883d61523fd8 ffff883e60fa9810
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.566985]  ffffffff8139=
958c ffff883d61523c60 ffff881cac478000 ffff881cac478290
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.566990] Call Trace:
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.566995]  [<ffffffff81=
39958c>] ? _raw_spin_unlock_irqrestore+0xc/0xd
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.567007]  [<ffffffffa0=
2f4d65>] ? md_super_wait+0x69/0x7f [md_mod]
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.567011]  [<ffffffff81=
059c2f>] ? abort_exclusive_wait+0x79/0x79
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.567019]  [<ffffffffa0=
2f5131>] ? md_update_sb+0x3b6/0x4b8 [md_mod]
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.567023]  [<ffffffff81=
3995cb>] ? _raw_spin_lock_irqsave+0x14/0x35
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.567030]  [<ffffffffa0=
2f59ee>] ? md_check_recovery+0x1c6/0x3d1 [md_mod]
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.567034]  [<ffffffffa0=
5c31cc>] ? raid1d+0x3e/0xb22 [raid1]
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.567038]  [<ffffffff81=
3988db>] ? __schedule+0x4e7/0x53d
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.567042]  [<ffffffff81=
3978a3>] ? schedule_timeout+0x2c/0x123
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.567045]  [<ffffffff81=
3995cb>] ? _raw_spin_lock_irqsave+0x14/0x35
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.567048]  [<ffffffff81=
3995cb>] ? _raw_spin_lock_irqsave+0x14/0x35
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.567088]  [<ffffffffa0=
2f02ed>] ? md_thread+0x114/0x132 [md_mod]
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.567092]  [<ffffffff81=
059c2f>] ? abort_exclusive_wait+0x79/0x79
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.567100]  [<ffffffffa0=
2f01d9>] ? signal_pending+0x10/0x10 [md_mod]
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.567107]  [<ffffffffa0=
2f01d9>] ? signal_pending+0x10/0x10 [md_mod]
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.567110]  [<ffffffff81=
059295>] ? kthread+0x81/0x89
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.567113]  [<ffffffff81=
059214>] ? __kthread_parkme+0x5d/0x5d
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.567117]  [<ffffffff81=
39e9bc>] ? ret_from_fork+0x7c/0xb0
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.567120]  [<ffffffff81=
059214>] ? __kthread_parkme+0x5d/0x5d
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.567125] INFO: task kv=
m:19762 blocked for more than 120 seconds.
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.570192] "echo 0 > /pr=
oc/sys/kernel/hung_task_timeout_secs" disables this message.
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.573492] kvm          =
   D ffff88407f273f40     0 19762      1 0x00000000
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.573496]  ffff883fc90f=
97d0 0000000000000082 0000000000011200 ffff881fe2d64040
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.573502]  000000000001=
3f40 ffff882aad01dfd8 ffff882aad01dfd8 ffff883fc90f97d0
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.573507]  ffffffff8139=
958c ffff881fb5475800 ffff882aad01dcb0 ffff881fb5475a90
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.573512] Call Trace:
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.573517]  [<ffffffff81=
39958c>] ? _raw_spin_unlock_irqrestore+0xc/0xd
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.573529]  [<ffffffffa0=
2efff0>] ? md_write_start+0x131/0x147 [md_mod]
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.573545]  [<ffffffff81=
059c2f>] ? abort_exclusive_wait+0x79/0x79
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.573549]  [<ffffffffa0=
5c2762>] ? make_request+0x37/0xa63 [raid1]
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.573557]  [<ffffffffa0=
00679f>] ? __split_and_process_bio+0x40d/0x420 [dm_mod]
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.573561]  [<ffffffff81=
100cbd>] ? ____cache_alloc+0x25d/0x293
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.573569]  [<ffffffffa0=
2f4b7e>] ? md_make_request+0xee/0x1df [md_mod]
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.573576]  [<ffffffffa0=
006902>] ? dm_request+0x150/0x163 [dm_mod]
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.573580]  [<ffffffff81=
1b3efc>] ? generic_make_request+0x96/0xd5
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.573583]  [<ffffffff81=
1b4c79>] ? submit_bio+0x10a/0x13b
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.573586]  [<ffffffff81=
1b6b0a>] ? blkdev_issue_flush+0x86/0xc4
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.573590]  [<ffffffff81=
13b298>] ? blkdev_fsync+0x2b/0x37
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.573593]  [<ffffffff81=
134a43>] ? do_fsync+0x2b/0x50
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.573596]  [<ffffffff81=
134c4f>] ? SyS_fdatasync+0xb/0xf
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.573600]  [<ffffffff81=
39ea69>] ? system_call_fastpath+0x16/0x1b
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.573603] INFO: task kv=
m:9147 blocked for more than 120 seconds.
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.576936] "echo 0 > /pr=
oc/sys/kernel/hung_task_timeout_secs" disables this message.
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.580590] kvm          =
   D ffff88407f3f3f40     0  9147      1 0x00000000
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.580594]  ffff883fd9bf=
d080 0000000000000082 0000000000000096 ffff881fe2db5040
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.580631]  000000000001=
3f40 ffff882da06a1fd8 ffff882da06a1fd8 ffff883fd9bfd080
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.580635]  ffffffff8139=
958c ffff881fb5475800 ffff882da06a1820 ffff881fb5475a90
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.580648] Call Trace:
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.580653]  [<ffffffff81=
39958c>] ? _raw_spin_unlock_irqrestore+0xc/0xd
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.580666]  [<ffffffffa0=
2efff0>] ? md_write_start+0x131/0x147 [md_mod]
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.580670]  [<ffffffff81=
059c2f>] ? abort_exclusive_wait+0x79/0x79
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.580674]  [<ffffffffa0=
5c2762>] ? make_request+0x37/0xa63 [raid1]
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.580678]  [<ffffffff81=
399449>] ? _raw_read_lock_irqsave+0x21/0x2a
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.580685]  [<ffffffffa0=
00679f>] ? __split_and_process_bio+0x40d/0x420 [dm_mod]
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.580689]  [<ffffffff81=
102005>] ? kmem_cache_alloc+0xe1/0x154
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.580697]  [<ffffffffa0=
2f4b7e>] ? md_make_request+0xee/0x1df [md_mod]
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.580704]  [<ffffffffa0=
006902>] ? dm_request+0x150/0x163 [dm_mod]
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.580708]  [<ffffffff81=
1b3efc>] ? generic_make_request+0x96/0xd5
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.580712]  [<ffffffff81=
1b4c79>] ? submit_bio+0x10a/0x13b
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.580716]  [<ffffffff81=
13ce89>] ? dio_bio_submit+0x68/0x88
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.580719]  [<ffffffff81=
13dc35>] ? do_blockdev_direct_IO+0x957/0xae8
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.580723]  [<ffffffff81=
13aef1>] ? I_BDEV+0x8/0x8
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.580752]  [<ffffffff81=
0c800a>] ? generic_file_direct_write+0xe3/0x14a
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.580755]  [<ffffffff81=
0c818c>] ? __generic_file_aio_write+0x11b/0x1ff
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.580759]  [<ffffffff81=
13b617>] ? blkdev_aio_write+0x44/0x93
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.580763]  [<ffffffff81=
1120b3>] ? do_sync_write+0x55/0x7c
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.580767]  [<ffffffff81=
112ab0>] ? vfs_write+0x9d/0x103
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.580770]  [<ffffffff81=
112eb9>] ? SyS_pwrite64+0x61/0x87
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.580773]  [<ffffffff81=
39ea69>] ? system_call_fastpath+0x16/0x1b
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.580778] INFO: task md=
42_raid1:36156 blocked for more than 120 seconds.
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.584560] "echo 0 > /pr=
oc/sys/kernel/hung_task_timeout_secs" disables this message.
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.588685] md42_raid1   =
   D ffff88207fa33f40     0 36156      2 0x00000000
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.588690]  ffff881d0b32=
4080 0000000000000046 ffff881d0b324080 ffff881fe2d62810
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.588695]  000000000001=
3f40 ffff881fe1157fd8 ffff881fe1157fd8 ffff881d0b324080
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.588699]  ffffffff8139=
958c ffff881fe1157c60 ffff881fb5475800 ffff881fb5475a90
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.588703] Call Trace:
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.588710]  [<ffffffff81=
39958c>] ? _raw_spin_unlock_irqrestore+0xc/0xd
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.588734]  [<ffffffffa0=
2f4d65>] ? md_super_wait+0x69/0x7f [md_mod]
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.588738]  [<ffffffff81=
059c2f>] ? abort_exclusive_wait+0x79/0x79
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.588745]  [<ffffffffa0=
2f5131>] ? md_update_sb+0x3b6/0x4b8 [md_mod]
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.588750]  [<ffffffff81=
00c02f>] ? load_TLS+0x7/0xa
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.588758]  [<ffffffffa0=
2f59ee>] ? md_check_recovery+0x1c6/0x3d1 [md_mod]
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.588761]  [<ffffffffa0=
5c31cc>] ? raid1d+0x3e/0xb22 [raid1]
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.588766]  [<ffffffff81=
049389>] ? lock_timer_base.isra.35+0x23/0x48
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.588769]  [<ffffffff81=
0490d4>] ? detach_if_pending+0x18/0x6c
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.588772]  [<ffffffff81=
39958c>] ? _raw_spin_unlock_irqrestore+0xc/0xd
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.588775]  [<ffffffff81=
0494ae>] ? try_to_del_timer_sync+0x4e/0x59
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.588778]  [<ffffffff81=
0494e0>] ? del_timer_sync+0x27/0x44
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.588781]  [<ffffffff81=
39796c>] ? schedule_timeout+0xf5/0x123
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.588784]  [<ffffffff81=
3995cb>] ? _raw_spin_lock_irqsave+0x14/0x35
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.588787]  [<ffffffff81=
3995cb>] ? _raw_spin_lock_irqsave+0x14/0x35
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.588794]  [<ffffffffa0=
2f02ed>] ? md_thread+0x114/0x132 [md_mod]
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.588797]  [<ffffffff81=
059c2f>] ? abort_exclusive_wait+0x79/0x79
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.588804]  [<ffffffffa0=
2f01d9>] ? signal_pending+0x10/0x10 [md_mod]
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.588810]  [<ffffffffa0=
2f01d9>] ? signal_pending+0x10/0x10 [md_mod]
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.588813]  [<ffffffff81=
059295>] ? kthread+0x81/0x89
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.588816]  [<ffffffff81=
059214>] ? __kthread_parkme+0x5d/0x5d
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.588819]  [<ffffffff81=
39e9bc>] ? ret_from_fork+0x7c/0xb0
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.588822]  [<ffffffff81=
059214>] ? __kthread_parkme+0x5d/0x5d
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.588834] INFO: task kv=
m:14262 blocked for more than 120 seconds.
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.592943] "echo 0 > /pr=
oc/sys/kernel/hung_task_timeout_secs" disables this message.
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.597362] kvm          =
   D ffff88207fbb3f40     0 14262      1 0x00000000
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.597365]  ffff88361cc9=
1080 0000000000000082 0000000000000092 ffff881fe2db3810
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.597371]  000000000001=
3f40 ffff882849fd9fd8 ffff882849fd9fd8 ffff88361cc91080
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.597374]  ffffffff8139=
958c ffff883fe1297000 ffff882849fd9cb0 ffff883fe1297290
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.597378] Call Trace:
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.597383]  [<ffffffff81=
39958c>] ? _raw_spin_unlock_irqrestore+0xc/0xd
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.597400]  [<ffffffffa0=
2efff0>] ? md_write_start+0x131/0x147 [md_mod]
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.597403]  [<ffffffff81=
059c2f>] ? abort_exclusive_wait+0x79/0x79
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.597407]  [<ffffffffa0=
5c2762>] ? make_request+0x37/0xa63 [raid1]
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.597415]  [<ffffffffa0=
2f4b7e>] ? md_make_request+0xee/0x1df [md_mod]
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.597422]  [<ffffffffa0=
006902>] ? dm_request+0x150/0x163 [dm_mod]
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.597426]  [<ffffffff81=
1b3efc>] ? generic_make_request+0x96/0xd5
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.597430]  [<ffffffff81=
1b4c79>] ? submit_bio+0x10a/0x13b
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.597433]  [<ffffffff81=
1b6b0a>] ? blkdev_issue_flush+0x86/0xc4
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.597438]  [<ffffffff81=
13b298>] ? blkdev_fsync+0x2b/0x37
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.597442]  [<ffffffff81=
134a43>] ? do_fsync+0x2b/0x50
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.597445]  [<ffffffff81=
134c4f>] ? SyS_fdatasync+0xb/0xf
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.597449]  [<ffffffff81=
39ea69>] ? system_call_fastpath+0x16/0x1b
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.597452] INFO: task kv=
m:14266 blocked for more than 120 seconds.
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.602000] "echo 0 > /pr=
oc/sys/kernel/hung_task_timeout_secs" disables this message.
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.606850] kvm          =
   D ffff88207fa53f40     0 14266      1 0x00000000
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.606854]  ffff883e6f7a=
3810 0000000000000082 0000000000000096 ffff881fe2d63850
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.606860]  000000000001=
3f40 ffff883c8fc49fd8 ffff883c8fc49fd8 ffff883e6f7a3810
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.606865]  ffffffff8139=
958c ffff881b5fa52800 ffff883c8fc49700 ffff881b5fa52a90
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.606870] Call Trace:
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.606877]  [<ffffffff81=
39958c>] ? _raw_spin_unlock_irqrestore+0xc/0xd
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.606897]  [<ffffffffa0=
2efff0>] ? md_write_start+0x131/0x147 [md_mod]
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.606901]  [<ffffffff81=
059c2f>] ? abort_exclusive_wait+0x79/0x79
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.606906]  [<ffffffffa0=
5c2762>] ? make_request+0x37/0xa63 [raid1]
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.606909]  [<ffffffff81=
399449>] ? _raw_read_lock_irqsave+0x21/0x2a
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.606917]  [<ffffffffa0=
00679f>] ? __split_and_process_bio+0x40d/0x420 [dm_mod]
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.606925]  [<ffffffffa0=
2f4b7e>] ? md_make_request+0xee/0x1df [md_mod]
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.606932]  [<ffffffffa0=
006902>] ? dm_request+0x150/0x163 [dm_mod]
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.606936]  [<ffffffff81=
1b3efc>] ? generic_make_request+0x96/0xd5
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.606940]  [<ffffffff81=
1b4c79>] ? submit_bio+0x10a/0x13b
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.606944]  [<ffffffff81=
13ce89>] ? dio_bio_submit+0x68/0x88
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.606947]  [<ffffffff81=
13d115>] ? dio_send_cur_page+0x7d/0xa8
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.606951]  [<ffffffff81=
13d1e8>] ? submit_page_section+0xa8/0x112
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.606954]  [<ffffffff81=
13da99>] ? do_blockdev_direct_IO+0x7bb/0xae8
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.606958]  [<ffffffff81=
13aef1>] ? I_BDEV+0x8/0x8
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.606961]  [<ffffffff81=
13b0e8>] ? blkdev_direct_IO+0x4e/0x53
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.606964]  [<ffffffff81=
13aef1>] ? I_BDEV+0x8/0x8
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.606969]  [<ffffffff81=
0c800a>] ? generic_file_direct_write+0xe3/0x14a
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.606972]  [<ffffffff81=
0c818c>] ? __generic_file_aio_write+0x11b/0x1ff
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.606976]  [<ffffffff81=
13b617>] ? blkdev_aio_write+0x44/0x93
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.606980]  [<ffffffff81=
112038>] ? do_sync_readv_writev+0x50/0x76
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.606983]  [<ffffffff81=
13b5d3>] ? bd_may_claim+0x2c/0x2c
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.606987]  [<ffffffff81=
1130a6>] ? do_readv_writev+0xbf/0x135
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.606990]  [<ffffffff81=
13b5d3>] ? bd_may_claim+0x2c/0x2c
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.606993]  [<ffffffff81=
11205e>] ? do_sync_readv_writev+0x76/0x76
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.606997]  [<ffffffff81=
126eee>] ? fget_light+0x6b/0x7c
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.607000]  [<ffffffff81=
111fbb>] ? fdget+0xe/0x17
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.607004]  [<ffffffff81=
1133fe>] ? SyS_pwritev+0x65/0xb0
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.607007]  [<ffffffff81=
39ea69>] ? system_call_fastpath+0x16/0x1b
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.607010] INFO: task kv=
m:14306 blocked for more than 120 seconds.
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.612040] "echo 0 > /pr=
oc/sys/kernel/hung_task_timeout_secs" disables this message.
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.617441] kvm          =
   D ffff88207fa53f40     0 14306      1 0x00000000
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.617445]  ffff880eedba=
a080 0000000000000082 0000000000011200 ffff881fe2d63850
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.617451]  000000000001=
3f40 ffff881d8e5edfd8 ffff881d8e5edfd8 ffff880eedbaa080
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.617451]  000000000001=
3f40 ffff881d8e5edfd8 ffff881d8e5edfd8 ffff880eedbaa080
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.617456]  ffffffff8139=
958c ffff881b5fa52800 ffff881d8e5ed820 ffff881b5fa52a90
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.617460] Call Trace:
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.617467]  [<ffffffff81=
39958c>] ? _raw_spin_unlock_irqrestore+0xc/0xd
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.617486]  [<ffffffffa0=
2efff0>] ? md_write_start+0x131/0x147 [md_mod]
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.617490]  [<ffffffff81=
059c2f>] ? abort_exclusive_wait+0x79/0x79
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.617509]  [<ffffffffa0=
5c2762>] ? make_request+0x37/0xa63 [raid1]
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.617513]  [<ffffffff81=
399449>] ? _raw_read_lock_irqsave+0x21/0x2a
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.617531]  [<ffffffffa0=
00679f>] ? __split_and_process_bio+0x40d/0x420 [dm_mod]
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.617536]  [<ffffffff81=
102005>] ? kmem_cache_alloc+0xe1/0x154
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.617552]  [<ffffffffa0=
2f4b7e>] ? md_make_request+0xee/0x1df [md_mod]
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.617559]  [<ffffffffa0=
006902>] ? dm_request+0x150/0x163 [dm_mod]
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.617563]  [<ffffffff81=
1b3efc>] ? generic_make_request+0x96/0xd5
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.617573]  [<ffffffff81=
1b4c79>] ? submit_bio+0x10a/0x13b
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.617577]  [<ffffffff81=
13ce89>] ? dio_bio_submit+0x68/0x88
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.617580]  [<ffffffff81=
13dc35>] ? do_blockdev_direct_IO+0x957/0xae8
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.617584]  [<ffffffff81=
13aef1>] ? I_BDEV+0x8/0x8
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.617587]  [<ffffffff81=
13b0e8>] ? blkdev_direct_IO+0x4e/0x53
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.617590]  [<ffffffff81=
13aef1>] ? I_BDEV+0x8/0x8
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.617594]  [<ffffffff81=
0c800a>] ? generic_file_direct_write+0xe3/0x14a
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.617597]  [<ffffffff81=
0c818c>] ? __generic_file_aio_write+0x11b/0x1ff
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.617601]  [<ffffffff81=
13b617>] ? blkdev_aio_write+0x44/0x93
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.617604]  [<ffffffff81=
1120b3>] ? do_sync_write+0x55/0x7c
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.617608]  [<ffffffff81=
112ab0>] ? vfs_write+0x9d/0x103
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.617611]  [<ffffffff81=
112eb9>] ? SyS_pwrite64+0x61/0x87
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.617614]  [<ffffffff81=
39ea69>] ? system_call_fastpath+0x16/0x1b
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.617629] INFO: task md=
71_raid1:14478 blocked for more than 120 seconds.
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.622944] "echo 0 > /pr=
oc/sys/kernel/hung_task_timeout_secs" disables this message.
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.628476] md71_raid1   =
   D ffff88207fad3f40     0 14478      2 0x00000000
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.628480]  ffff883ed1a0=
9040 0000000000000046 ffff883ed1a09040 ffff881fe2d68850
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.628486]  000000000001=
3f40 ffff883fbd0b7fd8 ffff883fbd0b7fd8 ffff883ed1a09040
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.628490]  ffffffff8139=
958c ffff883fbd0b7c60 ffff881b5fa52800 ffff881b5fa52a90
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.628498] Call Trace:
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.628504]  [<ffffffff81=
39958c>] ? _raw_spin_unlock_irqrestore+0xc/0xd
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.628522]  [<ffffffffa0=
2f4d65>] ? md_super_wait+0x69/0x7f [md_mod]
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.628526]  [<ffffffff81=
059c2f>] ? abort_exclusive_wait+0x79/0x79
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.628534]  [<ffffffffa0=
2f5131>] ? md_update_sb+0x3b6/0x4b8 [md_mod]
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.628542]  [<ffffffffa0=
2f59ee>] ? md_check_recovery+0x1c6/0x3d1 [md_mod]
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.628546]  [<ffffffffa0=
5c31cc>] ? raid1d+0x3e/0xb22 [raid1]
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.628550]  [<ffffffff81=
3988db>] ? __schedule+0x4e7/0x53d
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.628553]  [<ffffffff81=
3978a3>] ? schedule_timeout+0x2c/0x123
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.628557]  [<ffffffff81=
3995cb>] ? _raw_spin_lock_irqsave+0x14/0x35
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.628560]  [<ffffffff81=
3995cb>] ? _raw_spin_lock_irqsave+0x14/0x35
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.628568]  [<ffffffffa0=
2f02ed>] ? md_thread+0x114/0x132 [md_mod]
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.628571]  [<ffffffff81=
059c2f>] ? abort_exclusive_wait+0x79/0x79
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.628578]  [<ffffffffa0=
2f01d9>] ? signal_pending+0x10/0x10 [md_mod]
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.628585]  [<ffffffffa0=
2f01d9>] ? signal_pending+0x10/0x10 [md_mod]
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.628588]  [<ffffffff81=
059295>] ? kthread+0x81/0x89
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.628591]  [<ffffffff81=
059214>] ? __kthread_parkme+0x5d/0x5d
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.628594]  [<ffffffff81=
39e9bc>] ? ret_from_fork+0x7c/0xb0
> Apr 12 19:33:47 10-120-202-67 kernel: [10636897.628597]  [<ffffffff81=
059214>] ? __kthread_parkme+0x5d/0x5d
>
>
> -------------
>
> Zhiyong Xi
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
