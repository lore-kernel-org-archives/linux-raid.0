From: Charles Polisher <cpolish@surewest.net>
Subject: Re: Suboptimal raid6 linear read speed
Date: Tue, 15 Jan 2013 20:43:35 -0800
Message-ID: <20130116044335.GA10165@kevin>
References: <20130115123301.GA11948@rabbit.us>
 <50F55046.7050605@turmel.org>
 <20130115125507.GA12184@rabbit.us>
 <20130115170937.GA8831@kevin>
 <20130115195707.GA30921@www5.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130115195707.GA30921@www5.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: keld@keldix.com
Cc: Peter Rabbitson <rabbit+list@rabbit.us>, Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

keld@keldix.com wrote:
> >                                         Advantage     Advantage
> >                                         vs 4 drives   vs RAID0
> > Config  Drives  Seq write   Seq  read   Write  Read   Write Read
> > ------  ------  ----------  ----------  ----- -----   ----  ----
> > RAID0   4        8.1MB/sec   9.3MB/sec   1.00  1.00   1.00  1.00
> > RAID0   8       16.8MB/sec  15.0MB/sec   2.07  1.61   1.00  1.00
> >  
> > RAID1   4        2.1MB/sec   3.6MB/sec   1.00  1.00   0.25  0.38
> > RAID1   8        1.6MB/sec   3.6MB/sec   0.76  1.00   0.09  0.24
> > 
> > RAID5   4       16.8MB/sec   9.1MB/sec   1.00  1.00   2.07  0.97
> > RAID5   8       17.2MB/sec  14.9MB/sec   1.02  1.63   2.12  1.60
> > 
> > RAID6   4       12.6MB/sec   7.9MB/sec   1.00  1.00   1.55  0.84
> > RAID6   8       14.4MB/sec  14.5MB/sec   1.63  1.83   1.77  1.55
> > 
> > RAID10  4        4.0MB/sec   7.3MB/sec   1.00  1.00   0.49  0.78
> > RAID10  8        6.3MB/sec  13.4MB/sec   1.57  1.83   0.37  0.89
> > 
> What layout are you using for RAID10?
> Is it Linux MD RAID10?

# cat /proc/mdstat 
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4] [multipath] 
md1 : active raid10 sdi[7] sdh[6] sdg[5] sdf[4] sde[3] sdd[2] sdc[1] sdb[0]
      2118656 blocks 64K chunks 2 near-copies [8/8] [UUUUUUUU]


