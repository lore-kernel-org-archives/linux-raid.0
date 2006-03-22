From: Neil Brown <neilb@suse.de>
Subject: Re: Linux MD RAID5/6 bitmap patches
Date: Wed, 22 Mar 2006 21:06:14 +1100
Message-ID: <17441.8598.153372.503058@cse.unsw.edu.au>
References: <WM0DE1777FF9584eb1ACF5F0387340F83F@spsoftindia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Yogesh Pahilwan on Wednesday March 22
Sender: linux-raid-owner@vger.kernel.org
To: Yogesh Pahilwan <pahilwan.yogesh@spsoftindia.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday March 22, pahilwan.yogesh@spsoftindia.com wrote:
> Hello,
> 
> I want to know where I can get various MD RAID5/RAID6 bitmap patches for
> linux kernel 2.6.15.

2.6.15 already includes support for bitmaps for MD raid5 and raid6
(And raid1).  No patches needed.

> I want to know what kind of performance optimization possible on bitmap
> patches. I also want to know are 
> there any patches available which provides performance optimizations using
> bitmaps. 

Bitmaps optimise rebuild time after a crash, or after removing and
re-adding a device.  They do not improve normal read/write
performance, and may well cause a small degradation in performance.

NeilBrown
