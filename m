Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA2EEEAE7
	for <linux-raid@vger.kernel.org>; Thu, 17 Apr 2025 03:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744859379; cv=none; b=LBPY6I/Sxvzc5wwqN+v4LGHrNWcExUbJJ1IRs6v7ArP2kc+D8oZE7zHkbzt6abTNnnu9HP3VuVHaAvw9ZPIS17oRthwun7ZdYiZTeFDviJ6YJmzeeveZDeEbChNiPZ1EnwFgC7hKDVa+GsB616xEDjaaXHvok3tegqmFaQX3EeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744859379; c=relaxed/simple;
	bh=TR7ly/vvz5ltyFP6edke631uJZlsOX6oKroOD8J84yU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WovZ3i20EcCn5Kh13++PMXXU6qpw8X7XZE/o5gqJHCLzMKZT/+YUh8UXFsDXPypQBSEpu++vrBzW4uSN9XCZiNUE7o+xOgVd+5TdiGcZwb5grPzcYoH8UAywpjuX+4NSEdsjYKHLjY5VDbx82+02T346hRBEuggSPnmp3tc5OgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=BWt8O+mX; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="BWt8O+mX"
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-86192b6946eso8306939f.1
        for <linux-raid@vger.kernel.org>; Wed, 16 Apr 2025 20:09:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1744859375; x=1745464175; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Czb8sBa766tI/Nk4lvwnvsle8OYEqChC3mwFvVlF7Bg=;
        b=BWt8O+mXPPAXdHaJqRbmFN0GnHEV8VXCEwl2IpcKjVxYOhhfHz/3gYRkAKhFdevDU0
         CWy8dzyT91iwwIouCk+HB9R1yOACbQ0FOrHkzN5jM8tJzHfw/5nIUKkwSKRdfKiPkULx
         YYnXItQdSa7s/oeV0wNfTl6a6G0TlH2FxolkkDSfASBbAOp/DYpGAUminiWdQtTEIYrV
         z9D/KfzG+LxyinZ6hlgwk7jR3HYJZR12STfXsY3ZZjjKzG9dqpjzeEHjfaoYdXri3ywJ
         U3ExvcXVzBxbiyTrEjqkEZuL6GuY7lsdTQ0M1sJbCsJwhZhUmMVsPDLmdH6+lrfe400L
         JeNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744859375; x=1745464175;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Czb8sBa766tI/Nk4lvwnvsle8OYEqChC3mwFvVlF7Bg=;
        b=Trf406vwN8+YngN6CPGYayzgslVrZo/Zjzwlnp5oJfzsiWEPYjHUr0NOKxwRykGkzD
         X29LnSKDsXrO65QNbcUEaXmduxl8mTuJAAEQ3EIcOKis+iun9nshpnd1IZKtEk7ZHT2b
         do8Gd0LD3qPkERmSsyqW6d41OhaOwhetlAW9/iMSKWxcn2BlN4daNG+so51H1owbRxoy
         zYq998t/XVZFpD2YvNOzvTjYOmYvEx/alvVcUFZCCSTluDKcerCHcaa1Li9F5wKmOMKK
         UD9uYFJxd2XzEUfIMywyRZeqqWJzH2QUNKWNDlZEw749ELZshkZamNpqgD1oTioflzpr
         aSog==
X-Forwarded-Encrypted: i=1; AJvYcCXE0B6BUS4JuIT4YIq78ORbS4MeOVsbi0z4PUjsIXAl7kwCUyXar4P+t9Pf/qUtqCe+CPlVAyonYKm1@vger.kernel.org
X-Gm-Message-State: AOJu0YxowfkX7BMmLj/2icjy5Df3MLOwdbD69kFqUkzcok0CitzwNUPb
	CWxEuzhWPf5D3zZ7z3wN6ftShl7u6LqQpx0nEF2zQCfjNsFHbKQhwQnIHb2FN10=
X-Gm-Gg: ASbGnctgMKYHuy990EuHr4O4kpYIdwzFa4Hxc/+IW4nyD7dD2Q12hnZRLxWA77CaYgF
	YJUXjVcEGwX8SitwZafmusy3pp6DKbsUrWHhuUxVezt3+dGnkAE6iXoVQM1TOxy+P3YZyURYqda
	5rUFSOo3ffASm0vCPJCKBgox1EJy9j84QpgNsH9PqrKIYffaVq2qATbrJs+Eq2P9PIbON/njoky
	+AOgPGgOCA1d57FNwmSD5nvmidAn6mHWV5lHu+VNzuwfcAhETIEv7ubI72OD6qtbTgdEI/M9smG
	KoItlk9/7ItdhJDrkF6J6R00z/z4B9jzwbdNuA==
X-Google-Smtp-Source: AGHT+IFRLIvKLeB9Ixll2OHTXIAT1fXZF5P9WSGz+tIofTSaAqkrC1BDk1bCwYIPUc4zrYzPAU9dcw==
X-Received: by 2002:a05:6e02:17cd:b0:3d3:ff09:432c with SMTP id e9e14a558f8ab-3d815af45e3mr39977875ab.4.1744859375331;
        Wed, 16 Apr 2025 20:09:35 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f505d1597csm3830661173.34.2025.04.16.20.09.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Apr 2025 20:09:34 -0700 (PDT)
Message-ID: <0cb608f9-2537-4522-beea-ed5e7e4869db@kernel.dk>
Date: Wed, 16 Apr 2025 21:09:33 -0600
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-6.15-20250416
To: Yu Kuai <yukuai1@huaweicloud.com>, linux-raid@vger.kernel.org,
 song@kernel.org, yukuai3@huawei.com, meir.elisha@volumez.com,
 zhengqixing@huawei.com
Cc: yangerkun@huawei.com, yi.zhang@huawei.com, johnny.chenyi@huawei.com
References: <20250417021442.1670701-1-yukuai1@huaweicloud.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250417021442.1670701-1-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/16/25 8:14 PM, Yu Kuai wrote:
> Hi Jens,
> 
> Please consider pulling the following changes for md-6.15 on your
> block-6.15 branch, this pull request contains:
> 
> - fix raid10 missing discard IO accounting (Yu Kuai)
> - fix bitmap stats for bitmap file (Zheng Qixing)
> - fix oops while reading all member disks failed during check/repair (Meir Elisha)

Pulled, thanks.

-- 
Jens Axboe

