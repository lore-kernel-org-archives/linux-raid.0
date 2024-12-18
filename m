Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 410CF1A23AE;
	Wed, 18 Dec 2024 12:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734524312; cv=none; b=HlzOsUB7rlb1t8Kn55lHKSRXpbg5ujlaZP7Kzw8LRXa/DaHWkDPhHYWcQ5Aop62nV42BHMXF0mz8oi+vGwxPgfBX1QZM5iNlVqjOONWsXaK62wRFd2GnczE1e0d2rTJc9q+Vg5MrN/BYc8CkK4tacYaSQ8HoxELLtG1J+mto4p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734524312; c=relaxed/simple;
	bh=IKEd6Fz4md5jsf8DS2Rtm86p8ypFqsyrLejf3nWXVIw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=oS/t2YgrQ1elXM7L3D/81Sqk0Gp+UjBfjTP24EVHtID9U5Z57Nhkn3Ape5bSJbsD1n39MUDPhDeocutlsn4AHeprwVHcmDebx1sdS2oJ1brbWxTYwHQFv/P257JSXtOSNHUePqbJBiyMdRZp0arruA6nq8dFbPmhQ/xfQuNMDwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rTbMntgg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rTbMntgg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5F4DC4CECE;
	Wed, 18 Dec 2024 12:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734524311;
	bh=IKEd6Fz4md5jsf8DS2Rtm86p8ypFqsyrLejf3nWXVIw=;
	h=From:To:Cc:Subject:Date:From;
	b=rTbMntggvs2vITyhTe3mn4u0vgSc+8ug1Q9m3AMyH8JkKNZrlQVl8V/ep47befg6t
	 5J2OvPpNxcdsQ/aHH1mMr7PSZhCjXMXXWip+xuSkVRq5bHBx+awOxGgtywA2PA9eYb
	 Bm7OrULtWux8nHDykyzLDebxgDCBfb0IVXHhRFhVgJXWQjKuLWBM5Iy746J7waFx/e
	 /YQQM5lFbj7zq5p8biwVmBlxHxmokkRFs90hRerspyRgaiQ60sG5m80zm1PG88/++O
	 Bs6LmxgDChejzkugw6Sb0xxB+olOKjySimedy+nE2pGXYq+0T5IUu66ntwglDVA77L
	 JPeqcI8rqx1pw==
From: yukuai@kernel.org
To: song@kernel.org,
	yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yi.zhang@hauwei.com,
	yangerkun@huawei.com,
	Yu Kuai <yukuai@kernel.org>
Subject: [PATCH v2 md-6.14 0/5] md/md-bitmap: move bitmap_{start, end}write to md upper layer
Date: Wed, 18 Dec 2024 20:17:40 +0800
Message-ID: <20241218121745.2459-1-yukuai@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai@kernel.org>

Changes in v2:
 - add review tag for patch 1 and 3;
 - update commit message for patch 5;

Yu Kuai (5):
  md/md-bitmap: factor behind write counters out from
    bitmap_{start/end}write()
  md/md-bitmap: remove the last parameter for bimtap_ops->endwrite()
  md: add a new callback pers->bitmap_sector()
  md/raid5: implement pers->bitmap_sector()
  md/md-bitmap: move bitmap_{start, end}write to md upper layer

 drivers/md/md-bitmap.c   | 74 ++++++++++++++++++++++++----------------
 drivers/md/md-bitmap.h   |  7 ++--
 drivers/md/md.c          | 29 ++++++++++++++++
 drivers/md/md.h          |  5 +++
 drivers/md/raid1.c       | 11 +++---
 drivers/md/raid10.c      |  6 ----
 drivers/md/raid5-cache.c |  4 ---
 drivers/md/raid5.c       | 48 ++++++++++++--------------
 8 files changed, 109 insertions(+), 75 deletions(-)

-- 
2.43.0

