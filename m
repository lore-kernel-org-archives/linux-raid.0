From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] block: Do a full clone when splitting discard bios
Date: Wed, 22 Jul 2015 10:17:41 -0700
Message-ID: <20150722171741.GA6415@infradead.org>
References: <005601d0c470ea860samsung.com>
 <1437566232-25422-1-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1437566232-25422-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: axboe@fb.com, linux-raid@vger.kernel.org, neilb@suse.de, Seunguk Shin <seunguk.shin@samsung.com>, Kent Overstreet <kent.overstreet@gmail.com>, stable@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jul 22, 2015 at 07:57:12AM -0400, Martin K. Petersen wrote:
> This fixes a data corruption bug when using discard on top of MD linear,
> raid0 and raid10 personalities.
> 
> Commit 20d0189b1012 "block: Introduce new bio_split()" permits sharing
> the bio_vec between the two resulting bios. That is fine for read/write
> requests where the bio_vec is immutable. For discards, however, we need
> to be able to attach a payload and update the bio_vec so the page can
> get mapped to a scatterlist entry. Therefore the bio_vec can not be
> shared when splitting discards and we must do a full clone.

Eww.  The magic discard payload comes bac to bite us again.  I wish
someone smarter than me could come up with a scheme to avoid this issue.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
