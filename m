From: Doug Ledford <dledford@redhat.com>
Subject: Re: multipath md devices
Date: Fri, 24 Sep 2004 12:41:12 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1096044072.4196.1671.camel@compaq.xsintricity.com>
References: <4151E37B.8040207@bms.com>
	 <1095888922.4196.1548.camel@compaq.xsintricity.com>
	 <20040923054607.GB27855@percy.comedia.it>
	 <16723.29710.953435.739461@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16723.29710.953435.739461@cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Luca Berra <bluca@comedia.it>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 2004-09-23 at 21:10, Neil Brown wrote:
> On Thursday September 23, bluca@comedia.it wrote:
> > On Wed, Sep 22, 2004 at 05:35:23PM -0400, Doug Ledford wrote:
> > >Yeah, IBM wrote a little app to help with that.  We stuffed it into the
> > >mdadm package we ship since that seemed the most appropriate place for
> > >it.  It's called mdmpd and that's it's job basically.  Very simple app,
> > >but doesn't run on upstream kernels at the moment (it wants the md event
> > >interface which hasn't yet been submitted upstream by Neil).
> > 
> > iirc the it has been submitted and refused
> > http://marc.theaimsgroup.com/?t=109417961300007&r=1&w=2&n=8
> > 
> 
> Well..... it's still alive in -mm, and where there's life, there's
> hope (and need of vitals, as the old Gaffer usually added:-).

I didn't know that.  You know, I resubbed to linux-kernel about 2 days
after this conversation ended, so I read the archives yesterday and
wanted to write some responses to what was in there today.  Now, whether
I'll have the time to get to it today or not is one thing, but I am
planning on responding and it's nice to know that it's not *totally*
dead already.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc.
         1801 Varsity Dr.
         Raleigh, NC 27606


