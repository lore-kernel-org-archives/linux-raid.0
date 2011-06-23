From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/4] mdadm.8: change linux version 2.6.40 -> 3.0
Date: Thu, 23 Jun 2011 11:41:22 +1000
Message-ID: <20110623114122.716cb9cf@notabene.brown>
References: <1308673145-8151-1-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1308673145-8151-1-git-send-email-namhyung@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 22 Jun 2011 01:19:02 +0900 Namhyung Kim <namhyung@gmail.com> wrote:

> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  Grow.c     |    2 +-
>  mdadm.8.in |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Grow.c b/Grow.c
> index 6e31b94..a4092b5 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -1494,7 +1494,7 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
>  			goto release;
>  		}
>  		if (assume_clean) {
> -			/* This will fail on kernels newer than 2.6.40 unless
> +			/* This will fail on kernels newer than 3.0 unless
>  			 * a backport has been arranged.
>  			 */
>  			if (sra == NULL ||
> diff --git a/mdadm.8.in b/mdadm.8.in
> index d2d7ef2..44accc0 100644
> --- a/mdadm.8.in
> +++ b/mdadm.8.in
> @@ -706,7 +706,7 @@ facts the operator knows.
>  When an array is resized to a larger size with
>  .B "\-\-grow \-\-size="
>  the new space is normally resynced in that same way that the whole
> -array is resynced at creation.  From Linux version 2.6.40,
> +array is resynced at creation.  From Linux version 3.0,
>  .B \-\-assume\-clean
>  can be used with that command to avoid the automatic resync.
>  


Thanks for this and the other 3.  They are all applied and pushed out on my
'master' branch.

Thanks,
NeilBrown

