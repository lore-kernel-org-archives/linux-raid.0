From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH 2/2] mdadm/manpage:clustered array doesn't support
 --array-size yet
Date: Tue, 11 Apr 2017 10:49:45 -0400
Message-ID: <1d2103a9-a7f2-54f8-ec51-ad0a04c6d9ae@gmail.com>
References: <1491811296-9118-1-git-send-email-zlliu@suse.com>
 <1491811478-9234-1-git-send-email-zlliu@suse.com>
 <1491811478-9234-2-git-send-email-zlliu@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1491811478-9234-2-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/10/2017 04:04 AM, Zhilong Liu wrote:
> update man page for --array-size:
> clustered array isn't allowed to change array_sector by now.
>
> Signed-off-by: Zhilong Liu <zlliu@suse.com>
> ---
>  mdadm.8.in | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/mdadm.8.in b/mdadm.8.in
> index f006cf5..3555516 100644
> --- a/mdadm.8.in
> +++ b/mdadm.8.in
> @@ -541,6 +541,10 @@ A value of
>  restores the apparent size of the array to be whatever the real
>  amount of available space is.
>
> +The
> +.B clustered
> +array isn't supported this parameter yet.

Should this say "Clustered arrays do not support this parameter yet." ?

Thanks,
Jes


