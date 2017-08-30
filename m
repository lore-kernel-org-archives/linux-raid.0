From: oleksandr@natalenko.name
Subject: Re: I/O hangs after resuming from suspend-to-ram
Date: Wed, 30 Aug 2017 08:15:02 +0200
Message-ID: <692537117e26fe71b5e07cd8c86b38e4@natalenko.name>
References: <3926917.BCSovyVWdL@natalenko.name>
 <1615033.Xza1AIGLzP@natalenko.name> <20170829002425.GA28904@ming.t460p>
 <2329566.kid2YYBOAQ@natalenko.name> <20170830021537.GA4897@ming.t460p>
 <20170830051725.GA5840@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170830051725.GA5840@ming.t460p>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Shaohua Li <shli@kernel.org>
List-Id: linux-raid.ids

Hello.

Addressing your questions below.

> Can't reproduce even with putting dmcypt on raid10 after applying my 
> patch.

Just a side note, that dm-crypt is not necessary here — I am able to 
trigger hang with RAID10 and LVM only.

> BTW, could you share us which blk-mq scheduler you are using on sata?

Okay, now it makes sense. Previously, without your patch I was able to 
reproduce the issue with "mq-deadline", "bfq" and "none". Now, I cannot 
trigger it with "none" set, but "mq-deadline" still hangs for me. Does 
this mean each scheduler should be modified separately?

> Could you apply the following debug patch and provide the dmesg log 
> after running the commands below?

Is it still relevant since I confirm issue to be fixed with "none"?

Thanks.

30.08.2017 07:17, Ming Lei написав:
> …SNIP…
> Can't reproduce even with putting dmcypt on raid10 after applying
> my patch.
> …SNIP…
