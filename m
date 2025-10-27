Received: from www5210.sakura.ne.jp (www5210.sakura.ne.jp [133.167.8.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD543090D5
	for <linux-raid@vger.kernel.org>; Mon, 27 Oct 2025 15:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=133.167.8.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761577517; cv=none; b=fWzDI23vLFLPRmAOMPCY0Fyki02wjcIdxqGvtxQX38SPFWqcUe8SYC0qngXFSwTmkCiqTO+KT1RV3vkABI4HIZXrU8DvzpYoTjHOzcrV0zzQ2PrYK5a2+F+auoduHBFxXrKAkdO6+IOm1HyvZj7Y3IJkD94VT/roOFuk+ARoRTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761577517; c=relaxed/simple;
	bh=3+XA20Rc9EnFrgx6YdQVGbAivbvGC2wj1PaFAMIRAV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AGgZnnpO8Hze8TY8qzL+fXet4onjmtS1iBwOHSJg8OSrmm0bgPyOqkavDKu9W92YdUrt6LNP0tdumsf6bIq/WX/5+cC+4Xbqs8L8v8cMeDVNpt/4f9HekmUYxrQxLdeXMYLbnZ4B34Hj4SOiL3Mc5/O9ADILPdaAkWW+hm5Kxog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me; spf=pass smtp.mailfrom=mgml.me; dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b=iVBobUcQ; arc=none smtp.client-ip=133.167.8.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b="iVBobUcQ"
Received: from fedora (p3796170-ipxg00h01tokaisakaetozai.aichi.ocn.ne.jp [180.53.173.170])
	(authenticated bits=0)
	by www5210.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 59RF4hAi090988
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Tue, 28 Oct 2025 00:04:46 +0900 (JST)
	(envelope-from k@mgml.me)
DKIM-Signature: a=rsa-sha256; bh=sx1Lo0j+on85gzn1GqHUcemMoQBFiCbVd0Zd9bIDEUs=;
        c=relaxed/relaxed; d=mgml.me;
        h=From:To:Subject:Date:Message-ID;
        s=rs20250315; t=1761577486; v=1;
        b=iVBobUcQ+2uPz46F4RrLCxtc/+KUanSfiEft5Hn3jP3Fn2evfGKQBq+/4GIdJjQX
         8R3E1b1pzd9ygS2gWl6ugnE5MbIz6TKS5xZgMur2S1W8TOJ1zsYXv/VNiuLaWrhg
         LAfHBs8UgQUN2Cum1Z7KJ/GCyoGlubVUSErMEEIF2u+kxWaDbv18nuSWqbdgHSmb
         2/rjVop/R+A49Kg+sxuVro2VUWtJ8C6E3Y8yFhIQepx0dGgB2odq/3/8CVG3g+/v
         ELYFmdhJVsRzo4DoMAikPHbVZkeRUrX6cTOAWFgej7TDFbh8Cn5bs0CdBgvqPF2v
         6uzGWfU50BHcThTF5u/oEQ==
From: Kenta Akagi <k@mgml.me>
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>,
        Shaohua Li <shli@fb.com>, Mariusz Tkaczyk <mtkaczyk@kernel.org>,
        Guoqing Jiang <jgq516@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kenta Akagi <k@mgml.me>
Subject: [PATCH v5 08/16] md/raid10: refactor handle_read_error()
Date: Tue, 28 Oct 2025 00:04:25 +0900
Message-ID: <20251027150433.18193-9-k@mgml.me>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251027150433.18193-1-k@mgml.me>
References: <20251027150433.18193-1-k@mgml.me>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For the failfast bio feature, the behavior of handle_read_error() will
be changed in a subsequent commit, but refactor it first.

This commit only refactors the code without functional changes. A
subsequent commit will replace md_error() with md_cond_error()
to implement proper failfast error handling.

Signed-off-by: Kenta Akagi <k@mgml.me>
---
 drivers/md/raid10.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 68dbab7b360b..87468113e31a 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2873,14 +2873,15 @@ static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
 	bio_put(bio);
 	r10_bio->devs[slot].bio = NULL;
 
-	if (mddev->ro)
+	if (mddev->ro) {
 		r10_bio->devs[slot].bio = IO_BLOCKED;
-	else if (!test_bit(FailFast, &rdev->flags)) {
+	} else if (test_bit(FailFast, &rdev->flags)) {
+		md_error(mddev, rdev);
+	} else {
 		freeze_array(conf, 1);
 		fix_read_error(conf, mddev, r10_bio);
 		unfreeze_array(conf);
-	} else
-		md_error(mddev, rdev);
+	}
 
 	rdev_dec_pending(rdev, mddev);
 	r10_bio->state = 0;
-- 
2.50.1

