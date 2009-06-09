From: "NeilBrown" <neilb@suse.de>
Subject: Re: resync hangs
Date: Wed, 10 Jun 2009 07:55:48 +1000 (EST)
Message-ID: <e95d1c83e3f5fa745e914e77e90dd8ec.squirrel@neil.brown.name>
References: <h0e9qm$91r$1@ger.gmane.org> <h0mjne$mkv$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <h0mjne$mkv$1@ger.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Randall Smith <randall@tnr.cc>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, June 10, 2009 7:20 am, Randall Smith wrote:
> Maybe I should have used "resync stalls" in the subject.
>
> Any hints about this?  What kind of things might cause it to stall?

I cannot think of anything that would cause a stall like that.

The "128" suggest that md_do_sync has scheduled one "window" of
IO and is in the section of code that calculates the speed and
makes sure were aren't going too fast.

'currspeed' will almost certainly be '1' by this point, so it seems
to imply that min_speed and max_speed are both zero.  Seems unlikely.
You could confirm or deny that with

   grep . /sys/block/md2/md/*

if you ever see the problem again.

Just to clarify:  You have seen this only occasionally, not everytime
a resync is needed.  But you have seen it both on 2.6.26 and 2.6.29
(Debian versions).  Correct?

Thanks,
NeilBrown


>
> Randall
>
> Randall Smith wrote:
>> On occasions that my raid5 array needs to resync (power outage, etc),
>> the resync stops progressing early on.  This is on Debian Lenny.  I've
>> tried the stock 2.6.26 kernel as well as the 2.6.29 kernel from Sid.
>>
>> On boot:
>>
>> [   10.022020] md: md2: raid array is not clean -- starting background
>> reconstruction
>> [   10.032896] raid5: allocated 3226kB for md2
>> [   10.032936] raid5: raid level 5 set md2 active with 3 out of 3
>> devices, algorithm 2
>> [   10.033685]  md2: unknown partition table
>> [   20.492246] md: resync of RAID array md2
>>
>>
>> ~$ cat /proc/mdstat
>>
>> md2 : active raid5 sda3[0] sdf3[2] sdc3[1]
>>       488279424 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
>>       [>....................]  resync =  0.0% (128/244139712)
>> finish=1220697.9min speed=0K/sec
>>
>>
>> I it resyncs find when using a live cd.  Any ideas what's causing it to
>> hang.
>>
>> --Randall
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

