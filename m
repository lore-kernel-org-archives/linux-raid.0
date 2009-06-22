From: Randall Smith <randall@tnr.cc>
Subject: Re: resync hangs
Date: Sun, 21 Jun 2009 22:18:15 -0500
Message-ID: <h1mt5n$b74$1@ger.gmane.org>
References: <h0e9qm$91r$1@ger.gmane.org> <h0mjne$mkv$1@ger.gmane.org> <e95d1c83e3f5fa745e914e77e90dd8ec.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e95d1c83e3f5fa745e914e77e90dd8ec.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown wrote:
> On Wed, June 10, 2009 7:20 am, Randall Smith wrote:
>> Maybe I should have used "resync stalls" in the subject.
>>
>> Any hints about this?  What kind of things might cause it to stall?
> 
> I cannot think of anything that would cause a stall like that.
> 
> The "128" suggest that md_do_sync has scheduled one "window" of
> IO and is in the section of code that calculates the speed and
> makes sure were aren't going too fast.
> 
> 'currspeed' will almost certainly be '1' by this point, so it seems
> to imply that min_speed and max_speed are both zero.  Seems unlikely.
> You could confirm or deny that with
> 
>    grep . /sys/block/md2/md/*
> 
> if you ever see the problem again.


Happened again.

md2 : active raid5 sda3[0] sdf3[2] sdc3[1]
       488279424 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
       [>....................]  resync =  0.3% (787584/244139712) 
finish=1257319.3min speed=0K/sec


~$ grep . /sys/block/md2/md/*
/sys/block/md2/md/array_state:active
grep: /sys/block/md2/md/bitmap_set_bits: Permission denied
/sys/block/md2/md/chunk_size:65536
/sys/block/md2/md/component_size:244139712
/sys/block/md2/md/degraded:0
/sys/block/md2/md/layout:2
/sys/block/md2/md/level:raid5
/sys/block/md2/md/metadata_version:0.90
/sys/block/md2/md/mismatch_cnt:0
grep: /sys/block/md2/md/new_dev: Permission denied
/sys/block/md2/md/preread_bypass_threshold:1
/sys/block/md2/md/raid_disks:3
/sys/block/md2/md/reshape_position:none
/sys/block/md2/md/resync_start:0
/sys/block/md2/md/safe_mode_delay:0.204
/sys/block/md2/md/stripe_cache_active:0
/sys/block/md2/md/stripe_cache_size:256
/sys/block/md2/md/suspend_hi:0
/sys/block/md2/md/suspend_lo:0
/sys/block/md2/md/sync_action:resync
/sys/block/md2/md/sync_completed:1575168 / 488279424
/sys/block/md2/md/sync_force_parallel:0
/sys/block/md2/md/sync_max:max
/sys/block/md2/md/sync_min:0
/sys/block/md2/md/sync_speed:0
/sys/block/md2/md/sync_speed_max:0 (system)
/sys/block/md2/md/sync_speed_min:0 (system)


> 
> Just to clarify:  You have seen this only occasionally, not everytime
> a resync is needed.  But you have seen it both on 2.6.26 and 2.6.29
> (Debian versions).  Correct?


Happens every time a resync is needed.  I have to boot a rescue cd to 
rebuild it.

> 
> Thanks,
> NeilBrown
> 
> 
>> Randall
>>
>> Randall Smith wrote:
>>> On occasions that my raid5 array needs to resync (power outage, etc),
>>> the resync stops progressing early on.  This is on Debian Lenny.  I've
>>> tried the stock 2.6.26 kernel as well as the 2.6.29 kernel from Sid.
>>>
>>> On boot:
>>>
>>> [   10.022020] md: md2: raid array is not clean -- starting background
>>> reconstruction
>>> [   10.032896] raid5: allocated 3226kB for md2
>>> [   10.032936] raid5: raid level 5 set md2 active with 3 out of 3
>>> devices, algorithm 2
>>> [   10.033685]  md2: unknown partition table
>>> [   20.492246] md: resync of RAID array md2
>>>
>>>
>>> ~$ cat /proc/mdstat
>>>
>>> md2 : active raid5 sda3[0] sdf3[2] sdc3[1]
>>>       488279424 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
>>>       [>....................]  resync =  0.0% (128/244139712)
>>> finish=1220697.9min speed=0K/sec
>>>
>>>
>>> I it resyncs find when using a live cd.  Any ideas what's causing it to
>>> hang.
>>>
>>> --Randall

Randall

