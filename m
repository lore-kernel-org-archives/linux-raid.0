From: Neil Brown <neilb@suse.de>
Subject: Re: [mdadm PATCH 9/9] allow redefinition of VAR_RUN
Date: Wed, 3 Mar 2010 12:53:37 +1100
Message-ID: <20100303125337.41a844bf@notabene.brown>
References: <cover.1267282753.git.bluca@comedia.it>
	<20100228144123.GA24781@maude.comedia.it>
	<20100228144616.GH24781@maude.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100228144616.GH24781@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: Luca Berra <bluca@comedia.it>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, 28 Feb 2010 15:46:16 +0100
Luca Berra <bluca@comedia.it> wrote:

> having mdmon socket under var is painful at shutdown time

Thanks.  I have applied this after some minor modifications, just as
removing the "ifdef" stuff from Makefile and adding some commentary.

Thanks,
NeilBrown


> 
> Signed-off-by: Luca Berra <bluca@comedia.it>
> ---
>   Makefile |    8 ++++++--
>   mdadm.h  |    2 ++
>   mdmon.c  |    3 ---
>   3 files changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 1836b4b..1fffb26 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -62,9 +62,13 @@ CONFFILEFLAGS = -DCONFFILE=\"$(CONFFILE)\" -DCONFFILE2=\"$(CONFFILE2)\"
>   # from early boot to late boot.
>   # If you don't have /lib/init/rw you might want to use /dev/.something
>   #  e.g. make ALT_RUN=/dev/.mdadm
> -ALT_RUN = /lib/init/rw
> +ifdef ALT_RUN
>   ALTFLAGS = -DALT_RUN=\"$(ALT_RUN)\"
> -CFLAGS = $(CWFLAGS) $(CXFLAGS) -DSendmail=\""$(MAILCMD)"\" $(CONFFILEFLAGS) $(ALTFLAGS)
> +endif
> +ifdef VAR_RUN
> +VARFLAGS = -DVAR_RUN=\"$(VAR_RUN)\"
> +endif
> +CFLAGS = $(CWFLAGS) $(CXFLAGS) -DSendmail=\""$(MAILCMD)"\" $(CONFFILEFLAGS) $(ALTFLAGS) $(VARFLAGS)
>   
>   # If you want a static binary, you might uncomment these
>   # LDFLAGS = -static
> diff --git a/mdadm.h b/mdadm.h
> index 825e3c2..2ad4a0e 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -68,7 +68,9 @@ extern __off64_t lseek64 __P ((int __fd, __off64_t __offset, int __whence));
>   #define DEFAULT_BITMAP_DELAY 5
>   #define DEFAULT_MAX_WRITE_BEHIND 256
>   
> +#ifndef VAR_RUN
>   #define VAR_RUN "/var/run/mdadm"
> +#endif /* VAR_RUN */
>   /* ALT_RUN should be somewhere that persists across the pivotroot
>    * from early boot to late boot.
>    * If you don't have /lib/init/rw you might want to use /dev/.something
> diff --git a/mdmon.c b/mdmon.c
> index b823a8c..6570637 100644
> --- a/mdmon.c
> +++ b/mdmon.c
> @@ -477,9 +477,6 @@ static int mdmon(char *devname, int devnum, int must_fork, int takeover)
>   		remove_pidfile(devname);
>   	}
>   	if (mkdir(VAR_RUN, 0600) >= 0 || (errno == EEXIST && access(VAR_RUN, W_OK) >= 0)) {
> -		/* try to clean up when we are finished with ALT_RUN dir */
> -		if (pid_dir != NULL)
> -			rmdir(pid_dir);
>   		pid_dir = VAR_RUN;
>   		remove_pidfile(devname);
>   	}

