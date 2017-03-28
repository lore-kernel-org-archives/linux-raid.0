From: Zhilong Liu <zlliu@suse.com>
Subject: Re: md/raid5: report one failure scenario about growing array from
 mirror to level 5
Date: Tue, 28 Mar 2017 21:45:18 +0800
Message-ID: <06ed2d88-956f-94bd-b740-c5d4f44cef43@suse.com>
References: <a0a4cb0b-94d3-a54d-364f-54f02af6e09a@suse.com>
 <20170324155145.boo2h7tgawmujdqx@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170324155145.boo2h7tgawmujdqx@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: NeilBrown <neilb@suse.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On 03/24/2017 11:51 PM, Shaohua Li wrote:
> On Thu, Mar 16, 2017 at 10:14:04PM +0800, Zhilong Liu wrote:
>> hi, list;
>>
>>    I just trace the code of the following scenarios, grow array from mirror
>>    to level 5,  it would be stuck at the beginning of reshape_progress when
>>    using the loop devices, the same testing steps work well via to hard disk
>>    devices.  refer to the detail steps as follow.
>>    Is this issue only happened on my site?
>>
>> *Steps for loop devices:*
>> 1). create one mirror array via to mdadm source code.
>> #  cd mdadm/
>> #  ./test setup
>> #  ./mdadm -CR /dev/md0 --level 1 -b internal -n2 /dev/loop[0-1]
>> #  dmesg -c,    clean the dmesg.
>> 2). triggers the reshape_request, then it would be stuck when start
>> reshape_progress.
>> ... ...
>> linux-x4lv:~/mdadm-test # ./mdadm --grow /dev/md0 -l5 -n3 -a /dev/loop2
>> mdadm: level of /dev/md0 changed to raid5
>> mdadm: added /dev/loop2
>> mdadm: Need to backup 128K of critical section..
>>
>> linux-x4lv:~/mdadm-test # cat /proc/mdstat
>> Personalities : [raid1] [raid6] [raid5] [raid4]
>> md0 : active raid5 loop2[2] loop1[1] loop0[0]
>>        19968 blocks super 1.2 level 5, 64k chunk, algorithm 2 [3/3] [UUU]
>>        [>....................]  reshape =  0.0% (1/19968) finish=41.5min
>> speed=0K/sec
>>        bitmap: 0/1 pages [0KB], 65536KB chunk
>>
>> unused devices: <none>
>>
>> linux-x4lv:~/mdadm-test # dmesg -c
>> [111544.283359] md/raid:md0: device loop1 operational as raid disk 1
>> [111544.283362] md/raid:md0: device loop0 operational as raid disk 0
>> [111544.296161] md/raid:md0: raid level 5 active with 2 out of 2 devices,
>> algorithm 2
>> [111544.296178] md/raid456: discard support disabled due to uncertainty.
>> [111544.296178] Set raid456.devices_handle_discard_safely=Y to override.
>> [111544.932238] md: reshape of RAID array md0
>>
>> *Steps for hard disks:*
>> # ./mdadm --grow /dev/md0 -l5 -n3  -a /dev/sdd
>> mdadm: level of /dev/md0 changed to raid5
>> mdadm: added /dev/sdd
>> mdadm: Need to backup 128K of critical section..
>>
>> # cat /proc/mdstat
>> Personalities : [raid1] [raid0] [raid6] [raid5] [raid4]
>> md0 : active raid5 sdd[2] sdc[1] sdb[0]
>>        102272 blocks super 1.2 level 5, 64k chunk, algorithm 2 [3/3] [UUU]
>>        [====>................]  reshape = 22.5% (23168/102272) finish=0.5min
>> speed=2316K/sec
>>        bitmap: 0/1 pages [0KB], 65536KB chunk
>>
>> unused devices: <none>
> can't reproduce locally. does this only exist in specific mdadm/kernel version?

I have noticed that it causes by the failure of 
"mdadm-grow-continue@%s.service",
I have sent a patch to mailing-list named:
mdadm/grow: reshape would be stuck from raid1 to raid5

I tested it under built the latest linux source code(4.11.0-rc4) and 
latest mdadm.
I would continue to look at this issue.

Thanks,
-Zhilong
> Thanks,
> Shaohua
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

