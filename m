From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Mis-matched disks RAID 1
Date: Fri, 21 Nov 2003 10:29:09 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16317.20037.232795.101990@notabene.cse.unsw.edu.au>
References: <114.2bc61a06.2cee8758@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from AndyLiebman@aol.com on Thursday November 20
To: AndyLiebman@aol.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday November 20, AndyLiebman@aol.com wrote:
> Can somebody tell me what I have to do to make a RAID 1 array with 
> mis-matched disks (1 is 200 GB, one is 160 GB)? 

"Just do it!" :-)

> 
> I am assuming I have to make 2 partitions on the 200 GB drive -- one exactly 
> the same size as the 160 GB drive, one with whatever is left. Is that true? 
> And is there an easy way to make the big partition EXACTLY the same as the size 
> of the 160 GB drive? (When I look at the 160 GB drive with fdisk, I see a size 
> that's a certain number of sectors (?)  xxxxxxxxxx+  with a plus sign at the 
> end. )

They do not have to be exactly the same size.  The size of the raid1
array will be slightly less than (to allow for metadata) the size of
the smallest drive.

So, partitions the 160GB drive as a single 160GB partition, and
partition the 200GB drive as a 160GB and a 40GB, but don't be stressed
about getting the sizes precise.
Then raid1 the two 160GB partitions together, and you get a bunus 40GB
non-RAID partition to play with.

NeilBrown
