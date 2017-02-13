From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v1 3/5] md: fail if mddev->bio_set can't be created
Date: Mon, 13 Feb 2017 05:45:20 -0800
Message-ID: <20170213134520.GA22818@infradead.org>
References: <1486724177-14817-1-git-send-email-tom.leiming@gmail.com>
 <1486724177-14817-4-git-send-email-tom.leiming@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1486724177-14817-4-git-send-email-tom.leiming@gmail.com>
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, NeilBrown <neilb@suse.com>
List-Id: linux-raid.ids

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

but this really needs to be patch 2 in this series.
