From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Unsure of changes to array
Date: Wed, 17 Oct 2007 16:50:03 -0400
Message-ID: <4716757B.9030609@tmr.com>
References: <47161684.7010604@bristol.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47161684.7010604@bristol.ac.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Gazeley <jonathan.gazeley@bristol.ac.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jonathan Gazeley wrote:
> Dear all,
>
> This is hopefully a simple question for you to answer, but I am fairly 
> new to RAID and don't want to risk losing my data!
>
> My setup is as follows:
> - I have four 500GB disks. Each disk is split into a 5GB partition, 
> and a 495GB partition.
> - The four 5GB partitions are in a RAID-5 array, md0. CentOS is 
> installed on this 15GB partition.
> - The four 495GB partiions are in a RAID-5 array, md1. This partition 
> holds my user data.
>
> However, I have decided I no longer wish to two arrays across the 
> disks. I've added a fifth disk on which I have installed the OS 
> without RAID, meaning the old md0 is currently unused. Can I simply 
> remove the four 5GB partitions, and resize the four 495GB partitions 
> to fill the entire disk? Will this break anything?

Not unless you make a mistake in typing, or your hardware or power fails 
during the process. Of course in that case you will possibly lose 
everything.
>
> Before anybody tells me off for having the OS on a non-RAID disk, this 
> is a home server and therefore high availability is not an issue. But 
> keeping my data safe against disk failures is important to me.

Having your o/s and swap on RAID reduces your chances of losing your 
data. If it were me and reliability were the goal, I would have the o/s 
mirrored on the first two drives (as seen by the BIOS) so you boot if 
one fails hard, then put swap RAID-10 in the little 5GB partition on the 
other three drives, then convert the raid-5 to raid-6 using the rest of 
the added fifth drive.

Anything which reduces the chances of an unclean shutdown improves the 
chances of keeping your data. A decent UPS is a big help in that regard. 
Disk failures on the data drives are not the only threat to your data!

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

