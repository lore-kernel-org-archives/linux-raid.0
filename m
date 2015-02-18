From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH] Revert "md: When RAID5 is dirty, force reconstruct-write instead of read-modify-write."
Date: Tue, 17 Feb 2015 20:08:36 -0500
Message-ID: <wrfj4mqkdo17.fsf@redhat.com>
References: <1424218444-4022-1-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1424218444-4022-1-git-send-email-Jes.Sorensen@redhat.com> (Jes
	Sorensen's message of "Tue, 17 Feb 2015 19:14:04 -0500")
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jes.Sorensen@redhat.com writes:
> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>
> This reverts commit a7854487cd7128a30a7f4f5259de9f67d5efb95f.
>
> The above patch would cause lockups of RAID4/5 arrays if a drive is
> going faulty during reconstruction.
>
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
> ---
>  drivers/md/raid5.c | 19 +++----------------
>  1 file changed, 3 insertions(+), 16 deletions(-)

Please ignore this one - per previous email, there is a better way<tm>

Cheers,
Jes

>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index aa76865..bc3a085 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -3159,25 +3159,12 @@ static void handle_stripe_dirtying(struct r5conf *conf,
>  				   int disks)
>  {
>  	int rmw = 0, rcw = 0, i;
> -	sector_t recovery_cp = conf->mddev->recovery_cp;
> -
> -	/* RAID6 requires 'rcw' in current implementation.
> -	 * Otherwise, check whether resync is now happening or should start.
> -	 * If yes, then the array is dirty (after unclean shutdown or
> -	 * initial creation), so parity in some stripes might be inconsistent.
> -	 * In this case, we need to always do reconstruct-write, to ensure
> -	 * that in case of drive failure or read-error correction, we
> -	 * generate correct data from the parity.
> -	 */
> -	if (conf->max_degraded == 2 ||
> -	    (recovery_cp < MaxSector && sh->sector >= recovery_cp)) {
> -		/* Calculate the real rcw later - for now make it
> +	if (conf->max_degraded == 2) {
> +		/* RAID6 requires 'rcw' in current implementation
> +		 * Calculate the real rcw later - for now fake it
>  		 * look like rcw is cheaper
>  		 */
>  		rcw = 1; rmw = 2;
> -		pr_debug("force RCW max_degraded=%u, recovery_cp=%llu sh->sector=%llu\n",
> -			 conf->max_degraded, (unsigned long long)recovery_cp,
> -			 (unsigned long long)sh->sector);
>  	} else for (i = disks; i--; ) {
>  		/* would I have to read this buffer for read_modify_write */
>  		struct r5dev *dev = &sh->dev[i];
