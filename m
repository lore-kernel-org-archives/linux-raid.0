From: Christoph Hellwig <hch@lst.de>
Subject: Re: [Fwd: "Enhanced" MD code avaible for review]
Date: Wed, 17 Mar 2004 19:37:56 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040317183756.GA23667@lst.de>
References: <405899E8.8070806@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <405899E8.8070806@pobox.com>
To: justin_gibbs@adaptec.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Mar 17, 2004 at 01:33:12PM -0500, Jeff Garzik wrote:
> A patch to fs/partitions/check.c is also required for this
> release to function correctly:
> 
> 	
> http://people.freebsd.org/~gibbs/linux/SRC/md_announce_whole_device.diff

Vetoed.  Kernel-level autodetection code is deprecated already, don't
even try to add functionality for it.

As for the actual code please post diffs instead of tarballs.

