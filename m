From: David Lethe <david@santools.com>
Subject: RE: Array read 3 time slower to read after data fully loaded
Date: Thu, 18 Nov 2010 14:53:28 -0600
Message-ID: <EB9469C209DB064DA15714214B92D5167F3433F8E0@34093-MBX-C09.mex07a.mlsrvr.com>
References: <4CE4B9E6.1040802@geograph.co.za>,<4CE58FF9.3050202@ziu.info>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CE58FF9.3050202@ziu.info>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Michal Soltys <soltys@ziu.info>, Zoltan Szecsei <zoltans@geograph.co.za>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Throughput is a function of block size & chunk size.  For operations such as copying large files, then larger block/chunk sizes mean
higher throughput .. at the COST of I/Os per second.

There is no free lunch. Before doing any tuning, ask yourself what the normal mix of random, sequential, read, write, large and small
block I/O is.  If you are constantly moving large files around, then by all means redo the RAID and file system setup, but if this exercise is an exception, then you may be better off leaving things as they are.
________________________________________
From: linux-raid-owner@vger.kernel.org [linux-raid-owner@vger.kernel.org] On Behalf Of Michal Soltys [soltys@ziu.info]
Sent: Thursday, November 18, 2010 2:43 PM
To: Zoltan Szecsei
Cc: linux-raid@vger.kernel.org
Subject: Re: Array read 3 time slower to read after data fully loaded

On 10-11-18 06:30, Zoltan Szecsei wrote:
> Hi,
> Can anyone please explain this to me?
>
> For the last >30 hours I have been loading some 2.5TB of 200-400MB tiff
> images, from another PC on our internal network, onto this new array.
> Yesterday, during this load process, I copied 10 of these files (about
> 2.5GB) from the array onto the /home directory of the same system.
>
> It took 33 seconds, equating to some 75MB/s.
>
> This morning I came in to find that the load process had finished, so I
> deleted the 10 test files from /home, and redid the identical copy test
> (using bash-history, so: identical).
>
> It took 123 seconds, equating to some 20MB/s.
>
> Que? (as in Manuel from Faulty Towers :-) )
>

Is the situation with reading into /dev/null instead of /home the same ?

As this is reading issue, one thing that came to my mind:

- make sure the kernel is _not_ compiled with  CONFIG_MULTICORE_RAID456.
It's afaik still experimental and can cause severe slowdowns

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
