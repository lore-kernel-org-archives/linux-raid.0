From: Jeff Lessem <Jeff@Lessem.org>
Subject: Re: 2.6.23.1: mdadm/raid5 hung/d-state
Date: Tue, 06 Nov 2007 16:18:12 -0700
Message-ID: <4730F634.9010302@Lessem.org>
References: <Pine.LNX.4.64.0711040658180.30831@p34.internal.lan>	 <18222.16003.92062.970530@notabene.brown>	 <Pine.LNX.4.64.0711041651250.23496@p34.internal.lan> <e9c3a7c20711051035m78ba90ck68f4fbc10480462a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755564AbXKFXms@vger.kernel.org>
In-Reply-To: <e9c3a7c20711051035m78ba90ck68f4fbc10480462a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@gmail.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, =?ISO-8859-1?Q?BERTRAND_Jo=EBl?= <joel.bertrand@systella.fr>
List-Id: linux-raid.ids

Dan Williams wrote:
 > On 11/4/07, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
 >>
 >> On Mon, 5 Nov 2007, Neil Brown wrote:
 >>
 >>> On Sunday November 4, jpiszcz@lucidpixels.com wrote:
 >>>> # ps auxww | grep D
 >>>> USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME=20
COMMAND
 >>>> root       273  0.0  0.0      0     0 ?        D    Oct21  14:40=20
[pdflush]
 >>>> root       274  0.0  0.0      0     0 ?        D    Oct21  13:00=20
[pdflush]
 >>>>
 >>>> After several days/weeks, this is the second time this has=20
happened, while
 >>>> doing regular file I/O (decompressing a file), everything on the=20
device
 >>>> went into D-state.
 >>> At a guess (I haven't looked closely) I'd say it is the bug that w=
as
 >>> meant to be fixed by
 >>>
 >>> commit 4ae3f847e49e3787eca91bced31f8fd328d50496
 >>>
 >>> except that patch applied badly and needed to be fixed with
 >>> the following patch (not in git yet).
 >>> These have been sent to stable@ and should be in the queue for 2.6=
=2E23.2
 >>>
 >> Ah, thanks Neil, will be updating as soon as it is released, thanks=
=2E
 >>
 >
 > Are you seeing the same "md thread takes 100% of the CPU" that Jo=EB=
l is
 > reporting?

I'm also seeing something similar, but it only seems to cause a
problem if the file system is xfs.  Once I observed the md thread at
100% cpu, but usually the machine is just idle, with processes stuck
in the D state.

The system:

Quad Xeon with 4GB of ram running stock 2.6.23, x86_64.  Drives are
attached to an Adaptec AIC-9410W with aic94xx driver 1.0.3 and
firmware 1.1 (V17/10c6).  Unfortunately I can't try earlier kernels,
because the aic94xx driver didn't support SATA disks until 2.6.23.

I have 4 750GB drives in a RAID5 with LVM and an LV formated ext3
that works without problem.  I can't do extensive testing on those
drives because they contain important data.

I also have 4 400GB drives attached to the same controller.  I created
10GB partition on the 4 drives and a 30GB RAID5 across the drives.
=46ormatting this RAID as XFS and then running bonnie++ on it causes a
hang (stack trace at the bottom of this message).

Rebooting, letting the RAID resync, and reformating the partition ext3
allows bonnie++ to complete successfully.

bonnie++ completes successfully on an xfs formatted non-RAID partition
on one of the drives.

bonnie++ completes succesfully on an xfs formatted RAID0 across the 4
drives.

I should be able to provide any additional debugging information.  I
can also test any patches, either the previous one from this thread,
or new ones.

The following stack trace was performed after the RAID5 hung.  The
hung RAID is md3:

SysRq : Show State
   task                        PC stack   pid father
init          S 0000000000000000     0     1      0
  ffff81012fc47a18 0000000000000082 0000000000000000 ffff81012c73e9c0
  ffff81012c8b6478 ffff81012fc44000 ffff81012fcc2000 ffff81012fc44208
  0000000300001000 ffff81012fc47a28 00000000ffffffff 000000010030fe11
Call Trace:
  [<ffffffff80448a20>] schedule_timeout+0x8a/0xad
  [<ffffffff80237ba4>] process_timeout+0x0/0x5
  [<ffffffff80284031>] do_select+0x3fc/0x45f
  [<ffffffff8028451a>] __pollwait+0x0/0xe1
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff80259d96>] generic_file_buffered_write+0x575/0x695
  [<ffffffff80287d9d>] __d_lookup+0xb0/0x100
  [<ffffffff8027ec7d>] do_lookup+0x63/0x1ae
  [<ffffffff80287198>] dput+0x1c/0x10b
  [<ffffffff80280eb1>] __link_path_walk+0xbb7/0xd0c
  [<ffffffff8028bba8>] mntput_no_expire+0x1c/0x80
  [<ffffffff802810d4>] link_path_walk+0xce/0xe0
  [<ffffffff80284250>] core_sys_select+0x1bc/0x265
  [<ffffffff8028bba8>] mntput_no_expire+0x1c/0x80
  [<ffffffff8027ada4>] cp_new_stat+0xe7/0xff
  [<ffffffff80284755>] sys_select+0x15a/0x183
  [<ffffffff8020bdee>] system_call+0x7e/0x83

kthreadd      S 0000000000000000     0     2      0
  ffff81012fc4bf20 0000000000000046 0000000000000000 0000000000000001
  ffff81011598bb98 ffff81012fc44720 ffffffff805354c0 ffff81012fc44928
  0000000000000000 ffff81011598bb90 00000000ffffffff 0000000000000286
Call Trace:
  [<ffffffff802410c4>] kthreadd+0x73/0x12e
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff803075b0>] acpi_ds_init_one_object+0x0/0x7c
  [<ffffffff80241051>] kthreadd+0x0/0x12e
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

migration/0   S 0000000000000000     0     3      2
  ffff81012fc4feb0 0000000000000046 0000000000000001 0000000000000001
  ffff8100a4e67e90 ffff81012fc44e40 ffff810129824000 ffff81012fc45048
  0000000000000000 ffff8100a4e67e88 ffff8100a4e67e90 0000000000000286
Call Trace:
  [<ffffffff8022c553>] migration_thread+0x185/0x21d
  [<ffffffff8022c3ce>] migration_thread+0x0/0x21d
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

ksoftirqd/0   S 0000000000000000     0     4      2
  ffff81012fc51f10 0000000000000046 0000000000000000 ffff81012fc45770
  0000000000000001 ffff81012fc45560 ffffffff805354c0 ffff81012fc45768
  000000002fc44720 ffff81012ea47560 00000000ffffffff 0000000000000000
Call Trace:
  [<ffffffff80234540>] ksoftirqd+0x0/0x9b
  [<ffffffff80234557>] ksoftirqd+0x17/0x9b
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

migration/1   S 0000000000000001     0     5      2
  ffff81012fc55eb0 0000000000000046 0000000000000001 0000000000000001
  ffff8100a49e9e90 ffff81012fc52000 ffff810129a82e40 ffff81012fc52208
  0000000100000000 ffff8100a49e9e88 ffff8100a49e9e90 0000000000000286
Call Trace:
  [<ffffffff8022c553>] migration_thread+0x185/0x21d
  [<ffffffff8022c3ce>] migration_thread+0x0/0x21d
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

ksoftirqd/1   S 0000000000000000     0     6      2
  ffff81012fc5df10 0000000000000046 0000000000000000 ffff81012fc52930
  0000000100000001 ffff81012fc52720 ffff81012fc52e40 ffff81012fc52928
  00000001ffffffff ffff81012ea47560 00000000ffffffff 0000000000000001
Call Trace:
  [<ffffffff80234540>] ksoftirqd+0x0/0x9b
  [<ffffffff80234557>] ksoftirqd+0x17/0x9b
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

migration/2   S 0000000000000002     0     7      2
  ffff81012fc87eb0 0000000000000046 0000000000000001 0000000000000001
  ffff8100a489be90 ffff81012fc53560 ffff810129824000 ffff81012fc53768
  0000000200000000 ffff8100a489be88 ffff8100a489be90 0000000000000286
Call Trace:
  [<ffffffff8022c553>] migration_thread+0x185/0x21d
  [<ffffffff8022c3ce>] migration_thread+0x0/0x21d
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

ksoftirqd/2   S 0000000000000000     0     8      2
  ffff81012fc91f10 0000000000000046 0000000000000000 ffff81012fc8a210
  0000000200000001 ffff81012fc8a000 ffff81012fc8a720 ffff81012fc8a208
  000000022fc44720 ffff81012ea47560 00000000ffffffff 0000000000000002
Call Trace:
  [<ffffffff80234540>] ksoftirqd+0x0/0x9b
  [<ffffffff80234557>] ksoftirqd+0x17/0x9b
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

migration/3   S 0000000000000000     0     9      2
  ffff81012fcb9eb0 0000000000000046 0000000000000000 0000000000000001
  ffff8100a49e7e90 ffff81012fc8ae40 ffff81012fcc2000 ffff81012fc8b048
  0000000300000000 ffff8100a49e7e88 00000000ffffffff 0000000000000286
Call Trace:
  [<ffffffff8022c553>] migration_thread+0x185/0x21d
  [<ffffffff8022c3ce>] migration_thread+0x0/0x21d
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

ksoftirqd/3   S 0000000000000003     0    10      2
  ffff81012fcc1f10 0000000000000046 ffff81012d4cd560 ffff81012fc8b770
  0000000300000001 ffff81012fc8b560 ffff81012ea47560 ffff81012fc8b768
  000000032fc44720 ffff81012ea47560 00000000ffffffff 0000000000000003
Call Trace:
  [<ffffffff80234540>] ksoftirqd+0x0/0x9b
  [<ffffffff80234557>] ksoftirqd+0x17/0x9b
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

events/0      S 0000000000000000     0    11      2
  ffff81012fceded0 0000000000000046 0000000000000000 ffffffff80237ddc
  ffffffff802147e3 ffff81012fcc2720 ffffffff805354c0 ffff81012fcc2928
  00000000ffffffff 00000000000000fa 00000000ffffffff ffffffff8023e5fe
Call Trace:
  [<ffffffff80237ddc>] __mod_timer+0xb6/0xc4
  [<ffffffff802147e3>] mcheck_timer+0x0/0x7c
  [<ffffffff8023e5fe>] queue_delayed_work_on+0xae/0xbe
  [<ffffffff80261c6a>] vmstat_update+0x0/0x32
  [<ffffffff8023e6c7>] worker_thread+0x74/0x9b
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8023e653>] worker_thread+0x0/0x9b
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

events/1      S 0000000000000000     0    12      2
  ffff81012fcf1ed0 0000000000000046 0000000000000000 ffffffff80237ddc
  ffff81012c74a9a0 ffff81012fcc2e40 ffff81012fc52e40 ffff81012fcc3048
  00000001ffffffff 00000000000000fa 00000000ffffffff ffffffff8023e5fe
Call Trace:
  [<ffffffff80237ddc>] __mod_timer+0xb6/0xc4
  [<ffffffff8023e5fe>] queue_delayed_work_on+0xae/0xbe
  [<ffffffff80261c6a>] vmstat_update+0x0/0x32
  [<ffffffff8023e6c7>] worker_thread+0x74/0x9b
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8023e653>] worker_thread+0x0/0x9b
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

events/2      S 0000000000000000     0    13      2
  ffff81012fcf3ed0 0000000000000046 0000000000000000 ffffffff80237ddc
  ffff81012d73cec8 ffff81012fcc3560 ffff81012fc8a720 ffff81012fcc3768
  00000002ffffffff 00000000000000fa 00000000ffffffff ffffffff8023e5fe
Call Trace:
  [<ffffffff80237ddc>] __mod_timer+0xb6/0xc4
  [<ffffffff8023e5fe>] queue_delayed_work_on+0xae/0xbe
  [<ffffffff80261c6a>] vmstat_update+0x0/0x32
  [<ffffffff8023e6c7>] worker_thread+0x74/0x9b
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8023e653>] worker_thread+0x0/0x9b
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

events/3      S 0000000000000000     0    14      2
  ffff81012fcf7ed0 0000000000000046 0000000000000000 ffffffff80237ddc
  0000000000000286 ffff81012fcf4000 ffff81012fcc2000 ffff81012fcf4208
  00000003ffffffff 00000000000000fa 00000000ffffffff ffffffff8023e5fe
Call Trace:
  [<ffffffff80237ddc>] __mod_timer+0xb6/0xc4
  [<ffffffff8023e5fe>] queue_delayed_work_on+0xae/0xbe
  [<ffffffff80261c6a>] vmstat_update+0x0/0x32
  [<ffffffff8023e6c7>] worker_thread+0x74/0x9b
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8023e653>] worker_thread+0x0/0x9b
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

khelper       S 0000000000000002     0    15      2
  ffff81012fcfbed0 0000000000000046 0000000000001351 ffff81012b6bc188
  0000000000000611 ffff81012fcf4720 ffff810129d44e40 ffff81012fcf4928
  000000028020cbfe 0000000000000010 0000000000000200 0000000000000000
Call Trace:
  [<ffffffff8023d7f4>] __call_usermodehelper+0x41/0x61
  [<ffffffff8023e6c7>] worker_thread+0x74/0x9b
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8023e653>] worker_thread+0x0/0x9b
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

kblockd/0     S 0000000000000000     0    54      2
  ffff81012fd83ed0 0000000000000046 0000000000000000 ffffffff802ec753
  ffff81012ee54000 ffff81012fd80000 ffffffff805354c0 ffff81012fd80208
  000000002ee54000 ffffffff802e8fbd 00000000ffffffff ffffffffffffffff
Call Trace:
  [<ffffffff802ec753>] kobject_get+0x12/0x17
  [<ffffffff802e8fbd>] cfq_kick_queue+0x0/0x35
  [<ffffffff8023e6c7>] worker_thread+0x74/0x9b
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8023e653>] worker_thread+0x0/0x9b
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

kblockd/1     S 0000000000000001     0    55      2
  ffff81012fd85ed0 0000000000000046 ffff81012ec9e1d8 ffffffff802ec753
  ffff81012ee54000 ffff81012fd80720 ffff810129824000 ffff81012fd80928
  000000012ee54000 ffffffff802e8fbd 0000000000000286 ffffffffffffffff
Call Trace:
  [<ffffffff802ec753>] kobject_get+0x12/0x17
  [<ffffffff802e8fbd>] cfq_kick_queue+0x0/0x35
  [<ffffffff802e8fdf>] cfq_kick_queue+0x22/0x35
  [<ffffffff8023e6c7>] worker_thread+0x74/0x9b
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8023e653>] worker_thread+0x0/0x9b
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

kblockd/2     S 0000000000000000     0    56      2
  ffff81012fd89ed0 0000000000000046 0000000000000000 ffffffff802ec753
  ffff81012e7505e0 ffff81012fd80e40 ffff81012fc8a720 ffff81012fd81048
  000000022e7505e0 ffffffff802e8fbd 00000000ffffffff ffffffffffffffff
Call Trace:
  [<ffffffff802ec753>] kobject_get+0x12/0x17
  [<ffffffff802e8fbd>] cfq_kick_queue+0x0/0x35
  [<ffffffff8023e6c7>] worker_thread+0x74/0x9b
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8023e653>] worker_thread+0x0/0x9b
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

kblockd/3     S 0000000000000003     0    57      2
  ffff81012fd8bed0 0000000000000046 ffff81012e8fd1d8 ffffffff802ec753
  ffff81012ee551a0 ffff81012fd81560 ffff81012ec75560 ffff81012fd81768
  000000032ee551a0 ffffffff802e8fbd 0000000000000286 ffffffffffffffff
Call Trace:
  [<ffffffff802ec753>] kobject_get+0x12/0x17
  [<ffffffff802e8fbd>] cfq_kick_queue+0x0/0x35
  [<ffffffff802e8fdf>] cfq_kick_queue+0x22/0x35
  [<ffffffff8023e6c7>] worker_thread+0x74/0x9b
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8023e653>] worker_thread+0x0/0x9b
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

kacpid        S 0000000000000000     0    59      2
  ffff81012fd97ed0 0000000000000046 ffff81012fd97e60 0000000000000000
  ffff81012fd90720 ffff81012fd90720 ffff81012fd90e40 ffff81012fd90928
  0000000000000000 ffffffff80448110 ffff81012fd97f20 0000000000000046
Call Trace:
  [<ffffffff80448110>] thread_return+0x0/0xf9
  [<ffffffff8023e6c7>] worker_thread+0x74/0x9b
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8023e653>] worker_thread+0x0/0x9b
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

kacpi_notify  S 0000000000000000     0    60      2
  ffff81012fd99ed0 0000000000000046 ffff81012fd99e60 0000000000000000
  ffff81012fd90e40 ffff81012fd90e40 ffff81012fd91560 ffff81012fd91048
  0000000000000000 ffffffff80448110 ffff81012fd99f20 0000000000000046
Call Trace:
  [<ffffffff80448110>] thread_return+0x0/0xf9
  [<ffffffff8023e6c7>] worker_thread+0x74/0x9b
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8023e653>] worker_thread+0x0/0x9b
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

ata/0         S 0000000000000000     0   189      2
  ffff81012fd9fed0 0000000000000046 0000000000000000 000000005800176d
  ffff81012fd9fee0 ffff81012fda3560 ffffffff805354c0 ffff81012fda3768
  0000000000000004 ffff81012ecd69e0 00000000ffffffff ffffffff805dd920
Call Trace:
  [<ffffffff8023e6c7>] worker_thread+0x74/0x9b
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8023e653>] worker_thread+0x0/0x9b
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

ata/1         S 0000000000000000     0   190      2
  ffff81012fd4bed0 0000000000000046 0000000000000000 00000000580017a9
  ffff81012fd4bee0 ffff81012fd48000 ffff81012fc52e40 ffff81012fd48208
  0000000100000004 ffff81012ecd69e0 00000000ffffffff ffffffff805dd920
Call Trace:
  [<ffffffff8023e6c7>] worker_thread+0x74/0x9b
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8023e653>] worker_thread+0x0/0x9b
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

ata/2         S 0000000000000000     0   191      2
  ffff81012fd53ed0 0000000000000046 0000000000000000 00000000580016c8
  ffff81012fd53ee0 ffff81012fd48720 ffff81012fc8a720 ffff81012fd48928
  0000000200000004 ffff81012ecd69e0 00000000ffffffff ffffffff805dd920
Call Trace:
  [<ffffffff8023e6c7>] worker_thread+0x74/0x9b
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8023e653>] worker_thread+0x0/0x9b
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

ata/3         S 0000000000000000     0   192      2
  ffff81012fd11ed0 0000000000000046 0000000000000000 00000000580017ea
  ffff81012fd11ee0 ffff81012fd48e40 ffff81012fcc2000 ffff81012fd49048
  0000000300000004 ffff81012ecd4ae0 00000000ffffffff ffffffff805dd920
Call Trace:
  [<ffffffff8023e6c7>] worker_thread+0x74/0x9b
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8023e653>] worker_thread+0x0/0x9b
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

ata_aux       S 0000000000000000     0   193      2
  ffff81012fd13ed0 0000000000000046 ffff81012fd13e60 0000000000000000
  ffff81012fd49560 ffff81012fd49560 ffff81012fd36000 ffff81012fd49768
  0000000000000000 ffffffff80448110 ffff81012fd13f20 0000000000000046
Call Trace:
  [<ffffffff80448110>] thread_return+0x0/0xf9
  [<ffffffff8023e6c7>] worker_thread+0x74/0x9b
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8023e653>] worker_thread+0x0/0x9b
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

ksuspend_usbd S 0000000000000000     0   194      2
  ffff81012fd05ed0 0000000000000046 ffff81012fd05e60 0000000000000000
  ffff81012fd36000 ffff81012fd36000 ffff81012fd36720 ffff81012fd36208
  0000000000000000 ffffffff80448110 ffff81012fd05f20 0000000000000046
Call Trace:
  [<ffffffff80448110>] thread_return+0x0/0xf9
  [<ffffffff8023e6c7>] worker_thread+0x74/0x9b
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8023e653>] worker_thread+0x0/0x9b
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

khubd         S 0000000000000000     0   200      2
  ffff81012fe03e40 0000000000000046 0000000000000000 ffffffff80228f46
  ffff81012ea8c000 ffff81012fe14e40 ffff81012fcc2000 ffff81012fe15048
  0000000300000003 ffff81012ea8c000 00000000ffffffff ffffffff8044985b
Call Trace:
  [<ffffffff80228f46>] __wake_up+0x38/0x4e
  [<ffffffff8044985b>] __up_wakeup+0x35/0x67
  [<ffffffff80393d35>] hub_thread+0xb33/0xb93
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff80393202>] hub_thread+0x0/0xb93
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

kseriod       S 0000000000000000     0   203      2
  ffff81012fdefed0 0000000000000046 0000000000000000 ffffffff80446d57
  0000000000000000 ffff81012fdea720 ffffffff805354c0 ffff81012fdea928
  00000000805dd920 ffffffff80345f1d 00000000ffffffff ffffffff80346044
Call Trace:
  [<ffffffff80446d57>] klist_next+0x2d/0x83
  [<ffffffff80345f1d>] next_device+0x9/0x1f
  [<ffffffff80346044>] bus_for_each_dev+0x61/0x6e
  [<ffffffff803a4a0d>] serio_thread+0x2ac/0x2e3
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff803a4761>] serio_thread+0x0/0x2e3
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

pdflush       D 0000000000000000     0   261      2
  ffff81012ecc7930 0000000000000046 ffff81012ecc78f8 0000000000000001
  0000000000000082 ffff81012ecbf560 ffff81012fc52e40 ffff81012ecbf768
  000000012cb33800 0000000000000046 00000000ffffffff ffffffff802e27e0
Call Trace:
  [<ffffffff802e27e0>] __generic_unplug_device+0x13/0x24
  [<ffffffff803b12cf>] get_active_stripe+0x22f/0x4ca
  [<ffffffff80228f46>] __wake_up+0x38/0x4e
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff803b6b3b>] make_request+0x3f3/0x577
  [<ffffffff8025acf6>] mempool_alloc+0x24/0xda
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff802e1728>] generic_make_request+0x1be/0x1f5
  [<ffffffff802e3caf>] submit_bio+0xb4/0xbb
  [<ffffffff80298e2f>] __bio_add_page+0x109/0x1b9
  [<ffffffff8827dcb4>] :xfs:xfs_submit_ioend_bio+0x1e/0x27
  [<ffffffff8827e0ce>] :xfs:xfs_submit_ioend+0x88/0xc6
  [<ffffffff8827ef51>] :xfs:xfs_page_state_convert+0x51e/0x56d
  [<ffffffff8827f0f2>] :xfs:xfs_vm_writepage+0xa7/0xe1
  [<ffffffff8025d022>] __writepage+0xa/0x23
  [<ffffffff8025d552>] write_cache_pages+0x176/0x2a3
  [<ffffffff8025d018>] __writepage+0x0/0x23
  [<ffffffff8025d6bb>] do_writepages+0x20/0x2d
  [<ffffffff80291fd1>] __writeback_single_inode+0x1d6/0x3a7
  [<ffffffff80228561>] update_curr+0xdf/0xfe
  [<ffffffff802924fa>] sync_sb_inodes+0x1cb/0x2af
  [<ffffffff80292961>] writeback_inodes+0x7d/0xd3
  [<ffffffff8025dafb>] background_writeout+0x84/0xb7
  [<ffffffff8025df26>] pdflush+0x0/0x1d8
  [<ffffffff8025e054>] pdflush+0x12e/0x1d8
  [<ffffffff8025da77>] background_writeout+0x0/0xb7
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

pdflush       D 0000000000000000     0   262      2
  ffff81012eccbdb0 0000000000000046 0000000000000000 ffff81012ecc8000
  0000000000000286 ffff81012ecc8000 ffffffff805354c0 ffff81012ecc8208
  000000002eccbe90 ffff81012eccbdc0 00000000ffffffff 000000010030fe0d
Call Trace:
  [<ffffffff80448a20>] schedule_timeout+0x8a/0xad
  [<ffffffff80237ba4>] process_timeout+0x0/0x5
  [<ffffffff804483fe>] io_schedule_timeout+0x28/0x33
  [<ffffffff802622f4>] congestion_wait+0x66/0x80
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff80292987>] writeback_inodes+0xa3/0xd3
  [<ffffffff8025dc1c>] wb_kupdate+0xba/0x111
  [<ffffffff8025df26>] pdflush+0x0/0x1d8
  [<ffffffff8025e054>] pdflush+0x12e/0x1d8
  [<ffffffff8025db62>] wb_kupdate+0x0/0x111
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

kswapd0       S 0000000000000000     0   263      2
  ffff81012eccfe20 0000000000000046 0000000000000000 ffffffff8022bc95
  ffff81012eccfde0 ffff81012ecc8720 ffff81012fcc2000 ffff81012ecc8928
  0000000300000001 ffff81012eccfe10 00000000ffffffff ffffffff80228561
Call Trace:
  [<ffffffff8022bc95>] set_cpus_allowed+0xa5/0xb2
  [<ffffffff80228561>] update_curr+0xdf/0xfe
  [<ffffffff80260c38>] kswapd+0x0/0x429
  [<ffffffff80260d0b>] kswapd+0xd3/0x429
  [<ffffffff80448110>] thread_return+0x0/0xf9
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff80260c38>] kswapd+0x0/0x429
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

aio/0         S 0000000000000000     0   318      2
  ffff81012ed81ed0 0000000000000046 0000000000000000 0000000000000000
  ffff81012ecc8e40 ffff81012ecc8e40 ffffffff805354c0 ffff81012ecc9048
  0000000000000000 ffffffff80448110 00000000ffffffff 0000000000000046
Call Trace:
  [<ffffffff80448110>] thread_return+0x0/0xf9
  [<ffffffff8023e6c7>] worker_thread+0x74/0x9b
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8023e653>] worker_thread+0x0/0x9b
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

aio/1         S 0000000000000000     0   319      2
  ffff81012ed83ed0 0000000000000046 0000000000000000 0000000000000000
  ffff81012ecc9560 ffff81012ecc9560 ffff81012fc52e40 ffff81012ecc9768
  0000000100000000 ffffffff80448110 00000000ffffffff 0000000000000046
Call Trace:
  [<ffffffff80448110>] thread_return+0x0/0xf9
  [<ffffffff8023e6c7>] worker_thread+0x74/0x9b
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8023e653>] worker_thread+0x0/0x9b
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

aio/2         S 0000000000000000     0   320      2
  ffff81012ed89ed0 0000000000000046 0000000000000000 0000000000000000
  ffff81012ed86000 ffff81012ed86000 ffff81012fc8a720 ffff81012ed86208
  0000000200000000 ffffffff80448110 00000000ffffffff 0000000000000046
Call Trace:
  [<ffffffff80448110>] thread_return+0x0/0xf9
  [<ffffffff8023e6c7>] worker_thread+0x74/0x9b
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8023e653>] worker_thread+0x0/0x9b
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

aio/3         S 0000000000000000     0   321      2
  ffff81012ed8bed0 0000000000000046 0000000000000000 0000000000000000
  ffff81012ed86720 ffff81012ed86720 ffff81012fcc2000 ffff81012ed86928
  000000032ecae000 ffffffff80448110 00000000ffffffff 0000000000000046
Call Trace:
  [<ffffffff80448110>] thread_return+0x0/0xf9
  [<ffffffff8023e6c7>] worker_thread+0x74/0x9b
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8023e653>] worker_thread+0x0/0x9b
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

scsi_eh_0     S 0000000000000000     0   497      2
  ffff81012ecb9e80 0000000000000046 ffff81012ecb9e48 0000000000000003
  ffff81012ecb9e40 ffff81012ed86e40 ffffffff805354c0 ffff81012ed87048
  0000000000000000 0000000000000001 00000000ffffffff ffffffff8035db5d
Call Trace:
  [<ffffffff8035db5d>] __scsi_iterate_devices+0x56/0x6f
  [<ffffffff803619ad>] scsi_error_handler+0x59/0x4b7
  [<ffffffff80361954>] scsi_error_handler+0x0/0x4b7
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

scsi_eh_1     S 0000000000000000     0   499      2
  ffff81012ecb3e80 0000000000000046 0000000000000000 0000000000000003
  ffff81012ecb3e40 ffff81012ed87560 ffff81012fc52e40 ffff81012ed87768
  0000000100000000 0000000000000001 00000000ffffffff ffffffff8035db5d
Call Trace:
  [<ffffffff8035db5d>] __scsi_iterate_devices+0x56/0x6f
  [<ffffffff803619ad>] scsi_error_handler+0x59/0x4b7
  [<ffffffff80361954>] scsi_error_handler+0x0/0x4b7
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

scsi_eh_2     S 0000000000000003     0   501      2
  ffff81012ee25e80 0000000000000046 0000000000000082 0000000000000003
  ffff81012ee25e40 ffff81012fdeb560 ffff81012fc44000 ffff81012fdeb768
  0000000300000000 0000000000000001 0000000000000246 ffffffff8035db5d
Call Trace:
  [<ffffffff8035db5d>] __scsi_iterate_devices+0x56/0x6f
  [<ffffffff803619ad>] scsi_error_handler+0x59/0x4b7
  [<ffffffff80361954>] scsi_error_handler+0x0/0x4b7
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

scsi_eh_3     S 0000000000000003     0   503      2
  ffff81012ed93e80 0000000000000046 0000000000000082 0000000000000003
  ffff81012ed93e40 ffff81012fdeae40 ffff81012fc44000 ffff81012fdeb048
  0000000300000000 0000000000000001 0000000000000246 ffffffff8035db5d
Call Trace:
  [<ffffffff8035db5d>] __scsi_iterate_devices+0x56/0x6f
  [<ffffffff803619ad>] scsi_error_handler+0x59/0x4b7
  [<ffffffff80361954>] scsi_error_handler+0x0/0x4b7
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

scsi_eh_4     S 0000000000000003     0   505      2
  ffff81012eca7e80 0000000000000046 0000000000000082 0000000000000003
  ffff81012eca7e40 ffff81012fdea000 ffff81012fc44000 ffff81012fdea208
  0000000300000000 0000000000000001 0000000000000246 ffffffff8035db5d
Call Trace:
  [<ffffffff8035db5d>] __scsi_iterate_devices+0x56/0x6f
  [<ffffffff803619ad>] scsi_error_handler+0x59/0x4b7
  [<ffffffff80361954>] scsi_error_handler+0x0/0x4b7
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

scsi_eh_5     S 0000000000000003     0   507      2
  ffff81012ec97e80 0000000000000046 0000000000000082 0000000000000003
  ffff81012ec97e40 ffff81012fd36720 ffff81012fc44000 ffff81012fd36928
  0000000300000000 0000000000000001 0000000000000246 ffffffff8035db5d
Call Trace:
  [<ffffffff8035db5d>] __scsi_iterate_devices+0x56/0x6f
  [<ffffffff803619ad>] scsi_error_handler+0x59/0x4b7
  [<ffffffff80361954>] scsi_error_handler+0x0/0x4b7
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

scsi_eh_6     S 0000000000000000     0   524      2
  ffff81012ecd3e80 0000000000000046 0000000000000000 0000000000000003
  ffff81012ec9f9d8 ffff81012fd37560 ffffffff805354c0 ffff81012fd37768
  0000000000000202 0000000000000000 00000000ffffffff ffffffff8035db6a
Call Trace:
  [<ffffffff8035db6a>] __scsi_iterate_devices+0x63/0x6f
  [<ffffffff803619ad>] scsi_error_handler+0x59/0x4b7
  [<ffffffff80361954>] scsi_error_handler+0x0/0x4b7
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

scsi_eh_7     S 0000000000000000     0   526      2
  ffff81012ede5e80 0000000000000046 0000000000000000 0000000000000003
  ffff81012ede5e40 ffff81012fd36e40 ffff81012fcc2000 ffff81012fd37048
  0000000300000000 0000000000000001 00000000ffffffff ffffffff8035db5d
Call Trace:
  [<ffffffff8035db5d>] __scsi_iterate_devices+0x56/0x6f
  [<ffffffff803619ad>] scsi_error_handler+0x59/0x4b7
  [<ffffffff80361954>] scsi_error_handler+0x0/0x4b7
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

kcryptd/0     S 0000000000000000     0   544      2
  ffff81012edfded0 0000000000000046 0000000000000000 0000000000000000
  ffff81012fda2e40 ffff81012fda2e40 ffffffff805354c0 ffff81012fda3048
  0000000000000000 ffffffff80448110 00000000ffffffff 0000000000000046
Call Trace:
  [<ffffffff80448110>] thread_return+0x0/0xf9
  [<ffffffff8023e6c7>] worker_thread+0x74/0x9b
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8023e653>] worker_thread+0x0/0x9b
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

kcryptd/1     S 0000000000000000     0   545      2
  ffff81012ed6bed0 0000000000000046 0000000000000000 0000000000000000
  ffff81012fda2720 ffff81012fda2720 ffff81012fc52e40 ffff81012fda2928
  0000000100000000 ffffffff80448110 00000000ffffffff 0000000000000046
Call Trace:
  [<ffffffff80448110>] thread_return+0x0/0xf9
  [<ffffffff8023e6c7>] worker_thread+0x74/0x9b
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8023e653>] worker_thread+0x0/0x9b
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

kcryptd/2     S 0000000000000000     0   546      2
  ffff81012ee59ed0 0000000000000046 0000000000000000 0000000000000000
  ffff81012fda2000 ffff81012fda2000 ffff81012fc8a720 ffff81012fda2208
  0000000200000000 ffffffff80448110 00000000ffffffff 0000000000000046
Call Trace:
  [<ffffffff80448110>] thread_return+0x0/0xf9
  [<ffffffff8023e6c7>] worker_thread+0x74/0x9b
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8023e653>] worker_thread+0x0/0x9b
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

kcryptd/3     S 0000000000000000     0   547      2
  ffff81012ecdfed0 0000000000000046 0000000000000000 0000000000000000
  ffff81012fd90000 ffff81012fd90000 ffff81012fcc2000 ffff81012fd90208
  0000000300000000 ffffffff80448110 00000000ffffffff 0000000000000046
Call Trace:
  [<ffffffff80448110>] thread_return+0x0/0xf9
  [<ffffffff8023e6c7>] worker_thread+0x74/0x9b
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8023e653>] worker_thread+0x0/0x9b
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

ksnapd        S 0000000000000000     0   548      2
  ffff81012ed1bed0 0000000000000046 0000000000000000 0000000000000000
  ffff81012fd91560 ffff81012fd91560 ffff81012fcc2000 ffff81012fd91768
  0000000300000000 ffffffff80448110 00000000ffffffff 0000000000000046
Call Trace:
  [<ffffffff80448110>] thread_return+0x0/0xf9
  [<ffffffff8023e6c7>] worker_thread+0x74/0x9b
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8023e653>] worker_thread+0x0/0x9b
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

scsi_eh_8     S 0000000000000003     0  1093      2
  ffff81012ebb3e80 0000000000000046 0000000000000001 ffff81012ec74768
  ffff8100052c0b80 ffff81012ec74720 ffff81012e645560 ffff81012ec74928
  000000032ebb3e50 ffff81012ec74720 ffff81012ec74720 ffffffffffffffff
Call Trace:
  [<ffffffff803619ad>] scsi_error_handler+0x59/0x4b7
  [<ffffffff80361954>] scsi_error_handler+0x0/0x4b7
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

scsi_wq_8     S 0000000000000003     0  1094      2
  ffff81012e67fed0 0000000000000046 0000000000000286 ffffffff8036bbf9
  ffff81012eba7a00 ffff81012e645560 ffff81012e8eee40 ffff81012e645768
  000000032e6c4154 ffffffff8036f154 ffff81012e6c0f30 ffff81012e993180
Call Trace:
  [<ffffffff8036bbf9>] sas_rphy_add+0x133/0x13f
  [<ffffffff8036f154>] sas_discover_domain+0x344/0x3fc
  [<ffffffff8036ee10>] sas_discover_domain+0x0/0x3fc
  [<ffffffff8023e6c7>] worker_thread+0x74/0x9b
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8023e653>] worker_thread+0x0/0x9b
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

scsi_eh_9     S 0000000000000001     0  1665      2
  ffff81012e4a1e80 0000000000000046 0000000000000001 ffff81012ea46e88
  ffff8100052aeb80 ffff81012ea46e40 ffff81012ea47560 ffff81012ea47048
  000000012e4a1e50 ffff81012ea46e40 ffff81012ea46e40 ffffffffffffffff
Call Trace:
  [<ffffffff803619ad>] scsi_error_handler+0x59/0x4b7
  [<ffffffff80361954>] scsi_error_handler+0x0/0x4b7
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

usb-storage   S 0000000000000000     0  1667      2
  ffff81012e681e20 0000000000000046 ffff81012e58fca0 ffffffff8806ea5f
  0000000000000000 ffff81012ea47560 ffff81012fc45560 ffff81012ea47768
  00000000000002d5 0000000000000001 0000000000000001 ffff81012e681e20
Call Trace:
  [<ffffffff8806ea5f>] :usb_storage:usb_stor_msg_common+0x110/0x13a
  [<ffffffff804499e5>] __down_interruptible+0xcb/0x137
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff804497e7>] __down_failed_interruptible+0x35/0x3a
  [<ffffffff8806fca5>] :usb_storage:usb_stor_control_thread+0x27/0x1e2
  [<ffffffff8806fc7e>] :usb_storage:usb_stor_control_thread+0x0/0x1e2
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

md0_raid1     S 0000000000000000     0  1836      2
  ffff81012eab1e80 0000000000000046 0000000000000000 ffff81012e8ef5a8
  ffff8100052aeb80 ffff81012e8ef560 ffff81012fcc2000 ffff81012e8ef768
  000000032eab1e50 ffff81012fcc2000 00000000ffffffff ffffffffffffffff
Call Trace:
  [<ffffffff804489b4>] schedule_timeout+0x1e/0xad
  [<ffffffff802414fd>] prepare_to_wait+0x15/0x5f
  [<ffffffff803c02fb>] md_thread+0xbb/0xf1
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff803c0240>] md_thread+0x0/0xf1
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

md1_raid1     S 0000000000000000     0  1854      2
  ffff81012e5bde80 0000000000000046 0000000000000000 ffff81012e8ee048
  ffff8100052aeb80 ffff81012e8ee000 ffff81012fc8a720 ffff81012e8ee208
  000000022e5bde50 ffffffff805354c0 00000000ffffffff ffffffffffffffff
Call Trace:
  [<ffffffff804489b4>] schedule_timeout+0x1e/0xad
  [<ffffffff802414fd>] prepare_to_wait+0x15/0x5f
  [<ffffffff803c02fb>] md_thread+0xbb/0xf1
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff803c0240>] md_thread+0x0/0xf1
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

md2_raid5     S 0000000000000000     0  1872      2
  ffff81012e479e80 0000000000000046 0000000000000000 0000000000000046
  ffff81012eaa1780 ffff81012e8ee720 ffff81012fc52e40 ffff81012e8ee928
  000000012eb1c800 ffff81012fc52e40 00000000ffffffff ffff81012e453400
Call Trace:
  [<ffffffff804489b4>] schedule_timeout+0x1e/0xad
  [<ffffffff802414fd>] prepare_to_wait+0x15/0x5f
  [<ffffffff803c02fb>] md_thread+0xbb/0xf1
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff803c0240>] md_thread+0x0/0xf1
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

kjournald     S 0000000000000000     0  1980      2
  ffff81012d503eb0 0000000000000046 0000000000000000 00000000802413e5
  00000fcc00000000 ffff81012e48c720 ffffffff805354c0 ffff81012e48c928
  0000000000000000 0000000000000001 00000000ffffffff 0000000000000003
Call Trace:
  [<ffffffff802d0936>] kjournald+0x165/0x1e6
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff802d07d1>] kjournald+0x0/0x1e6
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff8020cf7c>] call_softirq+0x1c/0x28
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

udevd         S 0000000000000000     0  2189      1
  ffff81012e7f7a18 0000000000000086 0000000000000000 ffffffff80264e33
  80000001143fa065 ffff81012ecbee40 ffff81012fc52e40 ffff81012ecbf048
  0000000100000870 ffff81012fc52e40 00000000ffffffff ffff81012ecbee40
Call Trace:
  [<ffffffff80264e33>] handle_mm_fault+0x6f3/0x772
  [<ffffffff804489b4>] schedule_timeout+0x1e/0xad
  [<ffffffff802415e1>] add_wait_queue+0x15/0x44
  [<ffffffff8029dde8>] inotify_poll+0x4f/0x56
  [<ffffffff80284031>] do_select+0x3fc/0x45f
  [<ffffffff8028451a>] __pollwait+0x0/0xe1
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
sage repeated 3 times
  [<ffffffff802eebcf>] __up_read+0x13/0x8a
  [<ffffffff802ef67d>] number+0x119/0x204
  [<ffffffff8025c800>] get_page_from_freelist+0x278/0x35e
  [<ffffffff80287198>] dput+0x1c/0x10b
  [<ffffffff8027eab8>] __follow_mount+0x26/0x7b
  [<ffffffff8027ec7d>] do_lookup+0x63/0x1ae
  [<ffffffff8028bba8>] mntput_no_expire+0x1c/0x80
  [<ffffffff8028098f>] __link_path_walk+0x695/0xd0c
  [<ffffffff80284250>] core_sys_select+0x1bc/0x265
  [<ffffffff80287d9d>] __d_lookup+0xb0/0x100
  [<ffffffff802910e3>] simple_empty+0x10/0x58
  [<ffffffff80241559>] remove_wait_queue+0x12/0x44
  [<ffffffff802846bc>] sys_select+0xc1/0x183
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff80278ad7>] sys_read+0x45/0x6e
  [<ffffffff8020bdee>] system_call+0x7e/0x83

kpsmoused     S 0000000000000001     0  2826      2
  ffff81012d0f3ed0 0000000000000046 ffff81012d0f3e60 0000000000000000
  ffff81012e599560 ffff81012e599560 ffff81012ecbee40 ffff81012e599768
  000000012fd2c768 ffffffff80448110 ffff81012d0f3f20 0000000000000046
Call Trace:
  [<ffffffff80448110>] thread_return+0x0/0xf9
  [<ffffffff8023e6c7>] worker_thread+0x74/0x9b
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8023e653>] worker_thread+0x0/0x9b
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

kjournald     S 0000000000000000     0  3333      2
  ffff81012c8b1eb0 0000000000000046 0000000000000000 0000000000000c31
  ffff81012dbd9a98 ffff81012fcf4e40 ffffffff805354c0 ffff81012fcf5048
  0000000000000000 0000000000000001 00000000ffffffff 0000000000000003
Call Trace:
  [<ffffffff802d0936>] kjournald+0x165/0x1e6
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff802d07d1>] kjournald+0x0/0x1e6
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

kjournald     S 0000000000000000     0  3334      2
  ffff81012d0b1eb0 0000000000000046 ffff81012e09b898 00000000000003f0
  ffff81012e09b898 ffff81012e8eee40 ffff81012fcf5560 ffff81012e8ef048
  0000000000000000 0000000000000001 0000000000000282 0000000000000003
Call Trace:
  [<ffffffff80228f46>] __wake_up+0x38/0x4e
  [<ffffffff802d0936>] kjournald+0x165/0x1e6
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff802d07d1>] kjournald+0x0/0x1e6
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

kjournald     S 0000000000000000     0  3335      2
  ffff81012e3edeb0 0000000000000046 0000000000000000 0000000000000c31
  ffff81012e09be98 ffff81012e598000 ffffffff805354c0 ffff81012e598208
  0000000000000000 0000000000000001 00000000ffffffff 0000000000000003
Call Trace:
  [<ffffffff802d0936>] kjournald+0x165/0x1e6
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff802d07d1>] kjournald+0x0/0x1e6
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

portmap       S 0000000000000000     0  3766      1
  ffff81012f703b28 0000000000000086 0000000000000000 ffffffff802eebcf
  ffff81012f0ab888 ffff81012d4cc720 ffff81012fc52e40 ffff81012d4cc928
  000000012dfa4600 ffff81012fc52e40 00000000ffffffff ffffffff00030002
Call Trace:
  [<ffffffff802eebcf>] __up_read+0x13/0x8a
  [<ffffffff804489b4>] schedule_timeout+0x1e/0xad
  [<ffffffff802415e1>] add_wait_queue+0x15/0x44
  [<ffffffff8040caaf>] tcp_poll+0x25/0x138
  [<ffffffff80283b12>] do_sys_poll+0x278/0x360
  [<ffffffff8028451a>] __pollwait+0x0/0xe1
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff8025885f>] file_read_actor+0xa0/0x118
  [<ffffffff8025897e>] find_get_page+0x21/0x50
  [<ffffffff80259207>] do_generic_mapping_read+0x3f4/0x406
  [<ffffffff802587bf>] file_read_actor+0x0/0x118
  [<ffffffff8025a61e>] generic_file_aio_read+0x11d/0x160
  [<ffffffff8025c2bf>] __pagevec_free+0x21/0x2e
  [<ffffffff8025e950>] release_pages+0x14a/0x157
  [<ffffffff80263edc>] unmap_vmas+0x3ec/0x710
  [<ffffffff8026d4d5>] free_pages_and_swap_cache+0x73/0x8f
  [<ffffffff802679e6>] unmap_region+0x114/0x12a
  [<ffffffff80267a40>] remove_vma+0x44/0x4b
  [<ffffffff80268687>] do_munmap+0x254/0x276
  [<ffffffff80283c2c>] sys_poll+0x32/0x3b
  [<ffffffff8020bdee>] system_call+0x7e/0x83

rpc.statd     S 0000000000000000     0  3783      1
  ffff81012c5bda18 0000000000000086 0000000000000000 ffffffff80229af5
  ffff81012c5bdad8 ffff81012e373560 ffff81012fcc2000 ffff81012e373768
  0000000300000003 0000000000000000 00000000ffffffff 0000000000000000
Call Trace:
  [<ffffffff80229af5>] find_busiest_group+0x254/0x6d6
  [<ffffffff804489b4>] schedule_timeout+0x1e/0xad
  [<ffffffff802415e1>] add_wait_queue+0x15/0x44
  [<ffffffff8040caaf>] tcp_poll+0x25/0x138
  [<ffffffff80284031>] do_select+0x3fc/0x45f
  [<ffffffff8028451a>] __pollwait+0x0/0xe1
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
sage repeated 2 times
  [<ffffffff8042298d>] udp_recvmsg+0x193/0x1f3
  [<ffffffff803dd31e>] sock_common_recvmsg+0x30/0x45
  [<ffffffff803dbe0b>] sock_recvmsg+0xd5/0xed
  [<ffffffff80449c4f>] _spin_lock_bh+0x9/0x19
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff80284250>] core_sys_select+0x1bc/0x265
  [<ffffffff803ddac9>] lock_sock_nested+0xa2/0xad
  [<ffffffff80449c4f>] _spin_lock_bh+0x9/0x19
  [<ffffffff803dd99f>] release_sock+0x13/0x9b
  [<ffffffff80241321>] bit_waitqueue+0x16/0x82
  [<ffffffff802413cb>] wake_up_bit+0x11/0x22
  [<ffffffff802846bc>] sys_select+0xc1/0x183
  [<ffffffff80276816>] filp_close+0x5d/0x65
  [<ffffffff8020bdee>] system_call+0x7e/0x83

rpciod/0      S 0000000000000000     0  3790      2
  ffff81012c693ed0 0000000000000046 0000000000000000 ffffffff80228f46
  ffff810128534308 ffff81012d97b560 ffffffff805354c0 ffff81012d97b768
  00000000805dd920 0000000000000000 00000000ffffffff 0000000000000286
Call Trace:
  [<ffffffff80228f46>] __wake_up+0x38/0x4e
  [<ffffffff8023e6c7>] worker_thread+0x74/0x9b
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8023e653>] worker_thread+0x0/0x9b
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

rpciod/1      S 0000000000000000     0  3791      2
  ffff81012c695ed0 0000000000000046 0000000000000000 ffff81012cea4000
  ffff81012c846a10 ffff81012d97ae40 ffff81012fc52e40 ffff81012d97b048
  0000000100000282 ffffffff802413b5 00000000ffffffff ffff810100000004
Call Trace:
  [<ffffffff802413b5>] __wake_up_bit+0x28/0x2d
  [<ffffffff8023e6c7>] worker_thread+0x74/0x9b
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8023e653>] worker_thread+0x0/0x9b
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

rpciod/2      S 0000000000000000     0  3792      2
  ffff81012c699ed0 0000000000000046 0000000000000000 ffffffff80228f46
  ffff810128534c08 ffff81012d97a000 ffff81012fc8a720 ffff81012d97a208
  00000002805dd920 0000000000000000 00000000ffffffff 0000000000000286
Call Trace:
  [<ffffffff80228f46>] __wake_up+0x38/0x4e
  [<ffffffff8023e6c7>] worker_thread+0x74/0x9b
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8023e653>] worker_thread+0x0/0x9b
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

rpciod/3      S 0000000000000000     0  3793      2
  ffff81012c69bed0 0000000000000046 0000000000000000 ffff81012cb29d00
  ffff81012cf8cd00 ffff81012e644000 ffff81012fcc2000 ffff81012e644208
  000000032ca80c00 0000000000000287 00000000ffffffff ffffffff881aad70
Call Trace:
  [<ffffffff8023e6c7>] worker_thread+0x74/0x9b
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8023e653>] worker_thread+0x0/0x9b
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

rpc.idmapd    S 0000000000000000     0  3817      1
  ffff81012c165e98 0000000000000082 0000000000000000 ffff81012c165ec8
  7474697765680101 ffff81012fe14720 ffff81012fc8a720 ffff81012fe14928
  0000000200000000 ffff81012c165ea8 00000000ffffffff 000000010030ffb3
Call Trace:
  [<ffffffff80448a20>] schedule_timeout+0x8a/0xad
  [<ffffffff80237ba4>] process_timeout+0x0/0x5
  [<ffffffff8029e84e>] sys_epoll_wait+0x17f/0x421
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff8023ab09>] sys_rt_sigprocmask+0x50/0xce
  [<ffffffff8020bdee>] system_call+0x7e/0x83

nfsv4-svc     S 0000000000000000     0  3823      2
  ffff81012c585e20 0000000000000046 0000000000000000 000005a800000001
  ffff81012c41acc8 ffff81012ea46000 ffffffff805354c0 ffff81012ea46208
  000000002c41ac00 ffffffff803dd99f 00000000ffffffff 0000000000000282
Call Trace:
  [<ffffffff803dd99f>] release_sock+0x13/0x9b
  [<ffffffff804489b4>] schedule_timeout+0x1e/0xad
  [<ffffffff802415e1>] add_wait_queue+0x15/0x44
  [<ffffffff8814d308>] :sunrpc:svc_recv+0x28e/0x40f
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff881a714f>] :nfs:nfs_callback_svc+0xa9/0x149
  [<ffffffff80232f85>] do_exit+0x7bc/0x7c0
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff881a70a6>] :nfs:nfs_callback_svc+0x0/0x149
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

syslogd       R  running task        0  4037      1
klogd         S 0000000000000000     0  4043      1
  ffff81012c6e1bf8 0000000000000082 0000000000000000 ffffffff80227c57
  ffff810005260480 ffff81012c047560 ffff81012fc52e40 ffff81012c047768
  00000001805a3b40 ffffffff803ddc95 00000000ffffffff 0000000000000286
Call Trace:
  [<ffffffff80227c57>] enqueue_task+0x13/0x21
  [<ffffffff803ddc95>] sock_alloc_send_skb+0x77/0x1d2
  [<ffffffff803ddc95>] sock_alloc_send_skb+0x77/0x1d2
  [<ffffffff804489b4>] schedule_timeout+0x1e/0xad
  [<ffffffff803e17b9>] __alloc_skb+0x76/0x121
  [<ffffffff8024149f>] prepare_to_wait_exclusive+0x15/0x5e
  [<ffffffff8043b9b4>] unix_wait_for_peer+0x90/0xac
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff803e08cc>] skb_queue_tail+0x17/0x3e
  [<ffffffff803df401>] sock_def_readable+0x10/0x5f
  [<ffffffff8043bf67>] unix_dgram_sendmsg+0x3fb/0x491
  [<ffffffff803db31f>] sock_aio_write+0xd1/0xe0
  [<ffffffff80277ec8>] do_sync_write+0xc9/0x10c
  [<ffffffff802eebcf>] __up_read+0x13/0x8a
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff802b4818>] kmsg_read+0x3a/0x44
  [<ffffffff8027861b>] vfs_write+0xc0/0x136
  [<ffffffff80278b45>] sys_write+0x45/0x6e
  [<ffffffff8020bdee>] system_call+0x7e/0x83

ypbind        S 0000000000000000     0  4067      1
  ffff81012c3ddb28 0000000000000082 0000000000000000 ffffffff804081d6
  ffff81012c47e300 ffff81012e598720 ffff81012fc52e40 ffff81012e598928
  000000012c47e300 ffffffff804055e5 00000000ffffffff ffffffff80406d2f
Call Trace:
  [<ffffffff804081d6>] ip_output+0x2bb/0x301
  [<ffffffff804055e5>] ip_push_pending_frames+0x3bd/0x425
  [<ffffffff80406d2f>] ip_generic_getfrag+0x0/0x8b
  [<ffffffff804489b4>] schedule_timeout+0x1e/0xad
  [<ffffffff802415e1>] add_wait_queue+0x15/0x44
  [<ffffffff8040caaf>] tcp_poll+0x25/0x138
  [<ffffffff80283b12>] do_sys_poll+0x278/0x360
  [<ffffffff8028451a>] __pollwait+0x0/0xe1
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff803dd31e>] sock_common_recvmsg+0x30/0x45
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff803dbe0b>] sock_recvmsg+0xd5/0xed
  [<ffffffff80258ab2>] find_lock_page+0x26/0xa1
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff803db1f1>] move_addr_to_kernel+0x25/0x36
  [<ffffffff803e2b8e>] verify_iovec+0x46/0x84
  [<ffffffff803dc16a>] sys_sendmsg+0x264/0x287
  [<ffffffff803dc88e>] move_addr_to_user+0x3a/0x4f
  [<ffffffff803dcc1a>] sys_recvfrom+0x121/0x136
  [<ffffffff80228561>] update_curr+0xdf/0xfe
  [<ffffffff80448110>] thread_return+0x0/0xf9
  [<ffffffff80283c2c>] sys_poll+0x32/0x3b
  [<ffffffff8020bdee>] system_call+0x7e/0x83

ypbind        S 0000000000000002     0  4068      1
  ffff81012c3ffe58 0000000000000082 000000000050a000 ffff81012d799040
  ffff810100000766 ffff81012ea46720 ffff81012e598720 ffff81012ea46928
  0000000200000004 00000000ffffffda 0000000000000004 0000000000000002
Call Trace:
  [<ffffffff802473d3>] do_futex+0x30b/0x9e0
  [<ffffffff804489b4>] schedule_timeout+0x1e/0xad
  [<ffffffff8023838b>] recalc_sigpending+0xe/0x25
  [<ffffffff80239f96>] dequeue_signal+0x8d/0x115
  [<ffffffff8023ae14>] sys_rt_sigtimedwait+0x17a/0x255
  [<ffffffff80247b8b>] sys_futex+0xe3/0x101
  [<ffffffff8027867c>] vfs_write+0x121/0x136
  [<ffffffff80278b60>] sys_write+0x60/0x6e
  [<ffffffff8020bdee>] system_call+0x7e/0x83

ypbind        S 0000000000000000     0  4069      1
  ffff81012bc01eb8 0000000000000082 0000000000000000 ffffffff80243b12
  ffff81012bc01ee8 ffff81012e644e40 ffff81012fcc2000 ffff81012e645048
  0000000300000000 ffffffff802433ae 00000000ffffffff ffffffff80243925
Call Trace:
  [<ffffffff80243b12>] ktime_get_ts+0x1a/0x4e
  [<ffffffff802433ae>] enqueue_hrtimer+0x5c/0x63
  [<ffffffff80243925>] hrtimer_start+0xf2/0x104
  [<ffffffff80448e56>] do_nanosleep+0x46/0x77
  [<ffffffff8024398f>] hrtimer_nanosleep+0x58/0x11e
  [<ffffffff802eb8c9>] _atomic_dec_and_lock+0x39/0x58
  [<ffffffff80243553>] hrtimer_wakeup+0x0/0x22
  [<ffffffff80243aa1>] sys_nanosleep+0x4c/0x62
  [<ffffffff8020bdee>] system_call+0x7e/0x83

acpid         S 0000000000000000     0  4143      1
  ffff81012bd0bb28 0000000000000086 0000000000000000 ffffffff80228f46
  ffffffff80466320 ffff81012c046000 ffff81012fc8a720 ffff81012c046208
  0000000200000000 ffff81012f3ee540 00000000ffffffff ffffffff802cafba
Call Trace:
  [<ffffffff80228f46>] __wake_up+0x38/0x4e
  [<ffffffff802cafba>] journal_stop+0x1e2/0x1ee
  [<ffffffff804489b4>] schedule_timeout+0x1e/0xad
  [<ffffffff802ada2d>] pde_users_dec+0x10/0x3f
  [<ffffffff802415e1>] add_wait_queue+0x15/0x44
  [<ffffffff80283b12>] do_sys_poll+0x278/0x360
  [<ffffffff8028451a>] __pollwait+0x0/0xe1
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff80233df8>] current_fs_time+0x1e/0x24
  [<ffffffff8025885f>] file_read_actor+0xa0/0x118
  [<ffffffff8025897e>] find_get_page+0x21/0x50
  [<ffffffff8025a1f4>] __generic_file_aio_write_nolock+0x33e/0x3a8
  [<ffffffff80258ab2>] find_lock_page+0x26/0xa1
  [<ffffffff8025a843>] filemap_fault+0x1e2/0x366
  [<ffffffff802631f2>] __do_fault+0x370/0x3aa
  [<ffffffff80264b64>] handle_mm_fault+0x424/0x772
  [<ffffffff802eebcf>] __up_read+0x13/0x8a
  [<ffffffff8021f1d8>] do_page_fault+0x425/0x779
  [<ffffffff8026d4d5>] free_pages_and_swap_cache+0x73/0x8f
  [<ffffffff8023838b>] recalc_sigpending+0xe/0x25
  [<ffffffff80283c2c>] sys_poll+0x32/0x3b
  [<ffffffff8020bdee>] system_call+0x7e/0x83

courierlogger S 0000000000000000     0  4147      1
  ffff81012bd63ce8 0000000000000082 0000000000000000 ffff810100000000
  0000000000000000 ffff81012bd64e40 ffffffff805354c0 ffff81012bd65048
  00000000051f7bb8 00000000fffffff7 00000000ffffffff 0000000000004000
Call Trace:
  [<ffffffff8027db22>] pipe_wait+0x66/0x8d
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8027e39f>] pipe_read+0x318/0x39a
  [<ffffffff80277fd4>] do_sync_read+0xc9/0x10c
  [<ffffffff8027ada4>] cp_new_stat+0xe7/0xff
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8027873b>] vfs_read+0xaa/0x132
  [<ffffffff80278ad7>] sys_read+0x45/0x6e
  [<ffffffff8020bdee>] system_call+0x7e/0x83

authdaemond   S 0000000000000001     0  4148   4147
  ffff81012bc91a18 0000000000000086 ffff81012bc919e0 ffff81012bc91ab8
  0000000000000000 ffff81012bd65560 ffff81012bd64000 ffff81012bd65768
  000000012ebef800 ffff81012bc91a28 ffff81012c436500 0000000100314abf
Call Trace:
  [<ffffffff80237ddc>] __mod_timer+0xb6/0xc4
  [<ffffffff80448a20>] schedule_timeout+0x8a/0xad
  [<ffffffff80237ba4>] process_timeout+0x0/0x5
  [<ffffffff80284031>] do_select+0x3fc/0x45f
  [<ffffffff8028451a>] __pollwait+0x0/0xe1
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff802c808a>] __ext3_journal_dirty_metadata+0x1e/0x46
  [<ffffffff80241321>] bit_waitqueue+0x16/0x82
  [<ffffffff80287d9d>] __d_lookup+0xb0/0x100
  [<ffffffff8027ec7d>] do_lookup+0x63/0x1ae
  [<ffffffff8025bb9c>] __rmqueue+0x79/0xe6
  [<ffffffff8025c84b>] get_page_from_freelist+0x2c3/0x35e
  [<ffffffff8025c93f>] __alloc_pages+0x59/0x2ae
  [<ffffffff80264706>] __pte_alloc+0x78/0xb2
  [<ffffffff80284250>] core_sys_select+0x1bc/0x265
  [<ffffffff802eebcf>] __up_read+0x13/0x8a
  [<ffffffff8021f1d8>] do_page_fault+0x425/0x779
  [<ffffffff80228561>] update_curr+0xdf/0xfe
  [<ffffffff80284755>] sys_select+0x15a/0x183
  [<ffffffff8020bdee>] system_call+0x7e/0x83

authdaemond   S 0000000000000000     0  4156   4148
  ffff81012c199a18 0000000000000082 0000000000000000 0000000000000000
  0000000000000000 ffff81012bd64000 ffff81012fc52e40 ffff81012bd64208
  0000000100000000 ffff81012c199a28 00000000ffffffff 0000000100314abf
Call Trace:
  [<ffffffff80448a20>] schedule_timeout+0x8a/0xad
  [<ffffffff80237ba4>] process_timeout+0x0/0x5
  [<ffffffff80284031>] do_select+0x3fc/0x45f
  [<ffffffff8028451a>] __pollwait+0x0/0xe1
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff8025c93f>] __alloc_pages+0x59/0x2ae
  [<ffffffff802638ab>] do_wp_page+0x4d4/0x545
  [<ffffffff80258ab2>] find_lock_page+0x26/0xa1
  [<ffffffff8025a843>] filemap_fault+0x1e2/0x366
  [<ffffffff80284250>] core_sys_select+0x1bc/0x265
  [<ffffffff802eebcf>] __up_read+0x13/0x8a
  [<ffffffff8021f1d8>] do_page_fault+0x425/0x779
  [<ffffffff80284755>] sys_select+0x15a/0x183
  [<ffffffff8020bdee>] system_call+0x7e/0x83

authdaemond   S 0000000000000000     0  4157   4148
  ffff81012c6b5a18 0000000000000082 ffff81012c6b59e0 00000000000041ed
  ffff81012c6b5ce8 ffff81012bd64720 ffffffff805354c0 ffff81012bd64928
  000000002e0a4ca8 ffff81012c6b5a28 00000000ffffffff 0000000100314abf
Call Trace:
  [<ffffffff80448a20>] schedule_timeout+0x8a/0xad
  [<ffffffff80237ba4>] process_timeout+0x0/0x5
  [<ffffffff80284031>] do_select+0x3fc/0x45f
  [<ffffffff8028451a>] __pollwait+0x0/0xe1
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff802810d4>] link_path_walk+0xce/0xe0
  [<ffffffff8025bb9c>] __rmqueue+0x79/0xe6
  [<ffffffff8025c93f>] __alloc_pages+0x59/0x2ae
  [<ffffffff80258ab2>] find_lock_page+0x26/0xa1
  [<ffffffff8025a843>] filemap_fault+0x1e2/0x366
  [<ffffffff80284250>] core_sys_select+0x1bc/0x265
  [<ffffffff802eebcf>] __up_read+0x13/0x8a
  [<ffffffff8021f1d8>] do_page_fault+0x425/0x779
  [<ffffffff80284755>] sys_select+0x15a/0x183
  [<ffffffff8020bdee>] system_call+0x7e/0x83

authdaemond   S 0000000000000002     0  4158   4148
  ffff81012daf5a18 0000000000000086 0000000000000000 0000000000000000
  0000000000000000 ffff81012e48d560 ffff81012e372000 ffff81012e48d768
  0000000200000000 ffff81012daf5a28 ffff81012f628e00 0000000100314abf
Call Trace:
  [<ffffffff80237ddc>] __mod_timer+0xb6/0xc4
  [<ffffffff80448a20>] schedule_timeout+0x8a/0xad
  [<ffffffff80237ba4>] process_timeout+0x0/0x5
  [<ffffffff80284031>] do_select+0x3fc/0x45f
  [<ffffffff8028451a>] __pollwait+0x0/0xe1
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff8025c93f>] __alloc_pages+0x59/0x2ae
  [<ffffffff8025bb9c>] __rmqueue+0x79/0xe6
  [<ffffffff80258ab2>] find_lock_page+0x26/0xa1
  [<ffffffff8025a843>] filemap_fault+0x1e2/0x366
  [<ffffffff80284250>] core_sys_select+0x1bc/0x265
  [<ffffffff802eebcf>] __up_read+0x13/0x8a
  [<ffffffff8021f1d8>] do_page_fault+0x425/0x779
  [<ffffffff80284755>] sys_select+0x15a/0x183
  [<ffffffff8020bdee>] system_call+0x7e/0x83

authdaemond   S 0000000000000000     0  4159   4148
  ffff81012bdada18 0000000000000086 0000000000000000 0000000000000000
  0000000000000000 ffff81012e372e40 ffff81012fcc2000 ffff81012e373048
  0000000300000000 ffff81012bdada28 00000000ffffffff 0000000100314abf
Call Trace:
  [<ffffffff80448a20>] schedule_timeout+0x8a/0xad
  [<ffffffff80237ba4>] process_timeout+0x0/0x5
  [<ffffffff80284031>] do_select+0x3fc/0x45f
  [<ffffffff8028451a>] __pollwait+0x0/0xe1
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff8025c93f>] __alloc_pages+0x59/0x2ae
  [<ffffffff8025bb9c>] __rmqueue+0x79/0xe6
  [<ffffffff80258ab2>] find_lock_page+0x26/0xa1
  [<ffffffff8025a843>] filemap_fault+0x1e2/0x366
  [<ffffffff80284250>] core_sys_select+0x1bc/0x265
  [<ffffffff802eebcf>] __up_read+0x13/0x8a
  [<ffffffff8021f1d8>] do_page_fault+0x425/0x779
  [<ffffffff80284755>] sys_select+0x15a/0x183
  [<ffffffff8020bdee>] system_call+0x7e/0x83

authdaemond   S 0000000000000000     0  4160   4148
  ffff81012bdcda18 0000000000000086 0000000000000000 0000000000000000
  0000000000000000 ffff81012e372000 ffff81012fc8a720 ffff81012e372208
  0000000200000000 ffff81012bdcda28 00000000ffffffff 0000000100314abf
Call Trace:
  [<ffffffff80448a20>] schedule_timeout+0x8a/0xad
  [<ffffffff80237ba4>] process_timeout+0x0/0x5
  [<ffffffff80284031>] do_select+0x3fc/0x45f
  [<ffffffff8028451a>] __pollwait+0x0/0xe1
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff8025c93f>] __alloc_pages+0x59/0x2ae
  [<ffffffff80258ab2>] find_lock_page+0x26/0xa1
  [<ffffffff8025a843>] filemap_fault+0x1e2/0x366
  [<ffffffff80284250>] core_sys_select+0x1bc/0x265
  [<ffffffff802eebcf>] __up_read+0x13/0x8a
  [<ffffffff8021f1d8>] do_page_fault+0x425/0x779
  [<ffffffff80284755>] sys_select+0x15a/0x183
  [<ffffffff8020bdee>] system_call+0x7e/0x83

dbus-daemon   S 0000000000000001     0  4162      1
  ffff81012be09b28 0000000000000082 ffff81012be09ad8 ffffffff80228561
  0000000000001e81 ffff81012c398e40 ffff81012e372720 ffff81012c399048
  000000012e372768 ffff8100052aec08 ffff8100052aeb80 ffffffff802287a3
Call Trace:
  [<ffffffff80228561>] update_curr+0xdf/0xfe
  [<ffffffff802287a3>] enqueue_entity+0x17c/0x1a2
  [<ffffffff804489b4>] schedule_timeout+0x1e/0xad
  [<ffffffff802415e1>] add_wait_queue+0x15/0x44
  [<ffffffff80283b12>] do_sys_poll+0x278/0x360
  [<ffffffff8028451a>] __pollwait+0x0/0xe1
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
sage repeated 3 times
  [<ffffffff803db40b>] sock_aio_read+0xdd/0xec
  [<ffffffff80277fd4>] do_sync_read+0xc9/0x10c
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff802784c5>] do_readv_writev+0x176/0x18b
  [<ffffffff80283c2c>] sys_poll+0x32/0x3b
  [<ffffffff8020bdee>] system_call+0x7e/0x83

hald          S 0000000000000000     0  4170      1
  ffff81012bf17b28 0000000000000082 0000000000000000 0000000000000000
  00000000000000d0 ffff81012e372720 ffff81012fc52e40 ffff81012e372928
  000000012bf17f68 ffff81012c398e40 00000000ffffffff ffff810003b931a0
Call Trace:
  [<ffffffff804489b4>] schedule_timeout+0x1e/0xad
  [<ffffffff80284572>] __pollwait+0x58/0xe1
  [<ffffffff802415e1>] add_wait_queue+0x15/0x44
  [<ffffffff802af526>] mounts_poll+0x39/0x56
  [<ffffffff80283b12>] do_sys_poll+0x278/0x360
  [<ffffffff8028451a>] __pollwait+0x0/0xe1
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
sage repeated 9 times
  [<ffffffff802784c5>] do_readv_writev+0x176/0x18b
  [<ffffffff802679e6>] unmap_region+0x114/0x12a
  [<ffffffff80283c2c>] sys_poll+0x32/0x3b
  [<ffffffff8020bdee>] system_call+0x7e/0x83

hald-runner   S 0000000000000000     0  4171   4170
  ffff81012bf39b28 0000000000000082 0000000000000000 ffffffff802287a3
  00000010000204d0 ffff81012e48c000 ffff81012fc52e40 ffff81012e48c208
  000000012bf39ae8 ffffffff80227c57 00000000ffffffff ffff8100052c0b80
Call Trace:
  [<ffffffff802287a3>] enqueue_entity+0x17c/0x1a2
  [<ffffffff80227c57>] enqueue_task+0x13/0x21
  [<ffffffff804489b4>] schedule_timeout+0x1e/0xad
  [<ffffffff802415e1>] add_wait_queue+0x15/0x44
  [<ffffffff80283b12>] do_sys_poll+0x278/0x360
  [<ffffffff8028451a>] __pollwait+0x0/0xe1
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff803db31f>] sock_aio_write+0xd1/0xe0
  [<ffffffff803db24e>] sock_aio_write+0x0/0xe0
  [<ffffffff80277db8>] do_sync_readv_writev+0xc0/0x107
  [<ffffffff802635b0>] do_wp_page+0x1d9/0x545
  [<ffffffff80264e33>] handle_mm_fault+0x6f3/0x772
  [<ffffffff802eebcf>] __up_read+0x13/0x8a
  [<ffffffff8021f1d8>] do_page_fault+0x425/0x779
  [<ffffffff802784c5>] do_readv_writev+0x176/0x18b
  [<ffffffff80241559>] remove_wait_queue+0x12/0x44
  [<ffffffff802326a5>] do_wait+0xa1e/0xace
  [<ffffffff8027d80d>] pipe_release+0x80/0x8b
  [<ffffffff80283c2c>] sys_poll+0x32/0x3b
  [<ffffffff8020bdee>] system_call+0x7e/0x83

hald-addon-ke S 0000000000000000     0  4179   4171
  ffff81012b5fdea8 0000000000000086 0000000000000000 00000002b25b6228
  ffff81012dd1a9c0 ffff81012e644720 ffff81012fcc2000 ffff81012e644928
  0000000300000000 00002b25b62fc8d0 00000000ffffffff 0000000000000000
Call Trace:
  [<ffffffff88099c94>] :evdev:evdev_read+0xff/0x211
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff80269820>] do_mmap_pgoff+0x27b/0x2db
  [<ffffffff8027873b>] vfs_read+0xaa/0x132
  [<ffffffff80278ad7>] sys_read+0x45/0x6e
  [<ffffffff8020bdee>] system_call+0x7e/0x83

hald-addon-hi S 0000000000000001     0  4186   4171
  ffff81012b68da18 0000000000000086 ffff8100052aeb80 0000000000000002
  ffff81012b68da08 ffff81012c398720 ffff81012e372720 ffff81012c398928
  000000012b68d9f0 ffff81012b68da5c ffff81012b68d9d8 ffff81012b68da5c
Call Trace:
  [<ffffffff8022ccd5>] load_balance_start_fair+0x0/0x2b
  [<ffffffff80228918>] load_balance_next_fair+0x0/0x2b
  [<ffffffff804489b4>] schedule_timeout+0x1e/0xad
  [<ffffffff802415e1>] add_wait_queue+0x15/0x44
  [<ffffffff80284031>] do_select+0x3fc/0x45f
  [<ffffffff8028451a>] __pollwait+0x0/0xe1
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff80227f17>] __wake_up_common+0x3e/0x68
  [<ffffffff80228f46>] __wake_up+0x38/0x4e
  [<ffffffff8043da8e>] unix_write_space+0x45/0x70
  [<ffffffff803e09d0>] skb_dequeue+0x48/0x50
  [<ffffffff8043c995>] unix_stream_recvmsg+0x439/0x4ea
  [<ffffffff803db40b>] sock_aio_read+0xdd/0xec
  [<ffffffff80284250>] core_sys_select+0x1bc/0x265
  [<ffffffff802eebcf>] __up_read+0x13/0x8a
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff802784c5>] do_readv_writev+0x176/0x18b
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff802846bc>] sys_select+0xc1/0x183
  [<ffffffff80278ad7>] sys_read+0x45/0x6e
  [<ffffffff8020bdee>] system_call+0x7e/0x83

hald-addon-st S 0000000000000000     0  4195   4171
  ffff81012b773eb8 0000000000000086 0000000000000000 ffffffff80243b12
  ffff81012b773ee8 ffff81012d4cd560 ffff81012fcc2000 ffff81012d4cd768
  0000000300000000 ffffffff802433ae 00000000ffffffff ffffffff80243925
Call Trace:
  [<ffffffff80243b12>] ktime_get_ts+0x1a/0x4e
  [<ffffffff802433ae>] enqueue_hrtimer+0x5c/0x63
  [<ffffffff80243925>] hrtimer_start+0xf2/0x104
  [<ffffffff80448e56>] do_nanosleep+0x46/0x77
  [<ffffffff8024398f>] hrtimer_nanosleep+0x58/0x11e
  [<ffffffff80243553>] hrtimer_wakeup+0x0/0x22
  [<ffffffff80243aa1>] sys_nanosleep+0x4c/0x62
  [<ffffffff8020bdee>] system_call+0x7e/0x83

hald-addon-st S 0000000000000000     0  4209   4171
  ffff81012b733eb8 0000000000000086 0000000000000000 ffffffff80243b12
  ffff81012b733ee8 ffff81012c399560 ffff81012fcc2000 ffff81012c399768
  0000000300000000 ffffffff802433ae 00000000ffffffff ffffffff80243925
Call Trace:
  [<ffffffff80243b12>] ktime_get_ts+0x1a/0x4e
  [<ffffffff802433ae>] enqueue_hrtimer+0x5c/0x63
  [<ffffffff80243925>] hrtimer_start+0xf2/0x104
  [<ffffffff80448e56>] do_nanosleep+0x46/0x77
  [<ffffffff8024398f>] hrtimer_nanosleep+0x58/0x11e
  [<ffffffff8029a2c4>] __blkdev_put+0x136/0x142
  [<ffffffff80243553>] hrtimer_wakeup+0x0/0x22
  [<ffffffff80243aa1>] sys_nanosleep+0x4c/0x62
  [<ffffffff8020bdee>] system_call+0x7e/0x83

avahi-daemon  S 0000000000000000     0  4226      1
  ffff81012b769b28 0000000000000086 0000000000000000 ffff810129cff300
  ffff81012cfb2c00 ffff81012ec74000 ffff81012fc8a720 ffff81012ec74208
  000000022cfb2c00 ffff81012b769b38 00000000ffffffff 00000001003118ad
Call Trace:
  [<ffffffff80448a20>] schedule_timeout+0x8a/0xad
  [<ffffffff80237ba4>] process_timeout+0x0/0x5
  [<ffffffff80283b12>] do_sys_poll+0x278/0x360
  [<ffffffff8028451a>] __pollwait+0x0/0xe1
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
sage repeated 6 times
  [<ffffffff80277fd4>] do_sync_read+0xc9/0x10c
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff80228561>] update_curr+0xdf/0xfe
  [<ffffffff80422729>] udp_ioctl+0x75/0x7a
  [<ffffffff80283c2c>] sys_poll+0x32/0x3b
  [<ffffffff8020bdee>] system_call+0x7e/0x83

avahi-daemon  S 0000000000000000     0  4227   4226
  ffff81012b7d9c18 0000000000000086 0000000000000000 ffffffff8043d3ce
  0000000000000001 ffff81012d97a720 ffff81012fcc2000 ffff81012d97a928
  000000032e668dc0 ffff81012d953200 00000000ffffffff ffffffff0000006a
Call Trace:
  [<ffffffff8043d3ce>] unix_stream_sendmsg+0x262/0x329
  [<ffffffff804489b4>] schedule_timeout+0x1e/0xad
  [<ffffffff803dbeee>] sock_sendmsg+0xcb/0xe3
  [<ffffffff802414fd>] prepare_to_wait+0x15/0x5f
  [<ffffffff8043c7a1>] unix_stream_recvmsg+0x245/0x4ea
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff803db40b>] sock_aio_read+0xdd/0xec
  [<ffffffff803dc11a>] sys_sendmsg+0x214/0x287
  [<ffffffff80277fd4>] do_sync_read+0xc9/0x10c
  [<ffffffff802eebcf>] __up_read+0x13/0x8a
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff802eb8c9>] _atomic_dec_and_lock+0x39/0x58
  [<ffffffff8027874e>] vfs_read+0xbd/0x132
  [<ffffffff80278ad7>] sys_read+0x45/0x6e
  [<ffffffff8020bdee>] system_call+0x7e/0x83

exim4         S 0000000000000000     0  4275      1
  ffff81012b021a18 0000000000000082 0000000000000000 ffff81012b810888
  ffff81012c28a208 ffff81012b6b0720 ffff81012fc8a720 ffff81012b6b0928
  0000000200001000 ffff81012fc8a720 00000000ffffffff ffff81012d520f78
Call Trace:
  [<ffffffff804489b4>] schedule_timeout+0x1e/0xad
  [<ffffffff802415e1>] add_wait_queue+0x15/0x44
  [<ffffffff8040caaf>] tcp_poll+0x25/0x138
  [<ffffffff80284031>] do_select+0x3fc/0x45f
  [<ffffffff8028451a>] __pollwait+0x0/0xe1
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff80259e5a>] generic_file_buffered_write+0x639/0x695
  [<ffffffff8025bb9c>] __rmqueue+0x79/0xe6
  [<ffffffff802ef67d>] number+0x119/0x204
  [<ffffffff8025c800>] get_page_from_freelist+0x278/0x35e
  [<ffffffff8025bb9c>] __rmqueue+0x79/0xe6
  [<ffffffff802f038b>] vsnprintf+0x561/0x5a5
  [<ffffffff80284250>] core_sys_select+0x1bc/0x265
  [<ffffffff80287e0b>] d_lookup+0x1e/0x42
  [<ffffffff802af809>] proc_flush_task+0x4e/0x1f6
  [<ffffffff80241559>] remove_wait_queue+0x12/0x44
  [<ffffffff802846bc>] sys_select+0xc1/0x183
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff8020bdee>] system_call+0x7e/0x83

hddtemp       S 0000000000000000     0  4425      1
  ffff81012b3efa18 0000000000000082 0000000000000000 00000000ffffffff
  ffff81012be2a720 ffff81012be2a720 ffff81012fc8a720 ffff81012be2a928
  0000000200000000 ffff81012b3efa28 00000000ffffffff 0000000100310655
Call Trace:
  [<ffffffff80448a20>] schedule_timeout+0x8a/0xad
  [<ffffffff80237ba4>] process_timeout+0x0/0x5
  [<ffffffff80284031>] do_select+0x3fc/0x45f
  [<ffffffff80227c57>] enqueue_task+0x13/0x21
  [<ffffffff8028451a>] __pollwait+0x0/0xe1
  [<ffffffff80274a24>] __slab_alloc+0xba/0x53a
  [<ffffffff803e1774>] __alloc_skb+0x31/0x121
  [<ffffffff803e17b9>] __alloc_skb+0x76/0x121
  [<ffffffff803ddc95>] sock_alloc_send_skb+0x77/0x1d2
  [<ffffffff80228f46>] __wake_up+0x38/0x4e
  [<ffffffff803e2909>] memcpy_fromiovec+0x36/0x66
  [<ffffffff803e08cc>] skb_queue_tail+0x17/0x3e
  [<ffffffff803df401>] sock_def_readable+0x10/0x5f
  [<ffffffff8043bf67>] unix_dgram_sendmsg+0x3fb/0x491
  [<ffffffff803dbeee>] sock_sendmsg+0xcb/0xe3
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff80284250>] core_sys_select+0x1bc/0x265
  [<ffffffff8028140e>] do_path_lookup+0x1a0/0x1c2
  [<ffffffff802eb8c9>] _atomic_dec_and_lock+0x39/0x58
  [<ffffffff8028bba8>] mntput_no_expire+0x1c/0x80
  [<ffffffff8027ada4>] cp_new_stat+0xe7/0xff
  [<ffffffff803dc2b5>] sys_sendto+0x128/0x151
  [<ffffffff80284755>] sys_select+0x15a/0x183
  [<ffffffff8020bdee>] system_call+0x7e/0x83

lpd           S 0000000000000000     0  4435      1
  ffff81012ac19a18 0000000000000082 0000000000000000 0000000000000000
  0000000000000001 ffff81012b18a720 ffff81012fc8a720 ffff81012b18a928
  0000000200000001 0000000000000000 00000000ffffffff ffff81012b18a720
Call Trace:
  [<ffffffff804489b4>] schedule_timeout+0x1e/0xad
  [<ffffffff8025acf6>] mempool_alloc+0x24/0xda
  [<ffffffff802415e1>] add_wait_queue+0x15/0x44
  [<ffffffff80284031>] do_select+0x3fc/0x45f
  [<ffffffff8028451a>] __pollwait+0x0/0xe1
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff8044817e>] thread_return+0x6e/0xf9
  [<ffffffff80227f17>] __wake_up_common+0x3e/0x68
  [<ffffffff80228f46>] __wake_up+0x38/0x4e
  [<ffffffff80287198>] dput+0x1c/0x10b
  [<ffffffff8027eab8>] __follow_mount+0x26/0x7b
  [<ffffffff8027ec7d>] do_lookup+0x63/0x1ae
  [<ffffffff80287d9d>] __d_lookup+0xb0/0x100
  [<ffffffff8027ec7d>] do_lookup+0x63/0x1ae
  [<ffffffff80287d9d>] __d_lookup+0xb0/0x100
  [<ffffffff8027ec7d>] do_lookup+0x63/0x1ae
  [<ffffffff80287198>] dput+0x1c/0x10b
  [<ffffffff80280eb1>] __link_path_walk+0xbb7/0xd0c
  [<ffffffff8028bba8>] mntput_no_expire+0x1c/0x80
  [<ffffffff80284250>] core_sys_select+0x1bc/0x265
  [<ffffffff8028aaee>] notify_change+0x287/0x2ad
  [<ffffffff80276e56>] chown_common+0xa8/0xb3
  [<ffffffff8028bba8>] mntput_no_expire+0x1c/0x80
  [<ffffffff802846bc>] sys_select+0xc1/0x183
  [<ffffffff8043c3db>] unix_listen+0x49/0xd8
  [<ffffffff8020bdee>] system_call+0x7e/0x83

lockd         S 0000000000000001     0  4464      2
  ffff81012ad83e10 0000000000000046 ffff81012b73b400 ffffffff80449c4f
  ffff81012bf2fc00 ffff81012d4cce40 ffff81012b01d560 ffff81012d4cd048
  000000012cee0780 ffff81012b01d560 ffff81012c6a0028 0000000000000000
Call Trace:
  [<ffffffff80449c4f>] _spin_lock_bh+0x9/0x19
  [<ffffffff804489b4>] schedule_timeout+0x1e/0xad
  [<ffffffff8814c9c0>] :sunrpc:svc_sock_release+0xf0/0x170
  [<ffffffff802415e1>] add_wait_queue+0x15/0x44
  [<ffffffff8814d308>] :sunrpc:svc_recv+0x28e/0x40f
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff88174686>] :lockd:lockd+0x134/0x262
  [<ffffffff80232f85>] do_exit+0x7bc/0x7c0
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff88174552>] :lockd:lockd+0x0/0x262
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

nfsd4         S 0000000000000000     0  4467      2
  ffff81012ae79ed0 0000000000000046 0000000000000000 ffffffff8023e5fe
  000000004730b4d2 ffff81012d4cc000 ffff81012fcc2000 ffff81012d4cc208
  000000034730e772 ffffffff881f852f 00000000ffffffff ffff81012ae79e80
Call Trace:
  [<ffffffff8023e5fe>] queue_delayed_work_on+0xae/0xbe
  [<ffffffff881f852f>] :nfsd:laundromat_main+0x20b/0x216
  [<ffffffff881f8324>] :nfsd:laundromat_main+0x0/0x216
  [<ffffffff8023e6c7>] worker_thread+0x74/0x9b
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8023e653>] worker_thread+0x0/0x9b
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

nfsd          S 0000000000000000     0  4468      2
  ffff81012aecde30 0000000000000046 0000000000000000 ffffffff80449c4f
  ffff81012fe21900 ffff81012be2b560 ffff81012fc8a720 ffff81012be2b768
  000000022cee0a00 ffff81012aecde40 00000000ffffffff 000000010035e62b
Call Trace:
  [<ffffffff80449c4f>] _spin_lock_bh+0x9/0x19
  [<ffffffff80448a20>] schedule_timeout+0x8a/0xad
  [<ffffffff80237ba4>] process_timeout+0x0/0x5
  [<ffffffff8814d308>] :sunrpc:svc_recv+0x28e/0x40f
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff881e17a6>] :nfsd:nfsd+0xdb/0x2ad
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff881e16cb>] :nfsd:nfsd+0x0/0x2ad
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

nfsd          S 0000000000000003     0  4469      2
  ffff81012af4fe30 0000000000000046 ffff81012b73b400 ffffffff80276816
  ffff81012c7ef8c0 ffff81012be2a000 ffff81012be2ae40 ffff81012be2a208
  000000032eb6a740 ffff81012af4fe40 ffff81012aece000 000000010035e62b
Call Trace:
  [<ffffffff80276816>] filp_close+0x5d/0x65
  [<ffffffff80237ddc>] __mod_timer+0xb6/0xc4
  [<ffffffff80448a20>] schedule_timeout+0x8a/0xad
  [<ffffffff80237ba4>] process_timeout+0x0/0x5
  [<ffffffff8814d308>] :sunrpc:svc_recv+0x28e/0x40f
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff881e17a6>] :nfsd:nfsd+0xdb/0x2ad
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff881e16cb>] :nfsd:nfsd+0x0/0x2ad
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

nfsd          S 0000000000000003     0  4470      2
  ffff81012afd1e30 0000000000000046 ffff81012b73b400 ffffffff80276816
  ffff81012c7eedc0 ffff81012be2ae40 ffff81012b6b1560 ffff81012be2b048
  000000032eb6a980 ffff81012afd1e40 ffff81012af50000 000000010035e62b
Call Trace:
  [<ffffffff80276816>] filp_close+0x5d/0x65
  [<ffffffff80237ddc>] __mod_timer+0xb6/0xc4
  [<ffffffff80448a20>] schedule_timeout+0x8a/0xad
  [<ffffffff80237ba4>] process_timeout+0x0/0x5
  [<ffffffff8814d308>] :sunrpc:svc_recv+0x28e/0x40f
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff881e17a6>] :nfsd:nfsd+0xdb/0x2ad
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff881e16cb>] :nfsd:nfsd+0x0/0x2ad
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

nfsd          S 0000000000000002     0  4471      2
  ffff81012a871e30 0000000000000046 ffff81012b73b400 ffffffff80276816
  ffff81012cfe8840 ffff81012fe15560 ffff81012be2b560 ffff81012fe15768
  000000022eb6a440 ffff81012a871e40 ffff81012afd2000 000000010035e62b
Call Trace:
  [<ffffffff80276816>] filp_close+0x5d/0x65
  [<ffffffff80237ddc>] __mod_timer+0xb6/0xc4
  [<ffffffff80448a20>] schedule_timeout+0x8a/0xad
  [<ffffffff80237ba4>] process_timeout+0x0/0x5
  [<ffffffff8814d308>] :sunrpc:svc_recv+0x28e/0x40f
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff881e17a6>] :nfsd:nfsd+0xdb/0x2ad
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff881e16cb>] :nfsd:nfsd+0x0/0x2ad
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

nfsd          S 0000000000000002     0  4472      2
  ffff81012a8f3e30 0000000000000046 ffff81012b73b400 ffffffff80276816
  ffff81012a8f4000 ffff81012e598e40 ffff81012fe15560 ffff81012e599048
  000000022eb6aec0 ffff81012a8f3e40 ffff81012a872000 000000010035e62b
Call Trace:
  [<ffffffff80276816>] filp_close+0x5d/0x65
  [<ffffffff80237ddc>] __mod_timer+0xb6/0xc4
  [<ffffffff80448a20>] schedule_timeout+0x8a/0xad
  [<ffffffff80237ba4>] process_timeout+0x0/0x5
  [<ffffffff8814d308>] :sunrpc:svc_recv+0x28e/0x40f
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff881e17a6>] :nfsd:nfsd+0xdb/0x2ad
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff881e16cb>] :nfsd:nfsd+0x0/0x2ad
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

nfsd          S 0000000000000000     0  4473      2
  ffff81012a979e30 0000000000000046 0000000000000000 ffffffff80276816
  ffff81012a8f42c0 ffff81012c398000 ffff81012fcc2000 ffff81012c398208
  000000032f0763c4 ffff81012a979e40 00000000ffffffff 000000010035e634
Call Trace:
  [<ffffffff80276816>] filp_close+0x5d/0x65
  [<ffffffff80448a20>] schedule_timeout+0x8a/0xad
  [<ffffffff80237ba4>] process_timeout+0x0/0x5
  [<ffffffff8814d308>] :sunrpc:svc_recv+0x28e/0x40f
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff881e17a6>] :nfsd:nfsd+0xdb/0x2ad
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff881e16cb>] :nfsd:nfsd+0x0/0x2ad
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

nfsd          S 0000000000000000     0  4474      2
  ffff81012a9fbe30 0000000000000046 0000000000000000 0000000000000080
  0000000000000000 ffff81012b6b0e40 ffff81012fc8a720 ffff81012b6b1048
  0000000200008000 ffff81012a9fbe40 00000000ffffffff 000000010035e634
Call Trace:
  [<ffffffff80448a20>] schedule_timeout+0x8a/0xad
  [<ffffffff80237ba4>] process_timeout+0x0/0x5
  [<ffffffff8814d308>] :sunrpc:svc_recv+0x28e/0x40f
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff804496f0>] __down_read+0x12/0x9a
  [<ffffffff881e17a6>] :nfsd:nfsd+0xdb/0x2ad
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff881e16cb>] :nfsd:nfsd+0x0/0x2ad
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

nfsd          S 0000000000000000     0  4475      2
  ffff81012aa7de30 0000000000000046 0000000000000000 ffffffff80276816
  ffff81012a8f4840 ffff81012b6b1560 ffff81012fcc2000 ffff81012b6b1768
  000000032eb6aa00 ffff81012aa7de40 00000000ffffffff 000000010035e62b
Call Trace:
  [<ffffffff80276816>] filp_close+0x5d/0x65
  [<ffffffff80448a20>] schedule_timeout+0x8a/0xad
  [<ffffffff80237ba4>] process_timeout+0x0/0x5
  [<ffffffff8814d308>] :sunrpc:svc_recv+0x28e/0x40f
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff881e17a6>] :nfsd:nfsd+0xdb/0x2ad
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff881e16cb>] :nfsd:nfsd+0x0/0x2ad
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

rpc.mountd    S 0000000000000003     0  4479      1
  ffff81012aaf9a18 0000000000000086 0000000000000000 0000000000000000
  0000000000000000 ffff81012fcf5560 ffff81012b6b0000 ffff81012fcf5768
  0000000300000000 0000000000000000 0000000000000000 0000000000000000
Call Trace:
  [<ffffffff804489b4>] schedule_timeout+0x1e/0xad
  [<ffffffff802415e1>] add_wait_queue+0x15/0x44
  [<ffffffff8040caaf>] tcp_poll+0x25/0x138
  [<ffffffff80284031>] do_select+0x3fc/0x45f
  [<ffffffff8028451a>] __pollwait+0x0/0xe1
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
sage repeated 4 times
  [<ffffffff80287198>] dput+0x1c/0x10b
  [<ffffffff80280eb1>] __link_path_walk+0xbb7/0xd0c
  [<ffffffff80258ab2>] find_lock_page+0x26/0xa1
  [<ffffffff8025a843>] filemap_fault+0x1e2/0x366
  [<ffffffff80284250>] core_sys_select+0x1bc/0x265
  [<ffffffff8027a970>] chrdev_open+0x167/0x196
  [<ffffffff802eebcf>] __up_read+0x13/0x8a
  [<ffffffff8021f1d8>] do_page_fault+0x425/0x779
  [<ffffffff80276ba4>] do_filp_open+0x2d/0x3d
  [<ffffffff802f1117>] strncpy_from_user+0x36/0x4b
  [<ffffffff802846bc>] sys_select+0xc1/0x183
  [<ffffffff8020bdee>] system_call+0x7e/0x83

nscd          S 0000000000000000     0  4490      1
  ffff81012aac1e98 0000000000000086 0000000000000000 000000000000118a
  000055555566c524 ffff81012ecbe000 ffffffff805354c0 ffff81012ecbe208
  0000000000000000 ffff81012aac1ea8 00000000ffffffff 0000000100310ab5
Call Trace:
  [<ffffffff80448a20>] schedule_timeout+0x8a/0xad
  [<ffffffff80237ba4>] process_timeout+0x0/0x5
  [<ffffffff8029e84e>] sys_epoll_wait+0x17f/0x421
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff8020bdee>] system_call+0x7e/0x83

nscd          S 0000000000000000     0  4496      1
  ffff81012acb1cd8 0000000000000086 0000000000000000 ffffffff802ee66c
  ffff81012acb1d78 ffff81012b18b560 ffff81012fc8a720 ffff81012b18b768
  00000002ffffffff ffffffff802433ae 00000000ffffffff ffffffff80243925
Call Trace:
  [<ffffffff802ee66c>] rb_insert_color+0xb2/0xda
  [<ffffffff802433ae>] enqueue_hrtimer+0x5c/0x63
  [<ffffffff80243925>] hrtimer_start+0xf2/0x104
  [<ffffffff80246c9a>] futex_wait+0x23f/0x304
  [<ffffffff80243553>] hrtimer_wakeup+0x0/0x22
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff8024713c>] do_futex+0x74/0x9e0
  [<ffffffff80244b2b>] getnstimeofday+0x32/0x8b
  [<ffffffff80243b12>] ktime_get_ts+0x1a/0x4e
  [<ffffffff80247b8b>] sys_futex+0xe3/0x101
  [<ffffffff80244b2b>] getnstimeofday+0x32/0x8b
  [<ffffffff8020bdee>] system_call+0x7e/0x83

nscd          S 0000000000000000     0  4497      1
  ffff81012ab8dcd8 0000000000000086 0000000000000000 ffff81012f0741ed
  ffff81012ab8dd78 ffff81012b18a000 ffff81012fc52e40 ffff81012b18a208
  00000001ffffffff ffffffff802433ae 00000000ffffffff ffffffff80243925
Call Trace:
  [<ffffffff802433ae>] enqueue_hrtimer+0x5c/0x63
  [<ffffffff80243925>] hrtimer_start+0xf2/0x104
  [<ffffffff80246c9a>] futex_wait+0x23f/0x304
  [<ffffffff80243553>] hrtimer_wakeup+0x0/0x22
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff8024713c>] do_futex+0x74/0x9e0
  [<ffffffff80244b2b>] getnstimeofday+0x32/0x8b
  [<ffffffff80243b12>] ktime_get_ts+0x1a/0x4e
  [<ffffffff80247b8b>] sys_futex+0xe3/0x101
  [<ffffffff80244b2b>] getnstimeofday+0x32/0x8b
  [<ffffffff8020bdee>] system_call+0x7e/0x83

nscd          S 0000000000000000     0  4498      1
  ffff81012ab8fcd8 0000000000000086 0000000000000000 ffff81012f0741ed
  ffff81012ab8fd78 ffff81012ecbe720 ffffffff805354c0 ffff81012ecbe928
  00000000ffffffff ffffffff802433ae 00000000ffffffff ffffffff80243925
Call Trace:
  [<ffffffff802433ae>] enqueue_hrtimer+0x5c/0x63
  [<ffffffff80243925>] hrtimer_start+0xf2/0x104
  [<ffffffff80246c9a>] futex_wait+0x23f/0x304
  [<ffffffff80243553>] hrtimer_wakeup+0x0/0x22
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff8024713c>] do_futex+0x74/0x9e0
  [<ffffffff80244b2b>] getnstimeofday+0x32/0x8b
  [<ffffffff80243b12>] ktime_get_ts+0x1a/0x4e
  [<ffffffff80247b8b>] sys_futex+0xe3/0x101
  [<ffffffff80244b2b>] getnstimeofday+0x32/0x8b
  [<ffffffff8020bdee>] system_call+0x7e/0x83

nscd          S 0000000000000003     0  4499      1
  ffff81012ab91cd8 0000000000000086 0000000000000000 ffffffff00000001
  0000000000000000 ffff81012c046720 ffff810129a82e40 ffff81012c046928
  0000000300000000 ffffffff80267d50 000055555566c000 ffff81012ab91d40
Call Trace:
  [<ffffffff80267d50>] find_extend_vma+0x16/0x59
  [<ffffffff80246010>] get_futex_key+0x82/0x14e
  [<ffffffff80246c4b>] futex_wait+0x1f0/0x304
  [<ffffffff802290dc>] task_rq_lock+0x3d/0x6f
  [<ffffffff802295e5>] try_to_wake_up+0x2c3/0x2d4
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff8024713c>] do_futex+0x74/0x9e0
  [<ffffffff80228f46>] __wake_up+0x38/0x4e
  [<ffffffff8028bba8>] mntput_no_expire+0x1c/0x80
  [<ffffffff80241321>] bit_waitqueue+0x16/0x82
  [<ffffffff80247b8b>] sys_futex+0xe3/0x101
  [<ffffffff80276816>] filp_close+0x5d/0x65
  [<ffffffff8020bdee>] system_call+0x7e/0x83

nscd          S 0000000000000000     0  4500      1
  ffff81012abb3cd8 0000000000000086 0000000000000000 ffffffff80228f46
  ffff81012ecb5700 ffff81012c046e40 ffff81012fc52e40 ffff81012c047048
  0000000100000040 ffffffff80267d50 00000000ffffffff ffff81012abb3d40
Call Trace:
  [<ffffffff80228f46>] __wake_up+0x38/0x4e
  [<ffffffff80267d50>] find_extend_vma+0x16/0x59
  [<ffffffff80246c4b>] futex_wait+0x1f0/0x304
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff8024713c>] do_futex+0x74/0x9e0
  [<ffffffff80228f46>] __wake_up+0x38/0x4e
  [<ffffffff8028bba8>] mntput_no_expire+0x1c/0x80
  [<ffffffff80241321>] bit_waitqueue+0x16/0x82
  [<ffffffff80247b8b>] sys_futex+0xe3/0x101
  [<ffffffff80276816>] filp_close+0x5d/0x65
  [<ffffffff8020bdee>] system_call+0x7e/0x83

nscd          S 0000000000000000     0  4501      1
  ffff81012abb5cd8 0000000000000086 0000000000000000 ffffffff00000001
  0000000000000000 ffff81012b6b0000 ffff81012fc8a720 ffff81012b6b0208
  0000000200000000 ffffffff80267d50 00000000ffffffff ffff81012abb5d40
Call Trace:
  [<ffffffff80267d50>] find_extend_vma+0x16/0x59
  [<ffffffff80246c4b>] futex_wait+0x1f0/0x304
  [<ffffffff803e2b8e>] verify_iovec+0x46/0x84
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff8024713c>] do_futex+0x74/0x9e0
  [<ffffffff80228f46>] __wake_up+0x38/0x4e
  [<ffffffff8028bba8>] mntput_no_expire+0x1c/0x80
  [<ffffffff80241321>] bit_waitqueue+0x16/0x82
  [<ffffffff80247b8b>] sys_futex+0xe3/0x101
  [<ffffffff80276816>] filp_close+0x5d/0x65
  [<ffffffff8020bdee>] system_call+0x7e/0x83

inetd         S 0000000000000000     0  4502      1
  ffff81012ab89a18 0000000000000082 0000000000000000 000a80d200000000
  ffffffff80545cd8 ffff81012ec74e40 ffff81012fcc2000 ffff81012ec75048
  00000003000a80d2 ffff81012fcc2000 00000000ffffffff ffff81012ec74e40
Call Trace:
  [<ffffffff804489b4>] schedule_timeout+0x1e/0xad
  [<ffffffff802415e1>] add_wait_queue+0x15/0x44
  [<ffffffff8040caaf>] tcp_poll+0x25/0x138
  [<ffffffff80284031>] do_select+0x3fc/0x45f
  [<ffffffff8028451a>] __pollwait+0x0/0xe1
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff80324d32>] extract_buf+0xe9/0xf9
  [<ffffffff803248a9>] __add_entropy_words+0x5d/0x184
  [<ffffffff802ef67d>] number+0x119/0x204
  [<ffffffff8025c800>] get_page_from_freelist+0x278/0x35e
  [<ffffffff802f038b>] vsnprintf+0x561/0x5a5
  [<ffffffff80284250>] core_sys_select+0x1bc/0x265
  [<ffffffff80287167>] d_kill+0x44/0x59
  [<ffffffff80287198>] dput+0x1c/0x10b
  [<ffffffff802af874>] proc_flush_task+0xb9/0x1f6
  [<ffffffff80241559>] remove_wait_queue+0x12/0x44
  [<ffffffff802846bc>] sys_select+0xc1/0x183
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff8023ab09>] sys_rt_sigprocmask+0x50/0xce
  [<ffffffff8020bdee>] system_call+0x7e/0x83

nmbd          S 0000000000000000     0  4511      1
  ffff81012a5c5a18 0000000000000086 0000000000000000 ffff81012ea8ba00
  ffff8100a4868300 ffff81012b01c720 ffffffff805354c0 ffff81012b01c928
  0000000000000000 ffff81012a5c5a28 00000000ffffffff 000000010030feb1
Call Trace:
  [<ffffffff80448a20>] schedule_timeout+0x8a/0xad
  [<ffffffff80237ba4>] process_timeout+0x0/0x5
  [<ffffffff80284031>] do_select+0x3fc/0x45f
  [<ffffffff8028451a>] __pollwait+0x0/0xe1
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
sage repeated 6 times
  [<ffffffff803dbe0b>] sock_recvmsg+0xd5/0xed
  [<ffffffff8025d9cf>] balance_dirty_pages_ratelimited_nr+0x1e5/0x1f4
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff80284250>] core_sys_select+0x1bc/0x265
  [<ffffffff803e7f63>] netdev_run_todo+0x220/0x229
  [<ffffffff803e542d>] __dev_get_by_name+0x72/0x85
  [<ffffffff803ddac9>] lock_sock_nested+0xa2/0xad
  [<ffffffff80449c4f>] _spin_lock_bh+0x9/0x19
  [<ffffffff803dd99f>] release_sock+0x13/0x9b
  [<ffffffff80241321>] bit_waitqueue+0x16/0x82
  [<ffffffff802413cb>] wake_up_bit+0x11/0x22
  [<ffffffff80284755>] sys_select+0x15a/0x183
  [<ffffffff8020bdee>] system_call+0x7e/0x83

smbd          S 0000000000000000     0  4513      1
  ffff81012a081a18 0000000000000086 0000000000000000 ffffffff80229af5
  0000000000470842 ffff81012ac4ce40 ffff81012fc52e40 ffff81012ac4d048
  0000000100000001 ffff81012fc52e40 00000000ffffffff 0000000000000001
Call Trace:
  [<ffffffff80229af5>] find_busiest_group+0x254/0x6d6
  [<ffffffff804489b4>] schedule_timeout+0x1e/0xad
  [<ffffffff802415e1>] add_wait_queue+0x15/0x44
  [<ffffffff8027d2ef>] pipe_poll+0x33/0x8d
  [<ffffffff80284031>] do_select+0x3fc/0x45f
  [<ffffffff8028451a>] __pollwait+0x0/0xe1
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
sage repeated 2 times
  [<ffffffff80287d9d>] __d_lookup+0xb0/0x100
  [<ffffffff8027ec7d>] do_lookup+0x63/0x1ae
  [<ffffffff80287198>] dput+0x1c/0x10b
  [<ffffffff802ef67d>] number+0x119/0x204
  [<ffffffff8025c800>] get_page_from_freelist+0x278/0x35e
  [<ffffffff802f038b>] vsnprintf+0x561/0x5a5
  [<ffffffff80284250>] core_sys_select+0x1bc/0x265
  [<ffffffff80287e0b>] d_lookup+0x1e/0x42
  [<ffffffff802af809>] proc_flush_task+0x4e/0x1f6
  [<ffffffff80241559>] remove_wait_queue+0x12/0x44
  [<ffffffff802846bc>] sys_select+0xc1/0x183
  [<ffffffff8020bdee>] system_call+0x7e/0x83

smbd          S 0000000000000000     0  4533   4513
  ffff81012a2bbf68 0000000000000082 0000000000000000 00002af339898f10
  00000000000011b5 ffff81012b01ce40 ffff81012fc52e40 ffff81012b01d048
  0000000100000007 0000000b0000000e 00000000ffffffff 0000000000000000
Call Trace:
  [<ffffffff8023a3c1>] sys_pause+0x19/0x22
  [<ffffffff8020bdee>] system_call+0x7e/0x83

sshd          S 0000000000000000     0  4534      1
  ffff81012a319a18 0000000000000086 0000000000000000 0000000000000096
  000000000042b364 ffff81012a413560 ffff81012fc8a720 ffff81012a413768
  0000000200001000 ffff81012fc8a720 00000000ffffffff ffff81012d520cd8
Call Trace:
  [<ffffffff804489b4>] schedule_timeout+0x1e/0xad
  [<ffffffff802415e1>] add_wait_queue+0x15/0x44
  [<ffffffff8040caaf>] tcp_poll+0x25/0x138
  [<ffffffff80284031>] do_select+0x3fc/0x45f
  [<ffffffff8028451a>] __pollwait+0x0/0xe1
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff80274a24>] __slab_alloc+0xba/0x53a
  [<ffffffff803ddc95>] sock_alloc_send_skb+0x77/0x1d2
  [<ffffffff803ddc95>] sock_alloc_send_skb+0x77/0x1d2
  [<ffffffff803e17b9>] __alloc_skb+0x76/0x121
  [<ffffffff803ddc95>] sock_alloc_send_skb+0x77/0x1d2
  [<ffffffff80233df8>] current_fs_time+0x1e/0x24
  [<ffffffff803e2909>] memcpy_fromiovec+0x36/0x66
  [<ffffffff803e08cc>] skb_queue_tail+0x17/0x3e
  [<ffffffff803df401>] sock_def_readable+0x10/0x5f
  [<ffffffff8043d3ce>] unix_stream_sendmsg+0x262/0x329
  [<ffffffff8025c93f>] __alloc_pages+0x59/0x2ae
  [<ffffffff803db31f>] sock_aio_write+0xd1/0xe0
  [<ffffffff80284250>] core_sys_select+0x1bc/0x265
  [<ffffffff802eebcf>] __up_read+0x13/0x8a
  [<ffffffff80273327>] add_partial+0x12/0x3f
  [<ffffffff80274306>] __slab_free+0x6d/0x2c4
  [<ffffffff80241321>] bit_waitqueue+0x16/0x82
  [<ffffffff802413cb>] wake_up_bit+0x11/0x22
  [<ffffffff802846bc>] sys_select+0xc1/0x183
  [<ffffffff80276816>] filp_close+0x5d/0x65
  [<ffffffff8020bdee>] system_call+0x7e/0x83

famd          S 0000000000000000     0  4595      1
  ffff810129cf1a18 0000000000000086 0000000000000000 0000000000000000
  0000000000000000 ffff81012b01c000 ffff81012fc8a720 ffff81012b01c208
  0000000200000003 ffff81012d52d078 00000000ffffffff ffff81012d52d000
Call Trace:
  [<ffffffff804489b4>] schedule_timeout+0x1e/0xad
  [<ffffffff802415e1>] add_wait_queue+0x15/0x44
  [<ffffffff8040caaf>] tcp_poll+0x25/0x138
  [<ffffffff80284031>] do_select+0x3fc/0x45f
  [<ffffffff8028451a>] __pollwait+0x0/0xe1
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff80283bce>] do_sys_poll+0x334/0x360
  [<ffffffff803e09d0>] skb_dequeue+0x48/0x50
  [<ffffffff803e2b18>] memcpy_toiovec+0x36/0x66
  [<ffffffff8028451a>] __pollwait+0x0/0xe1
  [<ffffffff803e2f52>] skb_copy_datagram_iovec+0x49/0x1e8
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff8042298d>] udp_recvmsg+0x193/0x1f3
  [<ffffffff803dd31e>] sock_common_recvmsg+0x30/0x45
  [<ffffffff803dbe0b>] sock_recvmsg+0xd5/0xed
  [<ffffffff8025ec50>] activate_page+0xa2/0xc9
  [<ffffffff8025ee53>] mark_page_accessed+0x1b/0x2f
  [<ffffffff8025a843>] filemap_fault+0x1e2/0x366
  [<ffffffff80284250>] core_sys_select+0x1bc/0x265
  [<ffffffff802eebcf>] __up_read+0x13/0x8a
  [<ffffffff8021f1d8>] do_page_fault+0x425/0x779
  [<ffffffff803dd99f>] release_sock+0x13/0x9b
  [<ffffffff80241321>] bit_waitqueue+0x16/0x82
  [<ffffffff802413cb>] wake_up_bit+0x11/0x22
  [<ffffffff802846bc>] sys_select+0xc1/0x183
  [<ffffffff8020bdee>] system_call+0x7e/0x83

ntpd          S 0000000000000000     0  4632      1
  ffff810129e6fa18 0000000000000082 0000000000000000 ffff81012e19c0d0
  ffff81012ed903a8 ffff810129d45560 ffff81012fc8a720 ffff810129d45768
  0000000200001000 ffff81012fc8a720 00000000ffffffff ffff81012c92b9c0
Call Trace:
  [<ffffffff804489b4>] schedule_timeout+0x1e/0xad
  [<ffffffff803e326f>] datagram_poll+0x21/0xd9
  [<ffffffff80420d77>] udp_poll+0x13/0xfb
  [<ffffffff80284031>] do_select+0x3fc/0x45f
  [<ffffffff8028451a>] __pollwait+0x0/0xe1
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
sage repeated 7 times
  [<ffffffff802ee66c>] rb_insert_color+0xb2/0xda
  [<ffffffff802433ae>] enqueue_hrtimer+0x5c/0x63
  [<ffffffff80243925>] hrtimer_start+0xf2/0x104
  [<ffffffff80284250>] core_sys_select+0x1bc/0x265
  [<ffffffff8023838b>] recalc_sigpending+0xe/0x25
  [<ffffffff8020b92c>] do_notify_resume+0x653/0x725
  [<ffffffff80211d59>] init_fpu+0x6b/0x87
  [<ffffffff8020dd37>] math_state_restore+0x1a/0x49
  [<ffffffff80449e2d>] error_exit+0x0/0x84
  [<ffffffff8020bc2d>] sys_rt_sigreturn+0x21b/0x2be
  [<ffffffff802846bc>] sys_select+0xc1/0x183
  [<ffffffff8020bdee>] system_call+0x7e/0x83

mdadm         S 0000000000000000     0  4643      1
  ffff810129db9a18 0000000000000082 0000000000000000 000a80d200000000
  ffffffff80545cd8 ffff81012ac4c000 ffff81012fc8a720 ffff81012ac4c208
  00000002000a80d2 ffff810129db9a28 00000000ffffffff 00000001003122a6
Call Trace:
  [<ffffffff80448a20>] schedule_timeout+0x8a/0xad
  [<ffffffff80237ba4>] process_timeout+0x0/0x5
  [<ffffffff80284031>] do_select+0x3fc/0x45f
  [<ffffffff8028451a>] __pollwait+0x0/0xe1
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff80227c57>] enqueue_task+0x13/0x21
  [<ffffffff80228435>] inc_nr_running+0x19/0x32
  [<ffffffff802295e5>] try_to_wake_up+0x2c3/0x2d4
  [<ffffffff80287d9d>] __d_lookup+0xb0/0x100
  [<ffffffff8027ec7d>] do_lookup+0x63/0x1ae
  [<ffffffff80228f46>] __wake_up+0x38/0x4e
  [<ffffffff803c01c8>] md_ioctl+0x1206/0x127e
  [<ffffffff802413e5>] autoremove_wake_function+0x9/0x2e
  [<ffffffff80227f17>] __wake_up_common+0x3e/0x68
  [<ffffffff80284250>] core_sys_select+0x1bc/0x265
  [<ffffffff8029a631>] do_open+0x229/0x2c0
  [<ffffffff8027fc34>] may_open+0x5b/0x22c
  [<ffffffff8029a887>] blkdev_open+0x0/0x5d
  [<ffffffff8029a8b5>] blkdev_open+0x2e/0x5d
  [<ffffffff80276a44>] __dentry_open+0x101/0x1aa
  [<ffffffff80284755>] sys_select+0x15a/0x183
  [<ffffffff8020bdee>] system_call+0x7e/0x83

apcupsd       D 0000000000000000     0  4655      1
  ffff810129f13d48 0000000000000086 0000000000000000 0000002000000400
  ffff810129f13d28 ffff810129d44000 ffff81012fc8a720 ffff810129d44208
  00000002052aeb80 ffff810129f13d58 00000000ffffffff 00000001003107cc
Call Trace:
  [<ffffffff80448a20>] schedule_timeout+0x8a/0xad
  [<ffffffff80237ba4>] process_timeout+0x0/0x5
  [<ffffffff803d69e7>] usbhid_wait_io+0x9a/0xfd
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff803d8caa>] hiddev_ioctl+0x370/0x91e
  [<ffffffff80448110>] thread_return+0x0/0xf9
  [<ffffffff80243b12>] ktime_get_ts+0x1a/0x4e
  [<ffffffff8027ada4>] cp_new_stat+0xe7/0xff
  [<ffffffff803d87f2>] hiddev_read+0x19a/0x1f7
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff802830b5>] do_ioctl+0x55/0x6b
  [<ffffffff80283318>] vfs_ioctl+0x24d/0x266
  [<ffffffff802787af>] vfs_read+0x11e/0x132
  [<ffffffff8028336d>] sys_ioctl+0x3c/0x5f
  [<ffffffff8020bdee>] system_call+0x7e/0x83

apcupsd       S 0000000000000000     0  4739      1
  ffff810129b17db8 0000000000000086 ffff810129b38000 ffffffff802413dc
  ffff810129b17d38 ffff810129b38000 ffff810129d44000 ffff810129b38208
  0000000029b17dc8 ffff81012d420244 ffff810129b17dc8 0000000000000002
Call Trace:
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8028140e>] do_path_lookup+0x1a0/0x1c2
  [<ffffffff804489b4>] schedule_timeout+0x1e/0xad
  [<ffffffff80449c4f>] _spin_lock_bh+0x9/0x19
  [<ffffffff803dd99f>] release_sock+0x13/0x9b
  [<ffffffff8040b34a>] inet_csk_accept+0xad/0x234
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8029d8e6>] inotify_d_instantiate+0x3e/0x68
  [<ffffffff80428336>] inet_accept+0x25/0xb5
  [<ffffffff803dce80>] sys_accept+0xff/0x1d1
  [<ffffffff803db9e4>] sys_connect+0x86/0x9c
  [<ffffffff80287fef>] d_instantiate+0x52/0x61
  [<ffffffff8020bdee>] system_call+0x7e/0x83

atd           S 0000000000000000     0  4661      1
  ffff810129c31eb8 0000000000000082 0000000000000000 ffffffff80243b12
  ffff810129c31ee8 ffff810129d44720 ffff81012fc52e40 ffff810129d44928
  0000000100000000 ffffffff802433ae 00000000ffffffff ffffffff80243925
Call Trace:
  [<ffffffff80243b12>] ktime_get_ts+0x1a/0x4e
  [<ffffffff802433ae>] enqueue_hrtimer+0x5c/0x63
  [<ffffffff80243925>] hrtimer_start+0xf2/0x104
  [<ffffffff80448e56>] do_nanosleep+0x46/0x77
  [<ffffffff8024398f>] hrtimer_nanosleep+0x58/0x11e
  [<ffffffff80243553>] hrtimer_wakeup+0x0/0x22
  [<ffffffff80243aa1>] sys_nanosleep+0x4c/0x62
  [<ffffffff8020bdee>] system_call+0x7e/0x83

cron          S 0000000000000000     0  4668      1
  ffff810129ff1eb8 0000000000000086 0000000000000000 ffffffff80243b12
  ffff810129ff1ee8 ffff81012b18ae40 ffff81012fcc2000 ffff81012b18b048
  0000000300000000 ffffffff802433ae 00000000ffffffff ffffffff80243925
Call Trace:
  [<ffffffff80243b12>] ktime_get_ts+0x1a/0x4e
  [<ffffffff802433ae>] enqueue_hrtimer+0x5c/0x63
  [<ffffffff80243925>] hrtimer_start+0xf2/0x104
  [<ffffffff80448e56>] do_nanosleep+0x46/0x77
  [<ffffffff8024398f>] hrtimer_nanosleep+0x58/0x11e
  [<ffffffff80243553>] hrtimer_wakeup+0x0/0x22
  [<ffffffff80243aa1>] sys_nanosleep+0x4c/0x62
  [<ffffffff8020bdee>] system_call+0x7e/0x83

portsentry    S ffff8100052a15a0     0  4689      1
  ffff810129f59a18 0000000000000082 ffff810129f599e0 0000000000000000
  ffffffff80545ca0 ffff810129a82000 ffff81012a412720 ffff810129a82208
  00000000000200d0 ffff810005114968 00000000ffffffff ffff810129a82000
Call Trace:
  [<ffffffff804489b4>] schedule_timeout+0x1e/0xad
  [<ffffffff802415e1>] add_wait_queue+0x15/0x44
  [<ffffffff8040caaf>] tcp_poll+0x25/0x138
  [<ffffffff80284031>] do_select+0x3fc/0x45f
  [<ffffffff8028451a>] __pollwait+0x0/0xe1
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
sage repeated 9 times
  [<ffffffff80284250>] core_sys_select+0x1bc/0x265
  [<ffffffff8028bba8>] mntput_no_expire+0x1c/0x80
  [<ffffffff802eebcf>] __up_read+0x13/0x8a
  [<ffffffff8021f1d8>] do_page_fault+0x425/0x779
  [<ffffffff80241321>] bit_waitqueue+0x16/0x82
  [<ffffffff802413cb>] wake_up_bit+0x11/0x22
  [<ffffffff802846bc>] sys_select+0xc1/0x183
  [<ffffffff8020bdee>] system_call+0x7e/0x83

portsentry    S 0000000000000000     0  4693      1
  ffff810129f55a18 0000000000000086 0000000000000000 ffffffff8025c93f
  00000010000200d0 ffff8101299f8720 ffff81012fc8a720 ffff8101299f8928
  00000002000a80d2 0000000000000000 00000000ffffffff ffff810129a0f600
Call Trace:
  [<ffffffff8025c93f>] __alloc_pages+0x59/0x2ae
  [<ffffffff804489b4>] schedule_timeout+0x1e/0xad
  [<ffffffff803e326f>] datagram_poll+0x21/0xd9
  [<ffffffff80420d77>] udp_poll+0x13/0xfb
  [<ffffffff80284031>] do_select+0x3fc/0x45f
  [<ffffffff8028451a>] __pollwait+0x0/0xe1
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
sage repeated 9 times
  [<ffffffff80284250>] core_sys_select+0x1bc/0x265
  [<ffffffff8028bba8>] mntput_no_expire+0x1c/0x80
  [<ffffffff802eebcf>] __up_read+0x13/0x8a
  [<ffffffff8021f1d8>] do_page_fault+0x425/0x779
  [<ffffffff80241321>] bit_waitqueue+0x16/0x82
  [<ffffffff802413cb>] wake_up_bit+0x11/0x22
  [<ffffffff802846bc>] sys_select+0xc1/0x183
  [<ffffffff8020bdee>] system_call+0x7e/0x83

getty         S 0000000000000002     0  4715      1
  ffff810129f4ddb8 0000000000000086 ffff8100052cb380 0000000000000020
  0000000000000020 ffff810129b2e720 ffff810129b2ee40 ffff810129b2e928
  00000002052292f0 00000008802631f2 ffff81012c601000 ffff81012fbe4000
Call Trace:
  [<ffffffff804489b4>] schedule_timeout+0x1e/0xad
  [<ffffffff80264b64>] handle_mm_fault+0x424/0x772
  [<ffffffff802415e1>] add_wait_queue+0x15/0x44
  [<ffffffff8032ba06>] read_chan+0x3b8/0x66e
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff80326fa3>] tty_ldisc_ref_wait+0xe/0x9b
  [<ffffffff8032899b>] tty_read+0x72/0xc8
  [<ffffffff8027873b>] vfs_read+0xaa/0x132
  [<ffffffff80278ad7>] sys_read+0x45/0x6e
  [<ffffffff8020bdee>] system_call+0x7e/0x83

getty         S 0000000000000000     0  4717      1
  ffff810129baddb8 0000000000000086 0000000000000000 0000000000000020
  0000000000000020 ffff810129b2ee40 ffff81012fc8a720 ffff810129b2f048
  00000002052292f0 00000008802631f2 00000000ffffffff ffff81012d122000
Call Trace:
  [<ffffffff804489b4>] schedule_timeout+0x1e/0xad
  [<ffffffff80264b64>] handle_mm_fault+0x424/0x772
  [<ffffffff802415e1>] add_wait_queue+0x15/0x44
  [<ffffffff8032ba06>] read_chan+0x3b8/0x66e
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff80326fa3>] tty_ldisc_ref_wait+0xe/0x9b
  [<ffffffff8032899b>] tty_read+0x72/0xc8
  [<ffffffff8027873b>] vfs_read+0xaa/0x132
  [<ffffffff80278ad7>] sys_read+0x45/0x6e
  [<ffffffff8020bdee>] system_call+0x7e/0x83

getty         S 0000000000000000     0  4718      1
  ffff810129a59db8 0000000000000086 0000000000000000 0000000000000020
  0000000000000020 ffff810129b2f560 ffff81012fc52e40 ffff810129b2f768
  00000001052292f0 00000008802631f2 00000000ffffffff ffff81012b188800
Call Trace:
  [<ffffffff804489b4>] schedule_timeout+0x1e/0xad
  [<ffffffff80264b64>] handle_mm_fault+0x424/0x772
  [<ffffffff802415e1>] add_wait_queue+0x15/0x44
  [<ffffffff8032ba06>] read_chan+0x3b8/0x66e
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff80326fa3>] tty_ldisc_ref_wait+0xe/0x9b
  [<ffffffff8032899b>] tty_read+0x72/0xc8
  [<ffffffff8027873b>] vfs_read+0xaa/0x132
  [<ffffffff80278ad7>] sys_read+0x45/0x6e
  [<ffffffff8020bdee>] system_call+0x7e/0x83

getty         S 0000000000000000     0  4719      1
  ffff810129b45db8 0000000000000086 0000000000000000 0000000000000020
  0000000000000020 ffff810129b30000 ffff81012fcc2000 ffff810129b30208
  00000003052292f0 00000008802631f2 00000000ffffffff ffff81012d199800
Call Trace:
  [<ffffffff804489b4>] schedule_timeout+0x1e/0xad
  [<ffffffff80264b64>] handle_mm_fault+0x424/0x772
  [<ffffffff802415e1>] add_wait_queue+0x15/0x44
  [<ffffffff8032ba06>] read_chan+0x3b8/0x66e
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff80326fa3>] tty_ldisc_ref_wait+0xe/0x9b
  [<ffffffff8032899b>] tty_read+0x72/0xc8
  [<ffffffff8027873b>] vfs_read+0xaa/0x132
  [<ffffffff80278ad7>] sys_read+0x45/0x6e
  [<ffffffff8020bdee>] system_call+0x7e/0x83

getty         S 0000000000000000     0  4721      1
  ffff810129babdb8 0000000000000082 0000000000000000 0000000000000020
  0000000000000020 ffff81012a412e40 ffffffff805354c0 ffff81012a413048
  00000000052292f0 00000008802631f2 00000000ffffffff ffff81012e879000
Call Trace:
  [<ffffffff804489b4>] schedule_timeout+0x1e/0xad
  [<ffffffff80264b64>] handle_mm_fault+0x424/0x772
  [<ffffffff802415e1>] add_wait_queue+0x15/0x44
  [<ffffffff8032ba06>] read_chan+0x3b8/0x66e
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff80326fa3>] tty_ldisc_ref_wait+0xe/0x9b
  [<ffffffff8032899b>] tty_read+0x72/0xc8
  [<ffffffff8027873b>] vfs_read+0xaa/0x132
  [<ffffffff80278ad7>] sys_read+0x45/0x6e
  [<ffffffff8020bdee>] system_call+0x7e/0x83

getty         S ffff8100052aa5a0     0  4722      1
  ffff810129f2fdb8 0000000000000086 ffff810129f2fd80 0000000000000020
  0000000000000020 ffff810129b30720 ffff810129b2f560 ffff810129b30928
  00000001052292f0 00000008802631f2 00000000ffffffff ffff81012d1ac800
Call Trace:
  [<ffffffff804489b4>] schedule_timeout+0x1e/0xad
  [<ffffffff80264b64>] handle_mm_fault+0x424/0x772
  [<ffffffff802415e1>] add_wait_queue+0x15/0x44
  [<ffffffff8032ba06>] read_chan+0x3b8/0x66e
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff80326fa3>] tty_ldisc_ref_wait+0xe/0x9b
  [<ffffffff8032899b>] tty_read+0x72/0xc8
  [<ffffffff8027873b>] vfs_read+0xaa/0x132
  [<ffffffff80278ad7>] sys_read+0x45/0x6e
  [<ffffffff8020bdee>] system_call+0x7e/0x83

sshd          S 0000000000000000     0  4740   4534
  ffff810129f37c18 0000000000000086 0000000000000000 ffffffff8043d3ce
  0000000000000001 ffff810129825560 ffffffff805354c0 ffff810129825768
  0000000029b66580 ffffffff805354c0 00000000ffffffff ffffffff80287d9d
Call Trace:
  [<ffffffff8043d3ce>] unix_stream_sendmsg+0x262/0x329
  [<ffffffff80287d9d>] __d_lookup+0xb0/0x100
  [<ffffffff804489b4>] schedule_timeout+0x1e/0xad
  [<ffffffff802414fd>] prepare_to_wait+0x15/0x5f
  [<ffffffff8043c7a1>] unix_stream_recvmsg+0x245/0x4ea
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff803db40b>] sock_aio_read+0xdd/0xec
  [<ffffffff80277fd4>] do_sync_read+0xc9/0x10c
  [<ffffffff802ec753>] kobject_get+0x12/0x17
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff80276ba4>] do_filp_open+0x2d/0x3d
  [<ffffffff8027874e>] vfs_read+0xbd/0x132
  [<ffffffff80278ad7>] sys_read+0x45/0x6e
  [<ffffffff8020bdee>] system_call+0x7e/0x83

sshd          S 0000000000000003     0  4743   4740
  ffff810129ae1a18 0000000000000082 0000000000000000 ffff810128605900
  ffff810129ae19cc ffff810129b38e40 ffff810129a83560 ffff810129b39048
  0000000300000000 0000000000000001 0000000000000096 0000000000000003
Call Trace:
  [<ffffffff80228f46>] __wake_up+0x38/0x4e
  [<ffffffff804489b4>] schedule_timeout+0x1e/0xad
  [<ffffffff8032713c>] tty_poll+0x5f/0x6d
  [<ffffffff80284031>] do_select+0x3fc/0x45f
  [<ffffffff8028451a>] __pollwait+0x0/0xe1
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
sage repeated 5 times
  [<ffffffff80449c4f>] _spin_lock_bh+0x9/0x19
  [<ffffffff803dd99f>] release_sock+0x13/0x9b
  [<ffffffff8040df5a>] tcp_sendmsg+0x9af/0xab3
  [<ffffffff80228cb6>] __check_preempt_curr_fair+0x56/0x78
  [<ffffffff803db31f>] sock_aio_write+0xd1/0xe0
  [<ffffffff80284250>] core_sys_select+0x1bc/0x265
  [<ffffffff80241559>] remove_wait_queue+0x12/0x44
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff80233df8>] current_fs_time+0x1e/0x24
  [<ffffffff80325fc3>] tty_ldisc_deref+0x62/0x75
  [<ffffffff802846bc>] sys_select+0xc1/0x183
  [<ffffffff80278b45>] sys_write+0x45/0x6e
  [<ffffffff8020bdee>] system_call+0x7e/0x83

tcsh          S 0000000000000000     0  4744   4743
  ffff810129a4ff28 0000000000000082 0000000000000000 ffff810129824e40
  0000000000000003 ffff810129824e40 ffff81012fcc2000 ffff810129825048
  0000000380448110 ffff810129a4ff70 00000000ffffffff ffff810129a4ff58
Call Trace:
  [<ffffffff8020bdee>] system_call+0x7e/0x83
  [<ffffffff8023a486>] sys_rt_sigsuspend+0xbc/0xdd
  [<ffffffff8023ab6e>] sys_rt_sigprocmask+0xb5/0xce
  [<ffffffff8020c107>] ptregscall_common+0x67/0xb0

smbd          S 0000000000000000     0  4792   4513
  ffff810128d7ba18 0000000000000082 0000000000000000 ffff81012fca9c00
  ffff810128d7b9cc ffff810129b38720 ffff81012fcc2000 ffff810129b38928
  0000000328d7ba18 ffff810128d7ba28 00000000ffffffff 0000000100310e04
Call Trace:
  [<ffffffff80448a20>] schedule_timeout+0x8a/0xad
  [<ffffffff80237ba4>] process_timeout+0x0/0x5
  [<ffffffff80284031>] do_select+0x3fc/0x45f
  [<ffffffff8028451a>] __pollwait+0x0/0xe1
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff80287d9d>] __d_lookup+0xb0/0x100
  [<ffffffff80287d9d>] __d_lookup+0xb0/0x100
  [<ffffffff8027ec7d>] do_lookup+0x63/0x1ae
  [<ffffffff80287198>] dput+0x1c/0x10b
  [<ffffffff80280eb1>] __link_path_walk+0xbb7/0xd0c
  [<ffffffff8028bba8>] mntput_no_expire+0x1c/0x80
  [<ffffffff802810d4>] link_path_walk+0xce/0xe0
  [<ffffffff80276a44>] __dentry_open+0x101/0x1aa
  [<ffffffff80284250>] core_sys_select+0x1bc/0x265
  [<ffffffff802eb8c9>] _atomic_dec_and_lock+0x39/0x58
  [<ffffffff8028bba8>] mntput_no_expire+0x1c/0x80
  [<ffffffff8027ada4>] cp_new_stat+0xe7/0xff
  [<ffffffff80284755>] sys_select+0x15a/0x183
  [<ffffffff8020bdee>] system_call+0x7e/0x83

screen        S 0000000000000000     0  4890   4744
  ffff810128523f68 0000000000000086 0000000000000000 ffffffff80233813
  00000d4c0000131a ffff8101282ec720 ffff81012fcc2000 ffff8101282ec928
  000000034e5a42d0 0000000000000000 00000000ffffffff ffffffff80233aa5
Call Trace:
  [<ffffffff80233813>] do_setitimer+0x15e/0x329
  [<ffffffff80233aa5>] alarm_setitimer+0x35/0x65
  [<ffffffff8023a3c1>] sys_pause+0x19/0x22
  [<ffffffff8020bdee>] system_call+0x7e/0x83

screen        S 0000000000000000     0  4891   4890
  ffff8101286ada18 0000000000000086 0000000000000000 0000000000000286
  0000000000000053 ffff810129a83560 ffff81012fcc2000 ffff810129a83768
  0000000300000000 0000000000000001 00000000ffffffff 0000000000000003
Call Trace:
  [<ffffffff804489b4>] schedule_timeout+0x1e/0xad
  [<ffffffff8032713c>] tty_poll+0x5f/0x6d
  [<ffffffff80284031>] do_select+0x3fc/0x45f
  [<ffffffff8028451a>] __pollwait+0x0/0xe1
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
sage repeated 6 times
  [<ffffffff80227f17>] __wake_up_common+0x3e/0x68
  [<ffffffff80228f46>] __wake_up+0x38/0x4e
  [<ffffffff80284250>] core_sys_select+0x1bc/0x265
  [<ffffffff80241559>] remove_wait_queue+0x12/0x44
  [<ffffffff80228f46>] __wake_up+0x38/0x4e
  [<ffffffff80325fc3>] tty_ldisc_deref+0x62/0x75
  [<ffffffff802846bc>] sys_select+0xc1/0x183
  [<ffffffff80278b45>] sys_write+0x45/0x6e
  [<ffffffff8020bdee>] system_call+0x7e/0x83

tcsh          S 0000000000000000     0  4893   4891
  ffff8101282abdb8 0000000000000086 0000000000000000 0000000000000000
  ffff81012868bc00 ffff81012ac4c720 ffffffff805354c0 ffff81012ac4c928
  000000002c930000 ffff81012840f410 00000000ffffffff 0000000000000000
Call Trace:
  [<ffffffff804489b4>] schedule_timeout+0x1e/0xad
  [<ffffffff802415e1>] add_wait_queue+0x15/0x44
  [<ffffffff8032ba06>] read_chan+0x3b8/0x66e
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff80326fa3>] tty_ldisc_ref_wait+0xe/0x9b
  [<ffffffff8032899b>] tty_read+0x72/0xc8
  [<ffffffff8027873b>] vfs_read+0xaa/0x132
  [<ffffffff80278ad7>] sys_read+0x45/0x6e
  [<ffffffff8020bdee>] system_call+0x7e/0x83

md3_raid5     S 0000000000000000     0  4923      2
  ffff8101284f1e80 0000000000000046 0000000000000000 0000000000000046
  ffff81012ea9e5e0 ffff81012ec75560 ffff81012fcc2000 ffff81012ec75768
  000000032ca9ae00 ffffffff803b03e2 00000000ffffffff ffff81012cb33800
Call Trace:
  [<ffffffff803b03e2>] unplug_slaves+0x5f/0x9a
  [<ffffffff804489b4>] schedule_timeout+0x1e/0xad
  [<ffffffff802414fd>] prepare_to_wait+0x15/0x5f
  [<ffffffff803c02fb>] md_thread+0xbb/0xf1
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff803c0240>] md_thread+0x0/0xf1
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

xfslogd/0     S 0000000000000000     0  4952      2
  ffff81010bc07ed0 0000000000000046 0000000000000000 0000000000000287
  ffff810129fa2840 ffff810129b30e40 ffff81012ec75560 ffff810129b31048
  000000002e2a5840 0000000000000046 0000000000000287 ffff8100a62e8780
Call Trace:
  [<ffffffff8023e6c7>] worker_thread+0x74/0x9b
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8023e653>] worker_thread+0x0/0x9b
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

xfslogd/1     S 0000000000000000     0  4953      2
  ffff810107d5bed0 0000000000000046 0000000000000000 ffffffff8827f63f
  ffff8101267f7300 ffff810129b31560 ffff81012fc52e40 ffff810129b31768
  000000012e2a5b40 ffff81012ecc8000 00000000ffffffff 0000000000000002
Call Trace:
  [<ffffffff8827f63f>] :xfs:xfs_buf_rele+0x32/0xa0
  [<ffffffff8827f8e4>] :xfs:xfs_buf_iodone_work+0x0/0x41
  [<ffffffff8023e6c7>] worker_thread+0x74/0x9b
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8023e653>] worker_thread+0x0/0x9b
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

xfslogd/2     S 0000000000000000     0  4954      2
  ffff8101267efed0 0000000000000046 0000000000000000 0000000000000001
  0000000000000282 ffff81012fe14000 ffff81012fc8a720 ffff81012fe14208
  000000022ad3be40 00000000ffffffff 00000000ffffffff ffff81012aaac700
Call Trace:
  [<ffffffff8023e6c7>] worker_thread+0x74/0x9b
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8023e653>] worker_thread+0x0/0x9b
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

xfslogd/3     S 0000000000000003     0  4955      2
  ffff8101175d9ed0 0000000000000046 0000000000000000 ffffffff80273327
  ffff810108b12000 ffff81012b01d560 ffff81012ec75560 ffff81012b01d768
  000000032e2a5f00 0000000000000287 ffff81012ed0e900 ffff81012fdf4a00
Call Trace:
  [<ffffffff80273327>] add_partial+0x12/0x3f
  [<ffffffff8023e6c7>] worker_thread+0x74/0x9b
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8023e653>] worker_thread+0x0/0x9b
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

xfsdatad/0    S 0000000000000000     0  4956      2
  ffff81010f493ed0 0000000000000046 0000000000000000 0000000000000003
  ffff81010f493e90 ffff810129b2e000 ffffffff805354c0 ffff810129b2e208
  000000000a405c38 ffffffffffffffff 00000000ffffffff 0000000000000000
Call Trace:
  [<ffffffff8023e6c7>] worker_thread+0x74/0x9b
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8023e653>] worker_thread+0x0/0x9b
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

xfsdatad/1    S 0000000000000001     0  4957      2
  ffff8101267bfed0 0000000000000046 ffff8100ca52a9c0 ffffffff80297e45
  0000000000000286 ffff8101282ece40 ffff81012ec75560 ffff8101282ed048
  00000001ffffffff 0000000000000000 ffff81012b6b6b40 ffff81010a405c38
Call Trace:
  [<ffffffff80297e45>] end_buffer_async_write+0xe5/0x106
  [<ffffffff8023e6c7>] worker_thread+0x74/0x9b
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8023e653>] worker_thread+0x0/0x9b
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

xfsdatad/2    S 0000000000000000     0  4958      2
  ffff810100e79ed0 0000000000000046 0000000000000000 ffffffff80297e45
  0000000000000286 ffff8101282ed560 ffff81012fc8a720 ffff8101282ed768
  00000002ffffffff 0000000000000287 00000000ffffffff ffffffff805a2de8
Call Trace:
  [<ffffffff80297e45>] end_buffer_async_write+0xe5/0x106
  [<ffffffff8023e6c7>] worker_thread+0x74/0x9b
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8023e653>] worker_thread+0x0/0x9b
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

xfsdatad/3    S 0000000000000003     0  4959      2
  ffff81011aae5ed0 0000000000000046 ffff8100cb399c30 ffffffff80297e45
  0000000000000286 ffff8101282ec000 ffff81012ec75560 ffff8101282ec208
  00000003ffffffff 0000000000000287 ffff81012b6b6c60 ffffffff805a2de8
Call Trace:
  [<ffffffff80297e45>] end_buffer_async_write+0xe5/0x106
  [<ffffffff8023e6c7>] worker_thread+0x74/0x9b
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8023e653>] worker_thread+0x0/0x9b
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

xfs_mru_cache S ffff8100052a1640     0  4961      2
  ffff81010f421ed0 0000000000000046 ffff81010f421e98 0000000000000000
  ffff810117894000 ffff810117894000 ffff810129d44e40 ffff810117894208
  0000000000000000 ffffffff80448110 00000000ffffffff 0000000000000046
Call Trace:
  [<ffffffff80448110>] thread_return+0x0/0xf9
  [<ffffffff8023e6c7>] worker_thread+0x74/0x9b
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8023e653>] worker_thread+0x0/0x9b
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

xfsbufd       D 0000000000000000     0  4966      2
  ffff810102e29cc0 0000000000000046 0000000000000000 0000000000000001
  0000000000000086 ffff810117894720 ffff81012fc8a720 ffff810117894928
  000000022cb33800 0000000000000046 00000000ffffffff ffffffff802e27e0
Call Trace:
  [<ffffffff802e27e0>] __generic_unplug_device+0x13/0x24
  [<ffffffff803b12cf>] get_active_stripe+0x22f/0x4ca
  [<ffffffff80228f46>] __wake_up+0x38/0x4e
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff803b6b3b>] make_request+0x3f3/0x577
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff802e1728>] generic_make_request+0x1be/0x1f5
  [<ffffffff802e3caf>] submit_bio+0xb4/0xbb
  [<ffffffff88280c06>] :xfs:_xfs_buf_ioapply+0x276/0x2a1
  [<ffffffff88280c6a>] :xfs:xfs_buf_iorequest+0x39/0x66
  [<ffffffff88284280>] :xfs:xfs_bdstrat_cb+0x37/0x3b
  [<ffffffff882810df>] :xfs:xfsbufd+0x8a/0xe3
  [<ffffffff88281055>] :xfs:xfsbufd+0x0/0xe3
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

xfssyncd      S 0000000000000000     0  4973      2
  ffff81010d8fde90 0000000000000046 0000000000000000 ffffffff8826e9d7
  0000000000000000 ffff810117894e40 ffffffff805354c0 ffff810117895048
  0000000000000000 ffff81010d8fdea0 00000000ffffffff 0000000100310522
Call Trace:
  [<ffffffff8826e9d7>] :xfs:xfs_icsb_count+0xf5/0x105
  [<ffffffff80448a20>] schedule_timeout+0x8a/0xad
  [<ffffffff80237ba4>] process_timeout+0x0/0x5
  [<ffffffff88285ca5>] :xfs:xfssyncd+0x33/0x13f
  [<ffffffff88285c72>] :xfs:xfssyncd+0x0/0x13f
  [<ffffffff802412cc>] kthread+0x47/0x73
  [<ffffffff8020cc08>] child_rip+0xa/0x12
  [<ffffffff80241285>] kthread+0x0/0x73
  [<ffffffff8020cbfe>] child_rip+0x0/0x12

bonnie++      D 0000000000000003     0  4981   4893
  ffff81011598b578 0000000000000082 0000000000000000 0000000000000001
  0000000000000096 ffff810117895560 ffff81012ec75560 ffff810117895768
  000000031f434070 0000000000000046 ffff81012ea9e5e0 ffffffff802e27e0
Call Trace:
  [<ffffffff802e27e0>] __generic_unplug_device+0x13/0x24
  [<ffffffff802e35f4>] generic_unplug_device+0x18/0x28
  [<ffffffff803b12cf>] get_active_stripe+0x22f/0x4ca
  [<ffffffff802295f6>] default_wake_function+0x0/0xe
  [<ffffffff803b6b3b>] make_request+0x3f3/0x577
  [<ffffffff8025acf6>] mempool_alloc+0x24/0xda
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff802e1728>] generic_make_request+0x1be/0x1f5
  [<ffffffff802e3caf>] submit_bio+0xb4/0xbb
  [<ffffffff80298e2f>] __bio_add_page+0x109/0x1b9
  [<ffffffff8827dcb4>] :xfs:xfs_submit_ioend_bio+0x1e/0x27
  [<ffffffff8827e0ce>] :xfs:xfs_submit_ioend+0x88/0xc6
  [<ffffffff8827ef51>] :xfs:xfs_page_state_convert+0x51e/0x56d
  [<ffffffff8827f0f2>] :xfs:xfs_vm_writepage+0xa7/0xe1
  [<ffffffff8025d022>] __writepage+0xa/0x23
  [<ffffffff8025d552>] write_cache_pages+0x176/0x2a3
  [<ffffffff8025d018>] __writepage+0x0/0x23
  [<ffffffff8025d6bb>] do_writepages+0x20/0x2d
  [<ffffffff80291ec8>] __writeback_single_inode+0xcd/0x3a7
  [<ffffffff8827e194>] :xfs:__xfs_get_blocks+0x61/0x19b
  [<ffffffff802924fa>] sync_sb_inodes+0x1cb/0x2af
  [<ffffffff80292961>] writeback_inodes+0x7d/0xd3
  [<ffffffff8025d8fd>] balance_dirty_pages_ratelimited_nr+0x113/0x1f4
  [<ffffffff80259d91>] generic_file_buffered_write+0x570/0x695
  [<ffffffff80233df8>] current_fs_time+0x1e/0x24
  [<ffffffff802eec67>] __up_write+0x21/0x10e
  [<ffffffff882853b3>] :xfs:xfs_write+0x6dd/0xa82
  [<ffffffff80227f17>] __wake_up_common+0x3e/0x68
  [<ffffffff88281932>] :xfs:xfs_file_aio_write+0x5a/0x5d
  [<ffffffff80277ec8>] do_sync_write+0xc9/0x10c
  [<ffffffff802eebcf>] __up_read+0x13/0x8a
  [<ffffffff802413dc>] autoremove_wake_function+0x0/0x2e
  [<ffffffff80228561>] update_curr+0xdf/0xfe
  [<ffffffff80278608>] vfs_write+0xad/0x136
  [<ffffffff80278b45>] sys_write+0x45/0x6e
  [<ffffffff8020bdee>] system_call+0x7e/0x83

tcsh          S 0000000000000000     0  4983   4891
  ffff8100a536bf28 0000000000000086 0000000000000000 ffff81010fea0000
  0000000000000000 ffff81010fea0000 ffffffff805354c0 ffff81010fea0208
  0000000080448110 ffff8100a536bf70 00000000ffffffff ffff8100a536bf58
Call Trace:
  [<ffffffff8020bdee>] system_call+0x7e/0x83
  [<ffffffff8023a486>] sys_rt_sigsuspend+0xbc/0xdd
  [<ffffffff8023ab6e>] sys_rt_sigprocmask+0xb5/0xce
  [<ffffffff8020c107>] ptregscall_common+0x67/0xb0

tcsh          R  running task        0  5038   4983
