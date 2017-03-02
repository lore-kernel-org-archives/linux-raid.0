From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH v2 05/13] md: raid1: simplify r1buf_pool_free()
Date: Thu, 2 Mar 2017 10:11:54 +0800
Message-ID: <CACVXFVO3Nk4NgwTyD5eY9fYHAoshbGx=vnTFFQ_VpmED55=Bjg@mail.gmail.com>
References: <1488296503-4987-1-git-send-email-tom.leiming@gmail.com>
 <1488296503-4987-6-git-send-email-tom.leiming@gmail.com> <20170228233105.npftquaf3fr5sfpl@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170228233105.npftquaf3fr5sfpl@kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Jens Axboe <axboe@fb.com>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-raid.ids

Hi Shaohua,

On Wed, Mar 1, 2017 at 7:31 AM, Shaohua Li <shli@kernel.org> wrote:
> On Tue, Feb 28, 2017 at 11:41:35PM +0800, Ming Lei wrote:
>> This patch gets each page's reference of each bio for resync,
>> then r1buf_pool_free() gets simplified a lot.
>>
>> The same policy has been taken in raid10's buf pool allocation/free
>> too.
>
> We are going to delete the code, this simplify isn't really required.

Could you explain it a bit? Or I can put this patch into this patchset if you
can provide one?

Thanks,
Ming Lei
