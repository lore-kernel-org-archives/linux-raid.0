From: Gregory Leblanc <gleblanc@linuxweasel.com>
Subject: Re: RAID autorun support for SunOS disk labels
Date: 26 Apr 2002 11:34:09 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1019846049.1670.76.camel@peecee>
References: <20020426101101.GA25225@monkey.beezly.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20020426101101.GA25225@monkey.beezly.org.uk>
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, 2002-04-26 at 03:11, Andrew Beresford wrote:
> Hi all,
> 
> After many hours spend last night trying to get my root filesystem
> autorun when my kernel loads I discovered that sunos.c in fs/partitions
> has no support for adding partitions to the list of eligible RAID
> members. Before I go and fix the Solaris partition code (it can't work
> out what type a partition is at the moment) and add in the
> md_autodetect_dev() business, has anyone else already fixed this?

As far as I know nobody has mucked around with the code for autodetect
stuff on non-DOS disklabels.  Neil Brown has been advocating that people
not use the partition types, and let the userspace tools set things up. 
You can find his arguments in the archives for this list (info
linux-raid to majordomo@vger.kernel.org should get you some links to the
archives).
	Greg

-- 
Portland, Oregon, USA.

