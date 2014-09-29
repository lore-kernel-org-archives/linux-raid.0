From: BillStuff <billstuff2001@sbcglobal.net>
Subject: Re: Raid5 hang in 3.14.19
Date: Sun, 28 Sep 2014 22:56:19 -0500
Message-ID: <5428D863.7090409@sbcglobal.net>
References: <5425E9D6.1050102@sbcglobal.net> <20140929122533.3b91a543@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140929122533.3b91a543@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 09/28/2014 09:25 PM, NeilBrown wrote:
> On Fri, 26 Sep 2014 17:33:58 -0500 BillStuff <billstuff2001@sbcglobal.net>
> wrote:
>
>> Hi Neil,
>>
>> I found something that looks similar to the problem described in
>> "Re: seems like a deadlock in workqueue when md do a flush" from Sept 14th.
>>
>> It's on 3.14.19 with 7 recent patches for fixing raid1 recovery hangs.
>>
>> on this array:
>> md3 : active raid5 sdf1[5] sde1[4] sdd1[3] sdc1[2] sdb1[1] sda1[0]
>>         104171200 blocks level 5, 64k chunk, algorithm 2 [6/6] [UUUUUU]
>>         bitmap: 1/5 pages [4KB], 2048KB chunk
>>
>> I was running a test doing parallel kernel builds, read/write loops, and
>> disk add / remove / check loops,
>> on both this array and a raid1 array.
>>
>> I was trying to stress test your recent raid1 fixes, which went well,
>> but then after 5 days,
>> the raid5 array hung up with this in dmesg:
> I think this is different to the workqueue problem you mentioned, though as I
> don't know exactly what caused either I cannot be certain.
>
>   From the data you provided it looks like everything is waiting on
> get_active_stripe(), or on a process that is waiting on that.
> That seems pretty common whenever anything goes wrong in raid5 :-(
>
> The md3_raid5 task is listed as blocked, but not stack trace is given.
> If the machine is still in the state, then
>
>   cat /proc/1698/stack
>
> might be useful.
> (echo t > /proc/sysrq-trigger is always a good idea)

Might this help? I believe the array was doing a "check" when things 
hung up.

md3_raid5       D ea49d770     0  1698      2 0x00000000
  e833dda8 00000046 c106d92d ea49d770 e9d38554 1cc20b58 1e79a404 0001721a
  c17d6700 c17d6700 e956d610 c2217470 c13af054 e9e8f000 00000000 00000000
  e833dd78 00000000 00000000 00000271 00000000 00000005 00000000 0000a193
Call Trace:
  [<c106d92d>] ? __enqueue_entity+0x6d/0x80
  [<c13af054>] ? scsi_init_io+0x24/0xb0
  [<c1072683>] ? enqueue_task_fair+0x2d3/0x660
  [<c153e7f3>] schedule+0x23/0x60
  [<c153db85>] schedule_timeout+0x145/0x1c0
  [<c1065698>] ? update_rq_clock.part.92+0x18/0x50
  [<c1067a65>] ? check_preempt_curr+0x65/0x90
  [<c1067aa8>] ? ttwu_do_wakeup+0x18/0x120
  [<c153ef5b>] wait_for_common+0x9b/0x110
  [<c1069ca0>] ? wake_up_process+0x40/0x40
  [<c153f077>] wait_for_completion_killable+0x17/0x30
  [<c105ad0a>] kthread_create_on_node+0x9a/0x110
  [<c1453ecc>] md_register_thread+0x8c/0xc0
  [<c1453f00>] ? md_register_thread+0xc0/0xc0
  [<c145ad14>] md_check_recovery+0x304/0x490
  [<c12b1192>] ? blk_finish_plug+0x12/0x40
  [<f3dc3a10>] raid5d+0x20/0x4c0 [raid456]
  [<c104a022>] ? try_to_del_timer_sync+0x42/0x60
  [<c153db3d>] ? schedule_timeout+0xfd/0x1c0
  [<c1453fe8>] md_thread+0xe8/0x100
  [<c1079990>] ? __wake_up_sync+0x20/0x20
  [<c1453f00>] ? md_register_thread+0xc0/0xc0
  [<c105ae21>] kthread+0xa1/0xc0
  [<c1541837>] ret_from_kernel_thread+0x1b/0x28
  [<c105ad80>] ? kthread_create_on_node+0x110/0x110

I've already rebooted the system, but I did get a snapshot of all the 
blocked processes.
It's kind of long but I can post it if it's useful.

Thanks,
Bill
