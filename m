From: hank peng <pengxihan@gmail.com>
Subject: about raid5 recovery when created
Date: Tue, 8 Dec 2009 21:01:23 +0800
Message-ID: <389deec70912080501u6c6bc90ei2d34ef245a1dae9e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi, all:
As we know, when a raid5 array is created, recovery will be going on
which involves some read, one xor and one write. Since there is no
real data in the disk at the time, besides, if I am willing to wait
for recovery to complete and then use this raid5, how about adding
support for a fast recovery method? Right now, what is in my mind is
zero all disks which belong to this raid5. I think it will increase
raid5 recovery speed when created and decrease CPU usage, since all
zero is also XORed.
What do raid developers think?

-- 
The simplest is not all best but the best is surely the simplest!
