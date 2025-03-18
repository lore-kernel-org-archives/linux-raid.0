Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 226021F8729
	for <linux-raid@vger.kernel.org>; Tue, 18 Mar 2025 07:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742283990; cv=none; b=iL2vX2aIRICf6Xp9Lspz1wr3TY8P8EvpMTlfWsuB9ohVs5uWMXQJGsYoNWWInMCHykGBCIurc8TgyFObcfkuPpnkxY68646XpipM5938mc8HOFx0scMOiu5Qq3fjxWJ6bd8Wbe4A+dyqeX85NJLLCVxxEKQGjbwnwQzIaOMC4dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742283990; c=relaxed/simple;
	bh=RGkqWG2d8ZfZkUxoLTbC7fHvim+HJE5MM1/7bZ6833I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hRk1bSuyFop+Dm1FAK0yhvOfKo9L7LxXnGhvV+LVdHH0YbY4qInlw45gvzQs4UjimY9rorkZY49qR1EqlhrDJ+P8NwTq9aJXcCIuVz7++sHhxLt90Ko7adOS9seI3ngWp6I9R9wEHgkl+P1nODX4UhxKePheL048m7JuP0ort7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [192.168.0.2] (ip5f5af679.dynamic.kabel-deutschland.de [95.90.246.121])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 92FE561E6479F;
	Tue, 18 Mar 2025 08:38:19 +0100 (CET)
Message-ID: <a5cd31f5-b7b8-4859-9a8e-1ef58f3aee95@molgen.mpg.de>
Date: Tue, 18 Mar 2025 08:38:18 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mdadm: check posix name before setting name and
 devname
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org, ncroxon@redhat.com,
 mariusz.tkaczyk@linux.intel.com
References: <20250318054638.58276-1-xni@redhat.com>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20250318054638.58276-1-xni@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dear Xiao,


Thank you for the patch. Wasn’t a similar patch sent to the list already 
months ago?

For the commit message subject/title I suggest:

mdadm: Allow to assemble existing arrays with non-POSIX names

Am 18.03.25 um 06:46 schrieb Xiao Ni:
> It's good to has limitation for name when creating an array. But the arrays

… to have limitations …

> which were created before patch e2eb503bd797 (mdadm: Follow POSIX Portable
> Character Set) can't be assembled. In this patch, it removes the posix
> check for assemble mode.

“In this patch” is redundant in the commit message. Maybe:

So, remove the POSIX check for assemble mode.

Maybe add how to reproduce this? Is there a way to create a non-POSIX 
name with current mdadm, or should such a file be provided for tests.

> Fixes: e2eb503bd797 (mdadm: Follow POSIX Portable Character Set)
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>   config.c |  8 ++------
>   mdadm.c  | 11 +++++++++++
>   2 files changed, 13 insertions(+), 6 deletions(-)
> 
> diff --git a/config.c b/config.c
> index 8a8ae5e48c41..ef7dbc4eb29f 100644
> --- a/config.c
> +++ b/config.c
> @@ -208,11 +208,6 @@ static mdadm_status_t ident_check_name(const char *name, const char *prop_name,
>   		return MDADM_STATUS_ERROR;
>   	}
>   
> -	if (!is_name_posix_compatible(name)) {
> -		ident_log(prop_name, name, "Not POSIX compatible", cmdline);
> -		return MDADM_STATUS_ERROR;
> -	}
> -
>   	return MDADM_STATUS_SUCCESS;
>   }
>   
> @@ -512,7 +507,8 @@ void arrayline(char *line)
>   
>   	for (w = dl_next(line); w != line; w = dl_next(w)) {
>   		if (w[0] == '/' || strchr(w, '=') == NULL) {
> -			_ident_set_devname(&mis, w, false);
> +			if (is_name_posix_compatible(w))
> +				_ident_set_devname(&mis, w, false);
>   		} else if (strncasecmp(w, "uuid=", 5) == 0) {
>   			if (mis.uuid_set)
>   				pr_err("only specify uuid once, %s ignored.\n",
> diff --git a/mdadm.c b/mdadm.c
> index 6200cd0e7f9b..9d5b0e567799 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -732,6 +732,11 @@ int main(int argc, char *argv[])
>   				exit(2);
>   			}
>   
> +			if (mode != ASSEMBLE && !is_name_posix_compatible(optarg)) {
> +				pr_err("%s Not POSIX compatible\n", optarg);
> +				exit(2);
> +			}
> +
>   			if (ident_set_name(&ident, optarg) != MDADM_STATUS_SUCCESS)
>   				exit(2);
>   
> @@ -1289,6 +1294,12 @@ int main(int argc, char *argv[])
>   			pr_err("an md device must be given in this mode\n");
>   			exit(2);
>   		}
> +
> +		if (mode != ASSEMBLE && !is_name_posix_compatible(devlist->devname)) {
> +			pr_err("%s Not POSIX compatible\n", devlist->devname);
> +			exit(2);
> +		}
> +
>   		if (ident_set_devname(&ident, devlist->devname) != MDADM_STATUS_SUCCESS)
>   			exit(1);
>   

