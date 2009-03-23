From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: How to configure 36 disks ?
Date: Mon, 23 Mar 2009 11:35:08 -0400
Message-ID: <49C7AC2C.9090307@tmr.com>
References: <5d96567b0903230659t734677a3pb4fd77cccb54008b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5d96567b0903230659t734677a3pb4fd77cccb54008b@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Raz <raziebe@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, Linux RAID Mailing List <linux-raid@vger.kernel.org>, linux-xfs@oss.sgi.com, linux-aio@kvack.org, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
List-Id: linux-raid.ids

Raz wrote:
> Hello
> I need to configure 3xDAS'es, each with 12 disks.
> All three DAS'es are connected to a single machine.
> I have the following requirements (in this order of importance)
> from the storage:
>
> 1. redundancy.
>    having two disks failing in one raid5 breaks the entire raid. when
> you have 30TB storage
>    it is a disaster.
>
> 2. performance.
>    My code eliminates Linux raid5/6 write penalty. I managed to do by
>    manipulating xfs and patching linux raid5 a bit.
>
> 3. modularity ( a "grow" and it will be nice to have "shrink" )
>    file system and volume must be able to grow. shrinking is possible
> by unifying multiple file systems
>    under unionfs or aufs.
>
> 4. Utilize storage size.
>
> I assume each disk is 1TB.
>
>   
___ snip ___

> Any other ideas ?

Yes, you have the whole solution rotated 90 degrees. Consider your 
original solution #2 below... You have no redundancy if one whole DAS 
box fails, which is certainly a possible failure mode. If you put the 
RAID0 horizontally, two arrays size six in each DAS, then RAID6 
vertically, if one DAS fails completely you still have a functioning 
system, and the failure results for individual drives remains about the 
same, while the rebuild time will be longer.

Solution #2
			     raid0
 DAS1: raid6: D,D,D,D,D,D     |
       raid6: D,D,D,D,D,D     |
   			      |
 DAS2: raid6: D,D,D,D,D,D     | xfs.
       raid6: D,D,D,D,D,D     |
                              |
 DAS3: raid6: D,D,D,D,D,D     |
       raid6: D,D,D,D,D,D     |


In addition, you can expand this configuration by adding more DAS units. 
This addresses several of your goals.

In practice, just to get faster rebuild as the array gets larger, I 
suspect you would find it was worth making the horizontal arrays RAID5 
instead of RAID0, just to minimize time to full performance.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc

"You are disgraced professional losers. And by the way, give us our money back."
    - Representative Earl Pomeroy,  Democrat of North Dakota
on the A.I.G. executives who were paid bonuses  after a federal bailout.


