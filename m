Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7802F13EFE4
	for <linux-raid@vger.kernel.org>; Tue, 27 Feb 2024 13:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041532; cv=none; b=MvJBwt7Yp1CaZ9gXZ+uBfPRfxApnQifcF2KFobO3meWLMK5yKoDyueeRUToDajozuFh4jIo9/bCrzLRn+CliA/Ht6Co7ngM6BWgOf2dBXClh1/RpDYkFCnkxbKxvfENSihyRTcHaGc2USJvXXd2ti70bqc91Z2SsZ6d0MvymPa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041532; c=relaxed/simple;
	bh=cBjyHAh14DbsPrRlGWqBCv//CIKQcUfKYFlXPKqVX9E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eeQGy8HQH2QAKgccHmhKa5JfJZ3qbih1wo8aVsvNK4iz9zOMzapqiOjZYSLYNXXud+YXxAOPC67iE64S2MjlaL19vG3DSGmrco39oH0wSThExhER03jcJE3TktPoJfM5EVAMJfEYSKAZLH3Vr7E81TMBU0QWzenLlwdeyXiA+Sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [141.14.12.27] (g027.RadioFreeInternet.molgen.mpg.de [141.14.12.27])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 3806F61E5FE01;
	Tue, 27 Feb 2024 14:45:00 +0100 (CET)
Message-ID: <e6a839df-7830-4dff-9271-aa245e2be7ed@molgen.mpg.de>
Date: Tue, 27 Feb 2024 14:44:59 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Detail: remove duplicated code
Content-Language: en-US
To: Kinga Tanska <kinga.tanska@intel.com>
Cc: linux-raid@vger.kernel.org, jes@trained-monkey.org,
 mariusz.tkaczyk@linux.intel.com
References: <20240227063656.31511-1-kinga.tanska@intel.com>
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20240227063656.31511-1-kinga.tanska@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dear Kinga,


Thank you for your patch.

Am 27.02.24 um 07:36 schrieb Kinga Tanska:
> Remove duplicated code from Detail(), where MD_UUID
> and MD_DEVNAME are being set. Superblock is no longer
> required to print system properties. Now it tries to
> obtain map in two ways.

Do you have the commit removing the requirement handy? If so, please add it.

It’d be great if you used 72 characters per line, so less lines are used.


Kind regards,

Paul


> Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
> ---
>   Detail.c | 33 +++++++++++++--------------------
>   1 file changed, 13 insertions(+), 20 deletions(-)
> 
> diff --git a/Detail.c b/Detail.c
> index 57ac336f..92affdc6 100644
> --- a/Detail.c
> +++ b/Detail.c
> @@ -226,6 +226,9 @@ int Detail(char *dev, struct context *c)
>   		str = map_num(pers, array.level);
>   
>   	if (c->export) {
> +		char nbuf[64];
> +		struct map_ent *mp = NULL, *map = NULL;
> +
>   		if (array.raid_disks) {
>   			if (str)
>   				printf("MD_LEVEL=%s\n", str);
> @@ -247,32 +250,22 @@ int Detail(char *dev, struct context *c)
>   				       array.minor_version);
>   		}
>   
> -		if (st && st->sb && info) {
> -			char nbuf[64];
> -			struct map_ent *mp, *map = NULL;
> -
> -			fname_from_uuid(st, info, nbuf, ':');
> -			printf("MD_UUID=%s\n", nbuf + 5);
> +		if (info)
>   			mp = map_by_uuid(&map, info->uuid);
> +		if (!mp)
> +			mp = map_by_devnm(&map, fd2devnm(fd));
>   
> -			if (mp && mp->path && strncmp(mp->path, DEV_MD_DIR, DEV_MD_DIR_LEN) == 0)
> +		if (mp) {
> +			__fname_from_uuid(mp->uuid, 0, nbuf, ':');
> +			printf("MD_UUID=%s\n", nbuf + 5);
> +			if (mp->path && strncmp(mp->path, DEV_MD_DIR, DEV_MD_DIR_LEN) == 0)
>   				printf("MD_DEVNAME=%s\n", mp->path + DEV_MD_DIR_LEN);
> +		}
>   
> +		map_free(map);
> +		if (st && st->sb) {
>   			if (st->ss->export_detail_super)
>   				st->ss->export_detail_super(st);
> -			map_free(map);
> -		} else {
> -			struct map_ent *mp, *map = NULL;
> -			char nbuf[64];
> -			mp = map_by_devnm(&map, fd2devnm(fd));
> -			if (mp) {
> -				__fname_from_uuid(mp->uuid, 0, nbuf, ':');
> -				printf("MD_UUID=%s\n", nbuf+5);
> -			}
> -			if (mp && mp->path && strncmp(mp->path, DEV_MD_DIR, DEV_MD_DIR_LEN) == 0)
> -				printf("MD_DEVNAME=%s\n", mp->path + DEV_MD_DIR_LEN);
> -
> -			map_free(map);
>   		}
>   		if (!c->no_devices && sra) {
>   			struct mdinfo *mdi;
