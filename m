From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Subject: Re: Awful RAID5 random read performance
Date: Sun, 31 May 2009 01:47:57 -0600
Message-ID: <200905310147.58119.tfjellstrom@shaw.ca>
References: <4A21A938.6050907@harddata.com> <4A2222E6.2070705@msgid.tls.msk.ru>
Reply-To: tfjellstrom@shaw.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A2222E6.2070705@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Maurice Hilarius <maurice@harddata.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun May 31 2009, Michael Tokarev wrote:
> Maurice Hilarius wrote:
> > A friend writes:
> >
> > On a recent machine set up with Raid5.
> > On a AMD Phenom II X4 810, and 4GB ram.
> > 4 Seagate 7200.12  SATA 1TB drives,
> >
> > I'm getting some rather impressive numbers for sequential read
> > (300MB/s+) and write (170MB/s+) but the random read is proving to be
> > absolutely atrocious.
> > iostat says its going at about 0.5MB/s,
>
> The key thing about random i/o is the block size.  With, say, 512bytes
> blocks and single thread you will see less than 0.5Mb/sec.  With 64kbytes
> blocksize it will be much better.
>
> To diagnose: first try the same test on bare disk without raid layer.
> Next try to vary block size and number of concurrent threads doing I/O.
> There's no tweaks needed really.

I happen to be the friend Maurice was talking about. I let the raid layer keep 
its default chunk size of 64K. The smaller size (below like 2MB) tests in 
iozone are very very slow. I recently tried disabling readahead, Acoustic 
Management, and played with the io scheduler and all any of it has done is 
make the sequential access slower and has barely touched the smaller sized 
random access test results. Even with the 64K iozone test random read/write is 
only in the 7 and 11MB/s range.

It just seems too low to me.

> /mjt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
