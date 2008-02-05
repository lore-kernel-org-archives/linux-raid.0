From: Neil Brown <neilb@suse.de>
Subject: Re: Deleting mdadm RAID arrays
Date: Wed, 6 Feb 2008 07:12:32 +1100
Message-ID: <18344.49968.584648.904844@notabene.brown>
References: <200802051142.19625.admin@domeny.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Marcin Krol on Tuesday February 5
Sender: linux-raid-owner@vger.kernel.org
To: Marcin Krol <admin@domeny.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday February 5, admin@domeny.pl wrote:
> 
> % mdadm --zero-superblock /dev/sdb1
> mdadm: Couldn't open /dev/sdb1 for write - not zeroing

That's weird.
Why can't it open it?

Maybe you aren't running as root (The '%' prompt is suspicious).
Maybe the kernel has  been told to forget about the partitions of
/dev/sdb.
mdadm will sometimes tell it to do that, but only if you try to
assemble arrays out of whole components.

If that is the problem, then
   blockdev --rereadpt /dev/sdb

will fix it.

NeilBrown
