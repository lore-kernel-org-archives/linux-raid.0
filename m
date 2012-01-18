From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: RE: [PATCH 2/4] Add --initrd argument to mdadm
Date: Wed, 18 Jan 2012 08:13:16 +0000
Message-ID: <79556383A0E1384DB3A3903742AAC04A06DAEE@IRSMSX101.ger.corp.intel.com>
References: <1326797330-4488-1-git-send-email-Jes.Sorensen@redhat.com>
 <1326797330-4488-3-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1326797330-4488-3-git-send-email-Jes.Sorensen@redhat.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "Jes.Sorensen@redhat.com" <Jes.Sorensen@redhat.com>, "neilb@suse.de" <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "dledford@redhat.com" <dledford@redhat.com>, "kay@redhat.com" <kay@redhat.com>, "harald@redhat.com" <harald@redhat.com>, "lpoetter@redhat.com" <lpoetter@redhat.com>, "mschmidt@redhat.com" <mschmidt@redhat.com>
List-Id: linux-raid.ids

Hi,

I think that '--initrd'  option should have '--freeze-reshape' option functionality for mdadm also.
To do this e.g.  proper variable (freeze_reshape in mdadm.c) should be set, when '--initrd' option is passed in command line.

BR
Adam

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Jes.Sorensen@redhat.com
> Sent: Tuesday, January 17, 2012 11:49 AM
> To: neilb@suse.de
> Cc: linux-raid@vger.kernel.org; dledford@redhat.com; kay@redhat.com;
> harald@redhat.com; lpoetter@redhat.com; mschmidt@redhat.com
> Subject: [PATCH 2/4] Add --initrd argument to mdadm
> 
> From: Jes Sorensen <Jes.Sorensen@redhat.com>
> 
> When --initrd is parsed, mdadm will change the first character of argv[0] to
> '@'. This is used to signal to systemd that mdadm was launched from
> initramfs and should not be shut down before returning to the initramfs.
> 
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
> ---
>  ReadMe.c |    3 +++
>  mdadm.c  |   10 ++++++++++
>  mdadm.h  |    1 +
>  3 files changed, 14 insertions(+), 0 deletions(-)
> 
> diff --git a/ReadMe.c b/ReadMe.c
> index 9aa798b..49dc04f 100644
> --- a/ReadMe.c
> +++ b/ReadMe.c
> @@ -111,6 +111,7 @@ struct option long_options[] = {
>      {"kill-subarray", 1, 0, KillSubarray},
>      {"update-subarray", 1, 0, UpdateSubarray},
>      {"udev-rules", 2, 0, UdevRules},
> +    {"initrd", 0, 0, InitrdOpt},
> 
>      /* synonyms */
>      {"monitor",   0, 0, 'F'},
> @@ -268,6 +269,8 @@ char OptionHelp[] =
>  "  --query       -Q   : Display general information about how a\n"
>  "                       device relates to the md driver\n"
>  "  --auto-detect      : Start arrays auto-detected by the kernel\n"
> +"  --initrd           : Set first character of argv[0] to @ to indicate the\n"
> +"                       application was launched from initrd.\n"
>  ;
>  /*
>  "\n"
> diff --git a/mdadm.c b/mdadm.c
> index f07fac2..c0ccf55 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -174,6 +174,16 @@ int main(int argc, char *argv[])
>  				homehost = optarg;
>  			continue;
> 
> +		/*
> +		 * --initrd sets first char of argv[0] to @. This is used
> +		 * by systemd to signal that the tast was launched from
> +		 * initrd/initramfs and should be preserved during shutdown
> +		 */
> +		case InitrdOpt:
> +			c = argv[0];
> +			c[0] = '@';
> +			continue;
> +
>  		case ':':
>  		case '?':
>  			fputs(Usage, stderr);
> diff --git a/mdadm.h b/mdadm.h
> index 381ef86..d1ac1e8 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -321,6 +321,7 @@ enum special_options {
>  	UdevRules,
>  	FreezeReshape,
>  	Continue,
> +	InitrdOpt,
>  };
> 
>  /* structures read from config file */
> --
> 1.7.8.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
