From: Bogo Mipps <bogo.mipps@gmail.com>
Subject: Re: Advice please re failed Raid6
Date: Wed, 19 Jul 2017 13:52:59 +1200
Message-ID: <f79a45b9-590b-4d3c-d387-81abfb02743d@gmail.com>
References: <9dca5b7a-b60e-0e93-41fd-49d092d8b27b@gmail.com>
 <22892.649.826246.644975@tree.ty.sabi.co.uk>
Reply-To: bogo.mipps@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <22892.649.826246.644975@tree.ty.sabi.co.uk>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg@lxraid2.for.sabi.co.UK>, Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 07/17/2017 12:19 PM, Peter Grandi wrote:
> The line that worries a bit is this:
> 
>    Jul 5 21:06:18 keruru mdadm[2497]: RebuildFinished event
>    detected on md  device /dev/md0, component device mismatches
>    found: 1847058224 (on raid  level 6)
> 
> That seems to indicate that pretty much every block was a
> mismatch. Which would have happened if you put in a blank drive
> and then used '--create --assume-clean' instead of '--assemble
> --force'. But '--assume-clean" explicitly skips a rebuild, and I
> wonder whether you omitted that yoiu have triggered a "repair"
> in 'sync_action'. Also the message is reported by 'mdadm', and
> it may be that 'mdadm' was running in daemon mode and triggering
> a periodic "repair". I can't remember the defaults.
> 
> HOWEVER there is a very subtle detail: the order of the devices
> from '--examine' is: 0: 'sdb', 1: 'sdc', 2: 'sdd', 3: 'sde' but
> you recreated the set in a different order. The order of the
> devices does not matter if they have MD superblocks,.but here
> you are using '--create' to make new superblocks, and they order
> must match exactly the original order.
> 
>> root@keruru:/var/log# mdadm --create --assume-clean --level=6 --raid-devices=4 --size=1953382912 /dev/md0 /dev/sdb /dev/sde /dev/sdd /dev/sdc
> 
> Probably the best thing you can do is to rerun this with members
> "missing /dev/sdc /dev/sdd /dev/sde". and then use 'blkid /dev/md0'
> to check whether the data in it is recognized again. If so add
> '/dev/sdb'. I did a quick test here of something close to that
> and it worked...

Thanks for responding, Peter.  Much appreciated.

Did I do it right? (See below)

root@keruru:~# mdadm --create --assume-clean --level=6 --raid-devices=4 
--size=1953382912 /dev/md0 missing /dev/sdc /dev/sdd /dev/sde
mdadm: /dev/sdc appears to be part of a raid array:
     level=raid6 devices=4 ctime=Tue Jul 11 17:33:12 2017
mdadm: /dev/sdd appears to be part of a raid array:
     level=raid6 devices=4 ctime=Tue Jul 11 17:33:12 2017
mdadm: /dev/sde appears to be part of a raid array:
     level=raid6 devices=4 ctime=Tue Jul 11 17:33:12 2017
Continue creating array? y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.

root@keruru:~# blkid /dev/md0
root@keruru:~#

root@keruru:~# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active (auto-read-only) raid6 sde[3] sdd[2] sdc[1]
       3906765824 blocks super 1.2 level 6, 512k chunk, algorithm 2 
[4/3] [_UUU]

unused devices: <none>

No reading from blkid, so I am assuming 'not good'.  But I've done 
nothing further in case I misunderstood your suggestion.



