Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zadara.com header.i=@zadara.com header.b="WHk5jzGh"
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7020E111
	for <linux-raid@vger.kernel.org>; Wed, 13 Dec 2023 04:31:04 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id ffacd0b85a97d-336420a244dso253133f8f.0
        for <linux-raid@vger.kernel.org>; Wed, 13 Dec 2023 04:31:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=zadara.com; s=google; t=1702470662; x=1703075462; darn=vger.kernel.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sh1piAvWLnGTe8ZDekPpzVVW9yjds0GZKTtNlVvH7ms=;
        b=WHk5jzGh/2TwI+knX25YhA16IAnFlRwumi586uhE6p3XHGeyN4GvRv4KdqrKdswPTA
         gtnH3UEuiptKcG/lKOz5MiMT+AsYY7bYZKOmxZhkgEfvwqCmFU2Fjg5GnixdI5ua4fSD
         GvsWfQl8CUtmAy5pfR35QpCsQD+nFAPIFwe9DmqYMmi8qAKLFhFSqdTyzYWdl032dXkm
         G6Pxv+ljZ86tlOINB6Htp0BrCoEccNPUlV6HK8p0U8tFFTai9nbxZNbUqnS3bu7WccJX
         1ULlggamgxUVgD09JgO9ezF/pyvU17o5orIG2wsoF4rg7Jwxa6VQr4lj7e5Lt5Dxwnej
         eH3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702470662; x=1703075462;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Sh1piAvWLnGTe8ZDekPpzVVW9yjds0GZKTtNlVvH7ms=;
        b=WOlmLglOI/IpKD+UnBe8WsLWan4YrDGuWXU6m7EkEI9eVjdTWDMq5B39srSygQrZGX
         XPkHBoACocdTFR/oZ30LUHhDAvRocNBYs8xDn2ByeAvFSQXSUWcrwQIYU0iNfMDLl7ZY
         NyoWJRf9BxEIFSpyvGoy1LsBqPVTlN1t17pYrR2VDa/nMc9GAiLzUN8iQgBEKYjrHJja
         bB8hfIchbrKIkqjQ9cxu/JNNsVAjSQ/0CprsutfeD9FWVO5Khh/uSh/B6Ohp1o0/n3Sk
         zeF31UoNgyyPPwm+BcaLYN1LzXm+aEfbBlKnCGA5QKzO6YyubtqoMscmx/gXSBl2/5tv
         9KSg==
X-Gm-Message-State: AOJu0YwDJbiy1cQbtqUXlitDOq4jvpIrQNHacVeGet6X2YVOovkioE+l
	3RBthad8TE92/K9Yg2ZXp6KXaNRe79HP/cMGmOk=
X-Google-Smtp-Source: AGHT+IH3dBkFT0JL6yJOEhQAxh9efmpyLtadGB08MZ5Ml4MgLfQk+gg5htj58JsYBx/Q9IUa/KUkUw==
X-Received: by 2002:adf:fe0d:0:b0:333:3a13:91dc with SMTP id n13-20020adffe0d000000b003333a1391dcmr3540631wrr.86.1702470661734;
        Wed, 13 Dec 2023 04:31:01 -0800 (PST)
Received: from localhost.localdomain ([82.166.81.77])
        by smtp.gmail.com with ESMTPSA id t8-20020adff608000000b00336341defadsm3492994wrp.19.2023.12.13.04.31.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 Dec 2023 04:31:01 -0800 (PST)
From: Alex Lyakas <alex.lyakas@zadara.com>
To: linux-raid@vger.kernel.org
Cc: song@kernel.org,
	alex.lyakas@zadara.com
Subject: [PATCH v2] md: upon assembling the array, consult the superblock of the freshest device
Date: Wed, 13 Dec 2023 14:24:31 +0200
Message-Id: <1702470271-16073-1-git-send-email-alex.lyakas@zadara.com>
X-Mailer: git-send-email 1.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

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

diff --git a/drivers/md/md.c b/drivers/md/md.c
index c94373d..27fa435 100644
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
@@ -1332,8 +1333,9 @@ static int super_90_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor
 
 /*
  * validate_super for 0.90.0
+ * note: we are not using "freshest" for 0.9 superblock
  */
-static int super_90_validate(struct mddev *mddev, struct md_rdev *rdev)
+static int super_90_validate(struct mddev *mddev, struct md_rdev *freshest, struct md_rdev *rdev)
 {
 	mdp_disk_t *desc;
 	mdp_super_t *sb = page_address(rdev->sb_page);
@@ -1845,7 +1847,7 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
 	return ret;
 }
 
-static int super_1_validate(struct mddev *mddev, struct md_rdev *rdev)
+static int super_1_validate(struct mddev *mddev, struct md_rdev *freshest, struct md_rdev *rdev)
 {
 	struct mdp_superblock_1 *sb = page_address(rdev->sb_page);
 	__u64 ev1 = le64_to_cpu(sb->events);
@@ -1941,13 +1943,15 @@ static int super_1_validate(struct mddev *mddev, struct md_rdev *rdev)
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
@@ -1968,8 +1972,38 @@ static int super_1_validate(struct mddev *mddev, struct md_rdev *rdev)
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
+						mdname(mddev), rdev->bdev, rdev->desc_nr,
+						freshest->bdev, freshest_max_dev);
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
@@ -2876,7 +2910,7 @@ static int add_bound_rdev(struct md_rdev *rdev)
 		 * and should be added immediately.
 		 */
 		super_types[mddev->major_version].
-			validate_super(mddev, rdev);
+			validate_super(mddev, NULL/*freshest*/, rdev);
 		err = mddev->pers->hot_add_disk(mddev, rdev);
 		if (err) {
 			md_kick_rdev_from_array(rdev);
@@ -3813,7 +3847,7 @@ static int analyze_sbs(struct mddev *mddev)
 	}
 
 	super_types[mddev->major_version].
-		validate_super(mddev, freshest);
+		validate_super(mddev, NULL/*freshest*/, freshest);
 
 	i = 0;
 	rdev_for_each_safe(rdev, tmp, mddev) {
@@ -3828,7 +3862,7 @@ static int analyze_sbs(struct mddev *mddev)
 		}
 		if (rdev != freshest) {
 			if (super_types[mddev->major_version].
-			    validate_super(mddev, rdev)) {
+			    validate_super(mddev, freshest, rdev)) {
 				pr_warn("md: kicking non-fresh %pg from array!\n",
 					rdev->bdev);
 				md_kick_rdev_from_array(rdev);
@@ -6836,7 +6870,7 @@ int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info)
 			rdev->saved_raid_disk = rdev->raid_disk;
 		} else
 			super_types[mddev->major_version].
-				validate_super(mddev, rdev);
+				validate_super(mddev, NULL/*freshest*/, rdev);
 		if ((info->state & (1<<MD_DISK_SYNC)) &&
 		     rdev->raid_disk != info->raid_disk) {
 			/* This was a hot-add request, but events doesn't
