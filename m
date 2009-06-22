From: "NeilBrown" <neilb@suse.de>
Subject: Re: resync hangs
Date: Mon, 22 Jun 2009 13:46:31 +1000 (EST)
Message-ID: <31c94e366685d963f1a4794853b9339f.squirrel@neil.brown.name>
References: <h0e9qm$91r$1@ger.gmane.org> <h0mjne$mkv$1@ger.gmane.org>
    <e95d1c83e3f5fa745e914e77e90dd8ec.squirrel@neil.brown.name>
    <h1mt5n$b74$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <h1mt5n$b74$1@ger.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Randall Smith <randall@tnr.cc>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, June 22, 2009 1:18 pm, Randall Smith wrote:
> NeilBrown wrote:
>> On Wed, June 10, 2009 7:20 am, Randall Smith wrote:
>>> Maybe I should have used "resync stalls" in the subject.
>>>
>>> Any hints about this?  What kind of things might cause it to stall?
>>
>> I cannot think of anything that would cause a stall like that.
>>
>> The "128" suggest that md_do_sync has scheduled one "window" of
>> IO and is in the section of code that calculates the speed and
>> makes sure were aren't going too fast.
>>
>> 'currspeed' will almost certainly be '1' by this point, so it seems
>> to imply that min_speed and max_speed are both zero.  Seems unlikely.
>> You could confirm or deny that with
>>
>>    grep . /sys/block/md2/md/*
>>
>> if you ever see the problem again.
>
>
> Happened again.
>
> md2 : active raid5 sda3[0] sdf3[2] sdc3[1]
>        488279424 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
>        [>....................]  resync =  0.3% (787584/244139712)
> finish=1257319.3min speed=0K/sec

This is a little different.  Instead of stopping at 128K, it
stopped at 787M.  So it didn't stop straight away.

>
>
> ~$ grep . /sys/block/md2/md/*
...
> /sys/block/md2/md/sync_speed:0
> /sys/block/md2/md/sync_speed_max:0 (system)
> /sys/block/md2/md/sync_speed_min:0 (system)

This looks like the culprit.  The sync_speed has been limited to
0.  The "(system)" means that it is using the value from
  /proc/sys/dev/raid/speed_limit_max

It seem that that value has been set to 0 somehow.
The default value is 200000.

Could something be setting that?  Can you set it back?
 .../speed_limit_min should be 1000 by default.

NeilBrown


