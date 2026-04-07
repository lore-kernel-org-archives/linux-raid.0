Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A997D3976B8
	for <linux-raid@vger.kernel.org>; Tue,  7 Apr 2026 10:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775557600; cv=none; b=L/9sIOZ9Tqy8VZ/yYWaH5tvExoXdIUf4kTBE1Qb2Biy+R98qgH5PS8wqS8sPwwjlL6ULQicJU3wT57vAV8AUNHfUj3zhiLv3BjGAx50plBafCIuKEVNph778QvOa/qwAkHErs81vnPDfyLOEj6oqoRpgGtoNpc/ONlJV9cyjWqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775557600; c=relaxed/simple;
	bh=nsAozxx8vezvkSdJ564cvXpU0sjYXKP7px3jIwPjx1A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jwdeOYNM83amgVODscmYnHyXHdf0RosX7aTqhN0IxFk8kovMrIw13Hi491O01jh79DIBC3NHSjcnV7F0PH6HyWERUUMxLY5Xyn2gwfpdKW2Mr2rnTC0uQweQ6wS8Wc6P/oqDk/vIZrUM+z+a4YV7TeHlr0EEnJ9erUuVshEQPsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=d5F+1oaR; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="d5F+1oaR"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-488b00ed86fso19513965e9.3
        for <linux-raid@vger.kernel.org>; Tue, 07 Apr 2026 03:26:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775557597; x=1776162397; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6B4uMsNxgvX4Biy++AO8PxqfRtR8ZezAolANEfAnIVQ=;
        b=d5F+1oaR1dmru/V86ak6ZghE7gXJ8d0kmz9I85xCy4bSBg/Fni1hhmTouymZI7j04i
         LJzeRysYkB6Vp7qoPCi5UMd0XOS8w8IDDx1thrFenS3qUkH3ONF8iaXSGQm6TfYqIrDa
         msVq6SCjKdg8Ih1B65IMDtpox5a8j3Cj5i2PHwF0Ls1McZSAHqpzdDLnDFiVT7LyK6RW
         sd5oYxC3yQ9Y02QABTrMjvrnNQO9xDW117gwojXKY3UaoNlNOpoMHPdyRjrBsnBVUXRi
         NvbAlvJqA0MaitfN1ACIvmtCsG/iLCFkhWXWX6XfokHP3iA6KqBQ6AZKsqpHLh8aDxSD
         v+ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775557597; x=1776162397;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6B4uMsNxgvX4Biy++AO8PxqfRtR8ZezAolANEfAnIVQ=;
        b=O0ElWXWQa23h0y+szixKcDu0S2YVZj00whEfmwzHFBwSNGfgRGl0v37gK6QASCH5tp
         SeU13JlEfxTJzOitKf9XwEl9AYOemC2ad8K5slKGjnEfB1UZIHqhO85JLe07aYckpeDl
         LcPmcDXqCAp/iVJV9TTCSi6zRPM+98p30wc+q0VVTCiPE9vDiNS2OR+n6u2AwTO818sO
         vncDRufnMY3mNqjEzuoxgpGMsIGuAifsOmKwgHlYdTQ50WW0kyVAG/iYSgstgYg3JgAS
         2iO3Bt8QrzImvnDKhjfjY5jWOnuMoIEQe00LMpH+XLIPO9uBOc3RQoDOKBpfDfQida92
         BdYg==
X-Gm-Message-State: AOJu0YyHmzX194+85Hoq/XvC4xLAT56MlQE3T/2ZtFfLtDZc6XXOFh8/
	iJgfyy+TAPgHBCPam8qbZzwwWDfZJVEdcXggXots9ble7Of3GEKkoQQOeHP23woH9U6YPJRtnsD
	iXKClO5tx7w==
X-Gm-Gg: AeBDieufPs3C0Fz3FxhkMSqQcB6zjgvBsal9rZ+Gef8eAFUjBNaNRESV3DYVl9yg9Af
	PRqooBzxVy2s7P7bWqzIapUZzLyEJUXRfDYiyPtzEdTTkWNIyB2YJffS2YVn5dOe7klVM4/EoDd
	5Y/nshafABqvFlvoXrGScSbM+/1QE00bb38/c+9qk4Bq9nejg9Wd1xChd1PDbBQ0Phxs9HtHw96
	4cXPIf7LTE/Vp/GLGAu5K3EtWas1+GmfOMuSLwhKRAfnvQi6CL/Bp53+ZfVjXDppECtcUCOwuZi
	oHzgbuWasBSsVTU/mBzXbpq98jD1vMJzitdS0mvSSpJeQSK5R2o0is1GJcP8ouCrn67lpe0Be7t
	Z8tJSRfQW37NzFyyBXIBKtaG5aYIzP9Glk3abDMQ2o0zM8N/pWMyp+NMytwhom62AjcOMCMhNcP
	8unLWNGA72nFwo3V4fs3cBOSm5lGW0ag==
X-Received: by 2002:a05:600c:820e:b0:485:40c6:f507 with SMTP id 5b1f17b1804b1-488997ee0bdmr234992955e9.30.1775557596732;
        Tue, 07 Apr 2026 03:26:36 -0700 (PDT)
Received: from mbp.lan ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ca760b0518sm16483880eec.0.2026.04.07.03.26.32
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 07 Apr 2026 03:26:35 -0700 (PDT)
From: Su Yue <glass.su@suse.com>
To: linux-raid@vger.kernel.org
Cc: song@kernel.org,
	xni@redhat.com,
	linan122@huawei.com,
	yukuai@fnnas.com,
	heming.zhao@suse.com,
	l@damenly.org,
	Su Yue <glass.su@suse.com>
Subject: [PATCH v2 0/5] md: bitmap grow fixes 
Date: Tue,  7 Apr 2026 18:26:20 +0800
Message-ID: <20260407102625.5686-1-glass.su@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi, This v2 series is to fixes bugs exposed by mdadm/clustermd-autotest.
The bugs are not cluster md only but also bitmap related.

The series based on v7.0-rc7 passes tests with mdadm v4.6 without regression.  

v2:
    Add a dummy bitmap operations per Kuai's suggestion.

To Yu Kuai:
A NULL group can't used for internal_bitmap_group since
the entries from internal_bitmap_attrs should be under bitmap.
So instead of sysfs_create_groups(), sysfs_create_group() and sysfs_merge_group()
are still needed /sigh.

Su Yue (5):
  md/md-bitmap: call md_bitmap_create,destroy in location_store
  md/md-bitmap: add an extra sysfs argument to md_bitmap_create and
    destroy
  md/md-bitmap: add dummy bitmap ops for none to fix wrong bitmap offset
  md: skip ID_BITMAP_NONE when show available bitmap types
  md/md-bitmap: remove member group from bitmap_operations

 drivers/md/md-bitmap.c   | 121 ++++++++++++++++++++++++++++++++++++---
 drivers/md/md-bitmap.h   |   3 +-
 drivers/md/md-llbitmap.c |  13 ++++-
 drivers/md/md.c          |  55 +++++++++---------
 drivers/md/md.h          |   2 +
 5 files changed, 155 insertions(+), 39 deletions(-)

-- 
2.53.0

