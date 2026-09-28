Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B5394FC357
	for <linux-raid@vger.kernel.org>; Mon, 28 Sep 2026 21:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790630679; cv=none; b=bd5wlhyD1sni7XH7TOijTXps/DNAn5jkMKc0bZ7ABH7Q4BFZwkYvDBd38jzTDMAzqanqoWpfVUfUIpSeJT3dye9s7Wwxj4WpAT5qh8icKX5lTuEO+he0EZOQ6Q9iRu4S+KklFyTD07z+8WxQx9oBjSHcpTWzJIq0UgHkUKbR64U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790630679; c=relaxed/simple;
	bh=J3+JakjEmegRUseVuPPSH83zT3KL/r/60QIHY4T/JdA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bNtZoHNghBh/J72P3azL896EjpwvfmHID+visDhEeQzfuQkOX+2LubI2nED7D75luGyIgewVPuwDSJ7cEH0nTXUv4G6rbLHuSzc6A7LU0uOvFETnU6B27NDkvdrYy5eu9I7Q3duhnilMMSPUQwTxRO/bnTA1YNDkpXAyz7ad9kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jvhHGSxY; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jvhHGSxY"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-4843378fb37so2107504f8f.3
        for <linux-raid@vger.kernel.org>; Mon, 28 Sep 2026 14:24:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790630672; x=1791235472; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Tfhdvxck6e/VGBLhH1y3Pr8xpk9G1Mao9iti+MUyAGY=;
        b=jvhHGSxYlrvQDcoTYbHECl20bEHznZzWMq+HqGRJnF6UG6q0BAT6/h/9DjPFE9Ecv0
         oeYbTSIHca4VX+P2OYKVOApR6nseHbBmTRy3kZHjtMBM0dWGM3PfChKiaDi4HffRg1cD
         E5lHALW5QuBkg3BvZBrIpTR8jWZA3gsLAcvhRnm+drhTmaQ2BGuyt7j4NRZ/U7QQCk7f
         qARnnpzZdtOggk3cDnP9uSI1E9Puc41lujBDWQqHYkocGyiBVs474DRgCPjBK7QLOzqu
         M1LP4CL0J3HSCx/LgOtnfz1zg/K7te2TWFhS18s9ychy2YzLCRWg966vp6nD47bx8ur1
         KeNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790630672; x=1791235472;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Tfhdvxck6e/VGBLhH1y3Pr8xpk9G1Mao9iti+MUyAGY=;
        b=S/sA2k0zr5iOXIvTUY9TjA0Ynk3EO4BzUs8MLP8PE/cLaAHjxRo2BePk2Eu1B3D5M3
         60K0TtmIRg9DYXgaU8IArNCBSs/vvJ4qPcL7sbgNDY971kpZEPYhD4/JT5QrLPxglsZB
         r4OIMatPYgYJJ2T9ZCiMt1l94+Y8l6OvhUo4WZA+kVhjhbQ4qu/2f+9eyE4HgrAUgQnE
         84OdxsJZW500NAjwa1M1Rip5qQTVnx+qRzlL8YGsXBiaTDrykA8zd3MGupzlDHKgyPRt
         jiYtLAtf/l+hBkI603yfb3JPZPTg6Xvts/Dx/3PXu+fUXaKmyWtK0MnNNynn6iBvQ8gn
         l7LA==
X-Gm-Message-State: AFq9FYJyPjnbDzKp6BH2SZYnv2UwvQMz2WaOVI6MdgvLj/fTIo6BJTrM
	X0m276URM2Il+ALxV+TpkbIYTt4B01GOlc+8LeDmHCNDNP6f7UplFFns
X-Gm-Gg: AYBFou0kuYKzegfpBCYSU07Kym8jjqHfUMAePNnJHBWRO38UWeGmxmlKkGXVQn3c//i
	2Yde+ko+FsblPmZcjKZ/ioO7951X3VAP+3mXtY5Fn0s4w/HFxre6bDb0dC27yK6Gl+WtvcKAQUT
	8P3J5P+sAbNqifUPQF83W6o/wIYcR1+YJ2uMnIa/ZbL65iFH6p0PT3h9HPZQWXMVDlQHS43GIYg
	LjQEb81zS69kHtarOK8D2jLdc7N0EyAosVbCtEcBpbOffriw+MUVPJkph9JclwdFvPA8IYqx6gt
	+qOwZWpfUMOQ3lHGaTeq/U1sbdwZUGrYqYmfHO5qnofEb28tNHHX6Qz/2uKTZUiDRMe9MxAN3rN
	Und78KdQNtvdfLWaBx7ynK/8OmJ5JqMZ9xKFzy/fORaLlN/u1yhijLEnMoQsdHyiMH6Q3XmGcPW
	9oxtTZyQ4sqPcm+8g703rK6grAZSPxxnvDDoZ7z4jh6abDA4z0S2ZXGNAstdsuPYdYmc66zWrKd
	53M/8DyJpkYW+GdIHkDJ8HYcqtrxt5gTSxG9vyhbSiP1ul9
X-Received: by 2002:adf:e19e:0:b0:488:8132:1429 with SMTP id ffacd0b85a97d-4888132168fmr17401129f8f.20.1790630672012;
        Mon, 28 Sep 2026 14:24:32 -0700 (PDT)
Received: from env.. (dynamic-176-003-100-011.176.3.pool.telefonica.de. [176.3.100.11])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4887a34a314sm30869895f8f.6.2026.09.28.14.24.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 14:24:31 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: yukuai@fygo.io,
	chengzhihao1@huawei.com,
	blazej.kucman@graidtech.com,
	mtkaczyk@kernel.org,
	ncroxon@redhat.com,
	xni@redhat.com,
	song@kernel.org
Cc: linux-raid@vger.kernel.org,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Subject: [PATCH 0/2] mdadm: switch management ioctls to /dev/md-control
Date: Mon, 28 Sep 2026 21:18:47 +0000
Message-ID: <20260928211849.3602414-1-abd.masalkhi@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series updates mdadm to use the kernel's new /dev/md-control
interface for md management ioctls.

The first patch adds the md_ioctl() helper and imports the new UAPI
definitions from the kernel. The helper sends management commands to
/dev/md-control and identifies the target array by name.

The second patch switches mdadm's existing management ioctl users to
md_ioctl() and the new 64-bit ioctl structures.

The kernel-side implementation of the control node can be found here:

https://lore.kernel.org/linux-raid/20260928201224.3602262-1-abd.masalkhi@gmail.com

Abd-Alrhman Masalkhi (2):
  mdadm: add md_ioctl() for the md control device
  mdadm: switch management ioctls to md_ioctl()

 Assemble.c    |   4 +-
 Build.c       |  12 +++---
 Create.c      |  19 ++++----
 Detail.c      |  22 +++++-----
 Grow.c        |  30 ++++++-------
 Incremental.c |   6 +--
 Manage.c      |  44 +++++++++----------
 Query.c       |   4 +-
 managemon.c   |   4 +-
 md_u.h        | 117 ++++++++++++++++++++++++++++++++++++++++++++++++++
 mdadm.c       |   2 +-
 mdadm.h       |  24 +++++++----
 mdmonitor.c   |   8 ++--
 super-ddf.c   |  22 +++++-----
 super-intel.c |  14 +++---
 super0.c      |   6 +--
 super1.c      |   6 +--
 util.c        |  52 ++++++++++++++++------
 18 files changed, 273 insertions(+), 123 deletions(-)

-- 
2.43.0

