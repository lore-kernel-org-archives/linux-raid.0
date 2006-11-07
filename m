From: Neil Brown <neilb@suse.de>
Subject: Re: Checksums wrong on one disk of mirror
Date: Tue, 7 Nov 2006 21:26:34 +1100
Message-ID: <17744.24410.177826.644308@cse.unsw.edu.au>
References: <20061107100456.v64wcs1zi80kcccc@my.pengus.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from David on Tuesday November 7
Sender: linux-raid-owner@vger.kernel.org
To: David <lists@edeca.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday November 7, lists@edeca.net wrote:
> I recently installed a server with mirrored disks using software RAID.  
> Everything was working fine for a few days until a normal reboot (not  
> the first).  Now the machine will not boot because it appears the  
> superblock is wrong on some of the RAID devices on the first disk.
> 
> The rough layout of the disks (sda and sdb):
> 
>   sdx1 (md0) - /
>   sdx2 (md1) - /var
>   sdx3 (md2) - /usr
>   extended partition with swap
>   sdx6 (md3) - /opt
> 
> The exact error is:
> 
>   "invalid superblock checksum on sda3
>   sda3 has invalid sb, not importing!"
> 
> Booting into a live CD, mdadm -E /dev/sdaX shows that the checksum is  
> not what would be expected for sda1,2,3 but is fine for sda6. All of  
> the checksums on drive sdb are correct.

I'm surprised it doesn't boot then.  How are the arrays being
assembled? A more complete kernel log would help.


> 
> The state is "clean" for all partitions, working 2, active 2 and  
> failed 0. The table for sdb1,2,3 shows that the first device has been  
> removed and is no longer an active mirror.
> 
> What is the best way to proceed here? Can I somehow sync from the  
> second disk, which appears to have the correct checksums? Is there an  
> easy way to fix this that wont involve loosing the data?

While booted from the live CD you should be able to
  mdadm -AR /dev/md0 /dev/sdb1
  mdadm /dev/md0 --add /dev/sda1

and repeat for 2 and 3.
That will cause a recovery of all arrays but you won't lose any data.

It is very odd that the checksums are all wrong though.  Kernel
version? mdadm version? hardware architecture?

NeilBrown
