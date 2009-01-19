From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: Raid6 write performance
Date: Mon, 19 Jan 2009 13:48:37 +0100
Message-ID: <20090119124837.GC23623@rap.rap.dk>
References: <49742E74.9090502@rabbit.us> <8CB482475EFC01A-17F0-256E@webmail-dx12.sysops.aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8CB482475EFC01A-17F0-256E@webmail-dx12.sysops.aol.com>
Sender: linux-raid-owner@vger.kernel.org
To: thomas62186218@aol.com
Cc: rabbit+list@rabbit.us, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jan 19, 2009 at 03:10:01AM -0500, thomas62186218@aol.com wrote:
> 
> I tested RAID 5 and RAID 6 with 12 x 15K SAS drives on Ubuntu 8.04 
> 64-bit and found their performance to be about the same. I used 256 K 
> chunk size, v1.0 superblocks, stripecachesize of 16384, and readahead 
> of 65536.
> 
> RAID 5 reads: 774 MB/sec
> RAID 5 writes: 585 MB/sec
> 
> RAID 6 reads: 742 MB/sec
> RAID 6 writes: 559 MB/sec
> 
> My CPU utilization remains under 10% though during writes, and I'm 
> wondering what can be done to get write performance closer to read 
> performance. I have dual quad-core CPUs so there's plenty of CPU to go 
> around. Any ideas on that front?

Seems like it is the same equipment that you also did the raid10,f2
tests for. I think it would be interesting to have a consolidated list
of performance comparisons, when you have completed your tweakings.
Is that part of your plan?

best regards
keld
