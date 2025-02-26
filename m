Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86C69221542
	for <linux-raid@vger.kernel.org>; Wed, 26 Feb 2025 14:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740580739; cv=none; b=SII5q6/3EBQ2YVqWTw+rIf83YCaSMKW4X8wCjX/5hXofOmDRQvm0MSgmLj7lpVptB+eZLl0RG+bH0wz0jV3Z60mHpf4BaIH/CJvY4P/QsGbLp7tOit3bGtGKqr1g3xnXxrVk+oVxBvdscSxIy2eB8RUs6OaMR3rkJ6WhMue+9KA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740580739; c=relaxed/simple;
	bh=4HzSOBJ7v/xi/lFkR0PWK9gzb3mxTpLXn2xOOncdSSk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=S66cnmOmZG4OOb0+pcxAdXb/nWI084yg6+69BsT1lByBeYY1+1lMBFEfmBfNz7v79dfrYV8rfBe3AuayoMggNEXJPuM6B5kc7+vk77PG8qeo39hvczf5cO0+C8BENeClr58+cxa8V7fUQgAb5RMDOf6CjSeYxRb7FxzFqGIDwPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=IkfnSWPe; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="IkfnSWPe"
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3cf82bd380bso58984945ab.0
        for <linux-raid@vger.kernel.org>; Wed, 26 Feb 2025 06:38:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1740580736; x=1741185536; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KjfGHR3mANWfNEqN0oG3qrm9QtKnyMkYTku5fjSXWXk=;
        b=IkfnSWPePUAFO7CBYRbJqxdc3BVYrs4Lk+KOvPFCqIV78nLxnvso86thJyWI1ZwGqq
         GgADpSnNzeL8ADv73xkQUiiBIH2j3J1+2Ixfr5YJtLtePexzYORJiSCGs35atUB7KSPV
         MkjQkenBiipROTv7x6hvQ5oq5qWMMRg814mfDqbyhKc+WBpNt7yZDIsb0gC/XuNvm3Y/
         7ytcXJgjuZDBpYj8EaFP/a/D0nF3wsqmQbWJRZoez4R1IYC7bGvgFQc+BedCD+wIhfk3
         BikEAjX94JCdt7VNtqy21YmpuU/mGeT4BunV+YCLNplbLufzP/Nxo+98exaIRaiHd3pO
         QnrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740580736; x=1741185536;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KjfGHR3mANWfNEqN0oG3qrm9QtKnyMkYTku5fjSXWXk=;
        b=Z3N41/WnF/fQKN6jTWEnn9mDhfe7HA7BCQpKarUOF7hcFV0+ufyTv7OiMPgv54pOLc
         ximWnPLp/3yBH11/YEJeQXyz4cOHyClLkqDQynlrbAnXuWY1ydI9Zo5DP5gHF9V9Obs2
         yDx4osBdqT6BpVcnNyilxN7HgyP+98WfQn+zmcAIeGgZA7v7Gsqy55kqBpkOyvb8QBTW
         Mw2A7JoH+MjFL3Zessfdo0SdNdv7zmx8+8qDS6ogTcs5E6KEGw3kbbA67TlJzdi8rxaE
         XvRJaeM9x8O59BW+TFze6aXRJdt6xv2e4XEL/BfPcUce3H+piyqj1+dy2Br59NIFQqm+
         ecSQ==
X-Forwarded-Encrypted: i=1; AJvYcCUE5eofGktJt3bwKhKs3McqMeRV7yaqMLgsajvJ9SZM8IXRMWbmm/DeNy4/ML32ytzxls//NG/GoZ+K@vger.kernel.org
X-Gm-Message-State: AOJu0YzamatjYI4Lr0BdnsZRPDD5VCv43VO0UYKK3EOHmkmVUn4QIaUj
	U79d5SURICKH7PBiUZqZwF4lpnw5XYqEgPnII7fHS5QtXgkyIPmBC5xfcJ1QTpY=
X-Gm-Gg: ASbGncu1KIq3iGWxtYy8XOmA3Yylg/cCqfTskR/BlqY+Sjs0KVFIEblDgVhQPphEUPm
	nyowx6M4c6brE4Z60XoXcEtmF2oRZeVGqIL0Rabw5a+RoP0XvKZitp8BEF6Yx71P8q18mvrrahl
	eXlDhBqU0Mfg5FsQnCVLi39H9ntyt1VJWIZwpjAJCq16bFxPJh30SfudDGKrgQ5HSPDbV/Gz2Xu
	FOcWDsuTlf7pVWpMssSktGRAiip+nyiJ5LBV71jDCwMJJEbCfwvKSd2qGXk0sxr9tu1ZVZmONeH
	5iqp8wA0aZX4I+uN
X-Google-Smtp-Source: AGHT+IHflMMR06CSDj0x1e+Hr7qg7IFtXxL9jnnQbF/txci+w+Cb8i5OqK2W58Pz8WpyNLiBoDGK+Q==
X-Received: by 2002:a05:6e02:3d83:b0:3d2:b930:ab5b with SMTP id e9e14a558f8ab-3d2cb473053mr193915355ab.10.1740580736635;
        Wed, 26 Feb 2025 06:38:56 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f04744db05sm945841173.1.2025.02.26.06.38.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2025 06:38:55 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@lst.de>
Cc: Mike Snitzer <snitzer@kernel.org>, 
 Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>, 
 Yu Kuai <yukuai3@huawei.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Kanchan Joshi <joshi.k@samsung.com>, linux-block@vger.kernel.org, 
 dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, 
 target-devel@vger.kernel.org
In-Reply-To: <20250225154449.422989-1-hch@lst.de>
References: <20250225154449.422989-1-hch@lst.de>
Subject: Re: split out the auto-PI code and data structures v2
Message-Id: <174058073532.2232453.9396018019259516741.b4-ty@kernel.dk>
Date: Wed, 26 Feb 2025 07:38:55 -0700
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-94c79


On Tue, 25 Feb 2025 07:44:30 -0800, Christoph Hellwig wrote:
> this is the tip of the iceberg of some of the PI work I've done a while
> ago, and given the current discussions it might be a good time to send it
> out.
> 
> The idea is to:
> 
>  a) make the auto-PI code stand out more clearly as it seems to lead to
>     a lot of confusion
>  b) optimize the size of the integrity payload to prepare for usage in
>     file systems
>  c) make sure the mempool backing actually works for auto-PI.  We'll still
>     need a mempool for the actual metadata buffer, but that is left for the
>     next series.
> 
> [...]

Applied, thanks!

[1/3] block: mark bounce buffering as incompatible with integrity
      commit: e9945facd48d2d5da87fa247f5d6a19c23d935fd
[2/3] block: move the block layer auto-integrity code into a new file
      commit: d2cfe5ceca59b74ef96bfe00632e3927d00c9918
[3/3] block: split struct bio_integrity_payload
      commit: 1972a1faaa026eb34322a2b4fcbb3c28d68cc5e2

Best regards,
-- 
Jens Axboe



