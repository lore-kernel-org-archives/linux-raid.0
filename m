From: Dominik Brodowski <linux@dominikbrodowski.net>
Subject: How to track down abysmal performance ata - raid1 - crypto - vg/lv
 - xfs
Date: Wed, 4 Aug 2010 09:35:46 +0200
Message-ID: <20100804073546.GA7494@comet.dominikbrodowski.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Hey,

on a production system I run kernel 2.6.35 and

	XFS	(rw,relatime,nobarrier)

on a

	lvdevice of a vgroup 

consisting of five

	dm-crypt devices (cryptsetup -c aes-lrw-benbi -s 384 create)

, each of which runs on a

	md-raid1 device (mdadm --create --level=raid1 --raid-devices=2)

on two

	750 GB ATA devices.


The read performance is abysmal. The ata devices can be ruled out, as hdparm
resulted in acceptable performance:
> Timing cached reads:   9444 MB in  2.00 seconds = 4733.59 MB/sec
> Timing buffered disk reads:  298 MB in  3.02 seconds =  98.73 MB/sec

How can I best track down the cause of the performance problem, 
a) without rebooting too often, and
b) without breaking up the setup specified above (production system)?

Any ideas? perf(1)? iostat(1)?

Thanks & best,

	Dominik
