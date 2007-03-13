From: Neil Brown <neilb@suse.de>
Subject: Re: sw raid0 read bottleneck
Date: Wed, 14 Mar 2007 07:51:50 +1100
Message-ID: <17911.3814.749745.77134@notabene.brown>
References: <Pine.LNX.4.64.0703131713280.18749@localhost.localdomain>
	<Pine.LNX.4.64.0703131248260.29504@p34.internal.lan>
	<Pine.LNX.4.64.0703131815050.18749@localhost.localdomain>
	<Pine.LNX.4.64.0703131914360.18749@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Tomka Gergely on Tuesday March 13
Sender: linux-raid-owner@vger.kernel.org
To: Tomka Gergely <gergely@tomka.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday March 13, gergely@tomka.hu wrote:
> On Tue, 13 Mar 2007, Tomka Gergely wrote:
> 
> > On Tue, 13 Mar 2007, Justin Piszcz wrote:
> > 
> > > Have you tried increasing your readahead values for the md device?
> > 
> > Yes. No real change. According to my humble mental image, readahead not a 
> > too useful thing, when we read 1-4 thread with sdd. The io subsystem 
> > already reading with the possible maximum speed, so don't have time to 
> > read ahead. Correct me, if i wrong. 
> 
> I was wrong, readahead can speed things up, to 450 MBps.

Can you tell use what read-ahead size you needed?

15 drives and 64K chunks gives 960K per stripe.
The raid0 code should set the read-ahead to twice that: 1920K
which I would have thought would be enough, but apparently not.

Thanks,
NeilBrown
