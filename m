From: NeilBrown <neilb@suse.de>
Subject: Re: RAID1 might_sleep() warning on 3.19-rc7
Date: Fri, 6 Feb 2015 08:51:33 +1100
Message-ID: <20150206085133.2c1ab892@notabene.brown>
References: <54D3D24E.5060303@cybernetics.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/UDUzG.yogvqGu0OE6=cIR5f"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <54D3D24E.5060303@cybernetics.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tony Battersby <tonyb@cybernetics.com>
Cc: linux-raid@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, lkml <linux-kernel@vger.kernel.org>, axboe@kernel.dk
List-Id: linux-raid.ids

--Sig_/UDUzG.yogvqGu0OE6=cIR5f
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 05 Feb 2015 15:27:58 -0500 Tony Battersby <tonyb@cybernetics.com>
wrote:

> I get the might_sleep() warning below when writing some data to an ext3
> filesystem on a RAID1.  But everything works OK, so there is no actual
> problem, just a warning.
>=20
> I see that there has been a fix for a might_sleep() warning in md/bitmap
> since 3.19-rc7, but this is a different warning.

Hi Tony,
 this is another false positive caused by=20

commit 8eb23b9f35aae413140d3fda766a98092c21e9b0
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Wed Sep 24 10:18:55 2014 +0200

    sched: Debug nested sleeps


It is even described in that commit:

    Another observed problem is calling a blocking function from
    schedule()->sched_submit_work()->blk_schedule_flush_plug() which will
    then destroy the task state for the actual __schedule() call that
    comes after it.

That is exactly what is happening here.  However I don't think that is an
"observed problem" but rather an "observed false-positive".

If nothing inside the outer loop blocks, then in particular
generic_make_request will not be called, so nothing will be added to the
queue that blk_schedule_flush_plug flushes.
So the first time through the loop, a call the 'schedule()' may not actually
block, but every subsequent time it will.
So there is no actual problem here.

So I'd be included to add sched_annotate_sleep() in blk_flush_plug_list().

Peter: what do you think is the best way to silence this warning.

Thanks,
NeilBrown



>=20
> ---
>=20
> > cat /proc/mdstat
> Personalities : [raid1]
> md0 : active raid1 sda1[0] sdb1[1]
>       1959884 blocks super 1.0 [2/2] [UU]
>      =20
> unused devices: <none>
>=20
> ---
>=20
> > grep md0 /proc/mounts
> /dev/md0 / ext3 rw,noatime,errors=3Dcontinue,barrier=3D1,data=3Djournal 0=
 0
>=20
> ---
>=20
> WARNING: CPU: 3 PID: 1069 at kernel/sched/core.c:7300 __might_sleep+0x82/=
0x90()
> do not call blocking ops when !TASK_RUNNING; state=3D2 set at [<ffffffff8=
028faa1>] prepare_to_wait+0x31/0xa0
> Modules linked in: iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi i=
gb i2c_algo_bit ptp pps_core mptsas mptscsih mptbase pm80xx libsas mpt2sas =
scsi_transport_sas raid_class sg coretemp eeprom w83795 i2c_i801
> CPU: 3 PID: 1069 Comm: kjournald Not tainted 3.19.0-rc7 #1
> Hardware name: Supermicro X8DTH-i/6/iF/6F/X8DTH, BIOS 2.1b       05/04/12=
 =20
>  0000000000001c84 ffff88032f1df608 ffffffff80645918 0000000000001c84
>  ffff88032f1df658 ffff88032f1df648 ffffffff8025ea6b ffff8800bb0b4d58
>  0000000000000000 00000000000006f6 ffffffff80942b6f ffff8803317b8a00
> Call Trace:
>  [<ffffffff80645918>] dump_stack+0x4f/0x6f
>  [<ffffffff8025ea6b>] warn_slowpath_common+0x8b/0xd0
>  [<ffffffff8025eb51>] warn_slowpath_fmt+0x41/0x50
>  [<ffffffff8028faa1>] ? prepare_to_wait+0x31/0xa0
>  [<ffffffff8028faa1>] ? prepare_to_wait+0x31/0xa0
>  [<ffffffff8027ee62>] __might_sleep+0x82/0x90
>  [<ffffffff803bee06>] generic_make_request_checks+0x36/0x2d0
>  [<ffffffff802943ed>] ? trace_hardirqs_on+0xd/0x10
>  [<ffffffff803bf0b3>] generic_make_request+0x13/0x100
>  [<ffffffff8054983b>] raid1_unplug+0x12b/0x170
>  [<ffffffff803c1302>] blk_flush_plug_list+0xa2/0x230
>  [<ffffffff80294315>] ? trace_hardirqs_on_caller+0x105/0x1d0
>  [<ffffffff80646760>] ? bit_wait_timeout+0x70/0x70
>  [<ffffffff80646383>] io_schedule+0x43/0x80
>  [<ffffffff80646787>] bit_wait_io+0x27/0x50
>  [<ffffffff80646a7d>] __wait_on_bit+0x5d/0x90
>  [<ffffffff803bf160>] ? generic_make_request+0xc0/0x100
>  [<ffffffff80646760>] ? bit_wait_timeout+0x70/0x70
>  [<ffffffff80646bc3>] out_of_line_wait_on_bit+0x73/0x90
>  [<ffffffff8028f680>] ? wake_atomic_t_function+0x40/0x40
>  [<ffffffff8034b60f>] __wait_on_buffer+0x3f/0x50
>  [<ffffffff8034df18>] __bread_gfp+0xa8/0xd0
>  [<ffffffff80388d45>] ext3_get_branch+0x95/0x140
>  [<ffffffff80389716>] ext3_get_blocks_handle+0xb6/0xca0
>  [<ffffffff8029760c>] ? __lock_acquire+0x50c/0xc30
>  [<ffffffff803114b2>] ? __slab_alloc+0x212/0x560
>  [<ffffffff80294315>] ? trace_hardirqs_on_caller+0x105/0x1d0
>  [<ffffffff8038a3a8>] ext3_get_block+0xa8/0x100
>  [<ffffffff80349bba>] generic_block_bmap+0x3a/0x40
>  [<ffffffff8038956d>] ext3_bmap+0x7d/0x90
>  [<ffffffff80333e2c>] bmap+0x1c/0x20
>  [<ffffffff8039ee70>] journal_bmap+0x30/0xa0
>  [<ffffffff8039f238>] journal_next_log_block+0x78/0xa0
>  [<ffffffff8039a637>] journal_commit_transaction+0x657/0x13e0
>  [<ffffffff802aaa87>] ? lock_timer_base+0x37/0x70
>  [<ffffffff802ab0c0>] ? get_next_timer_interrupt+0x240/0x240
>  [<ffffffff8039e632>] kjournald+0xf2/0x210
>  [<ffffffff8028f600>] ? woken_wake_function+0x10/0x10
>  [<ffffffff8039e540>] ? commit_timeout+0x10/0x10
>  [<ffffffff80279e2e>] kthread+0xee/0x120
>  [<ffffffff80279d40>] ? __init_kthread_worker+0x70/0x70
>  [<ffffffff8064b56c>] ret_from_fork+0x7c/0xb0
>  [<ffffffff80279d40>] ? __init_kthread_worker+0x70/0x70
> ---[ end trace 27f081e879dfbb12 ]---


--Sig_/UDUzG.yogvqGu0OE6=cIR5f
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVNPl5Tnsnt1WYoG5AQIu0w/+I0Hr0du9KkYY/3KGdpC0mnItClFze/Yi
2sgVane1rvjcvwM5nEzIR322BGma03PFtpLJWJXweqdAXEQtKtyiussBN0G6cX6M
vBKRSzYjMSxZaIabom9hLCyGZiH1Fv1QHqoqQQ8IUNsE0JYmh7g4WTzfo94MTb1o
5+gdz/9upyf5eEdu6O+rQ5gWM0lchkg1aEgpzHN1mBRpmH9RUcE+1yWCVWzh64U7
aQo2tAtqbaX15/4aRTaEC1Poykba0tcdAP4PBXOI6vaxsDYtSX7oRk+j7zecBinQ
fqvaJxlobztDgI2SiflShH0fPTmgYkj+PI7KEYdDBN7rhahPvWlzbezZ4TuMZ7Yh
MdgMzlnhUM5GjQ8vaTNi3hbX269RQT/7s7OhkpJKDI8zPglcXZpQbF3BdTQ0hhmU
S9yM3/bfbzmL9t0JHbzNCmeWlGhUZkwLtueE1HyrTKx7fqFBC/pLQA/HxBTAISt0
zkmvq41LElTGsGp0oDCYCkBKD5N1zHr7OQMi79miZoyQQpaG1PXSmLySIwIYp9ad
DRI7ztWdx5KzmkkRS/NvgWNJlorTKSqGY1Njbe/Rc2KM1TWXVfLw8UNOv7EJov3M
Sa0DulUzqgZo/Bp0JnYv0kheZV4njzpHpoVBdZZrJVjSb87sU/nbMbx8HPy/opYS
KEr4APOPvmA=
=K6o9
-----END PGP SIGNATURE-----

--Sig_/UDUzG.yogvqGu0OE6=cIR5f--
