From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v1 5/5] md: fast clone bio in bio_clone_mddev()
Date: Mon, 13 Feb 2017 05:49:45 -0800
Message-ID: <20170213134945.GE22818@infradead.org>
References: <1486724177-14817-1-git-send-email-tom.leiming@gmail.com>
 <1486724177-14817-6-git-send-email-tom.leiming@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1486724177-14817-6-git-send-email-tom.leiming@gmail.com>
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, NeilBrown <neilb@suse.com>
List-Id: linux-raid.ids

Please use bio_clone_fast directly and kill the wrapper.
