Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com [209.85.219.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5032EE285
	for <linux-raid@vger.kernel.org>; Tue, 12 Aug 2025 10:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754993311; cv=none; b=cf/LDKXac9exdZPhnSQIP1yV4wXty2VE1Kam4czcYGe9zjyHzYjrLCBxMfwWFPn2ZZJD09eku9TasTuT05yn5q2XN7+O93bh4zJTSa6SYP9Wtfu0l0hBA4hTtU4M7dsPn4WNhFThq0PN6oileogd6bzKSTDZUy5BrwlrDVqyfCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754993311; c=relaxed/simple;
	bh=Q7qAhDwSHqibJWfa8MeVxXSvUCKXEBtL24KQ4SuPZfU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=u+2aozifLfxzbzjqaEiC+5ibc5YVUeb1gCzDaux/UVxSHlldQ3wPjtDuub40voW4/JD9cb/v0fQAotQdu3exHu+34PcE6JAsQpIulcwxUgN56vlUDVii7zI1Pbp/8GCE1To8M//Hm+E0IvzIz0hyTzEXGvW80fFF5HQ07kK7TsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RqdFiaVO; arc=none smtp.client-ip=209.85.219.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RqdFiaVO"
Received: by mail-yb1-f171.google.com with SMTP id 3f1490d57ef6-e917db05f14so292580276.3
        for <linux-raid@vger.kernel.org>; Tue, 12 Aug 2025 03:08:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754993309; x=1755598109; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Q7qAhDwSHqibJWfa8MeVxXSvUCKXEBtL24KQ4SuPZfU=;
        b=RqdFiaVOGLiVI100eFchAeCNyDUvhQ42/odeq668UsQ5YBeou2lyV7XjO4sYuD4qDK
         Y7C1yA4JW4qbGwf9jHhCO3eZxsbIZTaP9d4f5xRx67jvWlsEIBHYuPUrSyExuv7it5T9
         say844BAQEbKe5roLxZs852SKhqbTTtEIY4B3LUTZ/LVSUnS9BeIP/9NzMQl/hgfV0Ko
         W+JOJ4nsiam+x5KPgBvHoAQP34JQ6qVNLGC/QGMKSavEfiJ3A7n6boL0sUgvT4ROx3Eb
         Hh5sYz/NaymCZPqvkG8YooBgAFKjvyS6AalqAuL+GVkMKUn4c2KuXAHYNX4Sh+vAfcDa
         d/+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754993309; x=1755598109;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q7qAhDwSHqibJWfa8MeVxXSvUCKXEBtL24KQ4SuPZfU=;
        b=SFbPfz5BeJkton8FSptSOI/HkXa+U5FpaVlbXH+rdWAbWVz+PYXyXdgikzR8i4o2zy
         ZTBgQoVvmPaIa58etYmY11f7TyNozqnozslHHgsMMmGZEA0uDSujZbYMvWGQdv7BQDpf
         rL4bfDYDE5a0RDy2kOd2oNhw27xBLWY4SMk5aJ70Wxwzz9Jm1w90tX5bSUPxXmdDkKEn
         JSznrKrhuCtmpIoWP9HyTq4lEj/LiD/RGStOwnvVOxdyN4YRkENPLtIQnt5/U/Jg80QY
         wXeZqWkPAA0RxfflVwB2NUz9OTTXuUzLi4lcPCcx3UrkU8rRCd+wBycAnvsZ8y5gHQXO
         rvxg==
X-Forwarded-Encrypted: i=1; AJvYcCW9uAPKHPZuDnT+w7w8DghfeRKP1z6KG0iGqyisAjZ7UM6TVkjITo8X2gFZUHahjVrhEWDPxRkZh2ys@vger.kernel.org
X-Gm-Message-State: AOJu0YzzPBV3bu/HGUMQwC/VJy5RYoOMOSA8BYhEJpIw1aYssm+9mjfr
	I0q/e1RZotkGBXyBXA2HqmheKb/6FNGcMw/SgJ22Nfh3dyIa+Fx6u1TNkqIEhvBVPQLo1QY5UsU
	gmS32Jm+6RW1vDrdS/jJNnZO+x6eKEqg=
X-Gm-Gg: ASbGnctg+UqrblAp3gbVx2Jwa6c01xS2ocyk3ug8qlom0EXJsQ0vkqms76fCTrmj+1e
	FYv4qKtdaCLK23Ot8iUmxTjZuBfLVcbh7I1ujn7I122kFMyc4PeIO4rj6eIV0sM/koBmNrmmacK
	xOgbetmvSta/suCFi+ThbfFJtB1GHBiDLNb6I4xppy2aFC5ujyX3uqAWO2Cohd3T/KcLu/sszW3
	FHzOfU9MqV+P/xCe6lDfCOYuzWyz4hRtB3E9Y8YlQ==
X-Google-Smtp-Source: AGHT+IHkPqNOfl5q/TQ9cGJsGNLR+9GU7cZbEq5ilghMhitgFcR5gGM15J2Bh5K+ivKjFapWn2/fhvIU9FFukjq9y0Y=
X-Received: by 2002:a05:690c:368c:b0:70e:18c0:dabd with SMTP id
 00721157ae682-71c428549a0mr40180317b3.0.1754993308870; Tue, 12 Aug 2025
 03:08:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250812074947.61740-1-xni@redhat.com> <75175b99-57ce-4384-9b75-c91d4fe4ddad@molgen.mpg.de>
In-Reply-To: <75175b99-57ce-4384-9b75-c91d4fe4ddad@molgen.mpg.de>
From: Luca Boccassi <luca.boccassi@gmail.com>
Date: Tue, 12 Aug 2025 11:08:17 +0100
X-Gm-Features: Ac12FXymb6JrfWzf9NmILjhWls9stjlKgIF2a7Uxq_kwOvjCQ7jtX9JCithBWKI
Message-ID: <CAMw=ZnSdKwvKwsfe_ajyxjobLvZZgUtApj5Lo9jXV5Bq_k76JA@mail.gmail.com>
Subject: Re: [PATCH V2 1/1] md: add legacy_async_del_gendisk mode
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: Xiao Ni <xni@redhat.com>, yukuai1@huaweicloud.com, linux-raid@vger.kernel.org, 
	yukuai3@huawei.com, mpatocka@redhat.com
Content-Type: text/plain; charset="UTF-8"

On Tue, 12 Aug 2025 at 10:57, Paul Menzel <pmenzel@molgen.mpg.de> wrote:
> Maybe add a timeframe?
>
> md: async del_gendisk mode will be removed in Linux 6.18. Please upgrade
> to mdadm 4.5+

It would be great to avoid breaking compatibility for a couple of
years at least, please, to allow for multiple cycles of distro
releases, and to diminish disruptions. Thanks.
