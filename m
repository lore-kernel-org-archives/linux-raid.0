From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: skip raid5 reconstruction
Date: Fri, 08 Jul 2005 15:25:26 -0400
Message-ID: <1120850726.26926.2.camel@localhost.localdomain>
References: <1120584167.5535.56.camel@localhost.localdomain>
	 <42CB7E65.5010204@wasp.net.au>
	 <1120825366.5461.14.camel@localhost.localdomain>
	 <42CEC269.6010205@wasp.net.au>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42CEC269.6010205@wasp.net.au>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <brad@wasp.net.au>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, 2005-07-08 at 22:14 +0400, Brad Campbell wrote:
> Ming Zhang wrote:
> 
> >>I did a similar thing a while back.
> >>I created the raid and waited for it to sync, I then make dd copies of the raid superblocks.
> >>When I blew it up I just dd the clean superblocks back again (saved a 12 hour rebuild time)
> > 
> > interesting to know about this. u just check the dmesg and see where is
> > the sb and then u dd it out and dd back later?
> 
> Actually, I used blockdev to get the device size and then just copied the last 64kb from memory.. 
> It's a bit hazy now but that's pretty close I think
> 
:P that is a good method!

thx

ming

> Regards
> Brad

