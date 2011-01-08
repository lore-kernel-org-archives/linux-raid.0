From: Christoph Hellwig <hch@lst.de>
Subject: Re: Patch to issue pure flushes directly (Was: Re: [PATCH v6 0/4] ext4: Coordinate data-only flush requests sent) by fsync
Date: Sat, 8 Jan 2011 08:45:24 +0100
Message-ID: <20110108074524.GA13024__49457.9765400433$1294472784$gmane$org@lst.de>
References: <20101129220536.12401.16581.stgit@elm3b57.beaverton.ibm.com> <20101130164124.GA30858@lst.de> <20110107235449.GT21922@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110107235449.GT21922@thunk.org>
Sender: linux-raid-owner@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>, Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@us.ibm.com>, Jens Axboe <axboe@kernel.dk>, Neil Brown <neilb@suse.de>, Andreas Dilger <adilger.ke>
List-Id: linux-raid.ids

On Fri, Jan 07, 2011 at 06:54:49PM -0500, Ted Ts'o wrote:
> This patch seemed like a good idea to me; I just checked linux-next,
> and looks like nothing like this is planned to be merged.  Just
> thought I would send a prod-o-gram to see what the current thinking
> was around adding something like this.

I haven't really gotten any feedback on the patch, so it fell on the
floor for a while.  I've managed to get some big system resources to
test the impact of it, and once I've got numbers I'll resend it as
separate patches for scsi and the block layer.

