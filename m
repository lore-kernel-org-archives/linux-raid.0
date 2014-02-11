From: Chris Murphy <chris@colorremedies.com>
Subject: Re: Raid 6 rebuild
Date: Tue, 11 Feb 2014 11:46:55 -0700
Message-ID: <F16B4FD7-AC18-4741-AC5F-3ABACC9C875D@colorremedies.com>
References: <8686CD5263BEB644AE9B4AA239E70EC72826D52D@FMSMSX106.amr.corp.intel.com>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8686CD5263BEB644AE9B4AA239E70EC72826D52D@FMSMSX106.amr.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Gallas, William N" <william.n.gallas@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Feb 11, 2014, at 11:11 AM, "Gallas, William N" <william.n.gallas@intel.com> wrote:

> 
> Hi,
> 
> I have a raid 6 unit that takes over 40 hours to rebuild from an HDD fail condition. I have ample CPU cycles available and was wondering
> if MDRAID throttles the rebuild speed. 

Yes. It's probably a combination of too small md/stripe_cache_size, and /proc/sys/dev/raid/speed_limit_max and maybe /proc/sys/dev/raid/speed_limit_min. Another possibility is misalignment due to incorrect partitioning of a disk with 4KB physical sector sizes.


Chris Murphy