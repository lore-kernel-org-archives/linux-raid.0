From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH/Resend] md: Push down data integrity code to personalities.
Date: Tue, 04 Aug 2009 01:28:49 -0400
Message-ID: <yq163d4f8q6.fsf@sermon.lab.mkp.net>
References: <20090701083802.GC9910@skl-net.de>
	<19026.50240.504728.428875@notabene.brown>
	<20090713085442.GJ9910@skl-net.de>
	<19058.31706.803177.77914@notabene.brown>
	<20090803164030.GI5174@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090803164030.GI5174@skl-net.de> (Andre Noll's message of "Mon,
	3 Aug 2009 18:40:30 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: Neil Brown <neilb@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>>>> "Andre" == Andre Noll <maan@systemlinux.org> writes:

[Inlining blk_get_integrity]

Andre> IMO this second alternative is be a bit cleaner and it might help
Andre> other users of blk_get_integrity() as well. Martin, are you OK
Andre> with this change to blkdev.h?

Yeah, that's fine.

-- 
Martin K. Petersen	Oracle Linux Engineering
