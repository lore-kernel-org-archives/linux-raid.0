From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 1/1] Grow: close fd earlier to avoid "cannot get excl access" when stopping
Date: Fri, 11 Mar 2016 12:31:51 -0500
Message-ID: <wrfjr3fg7wfs.fsf@redhat.com>
References: <1457700547-13253-1-git-send-email-pawel.baldysiak@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1457700547-13253-1-git-send-email-pawel.baldysiak@intel.com>
	(Pawel Baldysiak's message of "Fri, 11 Mar 2016 13:49:07 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Pawel Baldysiak <pawel.baldysiak@intel.com>
Cc: linux-raid@vger.kernel.org, artur.paszkiewicz@intel.com
List-Id: linux-raid.ids

Pawel Baldysiak <pawel.baldysiak@intel.com> writes:
> If this file descriptor is not closed here, it remains open during
> reshape process and stopping process will end up with
> "cannot get exclusive access to container".
> Once this file descriptor is no longer needed - it can be closed.
>
> Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
> ---
>  Grow.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/Grow.c b/Grow.c
> index cf2750a..d9db00b 100755
> --- a/Grow.c
> +++ b/Grow.c
> @@ -2070,6 +2070,10 @@ size_change_error:
>  		 * number of devices (On-Line Capacity Expansion) must be
>  		 * performed at the level of the container
>  		 */
> +		if (fd > 0) {
> +			close(fd);
> +			fd = -1;
> +		}
>  		rv = reshape_container(container, devname, -1, st, &info,
>  				       c->force, c->backup_file, c->verbose, 0, 0, 0);
>  		frozen = 0;

I went in and looked at this one to see how we deal with the open file
descriptior. I was worried something else could try and access or close
it later, but it looks like we just let it dangle and rely on exit()
cleaning up. So I'll apply this one as is and hopefully someone will
feel excited enough about it to clean it up down the line ;)

Cheers,
Jes


