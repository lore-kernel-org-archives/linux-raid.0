From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 0/5] md: sector_t conversions
Date: Fri, 11 Jul 2008 22:18:43 +1000
Message-ID: <18551.20387.782432.394928@notabene.brown>
References: <1215681338-32365-1-git-send-email-maan@systemlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andre Noll on Thursday July 10
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday July 10, maan@systemlinux.org wrote:
> Hi
> 
> here is the first batch of patches that aim to change the internal
> representations of sizes of raid devices from 1K blocks to 512 byte
> sectors.
> 
> Patches 1-3 change the internal functions update_size(),
> calc_dev_size() and calc_dev_sboffset() so that they take/return a
> sector count instead of a block count. Patch 4 changes the semantics
> of rdev->sb_offset so that its value now represents the number of the
> start sector instead of the start block. Patch 5 removes some macros
> that have become unused due to this conversion.

Thanks.  I've pushed all of these (with some changes as mentioned in
earlier emails) into my for-next tree
   git://neil.brown.name/md/ for-next
   http://neil.brown.name/git?p=md;a=shortlog;h=refs/heads/for-next

Thanks,
NeilBrown
