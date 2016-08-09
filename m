From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH] Incremental: don't try to load_container() for a subarray
Date: Tue, 09 Aug 2016 10:58:10 -0400
Message-ID: <wrfjy446q9a5.fsf@redhat.com>
References: <20160809080551.2226-1-artur.paszkiewicz@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160809080551.2226-1-artur.paszkiewicz@intel.com> (Artur
	Paszkiewicz's message of "Tue, 9 Aug 2016 10:05:51 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Artur Paszkiewicz <artur.paszkiewicz@intel.com> writes:
> mdadm -IRs would exit with a non-zero status because of this.
>
> Reported-by: Xiao Ni <xni@redhat.com>
> Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> ---
>  Incremental.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)

Applied!

Thanks,
Jes

> diff --git a/Incremental.c b/Incremental.c
> index ba97b00..cc01d41 100644
> --- a/Incremental.c
> +++ b/Incremental.c
> @@ -1347,8 +1347,12 @@ restart:
>  
>  		if (devnm && strcmp(devnm, me->devnm) != 0)
>  			continue;
> -		if (devnm && me->metadata[0] == '/') {
> +		if (me->metadata[0] == '/') {
>  			char *sl;
> +
> +			if (!devnm)
> +				continue;
> +
>  			/* member array, need to work on container */
>  			strncpy(container, me->metadata+1, 32);
>  			container[31] = 0;
