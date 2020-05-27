From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH] Block overwriting existing links while manual assembly
Date: Wed, 27 May 2020 10:05:32 -0400
Message-ID: <1a2efdb3-e669-f4db-b718-7252dd9dde0c@gmail.com>
References: <20200527071443.20998-1-kinga.tanska@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200527071443.20998-1-kinga.tanska@intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Kinga Tanska <kinga.tanska@intel.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5/27/20 3:14 AM, Kinga Tanska wrote:
> Manual assembly with existing link caused overwriting
> this link. Add checking link and block this situation.
> 
> Change-Id: I29ef58636e8fd8583bcaef1b28b6cf2edec385ef
> Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
> ---
>  Assemble.c | 4 ++++
>  1 file changed, 4 insertions(+)

Looks fine to me, but what is that non-standard Change-Id: tag you added?

Thanks,
Jes

> diff --git a/Assemble.c b/Assemble.c
> index 6b5a7c8e..92616251 100644
> --- a/Assemble.c
> +++ b/Assemble.c
> @@ -1482,6 +1482,10 @@ try_again:
>  				name = content->name;
>  			break;
>  		}
> +		if (mddev && map_by_name(&map, mddev) != NULL) {
> +			pr_err("Cannot create device with %s because is in use\n", mddev);
> +			goto out;
> +		}
>  		if (!auto_assem)
>  			/* If the array is listed in mdadm.conf or on
>  			 * command line, then we trust the name
> 
