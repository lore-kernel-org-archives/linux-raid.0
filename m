From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH v1 1/5] block: introduce bio_clone_bioset_partial()
Date: Tue, 14 Feb 2017 09:04:26 +0800
Message-ID: <CACVXFVNN3Gtm4Ut5KCmx8REbMYnh3Y2+sAZPto7F40fvGyZ=zw@mail.gmail.com>
References: <1486724177-14817-1-git-send-email-tom.leiming@gmail.com>
 <1486724177-14817-2-git-send-email-tom.leiming@gmail.com> <20170213134654.GB22818@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170213134654.GB22818@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@fb.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, NeilBrown <neilb@suse.com>
List-Id: linux-raid.ids

On Mon, Feb 13, 2017 at 9:46 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, Feb 10, 2017 at 06:56:13PM +0800, Ming Lei wrote:
>> md still need bio clone(not the fast version) for behind write,
>> and it is more efficient to use bio_clone_bioset_partial().
>>
>> The idea is simple and just copy the bvecs range specified from
>> parameters.
>
> Given how few users bio_clone_bioset has I wonder if we shouldn't
> simply add the two new arguments to it instead of adding another
> indirection.

For md write-behind, looks we have to provide the two arguments,
could you explain a bit how we can do that by adding another indirection?

>
> Otherwise looks fine:
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

-- 
Ming Lei
