Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C3AE14AD24
	for <linux-raid@vger.kernel.org>; Tue, 19 Nov 2024 09:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732009774; cv=none; b=S5NKKarXcpLSsx2wfEUldOuLoQGxeD+2Cjq8bCDlUd2J8WVzx2ZtlTXxm7JWo1PTEydEUKFb3rEwYaJoOOtTEWtcsJaWVXZ/zc2hZttIuXdTOiNGUt/cPuUTG3E2dpsDybWz8NShpqAMvIK35ojoHhblfvsYLyDTNGww1habf4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732009774; c=relaxed/simple;
	bh=lgopZdd6v9xAoh9CPgG7G6P2Rctls1aMm/4WV1OQBlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QjywVWSpzeyG1+lw26Rm633U7/KWdX9uAsWbLJusqhPZaarDsrOQglh9dXEoQ24hFuJnJHVtSu552/15K10cVVC2asTlBmRJlNBTVjS7IYTI9XzfFtOxoLKqulYNXGRAL0rymQIFsePioN/6FgvhGRCCP1cIc7jpaulpHIhB5Lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=YWBcs+Kg; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="YWBcs+Kg"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5cfbd7c5e35so404479a12.1
        for <linux-raid@vger.kernel.org>; Tue, 19 Nov 2024 01:49:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1732009771; x=1732614571; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eP6utXSspykskYzsNkWUBuQWYEnMFsie+2NCl6mM1/Q=;
        b=YWBcs+KgbMhR9KMQpV0aa4OmziYY/0GS+F532ii6y7hRkUH3HPSkwGs9qzRPgo4Rep
         nE44Lh1cbSL0/0GuBGtlifyiLRisJlSJ4eJU7WhNLOCobq+d4euMtYMinoS8fiL1Pjfj
         VPVWuvGeokhOqD/EAZfiXvevvOochHA2hOMHOq0N+BjQ0CaxJ1FWC/3LK/0R8+/D+ZpX
         KiyyrxJHwISIynv+6jAHrBm6V3L6L7KglW7Mskf1V5QldN3pN9z/tILI5BPx3pXyIjo/
         T2l/JvoeySpPLiF+EFumuGnAq4aYIsXtlH3xGLmkxsqPMg7m8DFdm1SCxzBHysS5R9Wo
         N4vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732009771; x=1732614571;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eP6utXSspykskYzsNkWUBuQWYEnMFsie+2NCl6mM1/Q=;
        b=J5u5/MyzfIL4JiLeGGoWvf7RXgzzBCVCmHeHHkV6HpxyOCI6X4T9OeUB6q2TBQjNjm
         XYtrsipY65WZb6XY2y/YVzIBNQAEhpnyfwSpew5IzgC4bYnoj/G4yI4hZLMZoi/kNiAa
         lNyGOiEu/uc4iaXbkxjlrv4NmMGHKK4pvijg1X39MmxX9pdsPMBGjagc3FmB+TMBDE6d
         ZvXFLZrFG4wLmws1ejGkEa0l+adx/H2ceyVfIy8g590dRVHMtNc4lkLNVMhxDBURG5FW
         nAtC3Q1SZvOgCzMUDl9CM8CX/BJ2RQVXg7hKGLdzTopvhNIc7jsQbWA2EluDIjr3kDvC
         RywA==
X-Forwarded-Encrypted: i=1; AJvYcCXJ72v8NNNyyQS4zdvVJ9rfKNbdO1NVhQTb0lKCTBpD+SErtse94hgv+woAWgR8q83FLYuj4ChcAsqG@vger.kernel.org
X-Gm-Message-State: AOJu0Yzh37RIDyd8B4aemuIx79/rrMO3sTdhMMvpNJYCrlM232BjQMtj
	sBZ8AfmkmPPcDGkXV4NWiQphvsj7ZlWJGVTkLpqYGytzykj+gKpbBFxSitIEDto=
X-Gm-Gg: ASbGncvHTcrqIfGcbh1m7wfb2L2IF253n0OTGITznDfwcMfUvYZr7/9yUOzM2hBx1Ge
	j6a7KjkPk/oN1F9XkdByJnuVAt7ojr2VvYx0jw7443yLYIKUrGVTeS9QapcLogqJP6VkW9kzGvm
	czi1evWPok3cgvLvzBRb8prAKpwoJDqyqWBDqoCMPaD23SLHWMo8YS/iMr2IaqobaKF4Qayz/JB
	sPYnqFzhGSYcGsKMCQDLbPdSqFn93ob7pCBplRQNMTgWs991zkGXUnoGgUd/eXWsrieKrJCnLo=
X-Google-Smtp-Source: AGHT+IFwGycoY5tmfGgoWai1RPCDaLKxzMqxyguqzfyyT8M1bLxtmfQi8zo5SFAqATNoMeg5yALTxw==
X-Received: by 2002:a05:6402:50ce:b0:5cf:7aad:bed2 with SMTP id 4fb4d7f45d1cf-5cf8fc4210cmr5229935a12.4.1732009770647;
        Tue, 19 Nov 2024 01:49:30 -0800 (PST)
Received: from lb02065.fkb.profitbricks.net ([2001:9e8:141f:2700:f5a7:4035:a697:97ab])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5cfaa333720sm3306563a12.61.2024.11.19.01.49.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2024 01:49:30 -0800 (PST)
From: Jack Wang <jinpu.wang@ionos.com>
To: yukuai1@huaweicloud.com
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	song@kernel.org,
	xni@redhat.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com,
	yukuai3@huawei.com
Subject: RE:  [PATCH md-6.13 4/5] md/raid5: implement pers->bitmap_sector() 
Date: Tue, 19 Nov 2024 10:49:29 +0100
Message-ID: <20241119094929.148060-1-jinpu.wang@ionos.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241118114157.355749-6-yukuai1@huaweicloud.com>
References: <20241118114157.355749-6-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Kuai,

Thanks for the patchset, as you mentioned both both hung problem regarding raid5
bitmap, just want to get confirmation, will this patchset fix the hung or just a
performance improvement/code cleanup?


In patch4, as you removed the set/clear bit STRIPE_BITMAP_PENDING, I think you
should also remove the test_bit line in stripe_can_batch, also the definition 
enum in raif5.h and the few lines in comments in __add_stripe_bio, same for the
line in break_stripe_batch_list.


Regards!
Jinpu Wang @ IONOS

