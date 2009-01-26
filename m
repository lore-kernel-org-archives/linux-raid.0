From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: Properly setting up partitions and verbose boot
Date: Mon, 26 Jan 2009 02:20:13 +0100
Message-ID: <20090126012013.GB28271@rap.rap.dk>
References: <001401c97f08$91205150$b360f3f0$@com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <001401c97f08$91205150$b360f3f0$@com>
Sender: linux-raid-owner@vger.kernel.org
To: GeneralNMX <generalmx@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Jan 25, 2009 at 11:18:31AM -0500, GeneralNMX wrote:
> 
> Currently I have a very stupid setup on my home server (not a production
> machine). I have four hard drives with three different types of RAID
> (1,5,10) on them setup through mdadm. I've been using this for a while and,
> as you can guess, I/O Wait is a big issue for me, especially when moving
> from different RAID types. I ordered four new hard drives to setup a proper
> RAID10 by itself and I'm scrapping the RAID1, instead just consolidating /
> into the RAID10. /boot gets its own tiny IDE HDD in a hotswap bay. The RAID5
> will consume the 4 old hard drives. 

Why do you think it is stupid?

I have a similar setup described in a howto at:

http://linux-raid.osdl.org/index.php/Preventing_against_a_failing_disk

How big is the iowait issue for you?

What are the performance of your raids?

> With my stupid setup, each partition gets its own /dev/mdX device. This is
> the only way I know how to do it. On the RAID10, I will need at least two
> partitions: / and swap. This means it cannot simply partition the entire
> disk Would this cause sub-optimal performance? Is there a way to make an
> underlying single RAID10 partition and place the file partitions on top?

I dont think it would be suboptimal. But try it out, both solutions and
see for yourself and report to the list your findings!).

I don't think having two raid10.f2 partitions, one for / and one for
swap, will be suboptimal, given the number of drives involved. Each 
raid will do its best for the IO, and the difference between haveing it
all on one raid, vs having it on two raids, would to be be
insignificant. Where  should the extra overhead come from? I even think
the elevator algorithm would be the same, as the elevator is per drive
(As far as I understand it).

do you think that the different raid  types make performance problems?

I think you can partition a MD device into more partitions. 
I have not tried it out for production, though and I dont know how it
performs.

I am in the process of setting up two quad-core machines with 8 GB ram 
for use as virtual servers, and intend to have rai10,f2 in the buttom of
the dom0, and then let the different virtual machines have partitions on
the raid10 array. Is this recommendable? I was thinkin of problems of
both dom0 and domu doing IO, and thus copying io buffers twice.

Best regards
keld
