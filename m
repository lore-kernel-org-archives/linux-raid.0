Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30073AC0EF
	for <linux-raid@vger.kernel.org>; Sun, 28 Jun 2026 14:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782656670; cv=none; b=fYzxe8lw2LnOojY9dc9AKC5u5OrnkzSgYZNr7LFegCo8641hvfU58QECExbqeSFl/E2izAU8TVv4Vj3hSym+ZkMG9RcJ4l+e0iF+BhCwpxQ/ZzpK1nKpdnFMzT2Nd+AumHtrZdJcaWb5RundZHstQqVb7QwXadTLDLuxS3OoY9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782656670; c=relaxed/simple;
	bh=zUz43ZH7VKchUSdgQ50Q0qRIyRBfS4U8Ixx9tFPlIpw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ioHkBqDCxJXReMsCck3UpMAhqfZK/yamSKr2JoCe+8TMOvzxW7YaSVHQn7zY1szCbdBmooM9GzaoiBT6yKcce1CM3BuXCbx1FMn3i6YbGOapKAzTMsLLmlHVoKLuDQRVFtqqZ3T6bnMtaQLzVPeHaSSQIGuP5eNmsNLGQnOb7Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bwM4Kt+J; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bwM4Kt+J"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4936e85e0deso5712495e9.2
        for <linux-raid@vger.kernel.org>; Sun, 28 Jun 2026 07:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782656666; x=1783261466; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=4YcpIATYRtraK9yBXIVvQeJwZDE3/yv25GmcunhXyJQ=;
        b=bwM4Kt+JbPnhy79jbc4V//TYJ2klb8QlesBRKRmhGTVsMmU0uqIeoQMjyEWk5Au5ri
         HJTAu5e7pd2Qr3UcRvMZnsMVVCTJwa8hZhfuefmzOb1Nj0Iq/7SJ3gYrrdCz7ZHQFtwB
         fO5jPjwOb3UrhuOs7Brgq87MRiRJ2/2G9rWqI4qcReMr8IDM+OIBHUwdeqf1Ga5KwWHm
         ZG0etnygjmKHftF/T9fr9AEYuELHhhg00jhKp7eGG7So8fOu3o2UJJO1vqCI3fgrB/U+
         cbh1m1R4PQo/qufBy9l8rhx/yrGI1aFnQzKXLH74RxEux1I57GX+RwuqoMAOtGJ5SqW/
         A1WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782656666; x=1783261466;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4YcpIATYRtraK9yBXIVvQeJwZDE3/yv25GmcunhXyJQ=;
        b=RHDf6fwnIBOIAvFPjHZmpej1EZ0Gt9uLiczz593Urf3pSz8pwkULxldlU4JRGhdT91
         6NzM0N5hGOt4gGd3dFmPt8DrjXaj/jCoivau3KBEh5ShmqGaf7aydJKuXt8CQo6MYMpd
         kOmZrP7LaTWxFr+H2JJmWC5dj7i29cKIenQ/E3tMGHs9ukkqdbzpjz7xPvToKTtPgsjX
         0SD9XqB70civOq/r7NLV0NCkVXv2zhWtNhpIMFOcVIS/K4M1kKuAeg3EantkVDNjltm4
         daQ2Z081HC36W3ickiQuUC4V6leD+GMaCMuZMID8A8ECOkQ/cBwWgVJ2Ox1IbPwzwfOU
         Jhtw==
X-Gm-Message-State: AOJu0YzE1yc1PdNYXH8OlDAVSxVuHL75h3Cfr2pFi2oJSzAC5T4bUr3O
	ElwONbNVJZgjybOQDSQha+upCS9YdowsOeJzl1iCMutGNbl7Cap3ZUct
X-Gm-Gg: AfdE7cmp/0WmiCF1K2r7BC8y7x5L8Om5URQe/Y+3nVZ7a8/Gt8PyAB12HxVcST/wpNq
	bFLDuTnlgF5Gfu83lvrke3Lmc38btcymnjgw7j/TNhWK490lYJHTBH2hZAg8rMXhubRNFED0aDV
	9GP4E/EbBxqm7y17Muz5U8xWw85WFf/fl9ubhP6Cb7/xrMAhbyUGAAaK1EpirA5gwfUr/rZ0ITS
	azb0sUR6A9kyf2f9CtL7FzwYe/E4IgTfuU7eEKau/mgZmSSXBvzTPndwUBQpOUZMRrdipYYf1XR
	KnIjtiFdaXtHp7ScnKhY5BMgXXP1VXmTOdTg+SxBflK3lv6pxOwPz5mgVWIOwp+hebJ7WhEYRu8
	I7UPzRtoC7wVu+cIf+GBz/0zLYOFftCrVS/mFDAT+VKNa5o+LWpQVY0BZ6oYnScjyO77AOJgIXD
	hnG7mKi5SYfNZbj/3xvySXBMyrnTfHXA4KQGFCNWhEbkqrwbfKYtk6t0oc5viZWgrsRCl2ptSnn
	UtqQuA=
X-Received: by 2002:a05:600c:1d0e:b0:492:2f59:4969 with SMTP id 5b1f17b1804b1-49266899d40mr209889975e9.22.1782656665773;
        Sun, 28 Jun 2026 07:24:25 -0700 (PDT)
Received: from yocto.rz.uni-frankfurt.de (cb-8021x-nat-134-108.net.uni-frankfurt.de. [141.2.134.108])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4728072189asm7819927f8f.30.2026.06.28.07.24.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2026 07:24:24 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: song@kernel.org,
	yukuai@fygo.io,
	magiclinan@didiglobal.com,
	xiao@kernel.org,
	axboe@kernel.dk,
	vverma@digitalocean.com,
	john.g.garry@oracle.com,
	martin.petersen@oracle.com,
	abd.masalkhi@gmail.com,
	linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org
Subject: [PATCH v2 0/7] md/raid10: fixes, atomic write handling, and error-path cleanup
Date: Sun, 28 Jun 2026 14:24:13 +0000
Message-ID: <20260628142420.1051027-1-abd.masalkhi@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This v2 of series contains a mix of bug fixes and cleanups for RAID10,
along with a related atomic write fix for RAID1.

Changes in v2:
 - Expand the commit message to explain why the
   allow_barrier()/wait_barrier() pair is no longer needed.
 - Drop the early atomic write split check from raid1_write_request().
 - Advertise the atomic write size limit via queue limits.
 - Disable write-behind instead of failing atomic writes when the
   BIO_MAX_VECS limit is encountered.
 - Drop the early atomic write split check from raid10_write_request()
   and rely on queue limits instead.
 - Fix a compilation error (bi -> bio).
 - Link to v1: https://lore.kernel.org/linux-raid/20260623072456.333437-1-abd.masalkhi@gmail.com/

Thanks,
Abd-alrhman,

Abd-Alrhman Masalkhi (7):
  md/raid10: fix r10bio leak in raid10_write_request() error paths
  md/raid1: advertise atomic write limits and handle runtime constraints
  md/raid10: consistently fail atomic writes that require splitting
  md/raid10: remove unnecessary barrier around bio_submit_split_bioset()
  md/raid10: replace wait loop with wait_event_idle()
  md/raid10: simplify write request error handling
  md/raid10: simplify read request error handling

 drivers/md/raid1.c  |  36 +++++++-------
 drivers/md/raid10.c | 118 +++++++++++++++++++++-----------------------
 2 files changed, 74 insertions(+), 80 deletions(-)

-- 
2.43.0

