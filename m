From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: mdadm and raid5 hot-rebuild problem on 2.5.67
Date: Wed, 16 Apr 2003 15:39:00 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16028.60532.659544.421715@notabene.cse.unsw.edu.au>
References: <1050536716.13739.6.camel@testlin.hades>
	<16028.46697.488363.56989@notabene.cse.unsw.edu.au>
	<1050544298.13739.9.camel@testlin.hades>
	<16028.47242.348607.436021@notabene.cse.unsw.edu.au>
	<1050545634.13739.14.camel@testlin.hades>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Stef Telford on  April 16
To: Stef Telford <stef@chronozon.artofdns.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On  April 16, stef@chronozon.artofdns.com wrote:
> > raidstart!  Horrible tool.  Throw it away.
> > 
> 
> consider it gone :)
> 
> > You will need
> >    mdadm --assemble --force ....
> > to start this array as it seems to have suffered an unclean shutdown
> > while degraded.
> > 
> 
> hrm, seems to not want to 'fly' to be honest...
> 

I think I misinterpreted the messages cause by raidstart.
You have given me lots of good information here.  I will try to
interpret it for you:

> 
> [root@survivor stef]# mdadm --detail /dev/md0
> /dev/md0:

to md0 has been sucessfully started...

>    Raid Devices : 4
it should have 4 devices...
...
> 
>     Number   Major   Minor   RaidDevice State
>        0      33        6        0      active sync   /dev/ide/host2/bus0/target0/lun0/part6
>        1      34        1        1      active sync   /dev/ide/host2/bus1/target0/lun0/part1
>        2       0        0       -1      removed
>        3      57        1        3      active sync   /dev/ide/host4/bus1/target0/lun0/part1

but only has 3, so it is degraded.

> [root@survivor stef]# mdadm --assemble --force /dev/md0
> mdadm: device /dev/md0 already active - cannot assemble it

Yep.  It is already started somehow so it cannot be started again.

> [root@survivor stef]# mdadm --manage /dev/md0 -a /dev/ide/host4/bus0/target0/lun0/part2
> mdadm: added /dev/ide/host4/bus0/target0/lun0/part2

We've successfully added a newdrive.  This should be installed as
RaidDevice 2, but not marked 'sync'.  A resync process should run, and
once that is finished, it will be marked sync.
Note that this *is*different* to 2.4 behaviour.
In 2.4 a spare would take up a virtual location outside the regular
array, be synced while there, and then swapped in.
In 2.5, when a spare is activated, it is swapped into position
straight away, then synced, then marked active.  This makes the
internal code cleaner.


> [root@survivor stef]# mdadm --assemble --force /dev/md0
> mdadm: device /dev/md0 already active - cannot assemble it

Still active, so cannot be assembled again.

> [root@survivor stef]# mdadm --detail /dev/md0
...
>     Number   Major   Minor   RaidDevice State
>        0      56        2        0           /dev/ide/host4/bus0/target0/lun0/part2
>        1      34        1        1      active sync   /dev/ide/host2/bus1/target0/lun0/part1
>        2       0        0       -1      removed
>        3      57        1        3      active sync   /dev/ide/host4/bus1/target0/lun0/part1

Ok, this is wrong.  Bigtime.
The spare has taken up postion 0 instead of 2.

I cannot immediately see what would be causing this.  The code looks
right, but obviously isn't.  I'll try to see if I can reproduce it
tomorrow.

> 
> surely, when i -a a drive into the array, it should
> 'fit into' the removed slot on item '2', or does it
> do that already and i am reading the output wrong :\
> 

Yes it should and no it isn't.

> > Well, an answer to my original question would be nice:-)  You should
> > have kernel logs of the time when you got "device busy" from "mdadm -a". 
> > 
> 
> ah this being the rub, there isnt any oops or anything
> like that in the kernel log when i get the device busy,
> not even a 'device currently locked' or 'missing device'
> from what i can see. sorry :\

Well that fact that were was definately no messages logged is helpful,
though I'm not sure yet what it means.
There aren't very many paths which return 'EBUSY'.

NeilBrown
