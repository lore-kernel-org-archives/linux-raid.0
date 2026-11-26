Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795680539;
	b=hKzpRCIXpp3ctcRwzdqitv4UAOwe1PaX7Ex+5dXT+gxYA8U3eZ6k44nAOWfneznhL4HZ
	 ZKW2+C4gYJq3MAo/D9QW9WAaPs+DK5Ui6HFxqSjUtjASFKKh8Zcl+Q4PDh6q8emqvgtxi
	 dwSYqSMs9LxuzhJs9FMnHsl6NKXvs9Te2qHO7aXxldGmHKrN9jxmfUDsQ17tvmkWDLqV7
	 H3ph1tPkGo3fQU6o5ohcZFy9TZ/6UcpkAQItOUqhX9rTC8ZjZPtKq1EJPgDkdzyDE/yaw
	 u7zQ336g/5ZdsznewvWr5ehlkIeH5N2nCO305F/t2Jx1FCChMQeUaODhnIHEs/Xm+Hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795680539;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-CM-SenderInfo;
	bh=zvkdkK0+UwOlOZIjm7Q+EAuYMPIYTFgsQa7NN8gnmiM=;
	b=zk4QtxYMWZifO7Am3/Pc7PYQiZzSlbYBI4OGup88VrFMIhS1G5rDNUY0016dWVHjfW6w
	 pdyPJJ+7D2IC+3o6KLu0tQIQ96mJ4ABMQBQ7KS7kBZE3IHnxybr/5xQJ3+sbmEivXbbkt
	 BAFEE1u/t/b3eZStH5La2OXPHrXcOa1VmQyU/t8bjrqnLPLP36uqw6eob03CJya53mH5T
	 VqljjcMG+jD/JoW98WaoQHvHuP7ldwfh8xSQCQ0iCJSNeNwQhMGNmawwu0OOzhc83aAN7
	 19QCTiavG6zkwZ9KwozoECeKjR+xxqheXDWvSZHR17Q5HD0SEcO/yJlxtwh1oAevYqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=eJIOUDMz;
	arc=none smtp.remote-ip=117.135.210.5
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A6C606A31C;
	Thu, 26 Nov 2026 08:08:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A3A6C606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=eJIOUDMz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=zv
	kdkK0+UwOlOZIjm7Q+EAuYMPIYTFgsQa7NN8gnmiM=; b=eJIOUDMzLerkmKxxO+
	ks8nS74/iRGMHFpummO0hIHxrTxpyviBje+qQS0fls68FPLs2DbV1OqZ77fTeDUT
	lE9WfWyS1aQHWgca2/8Pqqr9/dBbUsUlPuadZqZ+GbHOiAqfNiIhmVza7mTfZR9t
	VjUyFVX26L1rUn/o9udA6jYZI=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wD3Vxr36AdrXbESKg--.46527S2;
	Thu, 26 Nov 2026 16:08:24 +0800 (CST)
From: "Li Youhong" <dayou5941@163.com>
To: song@kernel.org,
	yukuai@fygo.io
Cc: magiclinan@didiglobal.com,
	xiao@kernel.org,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Li Youhong <liyouhong@kylinos.cn>
Subject: [PATCH v6 0/2] md: fix sync_work vs array teardown races
Date: Thu, 26 Nov 2026 16:08:21 +0800
Message-Id: <20261126080821.144057-1-dayou5941@163.com>
X-Mailer: git-send-email 2.25.1
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3Vxr36AdrXbESKg--.46527S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxZF15AF4xZryfJr43CFyUZFb_yoW5GF4xpr
	WYqry5Gw4DJw4IvFsrK3W0va4rAw1rX398Xr1fG3WfC3yFyr1UXFW8K3Wj9FyDuFyrA3s7
	ZF4UJFZaka4qqFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07joZXOUUUUU=
X-CM-SenderInfo: 5gd103ivzuiqqrwthudrp/xtbC3hkVw2sH6PmBhgAA3r

From: Li Youhong <liyouhong@kylinos.cn>

dm-raid tears down arrays via md_stop(), which cleared mddev->pers
without waiting for previously queued sync_work. That work could
then call remove_spares() with pers == NULL, or keep using mddev
after raid_dtr() frees it.

do_md_stop()/md_stop_writes() already call stop_sync_thread() before
teardown. md_stop() needs the same wait, plus a few related holes
around work_busy(), MD_RECOVERY_FROZEN on the read-only path, and
event_work on the raid_ctr() error path.

This series splits the previous combined fix so the work_pending ->
work_busy change can land on its own.

Li Youhong (2):
  md: use work_busy() to flush sync_work in stop_sync_thread()
  md: fix sync_work vs array teardown races

 drivers/md/dm-raid.c |  7 +++++++
 drivers/md/md.c      | 39 +++++++++++++++++++++++++++++----------
 2 files changed, 36 insertions(+), 10 deletions(-)

---
v6:
- Split into two patches per review:
  1/2: only replace work_pending() with work_busy() when flushing
       sync_work in stop_sync_thread(); Fixes: f52f5c71f3d4.
  2/2: remaining changes (md_stop wait, idle early-return gated by
       work_busy(), INTR only when RUNNING, RO FROZEN check,
       flush event_work on raid_ctr() error path).
- v5: https://lore.kernel.org/linux-raid/20261112013523.120428-1-dayou5941@163.com/

v5:
- Restore idle early-return in stop_sync_thread() gated by work_busy(),
  so locked callers keep reconfig_mutex and do not race with do_md_run().
- Flush event_work before raid_set_free() on the raid_ctr error path
  (md_stop() may drop the mutex and let md_reap queue it).
- v4: https://lore.kernel.org/linux-raid/20261111015027.4029184-1-dayou5941@163.com

v4:
- Always flush_work(&sync_work) in stop_sync_thread(); do not delay
  clearing MD_RECOVERY_RUNNING (that can drop MD_RECOVERY_NEEDED via
  md_check_recovery, and does not cover the successful sync_thread
  registration path).
- v3: https://lore.kernel.org/linux-raid/20261110063045.912703-1-dayou5941@163.com

v3:
- Honour MD_RECOVERY_FROZEN before queueing sync_work on the
  read-only md_check_recovery() path.
- (superseded) delayed MD_RECOVERY_RUNNING clear on not_running.
- v2: https://lore.kernel.org/linux-raid/20261109023055.2164333-1-dayou5941@163.com

v2:
- Drop the pers NULL check in md_start_sync().
- Call stop_sync_thread() from md_stop() before clearing pers,
  matching do_md_stop()/md_stop_writes().
- v1: https://lore.kernel.org/linux-raid/20261106083543.249267-1-dayou5941@163.com

