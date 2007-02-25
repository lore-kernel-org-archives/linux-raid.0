From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Linux Software RAID a bit of a weakness?
Date: Sun, 25 Feb 2007 15:08:19 -0500
Message-ID: <45E1ECB3.1060204@tmr.com>
References: <1172258378.21648.51.camel@cowie>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1172258378.21648.51.camel@cowie>
Sender: linux-raid-owner@vger.kernel.org
To: Colin Simpson <csimpson@csl.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Colin Simpson wrote:
> Hi, 
>
> We had a small server here that was configured with a RAID 1 mirror,
> using two IDE disks. 
>
> Last week one of the drives failed in this. So we replaced the drive and
> set the array to rebuild. The "good" disk then found a bad block and the
> mirror failed.
>
> Now I presume that the "good" disk must have had an underlying bad block
> in either unallocated space or a file I never access. Now as RAID works
> at the block level you only ever see this on an array rebuild when it's
> often catastrophic. Is this a bit of a flaw? 
>
> I know there is the definite probability of two drives failing within a
> short period of time. But this is a bit different as it's the
> probability of two drives failing but over a much larger time scale if
> one of the flaws is hidden in unallocated space (maybe a dirt particle
> finds it's way onto the surface or something). This would make RAID buy
> you a lot less in reliability, I'd have thought. 
>
> I seem to remember seeing in the log file for a Dell perc something
> about scavenging for bad blocks. Do hardware RAID systems have a
> mechanism that at times of low activity search the disks for bad blocks
> to help guard against this sort of failure (so a disk error is reported
> early)?
>
> On Software RAID, I was thinking apart from a three way mirror, which I
> don't think is at present supported. Is there any merit in say, cat'ing
> the whole disk devices to /dev/null every so often to check that the
> whole surface is readable (I presume just reading the raw device won't
> upset thing, don't worry I don't plan on trying it on a production
> system). 
>
> Any thoughts? As I presume people have thought of this before and I must
> be missing something.
Multi-way mirror is supported, my boot partition is striped over three 
drives.

How often were you running the "check" function on your array, and did 
anything show up in the S.M.A.R.T. background checks?

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979


