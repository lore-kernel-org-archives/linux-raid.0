From: Andrew Walrond <andrew@walrond.org>
Subject: Anybody know about nforce4 SATA II hot swapping + linux raid?
Date: Fri, 7 Oct 2005 11:11:46 +0100
Message-ID: <200510071111.46788.andrew@walrond.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

I need to deploy some very resilient servers with hot swapable drives.

I always used dac960 based hardware raid for hot swapping in the past, but 
sata drives are so cheap compared to scsi that I'm considering the Tyan GT24 
server with 4 hot swappable SATA II drives (nforce4 pro controller)

	http://www.tyan.com/products/html/gt24b2891.html

Before I place an order, I need to know whether sata II hot swapping is up to 
scratch in the linux kernel, and whether it works nicely with linux software 
raid (which I already use/am familiar with).

Any knowledge greatfully accepted :)

Andrew Walrond
