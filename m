From: Steven Ihde <x-linux-raid@hamachi.dyndns.org>
Subject: Re: Looking for the cause of poor I/O performance
Date: Wed, 8 Dec 2004 17:40:04 -0800
Message-ID: <20041209014004.GA16666@hamachi.us>
References: <200412082225.iB8MPT915415@www.watkins-home.com> <200412082241.iB8Mfo915469@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200412082241.iB8Mfo915469@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: 'David Greaves' <david@dgreaves.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 08 Dec 2004 17:41:45 -0500, Guy wrote:
> I also tried changing /proc/sys/vm/max-readahead.
> I tried the default of 31, 0 and 127.  All gave me about the same
> performance.
> 
> I started testing the speed with the dd command below.  It complete in about
> 12.9 seconds.  None of the read ahead changes seem to affect my speed.
> Everything is now set to 0, still 12.9 seconds.
> 12.9 seconds = about 79.38 MB/sec.
> 
> time dd if=/dev/md2 of=/dev/null bs=1024k count=1024

I'm running kernel 2.6.8; I found the readahead setting had a pretty
dramatic effect.  I set readahead for all the drives and their
partitions to zero:

blockdev --setra 0 /dev/{hdc,hdg,sda,hdc5,hdg5,sda5}

I tested various readahead values for the array device by reading 1GB
of data from the device using this procedure:

blockdev --flushbufs /dev/md1
blockdev --setra $readahead /dev/md1
dd if=/dev/md1 of=/dev/null bs=1024k count=1024

These are the results:

RA    transfer rate (B/s)
---------------
   0: 15768513
 128: 33680867
 256: 42982770
 512: 59223248
1024: 78590551
2048: 81918844
4096: 82386839

We seem to reach the point of diminishing returns at 1024 readahead,
~80MB/sec throughput.  To recap, this is with three Seagate Barracuda
drives, two of which are 80GB PATA, the other a 120GB SATA, in a RAID5
configuration.  256 was the default readahead value.  The chunk size
on my array is 32k.  I don't know if that has an effect or not.

-Steve

