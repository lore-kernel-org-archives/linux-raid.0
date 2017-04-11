From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH] mdadm.c:fix compile warning "mdfd is uninitialized"
Date: Tue, 11 Apr 2017 11:28:14 -0400
Message-ID: <9ca1b4d6-12db-7618-602d-8b70ad8bcb33@gmail.com>
References: <016b495a-1361-0f29-0fcb-6af008625565@gmail.com>
 <1491799792-6974-1-git-send-email-zlliu@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1491799792-6974-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/10/2017 12:49 AM, Zhilong Liu wrote:
> Initialized the mdfd as -1 to prevent compile error
> of some compilers.
> For example, gcc version 4.8.5(SUSE Linux).
>
> Signed-off-by: Zhilong Liu <zlliu@suse.com>
> ---
>  mdadm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied!

Thanks,
Jes


