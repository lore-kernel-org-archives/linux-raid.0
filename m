From: Kevin Ross <kevin@familyross.net>
Subject: Re: RAID extremely slow
Date: Wed, 25 Jul 2012 18:55:18 -0700
Message-ID: <5010A386.4080209@familyross.net>
References: <501078B2.8070707@familyross.net> <501096C3.5060700@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <501096C3.5060700@turmel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-kernel@vger.kernel.org, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thank you very much for taking the time to look into this.

On 07/25/2012 06:00 PM, Phil Turmel wrote:
> Piles of small reads  scattered across multiple drives, and a
> concentration of queued writes to /dev/sda.  What's on /dev/sda?
> It's not a member of the raid, so it must be some other system task
> involved.

/dev/sda1 is the root filesystem.  The writes were most likely by MySQL, 
but I would have to run iotop to be sure.

> [ The output of "lsdrv" [1] might be useful here, along with
> "mdadm -D /dev/md0" and "mdadm -E /dev/[b-j]" ]

Here you go: http://pastebin.ca/2174740

> MythTV is trying to flush recorded video to disk, I presume.  Sync is
> known to cause stalls--a great deal of work is on-going to improve
> this.  How old is this kernel?

After rebooting, MythTV is currently recording two shows, and the resync 
is running at full speed.

# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid6 sdh1[0] sdd1[9] sde1[10] sdb1[6] sdi1[7] sdc1[4] 
sdf1[3] sdg1[8] sdj1[1]
       6837311488 blocks super 1.2 level 6, 512k chunk, algorithm 2 
[9/9] [UUUUUUUUU]
       [=>...................]  resync =  9.3% (91363840/976758784) 
finish=1434.3min speed=10287K/sec

unused devices: <none>

atop shows the avio of all the drives to be less than 1ms, where before 
they were much higher.  It will run for a couple days under load just 
fine, and then it will come to a halt.

It's a 3.2.21 kernel.  I'm running Debian Testing, and the exact Debian 
package version is:

ii  linux-image-3.2.0-3-686-pae                    
3.2.21-3                                       Linux 3.2 for modern PCs

>
>> [51000.672258]  [<c12c409f>] ? sysenter_do_call+0x12/0x28
>> [51000.672261]  [<c12b0000>] ? quirk_usb_early_handoff+0x4a9/0x522
>>
>> Here is some other possibly relevant info:
>>
>> # cat /proc/mdstat
>> Personalities : [raid6] [raid5] [raid4]
>> md0 : active raid6 sdh1[0] sdd1[9] sde1[10] sdb1[6] sdi1[7] sdc1[4]
>> sdf1[3] sdg1[8] sdj1[1]
>>        6837311488 blocks super 1.2 level 6, 512k chunk, algorithm 2 [9/9]
>> [UUUUUUUUU]
>>        [==========>..........]  resync = 51.3% (501954432/976758784)
>> finish=28755.6min speed=275K/sec
> Is this resync a weekly check, or did something else trigger it?

This is not a scheduled check.  It was triggered by, I believe, an 
unclean shutdown.  An unclean shutdown will trigger a resync.  I don't 
think it used to do this, but I could be remembering wrong.

>
>> unused devices:<none>
>>
>> # cat /proc/sys/dev/raid/speed_limit_min
>> 10000
> MD is unable to reach its minimum rebuild rate while other system
> activity is ongoing.  You might want to lower this number to see if that
> gets you out of the stalls.
>
> Or temporarily shut down mythtv.

I will try lowering those numbers next time this happens, which will 
probably be within the next day or two.  That's about how often this 
happens.

>> # cat /proc/sys/dev/raid/speed_limit_max
>> 200000
>>
>> Thanks in advance!
>> -- Kevin
> HTH,
>
> Phil
>
> [1] http://github.com/pturmel/lsdrv
>

Thanks!
-- Kevin
