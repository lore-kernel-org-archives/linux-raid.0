From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: RAID-5 streaming read performance
Date: Thu, 14 Jul 2005 10:23:37 -0400
Message-ID: <1121351017.5544.29.camel@localhost.localdomain>
References: <874qb14btr.fsf@uwo.ca>
	 <1121220487.5552.34.camel@localhost.localdomain> <87mzorfmdx.fsf@uwo.ca>
	 <1121257494.5504.4.camel@localhost.localdomain> <87eka2g9dp.fsf@uwo.ca>
	 <1121259126.5504.14.camel@localhost.localdomain> <87vf3eeqe2.fsf@uwo.ca>
	 <42D5573A.6090801@dgreaves.com>  <87r7e23uo5.fsf@uwo.ca>
	 <1121344255.5544.7.camel@localhost.localdomain>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1121344255.5544.7.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Christensen <jdc@uwo.ca>
Cc: David Greaves <david@dgreaves.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

my problem here. this only apply to sdX not mdX. pls ignore this.

ming

On Thu, 2005-07-14 at 08:30 -0400, Ming Zhang wrote:
> > Also, is there a way to disable caching of reads?  Having to clear
> > the cache by reading 900M each time slows down testing.  I guess
> > I could reboot with mem=100M, but it'd be nice to disable/enable
> > caching on the fly.  Hmm, maybe I can just run something like
> > memtest which locks a bunch of ram...
> after you run your code, check the meminfo, the cached value might be
> much lower than u expected. my feeling is that linux page cache will
> discard all cache if last file handle closed.
> 

