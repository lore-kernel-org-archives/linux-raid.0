From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 09/18] md/raid6: remove expectation that Q device is	immediately
 after P device.
Date: Mon, 16 Feb 2009 16:15:08 +1100
Message-ID: <18840.63068.382477.592869@notabene.brown>
References: <20090212031009.23983.14496.stgit@notabene.brown>
	<20090212031010.23983.26264.stgit@notabene.brown>
	<4995A1D4.3020700@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Bill Davidsen on Friday February 13
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday February 13, davidsen@tmr.com wrote:
> NeilBrown wrote:
> > Code currently assumes that the devices in a raid6 stripe are
> >   0 1 ... N-1 P Q
> > in some rotated order.  We will shortly add new layouts in which
> > this strict pattern is broken.
> > So remove this expectation.  We still assume that the data disks
> > are roughly in-order.  However P and Q can be inserted anywhere within
> > that order.
> >   
> 
> Is this a change which could be done on the fly? Because if it is, 
> there's obviously a huge performance gain to be had in degraded mode.

You need to remember which stripes have been changed.

So the best you could do is start a raid6->raid5 conversion in the
event of a device failure.  That would be fairly intrusive while
running.  But when it has finished you get your performance back.

Then do a raid5->raid6 when you get a replacement drive.

I don't know that I would recommend this though.

NeilBrown

> 
> To clarify, if the order could be changed (raid5 example):
>     running array         0 1 2 3 4 P
>     failed device          0 1 F 3 4 P
> Leads to a recover of data from the failed device. But if the order 
> could be changed on the fly, then "recover" would be a one time 
> operation, recover the entire chunk previously on device 2, write to 
> device 5(P), change the order so the parity is on the failed device 
> (can't recover from another fail anyway), and:
>     remapped stripe    0 1 F 3 4 2
> 
> Now reads will not cost a recover, and writes hopefully could skip the 
> parity completely. When the failed device is replaced the rebuild could 
> restore the chunk order to improve leveling of head motion.
> 
> -- 
> Bill Davidsen <davidsen@tmr.com>
>   "Woe unto the statesman who makes war without a reason that will still
>   be valid when the war is over..." Otto von Bismark 
> 
