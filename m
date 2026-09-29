Received: from mail-wr2-f34.google.com (mail-wr2-f34.google.com [74.125.225.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B240C39BFF2
	for <linux-raid@vger.kernel.org>; Tue, 29 Sep 2026 07:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790665936; cv=none; b=oYA4SSQEOq00lAyxmj8Sng++gLIw7AJfSVtHEndOv8YavoWDkLVkkNyPY6JxUFveqQvf27LmVOxo4yyBDQhn7FahRbx5l0W5tSoXpD7jNK1ei/r/uaXvcdaI7P7YILi5jiRvjDg2+tBD1Xv0AGn1EuBYVUJ1sWfJh8dTMyjSbWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790665936; c=relaxed/simple;
	bh=u8TQO1UK8XHVE0Vqt/VlT60oO5zfpXd7X/el+fKVDdw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=tMvcNkioU8CicBlqSFAMgc3E42WAcMf2wUi4esuF2Lhb41tqhuL5FjR4gcqtJcw27HU8NxgJZVsM8A4mMLNU/fB6cfLHcLQNnJYoDU2nUy9uTAK7nhHdfp6Pm6IhzQO6T6Ulf0lFkORMDQ2Uo4ivHMdhI/VmKgOl+TAaXWRHQ9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gdWe+GVy; arc=none smtp.client-ip=74.125.225.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gdWe+GVy"
Received: by mail-wr2-f34.google.com with SMTP id ffacd0b85a97d-48aec508fe0so520270f8f.0
        for <linux-raid@vger.kernel.org>; Tue, 29 Sep 2026 00:12:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790665932; x=1791270732; darn=vger.kernel.org;
        h=content-type:mime-version:message-id:date:references:in-reply-to
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OxnpfrZPnSG8Zb7d0SFA6XW6LeRwagGigYoZfwslrbM=;
        b=gdWe+GVyMrbnJ4jfPp+4CdgWZ3ISzfOP/HmxeTWiOYIce3jg8D4O3uEsXgj05XUUgC
         cGH+b226sIO5uZlGWNEyoW4PODXNWn5KiBLVwdnU3dwgBc5rapvQEf3U2oVTn7Qs+xRG
         pb733VhNwZ/LMlXGMmP8AhbczbE0N/uTLlbHq/68OA/UxikAdalmEUFLxKVbpDAb7+sD
         Hr6Teo2i404YYchHKdARwl+tZa/ibNVyLGON0tTsBpyBGnQdqAaUkdnnXfz46iuw7viA
         JaUvmE1IsvlSwb/gDpCjAhn1KChUkJlAxmlKr7hoSBEHt7qThtwKEXY8AjlnmN9TJ/ol
         BLUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790665932; x=1791270732;
        h=content-type:mime-version:message-id:date:references:in-reply-to
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OxnpfrZPnSG8Zb7d0SFA6XW6LeRwagGigYoZfwslrbM=;
        b=xfkn4mQgwG1H+EcajXiHnRALV+Ibi/RNuZnkv2QosFkFO6s8z2bvk4LZjUvNA45qpg
         UoT9VNOit3naQEyYJ51kTe2v5N8EJ0BQgwm5CpK0kH38gmqY9NlQKEMUzuY/Na5JnEH3
         tHgdEkOf+FNbGW609AeSTLdr3FEV1ztx5AIgTXZnWXJaptfKZUNe1z8VIDosLz+QVDtu
         oSBsUnFAiwIJRBmRYmKnC49mdtKDI+wIGGgMlVENF8kfullaKiQ08RlqSIkG7ksv8JrE
         eoLRwr5lcC8M8NuOnPjJu9Zb4quL23TChqu0utKNUrP9smC1Xey5IuNJe8yQZeA7uzyv
         SGUw==
X-Forwarded-Encrypted: i=1; AKwUvBxxz7ePBDS67Ii1BVZSy4im+85vY7IMh7KvsqzDV1LbRUm7itnmyK9MH9cbN5mHWqGF3qguKpKgv59+@vger.kernel.org
X-Gm-Message-State: AFuF++lPesKwrJIE5fp3c61rWiHHx1ibTURuiWTSCStwY5wX1RKE93d7
	XyjpyKIeRcWOU/9Pm//Krxy1PshARn+OK9t0tyuESGYi5FGFGvmIGNM3
X-Gm-Gg: AYBFou2pqAmJPNnmRx8PnJKS57CvxfnXFU3A2NMl1bjNCX5F2kkzXV4/f13UyRUsXNe
	6hgHC8GRp4Tc+C4YtrZN+kFrFD7eg7vZ9U4CC/Hwpu+0x7jY45tMVnmjVlBoP12vc6Xs19ILMt8
	ERx5p9sdlPGcc3yi/HeSn61p3EsuFg9jmB3U5wXW688miTz8Wkn1S3aLO4o04lDS4uSxN4wUf1p
	9QZdyTG3M581KjmtCwxYtKxWWQNnNkJ905SL//+fy+N6m2Qwjc2v5YK1OJ2xXir4XZrqjhOukuz
	VqFbDz1eXNXxI7KzJmwkobON/KLZ9X91l2sVxjR12LkTHBcP5jXLb37ujQ0a5HwKePKzsF0sEAf
	2qmx04yaCI8G1qtd5UEgz+zrtKZK73cmp/18YtLUhYeIAS+de9uRo6MdYNYlA9i9dqgEyI9TzY/
	nbxYXCG6y5JmCE1qP5ftntTP7/Qg0ZG49TG/hzoXnu9+gvRr3dsl8n3kh/3vjYlw4f4VsRiWMZk
	pWiXcE9+kvkssoSe2Ta/22nnKfWc/s=
X-Received: by 2002:a05:600d:8650:20b0:49c:e37e:4389 with SMTP id 5b1f17b1804b1-4a00d75ad86mr16748835e9.4.1790665932244;
        Tue, 29 Sep 2026 00:12:12 -0700 (PDT)
Received: from Abds-MacBook-Air.local ([141.2.113.133])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a00cfafa23sm52092075e9.14.2026.09.29.00.12.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 00:12:11 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: song@kernel.org, yukuai@fygo.io, chengzhihao1@huawei.com,
 magiclinan@didiglobal.com, xiao@kernel.org, agk@redhat.com,
 snitzer@kernel.org, mpatocka@redhat.com, bmarzins@redhat.com,
 arnd@arndb.de, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 dm-devel@lists.linux.dev
Subject: Re: [PATCH 2/2] md: add a control device for array management
In-Reply-To: <2026092927-dominion-defeat-eed0@gregkh>
References: <20260928201224.3602262-1-abd.masalkhi@gmail.com>
 <20260928201224.3602262-3-abd.masalkhi@gmail.com>
 <2026092927-dominion-defeat-eed0@gregkh>
Date: Tue, 29 Sep 2026 09:12:10 +0200
Message-ID: <m2ik3o4jlh.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Hi Greg,

Thank you for your review.

On Tue, Sep 29, 2026 at 06:49 +0200, Greg KH wrote:
> On Mon, Sep 28, 2026 at 08:12:24PM +0000, Abd-Alrhman Masalkhi wrote:
>> Add a misc character device, /dev/md-control, with a fixed minor
>> MD_CTRL_MINOR. The control device is not tied to any md device, each
>> request specifies the array in the payload, either by name, by UUID or
>> by device number, without the need to open the md block device.
>
> Why is this a fixed number and not a dynamic one?  There should not eve
> be a need for fixed numbers anymore.
>
>> --- /dev/null
>> +++ b/drivers/md/md-ctl.c
>> @@ -0,0 +1,597 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +
>
> No copyright information?
>
I will add it in v2.

>> diff --git a/include/linux/miscdevice.h b/include/linux/miscdevice.h
>> index fa9000f68523..0bf2870dc191 100644
>> --- a/include/linux/miscdevice.h
>> +++ b/include/linux/miscdevice.h
>> @@ -71,6 +71,7 @@
>>  #define VHOST_VSOCK_MINOR	241
>>  #define EISA_EEPROM_MINOR	241
>>  #define RFKILL_MINOR		242
>> +#define MD_CTRL_MINOR		243
>
> No, please use a dynamic number instead.
>
I will use dynamic number in v2.

> thanks,
>
> greg k-h

-- 
Best Regards,
Abd-Alrhman
