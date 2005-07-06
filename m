From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: skip raid5 reconstruction
Date: Wed, 06 Jul 2005 11:47:31 -0400
Message-ID: <1120664851.5500.34.camel@localhost.localdomain>
References: <1120584167.5535.56.camel@localhost.localdomain>
	 <42CBFC86.4090009@tls.msk.ru>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42CBFC86.4090009@tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thanks, that is a workaround as well. :P

I already solve this by using mkraid.

Ming


On Wed, 2005-07-06 at 19:45 +0400, Michael Tokarev wrote:
> Ming Zhang wrote:
> > Hi folks
> > 
> > I am testing some HW performance with raid5 with 2.4.x kenrel.
> > 
> > It is really troublesome every time I create a raid5, wait 4 hours for
> > reconstruction, and then test some data and then recreate another one
> > and wait again. I wonder if there is any hack or option available to
> > create a raid5 without reconstruct the parity disk. I just have interest
> > to test the performance so do not care about data correctness at this
> > stage.
> 
> Maybe try smaller partitions?
> 
> /mjt

