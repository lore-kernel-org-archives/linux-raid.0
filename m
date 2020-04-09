From: Song Liu <song@kernel.org>
Subject: Re: [PATCH 0/4] md: fix lockdep warning
Date: Thu, 9 Apr 2020 00:25:13 -0700
Message-ID: <CAPhsuW4rWa_ZCX=3eW9Xk_jtZdu+uKX4HZtbfEJfS9ms4a+OSg@mail.gmail.com>
References: <20200404215711.4272-1-guoqing.jiang@cloud.ionos.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200404215711.4272-1-guoqing.jiang@cloud.ionos.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Cc: Song Liu <songliubraving@fb.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thanks for the fix!

On Sat, Apr 4, 2020 at 3:01 PM Guoqing Jiang
<guoqing.jiang@cloud.ionos.com> wrote:
>
> Hi,
>
> After LOCKDEP is enabled, we can see some deadlock issues, this patchset
> makes workqueue is flushed only necessary, and the last patch is a cleanup.
>
> Thanks,
> Guoqing
>
> Guoqing Jiang (5):
>   md: add checkings before flush md_misc_wq
>   md: add new workqueue for delete rdev
>   md: don't flush workqueue unconditionally in md_open
>   md: flush md_rdev_misc_wq for HOT_ADD_DISK case
>   md: remove the extra line for ->hot_add_disk

I think we will need a new workqueue (2/5). But I am not sure about
whether we should
do 1/5 and 3/5. It feels like we are hiding errors from lock_dep. With
some quick grep,
I didn't find code pattern like

       if (work_pending(XXX))
               flush_workqueue(XXX);

Is it possible to fix the issue without these workaround?

Thanks,
Song
