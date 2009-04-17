From: Neil Brown <neilb@suse.de>
Subject: Re: RAID 10 array won't assemble, all devices marked spare, confusing mdadm metadata
Date: Sat, 18 Apr 2009 08:38:59 +1000
Message-ID: <18921.1283.548260.293728@notabene.brown>
References: <20090417141402.GB27042@davefisher.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dave Fisher on Friday April 17
Sender: linux-raid-owner@vger.kernel.org
To: Dave Fisher <davef@davefisher.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday April 17, davef@davefisher.co.uk wrote:
> Hi,
> 
> Please forgive me if I'm posting to the wrong list because I've
> misunderstood the list's parameters.  The osdl wiki, and the list
> archives it points to, suggest that this is *not* a developer-only
> list. If I've got that wrong, please redirect me to somewhere more
> appropriate.

No, this is not developer only.  Not at all.

> 
> I need help to diagnose a RAID 10 failure, but I'm struggling to find
> anyone with genuinely authoritive knowledge of Linux software raid who
> might be willing to spare a little time to help me out.

You've come to the right place.


> 
> The affected system is an Ubuntu 8.10 amd64 server, running a 2.6.27-11
> kernel.
> 
> I have two RAID arrays:
> 
> [CODE]
>   $ sudo mdadm --examine --scan -v
>   ARRAY /dev/md0 level=raid1 num-devices=2 UUID=e1023500:94537d05:cb667a5a:bd8e784b
>      spares=1   devices=/dev/sde2,/dev/sdd2,/dev/sdc2,/dev/sdb2,/dev/sda2
>   ARRAY /dev/md1 level=raid10 num-devices=4 UUID=f4ddbd55:206c7f81:b855f41b:37d33d37
>      spares=1   devices=/dev/sde4,/dev/sdd4,/dev/sdc4,/dev/sdb4,/dev/sda4
> [/CODE]
> 
> /dev/md1 doesn't assemble on boot, and I can't assemble it manually (although
> that might be because I don't know how to):
> 
> [CODE]
>   $ sudo mdadm --assemble /dev/md1 /dev/sda4 /dev/sdb4 /dev/sdc4 /dev/sdd4 /dev/sde4
>   mdadm: /dev/md1 assembled from 1 drive and 1 spare - not enough to start the array.
> [/CODE]

Extracting a summary from the
> $ sudo mdadm -E /dev/sd{a,b,c,d,e}4
information you provided (thanks for being thorough),

> [CODE]
> $ sudo mdadm -E /dev/sd{a,b,c,d,e}4
> /dev/sda4:
>     Update Time : Tue Apr 14 00:45:27 2009
>           State : active
>          Events : 221
> /dev/sdb4:
>     Update Time : Tue Apr 14 00:44:13 2009
>           State : active
>          Events : 219
> /dev/sdc4:
>     Update Time : Tue Apr 14 00:44:13 2009
>           State : active
>          Events : 219
> /dev/sdd4:
>     Update Time : Tue Apr 14 00:44:13 2009
>           State : active
>          Events : 219
> /dev/sde4:
>     Update Time : Fri Apr 10 16:43:47 2009
>           State : clean
>          Events : 218
> [/CODE]

So sda is most up-to-date.  sd[bcd]4 were updated 74 seconds
earlier. and sde4 has not been updated for 4 days.
So it looks like sde4 failed first, and then when it
tried to update the metadata on the array, sda4 worked but all the
rest failed to get updated.

Given that sda thinks the array is still intact as we can see from

>       Number   Major   Minor   RaidDevice State
> this     0       8       20        0      active sync   /dev/sdb4
> 
>    0     0       8       20        0      active sync   /dev/sdb4
>    1     1       8       36        1      active sync   /dev/sdc4
>    2     2       0        0        2      faulty removed
>    3     3       8       68        3      active sync   /dev/sde4
>    4     4       8       84        4      spare

Your data is safe and we can get it back.
Note that the device currently known as /dev/sda4 thought, last time
the metadata was updated, that it's name was /dev/sdb4.  This suggests
some rearrangement of devices has happened.  This can be confusing,
but mdadm copes without any problem.
To restart your array, simple use the "--force" flag.
It might be valuable to also add "--verbose" so you can see what is
happening.
So:

  mdadm -S /dev/md1
  mdadm -A /dev/md1 -fv /dev/sd[abcde]4

and report the result.


> 
> As you can see from mdstat, the kernel appears to have marked all the
> partitions in /dev/md1 as spare (S):
> 
> [CODE]
>   $ cat /proc/mdstat
>   Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
>   md1 : inactive sda4[0](S) sde4[4](S) sdd4[3](S) sdc4[2](S) sdb4[1](S)
>         4829419520 blocks

When an array is 'inactive', everything is 'spare'.  It's an internal
implementation detail.  Probably confusing, yes.

> 
> As you can see, sda4 is not explicitly listed in any of the tables above.

This is presumably because names changed between tables being written.

> 
> I am guessing that this is because mdadm thinks that sda4 is the actual spare.  
> 
> I'm not sure that mdadm is correct.  Based on the fdisk readouts shown below,
> and my (admittedly imperfect human) memory, I think that sde4 should be the
> spare
> 
> Another confusing thing is that mdadm --examine for sda4 produces results that
> appear to contradict the examinations of sdb4, sdc4, sdd4, and sde4.
> 
> The results for sda4 show one partition (apparently sdd4) to be "faulty
> removed", but the other four examinations show sdd4 as "active sync".
> Examining sda4 also shows 1 "Failed" device, whereas the remaining 4
> examinations show no failures.
> 
> On the other hand, sda4, sdb4, sdc4, and sdd4 are shown as "State: active"
> whereas sde4 is shown as "State: clean".  

So this is what probably happened:
 The array has been idle, or read-only, since April 10, so no metadata
 updates happened and all devices were at "Events 218" and were 'clean'.
 At Apr 14 00:44:13, something tried to write to the array so it had
 to be marked 'active'.  This involves writing the metadata to every
 device and updating the Event count to 219.
 This worked for 3 of the 4 devices in the array.  For the 4th -
 currently called '/dev/sde4' but at the time called /dev/sdd4, the
 metadata update failed.
 So md/raid10 decided that device was faulty and so tried to update
 the metadata to record this fact.
 That metadata update succeeded for one devices, currently called sda4
 but at the time was called sdb4.  For the rest of the devices the
 update failed.  At this point the array would (understandably) no
 longer work.

 mdadm can fix this up for you with the "-f" flag.  It will probably
 trigger a resync, just to be on the safe side.  But all your data
 will be there.

NeilBrown
