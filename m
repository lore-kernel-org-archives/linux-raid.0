From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: RAID-10 with mixed block size HDDs
Date: Mon, 25 Mar 2013 19:04:58 +0100
Message-ID: <20130325180458.GA4833@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I've a two disk RAID-10 (far 2, I guess).
One HDD seems to be going to the HDD heaven,
so I'm planning to change it.

The most convenient HDD I found has 4K sectors,
while the actual ones have 512 byte sectors.

All partitions and headers seem to be multiple
of 4K, but I was wondering if there could be
performance problems having a mixed setup.

Any experience with that?
Suggestions?

Thanks,

bye,

-- 

piergiorgio
