From: Hans Kristian Rosbach <hk@isphuset.no>
Subject: Re: RAID1 & 2.6.9 performance problem
Date: Mon, 17 Jan 2005 16:51:21 +0100
Message-ID: <1105977081.15184.12.camel@linux.local>
References: <41EBD827.80701@pipi.ma.cx>
	 <Pine.LNX.4.56.0501171528010.21510@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0501171528010.21510@lion.drogon.net>
Sender: linux-raid-owner@vger.kernel.org
To: Gordon Henderson <gordon@drogon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> As I understand it, it reads "chunksize" blocks from one drive, then
> switches to the other drive, then back again.
>
> Try a bigger read - eg:
> 
>   time dd if=/dev/md6 of=/dev/null bs=128K count=8192
> 
> but I don't think there are any real gains to be made with RAID-1 - your
> results more or less track everything I've seen and used with RAID-1 - ie.
> disk read speed is the same as reading from a single device, and never
> significantly faster.

Actually I have managed to get about 30-40% higher throughput with just
a little hacking on the code that selects what disk to use.

Problem is
-It selects the disk that is closest to the wanted sector by remembering
 what sector was last requested and what disk was used for it.
-For sequential reads (sucha as hdparm) it will override and use the
 same disk anyways. (sector = lastsector+1)

I gained a lot of throughput by alternating disk, but seek time was
roughly doubled. I also tried to get smart and played some with the
code in order to avoid seeking both disks back and forth wildly when
there were two sequential reads. I didn't find a good way to do it
unfortunately.

I'm not going to make any patch available, because I removed bad-disk
checking in order to simplify it.

-HK

