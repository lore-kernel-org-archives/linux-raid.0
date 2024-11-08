Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 146C0610D;
	Fri,  8 Nov 2024 05:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731042970; cv=none; b=mltpx+f4n8aLn3ajlYWXsHuG9UsFju84da6RSUTXRgueAxKnWMqlFn2KGRzVBwUvGat7aZI8SARg4VlhfidExMLsV5c2m5NkE00uFEcIhWuZX7MwE6JOvnyt8s+xt2/v1ElzmiinRgqEG/DfN8aAdfI+yTTCyMsk/KfXNSEmXCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731042970; c=relaxed/simple;
	bh=XOsWpnDVYsswiJraNwaHauPEsAakbuKfqfOwgd7InNw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RSkNPv5HHVQ+K1DxES4yeVdTEh3U9x/GlKZsMkzByAt+NIx+5561N2RuzMH/bNolxDzA+U24OB6zL9hvg5RvMADgr7UArdH5o1MWZwBBAQ3PdO2b308R9paqSvAWTfe1Z5QNkTu20Abkx4Hen7WG1EPYvjut+56e8rBMcfL9yFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pkm-inc.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=pkm-inc.com header.i=@pkm-inc.com header.b=XyVtPf6O; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pkm-inc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pkm-inc.com header.i=@pkm-inc.com header.b="XyVtPf6O"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2e2c2a17aa4so171981a91.0;
        Thu, 07 Nov 2024 21:16:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pkm-inc.com; s=google; t=1731042967; x=1731647767; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XOsWpnDVYsswiJraNwaHauPEsAakbuKfqfOwgd7InNw=;
        b=XyVtPf6OKdKO5E9uDvrbMT4EXrDHWkegAUML76kYzcyeXvaY5usKWUG8OPIguQ6hvj
         Z109AS1b73b7W9PEITl/+uuzpVCVwY9JbLYNtcwCsikUl1YxEbgpGtbU3j4d08u2s131
         M0N+CCeXnuzRhaVhot0Uqo8msEN27zPunqJEd6xtXgHiym4oHfxk8hyqT3Eibb3ludzz
         zjylGe/QrZp4J7zwpfFr6Ka4C7EnrzyhQENRXY5dNxfdr90jHecJ/xRsHPyxJgqG6qZ/
         49QJzHt3Y9yR3jORVgL704wECqL6tHPITliqwBOQNBaTAXr2FE99BgxGs/EUp4yiY2uu
         AUsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731042967; x=1731647767;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XOsWpnDVYsswiJraNwaHauPEsAakbuKfqfOwgd7InNw=;
        b=p0C9RyG7o8FIdPo1RwSlwKViyBTlBsCi63qWjoJL1Pd76w183d5Jf6M08MmzxxHUUD
         wadqLUoDCYfVD/z/FQ+bcprwoPCa3D+HSR5941aCjp2zXQujMKhhH9z/JTx7EVFIaG8w
         GEP6By4SOSiepka0JGuyTXZeXudlJjKkZi1nre17LA6JoFFJQqa2XI7MM4qQvZzQIvhn
         pSZoTBtpFYF4OxqT89Y9eF9aWHt5MWmfMsuPJDeclvHRncVwOMs3z7RAH+BBf1BsKGrr
         nX3c097ejKCrlh1GgwptLDmCct+QllNQ5im2aBVi142VeXwc/iqdtoO3UiDXRtMKgaPj
         +OKQ==
X-Forwarded-Encrypted: i=1; AJvYcCXGET2kgQj9o0MoIbLaGpUCJ2Tgb81oUMqu8tfKIlRz766PNhc+UYntxq5aEl/XHfspYZ7gHX0C143tMQ==@vger.kernel.org, AJvYcCXzH3ZcpOWQrGOyEHf2nRZ66yCRSyQgPAlgo6YQxj1xEPiDo6GGtqiJIBRFEOrStc1MaJmCuEy4tCh9JaA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2Yq6X4K6i+cCoRHSShPgAev6vB2H6tXHQ+GBbFKlkrPvfxitB
	dSlCjMvEJBFIqiUz/wVzXG84JaCVIe10RRMBayGDrcDHoAbOJdNwC4UHMtrJpVRQDS+oNim416z
	b90bZSynWrthAMdhdOukMpmA1MS4eJj8z
X-Google-Smtp-Source: AGHT+IEvN2U2yefI/SXiPGMA1ll8rZBHbtctIrmleR/avb39CcCzvVTYOzmQztOnn8mSrTLM235umxHe9IeHpBgzvOs=
X-Received: by 2002:a17:90b:3505:b0:2e2:d881:5936 with SMTP id
 98e67ed59e1d1-2e9b16825edmr1093547a91.7.1731042967351; Thu, 07 Nov 2024
 21:16:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241107125911.311347-1-yukuai1@huaweicloud.com>
 <CAPhsuW7Ry0iUs6X7P4jL5CX3+8EGfb5uL=g-q_8jVR-g19ummQ@mail.gmail.com>
 <ef4dcb9e-a2fa-d9dc-70c1-e58af6e71227@huaweicloud.com> <CAPhsuW4tcXqL3K3Pdgy_LDK9E6wnuzSkgWbmyXXqAa=qjAnv7A@mail.gmail.com>
In-Reply-To: <CAPhsuW4tcXqL3K3Pdgy_LDK9E6wnuzSkgWbmyXXqAa=qjAnv7A@mail.gmail.com>
From: =?UTF-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>
Date: Fri, 8 Nov 2024 06:15:55 +0100
Message-ID: <CALtW_agCsNM66DppGO-0Trq2Nzyn3ytg1t8OKACnRT5Yar7vUQ@mail.gmail.com>
Subject: Re: [PATCH md-6.13] md: remove bitmap file support
To: Song Liu <song@kernel.org>
Cc: Yu Kuai <yukuai1@huaweicloud.com>, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com, 
	"yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, 8 Nov 2024 at 02:29, Song Liu <song@kernel.org> wrote:

> I think we should ship this with 6.14 (not 6.13), so that we have
> more time testing different combinations of old/new mdadm
> and kernel. WDYT?

I'm not sure if bitmap performance fixes are already included
but if not please include those too. Internal bitmap kills performance
and external bitmap was a workaround for that issue.
