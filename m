From: Ming Lei <ming.lei@redhat.com>
Subject: Re: I/O hangs after resuming from suspend-to-ram
Date: Wed, 30 Aug 2017 10:15:38 +0800
Message-ID: <20170830021537.GA4897@ming.t460p>
References: <3926917.BCSovyVWdL@natalenko.name>
 <1615033.Xza1AIGLzP@natalenko.name>
 <20170829002425.GA28904@ming.t460p>
 <2329566.kid2YYBOAQ@natalenko.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2329566.kid2YYBOAQ@natalenko.name>
Sender: linux-block-owner@vger.kernel.org
To: Oleksandr Natalenko <oleksandr@natalenko.name>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Shaohua Li <shli@kernel.org>
List-Id: linux-raid.ids

Hi,

On Tue, Aug 29, 2017 at 05:52:42PM +0200, Oleksandr Natalenko wrote:
> Hello.
> 
> Re-tested with v4.13-rc7 + proposed patch and got the same result.

Maybe there is another issue, I didn't use dmcrypt on raid10, will
test in your way to see if I can reproduce it.

BTW, could you share us which blk-mq scheduler you are using on sata?
The patch I posted should address one issue on none scheduler.


-- 
Ming
