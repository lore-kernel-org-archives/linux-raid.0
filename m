From: Andrew Burgess <andrew.burgess@embecosm.com>
Subject: Re: [PATCH] Fix minor typo in mdadm manpage.
Date: Fri, 22 May 2015 13:26:39 +0200
Message-ID: <20150522112639.GL2880@embecosm.com>
References: <1427303869-17319-1-git-send-email-andrew.burgess@embecosm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1427303869-17319-1-git-send-email-andrew.burgess@embecosm.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

* Andrew Burgess <andrew.burgess@embecosm.com> [2015-03-25 17:17:49 +0000]:

> ---
> Change 'is and of' to 'is one of' in mdadm manual page.

Ping! Any interest?

Thanks,
Andrew


> Signed-off-by: Andrew Burgess <andrew.burgess@embecosm.com>
> ---
>  mdadm.8.in | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mdadm.8.in b/mdadm.8.in
> index a630310..b4a21d9 100644
> --- a/mdadm.8.in
> +++ b/mdadm.8.in
> @@ -214,7 +214,7 @@ to detect and assemble arrays \(em possibly in an
>  
>  .P
>  If a device is given before any options, or if the first option is
> -and of
> +one of
>  .BR \-\-add ,
>  .BR \-\-re\-add ,
>  .BR \-\-add\-spare ,
> -- 
> 2.2.2
> 
