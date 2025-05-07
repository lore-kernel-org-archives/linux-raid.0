Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C02628C846
	for <linux-raid@vger.kernel.org>; Wed,  7 May 2025 13:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746626017; cv=none; b=JwFmL8P07wEE4RdBnNCMisf4NPp8b08piC5NUSoxgSSgkd9MRILSlcc8Xrzi1wM3z+IeKXoWE4VJRItjjlswX/FFrnVPunka1WWau/hsmvf8Ovl3oEWdII7lc/XVnawmI9vdD32bozn/Zti188Xd7PtPUE8pjkUobI/Q0cEcO9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746626017; c=relaxed/simple;
	bh=QgofyzvUUveQBDSMer+GE1bsIZuWpc+F3FD8udLxRbs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bL56UIK8SQlTSTRCrPVXJKzsB+Lh4jpqe/ZQSuhmR4CfFGzD00bRtG3s/RQ2g2iqH3HP+8o6aF0b4tabk5xdryDyrN5UYE/L1tOsRb/u/ORPq3AeKWBnHi2Zd2W2GpSpNIFKZn0wYEJQ0WYF465XiOyQcK78P0rcJnkGyrzeCO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [141.14.220.36] (g36.guest.molgen.mpg.de [141.14.220.36])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 341F561EA1BF5;
	Wed, 07 May 2025 15:53:14 +0200 (CEST)
Message-ID: <01fd9e77-6a01-46f6-865e-d8be47aae87b@molgen.mpg.de>
Date: Wed, 7 May 2025 15:53:13 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] mdadm: fix building errors
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org, mtkaczyk@kernel.org, ncroxon@redhat.com
References: <20250507122002.20826-1-xni@redhat.com>
 <20250507122002.20826-3-xni@redhat.com>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20250507122002.20826-3-xni@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dear Xiao,


Thank you for your patch. Could you make the summary/title more 
specific? Something like Cast …?


Am 07.05.25 um 14:20 schrieb Xiao Ni:
> Some building errors are found in ppc64le platform:
> format '%llu' expects argument of type 'long long unsigned int', but
> argument 3 has type 'long unsigned int' [-Werror=format=]

I’d put pasted things in one line.

Also, please state how you fixed this.

> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>   super-ddf.c   | 9 +++++----
>   super-intel.c | 3 ++-
>   2 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/super-ddf.c b/super-ddf.c
> index 6e7db924d2b1..dda8b7fedd64 100644
> --- a/super-ddf.c
> +++ b/super-ddf.c
> @@ -1606,9 +1606,9 @@ static void examine_vd(int n, struct ddf_super *sb, char *guid)
>   			       map_num(ddf_sec_level, vc->srl) ?: "-unknown-");
>   		}
>   		printf("  Device Size[%d] : %llu\n", n,
> -		       be64_to_cpu(vc->blocks)/2);
> +		       (unsigned long long)(be64_to_cpu(vc->blocks)/2));
>   		printf("   Array Size[%d] : %llu\n", n,
> -		       be64_to_cpu(vc->array_blocks)/2);
> +		       (unsigned long long)(be64_to_cpu(vc->array_blocks)/2));
>   	}
>   }
>   
> @@ -1665,7 +1665,7 @@ static void examine_pds(struct ddf_super *sb)
>   		printf("       %3d    %08x  ", i,
>   		       be32_to_cpu(pd->refnum));
>   		printf("%8lluK ",
> -		       be64_to_cpu(pd->config_size)>>1);
> +				(unsigned long long)be64_to_cpu(pd->config_size)>>1);

Keep the alignement from before?

>   		for (dl = sb->dlist; dl ; dl = dl->next) {
>   			if (be32_eq(dl->disk.refnum, pd->refnum)) {
>   				char *dv = map_dev(dl->major, dl->minor, 0);
> @@ -2901,7 +2901,8 @@ static unsigned int find_unused_pde(const struct ddf_super *ddf)
>   static void _set_config_size(struct phys_disk_entry *pde, const struct dl *dl)
>   {
>   	__u64 cfs, t;
> -	cfs = min(dl->size - 32*1024*2ULL, be64_to_cpu(dl->primary_lba));
> +	cfs = min((unsigned long long)dl->size - 32*1024*2ULL,
> +			(unsigned long long)(be64_to_cpu(dl->primary_lba)));
>   	t = be64_to_cpu(dl->secondary_lba);
>   	if (t != ~(__u64)0)
>   		cfs = min(cfs, t);
> diff --git a/super-intel.c b/super-intel.c
> index b7b030a20432..4fbbc98d915c 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -2325,7 +2325,8 @@ static void export_examine_super_imsm(struct supertype *st)
>   	printf("MD_LEVEL=container\n");
>   	printf("MD_UUID=%s\n", nbuf+5);
>   	printf("MD_DEVICES=%u\n", mpb->num_disks);
> -	printf("MD_CREATION_TIME=%llu\n", __le64_to_cpu(mpb->creation_time));
> +	printf("MD_CREATION_TIME=%llu\n",
> +			(unsigned long long)__le64_to_cpu(mpb->creation_time));
>   }
>   
>   static void detail_super_imsm(struct supertype *st, char *homehost,

Can’t this be fixed in the header?


Kind regards,

Paul
