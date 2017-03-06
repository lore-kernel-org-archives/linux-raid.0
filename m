From: jes.sorensen@gmail.com
Subject: Re: [MDADM PATCH 2/2] Specify suitable size when write to buffer
Date: Mon, 06 Mar 2017 16:21:54 -0500
Message-ID: <wrfjd1dum77x.fsf@gmail.com>
References: <1488348766-31087-1-git-send-email-xni@redhat.com>
        <1488348766-31087-3-git-send-email-xni@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1488348766-31087-3-git-send-email-xni@redhat.com> (Xiao Ni's
        message of "Wed, 1 Mar 2017 14:12:46 +0800")
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org, ncroxon@redhat.com
List-Id: linux-raid.ids

Xiao Ni <xni@redhat.com> writes:
> ---
>  Detail.c      | 2 +-
>  super-intel.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/Detail.c b/Detail.c
> index 509b0d4..f4d4241 100644
> --- a/Detail.c
> +++ b/Detail.c
> @@ -575,7 +575,7 @@ This is pretty boring
>  			printf("  Member Arrays :");
>  
>  			while (dir && (de = readdir(dir)) != NULL) {
> -				char path[200];
> +				char path[320];
>  				char vbuf[1024];
>  				int nlen = strlen(sra->sys_name);
>  				dev_t devid;
> diff --git a/super-intel.c b/super-intel.c
> index d5e9517..ea50265 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -1811,7 +1811,7 @@ static void examine_super_imsm(struct supertype *st, char *homehost)
>  	__u32 reserved = imsm_reserved_sectors(super, super->disks);
>  	struct dl *dl;
>  
> -	snprintf(str, MPB_SIG_LEN, "%s", mpb->sig);
> +	snprintf(str, MAX_SIGNATURE_LENGTH, "%s", mpb->sig);
>  	printf("          Magic : %s\n", str);
>  	snprintf(str, strlen(MPB_VERSION_RAID0), "%s", get_imsm_version(mpb));
>  	printf("        Version : %s\n", get_imsm_version(mpb));

Hi Xiao,

This is really two independent changes, so they should come in two
seperate patches. All the patches needs their own commit messages and
signed-off-by lines.

Thanks,
Jes
