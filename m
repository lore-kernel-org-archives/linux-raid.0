From: jim@rubylane.com
Subject: Re: Stupid Question?
Date: Sun, 23 May 2004 19:01:56 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040524020156.31599.qmail@paris.rubylane.com>
References: <134.2f7071f3.2de27730@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <134.2f7071f3.2de27730@aol.com> from "AndyLiebman@aol.com" at May 23, 2004 05:52:48 PM
To: AndyLiebman@aol.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> 
> Hi, 
> 
> I feel like this is a stupid question. But I actually don't know the answer 
> to it. If I'm going to make a Software RAID array with a bunch of identical 
> disks, do the disks have to have at least one partition on them? Or can I use 
> disks with NO partitions? 

Yes, the disks have to have partitions.  When you specify "make a raid
out of X, Y, Z", the X, Y, and Z are partition names, like /dev/hda1,
/dev/hdb1.  You can't make a raid out of /dev/hda and /dev/hdb - whole
devices.

> 
> Similarly, if I have made a hardware RAID array (say, with a 3ware 8506 
> card), do I have to create at least a single partition on it before I put a file 
> system on it? 

Hardware raid is usually device oriented, so you do say "make a raid
pair out of drive 0 and drive 1, equivalent to /dev/hda and /dev/hdb 
for example.  This drive pair is then presented to Linux as a single
hardware devices, like /dev/hdi.  You always need to make partitions
with fdisk before initializing the partition with a filesystem using
mkfs.

> If partitions aren't necessary, is there any advantage or disadvantage to 
> having a single partition on a disk versus having none? Is having no partitions 
> faster? 
> 
> Andy Liebman
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

