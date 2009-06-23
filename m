From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH/RFC] md: Push down data integrity code to personalities.
Date: Tue, 23 Jun 2009 00:49:17 -0400
Message-ID: <yq11vpbv9ki.fsf@sermon.lab.mkp.net>
References: <20090619141419.GB11504@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090619141419.GB11504@skl-net.de> (Andre Noll's message of
	"Fri, 19 Jun 2009 16:14:19 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: Neil Brown <neilb@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>>>> "Andre" == Andre Noll <maan@systemlinux.org> writes:

Andre> Hi here's another patch that aims to reduce the knowledge about
Andre> specific raid levels from md.c. It addresses the data integrity
Andre> code which was added quite recently by Martin (CCed).

Andre> Please review.

There was a slight conflict in latest md.h against current Linus.  You
may want to respin.

I tested on a few different configurations adding and removing devices
with and without integrity enabled.  Looks good on this end.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
