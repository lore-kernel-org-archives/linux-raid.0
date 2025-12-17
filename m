Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 389352D061F
	for <linux-raid@vger.kernel.org>; Wed, 17 Dec 2025 23:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766013528; cv=none; b=lLNRtx6vrJWdsQVOkboMfuMIA1fMUCN/i/kLpi1hxy5GzfBuoNsLxMSHyf4jwSlSD1empCXrmsttMGQbsoD5c6TtDxHrEr6jD9+nHY/i7FDTmx7CzwlFzb+5JCWEWkBy3AIMs5jbkgfUZSNT+lGCwRrQg6AtHXvRyPYDlID+49Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766013528; c=relaxed/simple;
	bh=C1X5R0T9A6CrUnxpIm/QVXVuRULmzTp597QRk97zyjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OX2bq2e0Cn+5T4JfYY83/QUXoQU0tS86k8eY7YP5kd93XhDiLcqmAzEEYvvkn/oi5VbD0o1WxEj4zgqW3zxCzaNvklOdgH8hdlqbPOUHLNiPgnPpJQDvt62Y+UzznHFEmEfREZVPMvKBBco6pFZQh9aUpJ3cFDJXBTtG2sURikA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VBaT4sxa; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VBaT4sxa"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-595910c9178so14320e87.1
        for <linux-raid@vger.kernel.org>; Wed, 17 Dec 2025 15:18:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766013524; x=1766618324; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AZvc3rVI0di0d/Re6Le5Bvc+vMvJtdhpmIxMnxjb6tA=;
        b=VBaT4sxaHFvfVHw/0PNR0mma9L9CQCE0t1LZsPF9klP2ecyZEgzKiX754iClqRnz0f
         GmmYZH9YBVrmYyy8S74MtCYaKuLLOE2twPEfhgrGbfkH8UXctcxVy2vj9OV5ntO4+YDt
         N24t/STd7wbl7G92s0Ny+GD1Htd8YjaiuuS7DGr+Iv8Q9IUwNUEXilozkJvTMnE86WQu
         MnZ+OnIJvOTufXzIWehEwX5Rn+kCV2O/NoVJ2bWPv2EgbMUdijMRcUlXoqnDdN/RqdV2
         qtSKWp2M81Sd6yvPFFJro9CHX/HMKbmz3BzLch4xdn6FHJrroyI4t4EVNBxfQxTI6t+V
         6rDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766013524; x=1766618324;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AZvc3rVI0di0d/Re6Le5Bvc+vMvJtdhpmIxMnxjb6tA=;
        b=rcGO+ifSEIrvJfas5B2qzULUMu6Hvq7ySgQteU3oYYyoUesF00Int8CKg7JiwxHY37
         PGv8nHk9DfgcFrHIHeNd4vMLIhHjhrLb57wd2BLrRwrS7cq+N7UMDaPGDr1t9zPhfPKa
         Y6kcYKle4MEHkFm/YtT2+9bV+tQWqXQr8RrgZvl5NdAS3JOKfn5OTl5w2Sh3fnOhuruk
         7YzUTOLn/qVH0X8OEGNHZYRggJDPOaWIAedlDjrXXm/kj0VMA8/U3Z437GD87RrdwncH
         /lcPkGqmRPQMNeWDhHakPetecL6lOhdDLiCkHjIzdgbghWuWEC4yBuj2BlPjQV1Ighfv
         mN6g==
X-Forwarded-Encrypted: i=1; AJvYcCUQV/mferp5ML6aM6gvECFwRqe7SSw5QVymcA34tyg2g7L0oMKNgVhYgU9E6KxrmSJAs/6EF8wOMWMF@vger.kernel.org
X-Gm-Message-State: AOJu0YzNHlv/Mb2N+nnbusSfMKnCaO38B/Vl6oT2BazlIbzcqUS/9LG0
	OUZI9EmOweIqfybysz3Xd9gUzRLx4wWkqbh91zR5PQ9KanS+l+I7claJ
X-Gm-Gg: AY/fxX4BASPRUQVpGRzPfWDd8gwOMtgyOkDf2oYnbk69lwKstaeml8hu9WPAz+xVMif
	669iku1Y9KdMS98fmjj7Weq1zmJ/nw9MEhG1kbUgYa5vaoSGW3QtIxay/4nczrn74FLoFSVuZz5
	Px9IkVaFstV/pTAlgrEdL+hFtYhLn9tuRUvnFJk7xVmvWNbCUvSMcTM1E1g46j9cTvO57JGlksX
	kbqIkAXTYW+xwnhF2SjCqge7QdPFfbxNfM2UPr4sMtH1be4li03Z9y0HvuhBeY7ketOdmqmwmur
	BxfZ5Mhyn+pJhmPSdCFKcl2OuZVMnajQWiCRK26ZzHWhIMqYIl6XW6OnSm7/ESl3NlkcDAltbZX
	+y7rCDfKJIUzouI3MNFx/R8ZiBWtDzH35k1pk9s+FSwYT+kUm+CU23HloKbGDIVaq9r1eKdZPEk
	x4iN3oZCAU
X-Google-Smtp-Source: AGHT+IFoFgIAi9PMNEfIKCxeozWxswujwd1S6MJvMAmdk00BzJYAqN7Mqo6fE4Jz6OZ88KHyEwKy2w==
X-Received: by 2002:a05:6512:3ba2:b0:598:edd4:d68 with SMTP id 2adb3069b0e04-598faa5a3bamr5789014e87.28.1766013524025;
        Wed, 17 Dec 2025 15:18:44 -0800 (PST)
Received: from localhost ([194.190.17.114])
        by smtp.gmail.com with UTF8SMTPSA id 38308e7fff4ca-381134b5011sm2807821fa.3.2025.12.17.15.18.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Dec 2025 15:18:42 -0800 (PST)
From: Askar Safin <safinaskar@gmail.com>
To: mpatocka@redhat.com
Cc: Dell.Client.Kernel@dell.com,
	dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-lvm@lists.linux.dev,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	linux-raid@vger.kernel.org,
	lvm-devel@lists.linux.dev,
	pavel@ucw.cz,
	rafael@kernel.org,
	gmazyland@gmail.com
Subject: Re: [RFC PATCH 2/2] swsusp: make it possible to hibernate to device mapper devices
Date: Thu, 18 Dec 2025 02:18:37 +0300
Message-ID: <20251217231837.157443-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <b32d0701-4399-9c5d-ecc8-071162df97a7@redhat.com>
References: <b32d0701-4399-9c5d-ecc8-071162df97a7@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Mikulas Patocka <mpatocka@redhat.com>:
> Askar Safin requires swap and hibernation on the dm-integrity device mapper
> target because he needs to protect his data.

Hi, Mikulas, Milan and others.

I'm running swap on dm-integrity for 40 days.

It runs mostly without problems.

But yesterday my screen freezed for 4 minutes. And then continued to work
normally.

So, may I ask again a question: is swap on dm-integrity supposed to work
at all? (I. e. swap partition on top of dm-integrity partition on top of
actual disk partition.) (I'm talking about swap here, not about hibernation.)

Mikulas Patocka said here https://lore.kernel.org/all/3f3d871a-6a86-354f-f83d-a871793a4a47@redhat.com/ :

> Encrypted swap file is not supposed to work. It uses the loop device that 
> routes the requests to a filesystem and the filesystem needs to allocate 
> memory to process requests.

> So, this is what happened to you - the machine runs out of memory, it 
> needs to swap out some pages, dm-crypt encrypts the pages and generates 
> write bios, the write bios are directed to the loop device, the loop 
> device directs them to the filesystem, the filesystem attempts to allocate 
> more memory => deadlock.

Does the same apply to dm-integrity?

I. e. is it possible that write to dm-integrity will lead to allocation?

-- 
Askar Safin
