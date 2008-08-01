From: Neil Brown <neilb@suse.de>
Subject: Re: Adding a bitmap, v 0.90 superblocks
Date: Fri, 1 Aug 2008 13:11:07 +1000
Message-ID: <18578.32459.608646.540653@notabene.brown>
References: <20080729184416.GA7655@nexus.edgeofthenet.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Richard Michael on Tuesday July 29
Sender: linux-raid-owner@vger.kernel.org
To: Richard Michael <rmichael-raid@edgeofthenet.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday July 29, rmichael-raid@edgeofthenet.org wrote:
> I would like to add an internal bitmap to my RAID1 array.  It uses
> v 0.90 superblocks.
> 
> Reading the man page, I believe I do this with:
> 
> "mdadm --grow --bitmap=internal /dev/mdX"
> 
> correct?

Correct!

> 
> How do I know how much space is available on the superblock when mdadm
> will perform it's computation "to make best use of available space"?
> I'm curious because perhaps I should change to 1.x superblocks in the
> future (for non-bootable arrays).

with 0.90, there is about 60K guaranteed to be available.  This is
491520 bits.

With 1.0 there 3K guaranteed to be available, though there might be
more.  I don't think we use the "more" currently unless you add a
bitmap when creating the array.

So there is no need to change metadata version for more bitmap space.

NeilBrown
