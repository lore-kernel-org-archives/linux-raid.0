From: Jes Sorensen <jsorensen@fb.com>
Subject: Re: [mdadm PATCH v3] To support clustered raid10
Date: Thu, 9 Nov 2017 11:56:55 -0500
Message-ID: <be7c2e16-436a-59e2-9d87-83cc2b773ec8@fb.com>
References: <1509354591-28264-1-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1509354591-28264-1-git-send-email-gqjiang@suse.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: linux-raid@vger.kernel.org, shli@kernel.org
List-Id: linux-raid.ids

On 10/30/2017 05:09 AM, Guoqing Jiang wrote:
> We are now considering to extend clustered raid to
> support raid10. But only near layout is supported,
> so make the check when create the array or switch
> the bitmap from internal to clustered.
> 
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> ---
>  Grow.c  |  6 ++++++
>  mdadm.c |  9 +++++++--
>  mdadm.h |  1 +
>  util.c  | 11 +++++++++++
>  4 files changed, 25 insertions(+), 2 deletions(-)

Applied!

Thanks,
Jes
