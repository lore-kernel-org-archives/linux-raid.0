From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Awful RAID5 random read performance
Date: Sun, 31 May 2009 10:25:42 +0400
Message-ID: <4A2222E6.2070705@msgid.tls.msk.ru>
References: <4A21A938.6050907@harddata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A21A938.6050907@harddata.com>
Sender: linux-raid-owner@vger.kernel.org
To: Maurice Hilarius <maurice@harddata.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Maurice Hilarius wrote:
> A friend writes:
> 
> On a recent machine set up with Raid5.
> On a AMD Phenom II X4 810, and 4GB ram.
> 4 Seagate 7200.12  SATA 1TB drives,
> 
> I'm getting some rather impressive numbers for sequential read
> (300MB/s+) and write (170MB/s+) but the random read is proving to be
> absolutely atrocious.
> iostat says its going at about 0.5MB/s,

The key thing about random i/o is the block size.  With, say, 512bytes
blocks and single thread you will see less than 0.5Mb/sec.  With 64kbytes
blocksize it will be much better.

To diagnose: first try the same test on bare disk without raid layer.
Next try to vary block size and number of concurrent threads doing I/O.
There's no tweaks needed really.

/mjt
