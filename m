Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C5E03ACEE1
	for <linux-raid@vger.kernel.org>; Sun, 26 Jul 2026 12:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785068751; cv=none; b=ZeoymQICBzUbx52DDvD8fn6wUq9rBcPhf4fFvmXACbtbZk9oklGR5RPIgkD88lYtEEHXPx08FMDDyCJpcNdPoXw4ahUx9smXO6JJaNB7tYDhc/nQx+Byi3Vtp6cpwENb5Xrt9JGx/HSk+vTQ3fEBco8cO//DQvAhuFjbioBV7uI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785068751; c=relaxed/simple;
	bh=JaKpvmu/bz/vC8QBqDOSptyd2EhANT5RZrXa8eSchqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iorPOYR/nxZge0a9FIIqYm9RWM28/hwoijWsmZA8AVujboVeHY4vP0k5OaZe3zrys/HawJEkSecXWGwR9YtgXrtdiMGkA3KNEpc532GTTDu9xm4HP2vNXotS+pJVkvDsSjSy+e0bpwxjAOztme3T8ouuDiSUnlRYOnIY1R5X+AM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=c1dOz/QQ; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="c1dOz/QQ"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4955de8797cso10969515e9.3
        for <linux-raid@vger.kernel.org>; Sun, 26 Jul 2026 05:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1785068746; x=1785673546; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7zlaUYhyfyu8eZmeK1wxZbQdj2lnxJyQyFF/To5B+NQ=;
        b=c1dOz/QQjAkaizZut38trd0b4pE1SFfRNOXjhBxgqNJSgsdyKKjmCL++KshzK/Q9w8
         OoF200zYN3Q9cLt6pAF11F6QQ3m6N7/mLxajERd3aKM9wTjDclVL98rM5qvxrpLGOMQq
         FAkTpOGfCFavn4ApARwZluSdC7I37PHbcp9SUG9T06RVr3Z9v6oMkLghHdIayuIT+3Zv
         CKksOYciBmnVOpinwu8yEwrIAuziFLyQkscr4O0OdxpBOoWwe9guWJGD7XR05Ld8k5gy
         HUXMTi9BzJJBO1Mh/4J76dySmPNw8d1eGzI2dOWjjl61kBzWJL0VF60JSFmAZydduUyC
         DY+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785068746; x=1785673546;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7zlaUYhyfyu8eZmeK1wxZbQdj2lnxJyQyFF/To5B+NQ=;
        b=caT8w+8yLZiv+tQb2RgW6arx9f8y6bDfIhOEFczUl2wYIgtMHw0Dz+bB/kvwPljBo/
         XKkVI94eTKr0dHQ7WZ1SnqH/VIGwFHeqISDsOMeJH5Y3xwNR/myMu0HFnEpNi41ad29u
         iQtdNRJ2k3PNC0yrtbIUEZT/IiUqGCV78BN7QX/ZFPsOf0xvMBvT3kQ3pMoWr43l02Y+
         UEiDoLECIRN75D6X8EydS1xZA7zOynT8KP6KJn7TuxcZpJ7JSORNKhrzgrVtvW15Eola
         CZSCytP5k21b8RqeejBhL60I40f5hM5xMhw5j8uIAhXsOcuyb2R37tq7lCiwq36WDfza
         rvwg==
X-Forwarded-Encrypted: i=1; AHgh+RqJbMwjdscutSDvaAX9yuuYe5p4MLGTWF0qVPBJLZuD66LWfkceyLHYY0SBj0qy9MD1XM9DADTgO3MS@vger.kernel.org
X-Gm-Message-State: AOJu0YxlMJUOyM39oh/QDzv10tkzjaOhYPvqSOgUs/5xyyrUB2ezkqzr
	WJhzrkC0qE1nRptPXf7qpFhYyrhY+IG0N/sM17xcocP7XUMvo/jdPAyh3L1TeWcxqg==
X-Gm-Gg: AR+sD11WLkcvK6Xu1vPFPnxD2Tk/kWjvjbkK9UMlnsTvzh7TTXyd4JfZqufFy6W4nXW
	ZyDk0pTVNRfQm6r0gz58JLaVt7CxTsVawSOc6oDaOCygWns4lULjS0gTX7qyEG6XZ+xloAKOz2L
	skgv/N62mW9i4wgSoEpWr8HBQw1tuvy72hMDcmTbUSxuF8lCCFuQAFxcACXdxqb/n7xNPfzYYS7
	HQ+pJHcDyjRbtgRk9UWEBDrpItHwJoq1i+sfdy9Dytf/4fiGjCq5sQc41eToVb0ulzFl68Le5X+
	kf1qAt8oJaIhlfZcpBXciXhr1WKqx62b45wLZtciXLFS1bNRwOT3XmusYtKvuX20YWoOU8AN2ns
	0Y1ZvW5whh5h5t+qipTo4NtA6xxHPmavcA6iZCgT7LORRRH5TpEkrkWeJOQYb5jPmtwGaBntT57
	Ih4P4bSF7uQy4XWC7W7IDIefSCz3ej7a3k6oBqSv8T6Lu5menoCi337Fc+03MMOcqsL0sxkgUHf
	ZmoHY9X3LswbFELrwwSZRxWB8+G82iHMbHoLkFYeZil6YIpV91T
X-Received: by 2002:a05:600c:5492:b0:495:7eab:3abd with SMTP id 5b1f17b1804b1-496b5736f4fmr69919305e9.33.1785068745663;
        Sun, 26 Jul 2026 05:25:45 -0700 (PDT)
Received: from meshstor-pc ([185.87.42.56])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4957f9ae5c3sm221458535e9.3.2026.07.26.05.25.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 05:25:44 -0700 (PDT)
From: Mykola Marzhan <mykola@meshstor.io>
To: yukuai@fygo.io
Cc: Song Liu <song@kernel.org>,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] md: only consult skip_sync_blocks when 'j' is in the bitmap's domain
Date: Sun, 26 Jul 2026 14:25:32 +0200
Message-ID: <20260726122538.2176316-1-mykola@meshstor.io>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <7aa16dbf-9931-4c7d-9368-a828a1767034@fygo.io>
References: <20260719144227.940444-1-mykola@meshstor.io> <20260719144227.940444-3-mykola@meshstor.io> <7aa16dbf-9931-4c7d-9368-a828a1767034@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> There is already a patchset to support llbitmap reshape for raid10 and raid5:
>
> [PATCH v2 00/20] md/md-llbitmap: support reshape for RAID10 and RAID5 -
> Yu Kuai <https://lore.kernel.org/linux-raid/cover.1782282042.git.yukuai@kernel.org/>
>
> Before this set, reshape for raid10 or raid5 is not safe. Kernel panic or
> data lost is observed. Please check if your problems still exist with this set.

I applied your v2 (all 20, clean on 0e35b9b6ec0f) and re-ran the test.
The problem still happens.

raid10 near-2, four members, lockless bitmap, no --assume-clean.
Write a region while healthy, fail and remove one member, rewrite the
same region while degraded, add a spare, then check whether the rebuilt
spare physically holds the degraded-era pattern:

  base                        spare does NOT have it
  base + this patch           spare has it
  base + your 20              spare does NOT have it
  base + your 20 + this patch spare has it

The mirror partner holds the pattern in all four runs, so the region
really did land on that mirror pair.

Only two of the 20 touch llbitmap_skip_sync_blocks():

  11/20 returns 0 for MD_RECOVERY_RESHAPE.  That is the reshape case,
        which this patch also excludes.

  10/20 adds "p >= llbitmap->chunks".  That bound does not fire here:
        raid10 recovery walks per-device offsets, which are always below
        the array-space bound, so p stays in range and simply addresses
        the wrong chunk.

Nothing in the series changes the md_do_sync() call site, so recovery
still consults the hook with an offset raid10's bitmap cannot interpret.

The two are independent.  Your series applies first and this one on top;
the only conflict is context in md.h and the raid5 personality tables.

Mykola
