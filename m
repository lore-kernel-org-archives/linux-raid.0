Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AAA8535D8
	for <linux-raid@vger.kernel.org>; Mon,  9 Jun 2025 09:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749460567; cv=none; b=ZEOMpl0lxE2DolY7aqj63F7iDTr8+IoPnSGHXRuqzrOoNgjJ+gzg8KC9NXzyEYYvwVroz00XOiMTEDtvdOmOMH7u157Ba42o+tfimyB6a3kKdOD+2PJyqq3jgNdFHHeXWWmX+Uefvkqai09h6bjFBreNp0pk5NVSIok3BDPeQN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749460567; c=relaxed/simple;
	bh=p2JFshxuisU5QOIhegCaj0RojjGBvY93RTwXvJFFoQc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UUmHJX3AeN2/a0Ul5RIjwgga27s/fMpAvIu3Cg2JU/Zq6PsB9iXt6kOBzaC1VeSNBiQJ5z3W95p2dSjfE4LOlXRGMoVK/NsUKwPD+QZjaRKMalJir+rCfeyUsdjQ9DSBycgnpoSsQp+mtaAcA3J38bIQp2UHMfxR9Omn007z53E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JGhlQpfp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JGhlQpfp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749460560;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3An5UNpag84y+IiXaZZvKz68swQI5Fs5aPeKYBLDhzU=;
	b=JGhlQpfpsvBwIvEuw3rXkMRCHv/wzquwsClNTE25RfWwN4nhIBA4YW4tOSpUUmg/YMKuta
	ig0eIF8LMAzCGcqHChGcWUiGf+0HoyZ0Hq66aX8g6u3PDo1/PQkXC/YIPGzWQEmLEvp1p3
	ISso6joVCtWYA/kA15ptdlhMrBPeeg4=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-206-CzWVRdsbNs6Q_97y5zUUVw-1; Mon, 09 Jun 2025 05:15:59 -0400
X-MC-Unique: CzWVRdsbNs6Q_97y5zUUVw-1
X-Mimecast-MFC-AGG-ID: CzWVRdsbNs6Q_97y5zUUVw_1749460558
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-60f428458c5so1853323eaf.3
        for <linux-raid@vger.kernel.org>; Mon, 09 Jun 2025 02:15:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749460557; x=1750065357;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3An5UNpag84y+IiXaZZvKz68swQI5Fs5aPeKYBLDhzU=;
        b=CC9YUYZOiksluTGb++l/HGRGtJb4R2+ZMcmPl+t72qgtBp1LWRSNVRj+XZ8RC4ROnY
         z/N9FhptT1C5U+iGeAMIGjxZ3PzpPG5wDVkyoQ/kk8YvZ0nLEbD41TxLMeWagEk+IzYY
         bfZgaLyx+TeSH1V5ITmTsvKHMWAqGoH75CjKHlRmzWkkoim5G/u07chzaOlV3HjUs8Ui
         3MhiSy59uK/IsofS++n4USdWHL/eEO3ZYD3DDcNXrFhWQIb3rva+qMf4gaAM4H9ioHpF
         xuW8iFB9aV8xHUmpNCILfWdDHg9+sMUWvPZrOWVO2K9nDmby6+E66fqyvpW+fSsQ1tvI
         1P0A==
X-Forwarded-Encrypted: i=1; AJvYcCUUIyEzjkIxGhMsyDKxH2qDYepqnMPrxCWQUsuD4HWTCRCfE9nm/FbB+h5hiR4cLBLjo5eMQ9QnBN4Z@vger.kernel.org
X-Gm-Message-State: AOJu0YxLvjhcOD7/hZYWxd7K75KsBYHSlpQPw7+Y6PH09obEM5ieetmP
	+V2I1IT5Cej+PZJaq8QTGX0vb4SHUji5YRGNvuf4JTF2+HasfuxYoWXlmAPXHuW5PHE8CZR7yJL
	N68xApZYZOEmoWqbbWFJfNVPUZ1vW3uiajWLQe7iy7R0ny4wvewgclyaT2/v58TioMABpKMk=
X-Gm-Gg: ASbGncuSH52w/zj0OJ/MaRIPCQ3es+5b0PMJE1F7np7oaXnD60RMEKjb0EQXQOBDQcC
	iTpOlfYZMuG77kElMFzGZnBuzb7dlD2LrEAFwYHGOFG4xM9W4Lzr7oH5FdcdrsY8vw7B1brEYQm
	CkF+EeVEv0PB4zRhSvGdKAbGePeqxoXhg5CAVyqwai9PGdDctW0gTz8cAZG+Gzz6Wwnr/SaWysq
	rBNQI4x0eCEVBE9mZGoRoYllHY3F1iOXsyGsE5TS1e0ow0le5HdQdQN72qSIy4tOue87L0w8Ene
	K8vhAzfmznexTb0PQ9YzLZc418tuTg==
X-Received: by 2002:a05:6214:29e2:b0:6fa:8aa6:af93 with SMTP id 6a1803df08f44-6fb08fcd5famr202725836d6.45.1749460540834;
        Mon, 09 Jun 2025 02:15:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEhTRNVTNSQRitGuOIfJ/aXK9FJmv05rd7tu3wEP+Vx7FbWHPNlSS8RmTmF0Y2HeAgdULaq3w==
X-Received: by 2002:a05:6a20:549d:b0:1f5:6e71:e55 with SMTP id adf61e73a8af0-21ee24e4c1cmr17821254637.6.1749460529681;
        Mon, 09 Jun 2025 02:15:29 -0700 (PDT)
Received: from [10.72.120.23] ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7482af3859csm5330239b3a.36.2025.06.09.02.15.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Jun 2025 02:15:28 -0700 (PDT)
Message-ID: <3beccc0e-2a6a-4538-881e-0088761b3e56@redhat.com>
Date: Mon, 9 Jun 2025 17:15:24 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] md: call del_gendisk in control path
To: Yu Kuai <yukuai1@huaweicloud.com>, linux-raid@vger.kernel.org
Cc: ncroxon@redhat.com, song@kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <20250604090742.37089-1-xni@redhat.com>
 <20250604090742.37089-2-xni@redhat.com>
 <30a77424-e5f4-ee83-52a2-cab7e3cbc1ed@huaweicloud.com>
 <cd3e67e6-05c2-56f8-9bcc-c95d0f05df92@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
In-Reply-To: <cd3e67e6-05c2-56f8-9bcc-c95d0f05df92@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


在 2025/6/6 下午4:48, Yu Kuai 写道:
> Hi,
>
> 在 2025/06/06 16:46, Yu Kuai 写道:
>> +    if (!ret && test_bit(MD_DELETED, &mddev->flags)) {
>> +        ret = -EBUSY;
>
> And I think ENODEV is better here.
>
> Thanks,
> Kuai
>

Hi Kuai

Thanks for pointing out these problems.

I modifed the patch (remove the sysfs remove also). The regression test 
is running now. I'll send v5 if regression can pass.

Regards

Xiao

