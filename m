From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID6 Reshape Gone Awry
Date: Fri, 03 Aug 2012 06:18:12 -0500
Message-ID: <501BB374.9020607@hardwarefreak.com>
References: <8C493F417CC49C6619BBAF45@ryoohko.kodachi.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8C493F417CC49C6619BBAF45@ryoohko.kodachi.com>
Sender: linux-raid-owner@vger.kernel.org
To: Flynn <flynn@kodachi.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 8/3/2012 12:27 AM, Flynn wrote:

> My RAID6 is actually a little bit odd in that the drives are split into
> 10 partitions.  All the partition 5's are a RAID6; all the partition 6's
> are a RAID6; etc.

md offered the ability, so you _could_ create such a monstrosity.  But
you never bothered to consider if you _should_

The primary function of RAID is to protect your data in the event of a
_disk_ failure.  Creating multiple arrays from _partitions_ on the same
set of physical disks does nothing to protect one from disk failure.

What it can do is cause massive problems for the elevator when you try
to reshape 10 arrays simultaneously, which just happen to reside on the
same set of disks.  By doing this you force the heads on the drives into
a massive random seek pattern, bumping all over the platters, top to
bottom.  This is likely what caused, or is directly related to, your crash.

> Suggestions very welcome.

Backup what you need to external storage.  Blow the entire mess away.
Start over from scratch, and build a single RAID6 array, as you should
have in the first place.

md allows the use of partitions, but not so you can create 50 arrays on
the same set of disks, shooting yourself in the foot.  Similarly, most
cars can travel at velocities over 120 mph, but most people have enough
sense not to attempt driving that fast.

Learn the difference between "Can I?" and "Should I?".  You never
bothered to consider the latter when you built this.  Please consider it
now, for your sake.

-- 
Stan

