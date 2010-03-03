From: Neil Brown <neilb@suse.de>
Subject: Re: [mdadm PATCH 4/9] mdmon: check select a writable pid_dir
Date: Wed, 3 Mar 2010 12:07:14 +1100
Message-ID: <20100303120714.5577d74c@notabene.brown>
References: <cover.1267282753.git.bluca@comedia.it>
	<20100228144123.GA24781@maude.comedia.it>
	<20100228144257.GC24781@maude.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100228144257.GC24781@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: Luca Berra <bluca@comedia.it>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, 28 Feb 2010 15:42:57 +0100
Luca Berra <bluca@comedia.it> wrote:

> Check that either VAR_DIR or ALT_DIR is actually writable before
> selecting it.

Why would e.g. /var/run/mdadm exist but not be writable?  Sounds like a
serious mis-configuration.

Nevertheless, it is safer this way.
I personally avoid using 'access' unless I am running setuid and want to
check what the real-uid would be allowed to do, as that is what 'access'
is for.
So I changed this code to test writability by calling make_pidfile - i.e.
actually doing the write.

Thanks,
NeilBrown


> 
> Signed-off-by: Luca Berra <bluca@comedia.it>
> ---
>   mdmon.c |    4 ++--
>   1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mdmon.c b/mdmon.c
> index 11b4f32..57fd492 100644
> --- a/mdmon.c
> +++ b/mdmon.c
> @@ -480,9 +480,9 @@ static int mdmon(char *devname, int devnum, int must_fork, int takeover)
>   	 */
>   	if (victim > 0)
>   		remove_pidfile(devname);
> -	if (mkdir(VAR_RUN, 0600) >= 0 || errno == EEXIST)
> +	if (mkdir(VAR_RUN, 0600) >= 0 || (errno == EEXIST && access(VAR_RUN, W_OK) >= 0))
>   		pid_dir = VAR_RUN;
> -	else if (mkdir(ALT_RUN, 0600) >= 0 || errno == EEXIST)
> +	else if (mkdir(ALT_RUN, 0600) >= 0 || (errno == EEXIST && access(ALT_RUN, W_OK) >= 0))
>   		pid_dir = ALT_RUN;
>   	else {
>   		fprintf(stderr, "mdmon: Neither %s nor %s are writable\n"

