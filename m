From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Growing RAID5 SSD Array
Date: Thu, 13 Mar 2014 06:58:04 -0500
Message-ID: <53219D4C.2020207@hardwarefreak.com>
References: <53211C9D.8050607@websitemanagers.com.au>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53211C9D.8050607@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 3/12/2014 9:49 PM, Adam Goryachev wrote:
...
>     Number   Major   Minor   RaidDevice State
>        7       8       33        0      active sync   /dev/sdc1
>        6       8        1        1      active sync   /dev/sda1
>        8       8       49        2      active sync   /dev/sdd1
>        5       8       81        3      active sync   /dev/sdf1
>        9       8       65        4      active sync   /dev/sde1
...
> /dev/sda	Total_LBAs_Written	845235
> /dev/sdc	Total_LBAs_Written      851335
> /dev/sdd	Total_LBAs_Written      804564
> /dev/sde	Total_LBAs_Written	719767
> /dev/sdf	Total_LBAs_Written      719982
...
> So the drive with the highest writes 851335 and the drive with the
> lowest writes 719982 show a big difference. Perhaps I have a problem
> with the setup/config of my array, or similar?

This is normal for striped arrays.  If we reorder your write statistics
table to reflect array device order, we can clearly see the effect of
partial stripe writes.  These are new file allocations, appends, etc
that are smaller than stripe width.  Totally normal.  To get these close
to equal you'd need a chunk size of 16K or smaller.

> /dev/sdc	Total_LBAs_Written      851335
> /dev/sda	Total_LBAs_Written	845235
> /dev/sdd	Total_LBAs_Written      804564
> /dev/sde	Total_LBAs_Written	719767
> /dev/sdf	Total_LBAs_Written      719982

> So, I could simply do the following:
> mdadm --manage /dev/md1 --add /dev/sdb1
> mdadm --grow /dev/md1 --raid-devices=6
> 
> Probably also need to remove the bitmap and re-add the bitmap.

Might want to do

~$ echo 250000 > /proc/sys/dev/raid/speed_limit_min
~$ echo 500000 > /proc/sys/dev/raid/speed_limit_min

That'll bump min resync to 250 MB/s per drive, max 500 MB/s.  IIRC the
defaults are 1 MB/s and 100 MB/s.

> Can anyone suggest if what I am seeing is "normal", and should I just go
> ahead and add the extra disk?

Don't see why not.  You might want to stop drbd first.

-- 
Stan

