From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH v1 02/14] block: introduce bio_remove_last_page()
Date: Tue, 28 Feb 2017 20:18:53 +0800
Message-ID: <CACVXFVOzaZ70UB8+1WM1Xukb=PRi9-C13GSDy8YtQda+WMrOSA@mail.gmail.com>
References: <1487950971-1131-1-git-send-email-tom.leiming@gmail.com>
 <1487950971-1131-3-git-send-email-tom.leiming@gmail.com> <20170225182306.GC26447@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170225182306.GC26447@infradead.org>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@fb.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Feb 26, 2017 at 2:23 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, Feb 24, 2017 at 11:42:39PM +0800, Ming Lei wrote:
>> MD need this helper to remove the last added page, so introduce
>> it.
>
> If MD really has a valid use case for this it should open code the
> operation.  The semantics look deeply fishy to me.

Thinking about MD's case further, and looks bio_add_page() won't
fail at all in case that queue's limit isn't applied in bio_add_page()
in future.

So I will change MD's handling in this case and avoid to introduce
bio_remove_last_page() in V2.

Thanks,
Ming Lei
