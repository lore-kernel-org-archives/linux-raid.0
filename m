From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.32.3 x86_64 - XFS hangs, all I/O to D-state bug (again)
Date: Thu, 11 Feb 2010 09:56:32 -0500
Message-ID: <20100211145632.GA16912@infradead.org>
References: <alpine.DEB.2.00.1002110903080.25392@p34.internal.lan> <20100211145123.GA13114@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100211145123.GA13114@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com, Alan Piszcz <ap@solarrain.com>
List-Id: linux-raid.ids

On Thu, Feb 11, 2010 at 09:51:23AM -0500, Christoph Hellwig wrote:
> Can you check if this still happens with the patch below?

Or the 2.6.32 variant of it:

Index: xfs/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_buf.c	2010-02-11 15:52:14.442003504 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_buf.c	2010-02-11 15:52:33.172024387 +0100
@@ -1182,8 +1182,7 @@ _xfs_buf_ioapply(
 		bp->b_flags &= ~_XBF_RUN_QUEUES;
 		rw = (bp->b_flags & XBF_WRITE) ? WRITE_SYNC : READ_SYNC;
 	} else {
-		rw = (bp->b_flags & XBF_WRITE) ? WRITE :
-		     (bp->b_flags & XBF_READ_AHEAD) ? READA : READ;
+		rw = (bp->b_flags & XBF_WRITE) ? WRITE : READ;
 	}
 
 	/* Special code path for reading a sub page size buffer in --
