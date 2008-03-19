From: Bernd Schubert <bs@q-leap.de>
Subject: ioatdma
Date: Wed, 19 Mar 2008 10:57:48 +0100
Message-ID: <frqo2s$tl2$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

from my understanding of ioatdma it just should be loaded before raid456 to 
make use it, shouldn't it?

I just wonder why memcpy_count and bytes_transferred in /sys/class/dma/* is 
always zero.

I guess the kernel version is relevant, but this a bit difficult to answer, 
since we have backported a huge chunk of raid, ioatdma and dca from 2.6.25
to 2.6.22...


Do I miss something or do I need to enable something somewhere?


Thanks,
Bernd


