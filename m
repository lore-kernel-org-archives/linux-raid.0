From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v1 02/14] block: introduce bio_remove_last_page()
Date: Sat, 25 Feb 2017 10:23:06 -0800
Message-ID: <20170225182306.GC26447@infradead.org>
References: <1487950971-1131-1-git-send-email-tom.leiming@gmail.com>
 <1487950971-1131-3-git-send-email-tom.leiming@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1487950971-1131-3-git-send-email-tom.leiming@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
List-Id: linux-raid.ids

On Fri, Feb 24, 2017 at 11:42:39PM +0800, Ming Lei wrote:
> MD need this helper to remove the last added page, so introduce
> it.

If MD really has a valid use case for this it should open code the
operation.  The semantics look deeply fishy to me.
