Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF8311C5486
	for <linux-raid@vger.kernel.org>; Mon, 13 Jan 2025 18:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736794413; cv=none; b=q4dMyTMcnM+Qppc7SczMtvdnYoCD7LMSu0Y0pWcucAZArJUSwtVaGkh5/QyrNW3GVwbaImdbdfDIyKXRoOpZg6Ubk7XaTvBe7mbflQD5veOuwp6h0nJ9utGhm33HWquwcKConVaXfxzHc023D/V+e2AdtJm43KqmWl91zF6Yffg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736794413; c=relaxed/simple;
	bh=DnYh+g5DRma2r+SyUcpVc3RKZkvDKE+MDmZF9+uh7Nc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XTdHFh93ZBDqhOYcmekAiemN8qt3kle5MTrcre7JFLnNj3SKn+LqvV+xgSB4bj273kWBIq6hZZ+sxmzNwOGc+W7sGVKYrzpkDQoHz/0ODD9SnxzUNNr9d9uJA0TSs8/wVa54pAKkYksxeOnS0JhaMW476QvX6dhEi8swAYMsFcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=GZyn0Bq/; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="GZyn0Bq/"
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-3a8146a8ddaso11342555ab.1
        for <linux-raid@vger.kernel.org>; Mon, 13 Jan 2025 10:53:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1736794410; x=1737399210; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2MqJgqzMCLMI1AGA8gKeZDK4+M+qj3kcuhnMYyyUTOM=;
        b=GZyn0Bq/2FuAbb+OlIAtd+D/w0BF1cbUuujydcDRD6SVjEig6bGbKqiCwFJzxCeU0k
         8D8jbzZv+q2BsSCjgJRbJd8jv6rX3gsidmh+P/9OMjhqPXTmsLk9ZM2/poxplnWMgVQE
         PdbeX0cakDi4EJWc4zDn7mKE3XmfndSuqbvQL4EFdijTNlSU4OJcuuLmq+5k64MyCEuY
         i+rs3MJtccElXUoXVNAEdFgx4jyowxL8odJZCA7EqZe/GaiTnh1Suqo7qW/C/POo3Y6H
         iUr1G0AYBcLZkFlyDf4ofHN/n2y2ubvFfdNZ+m0WWVFYE3BuXZ8g5MJc8jn7X8NHjV4p
         TqdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736794410; x=1737399210;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2MqJgqzMCLMI1AGA8gKeZDK4+M+qj3kcuhnMYyyUTOM=;
        b=vAVJYV/AJySSRZmredAC4/tT+ChOpY24DKq1a6HZW4alNEdPLgH024ph7xwq96p27l
         6ttH0M25vQwOCSN+vNA2gC2afi31JwuzzJ4SKdGWISdIfQyMRkF0kwa5k8/mwxSsD01U
         +J7vHl5VZRIk5q22jSj84iaoqZmahLpb3dZmZzUGg4pAOX1KAUfKtQkW0U1TjQI4xwCp
         YbSYXIZ169EGBND83w1VbMev5RHZiZbLAcNLteBgddlKOe+jkU6c5bXbHAfL8oeqk6vp
         z79LAJdTgkurfw3sEYrBql2T4DLjRp5/JYBHD07gFPq8duTaR5cXI+IOXt7Bmsg8VXa0
         OxSw==
X-Forwarded-Encrypted: i=1; AJvYcCVomi47QTnE+yYcM3538EHVCMVcYewoC21UJEfj59aAoAhnFoc+sZ7pLDFMejgXjOAHCNiA5eOrkue+@vger.kernel.org
X-Gm-Message-State: AOJu0YxUwNYP2fsqCGh0gLHhLm8PYuPY0eHPlE7Z8NxLkDocJCR1dcVm
	y0E/aiE1iMYBYT4CXQUekQJTvVtmMriX4EvovKjA3kQaQOFiot62DCpakHgN6/OVi+gruvv27B9
	e
X-Gm-Gg: ASbGncveoELnfXz0U8MujuZ0rcGZlLpQAkqhhiNV5tOBrDgaYuRskP+/Ra3dN8e1JuC
	pl5aPqYO6Qf8gXyx3HUR4oHdmpA+130JBlBqgKfkLWZodQIUu51bW2czk+deENpOiyMEEwQejMT
	mIJJh9pf5YTz9/kciO/Ory9PW9EPJS9R9Xf8u/zW4VwQGmAC+QGItC9oCeC968dEiublopbU9yF
	PF6aP10W8c0i3h3wOjFgm8L0zJaszbP2ThR7qJn0/IBEEIK9S2H
X-Google-Smtp-Source: AGHT+IHwuWt4p7LTBebhIiGB67Hx2o0pfT1ZCh9+Dx25aVAAkWS2/QbANezPEzLlOlncUReZ3074gQ==
X-Received: by 2002:a05:6e02:1447:b0:3ce:66a8:e2e8 with SMTP id e9e14a558f8ab-3ce66a8f07cmr51860965ab.13.1736794409952;
        Mon, 13 Jan 2025 10:53:29 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ea1b7488e0sm2907559173.133.2025.01.13.10.53.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jan 2025 10:53:29 -0800 (PST)
Message-ID: <79332549-8bb0-43d7-8b33-657530d9dbeb@kernel.dk>
Date: Mon, 13 Jan 2025 11:53:28 -0700
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-6.14 20250113
To: Song Liu <songliubraving@meta.com>,
 linux-raid <linux-raid@vger.kernel.org>
Cc: Yu Kuai <yukuai1@huaweicloud.com>, Yu Kuai <yukuai3@huawei.com>,
 Song Liu <song@kernel.org>, David Reaver <me@davidreaver.com>,
 Stephen Rothwell <sfr@canb.auug.org.au>
References: <B3AC6EF1-72E5-4503-BFA2-86063919F2E6@fb.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <B3AC6EF1-72E5-4503-BFA2-86063919F2E6@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/13/25 10:28 AM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following changes for md-6.14 on top of your
> for-6.14/block branch. Major changes in this set are:
> 
> 1. Reintroduce md-linear, by Yu Kuai.
> 2. md-bitmap refactor and fix, by Yu Kuai.
> 3. Replace kmap_atomic with kmap_local_page, by David Reaver. 
> 
> This is the fixed version of an earlier pull request [1], and addresses
> build error discovered in linux-next [2]. I am very sorry for this problem. 

Re-pulled, thanks.

-- 
Jens Axboe

