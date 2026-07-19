Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1229039DBCF
	for <linux-raid@vger.kernel.org>; Sun, 19 Jul 2026 14:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784472174; cv=none; b=rfZf88AClATnIuC2lbyMHCXF8WHiN0NAK8QrZlwf/tGJD0ARwfWzAgDlMhO3mzZDhhcpSkUM0mRusBvSs+C5tHOgsccLUK3pIThcpWvn7qzhHXqrSVvX79AsOkLrEvzHdQUR5hCZV5pNucoYLSsvTsxeRSO5DKtGhv/66g41llc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784472174; c=relaxed/simple;
	bh=oQUTr6CYoMz+3KkQKXqfB9kRiMcFrW/5MVb+DqECyZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ix2goxjMEx8g6maArVvzZm4YkcUhBuHRIgB4wzywoy7mWu1+jj0GSswp6sW1UhDFCvn1FMBUN6HpzUk+gmSuq7/5vhM+U1yVuPPxJs9gdvilIK2UGw9OPnRp7Tk5EJhkQG93dEjOjxiRJl/Ap8y8C+tYBq765OdQ3iD6UE7LaK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=HNi7dwL8; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="HNi7dwL8"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-4758bd3731bso2469396f8f.0
        for <linux-raid@vger.kernel.org>; Sun, 19 Jul 2026 07:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784472171; x=1785076971; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DWI2J+oPgO3qtXoFlpsHSDdFhAykwJO3OpAhzswB1nY=;
        b=HNi7dwL8MTR9pkOqCng0f3F75SU3qM6iVPqoHxafH6uMCpke4/YlmvvEXvUXdZfayF
         9hT62FIxjoBb0SXH1+SHidIqmQWh7hDGIItLGZEtgriT8WTKAPRvAQcBdwSj2FNp3qYJ
         isZ7s/XsWzITe5woiu4WI6wdYzZEDduqL1mDb6xH4ZVSOqs7N9NT9ykRwpqjByNZ+1JQ
         Yx4pGlsVXr+P4XPPvxjLcpBHtiA5rAVak1NH8yRY03nqyve8PYOV70GVJFjzRl17Qvvm
         1Ax4RfSMmLpuerJxIul4nAc8ygve9RNsllLM63v088P1beFamqB4if1oKQEx+fXY+vL6
         44mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784472171; x=1785076971;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=DWI2J+oPgO3qtXoFlpsHSDdFhAykwJO3OpAhzswB1nY=;
        b=jt4fZTRm1xSep5g329uc6acXX4iC5WRKHvTO9MZ6N00gC3UKd7ktssnTo5Ag9AIVjs
         wR7K7SJZTU5z15b74az4IIYllkDOSlAiAPk5i11gS3K6BKX9/0xAZtWRrh2SHMrN42/2
         7g1zls6FcwWBax9GiWwpzEfh3bmAtReUKSxMm85+c1oGxffj3SV8psU4BLAEoyYHulNx
         iz7aJDRankB2LqBVF2Ns8uPAxnzgSX2/qJiRTIXBvyqa0b02/cS1S+IDvFOI5ouAOxuP
         9zbpVjIMhtGq0dQTm9+VzhBNHXsOO1+BhLDzeP9a6wsWDdhxpOSI3McjbguzwvQZFilq
         iSDg==
X-Forwarded-Encrypted: i=1; AHgh+RpicftlyTjSEaw8uk5at5L7HMmJemAAjL6nipgXEyOvSfHdaX0WTLe3WDG4RHX6l3nj0cWj11eAbBG9@vger.kernel.org
X-Gm-Message-State: AOJu0Yye+eI1v762phDfhnhJQzzxLdgcdb8xiXqBpKCpsi83bWXwBRv5
	F1j+OqgRNC/4N0OX4+iiRbCS+j2zL88/4ERVHkYctokEzB9jUz1yP0QjOgZqPBDvBQ==
X-Gm-Gg: AfdE7cnlqUBN6b52ZzodiMKvfDaXMGpNpxADdZRdjzx0O01bQprA1YkChjYuPDxm354
	bauxffoZxY5LDZhnIloviSKbnxIf45BXZhSvIQ/ptiy/QFNUeEy5W6etw1Yhn+r4HsDSgYGKALE
	pyJqNm2BOG5yoQcVz1J+LLO4IUUMHgKJP12lVnBRTImUmgEucO9A854KYXaFrND0l8Pgy36s36G
	4mcR9bGiGYXbYTwaf4YXEj8z+dkXKH4gYQk0Oka5mzwxextuWhqIHimwdf0q4sB/RdZeSomi5bf
	uDVfqhcpMtELr9C/X+Y+gye82DKKTatiHqTuelDcRx+fz0kvgYTGfJXhbsIKxoH9gO+yVxrFl5M
	ndVl49oroSrm/mYRx3xOYtDQdvstc7Q6tJO+kZ7Vrax0Nno8t/OuypPLOHqD8DAJVLyw50IXm
X-Received: by 2002:a05:6000:25f1:b0:475:c578:b62f with SMTP id ffacd0b85a97d-47f5a419656mr17652936f8f.5.1784472171340;
        Sun, 19 Jul 2026 07:42:51 -0700 (PDT)
Received: from mf-00-01.. ([194.220.239.180])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f63ec7c69sm22668895f8f.17.2026.07.19.07.42.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2026 07:42:50 -0700 (PDT)
From: Mykola Marzhan <mykola@meshstor.io>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] md/md-llbitmap: fail resize that needs more bitmap pages
Date: Sun, 19 Jul 2026 14:42:27 +0000
Message-ID: <20260719144227.940444-4-mykola@meshstor.io>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260719144227.940444-1-mykola@meshstor.io>
References: <20260719144227.940444-1-mykola@meshstor.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

llbitmap_resize() only updates chunkshift/chunksize/chunks.  The
page cache backing the bitmap (pctl[] and nr_pages) is sized at
creation and never grown, so a grow whose chunk count crosses into a
never-allocated page leaves the data path indexing past the end of
pctl[].  And when the reserved bitmap space is too small for the new
size, the chunksize-doubling loop silently changes the
chunk-to-sector mapping without remapping any on-disk bit, so the
existing intent state describes the wrong sectors afterwards.

Fail such resizes before anything is mutated: -EINVAL for a resize
that needs a different chunksize, -ENOSPC for a grow that needs more
bitmap pages than were allocated at create time.  Shrinks, grows
within the allocated pages, and assemble-time sizing keep working.
"mdadm --grow --size" past the boundary now fails with an error
instead of corrupting memory, and a raid10 disk-add reshape crossing
it fails cleanly in raid10_start_reshape(), which calls
bitmap_ops->resize() directly and reverts the geometry on error.

Grows within the last allocated page can still expose per-chunk
bytes that are stale (after a shrink) or never initialised (the
tail of the last page: llbitmap_init() covers only [0, chunks - 1]).
That window closes once the bitmap page cache can actually grow --
the subject of separate work under review.

Fixes: 5ab829f1971d ("md/md-llbitmap: introduce new lockless bitmap")
Cc: stable@vger.kernel.org # v6.18+
Assisted-by: Claude-Code:claude-opus-4-8
Signed-off-by: Mykola Marzhan <mykola@meshstor.io>
---
 drivers/md/md-llbitmap.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index 5a4e2abaa757..e8f853e8461d 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -1150,6 +1150,32 @@ static int llbitmap_resize(struct mddev *mddev, sector_t blocks, int chunksize)
 		chunks = DIV_ROUND_UP_SECTOR_T(blocks, chunksize);
 	}
 
+	/*
+	 * A changed chunksize would require remapping every on-disk bit:
+	 * each chunk would cover a different sector range.  Refuse rather
+	 * than corrupt the existing intent record.
+	 */
+	if (chunksize != llbitmap->chunksize) {
+		pr_warn("md/llbitmap: %s: cannot resize to %llu sectors: bitmap space (%lu sectors) requires chunksize %u, current is %lu\n",
+			mdname(mddev), (unsigned long long)blocks,
+			mddev->bitmap_info.space, (unsigned int)chunksize,
+			llbitmap->chunksize);
+		return -EINVAL;
+	}
+
+	/*
+	 * pctl[]/nr_pages are sized at creation and not grown here; a
+	 * grow past the last allocated page would index past pctl[].
+	 */
+	if (DIV_ROUND_UP(chunks + BITMAP_DATA_OFFSET, PAGE_SIZE) >
+	    llbitmap->nr_pages) {
+		pr_warn("md/llbitmap: %s: cannot grow to %lu chunks: needs %lu bitmap pages, only %u allocated; growing the bitmap is not yet supported\n",
+			mdname(mddev), chunks,
+			DIV_ROUND_UP(chunks + BITMAP_DATA_OFFSET, PAGE_SIZE),
+			llbitmap->nr_pages);
+		return -ENOSPC;
+	}
+
 	llbitmap->chunkshift = ffz(~chunksize);
 	llbitmap->chunksize = chunksize;
 	llbitmap->chunks = chunks;
-- 
2.43.0

