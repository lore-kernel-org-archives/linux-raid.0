From: "Robison, Jon (CMG-Atlanta)" <narfman0@gmail.com>
Subject: Re: mdadm raid5 single drive fail, single drive out of sync terror
Date: Fri, 28 Nov 2014 12:00:56 -0500
Message-ID: <5478AA48.2050601@gmail.com>
References: <5475ECDC.6070309@gmail.com> <20141126154922.GA12222@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20141126154922.GA12222@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks Robin and Phil, mdadm 3.3.2 did allow successful forced 
reassemble (had to run the command twice for whatever reason, first 
execution said 4 aren't enough drives). I am updating my backup but 
already retrieved the things of high value. I consider this mission 
accomplished already.

Next steps I will take: backup -> fsck -> backup -> add missing disk -> 
add more automation to main and backup -> profit


On 11/26/14 10:49 AM, Robin Hill wrote:
> On Wed Nov 26, 2014 at 10:08:12AM -0500, Jon Robison wrote:
>
>> Hi all!
>>
>> I upgraded to mdadm-3.3-7.fc20.x86_64, and my raid5 array would no
>> longer recognize /dev/sdb1 in my raid 5 array (which is normally
>> /dev/sd[b-f]1). I `mdadm --detail --scan`,  which resulted in a degraded
>> array, then added /dev/sdb1, and it started rebuilding happily until 25%
>> or so, when another failure seemed to occur.
>>
>> I am convinced the data is fine on /dev/sd[c-f]1, and that somehow I
>> just need to inform mdadm about that, but they got out of sync and
>> /dev/sde1 thinks the array is AAAAA while the others think its AAA.. .
>> The drives also seem to think e is bad because f said e was bad or some
>> weird stuff, and sde1 is behind by ~50 events or so. That error hasn't
>> shown itself recently. I fear sdb is bad and sde is going to go soon.
>>
>> Results of `mdadm --examine /dev/sd[b-f]1` are here
>> http://dpaste.com/2Z7CPVY
>>
>> I'm scared and alone. Everything is off and sitting as above, though e
>> 50 events behind and out of synch. New drives coming Friday and backup
>> is of course a bit old. I'm petrified to execute `mdadm --create
>> --assume-clean --level=5 --raid-devices=5 /dev/md0 /dev/sdf1 /dev/sdd1
>> /dev/sdc1 /dev/sde1 missing`, but that seems my next option unless ya'll
>> know better. I tried `mdadm --assemble -f /dev/md0 /dev/sdf1 /dev/sdd1
>> /dev/sdc1 /dev/sde1` and it said something like can't start with only 3
>> devices (which I wouldn't expect because examine still shows 4, just
>> that they are out of sync and I thought that was -f's express purpose in
>> assemble mode). Anyone have any suggestions? Thanks!
> It looks like this is a bug in 3.3 (the checkin logs show something
> similar anyway). I'd advise getting 3.3.1 or 3.3.2 and retrying the
> forced assembly.
>
> If it failed during the rebuild, that would suggest there's an
> unreadable block on sde though, which means you'll hit the same issue
> again when you try to rebuild sdb. You'll need to:
>      - image sde to a new disk (via ddrescue)
>      - assemble the array
>      - add another new disk in to rebuild
>      - once the rebuild has completed, force a fsck on the array
>        (fsck -f /dev/md0) as the unreadable block may have caused some
>        filesystem corruption. It may also cause some file corruption, but
>        that's not something that can be easily checked.
>
> These read errors can be picked up and fixed by running regular array
> checks (echo check > /sys/block/md0/md/sync_action). Most distributions
> have these set up in cron, so make sure that's in there and enabled.
>
> The failed disks may actually be okay (sde particularly), so I'd advise
> checking SMART stats and running full badblocks write tests on them. If
> the badblocks tests run okay and there's no increase in reallocated
> sectors reported in SMART, they should be perfectly okay for re-use.
>
> Cheers,
>      Robin

