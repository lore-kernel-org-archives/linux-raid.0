From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: Which raid card to buy for Sarge
Date: Thu, 01 Apr 2004 08:19:48 +1200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <406B27E4.1000106@sauce.co.nz>
References: <Pine.LNX.4.44.0403311442520.31572-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0403311442520.31572-100000@coffee.psychology.mcmaster.ca>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mark Hahn wrote:

> please don't say things like this.  HW raid is *NOT* generally
> faster or better than software raid.  yes, if you're building a 
> quad-gigabit fileserver out of an old P5/100 you had sitting around,
> you're not even going to start looking at sw raid.
> 
> but for a normal FS config (dual opteron or xeon, >1GB ram,
> 2-400 MB/s sustained disk throughput), software raid is The Right Choice.
> 
> - speed: it's easy to do hundreds of MB/s with sw raid.  it's surprisingly hard
> to break even 100 MB/s using sw raid.
> 

<snip> further points I agree with.

I have spent some time benchmarking a dual xeon 2.4 with 1 GB and a
3ware 7506LP with 4 x 250 GB 7200RPM on 2.4.25 with XFS.

I would very much prefer to run software RAID 10 on this setup, for a
few reasons including being able to use mdadm for everything (I am using
a software RAID 1 for the OS) and the fact that 3dmd seems to have a
negative impact on disk writes, plus the other negatives you mention.

However, after extensive tests with iozone at the filesize (1.2MB), that
this server will be predominantly dealing with, varying stripe sizes and
the myriad of XFS variables, here are my best results:

3ware hardware RAID 10: Reads - 92.8MB/s    Writes - 88.9MB/s

Software RAID 10:  Reads - 53.7MB/s   Writes - 94.9 MB/s

If anyone is running similar hardware and is able to get better software
RAID performance, I would be very interested to hear the parameters.

Regards,

Richard Scobie


