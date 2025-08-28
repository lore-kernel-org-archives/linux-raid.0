Received: from www5210.sakura.ne.jp (www5210.sakura.ne.jp [133.167.8.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA226342CB8;
	Thu, 28 Aug 2025 16:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=133.167.8.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756398800; cv=none; b=lYZsdj7mYB3FiLouG1gBDqvk9X3/TBkBJ49KvwWbbouxFYTvgxF/ZuUf/pJnHQuA7uH6Zq9WblMdoLGuZOICKkqw0SZ0ZVb1ydjn3PRzdb1bo1R8+knnoZjoW0PM8WlzbmRclurQ4QzUz3YFQ4lvULrcqoSdpjjginlAGJAG0kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756398800; c=relaxed/simple;
	bh=MIav3jRn7ATCUTgRKGzzS34xmq77ZazS2J6HmaqF0fI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=vDzx42H7GTmVMb2T1pKCLTQabA9Ufv4GTIVzSAloijn39oCWE4xshS7Risp8wXiibo3caSdzt8scFGolQuRGVs1rSSpXv4qeAyWkHHVt55ygy0dnzeH1Br50qBT5NdFx3DzDrrWshICpjpS6xWXI/xJMBnP/HNwaNhmCBhEDYUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mgml.me; spf=pass smtp.mailfrom=mgml.me; dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b=VEZthFuj; arc=none smtp.client-ip=133.167.8.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b="VEZthFuj"
Received: from fedora (p4276017-ipxg00p01tokaisakaetozai.aichi.ocn.ne.jp [153.201.109.17])
	(authenticated bits=0)
	by www5210.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 57SGWlxM041448
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Fri, 29 Aug 2025 01:32:51 +0900 (JST)
	(envelope-from k@mgml.me)
DKIM-Signature: a=rsa-sha256; bh=2IMF+N/xzXiYMIFYSWkhPBEE2tRzYuSIjXl8Y+Q0OZs=;
        c=relaxed/relaxed; d=mgml.me;
        h=From:To:Subject:Date:Message-ID;
        s=rs20250315; t=1756398772; v=1;
        b=VEZthFujhnp0BAmpVTpFnkRIC336WTKzhZjHfw+EXC9CV8GDGS/Mp2mpS/lCOhbr
         +LgpF66j7vZ8fUWsutgSYbYOzeLCmJsiBrUJ406AbtgbJSfwVIw+nLUZj7fyM/ZV
         pMdXT1DNT7j2meh3+nyevAanvjmya/7sCuwp9qr4UqSASvBGGx+sKlnSzUy/2wYx
         RpnP+CfXKTaj/h8w5c0tA2BLpkItZZLlNDY0Kab/c+oa77EhA4/M86J/Zw8S/upL
         4M/hoxmbzlkSPTngpoue359k3Y9Si3oqhmRyLKQWt/CNtiyBOEP2E1S/V6aulZEz
         LyySRLdT2pCOoxTntIfg3Q==
From: Kenta Akagi <k@mgml.me>
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
        Mariusz Tkaczyk <mtkaczyk@kernel.org>,
        Guoqing Jiang <jgq516@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kenta Akagi <k@mgml.me>
Subject: [PATCH v3 0/3] Do not set MD_BROKEN on failfast io failure
Date: Fri, 29 Aug 2025 01:32:13 +0900
Message-ID: <20250828163216.4225-1-k@mgml.me>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changes from V2:
- Fix to prevent the array from being marked broken for all
  Failfast IOs, not just metadata.
- Reflecting the review, update raid{1,10}_error to clear
  FailfastIOFailure so that devices are properly marked Faulty.
Changes from V1:
- Avoid setting MD_BROKEN instead of clearing it
- Add pr_crit() when setting MD_BROKEN
- Fix the message may shown after all rdevs failure:
  "Operation continuing on 0 devices"

v2: https://lore.kernel.org/linux-raid/20250817172710.4892-1-k@mgml.me/
v1: https://lore.kernel.org/linux-raid/20250812090119.153697-1-k@mgml.me/

A failfast bio, for example in the case of nvme-tcp, bio will fail
immediately if the connection to the target is briefly lost and
the device enters a reconnecting state - even though it would
recover given few seconds. This behavior is by design in failfast.

However, md treats Failfast IO failures as fatal,
potentially marking the array as MD_BROKEN when a connection is lost.

For example, if an initiator - that is, a machine loading the md
module - loses all connections briefly, the array is marked
as MD_BROKEN, preventing subsequent writes.
This is the issue I am currently facing, and which this patch aims to fix.

The 1st patch changes the behavior on MD_FAILFAST IO failures on
the last rdev. The 2nd and 3rd patches modify the pr_crit messages.

Kenta Akagi (3):
  md/raid1,raid10: Do not set MD_BROKEN on failfast io failure
  md/raid1,raid10: Add error message when setting MD_BROKEN
  md/raid1,raid10: Fix: Operation continuing on 0 devices.

 drivers/md/md.c     | 14 +++++++++-----
 drivers/md/md.h     | 13 +++++++------
 drivers/md/raid1.c  | 32 ++++++++++++++++++++++++++------
 drivers/md/raid10.c | 35 ++++++++++++++++++++++++++++-------
 4 files changed, 70 insertions(+), 24 deletions(-)

-- 
2.50.1

