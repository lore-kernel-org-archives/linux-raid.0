From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: HELP.. how to remove a spare drive i accidently added
Date: Wed, 19 Nov 2003 09:38:16 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16314.40792.616508.878124@notabene.cse.unsw.edu.au>
References: <Pine.LNX.4.56.0311181431340.11397@nemesis.cs.yorku.ca>
	<PPEOJEIEFLAONFNHJPOOKEHMGOAA.jim@jimtreats.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from James R Bamford on Tuesday November 18
To: James R Bamford <jim@jimtreats.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday November 18, jim@jimtreats.com wrote:
> 
> mdadm -D revealed this
> 
.....
> 
>     Number   Major   Minor   RaidDevice State
>        0      33        1        0      active sync   /dev/hde1
>        1       0        0        1      faulty removed
>        2      34        1        2      spare   /dev/hdg1
>            UUID : f3be955c:8902d2ea:fb455a5e:8ea38b70
>          Events : 0.24
> 
> It didn't really shout out to me that the spare drive was being used to
> restore.. 

Good point.  I will try to put is something like "spare-rebuilding",
though it is not actually possible to tell form user-space which
spare is being rebuilt.

> I did in panic go to the FAQ and follow their advice of
> "raidhotadd /dev/mdX /dev/sdX" but this failed as it was already in use as
> spare..
> 
> So could someone point out what to do when my harddrive really does fail...
> take out the faulty one.. put a new one in, partition it.. and then add it
> with
> 
> mdadm -a /dev/md0 /dev/<harddisk>
> 
> this will add it with spare and is equivelant to raidhotadd so will start
> syncing the drive in!?

Yes, this is completely correct.

NeilBrown
