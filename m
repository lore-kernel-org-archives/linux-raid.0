From: Luca Berra <bluca@comedia.it>
Subject: Re: [mdadm PATCH 1/2] fix mdmon option parsing
Date: Sat, 27 Feb 2010 16:21:02 +0100
Message-ID: <20100227152102.GA20936@maude.comedia.it>
References: <cover.1267282753.git.bluca@comedia.it> <1-2.1267282753.git.bluca@comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1-2.1267282753.git.bluca@comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Cc: "Neil Brown (neilb@suse.de)" <neilb@suse.de>
List-Id: linux-raid.ids

On Sat, Feb 27, 2010 at 04:07:04PM +0100, Luca Berra wrote:
> --- a/mdmon.c
> +++ b/mdmon.c
> @@ -244,7 +244,7 @@ static int do_fork(void)
>   void usage(void)
>  {
> -	fprintf(stderr, "Usage: mdmon /device/name/for/container [target_dir]\n");
> +	fprintf(stderr, "Usage: mdmon [--all] [--takeover] CONTAINER");
oops, i missed a "\n" above
>  	exit(2);
>  }
>  @@ -262,15 +262,20 @@ int main(int argc, char *argv[])

-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
