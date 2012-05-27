From: joe.landman@gmail.com
Subject: Re: very slow file deletion on an SSD
Date: Sat, 26 May 2012 20:10:45 -0400
Message-ID: <B8054040-C690-463A-8CF2-B13945067683@gmail.com>
References: <4FBF60D1.80104@gmail.com> <20120526231838.GR25351@dastard> <4FC16683.9060800@gmail.com> <20120527000701.GS25351@dastard>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120527000701.GS25351@dastard>
Sender: linux-raid-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Ok.  Will do in a few hours

Sent from my iPad

On May 26, 2012, at 8:07 PM, Dave Chinner <david@fromorbit.com> wrote:

> On Sat, May 26, 2012 at 07:25:55PM -0400, Joe Landman wrote:
>> [root@siFlash test]# ls -alF  | wc -l
>> 59
>> [root@siFlash test]# /usr/bin/time rm -f *
>> ^C0.00user 8.46system 0:09.55elapsed 88%CPU (0avgtext+0avgdata
>> 2384maxresident)k
>> 25352inputs+0outputs (0major+179minor)pagefaults 0swaps
> 
> It's burning an awful lot of CPU time during this remove.
> 
>> [root@siFlash test]# ls -alF  | wc -l
>> 48
> 
> So, 48 files were removed, it was basically CPU bound and one took
> 2.6 seconds.
> 
> So, how big are the files, and does the one that took 2.6s have tens
> of thousands of extents ('xfs_bmap -vp *' will dump the extent maps
> for all the files)?
> 
> if not, can you use perf top to get an ida of the CPU usage profile
> duing the rm by doing:
> 
> # perf record rm -f *
> .....
> 
> and capturing the profile via:
> 
> # perf report > profile.txt
> 
> And attaching te profile.txt file so we can see where all the CPU
> time is being spent? You can find perf in your kernel source tree
> under the tools subdir....
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
