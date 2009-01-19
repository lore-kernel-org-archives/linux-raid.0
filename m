From: thomas62186218@aol.com
Subject: Re: Raid6 write performance
Date: Mon, 19 Jan 2009 03:10:01 -0500
Message-ID: <8CB482475EFC01A-17F0-256E@webmail-dx12.sysops.aol.com>
References: <49742E74.9090502@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49742E74.9090502@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: rabbit+list@rabbit.us, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I tested RAID 5 and RAID 6 with 12 x 15K SAS drives on Ubuntu 8.04 
64-bit and found their performance to be about the same. I used 256 K 
chunk size, v1.0 superblocks, stripecachesize of 16384, and readahead 
of 65536.

RAID 5 reads: 774 MB/sec
RAID 5 writes: 585 MB/sec

RAID 6 reads: 742 MB/sec
RAID 6 writes: 559 MB/sec

My CPU utilization remains under 10% though during writes, and I'm 
wondering what can be done to get write performance closer to read 
performance. I have dual quad-core CPUs so there's plenty of CPU to go 
around. Any ideas on that front?

-Thomas


-----Original Message-----
From: Peter Rabbitson <rabbit+list@rabbit.us>
To: linux-raid@vger.kernel.org
Sent: Sun, 18 Jan 2009 11:40 pm
Subject: Raid6 write performance










Hi,

I am experimenting with raid6 on 4 drives on 2.6.27.11. The problem I am
having is that no matter what chunk size I use, the write benchmark
always comes out at single drive speed, although I should be seeing
double drive speed (read speed is at near 4x as expected). Is there some
hidden setting that I am overlooking, or is this a current known
limitation of raid6? In contrast if I make a raid5 on these 4 drives, I
get the expected 3xdrive write speed, and occasionally 4xdrive linear
read speed.

When the write test is running, I get about 14% of system cpu a sporadic
40% of iowait and the rest idle at all times (machine is in runlevel 1
so not to screw with results). Anyone has any ideas?

Thank you.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html





