Received: from www5210.sakura.ne.jp (www5210.sakura.ne.jp [133.167.8.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA873002BA;
	Sun, 17 Aug 2025 17:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=133.167.8.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755451682; cv=none; b=r5tYNsoBy7F06Fsap72CVwqBkOyhZh5bIzpzif5g9Bqn1SRliete6bcPXykK7VW8vz71PVVu4UB6Uh1DdOb/ZhjiB1qSQ2uo8OewciyVXNkVgXceYsUlrXdBw7mZvQteyghvodnJ7VVE/ud0K3HvUoSMVleUw0wZTuQNk0k13+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755451682; c=relaxed/simple;
	bh=72Kchr4XjpGeIuAgaYfdpkz9shoH/O/gLTqXNYaiC7o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=e8NG21cRvCShBTxbrLoGrgr5Wr7Gc09GT3bUBvg0PUQHvwLzM3Re6fyJS62wGjAhUHZtnpSb7Tp5vl0npSlfuLNLkTurfeILk3I7sbzF7Z8WqDVNurHxwRDw2V5/IojGTIuf2wFAS6iMipO3vKmXubYihkUK3IHuyHuLXJcmo3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mgml.me; spf=pass smtp.mailfrom=mgml.me; dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b=AIEY+xAb; arc=none smtp.client-ip=133.167.8.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b="AIEY+xAb"
Received: from fedora (p3174069-ipxg00b01tokaisakaetozai.aichi.ocn.ne.jp [122.23.47.69])
	(authenticated bits=0)
	by www5210.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 57HHRM9Z012978
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 18 Aug 2025 02:27:26 +0900 (JST)
	(envelope-from k@mgml.me)
DKIM-Signature: a=rsa-sha256; bh=d/yf6+AD1x5rnDhFXxXuhSl+/vS3vLTKBvbGEOoSoO8=;
        c=relaxed/relaxed; d=mgml.me;
        h=From:To:Subject:Date:Message-ID;
        s=rs20250315; t=1755451646; v=1;
        b=AIEY+xAbaegE3UtEgFysda3i3oHxRT4b3I+51Qml5CXLfLMtvPdn/SYoTvatxXNY
         +x1aJiwwW1Pv0dXEcW2YoanVswd1hOvBa3AQZGZqWP4SM1zPUJC18Yg7NAxCBA9H
         tZCk7IbvrRFCpHsApKQkXtGos+kaUOXypxO+WYGqsPTr//eUGeLBEkqbRznMUQ/O
         YojDcXl87uHOU3fO08YBB0a9JZZpXoaTglo9ZzMflByxqlor6BvWdvneruUytlE/
         XnPPmLrNvWKYuRmArEhs+W3eWHWLlE8MdXTJneeXAiVqdh8Kz82srG9EL2hKFM+l
         xl4bq5ZNz3mhtu0DH1+RiQ==
From: Kenta Akagi <k@mgml.me>
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
        Mariusz Tkaczyk <mtkaczyk@kernel.org>,
        Guoqing Jiang <jgq516@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kenta Akagi <k@mgml.me>
Subject: [PATCH v2 0/3] md/raid1,raid10: don't broken array on failfast metadata write fails
Date: Mon, 18 Aug 2025 02:27:07 +0900
Message-ID: <20250817172710.4892-1-k@mgml.me>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changes from V1:
- Avoid setting MD_BROKEN instead of clearing it
- Add pr_crit() when setting MD_BROKEN
- Fix the message may shown after all rdevs failure:
  "Operation continuing on 0 devices"

A failfast bio, for example in the case of nvme-tcp,
will fail immediately if the connection to the target is
lost for a few seconds and the device enters a reconnecting
state - even though it would recover if given a few seconds.
This behavior is exactly as intended by the design of failfast.

However, md treats super_write operations fails with failfast as fatal.
For example, if an initiator - that is, a machine loading the md module -
loses all connections for a few seconds, the array becomes
broken and subsequent write is no longer possible.
This is the issue I am currently facing, and which this patch aims to fix.

The 1st patch changes the behavior on super_write MD_FAILFAST IO failures.
The 2nd and 3rd patches modify the output of pr_crit.

Kenta Akagi (3):
  md/raid1,raid10: don't broken array on failfast metadata write fails
  md/raid1,raid10: Add error message when setting MD_BROKEN
  md/raid1,raid10: Fix: Operation continuing on 0 devices.

 drivers/md/md.c     |  9 ++++++---
 drivers/md/md.h     |  7 ++++---
 drivers/md/raid1.c  | 26 ++++++++++++++++++++------
 drivers/md/raid10.c | 26 ++++++++++++++++++++------
 4 files changed, 50 insertions(+), 18 deletions(-)

-- 
2.50.1

