From: jes.sorensen@gmail.com
Subject: Re: [PATCH v4] mdadm/r5cache: allow adding journal to array without journal
Date: Tue, 28 Mar 2017 14:15:23 -0400
Message-ID: <wrfjzig5fetg.fsf@gmail.com>
References: <20170328180444.3385563-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170328180444.3385563-1-songliubraving@fb.com> (Song Liu's
        message of "Tue, 28 Mar 2017 11:04:44 -0700")
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid@vger.kernel.org, shli@fb.com, neilb@suse.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org
List-Id: linux-raid.ids

Song Liu <songliubraving@fb.com> writes:
> Currently, --add-journal can be only used to recreate broken journal
> for arrays with journal since  creation. As the kernel code getting
> more mature, this constraint is no longer necessary.
>
> This patch allows --add-journal to add journal to array without
> journal.
>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  Manage.c   | 6 ------
>  mdadm.8.in | 5 ++---
>  2 files changed, 2 insertions(+), 9 deletions(-)

Applied!

Thanks,
Jes
