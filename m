From: "David Lethe" <david@santools.com>
Subject: Re:  Re: Linux MD RAID 5 Benchmarks Across (3 to 10) 300 Gigabyte Veliciraptors
Date: Wed, 11 Jun 2008 13:42:00 -0500
Message-ID: <396301c8cbf2$ec088364$e90df40a@exchange.rackspace.com>
Reply-To: <David@santools.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Nat Makarevitch <nat@makarevitch.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

the extra spindles aren't being used because the benchmark isn't set up to perform the test on 3 different theads each of which process one third of the file concurrently at 3 different offsets where the data is distributed on 3 different platters.  This illustrates the danger of using load generating benchmarks instead of a system snapshot running your apps with your data... 

garbage in = garbage out :)
-----Original Message-----

From:  "Nat Makarevitch" <nat@makarevitch.org>
Subj:   Re: Linux MD RAID 5 Benchmarks Across (3 to 10) 300 Gigabyte Veliciraptors
Date:  Wed Jun 11, 2008 12:06 pm
Size:  1K
To:  "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>

Justin Piszcz <jpiszcz <at> lucidpixels.com> writes: 
 
> Ever wonder what kind of speed is possible with 3 disk, 4,5,6,7,8,9,10-disk 
RAID5s? 
 
> Here are the bonnie++ results: 
> 
http://home.comcast.net/~jpiszcz/20080607/raid5-benchmarks-3to10-veliciraptors/veliciraptor-raid.html 
 
Why does the amount of spindles has nearly no effect on the amount of seeks per 
second? 
 
3 disks: 713.9 seeks/s  (AFAIK the Raptor works at 10000 rpm, getting 230+ 
seeks/s is astonishing) 
 
10 disks: 705.5 seeks/s  (same as 3 disks?!) 
 
Did I miss something? Or did you use a very large stripe size (to the point of 
forbiding the 16 GB file used to span over all spindles?)? Or is it some glitch 
in the RAID code (I don't think so, on a RAID10 with 10 low-end disk I obtained 
~1000 IOPS: http://www.makarevitch.org/rant/raid/#3wmd)? 
 
-- 
To unsubscribe from this list: send the line "unsubscribe linux-raid" in 
the body of a message to majordomo@vger.kernel.org 
More majordomo info at  http://vger.kernel.org/majordomo-info.html 
 


