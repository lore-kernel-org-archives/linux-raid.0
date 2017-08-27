From: Ming Lei <ming.lei@redhat.com>
Subject: Re: I/O hangs after resuming from suspend-to-ram
Date: Sun, 27 Aug 2017 14:02:00 +0800
Message-ID: <20170827060200.GA30521@ming.t460p>
References: <3926917.BCSovyVWdL@natalenko.name>
 <2602983.s9jWEo5DpR@natalenko.name>
 <1579257.t1hTzJa9iD@natalenko.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1579257.t1hTzJa9iD@natalenko.name>
Sender: linux-block-owner@vger.kernel.org
To: Oleksandr Natalenko <oleksandr@natalenko.name>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Shaohua Li <shli@kernel.org>
List-Id: linux-raid.ids

On Sat, Aug 26, 2017 at 12:48:01PM +0200, Oleksandr Natalenko wrote:
> Quick update: reproduced on both v4.12.7 and v4.13.0-rc6.

BTW, given it hangs during resume, it isn't easy to collect debug
info, and there should have been lots useful info there.

You mentioned that you can reproduce it on QEMU, could you
share the exact raid10 setting? such as which disks behind
the raid10.

Or can you reproduce the issue without raid10 involved?

I will try to reproduce it in my VM if you may provide the
above info.

Thanks,
Ming
