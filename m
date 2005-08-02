From: "Boik Moon" <bmoon@yellowmachine.com>
Subject: RAID read performance
Date: Tue, 2 Aug 2005 15:43:44 -0700
Message-ID: <9A6ED0928D2DE54CAD74FDC8DCE9843505DA70@asi-exchange.ASI.int>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

According to RAID theory, the READ performance with RAID0, 1 and 5
should
Be faster than one with non-RAID. I tested it on Redhat linux(ES) on
Pentium PC, but they are almost same. I am using
RocketRAID404(HPT374)PCI card to connect 4 master IDE
Drivers.
Ideally it must be 2 or more times faster on RAID0/1/5.

Do we still have an issue on parallelism on 2.4 and 2.6 Linux kernel?

Thanks,

Bo

