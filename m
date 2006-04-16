From: Neil Brown <neilb@suse.de>
Subject: Re: Raid 4/5 small writes
Date: Mon, 17 Apr 2006 08:37:52 +1000
Message-ID: <17474.51008.572228.48479@cse.unsw.edu.au>
References: <qlk3bgwt2dp.fsf@clipper.ens.fr>
	<17456.31813.855730.279982@cse.unsw.edu.au>
	<444282BB.6080407@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Bill Davidsen on Sunday April 16
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: =?ISO-8859-1?Q?Ga=EBtan_LEURENT?= <gaetan.leurent@ens.fr>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday April 16, davidsen@tmr.com wrote:
> Neil Brown wrote:
> >
> >If you are writing exactly half the data in a stripe, I think it takes
> >the first option (Read the old unchanged data) as that is fewer reads
> >than reading the old changed data and the parity block.
> >
> >Does that make sense?
> >  
> >
> You can do some simulation of this, but consid this scenario: I have a 
> write which changes five of eight data blocks of a RAID4/5. 
> 8data+1parity. If I read the old data I read blocks from three drives 
> and write to six, generating a seek+io of every drive in the array.
> 
> if I read the old data and parity only on the drives which will be 
> rewritten, I generate two seeks and two io on five data and one parity 
> drive. However... I have not generate seeks on the other three drives, 
> and the 2nd seek on each drive will either be a no-op if the data are on 
> a single cylinder, or will be small, the seek from the end of the old 
> data back to the start.
> 
> I think the better performance would depend on the size of the io and 
> seek (small, or it would write every data drive), and the load (leaving 
> three drives to do user io could be a gain). Am I missing something? I 
> don't disagree with the way it works, I'm just not sure it's optimal if 
> the write doesn't reach every drive in the array.
> 

Optimising for a single IO request is pretty pointless.  The situation
that you want to optimise for is when there are lots of IO requests
coming and queueing up and keeping the array busy.  In this case I
suspect you would want to spread load evenly over all devices, and
keep the total number of IOs to a minimum.  That is what the current
code tries to do.

Ofcourse, this is pure theory, and so could be purely wrong.  The only
way we could tell is to do some measurements on some interesting
loads.

It would be very easy to change the code to all to read-modify-write
or always do reconstruct-write, and then test performance for some
real benchmark.  I would certainly be interested if any benchmarks
were significantly affected by the choice.

So I agree with your first comment - doing some simulations is best.

NeilBrown
