Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB1329C33E
	for <linux-raid@vger.kernel.org>; Thu, 17 Jul 2025 12:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752753714; cv=none; b=r9bDFc2aWhwW8qA11PwqT+H4zbeQqE72bev2/FZaRO823s9kFhAQrxxWpOlL6VT3cm0Gzkpfw4bCxT5ckAD+m85oRmf+fNln6B1VSNAd9kYYVFPtZyOuAV5mepVyOxbkXdJV3MLk0DIwTtbYevr1YomoqyO7bcKZMu00jWkqIN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752753714; c=relaxed/simple;
	bh=kjEyn7nEjF8oiVB6GgmGedSuLAr7HCIjBycrDFOZBKY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=eC5mxr6QPzod1WffFr4KPcgM0siKtouCg//+/ROh9b6IjmI6VkhfLbYsDa8DFwy2hpJ+xGl28XAIZ9Qpkpv/1wmOm21JK0UBf54PvTTp4CzgkWj4eMDSK+1OjsDrxhWUupDCs78K2A34plNQCrlGeTGJ60MmLyznWAIBnL/9cpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=lYE8f5kU; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="lYE8f5kU"
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3df210930f7so4230205ab.1
        for <linux-raid@vger.kernel.org>; Thu, 17 Jul 2025 05:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1752753712; x=1753358512; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=61ZOPEc1Npv0N7lkKyvYLgeXrgu1p1u4u8vtKljsiog=;
        b=lYE8f5kUqvO+XsNQ/XO+6VW86/pIpFACuVd/pl7Et4Hw1+gRnpawN95JAutzedDP9O
         nkCqB/eoIGz5n0adNm9VbJYr0k5R9L1FbylvG+rCi+niTJDUM7lCrMGzaUqROeNilr4C
         RJNQP8zBbrPO+InZ0fQ9Lip15LzVZdQRSrgoAbAhKHUcyiKdo+jfxxadpgFP7yv7kiwr
         nyLorzD87mtZU4OL/Yfc+WgM9G6Rw6BMZarx6Mu9CECKyxsRD6RknxcXjhKhpiIFinEU
         Yud6DdQ4JHeztnXArJpr+sKT1mMdlIGKg6syWxrZMg7ahk6uFenscA3o8UChYh1/2zpi
         ExAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752753712; x=1753358512;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=61ZOPEc1Npv0N7lkKyvYLgeXrgu1p1u4u8vtKljsiog=;
        b=Io9TqRLkPa+VFVHnY9kU3J6ZEQy6egXn5dVVgr9u/uDwtyZ52m4VlaqzhAjsN1VAl3
         o8SwtBrylRLvJwO+Pj6zJqUVsY66w3X73Ki9aTmY16iSwO36uSTdx39Egx0rPpNH13aV
         evtXomuzfCVxZpY69nwsxd8xMqc41gxWhDcGN9VuhXUz6qLkUrxJEyQa0TsRt/QEb42J
         B842gsRfhPOWBBXdKtEi5XkXFQf+tR/9BSTK8hvDUp2cRATxL38ABE4k/fX/TNmOhA2i
         luijgA/ZNasBWMsI4pnVqvwlBkDiBMDtPvr0fgW5Fc/Pqv3vV2shyPYcNNY5nQI+2SBH
         hBAA==
X-Forwarded-Encrypted: i=1; AJvYcCUujQHbhixL91UDoau+yj8saYtClIhEwZYTY0UeOPGZRTj5r89JsuucM/FFLPz8STFvcmmwhBU7aVTQ@vger.kernel.org
X-Gm-Message-State: AOJu0Yzn6rlCKBNyVZriOok/WsTC9zcLIrYdEbxhv0drrw6hxxMXS+hu
	sVe8Pp4Aej3wi+7mflB7m4jxqp5iMXshStJkS2Z4+KbsSUYhsUJfUSCMw4rJMKTDJdM=
X-Gm-Gg: ASbGnculo/7aD80Tmhzj/vTZx/BB2jVdBEyUxCJU0k+aYZB/K8YZgvxbD9/+lxGVWW9
	e1mbMBb1CEV1DSQDzP0ntqgGAhZRZ7a3T6qClgUL+mITt+kU/l2T30mdsR3VQm1wDBhCKnSWB35
	My0V0Lc/AQuQBPRgLHbsXxWAet0WkgystChpFOQMl66FDzM9pROJxhV5V3WcDFSWjWKZhdQNXQu
	VHjb4MadW1ewRroimWJscqqz20xsTv/agYOF0sKzvQtDbKzEp2rf82bWyiwWkAg++QYSxiTtV6x
	DhubEeg6gXMo8Gb4ZhguIHk20BA37JjxLTo9GIEH8FaBilP66Cv+Q7iFpSHtZMgui52QLalcvhl
	4cHmBMCNlPbErgg==
X-Google-Smtp-Source: AGHT+IGuqUVz1MlM22DWouaSIEqVc7JUz/swP0ZPOQK4pvQiO3B+o4V938h5qOKiQPbhSq72i+cb3A==
X-Received: by 2002:a05:6e02:4618:b0:3df:e7d:fda8 with SMTP id e9e14a558f8ab-3e28b718bcamr29664265ab.1.1752753712400;
        Thu, 17 Jul 2025 05:01:52 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e24611ce92sm49563745ab.6.2025.07.17.05.01.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jul 2025 05:01:51 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, 
 song@kernel.org, yukuai3@huawei.com, hch@lst.de, nilay@linux.ibm.com, 
 cem@kernel.org, John Garry <john.g.garry@oracle.com>
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
 linux-raid@vger.kernel.org, linux-block@vger.kernel.org, 
 ojaswin@linux.ibm.com, martin.petersen@oracle.com, 
 akpm@linux-foundation.org, linux-xfs@vger.kernel.org, djwong@kernel.org, 
 dlemoal@kernel.org
In-Reply-To: <20250711105258.3135198-1-john.g.garry@oracle.com>
References: <20250711105258.3135198-1-john.g.garry@oracle.com>
Subject: Re: [PATCH v7 0/6] block/md/dm: set chunk_sectors from stacked dev
 stripe size
Message-Id: <175275371113.371765.7347642796595215334.b4-ty@kernel.dk>
Date: Thu, 17 Jul 2025 06:01:51 -0600
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-2ce6c


On Fri, 11 Jul 2025 10:52:52 +0000, John Garry wrote:
> This value in io_min is used to configure any atomic write limit for the
> stacked device. The idea is that the atomic write unit max is a
> power-of-2 factor of the stripe size, and the stripe size is available
> in io_min.
> 
> Using io_min causes issues, as:
> a. it may be mutated
> b. the check for io_min being set for determining if we are dealing with
> a striped device is hard to get right, as reported in [0].
> 
> [...]

Applied, thanks!

[1/6] ilog2: add max_pow_of_two_factor()
      commit: 6381061d82141909c382811978ccdd7566698bca
[2/6] block: sanitize chunk_sectors for atomic write limits
      commit: 1de67e8e28fc47d71ee06ffa0185da549b378ffb
[3/6] md/raid0: set chunk_sectors limit
      commit: 4b8beba60d324d259f5a1d1923aea2c205d17ebc
[4/6] md/raid10: set chunk_sectors limit
      commit: 7ef50c4c6a9c36fa3ea6f1681a80c0bf9a797345
[5/6] dm-stripe: limit chunk_sectors to the stripe size
      commit: 5fb9d4341b782a80eefa0dc1664d131ac3c8885d
[6/6] block: use chunk_sectors when evaluating stacked atomic write limits
      commit: 63d092d1c1b1f773232c67c87debe557aab5aca0

Best regards,
-- 
Jens Axboe



