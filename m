From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH] imsm: do not activate spares for uninitialized member arrays
Date: Thu, 15 Sep 2016 12:16:35 -0400
Message-ID: <wrfjk2edxhng.fsf@redhat.com>
References: <20160915075358.16948-1-artur.paszkiewicz@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160915075358.16948-1-artur.paszkiewicz@intel.com> (Artur
        Paszkiewicz's message of "Thu, 15 Sep 2016 09:53:58 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Artur Paszkiewicz <artur.paszkiewicz@intel.com> writes:
> This fixes some issues when a member array is created with "missing"
> devices in a container that has more devices than used in the member
> array.
>
> Reported-by: Yi Zhang <yizhan@redhat.com>
> Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> ---
>  super-intel.c | 5 +++++
>  1 file changed, 5 insertions(+)

Applied!

Thanks,
Jes

> diff --git a/super-intel.c b/super-intel.c
> index 92817e9..032ef00 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -7789,6 +7789,11 @@ static struct mdinfo *imsm_activate_spare(struct active_array *a,
>  			IMSM_T_STATE_DEGRADED)
>  		return NULL;
>  
> +	if (get_imsm_map(dev, MAP_0)->map_state == IMSM_T_STATE_UNINITIALIZED) {
> +		dprintf("imsm: No spare activation allowed. Volume is not initialized.\n");
> +		return NULL;
> +	}
> +
>  	/*
>  	 * If there are any failed disks check state of the other volume.
>  	 * Block rebuild if the another one is failed until failed disks
