From: Andrew Klaassen <clawsoon@yahoo.com>
Subject: Re: RAID10 - Ensure mirrors aren't on same JBOD
Date: Mon, 26 Apr 2010 11:36:10 -0700 (PDT)
Message-ID: <969623.54050.qm@web65401.mail.ac4.yahoo.com>
References: <t2k4877c76c1004261118m4991141en8b107872b802b237@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <t2k4877c76c1004261118m4991141en8b107872b802b237@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--- On Mon, 4/26/10, Michael Evans <mjevans1983@gmail.com>  wrote:

> I don't think I've read the RAID FAQ you speak of, a link
> would have been helpful.

Sorry... this one, question #7:

http://git.debian.org/?p=pkg-mdadm/mdadm.git;a=blob_plain;f=debian/FAQ;hb=HEAD

> mdadm --create ... --layout=(man mdadm) blockdev0 blockdev1
> blockdev2 blockdev3
>
> n2 == Creates almost the behavior you described; each
> stripe consists
> of b0c0 b0c1 b1c0 b1c1 (blockXcopyY)
> o2 == Data backup is in the next stripe: that is mirrored
> and rotated
> stripes: b0c0 b1c0 b2c0 b3c0 // b3c1 b0c1 b1c1 b2c1
> f2 == The first half is like raid0; the second half is like
> the o2
> above, but over the entire first half.
>
> More info on far from man 4 md
>        When 'far' replicas are
> chosen, the multiple copies of a given
> chunk are laid out quite distant from each other. 
> The  first  copy
> of all  data  blocks  will  be striped
> across the early part of all
> drives in RAID0 fashion, and then the next copy of all
> blocks will be
> striped across a later section of all drives, always
> ensuring that all
> copies of any given block are on different drives.
>
>        The 'far' arrangement can
> give sequential read performance
> equal to that of a RAID0 array, but at the cost of 
> reduced  write
> performance.

Yep, I've read all that, and it tells me what happens in the trivial case when 4 drives are specified.

However, it doesn't say what happens with a larger number of drives.  I'm looking for the kind of control I can get with RAID 1+0, where I can specify exactly which drives are mirrors of each other.  Is that possible with RAID10?

Thanks.

Andrew




