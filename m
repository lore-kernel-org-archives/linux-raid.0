From: Neil Brown <neilb@suse.de>
Subject: Re: trying to "brute-force" my RAID 5...
Date: Tue, 18 Jul 2006 11:39:39 +1000
Message-ID: <17596.15323.451555.218541@cse.unsw.edu.au>
References: <44BAB76D.9070809@start.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Sevrin Robstad on Monday July 17
Sender: linux-raid-owner@vger.kernel.org
To: Sevrin Robstad <quackyo@start.no>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday July 17, quackyo@start.no wrote:
> I have written some posts about this before... My 6 disk RAID 5 broke 
> down because of hardware failure. When I tried to get it up'n'running again
> I did a --create without any missing disk, which made it rebuild. I have 
> also lost all information about how the old RAID was set up..
> 
> I got a friend of mine to make a list of all the 6^6 combinations of dev 
> 1 2 3 4 5 missing, and set it up this way :
> 
> "mdadm --create -n 6 -l 5  dev1 2 3 4 5 missing ; fdisk -l /dev/md0 ; 
> mdadm --stop /dev/md0" .
> But a "cat logfile | grep Linux" of the output of this script tells me 
> that on no of these combination does it find a valid "type 83" partition.
> 
> shouldn't this work ???

No.

What are you expecting fdisk to tell you?  fdisk lists partitions and
I suspect you didn't have any partitions on /dev/md0
More likely you want something like
   fsck -n -f /dev/md0

and see which one produces the least noise.

NeilBrown
