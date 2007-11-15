From: Neil Brown <neilb@suse.de>
Subject: Re: Proposal: non-striping RAID4
Date: Thu, 15 Nov 2007 17:01:02 +1100
Message-ID: <18235.57502.462218.1934@notabene.brown>
References: <ef2613f30711091657q48e57b63if47a3653a92b28a6@mail.gmail.com>
	<4737AC62.8000308@tmr.com>
	<ef2613f30711131548l2ecacd3p9994fdc6ebb6042a@mail.gmail.com>
	<ef2613f30711131706g31b7b7adm61add82fef3ff94a@mail.gmail.com>
	<473B81BE.8070309@tmr.com>
	<ef2613f30711141624v6279e79cg91afbe8ad32c7b68@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from James Lee on Thursday November 15
Sender: linux-raid-owner@vger.kernel.org
To: James Lee <james.lee@cantab.net>
Cc: Bill Davidsen <davidsen@tmr.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday November 15, james.lee@cantab.net wrote:
> 
> Neil: any comments on whether this would be desirable / useful / feasible?

1/ Have in raid4 variant which arranges the data like 'linear' is
   something I am planning to do eventually.  If your filesystem nows
   about the geometry of the array , then it can distribute the data
   across the drives and can make up for a lot of the benefits of
   striping.  The big advantage of such an arrangement is that it is
   trivial to add a drive - just zero it and make it part of the
   array.  No need to re-arrange what is currently there.
   However I was not thinking of support different sizes devices in
   such a configuration.

2/ Having an array with redundancy where drives are of different sizes
   is awkward, primarily because if there was a spare that as not as
   large as the largest device, you may-or-may not be able to rebuild
   in that situation.   Certainly I could code up those decisions, but
   I'm not sure the scenario is worth the complexity.
   If you have drives of different sizes, use raid0 to combine pairs
   of smaller one to match larger ones, and do raid5 across devices
   that look like the same size.

3/ If you really want to use exactly what you have, you can partition
   them into bits and make a variety of raid5 arrays as you suggest.
   md will notice and will resync in series so that you don't kill
   performance.

NeilBrown
