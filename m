Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE082010E6
	for <linux-raid@vger.kernel.org>; Wed,  6 Nov 2024 14:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730904969; cv=none; b=L6PcqyCiMnGOpUoS8GP+rm8kWYqqmBsBlhAZEGydI1dhduuyi41Wwe5Vn54X3JdHNQei3jnPnlFEIF/WSbrly3NJno+rLkFpWpDX/6w6EeA4KE63pYR0aAYYtboeetUUhO39qVSwj2mIkuOC8juOgAXOPu4T+qRDUq2RK1bfwV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730904969; c=relaxed/simple;
	bh=NsH8inz7skNevFYTZ/6rGlMhC1DpwGYJJdKAbbrxCY8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kLTtQVq0iBaCUeTf1ny51vHDR9jv/AEdzk6qbZ6ITOiggnyq34GM22dihwyqVuB2UJMAxjxB40FivdI7d90Gb2NKGn/54KK9tKl/bgNXF0Nj0TFqpsmUHaR/icBAw/RBQfmszyzUVion4/S68SmZJhuIcyOxxEPyaFZikblIU7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=CvhsiWOo; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="CvhsiWOo"
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-83abdaf8a26so253975039f.1
        for <linux-raid@vger.kernel.org>; Wed, 06 Nov 2024 06:56:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730904967; x=1731509767; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HWOXybJ1K2Cy7KTgY3rk1tgWN16MRdgGcWD3hLwAVmM=;
        b=CvhsiWOoiBasrV6X/OdP6O+6YIJi+EnWCew16eth1YakbpTdFbP7FsfbnRnpad7PkB
         m4Ave3iBfrQMQTRIkLr4y7ao/dXDuEerD1c22fRwvCJSCc2LPtn8bzYl5Jh+D9s6lYuV
         VEq1VVd+/2+EDBD3/xOI3moVh6+fgGP7XIvW50BNrOjQ1/O5BZsUnyrzz8XArudxpSr8
         ZSM7CITM3ANTpr9UY+T9Owu3a1ywD/F1h7YZu2WOxsLb7jOKkudPIEiGd9oyaW2wjEzR
         vX+qTZPQddX/3KEbWLPbfwYGi58nhmHEZ0yvQ/PAdlL6rGQNhHisf6FoatzoKJg1bYVs
         R9+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730904967; x=1731509767;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HWOXybJ1K2Cy7KTgY3rk1tgWN16MRdgGcWD3hLwAVmM=;
        b=Irfm4XF3NC6EYP37buTvQt8VFxK/qYJh0/IpJ8qQmOUvHsoBV07gO6uKRHQ7Zq8gb4
         7aqy7b6Y1oi1/Rpg8TLt8EZ2oyekvFWrdl62V6bG3t4IOPbMuaCZQJ/dkeMkXdh8JgPb
         J06oYRf58KONJoup6qGeNje+nNRQS/8dhMOLxlpq4q/US9QNYN84ilYRAJUx0Fm2TP9h
         JLdthooj6PuhlWzFy7U2jNb1ls9L3PGFwghkj2zfj33goC8gUyh22JV2SoL8Urr9sBHz
         uMOFfHnoxEaFqql1zEJuWnznnu1ZskUpBuWTEvhYAEAGGlcmNaimhI88/XQVPjegKjjw
         kj/w==
X-Forwarded-Encrypted: i=1; AJvYcCVCMt4Th6YfspL7ab6eSLCysDeptgRRewDPlC/OcwRNFDomKQtBuj/Je+zzf96OxJBNSyGq2LNOhKam@vger.kernel.org
X-Gm-Message-State: AOJu0YzHN862kaIy0RKP4fm58nnYiPGyk0fiyX7NS5/K/s03780XHiLR
	mzVbxQNufSowl6NteKNg9Xbvl/a++Y1v4xXPI6v4zqSzbVJKcem8D1Uu2HE07bI=
X-Google-Smtp-Source: AGHT+IFtjA/jqXrrrGHAVT+jMXjb503roT8H5nq3DD7o/X24Lcnbg/uOXFZDNf3yemBtCqEubN9aBw==
X-Received: by 2002:a05:6602:6b0a:b0:83a:c858:dc3a with SMTP id ca18e2360f4ac-83b1c5d5191mr3881457239f.14.1730904967127;
        Wed, 06 Nov 2024 06:56:07 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-83b67927c5fsm319869739f.0.2024.11.06.06.56.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Nov 2024 06:56:06 -0800 (PST)
Message-ID: <98b73e5b-0d57-433c-b021-ce3c02584dcf@kernel.dk>
Date: Wed, 6 Nov 2024 07:56:05 -0700
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-6.13 20241105
To: Song Liu <songliubraving@meta.com>,
 linux-raid <linux-raid@vger.kernel.org>
Cc: Song Liu <song@kernel.org>, Yu Kuai <yukuai1@huaweicloud.com>,
 Yu Kuai <yukuai3@huawei.com>, Yuan Can <yuancan@huawei.com>,
 Uros Bizjak <ubizjak@gmail.com>
References: <0894D5D0-A8ED-434E-B9FD-60B41C798B65@fb.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <0894D5D0-A8ED-434E-B9FD-60B41C798B65@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/5/24 11:51 PM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following changes for md-6.13 on top of your
> for-6.13/block branch. Changes in this set are:
> 
> 1. Enhance handling of faulty and blocked devices, by Yu Kuai.
> 2. raid5-ppl atomic improvement, by Uros Bizjak.
> 3. md-bitmap fix, by Yuan Can.

Pulled, thanks.

-- 
Jens Axboe

