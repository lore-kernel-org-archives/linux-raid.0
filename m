From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 1/4 v2] mdadm: bad block support for external metadata - initialization
Date: Mon, 28 Nov 2016 08:34:28 -0500
Message-ID: <wrfjr35vpw2j.fsf@redhat.com>
References: <1477558425-13332-1-git-send-email-tomasz.majchrzak@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1477558425-13332-1-git-send-email-tomasz.majchrzak@intel.com>
        (Tomasz Majchrzak's message of "Thu, 27 Oct 2016 10:53:42 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tomasz Majchrzak <tomasz.majchrzak@intel.com> writes:
> If metadata handler provides support for bad blocks, tell md by writing
> 'external_bbl' to rdev state file (both on create and assemble),
> followed by a list of known bad blocks written via sysfs 'bad_blocks'
> file.
>
> Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
> Reviewed-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> ---
>  mdadm.h | 13 +++++++++++++
>  sysfs.c | 29 ++++++++++++++++++++++++++++-
>  2 files changed, 41 insertions(+), 1 deletion(-)

Hi Tomasz,

Most of this one looks fine, just one minor nit.

> diff --git a/mdadm.h b/mdadm.h
> index 0516c82..5156ea4 100755
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -237,6 +237,17 @@ struct dlm_lksb {
>  
>  extern const char Name[];
>  
> +struct md_bb_entry {
> +	unsigned long long sector;
> +	int length;
> +};
> +
> +struct md_bb {
> +	int supported;
> +	int count;
> +	struct md_bb_entry *entries;
> +};
> +
>  /* general information that might be extracted from a superblock */
>  struct mdinfo {
>  	mdu_array_info_t	array;
> @@ -311,6 +322,8 @@ struct mdinfo {
>  
>  	/* info read from sysfs */
>  	char		sysfs_array_state[20];
> +
> +	struct md_bb bb;
>  };
>  
>  struct createinfo {
> diff --git a/sysfs.c b/sysfs.c
> index d28e21a..c7a8e66 100644
> --- a/sysfs.c
> +++ b/sysfs.c
> @@ -50,8 +50,12 @@ void sysfs_free(struct mdinfo *sra)
>  		while (sra->devs) {
>  			struct mdinfo *d = sra->devs;
>  			sra->devs = d->next;
> +			if (d->bb.entries)
> +				free(d->bb.entries);
>  			free(d);
>  		}
> +		if (sra->bb.entries)
> +			free(sra->bb.entries);
>  		free(sra);
>  		sra = sra2;
>  	}

free() handles NULL pointers, so no need to check first.

Cheers,
Jes
