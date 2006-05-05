From: Neil Brown <neilb@suse.de>
Subject: Re: Two-disk RAID5?
Date: Fri, 5 May 2006 20:03:44 +1000
Message-ID: <17499.8960.267047.130383@cse.unsw.edu.au>
References: <216D6FA68B0F304DA93E95C5B786F2D12FCBBC@bart.corp.egenera.com>
	<Pine.LNX.4.61.0604261518020.1846@soloth.lewis.org>
	<20060501171128.GA18811@harddisk-recovery.com>
	<445AA801.6050404@tmr.com>
	<1146821517.4365.40.camel@kenny>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from John Rowe on Friday May 5
Sender: linux-raid-owner@vger.kernel.org
To: John Rowe <rowe@excc.ex.ac.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday May 5, rowe@excc.ex.ac.uk wrote:
> 
> > Sorry, I couldn't find a diplomatic way to say you're completely wrong.
> 
> We don't necessarily expect a diplomatic way, but a clear and
> intelligent one would be helpful. 
> 
> In two-disk RAID5 which is it?
> 
>   1) The 'parity bit' is the same as the datum.

Yes.

> 
>   2) The parity bit is the complement of the datum.

No.

> 
>   3) It doesn't work at a bit-wise level.

No.

> 
> Many of us feel that RAID5 looks like:
> 
>   parity = data[0];
>   for (i=1; i < ndisks; ++i)
>       parity ^= data[i];

Actually in linux/md/raid5 it is more like

    parity = 0
    for (i=0; i < ndisks; ++i)
	parity ^= data[i];

which has exactly the same result.
(well, it should really be ndatadisks, but I think we both knew that
was what you meant).

> 
> which implies (1). It could easily be (2) but merely saying "it's not
> data, it's parity" doesn't clarify matters a great deal. 
> 
> But I'm pleased my question has stirred up such controversy!

A bit of controversy is always a nice way to pass those long winter
nights.... only it isn't winter anywhere at the moment :-)

NeilBrown
