Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D83A1E8855;
	Sat, 24 May 2025 06:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748067504; cv=none; b=MEYUtbwGWHaMYD+Rv97X8x5eyjKfNsc1+/N7Z2O37OaYBP1eZO4w1M0z+MewxDj51paLDQuq5zOw2LJImeyW9T2E4F8/HXhhO3Co7/SNdjTZJU+s/+JuGlwt/AZxQQjcmQVByYiOP9i9Ut1xCwkHJO+xm2mJDU6WLv68rELDTks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748067504; c=relaxed/simple;
	bh=cxtzLhTF/bOh23v8p+80tl3W0m+lHooI/GPXGrzVuqI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jvJPpHz/ks/twHUS3Cp5kzUAu05tq6nQ3Cf23PmVLA27EETcYrfl7z8TZqCgNqZPNlP0jG7bfnBlsS+OH4QJrM7S9CPLWil4LLOrnoQQ42p0tQ7MU7+PQM3uiIYZlicwz+6CrzG3V/kZhzQjYNvCJg+ch/TiF0Q6U8ibnEOzQsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4b4BfH3kZ0z4f3jqb;
	Sat, 24 May 2025 14:17:59 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 7DA0F1A194E;
	Sat, 24 May 2025 14:18:19 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCnCl+dZDFo3etkNQ--.42979S20;
	Sat, 24 May 2025 14:18:19 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: hch@lst.de,
	xni@redhat.com,
	colyli@kernel.org,
	song@kernel.org,
	yukuai3@huawei.com
Cc: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	johnny.chenyi@huawei.com
Subject: [PATCH 16/23] md/md-llbitmap: implement bit state machine
Date: Sat, 24 May 2025 14:13:13 +0800
Message-Id: <20250524061320.370630-17-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250524061320.370630-1-yukuai1@huaweicloud.com>
References: <20250524061320.370630-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnCl+dZDFo3etkNQ--.42979S20
X-Coremail-Antispam: 1UD129KBjvJXoWxWw1fArWDKw4DWFyUKry3urg_yoW7JFW5pw
	sxZrnxGrs8JF4xX3y7ta4xtF95Kr4kt3sIqF9xA3s5Ww1YyFZIvr1kWFy8J3yUWryFq3WU
	Jan5Cr95GF4UurJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmS14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0JUQFxUUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Each bit is one byte, contain 6 difference state, see llbitmap_state. And
there are total 8 differenct actions, see llbitmap_action, can change
state:

llbitmap state machine: transitions between states

|           | Startwrite | Startsync | Endsync | Abortsync| Reload   | Daemon | Discard   | Stale     |
| --------- | ---------- | --------- | ------- | -------  | -------- | ------ | --------- | --------- |
| Unwritten | Dirty      | x         | x       | x        | x        | x      | x         | x         |
| Clean     | Dirty      | x         | x       | x        | x        | x      | Unwritten | NeedSync  |
| Dirty     | x          | x         | x       | x        | NeedSync | Clean  | Unwritten | NeedSync  |
| NeedSync  | x          | Syncing   | x       | x        | x        | x      | Unwritten | x         |
| Syncing   | x          | Syncing   | Dirty   | NeedSync | NeedSync | x      | Unwritten | NeedSync  |

Typical scenarios:

1) Create new array
All bits will be set to Unwritten by default, if --assume-clean is set,
All bits will be set to Clean instead.

2) write data, raid1/raid10 have full copy of data, while raid456 donen't and
rely on xor data

2.1) write new data to raid1/raid10:
Unwritten --StartWrite--> Dirty

2.2) write new data to raid456:
Unwritten --StartWrite--> NeedSync

Because the initial recover for raid456 is skipped, the xor data is not build
yet, the bit must set to NeedSync first and after lazy initial recover is
finished, the bit will finially set to Dirty(see 5.1 and 5.4);

2.3) cover write
Clean --StartWrite--> Dirty

3) daemon, if the array is not degraded:
Dirty --Daemon--> Clean

For degraded array, the Dirty bit will never be cleared, prevent full disk
recovery while readding a removed disk.

4) discard
{Clean, Dirty, NeedSync, Syncing} --Discard--> Unwritten

5) resync and recover

5.1) common process
NeedSync --Startsync--> Syncing --Endsync--> Dirty --Daemon--> Clean

5.2) resync after power failure
Dirty --Reload--> NeedSync

5.3) recover while replacing with a new disk
By default, the old bitmap framework will recover all data, and llbitmap
implement this by a new helper llbitmap_skip_sync_blocks:

skip recover for bits other than dirty or clean;

5.4) lazy initial recover for raid5:
By default, the old bitmap framework will only allow new recover when there
are spares(new disk), a new recovery flag MD_RECOVERY_LAZY_RECOVER is add
to perform raid456 lazy recover for set bits(from 2.2).

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-llbitmap.c | 83 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 83 insertions(+)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index 1a01b6777527..f782f092ab5d 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -568,4 +568,87 @@ static int llbitmap_cache_pages(struct llbitmap *llbitmap)
 	return 0;
 }
 
+static void llbitmap_init_state(struct llbitmap *llbitmap)
+{
+	enum llbitmap_state state = BitUnwritten;
+	unsigned long i;
+
+	if (test_and_clear_bit(BITMAP_CLEAN, &llbitmap->flags))
+		state = BitClean;
+
+	for (i = 0; i < llbitmap->chunks; i++)
+		llbitmap_write(llbitmap, state, i);
+}
+
+/* The return value is only used from resync, where @start == @end. */
+static enum llbitmap_state llbitmap_state_machine(struct llbitmap *llbitmap,
+						  unsigned long start,
+						  unsigned long end,
+						  enum llbitmap_action action)
+{
+	struct mddev *mddev = llbitmap->mddev;
+	enum llbitmap_state state = BitNone;
+	bool need_resync = false;
+	bool need_recovery = false;
+
+	if (test_bit(BITMAP_WRITE_ERROR, &llbitmap->flags))
+		return BitNone;
+
+	if (action == BitmapActionInit) {
+		llbitmap_init_state(llbitmap);
+		return BitNone;
+	}
+
+	while (start <= end) {
+		enum llbitmap_state c = llbitmap_read(llbitmap, start);
+
+		if (c < 0 || c >= nr_llbitmap_state) {
+			pr_err("%s: invalid bit %lu state %d action %d, forcing resync\n",
+			       __func__, start, c, action);
+			state = BitNeedSync;
+			goto write_bitmap;
+		}
+
+		if (c == BitNeedSync)
+			need_resync = true;
+
+		state = state_machine[c][action];
+		if (state == BitNone) {
+			start++;
+			continue;
+		}
+
+write_bitmap:
+		/* Delay raid456 initial recovery to first write. */
+		if (c == BitUnwritten && state == BitDirty &&
+		    action == BitmapActionStartwrite && raid_is_456(mddev)) {
+			state = BitNeedSync;
+			need_recovery = true;
+		}
+
+		llbitmap_write(llbitmap, state, start);
+
+		if (state == BitNeedSync)
+			need_resync = true;
+		else if (state == BitDirty &&
+			 !timer_pending(&llbitmap->pending_timer))
+			mod_timer(&llbitmap->pending_timer,
+				  jiffies + mddev->bitmap_info.daemon_sleep * HZ);
+
+		start++;
+	}
+
+	if (need_recovery) {
+		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+		set_bit(MD_RECOVERY_LAZY_RECOVER, &mddev->recovery);
+		md_wakeup_thread(mddev->thread);
+	} else if (need_resync) {
+		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+		set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
+		md_wakeup_thread(mddev->thread);
+	}
+
+	return state;
+}
+
 #endif /* CONFIG_MD_LLBITMAP */
-- 
2.39.2

