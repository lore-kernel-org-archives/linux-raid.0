Received: from www5210.sakura.ne.jp (www5210.sakura.ne.jp [133.167.8.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4122B2E973B;
	Tue, 12 Aug 2025 09:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=133.167.8.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754991820; cv=none; b=nBo+wLOnqEsVfBQ6NIGnCpY108voGbLAucNvZUhuAAeamDwQWQ5w2ArhLiBE7RJ9E7yfRtuFEy4JTHpwK32bfiMCsKlcDYbGTM9nmYkwui8c5ss6OlLNP5dZO67ylr7CkvvizjDN89JC06jo+bOjoFwAZiYb8WbC5xX3qvzDCdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754991820; c=relaxed/simple;
	bh=CToGfzbCXrZf0RZFLdJeWgPXCbaCfQB2JIeTz3bcaVU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZrjfjQQH7nG9G7y5QQ/VlJyrCMZTlxJLVuHOjVMf9rVpd8fuNJ8Sh5uDvzzV1Qo+EbxeQxgtWhR7kiRBmgcS4SViJmONVkyomy+7zuvD6w8ye4HIFrCK2KNurly/PyJxcn/dgeLGhR6pJEwleZF5JkJCuSHrCJ6eEeqHL8SkpU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mgml.me; spf=pass smtp.mailfrom=mgml.me; dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b=USj/UIYG; arc=none smtp.client-ip=133.167.8.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b="USj/UIYG"
Received: from fedora (p3671070-ipxg00g01tokaisakaetozai.aichi.ocn.ne.jp [153.172.176.70])
	(authenticated bits=0)
	by www5210.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 57C91Z2P059440
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Tue, 12 Aug 2025 18:01:37 +0900 (JST)
	(envelope-from k@mgml.me)
DKIM-Signature: a=rsa-sha256; bh=saqQ1dvGdvKJQP638fHOvs1Wmr2wZcZehtTp6FimBbM=;
        c=relaxed/relaxed; d=mgml.me;
        h=From:To:Subject:Date:Message-ID;
        s=rs20250315; t=1754989297; v=1;
        b=USj/UIYGE9RJ3CCNbGU74Zoa5eTqH5hjlGmTMcLohYbIYpLuXxhKwW2b0oif2bL5
         NmDtSUCM9/7xPTSKglIdzWaGNNz6UnD1HmtvWNk/Z/dR1Q+0GFE2wagABzqVGCgH
         1TWeJGWMydAl0NxjOF/f3po6QXUEkrs6setjvjkOwhOoPAm7hI6b6xHQfdDb7pCX
         dNGA2QU1l4cpHcj6hG4M53a2ZLOfz40DiVqSBlM+prgo2SJYGtWMNC1cZmMJFYig
         P5LLaBZ/3P15iKLJ7gn9lNwE1AlV1vfLZKriF81F7lg5CKoHauSVEdmZkrQ3Fhzs
         P7XGNW+1y1pLhneu0rEBjg==
From: Kenta Akagi <k@mgml.me>
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
        Mariusz Tkaczyk <mtkaczyk@kernel.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kenta Akagi <k@mgml.me>
Subject: [PATCH] md/raid1,raid10: don't broken array on failfast metadata write fails
Date: Tue, 12 Aug 2025 18:01:19 +0900
Message-ID: <20250812090119.153697-1-k@mgml.me>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It is not intended for the array to fail when a metadata write with
MD_FAILFAST fails.
After commit 9631abdbf406 ("md: Set MD_BROKEN for RAID1 and RAID10"),
when md_error is called on the last device in RAID1/10,
the MD_BROKEN flag is set on the array.
Because of this, a failfast metadata write failure will
make the array "broken" state.

If rdev is not Faulty even after calling md_error,
the rdev is the last device, and there is nothing except
MD_BROKEN that prevents writes to the array.
Therefore, by clearing MD_BROKEN, the array will not become
"broken" after a failfast metadata write failure.

Fixes: 9631abdbf406 ("md: Set MD_BROKEN for RAID1 and RAID10")
Signed-off-by: Kenta Akagi <k@mgml.me>
---
 drivers/md/md.c | 1 +
 drivers/md/md.h | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index ac85ec73a409..3ec4abf02fa0 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1002,6 +1002,7 @@ static void super_written(struct bio *bio)
 		md_error(mddev, rdev);
 		if (!test_bit(Faulty, &rdev->flags)
 		    && (bio->bi_opf & MD_FAILFAST)) {
+			clear_bit(MD_BROKEN, &mddev->flags);
 			set_bit(MD_SB_NEED_REWRITE, &mddev->sb_flags);
 			set_bit(LastDev, &rdev->flags);
 		}
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 51af29a03079..2f87bcc5d834 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -332,7 +332,7 @@ struct md_cluster_operations;
  *			       resync lock, need to release the lock.
  * @MD_FAILFAST_SUPPORTED: Using MD_FAILFAST on metadata writes is supported as
  *			    calls to md_error() will never cause the array to
- *			    become failed.
+ *			    become failed while fail_last_dev is not set.
  * @MD_HAS_PPL:  The raid array has PPL feature set.
  * @MD_HAS_MULTIPLE_PPLS: The raid array has multiple PPLs feature set.
  * @MD_NOT_READY: do_md_run() is active, so 'array_state', ust not report that
-- 
2.50.1

