From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 2.6.21-rc4 00/15] md raid5 acceleration and async_tx
Date: Thu, 22 Mar 2007 23:51:37 -0700
Message-ID: <20070323064856.15570.45052.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, christopher.leech@intel.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, yur@emcraft.com, wd@denx.de, arjan@linux.intel.com, rmk+kernel@arm.linux.org.uk
List-Id: linux-raid.ids

The following patch set implements the async_tx api and modifies
md-raid5 to issue memory copies and xor calculations asynchronously.
Async_tx is an extension of the existing dmaengine interface in the
kernel.  Async_tx allows kernel code to utilize application specific
acceleration engines when present and fall back to software routines
otherwise.  Further details can be found in the individual patch
headers. 
 
The implementation has been in -mm since 2.6.20-mm1 and has been
released in various forms to IOP users since 2.6.18
(http://sourceforge.net/projects/xscaleiop).  This release includes
cleanups to the iop-adma driver.  The md-raid5 patches are just rebased
versions of the 2.6.20-rc5 release. 
 
Given the release of an acceleration engine driver for another platform
(440spe http://marc.info/?l=linux-raid&m=117400143317440&w=2), I feel
more comfortable broaching the subject of 2.6.22 inclusion.
 
Regards, 
Dan
 
 
Dan Williams (15):
        dmaengine: add base support for the async_tx api
        ARM: Add drivers/dma to arch/arm/Kconfig
        dmaengine: add the async_tx api
        md: add raid5_run_ops and support routines
        md: use raid5_run_ops for stripe cache operations
        md: move write operations to raid5_run_ops
        md: move raid5 compute block operations to raid5_run_ops
        md: move raid5 parity checks to raid5_run_ops
        md: satisfy raid5 read requests via raid5_run_ops
        md: use async_tx and raid5_run_ops for raid5 expansion operations
        md: move raid5 io requests to raid5_run_ops
        md: remove raid5 compute_block and compute_parity5
        dmaengine: driver for the iop32x, iop33x, and iop13xx raid engines
        iop13xx: Surface the iop13xx adma units to the iop-adma driver
        iop3xx: Surface the iop3xx DMA and AAU units to the iop-adma driver
 
