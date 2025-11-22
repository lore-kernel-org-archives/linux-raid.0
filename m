Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D582121D599
	for <linux-raid@vger.kernel.org>; Sat, 22 Nov 2025 22:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763851679; cv=none; b=Xk/DdDM/tQywSwJeVtY9xRrIS30xPHCHB/uSpeMmKCe6ZBuliA4O6h7VyJCyeX4CjPR0T5nTJWRA8lO8P3eaYsKilJGk+UTxQ35iEhooOLA826B6ZYxuyFkaAKocM0PbXxSo9SHU9Gp8In+4Ljxt4FH7npaaRtXhlq1gR2G1LMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763851679; c=relaxed/simple;
	bh=mDmOqDRRV1GxRTkt03uYnfvm5YBI/u/mWZasnkUTwrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fF6ZlybPMxg4bBMCRQ/E/0j/Kw20ltPcyLU1w72CXJlsJ4Hw8Wv7YpFtmsPrvCem9XxgmnjchEqErF3ZbBw302wUe7dwL3CywpGZDFB+g35nowTN5DUuPvQr8LY/qbxG6uiIw1JmOpwFoCRk9huTNoxFbB/0nXCF4zlIHTCO4Vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m4EYqLjM; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m4EYqLjM"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5957d7e0bf3so3899800e87.0
        for <linux-raid@vger.kernel.org>; Sat, 22 Nov 2025 14:47:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763851674; x=1764456474; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mm9cJVhutkedd51ycbYwKmMqp19QwPFiX/ffFg8rVcg=;
        b=m4EYqLjMnZAClasW5oW/RKRiG7pn1i/2sd87a2+bGT5arzuzX2s9OWunw3ssNpcdIL
         Rt3hNDSuFUBrtfbXvhjdipl2gBlBuevvx/2V/Sci3GW099P+W5/rd7vFyuWpyVXP1yQP
         MK62n9rzpZxAKODtmj7axGjtZm2iPhssZ7V5ietC61jcOyFvK9Nmes+GYZJ0bfVVY9W3
         HhsNbNtfDCgWUxgyoFMe3TEbEmFHKPlLJzBCay6GBLVkLziLLWupjzRTYCBTQvVTCNtC
         PCE0gN7ui5o9znFYb9NWADBrbgacrALeEnX1YBs7J3e4rCG9ErcZLONAjVpKnh7gKzq8
         xDnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763851674; x=1764456474;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mm9cJVhutkedd51ycbYwKmMqp19QwPFiX/ffFg8rVcg=;
        b=wCTBR26ao7WNDJuC7k3pgv+PqFsJmJEEQyd6kpMysxF5VyxritgHUUEVyG6qYKs1yK
         0IzdwzBRok8agOciTyL6uJI8GwCQyGKzJEx5Qh8E8CdHJcp3WLfL4Ot9X6xUwB+JWIzq
         pkn30QskE/uwCFY4taX+yquGlE0893qh71Aoasjh0sP+BXdzjZYH7dz52j1b8jX1dRDc
         krCA+We9pwlMAtZbOzijZa36uZlxJL4sW42R5+RYBDLqmN5Z6GUoHhsa/FvGhXWa2oxM
         MQusIdx9AkDaeW//2xG9/HfXOj5eHCz2PYQrr03GL/4za1tDXU6vFrLiEBeI0RwW+HGc
         smKQ==
X-Forwarded-Encrypted: i=1; AJvYcCVutgNbQhOVL1jfQZgDyrww6Tv1z1TRfttrdbl0f6i05acdZaQKG665TdfMk8zZe6xmcduCNiUl5FTo@vger.kernel.org
X-Gm-Message-State: AOJu0YwcPLs0HaJOqgJzgv+eMs1B7Z8kqdsViiSGUs33cY+aeawkEXgK
	qYSHUo7s+f4ElSbUztJLCGsFaxc+nc32mu7Enml5I0xl16lUy3khzan3
X-Gm-Gg: ASbGnctrTJdJ9bnz1U7R2JlGkGkV72mz+w/5d0wJxXfqBVgaRDgXaruDRk8jJPGB61X
	1kOlD3jEdgfSGMzgsrUvOPYmSZKBmMQowQ15pQ/JVl6AAgBwxt6TXatFNvBJKJAL9qTZnzhXWTL
	eat7jmDxg+8IZtoDvYx8P/DoNgGumD0nhyKcOlIaHK2F5Wd5NZo4QXCvecN6PKeZ/ma84nBw7s+
	+nKGBW5GRNo3IC1ydsPbbSx82CTLF2F4UyRG1jXUt7eAvrdGVHbcJtLS0N6iJHSW2RmK0NupmGU
	QkO3dHWeqR8/say7XTvBqfF6AsD9yLTaknjaONYIIE3VTOR8wACgygfcczHpvQk6N6Gj7VF6qdL
	tvNjy8Wg+v3mwABP4iiSHOtLp1AsrlYpJM6+gGwsXiztg1ZSxDUZq4T+kkPpvFUBYMfFjIQBAYb
	rEgw/wa9ruXg==
X-Google-Smtp-Source: AGHT+IG25dEQnHwaBToxpvBjTeZ/3RB3yCymIb0k9rzfOt31nS8ruDCrSu8IePguUMWt0EMXA9m5xw==
X-Received: by 2002:a05:6512:308c:b0:596:a000:596 with SMTP id 2adb3069b0e04-596a0000a2bmr3428587e87.10.1763851673743;
        Sat, 22 Nov 2025 14:47:53 -0800 (PST)
Received: from localhost ([109.167.240.218])
        by smtp.gmail.com with UTF8SMTPSA id 2adb3069b0e04-5969dbc5988sm2742367e87.78.2025.11.22.14.47.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Nov 2025 14:47:52 -0800 (PST)
From: Askar Safin <safinaskar@gmail.com>
To: mpatocka@redhat.com
Cc: Dell.Client.Kernel@dell.com,
	agk@redhat.com,
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
	milan@mazyland.cz,
	msnitzer@redhat.com,
	mzxreary@0pointer.de,
	nphamcs@gmail.com,
	pavel@ucw.cz,
	rafael@kernel.org,
	ryncsn@gmail.com,
	safinaskar@gmail.com,
	torvalds@linux-foundation.org
Subject: Re: [PATCH 1/2] pm-hibernate: flush disk cache when suspending
Date: Sun, 23 Nov 2025 01:47:48 +0300
Message-ID: <20251122224748.3724202-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <c44942f2-cf4d-04c2-908f-d16e2e60aae2@redhat.com>
References: <c44942f2-cf4d-04c2-908f-d16e2e60aae2@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Mikulas Patocka <mpatocka@redhat.com>:
> [PATCH 1/2] pm-hibernate: flush disk cache when suspending
> 
> There was reported failure that suspend doesn't work with dm-integrity.
> The reason for the failure is that the suspend code doesn't issue the
> FLUSH bio - the data still sits in the dm-integrity cache and they are
> lost when poweroff happens.

I tested this patchset (in Qemu). It works.

Here is script I used for testing:

https://zerobin.net/?66669be7d2404586#xWufhCq7zCoOk3LJcJCj7W4k3vYT3U4vhGutTN3p8m0=

Here are logs:

https://zerobin.net/?5d4a2abbad751890#WMcQl4FAZC9KqcAuJU3TSVr7wuVnPFwI7dlinA9QHOo=

Tested-By: Askar Safin <safinaskar@gmail.com>

There was no any reason to wait for me. You could easily test using script above.

Also: Linux shows this scary message when booting in Qemu:

[    0.512581] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA

So, FUA is not supported? Does it mean that this patch is wrong, and works purely
by chance?

-- 
Askar Safin
