From: oleksandr@natalenko.name
Subject: Re: I/O hangs after resuming from suspend-to-ram
Date: Wed, 30 Aug 2017 12:58:21 +0200
Message-ID: <ae216831876b8b71ebc1590a44731db7@natalenko.name>
References: <3926917.BCSovyVWdL@natalenko.name>
 <1615033.Xza1AIGLzP@natalenko.name> <20170829002425.GA28904@ming.t460p>
 <2329566.kid2YYBOAQ@natalenko.name> <20170830021537.GA4897@ming.t460p>
 <20170830051725.GA5840@ming.t460p>
 <692537117e26fe71b5e07cd8c86b38e4@natalenko.name>
 <20170830080628.GA2402@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170830080628.GA2402@ming.t460p>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Shaohua Li <shli@kernel.org>
List-Id: linux-raid.ids

Hi.

So, current summary:

1) first patch + debug patch: I can reproduce the issue in wild, but not 
with pm_test set;
2) first patch + debug patch + second patch: I cannot reproduce issue at 
all, neither with "none", nor with "mq-deadline".

Thus, "blk-mq: align to legacy path for implementing blk_execute_rq" + 
"blk-mq: add requests in the tail of hctx->dispatch" look like a proper 
fix. Thanks for that!

> I setup dm-crypt on /dev/md0 directly, could you show me how to setup 
> lvm on raid10?

If still relevant, here is a layout:

===
sda                 8:0    0    8G  0 disk
|-sda1              8:1    0  128M  0 part   /boot/EFI
`-sda2              8:2    0  7.9G  0 part
   `-md0             9:0    0  7.9G  0 raid10
     `-system-root 253:0    0  7.9G  0 lvm    /
sdb                 8:16   0    8G  0 disk
|-sdb1              8:17   0  128M  0 part
`-sdb2              8:18   0  7.9G  0 part
   `-md0             9:0    0  7.9G  0 raid10
     `-system-root 253:0    0  7.9G  0 lvm    /
===

Anything else you'd like /me to test?

30.08.2017 10:06, Ming Lei написав:
> …SNIP…
> Please try the following patch and previous patch together and see
> if they make a difference:
> …SNIP…
