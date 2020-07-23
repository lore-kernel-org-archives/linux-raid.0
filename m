From: Song Liu <song@kernel.org>
Subject: Re: [PATCH] md/raid5: use do_div() for 64 bit divisions
Date: Wed, 22 Jul 2020 22:54:37 -0700
Message-ID: <CAPhsuW7CmLH3c4gO+cGUVd8w6h1dbyHhF7RpqutbrK7ORf7R3g@mail.gmail.com>
References: <20200723032905.864569-1-yuyufen@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200723032905.864569-1-yuyufen@huawei.com>
Sender: linux-raid-owner@vger.kernel.org
To: Yufen Yu <yuyufen@huawei.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Jul 22, 2020 at 8:28 PM Yufen Yu <yuyufen@huawei.com> wrote:
>
> On 32-bit architectures (e.g. m68k):
>
>   ERROR: modpost: "__udivdi3" [drivers/md/raid456.ko] undefined!
>
> Since 'sync_blocks' is defined as 64bit, we should use do_div() to
> fix this error.
>
> Signed-off-by: Yufen Yu <yuyufen@huawei.com>

I modified the commit log and applied it to md-next. In the future, please
add Fixes tag for bug fix.

Thanks,
Song
