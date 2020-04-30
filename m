From: Song Liu <song@kernel.org>
Subject: Re: [PATCH v2 0/4] improve memalloc scope APIs usage
Date: Wed, 29 Apr 2020 23:49:39 -0700
Message-ID: <CAPhsuW5EBYxNu2fqDO_jPbSuiGyUF5qgUCSLJYPAr2b6VPSytQ@mail.gmail.com>
References: <20200409115258.19330-1-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200409115258.19330-1-colyli@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: Song Liu <songliubraving@fb.com>, linux-raid <linux-raid@vger.kernel.org>, mhocko@suse.com, kent.overstreet@gmail.com, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
List-Id: linux-raid.ids

On Thu, Apr 9, 2020 at 4:53 AM <colyli@suse.de> wrote:
>
> From: Coly Li <colyli@suse.de>
>
> Hi folks,
>
> The motivation of this series is to fix the incorrect GFP_NOIO flag
> usage in drivers/md/raid5.c:resize_chunks(). I take the suggestion
> from Michal Hocko to use memalloc scope APIs in unified entry point
> mddev_suspend()/mddev_resume(). Also I get rid of the incorect GFP_NOIO
> usage for scribble_alloc(), and remove redundant memalloc scope APIs
> usage in mddev_create_serial_pool(), also as Song Liu suggested, update
> the code comments on the header of scribble_alloc().
>
> Thank you in advance for the review and comments.
>
> Coly Li

Applied to md-next. Thanks for the fix. And Thanks Michal and Guoqing
for great inputs.

Song
