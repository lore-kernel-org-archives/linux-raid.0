From: xxiao <xiaoxianghua@gmail.com>
Subject: crypto/xor.c and lib/raid6 to improve raid5/6 performance?
Date: Fri, 11 Oct 2013 15:20:32 -0500
Message-ID: <CAP7cwtumKJ5t3cb0bACaVtGVKXT2jibzWzdjqY2Si=uNjDg1KQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm looking for ways to speed up RAID calculations(e.g XOR for RAID5) plus
offloading them from CPU as much as possible. During kernel boot up I
noticed two outputs:

crypto/xor.c:
xor: measuring software checksum speed
   8regs     :  3379.000 MB/sec
   8regs_prefetch:  2969.000 MB/sec
   32regs    :  3398.000 MB/sec
   32regs_prefetch:  3054.000 MB/sec
xor: using function: 32regs (3398.000 MB/sec)

lib/raid6:
raid6: altivecx1  1470 MB/s
raid6: altivecx2  1820 MB/s
raid6: altivecx4  2756 MB/s
raid6: altivecx8  2874 MB/s
raid6: int64x1    480 MB/s
raid6: int64x2    832 MB/s
raid6: int64x4   1221 MB/s
raid6: int64x8   1160 MB/s
raid6: using algorithm altivecx8 (2874 MB/s)
raid6: using intx1 recovery algorithm

However I'm unclear how the md drivers(especially RAID5, and/or RAID6) can
benefit from these code, can I use them to accelerate RAID5/6's XOR with
these code somehow?

Thanks a lot,
Xiao
