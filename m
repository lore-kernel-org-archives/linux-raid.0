From: Dave Chinner <david@fromorbit.com>
Subject: Re: very slow file deletion on an SSD
Date: Sun, 27 May 2012 10:07:01 +1000
Message-ID: <20120527000701.GS25351@dastard>
References: <4FBF60D1.80104@gmail.com>
 <20120526231838.GR25351@dastard>
 <4FC16683.9060800@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4FC16683.9060800@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Landman <joe.landman@gmail.com>
Cc: xfs@oss.sgi.com, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, May 26, 2012 at 07:25:55PM -0400, Joe Landman wrote:
> [root@siFlash test]# ls -alF  | wc -l
> 59
> [root@siFlash test]# /usr/bin/time rm -f *
> ^C0.00user 8.46system 0:09.55elapsed 88%CPU (0avgtext+0avgdata
> 2384maxresident)k
> 25352inputs+0outputs (0major+179minor)pagefaults 0swaps

It's burning an awful lot of CPU time during this remove.

> [root@siFlash test]# ls -alF  | wc -l
> 48

So, 48 files were removed, it was basically CPU bound and one took
2.6 seconds.

So, how big are the files, and does the one that took 2.6s have tens
of thousands of extents ('xfs_bmap -vp *' will dump the extent maps
for all the files)?

if not, can you use perf top to get an ida of the CPU usage profile
duing the rm by doing:

# perf record rm -f *
.....

and capturing the profile via:

# perf report > profile.txt

And attaching te profile.txt file so we can see where all the CPU
time is being spent? You can find perf in your kernel source tree
under the tools subdir....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
