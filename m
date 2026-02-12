Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B16F3446DA
	for <linux-raid@vger.kernel.org>; Thu, 12 Feb 2026 11:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770895627; cv=none; b=B1PmNI63gI8LFXbGjFsY9ReO6Xv7goe9JCraETNs3KGsO8udI8hOzESgropobwANv8JaoqI/rHOQuuUndEUu0YVkepZTAvqDCPCmbi67f6K4sbeec7OYm8lDBaMDv90E8Z0s2mhQ3TkwKQ9YMpgbhFJ31J4fwR4EBAESndBrXd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770895627; c=relaxed/simple;
	bh=aVKhTR5XhLZI6aTjd89DHSMnmnyhbfHIX5ecRrNkkcQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=tFUN7qyRXCWAYHe1sNIHVYup1/mKAosRR/aRX+FJ2Ck+Eki4wqsW2qaiJ6D4/oQa97J56iYOcNOrAn8OaIjY6e5Y3aH5YG8cv1DQZIiQRNbNAPWKZQt7rG0Y6QJl8ATTTbCdibvyBYE79iY1jTrGNXOMihNDfQBDljeVBjRQijY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=WPqHdssh; arc=none smtp.client-ip=209.85.160.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="WPqHdssh"
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-40945a682b5so3022248fac.1
        for <linux-raid@vger.kernel.org>; Thu, 12 Feb 2026 03:27:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1770895625; x=1771500425; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wCldroI7429Qp90gcUTtFsnAvy8jQqFz5POUC1/x6i8=;
        b=WPqHdsshOW46gzVxYqMEMDDTluwXKSqC6bH8UJmvL1D3EkIuJIan6+kjJCqzM6hrAR
         cvKQITqowRENi3lTbz10VCXq08uEWoMIJzYIAauBJ1ZP+SqDVoqQHXhiCzauZvfOKKcG
         YMTHwwumURO+ZHtNSvmISMW82XvcfqsJT7PilHa4gy2jdQloMbUMql7nXGfqmUroRGLk
         N+haU2ck3QNphIskFdXDJb71s6UX66eYVlqONSqJaxGdF9BHqdxXFMjz8Gsh0sW3YNc4
         poqC1oeHeSzU/cOdsddXLtGqVSwBMOSPKJCn4/A5JeF7lxc+LoPjJJt5Pp79dfv8/SUu
         mlJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770895625; x=1771500425;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wCldroI7429Qp90gcUTtFsnAvy8jQqFz5POUC1/x6i8=;
        b=ldi9SYlxJ12M4EfizMojirO8Zc3hmq1OhGq/n2F0P/8T9uwphT1mQZROUEICJHqVI+
         b4ihqBPuD2Uj8Cc341z/f2fzoEd3rTrJfGgiknXezQo9Ej2xQQrYmmYZQiEfp7Oe7l9J
         pPzevIAx0KNIhZY3JlzBYhUCVUrRcDtofo+QLQ69PqssOtSxr98v3+OPwBQPMcbYW6xV
         2CNh/Rs/8AbzGZEUzLrmig307WUc0ZNwH2nthB2fOj37kX19GYTJnlwEnuP5GzXlEhXT
         XAJTx8bKbdNRuofoLR4YpP12TIcVZ9Hmw2AqfJO+X8Vt3aSzYcGVZt32gC8ZWr7z8AF0
         kQiQ==
X-Gm-Message-State: AOJu0YxxwJmaNgGBOKHI9eXj1yplK1a2IxyCZjedUXeBmNsEcbxdoCEV
	GEL/3lfK4DM9VnXlln7WDq49HKUS4CAKxOHcB2BE6we3uXplQ0Z1uCs/rfkcWRAod34=
X-Gm-Gg: AZuq6aL4iGYpzMI25cwlDhn0n4bT9vcwenMxkqU9NlQhwI+2GOtwyKmhExNT11XaB/N
	iDCQ5l8UNHrMQnHOKECAkxOteEi9YgJZcXJVwd5VVo4ofVa2sXIL0PKldHOzZTPcFwZGKPC4a6y
	nMpqIpaVAIgqzR14qg5Bq0V8Sdk1/DnwPbTVHKwzJ5IpIIwR67z3Po7sGIveA11+zgE//zHlWQS
	4grBr3AJ3LA2vrCJzZ/W2prnVtOSDJKADXf49JnTqPtIOn3tvj+voc1XMfYkqSa4bcypO8ob1up
	3JVizEEEKCJ35V8l5nUAHfNDwwTULfhE5++LPgqPH7nJbElif6y1YGD/cgQc69bIjEWSCAUVOU8
	xEPfiY5lMf+NWvQHrMPcOIVjT6krm6y9TdpNd/XxI3OidOKgKRKPdUzPEbmCp7v6DDDdlqELE11
	mpoPi76DlCn+/338d8Rl6ef3NM6K3SzLwJPAW2w+PMJR+P5w3v79HNMqoLvOp7ftNIXrt3p1Zmo
	bCP
X-Received: by 2002:a4a:ee84:0:b0:673:e6c4:749f with SMTP id 006d021491bc7-6759bf89abamr817782eaf.76.1770895625029;
        Thu, 12 Feb 2026 03:27:05 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6747293e4c2sm2232685eaf.2.2026.02.12.03.27.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Feb 2026 03:27:04 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: linan122@huawei.com, song@kernel.org, yukuai@fnnas.com, hch@lst.de, 
 sagi@grimberg.me, Chaitanya Kulkarni <kch@nvidia.com>
Cc: linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org, 
 linux-block@vger.kernel.org
In-Reply-To: <20260211204438.22568-1-kch@nvidia.com>
References: <20260211204438.22568-1-kch@nvidia.com>
Subject: Re: [PATCH V4 0/3] block: ignore discard return value
Message-Id: <177089562347.419890.12862098263545903682.b4-ty@kernel.dk>
Date: Thu, 12 Feb 2026 04:27:03 -0700
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Wed, 11 Feb 2026 12:44:35 -0800, Chaitanya Kulkarni wrote:
> This version has remaining patches from the original series to change
> __blkdev_issue_discard() return type from int to void.
> 
> First two patches make md and nvmet drivers ignore the return value of
> __blkdev_issue_discard() call and last patch changes the actual function
> return type from int to void.
> 
> [...]

Applied, thanks!

[1/3] md: ignore discard return value
      commit: 699fcfb6cb80a9df67fd2086a1c930d196d709f2
[2/3] nvmet: ignore discard return value
      commit: 38d12f15c4772b5383b1249b2afb0d206a430f0f
[3/3] block: change return type to void
      commit: 453daece381e60df20da16c49ccc6a9bc5c6515a

Best regards,
-- 
Jens Axboe



