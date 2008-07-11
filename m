From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 3/5] md: Make calc_dev_sboffset() return a sector count.
Date: Fri, 11 Jul 2008 21:04:10 +1000
Message-ID: <18551.15914.696011.774286@notabene.brown>
References: <1215681338-32365-1-git-send-email-maan@systemlinux.org>
	<1215681338-32365-4-git-send-email-maan@systemlinux.org>
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
> As BLOCK_SIZE_BITS is 10 and
> 
> 	MD_NEW_SIZE_SECTORS(2 * x) = 2 * NEW_SIZE_BLOCKS(x),
> 
> the return value of calc_dev_sboffset() doubles. Fix up all three
> callers accordingly.

Only I have four callers :-)
There is new code in my tree that isn't in Linus' tree which you are
basing on.
Maybe it would be worth basing on linux-next? or pull the "for-next"
branch from git://neil.brown.name/md/

I've fixed the extra caller and push it into my tree.

Thanks,
NeilBrown
