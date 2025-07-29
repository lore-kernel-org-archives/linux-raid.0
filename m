Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A074233993
	for <linux-raid@vger.kernel.org>; Tue, 29 Jul 2025 16:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753807554; cv=none; b=Vi3nG9289q3goWr+v5zDD/7k1Y4vLtPETBEcrnn51coO4EWvY9Hkj2NsGcG1pb5KqoEPV2d+t9C06DsqDNoc2G9MVnqEJ/XuIcu4Tp/cdL4XSA/fnQ9bvz5VrA2EB6tX9DdGDloHBxYA2Si/3A3fGw9SYoeerimsuxthh5F5puE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753807554; c=relaxed/simple;
	bh=1GuOuSHQAxLZHDJv4O0kMdKVNRQE22qAVf/OaOmSeIc=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=VJqJR7yoRu6nmNoNfxuYCwLgDbS7cS5Hp2EbKCT1NC32tcsCEQiq7bjIyEgWOUdWCEwWtv9DvSB84OKRf2tY8/2KFxI070JjxDiAUvdm+9jG61RpJO7vccvwUiBOnLHz9RMfU280fvTtnteZSF96ddYR6oDg+xuhVVfAVX2LNpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dovygaO2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dovygaO2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A827C4CEEF;
	Tue, 29 Jul 2025 16:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753807554;
	bh=1GuOuSHQAxLZHDJv4O0kMdKVNRQE22qAVf/OaOmSeIc=;
	h=Date:From:Reply-To:Subject:To:Cc:References:In-Reply-To:From;
	b=dovygaO20TKcK2aCFSwzC701VJdN0BW+MRKyay02Umc1YG5aSelO6nSQjUB9T5d+P
	 F/7q6uesSfD9UJD0bgfs5ryPzrnqFoIJemUV+Pqn3VfZEVaGnyznaoIWQDatzC2Ngk
	 QF1gn1DxyD7RptsSxD7A25USh1YKpXtvaa4cuRNcnI6ZXeLszFuH6mdO2vN2YEz68z
	 J8dWC31YxZkOsATlgPucJXdTpyyyTrEIK90frZ3i7/1PLcQFwLBLiUn7nqmwh9PW1D
	 6WleQhHYYJj97Gx5/m6ah2dD9wCwfYjh29tlpH8KsxvIf/Cl6US+bMIRpweqWeyAse
	 mkDcSAjaHcTAw==
Message-ID: <21f02b29-2c00-4968-9cee-ca4d527cc98f@kernel.org>
Date: Wed, 30 Jul 2025 00:45:50 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: yukuai@kernel.org
Reply-To: yukuai@kernel.org
Subject: Re: [PATCH v4 04/11] md: add a new mddev field 'bitmap_id'
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org
References: <20250721171557.34587-1-yukuai@kernel.org>
 <20250729094913.59714-1-xni@redhat.com>
Content-Language: en-US
In-Reply-To: <20250729094913.59714-1-xni@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

在 2025/7/29 17:49, Xiao Ni 写道:
> The patch looks good to me.
> Reviewed-by: Xiao Ni <xni@redhat.com>
>
>
Thanks for the review :)
Kuai
