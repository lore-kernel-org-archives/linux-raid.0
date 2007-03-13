From: Tomka Gergely <gergely@tomka.hu>
Subject: Re: sw raid0 read bottleneck
Date: Tue, 13 Mar 2007 22:09:47 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0703132204310.18749@localhost.localdomain>
References: <Pine.LNX.4.64.0703131713280.18749@localhost.localdomain>
 <Pine.LNX.4.64.0703131248260.29504@p34.internal.lan>
 <Pine.LNX.4.64.0703131815050.18749@localhost.localdomain>
 <Pine.LNX.4.64.0703131914360.18749@localhost.localdomain>
 <17911.3814.749745.77134@notabene.brown>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17911.3814.749745.77134@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 14 Mar 2007, Neil Brown wrote:

> On Tuesday March 13, gergely@tomka.hu wrote:
> > On Tue, 13 Mar 2007, Tomka Gergely wrote:
> > 
> > > On Tue, 13 Mar 2007, Justin Piszcz wrote:
> > > 
> > > > Have you tried increasing your readahead values for the md device?
> > > 
> > > Yes. No real change. According to my humble mental image, readahead not a 
> > > too useful thing, when we read 1-4 thread with sdd. The io subsystem 
> > > already reading with the possible maximum speed, so don't have time to 
> > > read ahead. Correct me, if i wrong. 
> > 
> > I was wrong, readahead can speed things up, to 450 MBps.
> 
> Can you tell use what read-ahead size you needed?
> 
> 15 drives and 64K chunks gives 960K per stripe.
> The raid0 code should set the read-ahead to twice that: 1920K
> which I would have thought would be enough, but apparently not.

blockdev --setra 262144 /dev/md0 gives me 650+ MB/s with 4 threads 
(paralell running sdd). Lower values give lower speeds, greater values not 
giving higher speeds.

-- 
Tomka Gergely, gergely@tomka.hu
