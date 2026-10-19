Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A7653264F9;
	Mon, 19 Oct 2026 01:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792372550; cv=none; b=N4RDo0NAQDc+LvJoKcV6m8JMMUnSk+94m3NA8u7hPWx5nJbLzB9Ntj/Y5SRUjV7O8tXzldEUcqR09OOA+3p7/z1Wkp17EptgAHRo9dEqIj1T7DE8r+lLDJKTgi4h68UHWB9q64H+PT/9oQPq96fIoU42i8ZI6Cwb7Wig+MKKYNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792372550; c=relaxed/simple;
	bh=sOVBp+DcbI5xWQzbjbK1Mmn/uO63rqpVfwoXlg6wHxI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OAc6/Qsrgw4ftuBP6YEafDDQYkRotMCUoO2zxOPozQflyVHjPXvik+IURmqhwjqFeRnpQUb2OJD4FngbWn25zX5Q0z9MKZ7JhhPqBjZ1YOGnI2z7ivgUouAgR25euyfBNH56iL6iM3ZgzUAqijDGy1ZVbgF4WIVcHuS9ARdsn9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4j7HdT1sk4zYQtw7;
	Mon, 19 Oct 2026 09:14:37 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 0F8034056E;
	Mon, 19 Oct 2026 09:15:38 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgBXkO85b9VqI9LoAw--.23742S4;
	Mon, 19 Oct 2026 09:15:37 +0800 (CST)
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
Subject: [PATCH V2 0/6] md: fix takeover failure handling and raid0 size calculation
Date: Mon, 19 Oct 2026 09:08:21 +0800
Message-ID: <20261019010827.2922617-1-wozizhi@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBXkO85b9VqI9LoAw--.23742S4
X-Coremail-Antispam: 1UD129KBjvJXoW7uFyrZF17Wr17AF4UWr47XFb_yoW8GrWkpa
	nxt3W5Zw4rG34fZwnIk34UAayrtw18G3WUtF9xJw4rWF9rZFy8CrWDGrW5GayDX3sYqa4Y
	qw1DXrnYkF4DK37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUk0b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6x
	kF7I0E14v26F4UJVW0owAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAq
	x4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6x
	CaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxkF7I0En4kS14v26r1q6r43MxAIw28I
	cxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2
	IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI
	42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42
	IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280
	aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUrsqXDUUUU
X-CM-SenderInfo: pzr2x6tkl6x35dzhxuhorxvhhfrp/

From: Zizhi Wo <wozizhi@huawei.com>

Patches 1-3 fix the inconsistent mddev state left behind when a takeover
fails.

Patch 4 rejects a raid0 takeover whose zones cannot cover the capacity the
gendisk advertises, fixing a syzbot BUG() in find_zone().

Patch 5 factors out the member-size rounding. Patch 6 uses it in
raid0_size(), where the power-of-2 mask is not a round down for a
non-power-of-2 chunk.

Changes since v1:
 - Added 3 patches fixing the inconsistent mddev state left behind by a
   failed takeover in raid0, raid10 and raid5.
 - Patch 4: expanded the commit message with a paragraph addressing the
   issue previously reported by Sashiko.

v1:
https://lore.kernel.org/all/20261017005802.2212102-1-wozizhi@huaweicloud.com/

Zizhi Wo (6):
  md/raid0: don't leave mddev in an inconsistent state when takeover
    fails
  md/raid10: don't leave mddev in an inconsistent state when takeover
    fails
  md/raid5: don't leave mddev in an inconsistent state when takeover
    fails
  md/raid0: reject a takeover whose zones cannot cover the array
  md/raid0: factor out raid0_member_sectors()
  md/raid0: round member size in raid0_size() with sector_div()

 drivers/md/raid0.c  | 84 +++++++++++++++++++++++++++++++++++----------
 drivers/md/raid10.c | 11 ++++--
 drivers/md/raid5.c  | 13 ++++---
 3 files changed, 84 insertions(+), 24 deletions(-)

-- 
2.52.0

