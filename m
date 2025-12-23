Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D8E72F6164
	for <linux-raid@vger.kernel.org>; Tue, 23 Dec 2025 06:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766471647; cv=none; b=UV7ac9yRk032S6Kdud8F0FTllRLIFrPfR+LRIlUtFFMNrA1oiO/5RzKTzoHDvrHCL0YTwvpZotjNRoDVqsnH9JYLul84U6FFR2CfPFZQETuK6Eouwj93KbmIb0vTA1Kr5NJ6bvp5NkNZ51kBiAAqq/sdC+dyUbkJ5XEL0yhyyd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766471647; c=relaxed/simple;
	bh=zQMCxWwv+vy2hbOmutXkA1vn5ZNuVRvD6yhOueNtNZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nflj1T4hzDon7qgr7ulnuLU+G+GgxXMJJuQA2mZQamkjQB/kN5Z2lLEugpbo2HZpxli+Bowhw2YJDvc/O2lWsXILkjQae4w7Xmmy/luSyjQ4B1BSSfbMpz0Fq5Z85kjdWdjDH0bn0Bstr5mNSjjN5dyO7TCwIZDXwpPuYpEV4jI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WwAmUTBH; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WwAmUTBH"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-37a3a4d3d53so39229331fa.3
        for <linux-raid@vger.kernel.org>; Mon, 22 Dec 2025 22:34:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766471644; x=1767076444; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=048jzD37H8lsx/zZlGI/PEx4g5lnBiNM8RokzD3mdsY=;
        b=WwAmUTBH+Z8XRKtBCqY+p4vhvOZdSmb+n+f1cbt8viJVJQHBr5U0jo/4s6d7qWWbBf
         m0+yEyt1/jvRcNLPLCeivO4iEJDrI+k3zJ4jS2PQa2ZNeiL1Tlbub2tME3cf4CpV5t5x
         y2v7G9wdrigZhwrK4c7Yef+E/fzqp/cS5XJetFqG4hBREaOaTvMWzFG+nlcM12NpLnyV
         bWftFqc5KSBKZ0BFk6cyJPxHYk5+KPRoe6KeznkQ0/TJBWIgfaUW2op7B7NEb1bQFuep
         6NgElzoJ6xi+uJ6OfcZAZFe+8coZdOUBZ5vF3OSWtmJtAEFFTI3kGZUoLI04b5pvc8/0
         nauA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766471644; x=1767076444;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=048jzD37H8lsx/zZlGI/PEx4g5lnBiNM8RokzD3mdsY=;
        b=r0HVrEP8BvV5Ae6jrmU6Jny6Yb2pO9rc+MkyvBHTkk7LicTbD05WpcrDQXWg3EZDq5
         PMFxxGVZd5t4dJPQ/xFYhfqB8kI0x4RTN3ARniWi2pLHIZDKcpS420T7UNe25yC11KWW
         OOOMxJuq3SY9Dg0He9kxqtRffg1+0a6rw3cn4mhjCTjd5voe4XG1/0a7HdTjgHSzIMx2
         Jx/nUAqXJwaXz9Dld6J4ruzAJ8r6Ns6rYxIJmgnfCxghDIuRlHj13Ma64fr+r+M42loQ
         GLeHuMIsfKw+6HnDrxj+0NedLxurEgVj8uhj1WZPLGf46DiHkn0JNk36KN4RtaKVzxyj
         31xg==
X-Forwarded-Encrypted: i=1; AJvYcCVLKyZyubiI2ijLiHBqIDnZVNntv5MCoBThQlU9tbMYG0q6OFjf0qm6V2krx8HiNIc76kpnCWw7npbm@vger.kernel.org
X-Gm-Message-State: AOJu0YxkdM395Uwgtr4O3KDgrybWCZ/sh2+h8PgXvG2erIHeWFI3x/U8
	NODo+7Y21T2fd75hWhlE7zAb/kpHrEod99N4ZBk7rHAyYyGRMKaj6p8+
X-Gm-Gg: AY/fxX6XPhfWCPPG7jrxvFMDedT/CUNpaP0SQbhEwVezD2TxdmlTPYCg1YjkXBspfR/
	/4lGzF6ihVU0x2+AkRq0JCfy66w65An51mmECLRc5dRDIgwNSKc3l6Ch2sqYlhMEl3cSBLn6EFq
	pFkdkakFee6hQGok/CEr1NKM3yFT3hbSppvRhj154fYDkbGRyX2itCrGgrUZEJL++5hbvLgGpcX
	2bj/JGIm4VyJnLIFOfwn5x6Qaw/Hl/079hH5xOzDnj4QORbfgmXy9uLbs8fFS+WhGEGFyeJxbOl
	PpMRkuSuZ7qq2WkxDTad99HTjsTBrXsgnIGKHRsxE1uYfC+Tu2vnuSBHPTUDjym89ZcSO0kPAYD
	+NfGXfZo9k3tlZZQ82KqjMhJPnKUfykxUlCfJrW0gvgncZ3IHOQv7OVufjJfj631j3N5khDq2nM
	BeuP4jvm8scCTZ8yLLFes=
X-Google-Smtp-Source: AGHT+IFaFE0nlDnowk+Ou3U+M9eX56ZCvZ4aEX/mIAF0sQ5oS0z9Fh1vnyWDY8DQIpJC2t19J66zfQ==
X-Received: by 2002:a05:651c:1506:b0:378:e055:3150 with SMTP id 38308e7fff4ca-38121566b66mr43783861fa.5.1766471643890;
        Mon, 22 Dec 2025 22:34:03 -0800 (PST)
Received: from localhost ([194.190.17.114])
        by smtp.gmail.com with UTF8SMTPSA id 38308e7fff4ca-381224de6eesm33742031fa.6.2025.12.22.22.34.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Dec 2025 22:34:03 -0800 (PST)
From: Askar Safin <safinaskar@gmail.com>
To: gmazyland@gmail.com
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
	mpatocka@redhat.com,
	pavel@ucw.cz,
	rafael@kernel.org,
	safinaskar@gmail.com
Subject: Re: [RFC PATCH 2/2] swsusp: make it possible to hibernate to device mapper devices
Date: Tue, 23 Dec 2025 09:33:55 +0300
Message-ID: <20251223063355.2740782-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <86300955-72e4-42d5-892d-f49bdf14441e@gmail.com>
References: <86300955-72e4-42d5-892d-f49bdf14441e@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Milan Broz <gmazyland@gmail.com>:
> Anyway, my understanding is that all device-mapper targets use mempools,
> which should ensure that they can process even under memory pressure.

Okay, I just read some more code and docs.

dm-integrity fortunately uses bufio for checksums only.

And bufio allocates memory without __GFP_IO (thus allocation should not
lead to recursion). And bufio claims that "dm-bufio is resistant to allocation failures":
https://elixir.bootlin.com/linux/v6.19-rc2/source/drivers/md/dm-bufio.c#L1603 .

This still seems to be fragile.

So I will change mode to 'D' and hope for the best. :)

-- 
Askar Safin
