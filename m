From: Iustin Pop <iusty@k1024.org>
Subject: Re: raid1 does not seem faster
Date: Thu, 5 Apr 2007 17:38:07 +0200
Message-ID: <20070405153807.GB12661@teal.hq.k1024.org>
References: <Pine.LNX.4.61.0704011417470.8018@yvahk01.tjqt.qr> <200704011558.31670.a1426z@gawab.com> <46118473.10205@tmr.com> <200704031642.27701.a1426z@gawab.com> <461430B6.9060703@tmr.com> <20070405045819.GA5525@teal.hq.k1024.org> <4614FD90.2050205@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4614FD90.2050205@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Al Boldi <a1426z@gawab.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Apr 05, 2007 at 09:45:52AM -0400, Bill Davidsen wrote:
> Iustin Pop wrote:
> >On Wed, Apr 04, 2007 at 07:11:50PM -0400, Bill Davidsen wrote:
> >  
> >>You are correct, but I think if an optimization were to be done, some 
> >>balance between the read time, seek time, and read size could be done. 
> >>Using more than one drive only makes sense when the read transfer time is 
> >>significantly longer than the seek time. With an aggressive readahead set 
> >>for the array that would happen regularly.
> >>
> >>It's possible, it just takes the time to do it, like many other "nice" 
> >>things.
> >>    
> >
> >Maybe yes, but why optimise the single-reader case? raid1 already can
> >read in parallel from the drives when multiple processes read from the
> >raid1. Optimising the single reader can help in hdparm or other
> >benchmark cases, but in real life I see very often the total throughput
> >of a (two drive) raid1 being around two times the throughput of a single
> >drive.
> 
> Why optimize the single thread case? Any process which has low CPU 
> requirements (by current standards) becomes i/o bound. The obvious 
> candidates are grep, sed, dd, or awk. And don't overlook the benefits of 
> reliable swap.

"Premature optimisation is the root of all evil". Of course it's
possible to do it. But is it worth it? In terms of code complexity, of
possible bugs, etc. And what do you gain? raid0 performance and
mirroring? it's already available in raid10.

Reliable swap? Yes, I do that over raid1. But if raid raw I/O speed is
the bottleneck, the solution is add more ram instead of optimising
raid1.

And honestly, I like the raid1 code to be as simple as possible. If you
really find grep, sed, dd to be a bottleneck, you need to think if the
tools you are using are the right tools. As I said, raid1 shows good
read speed if using *more that one process doing I/O at a time*. Two
dd's in parallel are using two drives.

Iustin
