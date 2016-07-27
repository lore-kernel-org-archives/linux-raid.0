From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: RAID5 Performance
Date: Wed, 27 Jul 2016 11:15:49 +0800
Message-ID: <333e6601-d5f0-cd9a-10de-08fa06373c24@fnarfbargle.com>
References: <7b7d730f-2951-ba5f-7f6b-33624b59a02d@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7b7d730f-2951-ba5f-7f6b-33624b59a02d@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 27/07/16 10:24, Adam Goryachev wrote:
> Hi all,
>
> I know, age old question, but I have the chance to change things up a
> bit, and I wanted to collect some thoughts/ideas.
>
> Currently I am using 8 x 480GB Intel SSD in a RAID5, then LVM on top,
> DRBD on top, and finally iSCSI on top (and then used as VM raw disks for
> mostly windows VM's).


Wow. More layers than a wedding cake.

>
> My suspicion is that the actual load is made up of rather small random
> read/write, because that is the scenario that produced the worst
> performance results when I was initially setting this up, and seems to
> be what we are getting in practice.
>
> The last option is, what if I moved to RAID10? Would that provide a
> significant performance boost (completely removes the need to worry
> about chunk/stripe size because we always just write the exact data we
> want, no need to read/compute/write)?
> OR, is that read/compute overhead negligible since I'm using SSD and
> read performance is so quick?

I'll only comment from personal experience with anecdotal evidence.

I have a RAID10 comprised of 6 256GB SSD (3 Intel & 3 Samsung) used as 
the backing for multiple VMs (raw files on Ext4).

Initially I played with a number of RAID types when setting up the array 
(back in 2012) and found RAID10 offered the best compromise for my use 
case. This was based on CPU usage (raid 5 & 6 parity calculations on 
*every write*), the need for RMW cycles for small writes and trying to 
balance block sizes. None of these things are an issue with RAID10 and 
in general I found a measurable reduction in overhead and consequential 
performance boost in the VM's.

This is a single machine with a relatively underpowered AMD FX-8350 CPU. 
I found that with multiple VM's hitting the disks I was losing enough 
CPU time to RAID overhead that it made things noticeably less responsive.

My only issue is half the disks return a deterministic value after 
discard and the other half don't, so any raid check operations return a 
gazillion mismatches. Not an operational issue, but one worth mentioning 
if you were to use different model drives.

Regards,
Brad
