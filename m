From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: write-behind performance ... or how behind can write-behind write
Date: Fri, 13 Feb 2009 13:44:37 -0500
Message-ID: <4995BF95.1010908@steeleye.com>
References: <4995A170.4000000@amln.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4995A170.4000000@amln.net>
Sender: linux-raid-owner@vger.kernel.org
To: Georgi Alexandrov <teh@amln.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Georgi Alexandrov wrote:

> Generally with the healthy array I'm getting the write performance of
> the SATA disk alone (in terms of requests/sec issued to the disk and
> bytes/sec written). The SATA disk is obviously a bottleneck even with
> the write-behind option set(2).

write-behind can help with two things:

1) overcoming latency (say one disk is on the network -- it may be the 
same speed as the source disk, but it takes longer round-trip for each 
I/O to complete)

2) temporary slowness of a device (say at a peak in I/O) -- the queue 
can temporarily hide the slowness of the secondary disk, but this won't 
last very long -- if writes continue at a pace faster than the disk can 
handle (i.e., the queue gets filled) then the array drops back to 
non-write-behind behavior

> So the questions is How behind can write-behind write? And can we get a
> better performance in a similar setup.

By default, it queues up 256 writes. This can be increased, but I've 
actually seen worse performance in some cases -- not sure why. I haven't 
had the time to dig into it and figure it out.

--
Paul
