From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH] Change the option from NoUpdate to NodeNumUpdate
Date: Thu, 24 Mar 2016 12:33:45 -0400
Message-ID: <wrfjk2kr3keu.fsf@redhat.com>
References: <1458813635-14175-1-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1458813635-14175-1-git-send-email-gqjiang@suse.com> (Guoqing
	Jiang's message of "Thu, 24 Mar 2016 18:00:35 +0800")
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Guoqing Jiang <gqjiang@suse.com> writes:
> Actually, we need to use NodeNumUpdate here to
> ensure there are enough spaces for those nodes.
>
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> ---
>  Grow.c   | 2 +-
>  super1.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Applied!

Thanks,
Jes
