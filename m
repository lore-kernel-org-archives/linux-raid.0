From: AndyLiebman@aol.com
Subject: Re: Stupid Question?
Date: Mon, 24 May 2004 05:33:57 EDT
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <77.2a3e6256.2de31b85@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: jim@rubylane.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


>You always need to make partitions
>with fdisk before initializing the partition with a filesystem using
>mkfs.

After creating a Hardware RAID-5 with a 3ware 8506 card -- which comes up as 
/dev/sda on my machine (my system drive is a single IDE drive, /dev/hda) -- I 
have found that I AM able to put my filesystem on the RAID without making a 
partition. 

I ask this question because I have seen some discussions about some issues 
with "blockdev" and "block sizes" and how maybe you can get better throughput on 
devices if they are "higher" up the chain. I.E., /dev/sda is higher than 
/dev/sda1 and /dev/sda2. 

I didn't see any problems "formating" or "putting a file system" on a whole 
block device like /dev/sda. I ran Bonnie++ on it without issue. (I got the same 
results as with /dev/sda1 -- but I'm now looking into what I've been reading 
about blockdev and doing some tuning). But maybe I'm missing some. I'm NOT 
booting from the RAID. It's just for data storage. 

By the way, for those with 3ware 8506 cards, at the suggestion of 3ware I 
tuned the readahead value on my RAID with 'blockdev --setra 16384 /dev/sdX' 
(actually they had recommended this for their forthcoming 9500 series) and my read 
results with Bonnie++ jumped from 100 to 200 MB/sec on a 8-drive SATA RAID-5 
array. I don't yet know how the tuning will affect real world results. 

Might similar tuning make any difference for Software RAID-5 (I already get 
175 MB/sec using the same 3ware card in its JBOD mode). 

Andy Liebman
