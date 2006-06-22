From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Large single raid and XFS or two small ones and EXT3?
Date: Thu, 22 Jun 2006 20:16:57 +0100 (BST)
Message-ID: <Pine.LNX.4.56.0606222014210.21158@lion.drogon.net>
References: <449AEB7C.6040108@cjx.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <449AEB7C.6040108@cjx.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Allen <chris@cjx.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 22 Jun 2006, Chris Allen wrote:

> Dear All,
>
> I have a Linux storage server containing 16x750GB drives - so 12TB raw
> space.

Just one thing - Do you want to use RAID-5 or RAID-6 ?

I just ask, as with that many drives (and that much data!) the
possibilities of a 2nd drive failure is increasing, and personally,
wherever I can, I take the hit these days, and have used RAID-6 for
some time... drives are cheap, even the 750GB behemoths!

> If I make them into a single RAID5 array, then it appears my only
> choice for a filesystem is XFS - as  EXT3 won't really handle partitions
> over 8TB.

I can't help with this though - I didn't realise ext3 had such a
limitation though!

Gordon
