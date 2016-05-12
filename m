From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH] super1: add more checks for NodeNumUpdate option
Date: Thu, 12 May 2016 15:45:24 -0400
Message-ID: <wrfjzirv83hn.fsf@redhat.com>
References: <1462959096-11272-1-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1462959096-11272-1-git-send-email-gqjiang@suse.com> (Guoqing
	Jiang's message of "Wed, 11 May 2016 17:31:36 +0800")
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Guoqing Jiang <gqjiang@suse.com> writes:
> There are some cases which didn't need to check the space
> is enough or not for NodeNumUpdate option.
>
> 1. for array which does not have clustered bitmap.
> 2. "--nodes" parameter is 0 (eg, add a disk to clustered raid).
> 3. if "--nodes" parameter is set to a smaller num than
>    current bms->nodes.
>
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> ---
>  super1.c | 22 +++++++++++++++++++---
>  1 file changed, 19 insertions(+), 3 deletions(-)

Applied!

Thanks,
Jes
