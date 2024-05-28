Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E8E2563
	for <linux-raid@vger.kernel.org>; Tue, 28 May 2024 05:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716873024; cv=none; b=HdXeXWMXD+zBT4DKcBROs68QtDNWw/+dtMzP6pywC1brXWEf/JIEftuIT8dDa/GEX57wvoRd2XrVtzMPHDCq4Vq8lkfkf7Ba8ov3y+sOUXjqZJqYBdY8ZxKF0/acPWPgoZKOp6DaR70LNi4aHf6NiR4k7IGVhcQyMKXUvTvNcZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716873024; c=relaxed/simple;
	bh=CJGFb+a3VVEW4jk1ydWhc2JTnBqMz9lrL6Fl06hFiTw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F7RLp0A6wO3jqOLlFSM3oxAXJW+w485Yftu6iehUxgeHsh98Elfp8fDJEKSZVrywLA40MVAxxkV7A/zYTRDT4PtseDlvls5JKjgr76+UuSWxErblUPB5M3c7oIH68g63qyrSOHZuPNsvVGOC6cSscUg+sMPUWOggspsLlDFKTag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [192.168.0.3] (unknown [95.90.241.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id EA86B61E5FE01;
	Tue, 28 May 2024 07:09:54 +0200 (CEST)
Message-ID: <c198d2ff-bcfc-4355-bc97-3804e8dc0ec1@molgen.mpg.de>
Date: Tue, 28 May 2024 07:09:54 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mdadm/platform-intel: Fix buffer overflow
To: Xiao Ni <xni@redhat.com>
Cc: mariusz.tkaczyk@linux.intel.com, blazej.kucman@intel.com,
 linux-raid@vger.kernel.org
References: <20240528022903.20039-1-xni@redhat.com>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20240528022903.20039-1-xni@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dear Xiao,


Thank you for your patch.

Am 28.05.24 um 04:29 schrieb Xiao Ni:
> It reports buffer overflow detected when creating raid with big
> nvme devices. In my test, the size of the nvme device is 1.5T.

I always like the error message and example command pasted, so chances 
are higher for affected people to find this in search engine.

> It can't reproduce this with nvme device which size is smaller

s/It/I/?

> than 1T.
> 
> In function get_nvme_multipath_dev_hw_path it allocs memory in a for
> loop and the size it allocs is big. So if the iteration number is
> large, it has a risk that the stack space is larger than the limit.
> So move the memory allocation at the biginning of the funtion.

… move … *to* the b*e*ginning of the fun*c*tion.

> Fixes: d835518b6b53 ('imsm: nvme multipath support')
> Reported-by: Guang Wu <guazhang@redhat.com>
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>   platform-intel.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/platform-intel.c b/platform-intel.c
> index 15a9fa5a..0732af2b 100644
> --- a/platform-intel.c
> +++ b/platform-intel.c
> @@ -898,6 +898,7 @@ char *get_nvme_multipath_dev_hw_path(const char *dev_path)
>   	DIR *dir;
>   	struct dirent *ent;
>   	char *rp = NULL;
> +	char buf[PATH_MAX];
>   
>   	if (strncmp(dev_path, NVME_SUBSYS_PATH, strlen(NVME_SUBSYS_PATH)) != 0)
>   		return NULL;
> @@ -907,14 +908,13 @@ char *get_nvme_multipath_dev_hw_path(const char *dev_path)
>   		return NULL;
>   
>   	for (ent = readdir(dir); ent; ent = readdir(dir)) {
> -		char buf[strlen(dev_path) + strlen(ent->d_name) + 1];
>   
>   		/* Check if dir is a controller, ignore namespaces*/
>   		if (!(strncmp(ent->d_name, "nvme", 4) == 0) ||
>   		    (strrchr(ent->d_name, 'n') != &ent->d_name[0]))
>   			continue;
>   
> -		sprintf(buf, "%s/%s", dev_path, ent->d_name);
> +		snprintf(buf, PATH_MAX, "%s/%s", dev_path, ent->d_name);
>   		rp = realpath(buf, NULL);
>   		break;
>   	}


Kind regards,

Paul
