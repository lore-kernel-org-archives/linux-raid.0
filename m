From: jes.sorensen@gmail.com
Subject: Re: [PATCH 1/2] mdadm/r5cache: allow adding journal to array without journal
Date: Fri, 17 Mar 2017 15:38:39 -0400
Message-ID: <wrfjtw6rk81s.fsf@gmail.com>
References: <20170315182850.3628010-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170315182850.3628010-1-songliubraving@fb.com> (Song Liu's
        message of "Wed, 15 Mar 2017 11:28:49 -0700")
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.com, kernel-team@fb.com
List-Id: linux-raid.ids

Song Liu <songliubraving@fb.com> writes:
> We use to apply constraints to --add-journal:
>   1. We only support recreate journal for arrays with missing journal;
>   2. The array need to be readonly when the journal is added.
>
> As the kernel code getting more mature, these constraints are no longer
> necessary. This patch removes this constraints from mdadm.
>
> Signed-off-by: Song Liu <songliubraving@fb.com>

Applied!

However, for multi-patch series, please always include a cover letter.
Just like with the kernel. Easier to repond to that than each patch
individually.

Thanks,
Jes
