Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB5B2E7386
	for <linux-raid@vger.kernel.org>; Tue, 23 Jun 2026 07:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782199504; cv=none; b=a71BQQv2L48WKGfMaYvt2VVY6EFgl38/ij0l1Re3Fz2JjTaMoF8WPDz2FXQQ6k8amWsz6QAulvYewKtCJfkzelYgyPhkGO1P6fWJMCwEBT2w2lXbuPQSIGX569EWT4zDYZ1Rvx5qPXaQ3FX6eP3tO/m3mbpqgUefU4qBl5NVRgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782199504; c=relaxed/simple;
	bh=/+mGHHhsYyMd+hA1SQCSgnB70riUk/rXgwXN2pDB79c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=chkQiuDoIEDTtj8M4r1Vt8XdNF93X3zMcPOZIlYdZUg9ROtvAM7axENfsCHTAPJoews3MKopIzkccpbrVFUb+10K2rf+Ns0VH/S102/x/MXzAlcRvVXgp0+Senq5PPNo+xCUQ+jpJInds8d9283+ovk/lx+2o1Br5SdyWISG8pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Uo8Z3kt0; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Uo8Z3kt0"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-490aaeabdb4so30967035e9.1
        for <linux-raid@vger.kernel.org>; Tue, 23 Jun 2026 00:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782199501; x=1782804301; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Aa8NgND/XfWSAJltUFMPfLMmtEs03oTUTn9pERKm1Jw=;
        b=Uo8Z3kt0QyrXtvHZb3PXY0AAWnKBIOd0Dvd0nCOWy9dcqH8/0vcaNJafR7iFr88Cm2
         hMjiel/ZMESZd5M7vB7ra+I0HJYKeK/efUoTYlQlYYflCe6Ln8kHOHyQOu6GbyI4jtvg
         AfgURMJbwxu2GCFqgb1xKKiCahtPWEFWaL508oE77loJul1uGSd9vr2hZhW1CO087caA
         IwkzsBQx5mZYMcl+lnnf8ZLmMF5dyOU/9v2/94Gv1EJoKfEQlFtJ5ffq4slSfVytxr+8
         xMVXJSMlSih7jHq1NDcjNgX9cjow2NZ5hRjiq2P4WVRWhsvANAyPxjjLVn/4Xrq+svWF
         hc4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782199501; x=1782804301;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Aa8NgND/XfWSAJltUFMPfLMmtEs03oTUTn9pERKm1Jw=;
        b=bFEofA/1WwE1SkXYjFbEhZzij8gBd308vbru7slcDYNVqBsFyoy1PPSVg8Aw3Y1Akk
         ewL/Y4QYzLRHJWojJZF6s3p+Nu/vxgcCbtzLKqyFUfSjs9KWlD2Rl+fBk1YxHKfjZPvb
         kIrIqpFO6+r0Wtxmr5znVTEkTFFMBddVNq/Wiw7wAmIbLSOpuodVeOPMI0CwCBN0ZyEf
         FBWW3x/qJr+yIAiMJ5YZQv59sViImbqBolQSDgtN2CoGJjlNnS948VOZIG86sIbzMw7z
         6Lg3fBCWiFEGzlrGaistkXS+f4HCx3DETCyPpXYHbt3azqtzCoLYsIqVbpMdbGOM9ApI
         5Lxg==
X-Gm-Message-State: AOJu0Yy1z4o4mrvntBzEw7chFamWGzN4lF/5a6Td34drcNYK6thJkbK0
	zDIbwC0cY1GHqhd/+gtzT6UkO1nwKh9qx/2Sgg7VEXI+NYMxAdtMjM9L
X-Gm-Gg: AfdE7ck0PWBpe4J533sN+rCV1drZiidEJO2GaQPuP3r8W54HXlAs/cIDDZiXLQX4tr3
	rRV6PXus8d3b8As0+Pja4pNZz4FnKsT+n1pfSwSd7l4n6XgZmNOt2Gg+BpLEdTlDf7WZ5pgYQ3T
	1dHo3vryRDjJAdO+BiwStsy8HtSLiEahZXCqwQYBYIl5X7tEa0MDK0wJunGM51cYTJHzQxcF+H1
	Vu0T4bBNX5sd+FjjGeeOYigaEkRLgcgZfvVj3kJrM7QFUjQ05RuNzO6+KHCm9Y0Qx1eTY/mWeFK
	5+pFDsh3J8Dlg4kDZb1g9hPuHiIsQmrV6JBI0ojGQKGuw83uo2I8T2bI+Kq/g1+1GdEzvE3NHwx
	anR/uy0wE4hsjkUf5dH/kPzWyMmZ1WNNusBdLuGs1g8367wnYyBjh0G5Pt/FEbO+k8My/5QtsF/
	OiONOJ6zbxI32sAaFpCvccmptx1qJTD/E8
X-Received: by 2002:a05:600c:870e:b0:492:415c:8ac2 with SMTP id 5b1f17b1804b1-4925b3c8dcbmr19689985e9.36.1782199500973;
        Tue, 23 Jun 2026 00:25:00 -0700 (PDT)
Received: from yocto.rz.uni-frankfurt.de ([141.2.113.173])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-46666c57afasm34278743f8f.29.2026.06.23.00.24.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 00:25:00 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: song@kernel.org,
	yukuai@fygo.io,
	magiclinan@didiglobal.com,
	xiao@kernel.org,
	axboe@kernel.dk,
	john.g.garry@oracle.com,
	martin.petersen@oracle.com,
	abd.masalkhi@gmail.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] md/raid10: fixes, atomic write handling, and error-path cleanup
Date: Tue, 23 Jun 2026 07:24:49 +0000
Message-ID: <20260623072456.333437-1-abd.masalkhi@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This series contains a mix of bug fixes and cleanups for RAID10, along
with a related atomic write fix for RAID1.

Thanks,
Abd-alrhman,

Abd-Alrhman Masalkhi (7):
  md/raid10: fix r10bio leak in raid10_write_request() error paths
  md/raid1: handle atomic writes that require splitting
  md/raid10: handle atomic writes that require splitting
  md/raid10: raid10_write_request() drops the barrier before calling
  md/raid10: replace wait loop with wait_event_idle()
  md/raid10: simplify write request error handling
  md/raid10: simplify read request error handling

 drivers/md/raid1.c  |  25 ++++-----
 drivers/md/raid10.c | 123 +++++++++++++++++++++-----------------------
 2 files changed, 71 insertions(+), 77 deletions(-)

-- 
2.43.0

