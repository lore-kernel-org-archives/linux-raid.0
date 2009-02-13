From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [PATCH 00/18] Assorted md patches headed for 2.6.30
Date: Fri, 13 Feb 2009 11:54:06 -0500
Message-ID: <4995A5AE.8020301@tmr.com>
References: <20090212031009.23983.14496.stgit@notabene.brown> <20090212081148.GD9439@rap.rap.dk> <4993E82D.1020309@fairbairn-family.com> <20090212094604.GA11981@rap.rap.dk> <alpine.LRH.2.00.0902120003100.3470@taurus.cesta.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.00.0902120003100.3470@taurus.cesta.com>
Sender: linux-raid-owner@vger.kernel.org
To: Julian Cowley <julian@lava.net>
Cc: =?ISO-8859-15?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>, linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Julian Cowley wrote:
> That would be a mistake, too.  It's not tied to RAID 1+0, but it's not 
> tied down to RAID 1 either, and its name should reflect that.  I'd 
> prefer something like raid1+0E, raid0E, raid1+1, or even just raid11.  
> The latter term is not used anywhere I know of, so it stands out.
>
Storage Computer (NH) has a trademark on one of the raid levels, from 
memory raid7.  Raid5E is used to denote a raid5 with distributed spare 
(something I would love to see in md).

> The horse has already probably left the barn on this one, though.
>
And in this case locking the bard door after the horse has left is 
probably a path of least confusion.

> Perhaps instead the documentation in mdadm(8) and md(4) could be 
> updated to mention that raid10 is a combination of the concepts in 
> RAID 1 and RAID 0, but is generalized enough so that it can be done 
> with just two drives at a minimum.  That would have caught my eye, at 
> least.

Good idea.

Ob. plug for raid5E: the advantages of raid5E are two-fold. The most 
obvious is that head motion is spread over N+2 drives (N being number of 
data drives) which improves performance quite a bit in the common small 
business case of 4-5 drive setups. It also puts some use on each drive, 
so you don't suddenly start using a drive which may have been spun down 
for a month, may have developed issues since SMART was last run, etc.

While the distributed spare idea could be extended to raid6 and raid10, 
the mapping gets complex. Since Neil is currently adding code to allow 
for orders other than sequential in raid6, being able to quickly deploy 
the spare on a once-per-stripe basis might at least get him to rethink 
the concept.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


