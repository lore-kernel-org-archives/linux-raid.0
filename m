Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA253D5679
	for <linux-raid@vger.kernel.org>; Wed, 18 Mar 2026 12:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773835584; cv=none; b=qhPu27xfT3mWvheyPBJyp3aHw0oJderyXRZi+EI1m5Ji0uZbtiGtnzq8Y0cTaWMKLre9qCWx4G0W6/LDrBRwACcY2/xOrXbgwQF8jHUklxRY9uNs6qBGG8kraMnK3D7HRWFjWYOAuooj8wlAIL/vwKKoyzlss2UWsRpxj2faRN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773835584; c=relaxed/simple;
	bh=Hz8c2HJznE2NCLggaTZb6w+o1R8yJJXQfHP92fXVV2M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ukMHMbV307Ju+hfY7q5GEuPlBjqeOeB4KpefIDra1I1/EZGSYCaRyoz8xfl+MDiOD6yeeu+rDJl0Z0I03feZauV/WzSNrHE0FpQ32YVQOzaOBDdx5vO3EeqUayJP+I89sIL5st1/cQRbbttMHgQ5pf+iuMDaO8a2t0BX4TchWrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QcOOHeM7; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QcOOHeM7"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-43b50f4385aso58795f8f.2
        for <linux-raid@vger.kernel.org>; Wed, 18 Mar 2026 05:06:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773835581; x=1774440381; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iJc9czVCpJDhV95L/UPv38g8ePmFvcbEDzPneLDgqxQ=;
        b=QcOOHeM7evHpFgQ2kDE0z9qNysF3f7wy1QZblVg4wSCkEkwZP0CEDsqeQY6W0Tall8
         QD3PC2pQ742wZOr2mD4boNqLXfD/JnBn8EZGPg3t4vMubKLIY0MbLRZUf98E9tkxNAln
         SIY8YClkRJh4PIhywd8m390GREZBpqH/jtrsjCZTNz9FHkGA9hCNvpyvxOYwF40/ceJp
         ANblbFXv+jrcXonDqPqqNycQda28l+uu/nwoLCwXR55xQtdg610kDvw/C+bP7Z+rHCww
         qMdk9n2PbGIcJ4t4e/f8zaDOck83+Q6zwk67/R/+bDnYeis5ojvQjj/BUanaTi7Ngd5t
         TQBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773835581; x=1774440381;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iJc9czVCpJDhV95L/UPv38g8ePmFvcbEDzPneLDgqxQ=;
        b=k2T7yMFebbwz3FaY0nvyD5XQpFWKnwC5gvJ7U75LH6sjCGPCJ9PLYdT2kqIkuyI3KE
         q8GfHKIjCVGXVGO+XlBWRqW/dEO8QMIkbsFsIe09y1ZXd2bxwM+5x2OE7RViX4KYdvg7
         DNdKDVbrk7to2PO17Y1enPEH5mRSswbZZX1sIcCH0T2Ce5h2UHC1/2q0ZxJwdI7NNac3
         Y4T2Nrdfd08fasicVCtFZuZF3eni+eWR0m9uVx4HiRZxXdoO9aYxasKFSb4TGPT4ag0s
         zACpAmzma/OkE4DXGYPLvNS7LP03OYnTBpz3BxqWxSe6ves0PkclXNRRhz79+PRpcKYk
         9hvQ==
X-Gm-Message-State: AOJu0YzVmMeQk1XLGqf+TftG8d9e0cyUPPrk0FjBsjTjHZE+Mo3eROun
	1r+fcxEAFB79ABYqR/v3N7M08KGBJmK5vSlj8Q7OWOWRK27ORW709Zs=
X-Gm-Gg: ATEYQzwIFsRkfBOpn5REpXyFIkD4Iyxpfi0dglcL1Pyv6roC8g2OHdbZtcpSFF2VeKN
	2GFvsi9xpiEW7u8fG0NmuR0oTgmCH1F4g/ZTtcx8GaCyA3H48YQZ4K+/HBS3G9pwINkman95pdL
	pT74zmS46M/fvgGuztXQaqRuSFoXO1ApS4Qvu0voxxzLu+FDAQPxxMx76xT7PiS5QICeSL4cNuQ
	902WHjNMuR1/vQF9ajMN5va6y1V1TwARVQrvH7h92f4VXP67PCcNo2IyiFAnanzjvmDUcFrFf0j
	vCXmpUybmyWtJYi4D+F96HaZol2JUEs1nse7pjEQb6TpP8kZ2Njn61w3fc3yvFKu8RLzQV3YpNT
	JeaMES9Iu0TxzQuO89YCQS8e8FtpqcrwhP3krsSSFJVQ9JXE9Q7Yeg9Gfsb4jlYevjyQVzqm3Uz
	TOIZI3JaRwm8zToDHqpHb299mW+8StZbWZgjuuI38sOXucK78vpUDq4us5UpTUFH/7baU=
X-Received: by 2002:adf:9ccf:0:b0:43b:437e:bc5e with SMTP id ffacd0b85a97d-43b527cb5e6mr2071638f8f.4.1773835581239;
        Wed, 18 Mar 2026 05:06:21 -0700 (PDT)
Received: from localhost (171.red-80-39-136.dynamicip.rima-tde.net. [80.39.136.171])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b518522d7sm6425341f8f.13.2026.03.18.05.06.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2026 05:06:20 -0700 (PDT)
Message-ID: <e1b2e99f-1ee2-44dc-abdd-06441b74c147@gmail.com>
Date: Wed, 18 Mar 2026 13:06:19 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: Release mdadm-4.6
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Song Liu <song@kernel.org>,
 Yu Kuai <yukuai@fnnas.com>, Nigel Croxon <ncroxon@redhat.com>,
 Mariusz Tkaczyk <mtkaczyk@kernel.org>, Martin Wilck <martin.wilck@suse.com>
References: <CALTww2_2pjjOSsVj-WT++m35555CjnPWokU7fut+HwUJVV-=ZQ@mail.gmail.com>
 <ebafe7e7-4166-4c1b-92b0-378db8f79ebf@gmail.com>
 <CALTww28+ZdE4VzP1DqU=nFRibSPtu8L1qSOXKabv0ShdsAOO7A@mail.gmail.com>
Content-Language: en-US, en-GB, es-ES
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <CALTww28+ZdE4VzP1DqU=nFRibSPtu8L1qSOXKabv0ShdsAOO7A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/18/26 11:30 AM, Xiao Ni wrote:

> Hi, I'll try to do this. I took the maintainer job, but the job
> doesn't contain this part. I'll figure it out. But it needs some time.
> 
> If you want to download the package in spec file, you can do like this:
> 
>     1 Name:        mdadm
>     2 Version:     4.4
>     3 # extraversion is used to define rhel internal version
>     4 %define extraversion 3
>     5 Release:     %{extraversion}%{?dist}
>     6 Summary:     The mdadm program controls Linux md devices
> (software RAID arrays)
>     7 URL:         https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git
>     8 License:     GPLv2+
>     9
>    10 Source:
> https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/snapshot/%{name}-%{version}%{?subversion:-%{subversion}}.tar.gz
All versions are listed at https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/refs/tags

But package maintainers, or automated build systems, often rely on the kernel.org url
( https://www.kernel.org/pub/linux/utils/raid/mdadm ) for stable source downloads.

Thanks.
