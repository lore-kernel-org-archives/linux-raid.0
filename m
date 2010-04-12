From: MRK <mrk@shiftmail.org>
Subject: Re: stuck tasks
Date: Mon, 12 Apr 2010 14:49:48 +0200
Message-ID: <4BC316EC.9040808@shiftmail.org>
References: <hputbs$qq2$1@dough.gmane.org> <4BC2FE9E.9040802@shiftmail.org>
 <hpuvbb$13t$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <hpuvbb$13t$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jeremy Sanders <jeremy@jeremysanders.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/12/2010 01:14 PM, Jeremy Sanders wrote:
> MRK wrote:
>
>    
>> You need to lower the sync speed by catting a value into
>> /sys/block/md{n}/md/sync_speed_max
>> the value should be about 1/3 lower than the max speed you see (cat
>> /proc/mdstat) now that it's not yet limited.
>> Set up a script to set it at boot.
>>      
> Thanks - I'll try it. It didn't happen in a raid sync, just during an rsync
> run. Would this have any effect on normal operation?
>    

!?!!

Mistake of mine, but I might have gotten the right answer by chance
I had read resyncing but you wrote rsyncing.
But you were in fact also resyncing from what you write below:


>> If it was not happening for you on older kernels might be a good sign:
>> it might mean that the resync is faster now...
>>
>> What is the sync speed you see (cat /proc/mdstat)? How many drives do
>> you have and what type of raid is that?
>>      
> We're only getting 30MB/s. I thought it used to be quite a lot faster. It
> seems to slow down as the sync progresses:
>
> [root@xback2 ~]#  cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid5 sdb1[0] sdj1[10](S) sdk1[9] sdl1[8] sdi1[7] sdh1[6]
> sdg1[5] sdf1[4] sde1[3] sdd1[2] sdc1[1]
>        8788959360 blocks level 5, 32k chunk, algorithm 2 [10/10] [UUUUUUUUUU]
>        [>....................]  resync =  1.4% (14078544/976551040)
> finish=501.4min speed=31990K/sec
>    


Resync speed is indeed quite low if you confirm there is no other disk 
activity.
Instead if rsync is also running, you need to stop that one to have a 
proper resync speed measurement (to compute the value to be entered into 
sync_speed_max as per my previous email).
Do you have disk write caches activated? See that with tw_cli (3ware's CLI)
How much is /sys/block/md{n}/md/stripe_cache_size? Pump it up to 32768.

> unused devices:<none>
>
> The drives are connected to a single 3ware Inc 9650SE SATA-II RAID PCIe card
> on this particular system. They're SATA 1GB drives.
>
> Jeremy
>    


