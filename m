From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 2/2] Remove dead code about LKF_CONVERT flag
Date: Mon, 07 Mar 2016 15:54:17 -0500
Message-ID: <wrfjio0yj9fq.fsf@redhat.com>
References: <1457343063-14884-1-git-send-email-gqjiang@suse.com>
	<1457343063-14884-2-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1457343063-14884-2-git-send-email-gqjiang@suse.com> (Guoqing
	Jiang's message of "Mon, 7 Mar 2016 17:31:03 +0800")
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: linux-raid@vger.kernel.org, rgoldwyn@suse.com, neilb@suse.de
List-Id: linux-raid.ids

Guoqing Jiang <gqjiang@suse.com> writes:
> Since flags is only set as LKF_NOQUEUE, the code
> with LKF_CONVERT flag should be delete.
>
> Reported-by: Jes Sorensen <Jes.Sorensen@redhat.com>
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> ---
>  mdadm.h | 1 -
>  util.c  | 8 --------
>  2 files changed, 9 deletions(-)

Applied!

For multi-patch series, would you mind adding a cover letter when you
post them? Then I can just respond to that if all patches are applied.

Thanks,
Jes
