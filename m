Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741E33947A1
	for <linux-raid@vger.kernel.org>; Mon,  2 Mar 2026 21:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772485496; cv=none; b=ZDoqYtgj71nCmhAlTPGwJJt+jHjkalhfivh5UrB7pgcQru9xv8xMBndHxN+3UIcgASA/JvPqCRDYSVliQpZAA+MeTJgxMeaxp7ZbR+RmqKDT3DZoNNGyxQxJFZRknPpToPQmUSNdh1Npp+BLoaNt15/R3V2t0ps4d8ai8rMGfb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772485496; c=relaxed/simple;
	bh=bp8MxfLVfOLDFq0aYZEWtSvDAoA1yKcF7Xeisqp8xdM=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=JnFGwTcCCOjyt7hUS9B5s+eNYDZgwisWz+1h5MW17vdb44SI1d2Gwd2e4chvVLOt6XejwyWZF1Le95of2Phee0+xsXt2NoUtmI/WCLqw2RwpEOPPizFjUa3UXqvGanRnZnBgoamP6cf5ICUTFtfzOBXjbd3QsYm6h3RavrZShyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=EwFZJAoF; arc=none smtp.client-ip=209.85.167.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="EwFZJAoF"
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-464ba2bb3aeso3891356b6e.1
        for <linux-raid@vger.kernel.org>; Mon, 02 Mar 2026 13:04:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1772485494; x=1773090294; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A+IPbqMq77bOpkXLRkjJ3UFsST92OHSHvZuEyO94T9Y=;
        b=EwFZJAoFW1Wa8eTWGw+cVu6ZnPfwxnM84odhTiQ6Duqsm2P5Y1dbp6KxVwShV+vDZs
         /k3GnrRHNpqFNe5FSIc4HsyqjV4a9R/5eSw5BxQJ6Az7XUEjKJYHT3dG25ySfAT/ao2f
         wZKRpe0x36T4T9viuR4cwDmZ+YnbgMyaO/2bEtn/DvoRc86skNGgzENgM12YBXESwe0O
         JVrTdR6zGPV734wQ+/w3Fnta4zMk4M+SfsnQiCV9VXSXMMk94F0AnD90o7wG7ETcm6fU
         4Z1F0T1FlHPvuGZkuawZgGcN14vh+yZB3Z5g+k/wMS+D+CCh1MqwxOvgk0Mg6UnR3/Wl
         45Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772485494; x=1773090294;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=A+IPbqMq77bOpkXLRkjJ3UFsST92OHSHvZuEyO94T9Y=;
        b=ZA39ZCXOvxbX8jTBitd/v5Yom5dYmuWDKVM8XAf6PL86uOMlaDF0hxuq/De/jWk/Nx
         dL2SM15Ml0rAzvvruuLNdna0cryPJPTHkYENwFjnOMYetpw9YMM0MdVrCfENBc+p/lNo
         khlZWSnAPUFLhHytfa2HY9bxPDu0DqytJBmfwQ6vV5sZOccASD0nYMmSqK5QEUrCN/HW
         WuqEo3Ax6qQKSrmuXkOX9fS6MgA2eBuRUArAoE0vkD1Zh1dmh4hF445RF8ndGB2MNC3X
         fnBa2d2B5GWlF13MK6/TNiEEuOkSnpwiHslWFcLeb6aUBBjzF5kVC5mtrnctUNV608uI
         MwYQ==
X-Forwarded-Encrypted: i=1; AJvYcCW9N3Q/J/+akxzhG2Ft7EbvfSulLpy2ulmjRqBk2EY6iU/vy/DbK8xvvgyo1e+FN+ARF2QfxAF/2169@vger.kernel.org
X-Gm-Message-State: AOJu0Yzi/8Gu7WpOPl+A0CwIbcCv9k27jpwMlyPhxnXv3w/BC+w34NDQ
	bPG9cqMahoDwXBA2VfwbZoBiLu4T8y78mXbQmgwnUsH025spXOxMI1GQagXUmwVCsNHZe1hxZQ4
	QXaqSF9c=
X-Gm-Gg: ATEYQzzYDr+IlieFxiksppmI8OpvTK5THU6OzpGrJh65YPAcctHTKgcfEFDdRfzw2rM
	82+glBq5m49v/1MS0fn+JpHK2jyPZFdcT2nXgSZEaQdfuonBcD8X+cITPDm3ORGJnWIUn2wy0vy
	hVf5yJEE/Yc9Q6DEOn33BvOlZEyK+G3nBUqrgA0T9wMR0zAWAimX05jsio2TvVcy7/fZyhT/lXI
	LxLay1Cd6EevE0PU9QK/0eigzRtMLFdffO5IQ9/ITc5rCJax4m03y/XIvamN8MQF+1bpVYMGC6d
	C9JKGxgWadjpT+Ylih4qg2UYh86C7WGmHGpl43yVWwQiDN8HPaO5QrDJrie2Hf2jwDbRlml/TY6
	oqOzBwqRacPnj8I+VSDLZiaHs/cL/S220Ooh5FhKLZ23Nj1Karl7TMnWugWlXG6oN9jTfAzaRvL
	YxzGpX5XKVtyp/YQT3wZ9vr/LCa9hGK0D0DNNnC/OidlZ5rOnCvov99h2jocZ3OEQvm8BvaLUWx
	8mA
X-Received: by 2002:a05:6808:16a2:b0:451:4d80:5ab1 with SMTP id 5614622812f47-464a5f0d5e0mr10177242b6e.33.1772485494483;
        Mon, 02 Mar 2026 13:04:54 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4160cff1aacsm12335332fac.9.2026.03.02.13.04.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 13:04:53 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: linux-block@vger.kernel.org, Song Liu <song@kernel.org>, 
 Yu Kuai <yukuai@fnnas.com>, linux-raid@vger.kernel.org, 
 "Martin K . Petersen" <martin.petersen@oracle.com>, 
 linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
 David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, 
 Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, 
 Andreas Dilger <adilger.kernel@dilger.ca>, 
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, linux-mm@kvack.org, 
 Damien Le Moal <dlemoal@kernel.org>
In-Reply-To: <20260226075448.2229655-1-dlemoal@kernel.org>
References: <20260226075448.2229655-1-dlemoal@kernel.org>
Subject: Re: [PATCH] block: remove bdev_nonrot()
Message-Id: <177248549254.151113.14982963467044589269.b4-ty@kernel.dk>
Date: Mon, 02 Mar 2026 14:04:52 -0700
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Thu, 26 Feb 2026 16:54:48 +0900, Damien Le Moal wrote:
> bdev_nonrot() is simply the negative return value of bdev_rot().
> So replace all call sites of bdev_nonrot() with calls to bdev_rot()
> and remove bdev_nonrot().
> 
> 

Applied, thanks!

[1/1] block: remove bdev_nonrot()
      commit: d47f7c173262bbeb09645ec72bf91755eed6b1b3

Best regards,
-- 
Jens Axboe



