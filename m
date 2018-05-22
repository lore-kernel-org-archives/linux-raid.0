From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/12] block: convert bounce, q->bio_split to
 bioset_init()/mempool_init()
Date: Tue, 22 May 2018 03:08:45 -0700
Message-ID: <20180522100845.GA4477@infradead.org>
References: <20180520222558.7053-1-kent.overstreet@gmail.com>
 <20180520222558.7053-2-kent.overstreet@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180520222558.7053-2-kent.overstreet@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, axboe@kernel.dk, hch@infradead.org, colyli@suse.de, snitzer@redhat.com, darrick.wong@oracle.com, clm@fb.com, bacik@fb.com, linux-xfs@vger.kernel.org, drbd-dev@lists.linbit.com, linux-btrfs@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.com
List-Id: linux-raid.ids

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
