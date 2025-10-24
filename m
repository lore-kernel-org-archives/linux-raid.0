Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 162BE267714
	for <linux-raid@vger.kernel.org>; Fri, 24 Oct 2025 16:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761323515; cv=none; b=oPBAFFxm7CufFjfRBT+p4kbVyICQtqETE1MX1BCu4EIZ4YA844uyTCHJmj+YL5ds2asKOU1aRhi5lmiDQM1XLQQx9g+J3KJsaUUsoEC0m5RMjUprnWUfcNXU/eadlbSPyMq88UlFthONVpMzf4DRs9lvHclenVlNb5wcHBGRTOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761323515; c=relaxed/simple;
	bh=2sni659oKETAt3mg4JWKS26aiVXJeHNTGhbFaOETvpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ijfWcs7adK8mbjQ3AFG//P4QLGF86TJCqff5hOItNJnlDUFW5V7XBcH6uNabBAHv8LMjw28mvvaAfnVe871WgOULDevzVjl1u2NQHEu+U1+ayuuv0gUyp41Zy4pUKDaEAEFc8V51XSDMxn/1GpJ2BkcKKT/vX3F3Ib3+FLwuLGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=baeGrPtx; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="baeGrPtx"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-63c45c11be7so4053585a12.3
        for <linux-raid@vger.kernel.org>; Fri, 24 Oct 2025 09:31:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761323510; x=1761928310; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OU6+xLScjAoCvkgYL37muGkf8RRryUsuClOGQPNvZ0U=;
        b=baeGrPtxRl9Zf/t4igHdLAfWz7seyMy2nyivr30g2fvYihwprt8qlhOJ9DJtSB1hBN
         TYLvarvSWtjgZgxIFPLdBYl4+zOt6KrUsmyze798Y9YVrE4BJz0upn4uZAdQ0Qm/C69Y
         73LY1yYKOXRCr1VXZQAMZHTQGiaqwXIQl+XOrqPkJ6DJ3WbI8Lxosftc+V1hDcagxFE+
         Mv+ER1/NPEMnCHB5T/HRmKAwwHUaJG509q9O5YZGfQ2xoBy9R407zdmitycuDi0eGZZ4
         4CdnBpGwx2duUok2tRLKfKZLcZlsr35nVFeaUcTiP2b6iztLXtbn99MOpppdextVXb3r
         L0RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761323510; x=1761928310;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OU6+xLScjAoCvkgYL37muGkf8RRryUsuClOGQPNvZ0U=;
        b=QeFC3dnduO63bY6Fg75ffYBkKTEz/0bA4V1RFneHZK/lPReKENr6BgejJTLhYJac0K
         b/iy21xdyX7G7+YMeVBeAsmIssa/6MhSVbbno1zpMSQIQJevPAKxF5U9Qq7Vos9uXpL8
         rj1JMKmdzfCDcwGEwCBX+BhxpS48qOuFsyx+0bhWGJlet7cHTwkwpeiUUElXzd+ygE6O
         rcRgzveUt+4FLxmUavP0xnCunBGrtes9k4XzpuMynaYcuJfSwKi+cBpCBbsE0Cjp1YVb
         P00eFbjk+LdKFWuQolTK4ekKOC2vTbXHXS3OX7TnR1UPF2MRLIDwE0z/4PpNXt1tB391
         2kRg==
X-Forwarded-Encrypted: i=1; AJvYcCXCNJfOXDxpm++rEQ55HMTYLGNKwP+KA1Pfx6cHEvhNCvWW/xnnU/TrYgggSMsKHew7KGJbfY3xA3NT@vger.kernel.org
X-Gm-Message-State: AOJu0YyNcmNSyqHsdaBKU7kQp8dzb8pVTK2VJ0Sx1fyRUZ/sQCscQnLH
	7jaF+4r+h2zq41gYHBJCfRzSblr39OPt7+NO9N6W0puzaCz7Bo9Srj9Z
X-Gm-Gg: ASbGncubPOw5f8QubwBfGdtnmEEEA7bgQif8z7E/ETXU2050ikFKiO9+1JDF5/LmDWg
	OaGeQ2Aj+hGUJL7Mock87u9FFGUOom+OIBefOXVMxvx4ssqVFAQqewIHEOZG7/zO3tS5Dzuncst
	flAmRHttwXPvfJom295oqVh808OLfzHWc1z/fVVMYcHQPXc2EiCnwvFQ9hx4ZFuBMn1YlX9icEd
	rNymRMR4sv9sEz2bbbgYwQFpueSR15zSA4OM5bh8UkkvaZo0kybuS6N+jkLypOTGlcsXNPdqXi6
	fUMcUZoFvPzxn05iu/IWG8Yf7JLjax16OcE9ztYqdOlxmJEGHj3R67n5MB38dRR6Upz1qcp2CAN
	qqVoPmgsCg0qP4sGrwRX7YLjbiWYnYISB4UPF5fiXKpmfgXfEOOt4r2MMK3VMcUFV8aOBSE22E+
	Cu
X-Google-Smtp-Source: AGHT+IGJrzUB5n97Ss2T/JTlLzP7kGDtRqESJivToHOWW6+qmykXupmsLuZ+wNfM3MQ1VRw6GaGwKg==
X-Received: by 2002:a05:6402:42ca:b0:63b:fbd9:3d9c with SMTP id 4fb4d7f45d1cf-63e6002459emr2596805a12.15.1761323509904;
        Fri, 24 Oct 2025 09:31:49 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-63e3f316b64sm4717822a12.22.2025.10.24.09.31.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Oct 2025 09:31:49 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: gmazyland@gmail.com
Cc: Dell.Client.Kernel@dell.com,
	brauner@kernel.org,
	dm-devel@lists.linux.dev,
	ebiggers@kernel.org,
	kix@kix.es,
	linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-lvm@lists.linux.dev,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	linux-raid@vger.kernel.org,
	lvm-devel@lists.linux.dev,
	mzxreary@0pointer.de,
	nphamcs@gmail.com,
	pavel@ucw.cz,
	rafael@kernel.org,
	ryncsn@gmail.com,
	safinaskar@gmail.com,
	torvalds@linux-foundation.org
Subject: Re: dm bug: hibernate to swap located on dm-integrity doesn't work (how to get data redundancy for swap?)
Date: Fri, 24 Oct 2025 19:31:42 +0300
Message-ID: <20251024163142.376903-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <a48a37e3-2c22-44fb-97a4-0e57dc20421a@gmail.com>
References: <a48a37e3-2c22-44fb-97a4-0e57dc20421a@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Milan Broz <gmazyland@gmail.com>:
> Hi,

I just wrote script for reproduction of this bug in Qemu:
https://zerobin.net/?4e742925aedbecc6#BX3Tulvp7E3gKhopFKrx/2ZdOelMyYk1qOyitcOr1h8=

Just run it, and you will reproduce this bug, too.

Also, I just reproduced it on current master (43e9ad0c55a3).

Here is output of this script on master:
https://zerobin.net/?68ef6601ab203a11#7zBZ44AaVKmvRq161MJaOXIXY/5Hiv+hRUxWoqyZ7uE=

As you can see, hibernate succeeds, but resume fails so:

+ blkid --match-tag TYPE --output value /dev/mapper/early-swap
+ TYPE=swap
+ echo 'Type: swap'
Type: swap
+ echo /dev/mapper/early-swap
[    0.446545] PM: Image not found (code -22)

Also, I just noticed that the bug sometimes reproduces, and sometimes not.
Still it reproduces more than 50% of time.

Also, you will find backtrace in logs above. Disregard it. I think this
is just some master bug, which is unrelated to our dm-integrity bug.

I will answer to rest of your letter later.

Also, I saw patch, I will test it later.

-- 
Askar Safin
