From: Christoph Hellwig <hch@infradead.org>
Subject: Re: mkfs.xfs states log stripe unit is too large
Date: Mon, 2 Jul 2012 02:18:27 -0400
Message-ID: <20120702061827.GB16671@infradead.org>
References: <D3F781FA-CEB0-4896-9441-772A9E533354@2012.bluespice.org>
 <20120623234445.GZ19223@dastard>
 <4FE67970.2030008@sandeen.net>
 <4FE710B7.5010704@hardwarefreak.com>
 <d71834a062ffd666ab53a4695eb643e9@muaddib.hro.localnet>
 <20120626023059.GC19223@dastard>
 <20120626080217.GA30767@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120626080217.GA30767@infradead.org>
Sender: linux-raid-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Ingo J?rgensmann <ij@2012.bluespice.org>, xfs@oss.sgi.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ping to Neil / the raid list.

On Tue, Jun 26, 2012 at 04:02:17AM -0400, Christoph Hellwig wrote:
> On Tue, Jun 26, 2012 at 12:30:59PM +1000, Dave Chinner wrote:
> > You can't, simple as that. The maximum supported is 256k. As it is,
> > a default chunk size of 512k is probably harmful to most workloads -
> > large chunk sizes mean that just about every write will trigger a
> > RMW cycle in the RAID because it is pretty much impossible to issue
> > full stripe writes. Writeback doesn't do any alignment of IO (the
> > generic page cache writeback path is the problem here), so we will
> > lamost always be doing unaligned IO to the RAID, and there will be
> > little opportunity for sequential IOs to merge and form full stripe
> > writes (24 disks @ 512k each on RAID6 is a 11MB full stripe write).
> > 
> > IOWs, every time you do a small isolated write, the MD RAID volume
> > will do a RMW cycle, reading 11MB and writing 12MB of data to disk.
> > Given that most workloads are not doing lots and lots of large
> > sequential writes this is, IMO, a pretty bad default given typical
> > RAID5/6 volume configurations we see....
> 
> Not too long ago I benchmarked out mdraid stripe sizes, and at least
> for XFS 32kb was a clear winner, anything larger decreased performance.
> 
> ext4 didn't get hit that badly with larger stripe sizes, probably
> because they still internally bump the writeback size like crazy, but
> they did not actually get faster with larger stripes either.
> 
> This was streaming data heavy workloads, anything more metadata heavy
> probably will suffer from larger stripes even more.
> 
> Ccing the linux-raid list if there actually is any reason for these
> defaults, something I wanted to ask for a long time but never really got
> back to.
> 
> Also I'm pretty sure back then the md default was 256kb writes, not 512
> so it seems the defaults further increased.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
