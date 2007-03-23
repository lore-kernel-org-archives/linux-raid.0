From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Swap initialised as an md?
Date: Fri, 23 Mar 2007 16:22:09 -0400
Message-ID: <460436F1.2080003@tmr.com>
References: <20061110102955.ljws9mgxf4o4kgw8@my.pengus.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20061110102955.ljws9mgxf4o4kgw8@my.pengus.net>
Sender: linux-raid-owner@vger.kernel.org
To: David <lists@edeca.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David wrote:
> I have two devices mirrored which are partitioned like this:
>
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sda1   *          63    30716279    15358108+  fd  Linux raid 
> autodetect
> /dev/sda2        30716280    71682029    20482875   fd  Linux raid 
> autodetect
> /dev/sda3        71682030   112647779    20482875   fd  Linux raid 
> autodetect
> /dev/sda4       112647780   156248189    21800205    5  Extended
> /dev/sda5       112647843   122881184     5116671   82  Linux swap / 
> Solaris
> /dev/sda6       122881248   156248189    16683471   fd  Linux raid 
> autodetect
>
> My aim was to have the two swap partitions both mounted, no RAID (as I 
> didn't see any benefit to that, but if I'm wrong then I'd appreciate 
> being told!).  However it seems that sda5 seems to be recognised as an 
> md anyway at boot, so swapon does not work correctly.  When 
> initialising the partitions with mkswap, the RAID array is confused 
> and refuses to boot until the superblocks are fixed.
If you use RAID0 on an array it will be faster (usually) than just 
partitions, but any process with swapped pages will crash if you lose 
either drive. With RAID1 operation will be more reliable but no faster. 
If you use RAID10 the array will be faster and more reliable, but most 
recovery CDs don't know about RAID10 swap. Any reliable swap will also 
have the array size smaller than the sum of the partitions (you knew that).

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

