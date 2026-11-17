Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794890947;
	b=4m6Fo8ScsTkvCXhFA+1MHwMdGx2skjQt9J/P1EBrdygYr90uV5q3fgbrm1tYDeBQGQx3
	 QP8NE5SUm3LStoB21s6Ub6ox5s+4ISFxDmFZ3iy0vkxEeb5zHeQQebmkmMMsgXiqZ3Vkr
	 rtxrWdxKcp/0ehePKy5opVzVzuB6vzNFvcmue44aspDOkZ5/KQTT4dnpY/cXMXekdUtud
	 wCOGlYb1rB1pWyrPC8put2CPF7PJ4xoplMzhLGkh5znaet8ow/aw4DvlBmAmkXPrNqIeK
	 BttLYs+0+JZfsPApjayjtC2zfantXpUiCqatiu5UEGWxDhUobtFjHK0Tm1KA0sy5bag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794890947;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:From:
	 To:Cc:Subject:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=86CkpXuwpEyCMVvw149Ca3RuC1QKVovO1J/0AhH0nrA=;
	b=bPHHu8pAZxDqT84yNrHJ+exh5DyCrfbDIkMbZYD+b1tSJL2Xmnu7Ks/cuOKy3ccXkfYJ
	 f006/gTHdsRH3T8r8sjWf1wrM8K6Yl9WGsju4RhFTizm+76Jx5xf372DzsY5U9UDTwr6f
	 gOvXDeTtBofuo7ziJU8vMLZXY7hTTBP7I7BqcosJaYRiqwqeEuGkUzW5ZrTE8uF9fuYbM
	 z9NoOaSXUGZFtJIAHXDcSWO/XxOUYPpma8f1m1Kash2QQWbUi6EHK968oraYY9mVo9Yao
	 jI8VRVoxl+WExq0KyLLycWph5ZKMc6siU/9t6uwwvapgErWFgk88TxkFpj0XviWQTsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=S3HpShUJ;
	arc=none smtp.remote-ip=209.85.214.170
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF3A2606A329
	for <linux-raid@vger.kernel.org>; Tue, 17 Nov 2026 04:49:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EF3A2606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=S3HpShUJ
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2e977109392so24977885ad.0
        for <linux-raid@vger.kernel.org>; Mon, 16 Nov 2026 20:49:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794890946; x=1795495746; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:content-type:subject:cc:to
         :from:date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=86CkpXuwpEyCMVvw149Ca3RuC1QKVovO1J/0AhH0nrA=;
        b=S3HpShUJlch1Aw312O3ajiilNLZWKgLtK5r+0I+2k1y6nOKzfWft4gD+sHcSXTb4WZ
         ngLfADY1inopAwaSdp6UrhqlgOjyLKPrhIPPti1WoGgBogeVmyv+YOf30f96eNqN7s5o
         d0Z5/e0/RBFNYq5TLtj8UN1cHJR/q5jPPkDhRvwh6FDZdBe7cnXboaLFv+HZXfuP14DE
         6zlcVVqllJIAIHVTUkasz+Am8hKYYU6nnxJKflAS3f+Hu8Td9taDl6j2zEuMHHZF59IB
         tLWOvVlad8yGECxt28hrGX9wawMJUidT4DG2jZaGfkJMrS1P8mc6ToxdcNTo4zD4tlwq
         HKjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794890946; x=1795495746;
        h=mime-version:content-transfer-encoding:content-type:subject:cc:to
         :from:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=86CkpXuwpEyCMVvw149Ca3RuC1QKVovO1J/0AhH0nrA=;
        b=00D3ikaJ5Bxz045tkvlGtw+ZsHq2yBR9fEKlHneSP8MjxckKoRcxgre/nMDwwWeQg9
         Cdj0s8pBp4h/hih2EHsuKUVI9Yhq7GIv83Ue+qkdtwAW5x9BmyHEBeKxUv7CxGMeM7qc
         r/Bh4TtFAynMSy1zEHiNABq1Vl02YzbcmhLUnuu/gqKFFL1o6VdckHr7p1KV0akt0SfM
         9M+n9nTjShX66XXJfnr5CjlDTDVcqsVK49n1+kzCz7AVZmH8fe0RgfMQtW23S3g6+XTw
         jbHK70yscIS+AbVFxI6pClfgGM3s92EXf3MvTgqymXlKbAi2lsKMA3n3YmWnuRn+KbCe
         4HCQ==
X-Gm-Message-State: APuU4Z94K3WGsQjcUxL89LYptqXcgnH0nx+dtu4MW/Ih1eQfwYLnTFAr
	iTN2kH0mKee5KOxMRkyf32xoq+leTI0D+qgm06/S+P4FUEvFaKm4lIn1MAwdujjJ
X-Gm-Gg: AZFdTZeBDN/902emCIkVAWo3C8XfK81fSQKSU/v4rRMcjYw+UKZtISIclfgrfNagH0P
	Nis500+mgOt4ma5pi4TMu7v0mTKxZzm1xgEtXXzxGuYZ+EGIDqZMu8t8pOnqD0jflsGrm8CC2PY
	ONmhfsIkq3P/GllNpfLg42spK1+ZuhZjlTVpiuzRN1TyGoj25gCgEpC5obP253qNli0ynyY1Lw8
	37QwmV5suOzGi+q8Bqb33SqXI2PHuJRnWj5n0NlM0FQi9RNrtBF+Z4KUWqLcMGFEsa/x9OVyCQ4
	h/WQhBdwTJjiUlkINAUUMB4BvWrg1oVr39lZIawpO5GqP0D1A52HnCxwJWRCrZnZMJ2tPJJkUpj
	6vJ2lRzA/nfFfRhkUGWhfWt7qWRg4Xmk25WmEUPMqR1/KkwgnJ6HE7ygHKxw4Qyh8I5/ZZCmT5z
	G0zN2yP57wUr4IQvYgWhEcnUfomtE3y8B6zqNlX4MbQ3iRT8pXA8V3M880GRFEbUh5nvcouiI5P
	/QGl5Ppaw4yrgPfjUs15YORepI9iktdpAZsbMc900q2GIhSq4qRbdm8DWCfMbv3kKhnPcOnZQ==
X-Received: by 2002:a17:902:ccca:b0:2e9:5714:6087 with SMTP id d9443c01a7336-2ee0d65ffb2mr120597685ad.5.1794890946089;
        Mon, 16 Nov 2026 20:49:06 -0800 (PST)
Received: from [169.254.42.106] ([113.200.174.22])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2efd7a88a55sm7491235ad.65.2026.11.16.20.49.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 20:49:05 -0800 (PST)
Message-ID: <6afbdcc1.e6d8240f.129280.2aea@mx.google.com>
Date: Mon, 16 Nov 2026 20:49:05 -0800 (PST)
From: Zheng Shuhao <viennaoffh@gmail.com>
To: linux-raid@vger.kernel.org
Cc: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fygo.io>,
 Li Nan <magiclinan@didiglobal.com>, Xiao Ni <xiao@kernel.org>,
 NeilBrown <neilb@suse.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] md: skip superblock validation for nonpersistent arrays
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Hi,

syzbot reported a KASAN slab-out-of-bounds read in
super_90_validate() when adding a journal device to a nonpersistent
0.90-style RAID1 array.

The reproducer creates a nonpersistent RAID1 array with 35 raid slots
and then hot-adds a journal device. Nonpersistent arrays do not load an
on-disk superblock for the new device, but add_bound_rdev() still calls
validate_super() in the journal path.

For 0.90 metadata, super_90_validate() indexes sb->disks using
rdev->desc_nr. With 35 raid slots, this index can exceed the 27
descriptors available in the 0.90 superblock, resulting in an
out-of-bounds read even though there is no persistent superblock to
validate.

Skip validate_super() for nonpersistent arrays, while retaining
hot_add_disk() for both persistent and nonpersistent arrays.

Testing:

- The original syzbot C reproducer triggered KASAN in the baseline
  kernel in 4 of 5 clean runs.
- The patched kernel completed the same reproducer successfully in 3 of
  3 runs without KASAN, BUG, Oops, or kernel panic.
- Both baseline and patched kernels were built with KASAN,
  CONFIG_MD_RAID0, CONFIG_MD_RAID1, CONFIG_MD_RAID10,
  CONFIG_MD_RAID456, CONFIG_MD_LINEAR, and DEBUG_LIST enabled.
- mdadm tests 00raid1, 02r1add, 20raid5journal, and
  24raid456deadlock passed with the patched kernel.
- A baseline-versus-patched run of the remaining targeted mdadm tests
  produced identical results: 4 passed, 10 failed, and 1 skipped on
  each kernel. The common failures are in persistent 0.90 byte-order
  handling and external DDF tests; no KASAN, Oops, BUG, or panic was
  observed.
- 24raid10deadlock passed with CONFIG_FAULT_INJECTION,
  CONFIG_FAIL_MAKE_REQUEST, and CONFIG_FAULT_INJECTION_DEBUG_FS enabled.

Reported-by: syzbot+c5969d7e0a934b384fd6@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c5969d7e0a934b384fd6
Fixes: 87d4d91616e4 ("MD: add journal with array suspended")
Signed-off-by: Zheng Shuhao <viennaoffh@gmail.com>

---
 drivers/md/md.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 680b34a63cb3d..308cc146b0b6c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2992,8 +2992,9 @@ static int add_bound_rdev(struct md_rdev *rdev)
 		 * then added disks for geometry changes,
 		 * and should be added immediately.
 		 */
-		super_types[mddev->major_version].
-			validate_super(mddev, NULL/*freshest*/, rdev);
+		/* Nonpersistent arrays have no on-disk superblock to validate. */
+		if (mddev->persistent)
+			super_types[mddev->major_version].validate_super(mddev, NULL, rdev);
 		err = mddev->pers->hot_add_disk(mddev, rdev);
 		if (err) {
 			md_kick_rdev_from_array(rdev);
-- 
2.43.0
