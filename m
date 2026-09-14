Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF0A383985
	for <linux-raid@vger.kernel.org>; Mon, 14 Sep 2026 05:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789365399; cv=none; b=PxiF9e7bb4gGVTagKuAk43upmvr9lBrvot8gmn1VL6lepfg5sfP9ldOri3U3qtZL3U31mQamZT3/v5oE0LJTX6tIqzck3KfgkfcjOm/fuDR2K0zXtYOYqucaxZtvYuIhsC+cq+PDwtNLVbc9XRjS3C0/Y9JW1IttvJBDkES2CfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789365399; c=relaxed/simple;
	bh=TpSPkH+SXiJ3GUAtyS7rFYndR00eT9614I4bRCa+GH4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=S1mSgHbdgUqAPF6ATzTRAi8ftiWYIMsNSGJZVeZf9Vd+ymIpxfERmbJ2ByfPqeaccKPGzcbzGdJ20V0ByamlD6Hd0kVmts3CxW6rKXPEJr4Kvrm9yEox936TUfRXpIo1XE6/sRMTTtLf7kvzVN1leCjWT+QYtZxECmFoSq1cA2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kuwUDlbu; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kuwUDlbu"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2cfbbdfa60bso29973865ad.3
        for <linux-raid@vger.kernel.org>; Sun, 13 Sep 2026 22:56:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789365386; x=1789970186; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=bRMmXFSdNXlIVborRjU6mCE3PD/OEqkVPn+DnkXz8F0=;
        b=kuwUDlbuHpjvvJT+x1YwMJxRUk5W2nBsDXlxqN7e8wdoUHV56rf4660vFvMmf2lJiQ
         nqBXmDczQHcVp/jU6dYkrH/0/w9bLBwXowO5oIz2u0Q8Zl6TFa3EtxR8oXs69sfVoHHj
         8yRT+MvfjZrHrICAWabsXV9T1dFSxXu5rZmUGEzhTBSxau5aZN3Gv5GsQeOGAGXFxn30
         oBCYiQ9EWQm2SA8HoUZFfJCEeswX2XcOYkYqaQYFMBjUmRbkS8xngVu9QfA3t0eh3FWk
         RCYMDE1Jw2YEwrbh2LLOZ0XISEHcpm7Dn1orXbGgFWtayMlc5gO/PLBuJEFqfInkk1MC
         3F0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789365386; x=1789970186;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bRMmXFSdNXlIVborRjU6mCE3PD/OEqkVPn+DnkXz8F0=;
        b=j6M91N0B1F5nU+2Oelw6rYc/lEACRgs/LcawuOZZ9QuetnSabfhCgCIoBRUKn/jznG
         r6+p0yxhVlUTQKwAasZrpsjRmkSBoxNUpch6dQuYVbu2v0RByjTRXfUQFRZpTwfxcP1z
         v37n9xzbkER4S2YuvKr/JpMAKoi9dy99AfZHWAZNAMt0+zodbcVzJlP1HwQdz5Q0CKtD
         L1qYtn7TycHJK1nJhjSGTGq+W8P9l7aDc0j5vvJP09EvkZcbkIUBqtVOopOoJDyUa9yk
         jN67fkkxH80+cQByLMvjsISvWPZ/qgE311pES14otDG6HnqGk66K3qmHq7Snqe40DaDn
         fBpQ==
X-Forwarded-Encrypted: i=1; AKwUvBx+lbzsuTNNio7nbl1qnGyNYB5k1Eqlz1oEuV7SLBMXKqA39vjyQj0v2bHM/K4jAbCMeHLCNxawC2vV@vger.kernel.org
X-Gm-Message-State: AFuF++kcA2kDpKLb29z9MKcNdqNSCpI5TGXPi+f6pRTEGr9ccmx0KAVi
	lYctrvL2vgBwVVInCwusbTpNY41xnfd1gfNeLLKL+WI+z+ZZDkJcvn13
X-Gm-Gg: AYBFou2UpHAVRe8t4X5bNyFmU8ob9jclae54AnxjBdqvkX1XndPcG/WVGmbVA/IyQ4S
	lxubqt3zvGCRbsa9ryHWZ+oqganPqIOjAjAbyKvNX19fdvWVMHkHk61D8pf2q3c/7KcW7HjbECd
	JZcDiqpJBQxvFrC7zJNgB9nW18HJ7Zpl4j/v9K4yIXveaDeeR56+dme1I1xFI3n5C/TUFDMuUMv
	uONGtRTIZGUq8p71OJc7GOXdL0e7YW1+f2SWSB/Pg0fIvQ945MazP1oxSi5PuYi41Wngat5KXnz
	1a6v737AS+3yZs4w7cLx9LpxQ0ltl13CgyCrxev15OLiLLrvBrUQhjKAXLPxeV7wLVX7BlUcUAy
	ddlf5vuNWIsd6ayiDIRaSWJ++cKh3ZvETmchBWV+zivUiERZdW/tWv/ICM64vaDWhHuL8N72TRt
	1YGtRoKRKvHDxXq3lLyNw7rHZI2UgwAE+zG6BF9BP8mDDjvuUf/ZBYSwBpSeCgclVaAHyYlLN2k
	p0vwvCs77ZhLkjFLHPqxAh/jkfQU6bHSwU=
X-Received: by 2002:a17:902:f644:b0:2d9:3636:d01a with SMTP id d9443c01a7336-2dd6c725048mr27735915ad.15.1789365386312;
        Sun, 13 Sep 2026 22:56:26 -0700 (PDT)
Received: from deepanshu.. ([2405:201:682f:383f:70f2:8a07:cfbd:d0e7])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd44ad5d5bsm31494665ad.75.2026.09.13.22.56.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2026 22:56:25 -0700 (PDT)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: song@kernel.org,
	yukuai@fygo.io
Cc: magiclinan@didiglobal.com,
	xiao@kernel.org,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+9e3014263a35700ab49b@syzkaller.appspotmail.com
Subject: [PATCH] md: fix out-of-bounds access to superblock disk array
Date: Mon, 14 Sep 2026 11:26:19 +0530
Message-Id: <20260914055619.32929-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The v0.90 superblock format can only describe MD_SB_DISKS (27) member
disks, but several places did not enforce this limit, allowing an
out-of-bounds access to sb->disks[]:

 1. super_90_load() only checked that sb->raid_disks was positive,
    not that it fit within MD_SB_DISKS. A crafted superblock with an
    oversized raid_disks value was accepted into mddev->raid_disks.

 2. super_90_sync() computed desc_nr from rdev2->raid_disk or a
    running spare counter without checking it stayed within bounds
    before indexing sb->disks[desc_nr].

 3. super_90_sync() also indexed sb->disks[rdev->desc_nr] for
    sb->this_disk without any bounds check.

 4. The "missing devices" loop in super_90_sync() iterated up to
    mddev->raid_disks with no per-iteration bound on sb->disks[].

Any of these could be reached with a bad raid_disks/desc_nr value
and cause an out-of-bounds array access:

  UBSAN: array-index-out-of-bounds in drivers/md/md.c:1697:17
  index 124 is out of range for type 'mdp_disk_t [27]'

Validate raid_disks at load time, and add bounds checks at each
point sb->disks[] is indexed as defense in depth.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+9e3014263a35700ab49b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9e3014263a35700ab49b
Assisted-by: Claude
Tested-by: syzbot+9e3014263a35700ab49b@syzkaller.appspotmail.com
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
---
 drivers/md/md.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 680b34a63cb3..f950e6fd144c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1393,7 +1393,8 @@ static int super_90_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor
 		goto abort;
 	}
 
-	if (sb->raid_disks <= 0)
+	if (sb->raid_disks <= 0 ||
+	    sb->raid_disks > MD_SB_DISKS)
 		goto abort;
 
 	if (md_csum_fold(calc_sb_csum(sb)) != md_csum_fold(sb->sb_csum)) {
@@ -1693,6 +1694,13 @@ static void super_90_sync(struct mddev *mddev, struct md_rdev *rdev)
 			desc_nr = rdev2->raid_disk;
 		else
 			desc_nr = next_spare++;
+
+		if (desc_nr < 0 || desc_nr >= MD_SB_DISKS) {
+			pr_warn("md: %s: desc_nr %d out of range for rdev %pg, skipping\n",
+				mdname(mddev), desc_nr, rdev2->bdev);
+			continue;
+		}
+
 		rdev2->desc_nr = desc_nr;
 		d = &sb->disks[rdev2->desc_nr];
 		nr_disks++;
@@ -1722,7 +1730,7 @@ static void super_90_sync(struct mddev *mddev, struct md_rdev *rdev)
 			d->state |= (1<<MD_DISK_FAILFAST);
 	}
 	/* now set the "removed" and "faulty" bits on any missing devices */
-	for (i=0 ; i < mddev->raid_disks ; i++) {
+	for (i = 0 ; i < mddev->raid_disks && i < MD_SB_DISKS ; i++) {
 		mdp_disk_t *d = &sb->disks[i];
 		if (d->state == 0 && d->number == 0) {
 			d->number = i;
@@ -1737,8 +1745,11 @@ static void super_90_sync(struct mddev *mddev, struct md_rdev *rdev)
 	sb->working_disks = working;
 	sb->failed_disks = failed;
 	sb->spare_disks = spare;
-
-	sb->this_disk = sb->disks[rdev->desc_nr];
+	if (rdev->desc_nr >= 0 && rdev->desc_nr < MD_SB_DISKS)
+		sb->this_disk = sb->disks[rdev->desc_nr];
+	else
+		pr_warn("md: %s: rdev desc_nr %d out of range, this_disk not set\n",
+			mdname(mddev), rdev->desc_nr);
 	sb->sb_csum = calc_sb_csum(sb);
 }
 
-- 
2.34.1

