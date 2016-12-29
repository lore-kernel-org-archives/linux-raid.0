From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: Intel SSD or other brands
Date: Thu, 29 Dec 2016 11:39:47 +0000
Message-ID: <22628.62979.46926.463323@tree.ty.sabi.co.uk>
References: <0329d841-984b-fa25-0bf2-0aba4d55b6de@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0329d841-984b-fa25-0bf2-0aba4d55b6de@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> [ ... ] I now found out that performance of a 520s SSD is
> around 180 times faster than a 530s SSD. [ ... ]

Well "performance" can be roughly the same, even if "speed" can
be very different.

http://www.sabi.co.uk/blog/15-two.html#151023

> 520s: 70MB/s
> 530s: 0.4MB/s
....
> fio --filename=/dev/sdb --direct=1 --sync=1 --rw=write --bs=4k 
>  --iodepth=1 --runtime=60 --time_based --group_reporting 
>  --name=IntelDC3510_4kj1 --numjobs=1

Arguably the 520s actually have no performance.

https://www.sebastien-han.fr/blog/2014/10/10/ceph-how-to-test-if-your-ssd-is-suitable-as-a-journal-device/
