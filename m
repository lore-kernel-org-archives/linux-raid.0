From: Neil Brown <neilb@suse.de>
Subject: Re: [[Patch mdadm] 3/5] We don't like %02d as a metadata format
 specifier, it confuses us when we read the output back later
Date: Tue, 19 Jan 2010 11:02:09 +1300
Message-ID: <20100119110209.3aa70c92@notabene>
References: <1263242294-5353-1-git-send-email-dledford@redhat.com>
	<1263242294-5353-4-git-send-email-dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1263242294-5353-4-git-send-email-dledford@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org, Doug Ledford <dledford@redhat.com>
List-Id: linux-raid.ids

On Mon, 11 Jan 2010 15:38:12 -0500
Doug Ledford <dledford@redhat.com> wrote:

> Signed-off-by: Doug Ledford <dledford@redhat.com>

Applied, thanks.

NeilBrown


> ---
>  Detail.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/Detail.c b/Detail.c
> index 0e47a05..ba07c83 100644
> --- a/Detail.c
> +++ b/Detail.c
> @@ -174,7 +174,7 @@ int Detail(char *dev, int brief, int export, int test, char *homehost)
>  			if (sra && sra->array.major_version < 0)
>  				printf("MD_METADATA=%s\n", sra->text_version);
>  			else
> -				printf("MD_METADATA=%d.%02d\n",
> +				printf("MD_METADATA=%d.%d\n",
>  				       array.major_version, array.minor_version);
>  		}
>  		
> @@ -226,7 +226,7 @@ int Detail(char *dev, int brief, int export, int test, char *homehost)
>  			if (sra && sra->array.major_version < 0)
>  				printf(" metadata=%s", sra->text_version);
>  			else
> -				printf(" metadata=%d.%02d",
> +				printf(" metadata=%d.%d",
>  				       array.major_version, array.minor_version);
>  		}
>  
> @@ -259,7 +259,7 @@ int Detail(char *dev, int brief, int export, int test, char *homehost)
>  		if (sra && sra->array.major_version < 0)
>  			printf("        Version : %s\n", sra->text_version);
>  		else
> -			printf("        Version : %d.%02d\n",
> +			printf("        Version : %d.%d\n",
>  			       array.major_version, array.minor_version);
>  		}
>  

