Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zadara.com header.i=@zadara.com header.b="M9ImUM6s"
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC468CA
	for <linux-raid@vger.kernel.org>; Mon,  4 Dec 2023 09:00:40 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id ffacd0b85a97d-33339d843b9so1983498f8f.0
        for <linux-raid@vger.kernel.org>; Mon, 04 Dec 2023 09:00:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=zadara.com; s=google; t=1701709239; x=1702314039; darn=vger.kernel.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ed40W60gNIeTeudT1ds77B+kz+vzslVsFaXUParCr/M=;
        b=M9ImUM6sX99BlP2/KkcqmOW/JSQf80N8CJM2wmxAEFDyqYhwAu5GB/z5vHFOCBKU1U
         v8xkMQ+9LF9n6aa820+fBFo77KjCXh33RDk95W9mAto3nA1DT4jrNHANFkU18NLuUz+M
         UgUO4a5aSyw+TPD4S0s0TSQp7wESXPB76rpmiLl8YFLXNRo4HJpKSkzQrvdHWQ48XbvJ
         D+NoTaqMzjeJtD/Pszwn/Y/dhNt5ca+qeiRUW3IBpCwsU351fsDKg+a3vjS8WVQcYZPA
         kCeXFqPmdPEJ9zMQk8SS95pgV7+LKxYd94VMnPeNaMNGlMk5F6h7ZsE/g3sklAaUUO0C
         Lnrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701709239; x=1702314039;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ed40W60gNIeTeudT1ds77B+kz+vzslVsFaXUParCr/M=;
        b=NA4421PWAhrGivCApiaY91Nur5222oBvjzKkEjHLvU9GcZPTxTfiVeqIDEUUA7Bpp0
         7bE0ssile+hWLJ8knLuFMwPljSRKgVewoYY5NSGZgRVq4iLPWgFtVtmykWUPfr9+cmcb
         I/qkqX+N8sfbChPDB0xW5IKhZ/OIsT7KG4axeue7sBteBdr9fc+C4vL5Xpd+dIQCmOt2
         FZx0UDOYT9Yl7jDJE4JDedLCNW71R1d0KTFC78dE/SN6fWw55U1OZuvM2cPkG2McCRV1
         tTBkzoUwSrZV3eivMdtuKd3qGyD66wsM/RKdoMIQPNBRitzgWoi/XiF+UgggmBiGHnqC
         ECjQ==
X-Gm-Message-State: AOJu0YznOozMcpOCFFzrcy2QyKceLIoPNIzqKLjoHWD8L89dVwHC0bsf
	x1aUal/+U8qGS/etlCq3v+/Ss6iV+G+iu4zrv0E=
X-Google-Smtp-Source: AGHT+IF0ActTofz1OMpE/KW3axEPsBDbngszExwrMjjf1l8sXJtNp64l6QbgssInQ0UO4/0ADggBnw==
X-Received: by 2002:a05:600c:5119:b0:40a:42dd:c82c with SMTP id o25-20020a05600c511900b0040a42ddc82cmr2676239wms.27.1701709238751;
        Mon, 04 Dec 2023 09:00:38 -0800 (PST)
Received: from localhost.localdomain ([82.166.81.77])
        by smtp.gmail.com with ESMTPSA id v15-20020a5d4a4f000000b0033328f47c83sm11403615wrs.2.2023.12.04.09.00.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 Dec 2023 09:00:38 -0800 (PST)
From: Alex Lyakas <alex.lyakas@zadara.com>
To: linux-raid@vger.kernel.org
Cc: song@kernel.org,
	alex.lyakas@zadara.com,
	Alex Lyakas <alex@zadara.com>
Subject: [PATCH] md: upon assembling the array, consult the superblock of the freshest device
Date: Mon,  4 Dec 2023 18:54:15 +0200
Message-Id: <1701708855-17404-1-git-send-email-alex.lyakas@zadara.com>
X-Mailer: git-send-email 1.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

From: Alex Lyakas <alex@zadara.com>

Upon assembling the array, both kernel and mdadm allow the devices to have event
counter difference of 1, and still consider them as up-to-date.
However, a device whose event count is behind by 1, may in fact not be up-to-date,
and array resync with such a device may cause data corruption.
To avoid this, consult the superblock of the freshest device about the status
of a device, whose event counter is behind by 1.

Signed-off-by: Alex Lyakas <alex.lyakas@zadara.com>

Disclaimer: I was not able to test this change on one of the latest 6.7 kernels.
I tested it on kernel 4.14 LTS and then ported the changes.

To test this change, I modified the code of remove_and_add_spares():
diff --git a/drivers/md/md.c b/drivers/md/md.c
index ad68b5e..f57854e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9341,6 +9341,7 @@ static int remove_and_add_spares(struct mddev *mddev,
                }
        }
 no_add:
+       removed = 0;
        if (removed)
                set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
        return spares;

With this change, when a device fails, the superblock of all other devices
is only updated once. During test, I sumulated a failure of one of the devices,
and then rebooted the machine. After reboot, I re-assembled the array
with all devices, including the device that I failed.
Event counter difference between the failed device and the other devices
was 1, and then with my change the role of the problematic device was taken
from the superblock of one of the higher devices, which indicated
the role to be MD_DISK_ROLE_FAULTY. After array assembly completed,
remove_and_add_spares() ejected the problematic disk from the array,
as expected.
---
 drivers/md/md.c | 53 +++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 43 insertions(+), 10 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index c94373d..ad68b5e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1195,6 +1195,7 @@ struct super_type  {
 					  struct md_rdev *refdev,
 					  int minor_version);
 	int		    (*validate_super)(struct mddev *mddev,
+					      struct md_rdev *freshest,
 					      struct md_rdev *rdev);
 	void		    (*sync_super)(struct mddev *mddev,
 					  struct md_rdev *rdev);
@@ -1333,7 +1334,7 @@ static int super_90_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor
 /*
  * validate_super for 0.90.0
  */
-static int super_90_validate(struct mddev *mddev, struct md_rdev *rdev)
+static int super_90_validate(struct mddev *mddev, struct md_rdev *freshest, struct md_rdev *rdev)
 {
 	mdp_disk_t *desc;
 	mdp_super_t *sb = page_address(rdev->sb_page);
@@ -1845,7 +1846,7 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
 	return ret;
 }
 
-static int super_1_validate(struct mddev *mddev, struct md_rdev *rdev)
+static int super_1_validate(struct mddev *mddev, struct md_rdev *freshest, struct md_rdev *rdev)
 {
 	struct mdp_superblock_1 *sb = page_address(rdev->sb_page);
 	__u64 ev1 = le64_to_cpu(sb->events);
@@ -1941,13 +1942,15 @@ static int super_1_validate(struct mddev *mddev, struct md_rdev *rdev)
 		}
 	} else if (mddev->pers == NULL) {
 		/* Insist of good event counter while assembling, except for
-		 * spares (which don't need an event count) */
-		++ev1;
+		 * spares (which don't need an event count).
+		 * Similar to mdadm, we allow event counter difference of 1
+		 * from the freshest device.
+		 */
 		if (rdev->desc_nr >= 0 &&
 		    rdev->desc_nr < le32_to_cpu(sb->max_dev) &&
 		    (le16_to_cpu(sb->dev_roles[rdev->desc_nr]) < MD_DISK_ROLE_MAX ||
 		     le16_to_cpu(sb->dev_roles[rdev->desc_nr]) == MD_DISK_ROLE_JOURNAL))
-			if (ev1 < mddev->events)
+			if (ev1 + 1 < mddev->events)
 				return -EINVAL;
 	} else if (mddev->bitmap) {
 		/* If adding to array with a bitmap, then we can accept an
@@ -1968,8 +1971,38 @@ static int super_1_validate(struct mddev *mddev, struct md_rdev *rdev)
 		    rdev->desc_nr >= le32_to_cpu(sb->max_dev)) {
 			role = MD_DISK_ROLE_SPARE;
 			rdev->desc_nr = -1;
-		} else
+		} else if (mddev->pers == NULL && freshest != NULL && ev1 < mddev->events) {
+			/*
+			 * If we are assembling, and our event counter is smaller than the
+			 * highest event counter, we cannot trust our superblock about the role.
+			 * It could happen that our rdev was marked as Faulty, and all other
+			 * superblocks were updated with +1 event counter.
+			 * Then, before the next superblock update, which typically happens when
+			 * remove_and_add_spares() removes the device from the array, there was
+			 * a crash or reboot.
+			 * If we allow current rdev without consulting the freshest superblock,
+			 * we could cause data corruption.
+			 * Note that in this case our event counter is smaller by 1 than the
+			 * highest, otherwise, this rdev would not be allowed into array;
+			 * both kernel and mdadm allow event counter difference of 1.
+			 */
+			struct mdp_superblock_1 *freshest_sb = page_address(freshest->sb_page);
+			u32 freshest_max_dev = le32_to_cpu(freshest_sb->max_dev);
+
+			if (rdev->desc_nr >= freshest_max_dev) {
+				/* this is unexpected, better not proceed */
+				pr_warn("md: %s: rdev[%pg]: desc_nr(%d) >= freshest(%pg)->sb->max_dev(%u)\n",
+						mdname(mddev), rdev->bdev, rdev->desc_nr, freshest->bdev,
+						freshest_max_dev);
+				return -EUCLEAN;
+			}
+
+			role = le16_to_cpu(freshest_sb->dev_roles[rdev->desc_nr]);
+			pr_debug("md: %s: rdev[%pg]: role=%d(0x%x) according to freshest %pg\n",
+				     mdname(mddev), rdev->bdev, role, role, freshest->bdev);
+		} else {
 			role = le16_to_cpu(sb->dev_roles[rdev->desc_nr]);
+		}
 		switch(role) {
 		case MD_DISK_ROLE_SPARE: /* spare */
 			break;
@@ -2876,7 +2909,7 @@ static int add_bound_rdev(struct md_rdev *rdev)
 		 * and should be added immediately.
 		 */
 		super_types[mddev->major_version].
-			validate_super(mddev, rdev);
+			validate_super(mddev, NULL/*freshest*/, rdev);
 		err = mddev->pers->hot_add_disk(mddev, rdev);
 		if (err) {
 			md_kick_rdev_from_array(rdev);
@@ -3813,7 +3846,7 @@ static int analyze_sbs(struct mddev *mddev)
 	}
 
 	super_types[mddev->major_version].
-		validate_super(mddev, freshest);
+		validate_super(mddev, NULL/*freshest*/, freshest);
 
 	i = 0;
 	rdev_for_each_safe(rdev, tmp, mddev) {
@@ -3828,7 +3861,7 @@ static int analyze_sbs(struct mddev *mddev)
 		}
 		if (rdev != freshest) {
 			if (super_types[mddev->major_version].
-			    validate_super(mddev, rdev)) {
+			    validate_super(mddev, freshest, rdev)) {
 				pr_warn("md: kicking non-fresh %pg from array!\n",
 					rdev->bdev);
 				md_kick_rdev_from_array(rdev);
@@ -6836,7 +6869,7 @@ int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info)
 			rdev->saved_raid_disk = rdev->raid_disk;
 		} else
 			super_types[mddev->major_version].
-				validate_super(mddev, rdev);
+				validate_super(mddev, NULL/*freshest*/, rdev);
 		if ((info->state & (1<<MD_DISK_SYNC)) &&
 		     rdev->raid_disk != info->raid_disk) {
 			/* This was a hot-add request, but events doesn't
-- 
1.9.1

