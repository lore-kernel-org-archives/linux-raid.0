From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH] mdadm: add test case for raid5 write back cache
Date: Mon, 19 Dec 2016 10:08:28 -0500
Message-ID: <wrfj7f6wrm6r.fsf@redhat.com>
References: <20161216000016.3840135-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161216000016.3840135-1-songliubraving@fb.com> (Song Liu's
        message of "Thu, 15 Dec 2016 16:00:16 -0800")
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.com, shli@fb.com, liuzhengyuan@kylinos.cn, liuyun01@kylinos.cn
List-Id: linux-raid.ids

Song Liu <songliubraving@fb.com> writes:
> This test cases checks data integrity of raid5 write back cache
> under various scenarios:
>
> degraded mode, non-overwrite, raid-5/6.
>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  tests/21raid5cache | 87 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 87 insertions(+)
>  create mode 100644 tests/21raid5cache

Applied!

Thanks,
Jes
