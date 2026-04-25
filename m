Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1AED35CB76
	for <linux-raid@vger.kernel.org>; Sat, 25 Apr 2026 14:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777127383; cv=none; b=rvwBXZpZIWPy4/1tIxgoTuqkWCnIUOa+hk04l4VwKTEv3pauMa8Y2McSygrp9mpQ7b3LeIRlVaKzfLCjyq1e+2gzEXNLLrolcwbLcJLe26T+0Gm0rtej37CjS+iK6HnhIVWj3BOLWOpMMXYsGupGxmnYS2PgGZEvGXzt7MadmQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777127383; c=relaxed/simple;
	bh=A6VOulTgouZzEeQe94awfpSmoyzktcwG85H4rcHLhTo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=njfo3hizI+dXU9oylH5ZN18Ddp0jTKcSBF/TM4Evtz031ZDN5aVLEsIN8E4UgDVJXPnjPT4nceCwirq9gU6VjaBxM8HI1bKs0+DB8VEi1gHVk/bgG+JQWaBsjwKTZL/iZbjsBoU1rpkQT+X8myHtjDnsvZojK/KdAY9VoUrWoQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HERi3/yt; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HERi3/yt"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-488d2079582so102469865e9.2
        for <linux-raid@vger.kernel.org>; Sat, 25 Apr 2026 07:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777127380; x=1777732180; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=v1GLAZ6Q4eu4pOonAVDQr61KWdkIrk9c4bRT7Wa1sec=;
        b=HERi3/ytQvd+/s06j8ExAB491e/+zySQHA8Zolpy5Akmfh3tFP24ryxEXkedEJAHVJ
         /Mz1T/iOam/90384E/b2i+EmqCZZJdW052TL8MnQUS7u7efFWPcLraXzle6CQPWxWoe8
         ltWtDF69D/tfWt2pnx4KpUULNH0Sk15C7EEeXTtxCpPPSFucS1n5NFnrvMqkG7YU6Cbv
         PqTHsuxT3isL9AL1/UEkBZsYLTq+xEPVVLs8vjP0MClbQJkL9CvVIFsUFo036RMSJCDe
         VsWzWB/EzThTaTEKP3c6lSF5FXiyV6AmfZWD6AQPJaVKrsYVGGAi8Tq1XdoXo/0Bdn4R
         Zn2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777127380; x=1777732180;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v1GLAZ6Q4eu4pOonAVDQr61KWdkIrk9c4bRT7Wa1sec=;
        b=GT2oiM4OUBlvJ07iB5zvSAT/SQE02w+T7a7B/LApkpCpMxMOFRv86L0C7n7x+hT93b
         6O+GtcLzjqu4wfYvTbGfPE/vGvvqcUz9sTfYroFFY565W+1VUfWgmhr769QulMD0PCGr
         asTFEGDhOkGxA5vbzDIGYX+10eZX8+84O9j4OZbA/gWwPUDprCwJ2YoXxWKi/od4Nvl3
         abU8j2DzTGmo56O+F3/2OIDyKhjioaYlksRtVjfstdj8mFrSm/9LhBBz7jNTQ5ensOGL
         3Ckp168nNNK/16Vy2A57oXQu/DYrB+sdYmtY6oTVoSnT6uPEuTg6iNbQl5HdQvsQlNTm
         fPHQ==
X-Gm-Message-State: AOJu0Yw0Qj3b2vuzE66hW/azxPdJmmns89FJzdBlVEqYmYQehx4GWqs4
	poHTF99cBJZrkGulyXqr2l1nbWvITMmTPQwOkKY0GstPkGHOgOVCYt2AysNNMA==
X-Gm-Gg: AeBDietWme3qwp8je0Gvg0FIvJEQVzFfdhyVJ8PGRNRjqjD6fZTndM4VBoNjGfib7tW
	5D4/p5aZg9zIotaeXHSxtjQC74Gft6bEnlaM48iW1v+MH9wiYg03jGQI7O/4uedkOwjaOypD4eA
	oUr1dbQF4UZtoz/eMX0/WU1stoo+8tlET8mS9/jZSbBUnH/j+FnHU/nd6ilRC/+a2BbElJrqwb2
	ACbIAoTWUYYNV99JsC8O6stz0HrUnSaTzAo58TW5rLM4YoLw9GJqtTlAIOVl3xqOCHG4mGErMyo
	jZ8FTarHz+koZt+/52xfBQp8tW8CJmkiNC8Oqldjhxtib7tHo8LVj6/pQYR66kggmjZU0ohn/qI
	1uV3GSMdF1RumvfDPkV5siBVA5TTs032CenyrK4LKuySlpjIuwCNX/R7efLr+3GBhBDIRTaXK6l
	kBRSMbePIepyjMO3gXV0mj3pafkD5gyQiSzzJ5nz1iEPHf4XDsrpry3gIubF4StFmDtf6bo4qzJ
	f1tPY/bMaBCQxMh2rTkovF+Vg==
X-Received: by 2002:a05:600c:2d09:b0:489:c57:7836 with SMTP id 5b1f17b1804b1-4890c5778ffmr231039785e9.27.1777127380144;
        Sat, 25 Apr 2026 07:29:40 -0700 (PDT)
Received: from yocto.. (dynamic-176-007-212-220.176.7.pool.telefonica.de. [176.7.212.220])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fb7b2716sm209489945e9.30.2026.04.25.07.29.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Apr 2026 07:29:39 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: song@kernel.org,
	yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC] md/raid1: possible deadlock introduced in raid1_read_request()
Date: Sat, 25 Apr 2026 16:29:38 +0200
Message-ID: <20260425142938.5555-1-abd.masalkhi@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

hi,

The raid1_read_request() function splits a bio regardless of whether it
is an original bio or an md-cloned bio (regardless of the r1bio_existed
value).

When an md_cloned_bio is resubmitted, raid1_read_request() treats it as a
new original bio instead of recognizing it as an md_cloned_bio.

If I understand this correctly, this results in allocating a new r1bio,
etc. More importantly, this may lead to a deadlock if we tried to 
suspended the array before the md driver calls percpu_ref_tryget_live()
(&mddev->active_io) on the path down to pers->make_request().

I am considering two possible approaches, ending the bio if max_sectors
is smaller than bio_sectors(bio), or modifing read_balance() to select
a disk that can handle the full bio if r1bio_existed was set.

Is this understanding correct? and What might be the preferred approach
in this case?

Thanks,
Abd-Alrhman
