From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Raid-6 hang on write.
Date: Tue, 1 Mar 2005 20:18:03 +1100
Message-ID: <16932.13131.973765.36917@cse.unsw.edu.au>
References: <421DE9A9.4090902@wasp.net.au>
	<421F4629.5080309@wasp.net.au>
	<16930.45319.682534.351648@cse.unsw.edu.au>
	<422412AB.8080907@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
In-Reply-To: message from Brad Campbell on Tuesday March 1
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <brad@wasp.net.au>
Cc: lkml <linux-kernel@vger.kernel.org>, RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tuesday March 1, brad@wasp.net.au wrote:
> Neil Brown wrote:
> > 
> > Could you please confirm if there is a problem with
> >     2.6.11-rc4-bk4->bk10
> > 
> > as reported, and whether it seems to be the same problem.
> 
> Ok.. are we all ready? I had applied your development patches to all my vanilla 2.6.11-rc4-* 
> kernels. Thus they all exhibited the same problem in the same way as -mm1. <Smacks forehead against 
> wall repeatedly>

Thanks for following through with this so we know exactly where the
problem is ... and isn't.  And admitting your careless mistake in
public is a great example to all the rest of us who are too shy to do
so - thanks :-)

> 
> Oh well, at least we now know about a bug in the -mm patches.
> 

Yes, and very helpful to know it is.  Thanks again.

NeilBrown
