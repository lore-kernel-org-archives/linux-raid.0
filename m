From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH/Resend] md: Push down data integrity code to personalities.
Date: Fri, 07 Aug 2009 00:48:07 -0400
Message-ID: <yq1ocqsi60o.fsf@sermon.lab.mkp.net>
References: <20090701083802.GC9910@skl-net.de>
	<19026.50240.504728.428875@notabene.brown>
	<20090713085442.GJ9910@skl-net.de>
	<19058.31706.803177.77914@notabene.brown>
	<20090803164030.GI5174@skl-net.de>
	<yq163d4f8q6.fsf@sermon.lab.mkp.net>
	<20090806083710.GJ5174@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090806083710.GJ5174@skl-net.de> (Andre Noll's message of "Thu,
	6 Aug 2009 10:37:10 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Neil Brown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>>>> "Andre" == Andre Noll <maan@systemlinux.org> writes:

Andre> So here's a patch that replaces the dummy macros for data
Andre> integrity by inline functions. The patch is only compile-tesed,
Andre> but that's hopefully OK as the new functions are only used if
Andre> data integrity is not compiled in and are thrown away by gcc
Andre> anyway.

Looks ok.  Please send it to Jens.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
