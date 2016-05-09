From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH] super1: make the check for NodeNumUpdate more accurate
Date: Mon, 09 May 2016 15:01:24 -0400
Message-ID: <wrfjposvt5rv.fsf@redhat.com>
References: <1462760578-1429-1-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1462760578-1429-1-git-send-email-gqjiang@suse.com> (Guoqing
	Jiang's message of "Mon, 9 May 2016 10:22:58 +0800")
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Guoqing Jiang <gqjiang@suse.com> writes:
> We missed to check the version is BITMAP_MAJOR_CLUSTERED
> or not, otherwise mdadm can't create array with other 1.x
> metadatas (1.0 and 1.1).
>
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> ---
>  super1.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied!

Also applied the two patches from last week.

Thanks,
Jes
