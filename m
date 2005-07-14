From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: RAID-5 streaming read performance
Date: Thu, 14 Jul 2005 14:00:02 -0400
Message-ID: <1121364003.5544.80.camel@localhost.localdomain>
References: <874qb14btr.fsf@uwo.ca>
	 <1121220487.5552.34.camel@localhost.localdomain> <87mzorfmdx.fsf@uwo.ca>
	 <1121257494.5504.4.camel@localhost.localdomain> <87eka2g9dp.fsf@uwo.ca>
	 <1121259126.5504.14.camel@localhost.localdomain> <87vf3eeqe2.fsf@uwo.ca>
	 <42D5573A.6090801@dgreaves.com> <87r7e23uo5.fsf@uwo.ca>
	 <1121344255.5544.7.camel@localhost.localdomain>   <87br55xogl.fsf@uwo.ca>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87br55xogl.fsf@uwo.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Christensen <jdc@uwo.ca>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 2005-07-14 at 13:54 -0400, Dan Christensen wrote:
> Ming Zhang <mingz@ele.uri.edu> writes:
> 
> > On Wed, 2005-07-13 at 23:58 -0400, Dan Christensen wrote:
> >
> >> But I still don't understand why the md layer can't do better.  If I
> >> turn off readahead of the raw devices, and keep it for the raid
> >> device, then parity blocks should never be requested, so they
> >> shouldn't use any bus/controller bandwidth.  And even if each drive is
> >> only acting at 75% efficiency, the four drives should still be able to
> >> saturate the bus/controller.  So I can't figure out what's going on
> >> here.
> > 
> > when read, i do not think MD will read parity at all. but since parity
> > is on all disk, there might be a seek here.
> 
> Yes, there will be a seek, or internal drive readahead, so each drive
> will operate at around 75% efficiency.  But since that shouldn't
> affect bus/controller traffic, I still would expect to get over
> 100MB/s with my hardware.
agree. but what if your controller is a bottleneck? u need to have
another card to find out.



> 
> >> Also, is there a way to disable caching of reads?
> > 
> > after you run your code, check the meminfo, the cached value might be
> > much lower than u expected. my feeling is that linux page cache will
> > discard all cache if last file handle closed.
> 
> Ming Zhang <mingz@ele.uri.edu> writes:
> 
> > my problem here. this only apply to sdX not mdX. pls ignore this.
> 
> I'm not sure what you mean.  For reads from sdX, mdX, files on sdX
> or files on mdX, the cache is retained.  So it's necessary to clear
> this cache to get valid timing results.

yes, i was insane at that time, pls ignore these blah blah.


> 
> Dan
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

