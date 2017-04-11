From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH 1/2] mdadm/manpage:update description for readonly in
 manpage
Date: Tue, 11 Apr 2017 10:51:47 -0400
Message-ID: <6afe1397-3063-c5d7-58ba-f3dbdfa05336@gmail.com>
References: <1491811296-9118-1-git-send-email-zlliu@suse.com>
 <1491811478-9234-1-git-send-email-zlliu@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1491811478-9234-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/10/2017 04:04 AM, Zhilong Liu wrote:
> update readonly/readwrite in man page:
> Currently both the readwrite and readonly are worked well,
> thus updates description for them.
>
> Signed-off-by: Zhilong Liu <zlliu@suse.com>
> ---
>  mdadm.8.in | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)

A couple of comments below.

>  .TP
>  .B \-\-readonly
> -start the array readonly \(em not supported yet.
> +start the array with readonly status.

I believe it would be more correct to say "start the array in readonly 
mode" here.

>  .SH MANAGE MODE
>  .HP 12
> @@ -2438,12 +2439,11 @@ This will fully activate a partially assembled md array.
>
>  .TP
>  .B \-\-readonly
> -This will mark an active array as read-only, providing that it is
> -not currently being used.
> +This will set an active array as read-only status.

I think this chance is not good, and should be omitted.

>  .TP
>  .B \-\-readwrite
> -This will change a
> +This will change an
>  .B readonly
>  array back to being read/write.

This change is grammatically incorrect I believe and the original text 
is correct.

Thanks,
Jes

