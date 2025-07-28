Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E5D1C36
	for <linux-raid@vger.kernel.org>; Mon, 28 Jul 2025 04:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753676520; cv=none; b=ZyQgBbdllJmhiywtQLx1ZpaOBn63rqf3JHEV4VNAD6XDVyxubxC5+kovjqS4Z27fEeU/6/mnXu1ShhjW/AACiFEjUjAq/eQ+dbsqDjrCzzwQEzsrRQjtpC+FcOcnGcVE2/RTsYPX+s8b7l7hM87tqvJ26Hd5Kodj5LVp3tRXFlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753676520; c=relaxed/simple;
	bh=WElGqm6dDFD1dpG7a4VFPLAPEjMtiTHDkGeQND4hloE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UFfN131y7UemL5dQ86m8uFO+wgx+BRFhYlaurKnXSWzb0v3udDtOb14W+tdVeMkXSF88Bm7H/Pmci0gxJMA5pSlZ0dR3HHKEuhWXLQGKLt0Yy5vkpXYrCWoWNb+wHiuWUs+xaBPz0s8endvAemiH6Q/uFQfMP+zZj9U+VSiFkRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ekfjSRaK; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ekfjSRaK"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3b784493b7aso49092f8f.2
        for <linux-raid@vger.kernel.org>; Sun, 27 Jul 2025 21:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1753676516; x=1754281316; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=b1XTKyHrUf7b2VsY2Bjf0JW+BUkBPa2ewV+fH3qkXjU=;
        b=ekfjSRaKgR6wDFp5F/6CAMD6LFfNagwgKWMep+IbdEol1zwiE6jIAm/anXk7eHtaTM
         Bmk3bsQwZogDxtqZwmyY5jYQMO9KO64nn3GTuIQsURjtozS7kbvVR+inZf3GB4jATd84
         fX5+/55oXabV2zV0mLw3iQtSOmVnFq8CBXDFDqhTZYkt4E+G4LP5Oqc5yqNWP7/wb2NC
         OTYXZtEEGvXF+UCgQEjq5Dmg52OeVuwwwnuupPSQPr94hcQmDH/k1xgxsqgGGdS0Hi+H
         78jxsko7yIe8U3/Tb0ALYDtfInA3e9sFLCtPKyTUHZPVhgcEyvxIL70uD2OOXLv+JIZT
         wv8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753676516; x=1754281316;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b1XTKyHrUf7b2VsY2Bjf0JW+BUkBPa2ewV+fH3qkXjU=;
        b=NqDDXGlTdPbx7Y9vZkwPpT0Qm1I2uBCqXac1nB1KaFnMPwNeJf6QBLiwMKNYXcL3bp
         IiVOsrPtVDNbWnsGBTZ1YLtUMUyiHg3wCqNUem61jX827uQjol4Bysv8PX6tUlnkVPkZ
         uy5yYl+a0Nfk3IRW2PpIvnasvzSuXagsDQ5v76FFvyzfx/waSU9bRAUC5JMpQUKatAUM
         apKoYnZQKOLQltn5B2BAjnkLVla7EnwsdY0Niw+4TUhBzpkuhMLnIIonXySJVnrpZ/QQ
         vU3k6L8rAjlc7uGsETI2DUkgVRKt+r991XNaU6IOjrL0icJGEIXPFsiDNKK8V/wXk/yy
         bU+g==
X-Forwarded-Encrypted: i=1; AJvYcCXt/a0otY5/BIu2tdQ2FxlVj+E3fH9IBYS53/R/LBMInRbbGVHtvek/V36nwf3nvan8fmJHjiYipYMl@vger.kernel.org
X-Gm-Message-State: AOJu0Ywxc/oVA3O40Yuw/bx8722GHmLFPutJUYTzEwxBnBaGsOMM3e8C
	iqO12j4sfLXTXlkeLcRcrMPLKEte8aJQC1BC2f1UPJk/jeZSHNuwPrnqB9Q61og6KUs=
X-Gm-Gg: ASbGncsjF30JEcg+GL99nQdvVv6jOPsKY9yDiU5kr9aNgG3sc26Ml8wrtdOHjA2r9k5
	JAeyM3ttV5q2MOHnxLcHGppCwWJUBwseiq6pdH7XiQkJXjSn5KltSXb7MoxTIQXwnOVRx4sLB+y
	pEBl1lT8AiwiFQvZQVXjVSJNe/lzMKNREDtHBx2Una5C3Bs/mKBxIt4BWSMBI/ttALNyBYdaVGS
	jTVUQwrFo5iXjYQtBmwx9Eajv1Syi/00LcCqOO5AOGhSGEQsHDsnTSUmP+XZAJTd8wNAd6BLWPY
	FXWM3aUB6SDH9lBAjrMpbc9FD3C6NU3OmlRKlYjq6oJlSjKTi28I4vNeIIbcTZYqjcfTiweaQv2
	3uZuBjZGoA225LHoW35l2Iok=
X-Google-Smtp-Source: AGHT+IHLKvnk2F4+sjG2wWkI71bo2NNvihWdZHilofvcK6n4x8V7TJE10xk97ZRkAh8Z9WdBM8nvOA==
X-Received: by 2002:a5d:584a:0:b0:3a6:ed68:cef9 with SMTP id ffacd0b85a97d-3b7765e5895mr2672064f8f.3.1753676516364;
        Sun, 27 Jul 2025 21:21:56 -0700 (PDT)
Received: from p15.suse.cz ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23ff7044135sm25527715ad.71.2025.07.27.21.21.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jul 2025 21:21:55 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: song@kernel.org,
	yukuai1@huaweicloud.com
Cc: Heming Zhao <heming.zhao@suse.com>,
	glass.su@suse.com,
	linux-raid@vger.kernel.org
Subject: [PATCH] md/md-cluster: handle REMOVE message earlier
Date: Mon, 28 Jul 2025 12:21:40 +0800
Message-ID: <20250728042145.9989-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit a1fd37f97808 ("md: Don't wait for MD_RECOVERY_NEEDED for
HOT_REMOVE_DISK ioctl") introduced a regression in the md_cluster
module. (Failed cases 02r1_Manage_re-add & 02r10_Manage_re-add)

Consider a 2-node cluster:
- node1 set faulty & remove command on a disk.
- node2 must correctly update the array metadata.

Before a1fd37f97808, on node1, the delay between msg:METADATA_UPDATED
(triggered by faulty) and msg:REMOVE was sufficient for node2 to
reload the disk info (written by node1).
After a1fd37f97808, node1 no longer waits between faulty and remove,
causing it to send msg:REMOVE while node2 is still reloading disk info.
This often results in node2 failing to remove the faulty disk.

== how to trigger ==

set up a 2-node cluster (node1 & node2) with disks vdc & vdd.

on node1:
mdadm -CR /dev/md0 -l1 -b clustered -n2 /dev/vdc /dev/vdd --assume-clean
ssh node2-ip mdadm -A /dev/md0 /dev/vdc /dev/vdd
mdadm --manage /dev/md0 --fail /dev/vdc --remove /dev/vdc

check array status on both nodes with "mdadm -D /dev/md0".
node1 output:
    Number   Major   Minor   RaidDevice State
       -       0        0        0      removed
       1     254       48        1      active sync   /dev/vdd
node2 output:
    Number   Major   Minor   RaidDevice State
       -       0        0        0      removed
       1     254       48        1      active sync   /dev/vdd

       0     254       32        -      faulty   /dev/vdc

Fixes: a1fd37f97808 ("md: Don't wait for MD_RECOVERY_NEEDED for HOT_REMOVE_DISK ioctl")
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 drivers/md/md.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0f03b21e66e4..de9f9a345ed3 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9758,8 +9758,8 @@ void md_check_recovery(struct mddev *mddev)
 			 * remove disk.
 			 */
 			rdev_for_each_safe(rdev, tmp, mddev) {
-				if (test_and_clear_bit(ClusterRemove, &rdev->flags) &&
-						rdev->raid_disk < 0)
+				if (rdev->raid_disk < 0 &&
+				    test_and_clear_bit(ClusterRemove, &rdev->flags))
 					md_kick_rdev_from_array(rdev);
 			}
 		}
@@ -10065,8 +10065,11 @@ static void check_sb_changes(struct mddev *mddev, struct md_rdev *rdev)
 
 	/* Check for change of roles in the active devices */
 	rdev_for_each_safe(rdev2, tmp, mddev) {
-		if (test_bit(Faulty, &rdev2->flags))
+		if (test_bit(Faulty, &rdev2->flags)) {
+			if (test_bit(ClusterRemove, &rdev2->flags))
+				set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 			continue;
+		}
 
 		/* Check if the roles changed */
 		role = le16_to_cpu(sb->dev_roles[rdev2->desc_nr]);
-- 
2.43.0

