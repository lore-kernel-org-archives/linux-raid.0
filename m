From: Wes <wt75@gazeta.pl>
Subject: Re: raid10 centos5 vs. centos6 300% worse random write performance
Date: Thu, 25 Jul 2013 18:49:40 +0000 (UTC)
Message-ID: <loom.20130725T204640-706@post.gmane.org>
References: <loom.20130725T120703-146@post.gmane.org> <alpine.DEB.2.00.1307251338050.8891@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mikael Abrahamsson <swmike <at> swm.pp.se> writes:

> 
> On Thu, 25 Jul 2013, Wes wrote:
> 
> > Why raid10 driver from Centos 6 has a 300% slower random write performance
> > (random read stays the same) than Centos 5?
> >
> > Please share your ideas.
> 
> ... 
> Does seekmark use barriers to assure that data has actually been written? 
> In that case it could be that 2.6.18 has different behaviour from 2.6.32 
> when it comes to barriers and that explains the speed difference.
> 


I also made random write tests with raid1 and these return the same results
on centos 5 and 6 (+/- 1%)
thread 1 completed, time: 85.34, 11.72 seeks/sec, 85.3ms per request
...
93.28 total seeks per sec, 11.66 WRITE seeks per sec per thread

And raid10 random write speed on centos 5 is twice as much as above - this
is expected as there are 4 spindles.
But centos6's raid10 (4 spindles) random write speed (~120ms/req) is even
slower than 2 spindle raid1 (~80ms/req).
This experiment seems to narrow the problem down to raid10.


