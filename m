Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ACB41B808
	for <linux-raid@vger.kernel.org>; Wed, 26 Mar 2025 08:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742976033; cv=none; b=WeNPHhwLVfSBoykRuZiEy5xih10yZunyXnxQYtqUhOJWLta6RAhLGR/yFCEzpv5kkuerhzhGuOfZ7xmpjj6gh3oHngSbRaElLM7SgLE0bVHWZRD1oc0dljzbLWc17hCsPPd+FtMset5V/dRQ5RkoB82zy1Mk0H7JP3Xhu6T9wMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742976033; c=relaxed/simple;
	bh=Mu8C+/goBVtEn5G1ikUPKcbrNxNy//jb46NyDOy+mag=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=txFU617f4fTAaiWTyB82np2uaiq4cCcyS9vVTei1Y5efWUMzTFQayDvmTQk4YRNmaBVliQJ7URnW232HAYH/MnNie5yoMOiaRKg6PJHSc5C1cJO6pRmmOVLmOBpt5JhM1WtpTS5nsG61Q/XK9awD1PsvNN+XZf3T9DmYWmk1zEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [192.168.178.112] (p57b37a18.dip0.t-ipconnect.de [87.179.122.24])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 729EA61E64782;
	Wed, 26 Mar 2025 09:00:03 +0100 (CET)
Message-ID: <66a621dc-c4ac-448d-a72a-311009baedf0@molgen.mpg.de>
Date: Wed, 26 Mar 2025 09:00:02 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mdadm: Incremental mode creates file for udev rules
To: Nigel Croxon <ncroxon@redhat.com>
References: <ded3b88e-c0e8-4a66-89f3-43bc6bb9664a@redhat.com>
Content-Language: en-US
Cc: linux-raid@vger.kernel.org,
 Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>, Xiao Ni <xni@redhat.com>
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <ded3b88e-c0e8-4a66-89f3-43bc6bb9664a@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dear Nigel,


Thank you for your patch. It’d be great if you used imperative mood for 
the summary/title.

Am 25.03.25 um 20:18 schrieb Nigel Croxon:
> 

Just a note, that there is a blank line at the top of your commit 
message body.

> Mounting an md device may fail during boot from mdadm's claim
> on the device not being released before systemd attempts to mount.
> 
> While mdadm is still constructing the array (mdadm --incremental
> that is called from within /usr/lib/udev/rules.d/64-md-raid-assembly.rules),
> there is an attempt to mount the md device, but there is not a creation
> of "/run/mdadm/creating-xxx" file when in incremental mode that
> the rule is looking for.  Therefore the device is not marked
> as SYSTEMD_READY=0  in
> "/usr/lib/udev/rules.d/01-md-raid-creating.rules" and missing
> synchronization using the "/run/mdadm/creating-xxx" file.
> 
> Enable creating the "/run/mdadm/creating-xxx" file during
> incremental mode.
> 
> Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
> ---
>   Incremental.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/Incremental.c b/Incremental.c
> index 228d2bdd..e0d3fce7 100644
> --- a/Incremental.c
> +++ b/Incremental.c
> @@ -30,6 +30,7 @@
> 
>   #include    "mdadm.h"
>   #include    "xmalloc.h"
> +#include    "udev.h"
> 
>   #include    <sys/wait.h>
>   #include    <dirent.h>
> @@ -286,7 +287,7 @@ int Incremental(struct mddev_dev *devlist, struct context *c,
> 
>           /* Couldn't find an existing array, maybe make a new one */
>           mdfd = create_mddev(match ? match->devname : NULL, name_to_use, trustworthy,
> -                    chosen_name, 0);
> +                    chosen_name, 1);
> 
>           if (mdfd < 0)
>               goto out_unlock;
> @@ -599,6 +600,7 @@ int Incremental(struct mddev_dev *devlist, struct context *c,
>           rv = 0;
>       }
>   out:
> +    udev_unblock();
>       free(avail);
>       if (dfd >= 0)
>           close(dfd);


Kind regards,

Paul
