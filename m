From: Robert LeBlanc <robert@leblancnet.us>
Subject: Re: Intel SSD or other brands
Date: Thu, 29 Dec 2016 09:56:07 -0700
Message-ID: <CAANLjFo4tP9Xdv8JX5waNOu_34zWDKsQqOru3fpt2wOAJuZYcQ@mail.gmail.com>
References: <0329d841-984b-fa25-0bf2-0aba4d55b6de@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0329d841-984b-fa25-0bf2-0aba4d55b6de@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is a similar workload as Ceph and you may find more information
from their mailing lists. When I was working with Ceph about a year
ago, we tested a bunch of SSDs and found that sync=1 really
differentiates drives and you really find which drives are better. In
our testing, we found that the 35xx, 36xx, and 37xx drives handled the
workloads the best. The 3x00 drives were close to EOL, so we focused
on the 3x10 drives. I don't have the data anymore, but the 3610 had
the best performance, the 3710 had the best data integrity in the case
of power failure, and the 3510 had the best price. The 3510 had about
~.1 drive writes per day, the 3610 had ~1 DWPD and the 3710 had ~3
DWPD. Due to the fault tolerance of Ceph, we felt comfortable with the
3610s. In our testing, we exceeded the performance numbers listed for
the drives on their data sheets when running up to 8 jobs even with
sync=1 which no other manufacture did. For Ceph, we could put multiple
OSDs on a disk and take advantage of this performance gain. You may be
able to do something similar by partitioning your RAID 5 and putting
multiple DRBDs on it.
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1


On Wed, Dec 28, 2016 at 7:14 PM, Adam Goryachev
<mailinglists@websitemanagers.com.au> wrote:
> Apologies for my prematurely sent email (if it gets through), this one is
> complete...
>
> Hi all,
>
> I've spent a number of years trying to build up a nice RAID array for my
> SAN, but I seem to be slowly solving one bottle neck only to find another
> one. Right now, I've identified the underlying SSD's as being a major factor
> in that performance issue.
>
> I started with 5 x 480GB Intel 520s SSD's in a RAID5 array, and this
> performed really well.
> I added 1 x 480GB 530s SSD
> I added 2 x 480GB 530s SSD
>
> I now found out that performance of a 520s SSD is around 180 times faster
> than a 530s SSD. I had to run many tests, but eventually I found the right
> things to test for (which matched my real life results), and the numbers
> were nothing short of crazy.
> Running each test 5 times and average the results...
> 520s: 70MB/s
> 530s: 0.4MB/s
>
> OK, so before I could remove and test the 520s, I removed/tested one of the
> 530s and saw the horrible performance, so I bought and tested a 540s and
> found:
> 540s: 6.7MB/s
> So, around 20 times better than the 530, so I replaced all the drives with
> the 540, but I still have worse performance than the original 5 x 520s
> array.
>
> Working with Intel, they swapped a 530s drive for a DC3510, and I then found
> the DC3510 was awesome:
> DC3510: 99MB/s
> Except, a few weeks back when I placed the order, I was told there is no
> longer any stock of this drive, (I wanted 16 x 800GB model), and that the
> replacement model is the DC3520. So I figure I won't just blindly buy the
> DC3520 assuming it's performance will be similar to the previous model, so I
> buy 4 x 480GB DC3520 and start testing.
> DC3520: 37MB/s
>
> So, 1/3rd of a DC3510, but still better than the current live 540s drives,
> but also still half the original 520s drives.
>
> Summary:
> 520s:   70217kB/s
> 530s:     391kB/s
> 540s:    6712kB/s
> 330s:      24kB/s
> DC3510: 99313kB/s
> DC3520: 37051kB/s
> WD2TBCB:  475kB/s
>
> * For comparison, I had a older Western Digital Black 2TB spare, and ran the
> same test on it. Got a better result than some of the SSD's which was really
> surprising, but it's certainly not an option.
> FYI, the test I'm running is this:
> fio --filename=/dev/sdb --direct=1 --sync=1 --rw=write --bs=4k --iodepth=1
> --runtime=60 --time_based --group_reporting --name=IntelDC3510_4kj1
> --numjobs=1
> All drives were tested on the same machine/SATA3 port (basic intel desktop
> motherboard), with nothing on the drive (no fs, no partition, nothing trying
> to access it, etc..).
> In reality, I tested iodepth from 1..10, but in my use case, the iodepth=1
> matches is the relevant number. At higher iodepth, we see performance on all
> the drives improve, if interested, I can provide a full set of my
> results/analysis.
>
> So, my actual question... Can you suggest or have you tested any Intel (or
> other brand) SSD which has good performance (similar to the DC3510 or the
> 520s)? (I can't buy and test every single variant out there, my budget
> doesn't go anywhere close to that).
> It needs to be SATA, since I don't have enough PCIe slots to get the needed
> capacity (nor enough budget). I need around 8 x drives with around 6TB
> capacity in RAID5.
>
> FYI, my storage stack is like this:
> 8 x SSD's
> mdadm - RAID5
> LVM
> DRBD
> iSCSI
>
> From my understanding, it is DRBD that makes everything a iodepth=1 issue.
> It is possible to reach iodepth=2 if I have 2 x VM's both doing a lot of IO
> at the same time, but it usually a single VM performance that is too
> limited.
>
> Regards,
> Adam
>
>
> --
> Adam Goryachev Website Managers www.websitemanagers.com.au
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
