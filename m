From: Larkin Lowrey <llowrey@gmail.com>
Subject: Re: Stopping raid6 (with journal) hangs w/ 100%CPU
Date: Fri, 24 Nov 2017 14:20:58 -0500
Message-ID: <97c88343-8f46-28a4-3590-82465312bcb5@gmail.com>
References: <6fb7c56a-a78d-ebe6-e569-0d68f69469ce@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6fb7c56a-a78d-ebe6-e569-0d68f69469ce@gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

After hard-rebooting, this instance (stripe_cache_active: 2) assembled 
just fine on boot. The next time I encountered this the array was 
'inactive' on boot. There was a flurry of I/O initially (which seems to 
indicate journal re-play, then the array becoming 'active') but the I/O 
ceased without the array becoming active.

This time...

stripe_cache_active: 2376

> md125 : inactive md127p4[9](J) sdk1[2] sdl1[3] sdn1[5] sdo1[6] sdm1[4] 
> sdj1[1] sdq1[8] sdp1[7]
>       31258219068 blocks super 1.2


> # mdadm -D /dev/md125
> /dev/md125:
>            Version : 1.2
>      Creation Time : Thu Oct 19 10:11:35 2017
>         Raid Level : raid6
>      Used Dev Size : 18446744073709551615
>       Raid Devices : 8
>      Total Devices : 9
>        Persistence : Superblock is persistent
>
>        Update Time : Fri Nov 24 13:41:38 2017
>              State : active, FAILED, Not Started
>     Active Devices : 8
>    Working Devices : 9
>     Failed Devices : 0
>      Spare Devices : 0
>
>             Layout : left-symmetric
>         Chunk Size : 64K
>
> Consistency Policy : journal
>
>               Name : ########:3
>               UUID : de6a2ce0:1a4c510f:d7c89da4:1215a312
>             Events : 156844
>
>     Number   Major   Minor   RaidDevice State
>        -       0        0        0      removed
>        -       0        0        1      removed
>        -       0        0        2      removed
>        -       0        0        3      removed
>        -       0        0        4      removed
>        -       0        0        5      removed
>        -       0        0        6      removed
>        -       0        0        7      removed
>
>        -     259        3        -      spare   /dev/md127p4
>        -       8      225        5      sync   /dev/sdo1
>        -       8      209        4      sync   /dev/sdn1
>        -       8      193        3      sync   /dev/sdm1
>        -       8      177        2      sync   /dev/sdl1
>        -       8      161        1      sync   /dev/sdk1
>        -       8      145        0      sync   /dev/sdj1
>        -      65        1        7      sync   /dev/sdq1
>        -       8      241        6      sync   /dev/sdp1

--Larkin

On 11/23/2017 1:22 PM, Larkin Lowrey wrote:
> Sometimes, stopping a raid6 array (with journal) hangs, the mdX_raid6 
> process pegs at 100% CPU, and there is no I/O. Looks like it's stuck 
> in an infinite loop.
>
> Kernel: 4.13.13-200.fc26.x86_64
>
> The stack trace (echo l > /proc/sysrq-trigger) is always the same:
>
>> handle_stripe+0x10c/0x2140 [raid456]
>> ? pick_next_task_fair+0x491/0x550
>> handle_active_stripes.isra.60+0x3e5/0x5a0 [raid456]
>> raid5d+0x42e/0x630 [raid456]
>> ? prepare_to_wait_event+0x79/0x160
>> md_thread+0x125/0x170
>> ? md_thread+0x125/0x170
>> ? finish_wait+0x80/0x80
>> kthread+0x125/0x140
>> ? state_show+0x2f0/0x2f0
>> ? kthread_park+0x60/0x60
>> ? do_syscall_64+0x67/0x140
>> ret_from_fork+0x25/0x30
>
> The array is healthy, has a journal, and writes were idle for several 
> minutes prior to running 'mdadm --stop'.
>
>> md124 : active raid6 sdt1[6] sds1[5] sdw1[1] sdx1[2] sdy1[3] sdu1[7] 
>> sdv1[8] sdz1[4] md125p4[9](J)
>>       23442092928 blocks super 1.2 level 6, 64k chunk, algorithm 2 
>> [8/8] [UUUUUUUU]
>
> stripe_cache_active: 2
> stripe_cache_size: 32768
> array_state: write-pending
> journal_mode: write-through [write-back]
> consistency_policy: journal
>
> --Larkin
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

