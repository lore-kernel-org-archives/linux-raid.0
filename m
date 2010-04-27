From: Keld Simonsen <keld@keldix.com>
Subject: Re: RAID10 - Ensure mirrors aren't on same JBOD
Date: Tue, 27 Apr 2010 15:44:02 +0200
Message-ID: <20100427134401.GB17950@rap.rap.dk>
References: <535203.18346.qm@web65402.mail.ac4.yahoo.com>
 <t2k4877c76c1004261118m4991141en8b107872b802b237@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <t2k4877c76c1004261118m4991141en8b107872b802b237@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Evans <mjevans1983@gmail.com>
Cc: Andrew Klaassen <clawsoon@yahoo.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Apr 26, 2010 at 11:18:50AM -0700, Michael Evans wrote:
> 
> However as long as you remember that currently raid10 cannot be grown
> (*may have very very recently changed) you can use any of the layouts
> you like (I tend to prefer the 'far' layout).
> 
> mdadm --create ... --layout=(man mdadm) blockdev0 blockdev1 blockdev2 blockdev3
> 
> n2 == Creates almost the behavior you described; each stripe consists
> of b0c0 b0c1 b1c0 b1c1 (blockXcopyY)
> o2 == Data backup is in the next stripe: that is mirrored and rotated
> stripes: b0c0 b1c0 b2c0 b3c0 // b3c1 b0c1 b1c1 b2c1
> f2 == The first half is like raid0; the second half is like the o2
> above, but over the entire first half.

mnjae, the second part of a f2 layout is also laid out in a raid0 fashion.

> More info on far from man 4 md
>        When 'far' replicas are chosen, the multiple copies of a given
> chunk are laid out quite distant from each other.  The  first  copy
> of all  data  blocks  will  be striped across the early part of all
> drives in RAID0 fashion, and then the next copy of all blocks will be
> striped across a later section of all drives, always ensuring that all
> copies of any given block are on different drives.
> 
>        The 'far' arrangement can give sequential read performance
> equal to that of a RAID0 array, but at the cost of  reduced  write
> performance.

If you employ a file system (like ext3), then the elevator algorithm
tends to eliminate the write performance hit.

best regards
keld
