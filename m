From: Lapohos Tibor <tibor.lapohos@rogers.com>
Subject: Re: embedding area is unusually small... (GRUB2 on software RAID1)
Date: Thu, 7 Jan 2010 08:26:11 -0800 (PST)
Message-ID: <272147.77280.qm@web88202.mail.re2.yahoo.com>
References: <21410882.iaPbMVeJ7U@rnqqfki.eternal-september.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <21410882.iaPbMVeJ7U@rnqqfki.eternal-september.org>
Sender: linux-raid-owner@vger.kernel.org
To: dev raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> > ....How, I don't know.
> 
> Did you check the "fdisk -lu /dev/sda" output?
> 
Yes. 63, so I still went on and repartitioned as described in Trial #[123].

I'm thinking that it could have been something left behind by the Intel Matrix RAID volume management... Maybe Neil Brown could give an explanation to this. I also noticed that if one re-partitions the exact same way, the RAID superblock information becomes available again, that is, partitioning or disassembling a RAID device does not threcken those records off the disks. Therefore, even if one does not create a partitioned md array, it will be, on its own! Actually it makes sense, since partitioning does not involve alteration of records throughout the disks... I just thought it would be interesting to share all this.

In the near future I will describe my story in a single post, maybe it will inspire some developers to address certain points in their documentation work.

Thanks again to All,
Tibor

