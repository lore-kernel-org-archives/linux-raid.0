From: Georgi Nikolov <gnikolov@icdsoft.com>
Subject: Re: Pausing md check hangs
Date: Tue, 28 Jan 2020 10:11:21 +0200
Message-ID: <ac3ae81d-8dad-8b4e-bc61-fc37514e3929@icdsoft.com>
References: <2ce8813c-fd3e-5e78-39ac-049ddfa79ff6@icdsoft.com>
 <CAPhsuW4Jc-qef9uW-JSut90qOpDc_4VoAFpMU8KwqnK7EeT_xg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPhsuW4Jc-qef9uW-JSut90qOpDc_4VoAFpMU8KwqnK7EeT_xg@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <song@kernel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Yes the kernel is 4.19.67-2+deb10u2. I have tried with 5.4.8-1~bpo10+1 
and same thing happened.
Before this i have used same thing for a long time with kernel 4.9.189-3.
It happens most often when there is some heavy IO.

Georgi Nikolov
> On Mon, Jan 27, 2020 at 5:44 AM Georgi Nikolov <gnikolov@icdsoft.com> wrote:
>> Hi,
>>
>> I posted a kernel bug about this a month ago but it did not receive any
>> attention: https://bugzilla.kernel.org/show_bug.cgi?id=205929
>> Here is a copy of the bug report and I hope that this is the correct
>> place to discuss this:
>>
>> I have a Supermicro server with 10 md raid6 arrays each consisting of 8
>> SATA drives. SATA drives are Hitachi/HGST Ultrastar 7K4000 8T.
>> When i try to pause array check with "echo idle >
>> "/sys/block/<md_dev>/md/sync_action" it randomly hangs at different md
>> device.
>> Process "mdX_raid6" is at 100% cpu usage. cat
>> /sys/block/mdX/md/journal_mode hungs forever.
>>
>> Here is the state at the moment of crash for one of the md devices:
>>
>> root@supermicro:/sys/block/mdX/md# find -mindepth 1 -maxdepth 1 -type
>> f|sort|grep -v journal_mode|xargs -r egrep .
>> ./array_size:default
>> ./array_state:write-pending
>> grep: ./bitmap_set_bits: Permission denied
>> ./chunk_size:524288
>> ./component_size:7813895168
>> ./consistency_policy:resync
>> ./degraded:0
>> ./group_thread_cnt:4
>> ./last_sync_action:check
>> ./layout:2
>> ./level:raid6
>> ./max_read_errors:20
>> ./metadata_version:1.2
>> ./mismatch_cnt:0
>> grep: ./new_dev: Permission denied
>> ./preread_bypass_threshold:1
>> ./raid_disks:8
>> ./reshape_direction:forwards
>> ./reshape_position:none
>> ./resync_start:none
>> ./rmw_level:1
>> ./safe_mode_delay:0.204
>> ./skip_copy:0
>> ./stripe_cache_active:13173
>> ./stripe_cache_size:8192
>> ./suspend_hi:0
>> ./suspend_lo:0
>> ./sync_action:check
>> ./sync_completed:3566405120 / 15627790336
>> ./sync_force_parallel:0
>> ./sync_max:max
>> ./sync_min:1821385984
>> ./sync_speed:126
>> ./sync_speed_max:1000 (local)
>> ./sync_speed_min:1000 (system)
>>
>> root@supermicro:~# cat /proc/mdstat
>> Personalities : [raid1] [linear] [multipath] [raid0] [raid6] [raid5]
>> [raid4] [raid10]
>> md4 : active raid6 sdaa[2] sdab[3] sdy[0] sdae[6] sdac[4] sdad[5]
>> sdaf[7] sdz[1]
>>         46883371008 blocks super 1.2 level 6, 512k chunk, algorithm 2
>> [8/8] [UUUUUUUU]
>>         [====>................]  check = 22.8% (1784112640/7813895168)
>> finish=20571.7min speed=4884K/sec
> Thanks for the report.
>
> Could you please confirm the kernel is 4.19.67-2+deb10u2 amd64?
> Also, have you tried different kernels?
>
> Song
