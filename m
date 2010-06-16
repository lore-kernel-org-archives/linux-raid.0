From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Data-check brings system to a standstill
Date: Wed, 16 Jun 2010 12:52:43 -0400
Message-ID: <4C19015B.3020807@tmr.com>
References: <4C0FCFCD.4070201@quo.to>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C0FCFCD.4070201@quo.to>
Sender: linux-raid-owner@vger.kernel.org
To: Jordan Russell <jr-list-2010@quo.to>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jordan Russell wrote:
> Hi,
>
> I have two RAID1 arrays:
> - md0, the / partition (ext3), lightly accessed
> - md1, a secondary partition (ext3), mounted but not accessed at all
>
> Running on:
> Linux version 2.6.32.12-115.fc12.i686.PAE
> (mockbuild@x86-03.phx2.fedoraproject.org) (gcc version 4.4.3 20100127
> (Red Hat 4.4.3-4) (GCC) ) #1 SMP Fri Apr 30 20:14:08 UTC 2010
>
> /proc/mdstat output is as follows (ignore md9 and md20, they aren't
> being used):
>
>   
>> Personalities : [raid1]
>> md20 : active raid1 sda5[0] sdb5[1]
>>       12241408 blocks [2/2] [UU]
>>
>> md1 : active raid1 sdb6[1] sda6[0]
>>       290503296 blocks [2/2] [UU]
>>       [=====>...............]  check = 28.7% (83548928/290503296) finish=62.0min speed=55605K/sec
>>
>> md9 : active raid1 sda1[0] sdb1[1]
>>       1028032 blocks [2/2] [UU]
>>
>> md0 : active raid1 sdb2[1] sda2[0]
>>       8795520 blocks [2/2] [UU]
>>
>> unused devices: <none>
>>     
>
> My issue is that when I initiate a data-check on md1, attempts to access
> md0 "hang" for long periods of time (sometimes minutes), making the
> machine practically unusable. Even simple operations that are in no way
> I/O intensive, like receiving a single e-mail message, can hang for minutes.
>
> As of kernel 2.6.32 (I didn't see this when I was running 2.6.24-2.6.27
> previously), the kernel also emits "hung task" warnings every few
> minutes while the data-check is in progress:
>
> # echo check > /sys/block/md1/md/sync_action
> # cat /var/log/messages
>   
>> Jun  9 11:11:32 system kernel: md: data-check of RAID array md1
>> Jun  9 11:11:32 system kernel: md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
>> Jun  9 11:11:32 system kernel: md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
>> Jun  9 11:11:32 system kernel: md: using 128k window, over a total of 290503296 blocks.
>> Jun  9 11:18:32 system kernel: INFO: task kjournald:448 blocked for more than 120 seconds.
>> Jun  9 11:18:32 system kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> Jun  9 11:18:32 system kernel: kjournald     D 00066faa     0   448      2 0x00000000
>> Jun  9 11:18:32 system kernel: f614de5c 00000046 463cb427 00066faa 000039d3 00000000 f6bc0f6c 00000000
>> Jun  9 11:18:32 system kernel: c0a81354 c0a85e60 f6bc0f6c c0a85e60 c0a85e60 f614de4c c0462bdf 3a0a8f3d
>> Jun  9 11:18:32 system kernel: 00000000 00000000 00066faa f6bc0cc0 c1e08e60 00000000 f614deac f614de54
>> Jun  9 11:18:32 system kernel: Call Trace:
>> Jun  9 11:18:32 system kernel: [<c0462bdf>] ? ktime_get_ts+0x98/0xa2
>> Jun  9 11:18:32 system kernel: [<c07a503f>] io_schedule+0x37/0x4e
>> Jun  9 11:18:32 system kernel: [<c0501f94>] sync_buffer+0x38/0x3c
>> Jun  9 11:18:32 system kernel: [<c07a54fe>] __wait_on_bit+0x39/0x60
>> Jun  9 11:18:32 system kernel: [<c0501f5c>] ? sync_buffer+0x0/0x3c
>> Jun  9 11:18:32 system kernel: [<c0501f5c>] ? sync_buffer+0x0/0x3c
>> Jun  9 11:18:32 system kernel: [<c07a55c5>] out_of_line_wait_on_bit+0xa0/0xa8
>> Jun  9 11:18:32 system kernel: [<c045b6cd>] ? wake_bit_function+0x0/0x3c
>> Jun  9 11:18:32 system kernel: [<c0501ed1>] __wait_on_buffer+0x1e/0x21
>> Jun  9 11:18:32 system kernel: [<c056aa86>] wait_on_buffer+0x34/0x37
>> Jun  9 11:18:32 system kernel: [<c056b2dc>] journal_commit_transaction+0x7b3/0xc57
>> Jun  9 11:18:32 system kernel: [<c044e742>] ? try_to_del_timer_sync+0x5e/0x66
>> Jun  9 11:18:32 system kernel: [<c056de45>] kjournald+0xb8/0x1cc
>> Jun  9 11:18:32 system kernel: [<c045b699>] ? autoremove_wake_function+0x0/0x34
>> Jun  9 11:18:32 system kernel: [<c056dd8d>] ? kjournald+0x0/0x1cc
>> Jun  9 11:18:32 system kernel: [<c045b461>] kthread+0x64/0x69
>> Jun  9 11:18:32 system kernel: [<c045b3fd>] ? kthread+0x0/0x69
>> Jun  9 11:18:32 system kernel: [<c0409cc7>] kernel_thread_helper+0x7/0x10
>>     
> ...
>
> I don't understand why this is happening, given that md claims to be
> using "idle IO bandwidth". Does "idle IO bandwidth" only refer to I/O on
> the same md device (i.e. md1)? Does it not allow other md devices (i.e.
> md0) to cut into the bandwidth used for the data-check?
>
> I can work around this by setting sync_speed_max to a value about 5 MB
> lower than the current sync rate. But since the transfer rate drops as
> it nears the end of the disks, I have to keep lowering the
> sync_speed_max value, otherwise the hangs resurface.
>
> If I force a resync of md1 by removing and re-adding sdb6 (with mdadm
> -f, -r, -a), I *don't* see this problem. There are no "hung task"
> warnings during the resync, and AFAICT no significant hangs on md0.
>
> Any ideas on what might be causing this, or how to solve it?
>   

Not sure what's causing that, other than you just have your max set 
pretty high for raid1. By leaving nothing in the way of capacity for 
system operation you are filling all of memory with writes to the 
resyncing drive. I would measure the speed of the disk read on the inner 
tracks (dd with offset from sda to /dev/null) and not set max over 2/3 
of that. Alternatively, you can try setting your io scheduler to 
deadline, changing your queue depth, or otherwise overcome what you are 
asking the disk to do.

I think md would benefit from a limit on how much io can be outstanding 
to any given device, but that would be a non-trivial change, I fear.

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

