From: Yuri Tikhonov <yur@emcraft.com>
Subject: [RFC PATCH 00/11][v2] md: support for asynchronous execution of RAID6 operations
Date: Tue, 9 Dec 2008 00:55:04 +0300
Message-ID: <200812090055.04265.yur@emcraft.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, dan.j.williams@intel.com, dzu@denx.de, wd@denx.de, yanok@emcraft.com
List-Id: linux-raid.ids

 Hello,

 This is the next attempt on asynchronous RAID-6 support. This patch-set
has the Dan Williams' comments (Nov, 15) addressed. These were mainly
about the ASYNC_TX part of the code.

 The following patch-set includes enhancements to the async_tx api and
modifications to md-raid6 to issue memory copies and parity calculations
asynchronously. Thus we may process copy operations and RAID-6 calculations
on the dedicated DMA engines accessible with ASYNC_TX API, and, as a result
off-load CPU, and improve the performance.

 To reduce the code duplication in the raid driver this patch-set modifies
some raid-5 functions to make them possible to use in the raid-6 case.

 The patch-set can be broken down into thee following main categories: 

1) Additions to ASYNC_TX API (patches 1-3; without the patch 1 the ASYNC_TX
can't be compiled for 44x in 2.6.27-rc6 or later);

2) RAID-6 implementation (patches 4-10)

3) ppc440spe ADMA driver (patch 11) (provided as a reference here)

-- 
Yuri Tikhonov, Senior Software Engineer
Emcraft Systems, www.emcraft.com
