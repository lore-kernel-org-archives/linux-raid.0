From: Bernd Schubert <bs@q-leap.de>
Subject: ioatdma
Date: Tue, 18 Mar 2008 22:30:42 +0100
Message-ID: <200803182230.42812.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

from my understanding of ioatdma it just should be loaded before raid456 to 
make use it, shouldn't it?

I just wonder why memcpy_count and bytes_transferred in /sys/class/dma/* is 
always zero.

I guess the kernel version is relevant, but this a bit difficult to answer, 
since we have backported a huge chunk of raid, ioatdma and dca to 2.6.22...


Do I miss something?


Thanks,
Bernd

-- 
Bernd Schubert
Q-Leap Networks GmbH
