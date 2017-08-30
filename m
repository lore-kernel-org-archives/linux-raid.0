From: Ming Lei <ming.lei@redhat.com>
Subject: Re: I/O hangs after resuming from suspend-to-ram
Date: Wed, 30 Aug 2017 22:37:58 +0800
Message-ID: <20170830143752.GA14684@ming.t460p>
References: <3926917.BCSovyVWdL@natalenko.name>
 <1615033.Xza1AIGLzP@natalenko.name>
 <20170829002425.GA28904@ming.t460p>
 <2329566.kid2YYBOAQ@natalenko.name>
 <20170830021537.GA4897@ming.t460p>
 <20170830051725.GA5840@ming.t460p>
 <692537117e26fe71b5e07cd8c86b38e4@natalenko.name>
 <20170830080628.GA2402@ming.t460p>
 <ae216831876b8b71ebc1590a44731db7@natalenko.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ae216831876b8b71ebc1590a44731db7@natalenko.name>
Sender: linux-kernel-owner@vger.kernel.org
To: oleksandr@natalenko.name
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Shaohua Li <shli@kernel.org>
List-Id: linux-raid.ids

Hi,

On Wed, Aug 30, 2017 at 12:58:21PM +0200, oleksandr@natalenko.name wrote:
> Hi.
> 
> So, current summary:
> 
> 1) first patch + debug patch: I can reproduce the issue in wild, but not
> with pm_test set;

That is interesting, since I always test via pm_test.

> 2) first patch + debug patch + second patch: I cannot reproduce issue at
> all, neither with "none", nor with "mq-deadline".
> 
> Thus, "blk-mq: align to legacy path for implementing blk_execute_rq" +
> "blk-mq: add requests in the tail of hctx->dispatch" look like a proper fix.
> Thanks for that!

That is great, will prepare a formal one for merge.

> 
> > I setup dm-crypt on /dev/md0 directly, could you show me how to setup
> > lvm on raid10?
> 
> If still relevant, here is a layout:

Looks not relevant, just because I use pm_test.

> 
> ===
> sda                 8:0    0    8G  0 disk
> |-sda1              8:1    0  128M  0 part   /boot/EFI
> `-sda2              8:2    0  7.9G  0 part
>   `-md0             9:0    0  7.9G  0 raid10
>     `-system-root 253:0    0  7.9G  0 lvm    /
> sdb                 8:16   0    8G  0 disk
> |-sdb1              8:17   0  128M  0 part
> `-sdb2              8:18   0  7.9G  0 part
>   `-md0             9:0    0  7.9G  0 raid10
>     `-system-root 253:0    0  7.9G  0 lvm    /
> ===
> 
> Anything else you'd like /me to test?

You have done enough, thanks a lot for your report and test!


-- 
Ming
