From: Neil Brown <neilb@suse.de>
Subject: Re: Linux Software RAID a bit of a weakness?
Date: Sat, 24 Feb 2007 07:25:26 +1100
Message-ID: <17887.19894.548422.683023@notabene.brown>
References: <1172258378.21648.51.camel@cowie>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Colin Simpson on Friday February 23
Sender: linux-raid-owner@vger.kernel.org
To: Colin Simpson <csimpson@csl.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday February 23, csimpson@csl.co.uk wrote:
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

Certainly can be unfortunate.

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

As has been mentioned, this can be done with md/raid too.  Some
distros (debian/testing at least) schedule a 'check' of all arrays
once a month.

> On Software RAID, I was thinking apart from a three way mirror, which I
> don't think is at present supported. Is there any merit in say, cat'ing
> the whole disk devices to /dev/null every so often to check that the
> whole surface is readable (I presume just reading the raw device won't
> upset thing, don't worry I don't plan on trying it on a production
> system). 

Three-way mirroring has always been supported.  You can do N way
mirroring if you have N drives.

Reading the whole device would not be sufficient as it would only read
one copy of every block rather than all copies.
The 'check' process reads all copies and compares them with one
another,  If there is a difference it is reported.  If you use
'repair' instead of 'check', the difference is arbitrarily corrected.
If a read error is detected during the 'check', md/raid1 will attempt
to write the data from the good drive to the bad drive, then read it
back.  If this works, the drive is assumed to be fixed.  If not, the
bad drive is failed out of the array.

NeilBrown
