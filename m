From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH v2 05/13] md: raid1: simplify r1buf_pool_free()
Date: Fri, 3 Mar 2017 09:57:42 +0800
Message-ID: <CACVXFVN8sA9ihdZ6hKS7ebFC7+eVsh-FL03Kh5=U42mp0U8GRQ@mail.gmail.com>
References: <1488296503-4987-1-git-send-email-tom.leiming@gmail.com>
 <1488296503-4987-6-git-send-email-tom.leiming@gmail.com> <20170228233105.npftquaf3fr5sfpl@kernel.org>
 <CACVXFVO3Nk4NgwTyD5eY9fYHAoshbGx=vnTFFQ_VpmED55=Bjg@mail.gmail.com> <20170302174942.ad3lsrqgvi2erkrl@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170302174942.ad3lsrqgvi2erkrl@kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Jens Axboe <axboe@fb.com>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-raid.ids

On Fri, Mar 3, 2017 at 1:49 AM, Shaohua Li <shli@kernel.org> wrote:
> On Thu, Mar 02, 2017 at 10:11:54AM +0800, Ming Lei wrote:
>> Hi Shaohua,
>>
>> On Wed, Mar 1, 2017 at 7:31 AM, Shaohua Li <shli@kernel.org> wrote:
>> > On Tue, Feb 28, 2017 at 11:41:35PM +0800, Ming Lei wrote:
>> >> This patch gets each page's reference of each bio for resync,
>> >> then r1buf_pool_free() gets simplified a lot.
>> >>
>> >> The same policy has been taken in raid10's buf pool allocation/free
>> >> too.
>> >
>> > We are going to delete the code, this simplify isn't really required.
>>
>> Could you explain it a bit? Or I can put this patch into this patchset if you
>> can provide one?
>
> I mean you will replace the code soon, with the resync_pages stuff. So I
> thought this isn't really required.

OK,  one benefit of this patch is to make the following one easier to review,
but not a big deal, I may merge this into the following patch.


Thanks,
Ming Lei
