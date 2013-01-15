From: keld@keldix.com
Subject: Re: Suboptimal raid6 linear read speed
Date: Tue, 15 Jan 2013 20:57:07 +0100
Message-ID: <20130115195707.GA30921@www5.open-std.org>
References: <20130115123301.GA11948@rabbit.us> <50F55046.7050605@turmel.org> <20130115125507.GA12184@rabbit.us> <20130115170937.GA8831@kevin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130115170937.GA8831@kevin>
Sender: linux-raid-owner@vger.kernel.org
To: Charles Polisher <cpolish@surewest.net>
Cc: Peter Rabbitson <rabbit+list@rabbit.us>, Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jan 15, 2013 at 09:09:38AM -0800, Charles Polisher wrote:
> On Tue, Jan 15, 2013 at 11:55:07PM +1100, Peter Rabbitson wrote:
> > On Tue, Jan 15, 2013 at 07:49:10AM -0500, Phil Turmel wrote:
> > > You are neglecting each drive's need to skip over parity blocks.  If the
> > > array's chunk size is small, the drives won't have to seek, just wait
> > > for the platter spin.  Larger chunks might need a seek.
> > 
> > > Either way, you
> > > won't get better than (single drive rate) * (n-2) where "n" is the
> > > number of drives in your array. (Large sequential reads.)
> > 
> > This can't be right. As far as I know the md layer is smarter than that, and
> > includes various anticipatory codepaths specifically to leverage multiple
> > drives in this fashion. Fwiw raid5 does give me the near-expected speed
> > (n * single drive).
> 
> Happen to be working with comparative benchmarks looking for
> relative throughput, varying the number of active drives in the
> array and the RAID level. Clearly in this data RAID6 sequential
> writes are bottlenecked by the 2 parity stripes. RAID6 setup
> increases from 2 non-parity drives in the 4 drive configuration
> to 6 non-parity drives in the 8 drive configuration, so one
> might hope for 3x advantage. Yet the data show an advantage of
> only 1.83 for reads. My guess is the need to read the parity
> stripes is again a limiting factor. Next benchmark will vary
> stripe and stride.
> 
>                                         Advantage     Advantage
>                                         vs 4 drives   vs RAID0
> Config  Drives  Seq write   Seq  read   Write  Read   Write Read
> ------  ------  ----------  ----------  ----- -----   ----  ----
> RAID0   4        8.1MB/sec   9.3MB/sec   1.00  1.00   1.00  1.00
> RAID0   8       16.8MB/sec  15.0MB/sec   2.07  1.61   1.00  1.00
>  
> RAID1   4        2.1MB/sec   3.6MB/sec   1.00  1.00   0.25  0.38
> RAID1   8        1.6MB/sec   3.6MB/sec   0.76  1.00   0.09  0.24
> 
> RAID5   4       16.8MB/sec   9.1MB/sec   1.00  1.00   2.07  0.97
> RAID5   8       17.2MB/sec  14.9MB/sec   1.02  1.63   2.12  1.60
> 
> RAID6   4       12.6MB/sec   7.9MB/sec   1.00  1.00   1.55  0.84
> RAID6   8       14.4MB/sec  14.5MB/sec   1.63  1.83   1.77  1.55
> 
> RAID10  4        4.0MB/sec   7.3MB/sec   1.00  1.00   0.49  0.78
> RAID10  8        6.3MB/sec  13.4MB/sec   1.57  1.83   0.37  0.89
> 
> Yes, these drives are *really* slow (Connor CP 30548). 
> The math doesn't change.
> -- 
> Charles

What layout are you using for RAID10?
Is it Linux MD RAID10?

Best regards
Keld
