Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C74F642A82
	for <linux-raid@vger.kernel.org>; Sun, 26 Jul 2026 12:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785068059; cv=none; b=kTED1ECqxHgQURY4fo7MwtROhvz3Ic3LfiQxL5NdxofxmlcLmJ45C6Dj6a6rwCcpUO+YoHcvV+3dBMWu83Ih3Nu81FnplnMlP50E/VfGBF5aoTRhtr736EhzyQX3RVMBaD25wbjZ5I9GC319q1SP/WZyBOmqSgwTqXsOJC93QvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785068059; c=relaxed/simple;
	bh=Ryv1otfh7IPPl2HE5VEnU2MnTcH6bFVHILVl6lyu9tY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KCsrQ69Bsas4N60E5K5A+mCvjhIp0vLEctyNRe0msc1KI9Ntue+nM6yjJKZSw7fCxgfesEIDDOuFQy7Q2T//na8dZDHIIzh5biKYCL6JFTI9/gSlMnRtAP3IyyQKi8LO3wb6Szn9O5YxhwAn3++spSg835iCoypiEVQ/Qs9+bgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=Y3qrrUQZ; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="Y3qrrUQZ"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-47f97d310caso1242716f8f.2
        for <linux-raid@vger.kernel.org>; Sun, 26 Jul 2026 05:14:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1785068056; x=1785672856; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7iENh3rDRMSyWSKiTiLHxFOwk8lzmAgK7/WSV6dq3Ls=;
        b=Y3qrrUQZi8217IGYAQVJyF2lO9ul53j7G2Pz9Ru+R00fd4NbyIafgIiq/6fAB8rvIL
         QKSKEA4dHY0/bbQJyIJL/lWW3/5IHP+spQPB6h7ac3Pv2hfVShjjWjPNJli8GUp4hKuc
         mBYoypInEbjK+VH8IqI13TBXB4HqJk9Gcm/x7qogiIWyAsCasccyyIOghcb3jrptNk69
         uPR4SKN83iPZwgPGoFFBdWoSs5sdIZms7ude+kr4U8X1WnFHVp1jboSCmYtY8ea2xyZa
         9VlEeGF/9UxkW8LH2QNJZypmpG9oj4tce985Q608vABLaBlLWl47K6+bp4q5oenl8/Go
         jf4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785068056; x=1785672856;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7iENh3rDRMSyWSKiTiLHxFOwk8lzmAgK7/WSV6dq3Ls=;
        b=K5qrFN22ueiguWkECflk8Z1E4U2PjHnLQyUC7+5Mtts7N8YTwsjB7emBGXS59kP583
         gSh450iBN78DTK+XbJBaKyZEGOykJHabJ9KG2aiZBMRFmTo1kpYMirC5qazmkmabp8a/
         bGj4m5cS/+q32d3rUcmp+6Vv46KePcGq8zCvcQt3FlScoaRvBVh4/bOB1u7iVbwechsf
         ACP2lRCgZuY1w1qgGfXTjR5UgJ7FH4wzG677wDYhw7ChyKT52t0WPq9bQQiv4VILqqFh
         hNVFBLChLhcypA+gpv82FSCYjRIo6WACL4ZHNmoDtV3hME14VlHm8BD8N1jVBk9i8FdI
         jqQQ==
X-Forwarded-Encrypted: i=1; AHgh+Rpo7i/7WKgLgV4HxI/nBIWa/4qx7ON6bP1YlxWQAqiQnWIsJSiKU3E0zoi8/UUwtFJuUMSiBfg2hHrW@vger.kernel.org
X-Gm-Message-State: AOJu0YyaxcNFaLNUwQXtwOGHG5VPBq6JjNcdTJCfyA0SR+h0mXLVsZqe
	a3S645lkxB4jjCpPx03ot6lN8oDfT0N7SquMntZ92IVu6PRNdQPWBd49m/1Syzivow==
X-Gm-Gg: AR+sD11GB4ToA0oqFOnRAI7rwD6WEGwzpDrQBh2Ym1WJxNvbtMXyHGAIWNTVjQ5VfHJ
	Xa3y08uMfGzXVWw9DaczRLV/7j1yuZkMIr9vyGlMdOsuHhyZURvksqnaWIyapvKBHDCl8yS4d4y
	aISIZRdtLdDRKFO+4LH3oVVW95jACJpuE/GXgZKpzuxj8cSxUoQmT9uU/OwLL1LCvmLloySAGIp
	xRiaRBrol3jrjPLnKymwYj/1hi18jSWbp9N02fdKLAf9HL/kF3T414UpucDUHUcoxaHDMIhCdyQ
	xl0FNI/jTkaWbjq/SVJGbimzv5/F54s8u71Y4Or6557Y7fpiK1qI7VsYmi0+Bb/1NlwgYSr1aWw
	2KdpMvH6vCApYRnoHe3dmnV7kPmVpqux4UBJqk65i6k44GX7nOvZ3L01ImJpMBGrJrRz7xcsiO1
	+5YrxUEp3z6pPLLneayv58PsThoikPB5JKAyQEEXufGuWdilNTW/qIgkwQvWoXmsPfY1boWOX4r
	Pry9ZcmVmRDLA47+MqmnMO7c9SGhpi/mpicLcI28g==
X-Received: by 2002:a05:6000:2387:b0:47f:80f6:afac with SMTP id ffacd0b85a97d-47f9fead270mr5703794f8f.49.1785068055869;
        Sun, 26 Jul 2026 05:14:15 -0700 (PDT)
Received: from meshstor-pc ([185.87.42.56])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85c6287csm40370376f8f.25.2026.07.26.05.14.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 05:14:15 -0700 (PDT)
From: Mykola Marzhan <mykola@meshstor.io>
To: Martin Wilck <martin.wilck@suse.com>,
	Yu Kuai <yukuai@kernel.org>,
	Song Liu <songliubraving@fb.com>
Cc: Xiao Ni <xni@redhat.com>,
	Li Nan <linan122@huawei.com>,
	Martin Wilck <mwilck@suse.com>,
	linux-raid@vger.kernel.org
Subject: Re: [PATCH] md/raid1: create serial pool adding rdev to array with serialize_policy=1
Date: Sun, 26 Jul 2026 14:13:52 +0200
Message-ID: <20260726121359.2173478-1-mykola@meshstor.io>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260723112741.1206836-1-mwilck@suse.com>
References: <20260723112741.1206836-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This reply was drafted with AI assistance.

> But when a new rdev is added to an existing array in bind_rdev_to_array(),
> the condition at mddev_create_serial_pool() causes creation of rdev->serial
> to be skipped. Fix it.

I ran into the same early return from the other direction, so I can
confirm the analysis: the new rdev fails rdev_need_serial() (it is not
a write-mostly member with write-behind configured), CollisionCheck
was never set on it, and mddev_create_serial_pool() returns without
allocating rdev->serial. The first write routed to it then crashes in
wait_for_serialization(), which is gated on the array-wide flag and
assumes the tree exists. serialize_policy is array-wide, so creating
the pool for every rdev bound while it is set is the right fix.

Reviewed-by: Mykola Marzhan <mykola@meshstor.io>

One interaction to flag. Patch 3 of my P2PDMA series changes that
raid1 gate from MD_SERIALIZE_POLICY to per-rdev CollisionCheck, so
that writes which skip write-behind also order against in-flight
behind I/O on write-mostly members (the behind path already checks
CollisionCheck; the non-behind path does not):

  https://lore.kernel.org/linux-raid/20260726113229.2154269-4-mykola@meshstor.io/

For the rdev in your report the two gates disagree: without your fix
it has no serial tree, and the CollisionCheck gate would skip
serialization instead of crashing, hiding the oops but not the bug.
So your patch is needed either way and should go in first; with it,
every rdev in a serialize_policy array owns a serial tree, and the
CollisionCheck gate covers everything the old one did. Patch 3
carries a Link: to your fix.

If you see a hole in that reasoning I would rather hear it now than
after either patch lands.

Mykola
