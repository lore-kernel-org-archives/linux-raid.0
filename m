Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3C81B040B;
	Wed, 18 Dec 2024 12:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734524439; cv=none; b=Fg/zMKXnjeb6UZYJ57ohlzu0l0v3rL/MVSdlygRrqYGPkVm7xZ+EbjyaQ2rOWsxmPDqQ8hHKVznGvYdldu3pHWAciOAaWRjNbg5kAFNHygy5kw2rNhoiuckcLPMLRGLpEY9oHfdrVbCjsftBi/eoq2GPMQNNPetlc0GbmPYjLQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734524439; c=relaxed/simple;
	bh=5E8AP3KlgUjBu3Ysxtpaw5IJbxNeBYNlegiBXIWZ4Hc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BcRaOYYBBmK6vkmKTVWihQyTA5GLQyGBW709kKOzcmzF37FxxEqwS0mNNWIWHbQavakPFFhDnqagQR5VdcM+ESJeQjdkMGcToQ6n/jDDFUP0/u3t82aXKhy+S9wRHNUXchLUfqwK++73mI8cJXnhFK4Y/GJmEXdajPXqwtZhdFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jMJs06Jx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jMJs06Jx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B906C4CECE;
	Wed, 18 Dec 2024 12:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734524439;
	bh=5E8AP3KlgUjBu3Ysxtpaw5IJbxNeBYNlegiBXIWZ4Hc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jMJs06JxFgg0qUKpuaSsvV7xE0s1luFtZnfa3Q+eNxCK0EntEg/rw4ADOKPMF85If
	 IucwaIPX5IMszj+plymA6et/ECFBcMmO13lQindAf8t+2+YzlBhuOrxJs1BM5NUq/1
	 P/RwNo6b4nMYAyTfRGLuWnrJ+RN55XlhxGcGxY+9VZ9oDfKx7GaFXtJnyqK9k9I/Ml
	 tL1PgyFDhYWv1yMfiI0TDjvc1XZo2sK5Wc/Whi+ihORF540suvuDqrbOmk6TR/5qJI
	 fYHd2A57H60iPW+Elsm/+xwesKs7OG2Y3FegOE2CnQSBNxUqsXUfaYWdJvzAxO9F/e
	 Ti8CcwnbUo5rA==
From: yukuai@kernel.org
To: song@kernel.org,
	yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yi.zhang@hauwei.com,
	yangerkun@huawei.com,
	Xiao Ni <xni@redhat.com>,
	Yu Kuai <yukuai@kernel.org>
Subject: [PATCH v2 md-6.14 3/5] md: add a new callback pers->bitmap_sector()
Date: Wed, 18 Dec 2024 20:17:43 +0800
Message-ID: <20241218121745.2459-4-yukuai@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241218121745.2459-1-yukuai@kernel.org>
References: <20241218121745.2459-1-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai3@huawei.com>

This callback will be used in raid5 to convert io ranges from array to
bitmap.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Xiao Ni <xni@redhat.com>
Signed-off-by: Yu Kuai <yukuai@kernel.org>
---
 drivers/md/md.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/md.h b/drivers/md/md.h
index 4ba93af36126..de6dadb9a40b 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -746,6 +746,9 @@ struct md_personality
 	void *(*takeover) (struct mddev *mddev);
 	/* Changes the consistency policy of an active array. */
 	int (*change_consistency_policy)(struct mddev *mddev, const char *buf);
+	/* convert io ranges from array to bitmap */
+	void (*bitmap_sector)(struct mddev *mddev, sector_t *offset,
+			      unsigned long *sectors);
 };
 
 struct md_sysfs_entry {
-- 
2.43.0

