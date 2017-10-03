From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH] mdmon: get safe mode delay file descriptor early
Date: Tue, 3 Oct 2017 11:06:54 -0400
Message-ID: <f223d535-5fed-0c97-a7b2-6c4eb9e46484@gmail.com>
References: <1507026869-6415-1-git-send-email-tomasz.majchrzak@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1507026869-6415-1-git-send-email-tomasz.majchrzak@intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Majchrzak <tomasz.majchrzak@intel.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/03/2017 06:34 AM, Tomasz Majchrzak wrote:
> After switch root new mdmon is started. It sends initrd mdmon a signal
> to terminate. initrd mdmon receives it and switches the safe mode delay
> to 1 ms in order to get array to clean state and flush last version of
> metadata. The problem is sysfs filesystem is not available to initrd mdmon
> after switch root so the original safe mode delay is unchanged. The delay
> is set to few seconds - if there is a lot of traffic on the filesystem,
> initrd mdmon doesn't terminate for a long time (no clean state). There
> are 2 instances of mdmon. initrd mdmon flushes metadata when array goes
> to clean state but this metadata might be already outdated.
> 
> Use file descriptor obtained on mdmon start to change safe mode delay.
> 
> Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
> ---
>   managemon.c | 15 ++++++++++++---
>   mdmon.h     |  1 +
>   2 files changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/managemon.c b/managemon.c
> index 222e9ad..1c80510 100644
> --- a/managemon.c
> +++ b/managemon.c
> @@ -129,6 +129,8 @@ static void close_aa(struct active_array *aa)
>   		close(aa->metadata_fd);
>   	if (aa->sync_completed_fd >= 0)
>   		close(aa->sync_completed_fd);
> +	if (aa->safe_mode_delay_fd >= 0)
> +		close(aa->safe_mode_delay_fd);
>   }
>   
>   static void free_aa(struct active_array *aa)
> @@ -532,9 +534,14 @@ static void manage_member(struct mdstat_ent *mdstat,
>   	if (a->container == NULL)
>   		return;
>   
> -	if (sigterm && a->info.safe_mode_delay != 1) {
> -		sysfs_set_safemode(&a->info, 1);
> -		a->info.safe_mode_delay = 1;
> +	if (sigterm && a->info.safe_mode_delay != 1 &&
> +	    a->safe_mode_delay_fd >= 0) {
> +		long int new_delay = 1;
> +		char delay[10];
> +
> +		snprintf(delay, sizeof(delay), "0.%03ld\n", new_delay);
> +		if (write(a->safe_mode_delay_fd, delay, strlen(delay)))
> +			a->info.safe_mode_delay = new_delay;

I think overall strategy is fine here, however write returns -1 on 
error, so this piece isn't good.

Jes

