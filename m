From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: raid10,f2 degraded read speed
Date: Thu, 26 Jun 2008 10:17:02 +0200
Message-ID: <20080626081701.GE23500@rap.rap.dk>
References: <20080617143745.GA9148@rap.rap.dk> <20080625172516.GA21707@rap.rap.dk> <cccedfc60806251031q536dd88bg3cbeae703558318b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cccedfc60806251031q536dd88bg3cbeae703558318b@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson@jamponi.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jun 25, 2008 at 12:31:25PM -0500, Jon Nelson wrote:
> Yep that's me.

Good! I added your name in the wiki.

> > I found the link:
> > http://pycurious.blogspot.com/2007/12/some-raid10-performance-numbers.html
> >
> > Is this Jon Nelson writing this?
> >
> > I added the link + some benchmark from Bill Davidsen to the wiki pages
> > on performance.
> 
> Neat! I'll probably be going through a rather more extensive set of tests soon.
> The problem for me is that I have to test on a deployed system.
> The load is insanely low, but I can't exactly try "now do it without
> the LVM layer.".

I think we should actually have more figures from systems in production. 
The problem is of cause then what is measured. But is sometimes gives a
much better idea of what can be achieved. For example I have a Linux
mirror site with a raid10,f2 array of 4 1 TB disks, and I have maybe 100
concurrent proftpd processes. The fs produces something like 30 MB/s -
but that is not peak performance. I can then cat an ISO file with
about 60 - 100 MB/s - that is not bad. But the system then only delivers 
something like 90 - 130 MB/s where peak seq reading is 320 MB/s in idle
mode. Hmm, I think I normally get something like 200 MB/s for the
sequential read of one file, while there is some other activity, and I
am running a number of heavier administrative tasks right now...

But the point is: how do we measure production performance?
My best guess is that we can only give anedotical evidence, and report
of the admins feel of the system. 



Nice to have more benchmarks. Maybe you can write up something for the
wiki? 

For the wiki I tend to just make links to the articles with performance results,
instead of integrating them in the wiki. And that probably does not make 
due description as all the data on the test sometimes is not readily
referenced in the link.

Anyway what we should do for the wiki is kind of a canonical benchmark
results, so that it is easy to read and not repeated a lot of times, at
least on the main performance page. I think it is fine to have more
tests, maybe on subpages. And then I fear that some of the links will go
away, I would rather have the info incorporated into the wiki.

And to stand the teeth of time, I would like to have performance
expressed in terms of relative performance of raw read speed for one
disk, this figure is most likely very stable even over a 10 years'
timespan.

Best regards
keld
