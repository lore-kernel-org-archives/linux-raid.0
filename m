Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4439420D4FC;
	Sat, 17 Oct 2026 01:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792199112; cv=none; b=qoHFo6AfMKIBHXVEsbcW/+SaBYkQFYRcCLxIXV3u3D8VchWtHMwIW7WIX0iQXnmWK8nB20Tep1PwJE44Tz/jjm53TvObER62N+kOwVZSgEB+esAs/FzaufBfcQMcgL9g/wxA8KhyDCxgnDaMi375r+wanLZXbe0zl0xHpk1H0iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792199112; c=relaxed/simple;
	bh=1N7hwwpAV6MsP5684zFn7cBxCubixNxi9GkyjzdKC6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CrcMMM8RuNXa9ZkeXaK3HA2sg3Uy2Syv/eR29XZwGVu5yVU8p+lIgCqmnwNddESb6lJiY8C1ux8k56ftuoVS21WfNfvxvHSz2SLZyaiwmtx80qV4qORuuetyU0uM1Qiwz1z9+vLKVbu/RzB9QcxZ0acvb0/IxOznXZk6on3bsQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4j63WM2K29zKHMNg;
	Sat, 17 Oct 2026 09:05:03 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 58F1140578;
	Sat, 17 Oct 2026 09:05:07 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgAnZvXBydJqADTpAg--.35962S4;
	Sat, 17 Oct 2026 09:05:07 +0800 (CST)
From: Zizhi Wo <wozizhi@huaweicloud.com>
To: song@kernel.org,
	yukuai@fygo.io,
	magiclinan@didiglobal.com,
	xiao@kernel.org,
	linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	yangerkun@huawei.com,
	chengzhihao1@huawei.com,
	wozizhi@huawei.com
Subject: [PATCH 0/3] md/raid0: fix a takeover BUG and tidy member-size rounding
Date: Sat, 17 Oct 2026 08:57:59 +0800
Message-ID: <20261017005802.2212102-1-wozizhi@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAnZvXBydJqADTpAg--.35962S4
X-Coremail-Antispam: 1UD129KBjvdXoWrZF1UAr1Utw4fGry7Cr4Uurg_yoWfWrcEyr
	yrtryrWF48JF1ava43ZrsrWFZ7JFW8Cr1kZ3WUKr48Ja43Xws2qF1jqry09r18K390qrn8
	J34Fqw4xCwn2gjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb7xYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7
	CjxVAFwI0_Cr1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02
	F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4I
	kC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IY
	c2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s
	026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF
	0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0x
	vE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv
	6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07UAwIDUUUUU=
X-CM-SenderInfo: pzr2x6tkl6x35dzhxuhorxvhhfrp/

From: Zizhi Wo <wozizhi@huawei.com>

Patch 1 fixes a syzbot BUG() in find_zone(): a takeover can build strip
zones that cover less than the array still advertises, and I/O for the tail
reaches find_zone(), which cannot map it. Reject such a takeover up front.

Patch 2 factors out the "member size rounded down to a chunk" computation.

Patch 3 uses it in raid0_size() in place of a power-of-2 mask, which is not
a round down for a non-power-of-2 chunk, to consistent with how
create_strip_zones() already rounds the members when building the zones.

Zizhi Wo (3):
  md/raid0: reject a takeover whose zones cannot cover the array
  md/raid0: factor out raid0_member_sectors()
  md/raid0: round member size in raid0_size() with sector_div()

 drivers/md/raid0.c | 48 +++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 43 insertions(+), 5 deletions(-)

-- 
2.52.0

