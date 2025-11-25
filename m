Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01B3C2F12DF
	for <linux-raid@vger.kernel.org>; Tue, 25 Nov 2025 23:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764114089; cv=none; b=RUszKQ7Jzq7EwDsYmUQ/C6yQCI1JxYln7ZCF2ilHiSnFCVFJ/AXknhNyvqmrSpKVoqD9+FkMpGlDSo7CETx/7/I9aBJX2TN+tA2IV5Pnl/ZRjt4ehDvF1QoEfOaOyQH6i75OuIyKHVvtU0NBvz7Og2TZRwnZuxaAg7lDDpqcGK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764114089; c=relaxed/simple;
	bh=gWMb0VoUFPvI9dqT/ScM08+SFgSz52WvWw6dKZyzkX4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GOJGVhuNCVpdPlEj3oFenTCKB1kGXHlQDsmv966OZsMU/qEDbHn9rarwcdPftb5qu7zrjmy/V1IJj45teSe+vyi289fygay6kS+khGRMsuM4UDuSioZNC9c0PR3gWDlPuSeTKb44c9j3/HfGgBVLB5lhl1/A+yvJKPEOXaloEaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Bh2eSTbF; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bh2eSTbF"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-34361025290so4844754a91.1
        for <linux-raid@vger.kernel.org>; Tue, 25 Nov 2025 15:41:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764114087; x=1764718887; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gWMb0VoUFPvI9dqT/ScM08+SFgSz52WvWw6dKZyzkX4=;
        b=Bh2eSTbF+S2eJFmwCc1VKmsOxCMxgZ0bmxzfMfQ9jvpx/Uuu/exl9YrXv/CpYqrHPA
         MDznPP3EecuhDZxjOAIPcy9aUfePrAG1EUyAmCUiy64KsvYcFDoSKCseaORNt71vJ+Hq
         Xh+BYWayuqLVLedpm3/lQuvzYyqOoQymqd2HoBkBGfuHBmF+xj/ZaaSIhjHp2CcGjNOF
         ACSYynNugZr/MtNQd1ZesmPTUP+SkLkRvXqz0jInKZjs/4Vhj5MRmpQTnvHtd9MVwF7e
         GZZTTMD/yIUzeyFr6CeFH/mqtlwjLxDx7REF+C36qjFfi+Q24Ssk0cM8OSJGS0+ugu1H
         tFFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764114087; x=1764718887;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gWMb0VoUFPvI9dqT/ScM08+SFgSz52WvWw6dKZyzkX4=;
        b=GxJ8iE93WFwHCnYATj3W+R6l++p18rxmvlnU7/6FwYvhMgf4I2reb6zcAYF4A6atMV
         2484hfctck+TWRgQ0stB8A29UqaUG4PdYFMi63Q8OnQTr7GmTkO5R0txV0cJhJPxoRBP
         6l6zmSo61X2DAIGPnDRnSECr2P93ZjtPksx2k5tpuY5PqAI2JjgzpZHtCmlz1q6BhD7d
         5bCMySUQB6TisaszhUOheieMeNKJT7r8PgLXA3euOIRlN1ffT1lPGJ9aoLzMxS3O3pkF
         1rzOiwFzri6ozEvh7J4c2BwVvcAs1v5daEcHD8G5evPAp0ciubIzM9z5+Y4cfLKQO+ir
         DZOA==
X-Forwarded-Encrypted: i=1; AJvYcCUQlMAxv2rh7qy/cBF3Hs8nP7Ea0FfIKZaG08QK6iOdlassPa5Ev4S8v+GevII75TQN+6XnogVQEBlS@vger.kernel.org
X-Gm-Message-State: AOJu0YzmaBb9iWp45ZVTtQikbLtBo3RbuwMpo0i+AEKSz0Zxy3k/Wz1R
	Wnws8ftwVSHvGwL/kBdy9ETT0WPzTcIDAtSIxi6pnzYvHizijnsXSh/A
X-Gm-Gg: ASbGncv1xTm0ASQYJq1EGhZHsp8+VkM50KkKNWaYZQSsRO4zHCxQrRuQg+orFQahQsI
	3mncuLeBeN+eu2cTEyn05f/A7EynXnaDtid6qZ8HEboJW0zN+Klhv9J3yDcIX++FNHaIpyp4H7o
	4fwDLXsy+mYV8faRWW4A4r+peFktrHqgHv+J7C0+WcE6npsDgjhK3tNQXruMnOKRd9TifVN645H
	FGWuPIKQFn+xT4ISnvDpHA0uRlFPRkAVfsqNe52LKz8VPE6DeSvqtZNAoub4185Xh6XOkztMYjw
	gvYWPrP0Rx6ZTAYBWeKd4toVYT8PTQjpyDmZ+PxRoAyU0cYHIByr1SRSFF0Ch2HHsuqixA+pSb4
	I65cHNPmlmZvzY/Lawas8EXEXKmBuUBVg3XPShWhTE/ZcySTBqKGlSCqwyUNFbDBJNLQxLP5Lbu
	EXMXL7sRAGbbxW4IbXtX39LKn0En3CBYNqTjULfw==
X-Google-Smtp-Source: AGHT+IERAr6ZaAk8N2XfP1sLPZ8ltdcZpy2by33AewknK2HCsGdLuO/dThk3nDRSpzRLveBkNTfbCg==
X-Received: by 2002:a17:90b:3b41:b0:33f:f22c:8602 with SMTP id 98e67ed59e1d1-3475ed6ac44mr4636649a91.26.1764114087385;
        Tue, 25 Nov 2025 15:41:27 -0800 (PST)
Received: from [192.168.0.233] ([159.196.5.243])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7c3f0e6c9bcsm19291748b3a.57.2025.11.25.15.41.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 15:41:26 -0800 (PST)
Message-ID: <2f356d3564524c8c8b314ca759ec9cb07659d42a.camel@gmail.com>
Subject: Re: [PATCH V2 2/5] dm: ignore discard return value
From: Wilfred Mallawa <wilfred.opensource@gmail.com>
To: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>, axboe@kernel.dk, 
	agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org, 
	yukuai@fnnas.com, hch@lst.de, sagi@grimberg.me, kch@nvidia.com,
 jaegeuk@kernel.org, 	chao@kernel.org, cem@kernel.org
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, 
	linux-nvme@lists.infradead.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-xfs@vger.kernel.org, bpf@vger.kernel.org
Date: Wed, 26 Nov 2025 09:41:19 +1000
In-Reply-To: <20251124025737.203571-3-ckulkarnilinux@gmail.com>
References: <20251124025737.203571-1-ckulkarnilinux@gmail.com>
	 <20251124025737.203571-3-ckulkarnilinux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.1 (3.58.1-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Sun, 2025-11-23 at 18:57 -0800, Chaitanya Kulkarni wrote:
> __blkdev_issue_discard() always returns 0, making all error checking
> at call sites dead code.
>=20
> For dm-thin change issue_discard() return type to void, in
> passdown_double_checking_shared_status() remove the r assignment from
> return value of the issue_discard(), for end_discard() hardcod value

Hey Chaitanya,

Typo here s/hardcod/hardcode. Otherwise, with the split as other have
suggested:


Reviewed-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>

Regards,
Wilfred
