From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Problems with RAID1 using SATA disks.
Date: Wed, 12 May 2004 18:09:44 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040512180944.A31062@infradead.org>
References: <40A255D5.3090602@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <40A255D5.3090602@acm.org>; from stratus@acm.org on Wed, May 12, 2004 at 01:50:29PM -0300
To: Gustavo Franco <stratus@acm.org>
Cc: linux-raid@vger.kernel.org, linux-xfs@oss.sgi.com
List-Id: linux-raid.ids

On Wed, May 12, 2004 at 01:50:29PM -0300, Gustavo Franco wrote:
> I've already reported[0] my problem on Apr 12, with few details on
> lkml.Since then, only Steve Lord (xfs) have replied to me writing that
> Christoph was looking into it.I'll explain my problem here again, since
> with my new tests i can see clearly that it isn't a xfs problem.I just don't
> known if it's a hardware, software raid or libata problem.

The thing at [0] certainly is not a raid problem.  Most likely it's a
XFS problem although there's a small but non-zero chance that either
the VFS or nfsd are at fault.  I currently have a bunch of more important
issue on my plate, but for now the patch at:

	http://oss.sgi.com/bugzilla/attachment.cgi?id=108&action=view

should fix it at the cost of slower deletions.

