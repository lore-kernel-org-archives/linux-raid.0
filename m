From: Dave Chinner <david@fromorbit.com>
Subject: Re: Linux RAID & XFS Question - Multiple levels of concurrency =
	faster I/O on md/RAID 5?
Date: Mon, 3 Nov 2008 09:03:13 +1100
Message-ID: <20081102220313.GF19509@disturbed>
References: <alpine.DEB.1.10.0811010424270.16517@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0811010424270.16517@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org, xfs@oss.sgi.com
List-Id: linux-raid.ids

On Sat, Nov 01, 2008 at 04:29:18AM -0400, Justin Piszcz wrote:
> Overall the raw speed according to vmstat seems to increase as you add more
> load to the server.  So I decided to time running three jobs on two parts 
> of data and compare it with a single job that proceses them all.
>
> Three jobs run con-currently: (2 parts/each):
>
> 1- 59.99user 18.25system 2:02.07elapsed 64%CPU (0avgtext+0avgdata 0maxresident)k
>    0inputs+0outputs (0major+21000minor)pagefaults 0swaps
>
> 2- 59.86user 17.78system 1:59.96elapsed 64%CPU (0avgtext+0avgdata 0maxresident)k
>    0inputs+0outputs (21major+20958minor)pagefaults 0swaps
>
> 3- 74.77user 22.83system 2:13.30elapsed 73%CPU (0avgtext+0avgdata 0maxresident)k
>    0inputs+0outputs (36major+21827minor)pagefaults 0swaps
>
> One job with (6 parts):
>
> 1 188.66user 56.84system 4:38.52elapsed 88%CPU (0avgtext+0avgdata 0maxresident)k
>   0inputs+0outputs (71major+43245minor)pagefaults 0swaps
>
> Why is running 3 jobs con-currently that take care of two parts each more than
> twice as fast than running one job for six parts?

Usually this is because the workload is I/O latency sensitive and so
can't keep the disk fully busy because it is serialising on I/O.  By
running jobs concurrently you are reducing the impact of serialising
on an I/O because there are still two other concurrent jobs issuing
I/O instead of none...

> I am using XFS and md/RAID-5, the CFQ scheduler and kernel 2.6.27.4.
> Is this more of an md/raid issue ( I am guessing ) than XFS? I remember  
> reading of some RAID acceleration patches awhile back that were supposed  
> to boost performance quite a bit, what happened to them?

Without further information, I'd say a pure application issue - the
disk subsystem is clearly fast enough to handle much higher load
than the single job is capable of issuing.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
