From: jes.sorensen@gmail.com
Subject: Re: [PATCH] mdadm/mdmon:deleted the abort_reshape never invoked
Date: Mon, 27 Mar 2017 18:16:59 -0400
Message-ID: <wrfjbmsmicv8.fsf@gmail.com>
References: <1489987284-22786-1-git-send-email-zlliu@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1489987284-22786-1-git-send-email-zlliu@suse.com> (Zhilong Liu's
        message of "Mon, 20 Mar 2017 13:21:24 +0800")
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Zhilong Liu <zlliu@suse.com> writes:
> mdmon.c: abort_reshape() has implemented in Grow.c,
> this function doesn't make a lot of sense here.
>
> Signed-off-by: Zhilong Liu <zlliu@suse.com>
> ---
>  mdmon.c | 5 -----
>  1 file changed, 5 deletions(-)

This used to be there for super-intel in mdmon, but is no longer needed.

Applied!

Thanks,
Jes
