Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pm4rKqO3"
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22D46C1
	for <linux-raid@vger.kernel.org>; Wed, 29 Nov 2023 04:15:46 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id ffacd0b85a97d-3331752d2b9so435487f8f.3
        for <linux-raid@vger.kernel.org>; Wed, 29 Nov 2023 04:15:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701260144; x=1701864944; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5swqXhS1U5U3RhAq8ZMgbaXuu8V3U7BQD7if+bTGcSU=;
        b=Pm4rKqO3ZdgA9BsmwsgPkSgb94R0GlEFqUO7eTbsx2hR913lzsZVMdkgK/qNgulqEn
         DPZUYCFZw/fUKHvTmPw0NwKX3EzbZ3qiQp/qMvYQtKsQxKtS2yn7KjKKhYmy8iY6u1oz
         9DiHMVMenXC+l55+lux9nEmbh5RmecHRH9Js1Vtqcg00EDFZMQkBmGv9ubq8uftoUuwk
         +sXpAY5cVLSUy1sDrI9rhTNQUHNhbQD5OxtfaR4+kRBAnBLHi4JkXybi6VkNcXXjzTeq
         tdyYl8DMMCizaKJAGHzCYDZatgcOR6DctEb+FCYRRMA7grvsCrI5sDGnw+R1AU3lAR5n
         TRrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701260144; x=1701864944;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5swqXhS1U5U3RhAq8ZMgbaXuu8V3U7BQD7if+bTGcSU=;
        b=Uz+93HZpN4YXrq8nq7/ggr38Hu88Ci86jij8VIYf9KRUnSdnzphrbh9Wu2w0Mko94d
         0oFrKGTEKqmi7gf0mU4zpcXfDjMp0xR11tw7QmzCHaw5grQR3akXPXFgDi8OBxbxkmaU
         U0jR65iqUCkJNOt/VhF4JTm9Kh/Z6+r4/MjYd2VXwnWK1H/24+1XtlwGkFba3lNRONDT
         WnU4U9EvPGg4PmkX6Wv+6WbCiiDx3J9QKu3ymgBY2Z0+Bu5KqfZYyP14ESDPpR8xEdvn
         DAZheU1qLCMfIxKeRsWxD4/2i/GpIYWNo2XS1wnLegrFYyQksN2xK6nukHxDScGxVIZJ
         UBYg==
X-Gm-Message-State: AOJu0YzGkrTHGGpfzddKONdJTk8nuyHcYijNbJ8/9IpqrVlb5hdiXqM7
	YXdNjqvCsM+Mi1JS/tyyDVY2iXLSLfZTEHGSfoJtqSCbA04=
X-Google-Smtp-Source: AGHT+IEKYNaoKk9FDCw7M0xzcn0dxSoT9lCUaY+7I2NIfBT5+WcseWm/tdtndAxN5J1edrDUiBIbyENpEduHqnEgbqo=
X-Received: by 2002:a5d:4e4a:0:b0:332:f895:f598 with SMTP id
 r10-20020a5d4e4a000000b00332f895f598mr8412244wrt.61.1701260144260; Wed, 29
 Nov 2023 04:15:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAGRgLy5E3cb=MS8eSMH03fa27tgFnZp0hwrrobyQMuUU_Axiag@mail.gmail.com>
 <CAPhsuW4z7U-Aq=YemQjFKtcaB7k9x+T_=zM8oBkR3aK2fRzo=A@mail.gmail.com>
 <CAGRgLy6KH9WfqHzN2OkFg5tb49Y=wKnBqQCdWifoFV13aD17Dg@mail.gmail.com> <CAPhsuW6AT5_=d9ibfwBedsd-aVrdM1tfBnJpYD=hoiOeKMCpAw@mail.gmail.com>
In-Reply-To: <CAPhsuW6AT5_=d9ibfwBedsd-aVrdM1tfBnJpYD=hoiOeKMCpAw@mail.gmail.com>
From: Alexander Lyakas <alex.bolshoy@gmail.com>
Date: Wed, 29 Nov 2023 14:15:33 +0200
Message-ID: <CAGRgLy6H0q+VEGBeG5bqs-=826cZyGZYVq9_7ZG453n+XXJBcQ@mail.gmail.com>
Subject: Re: raid6 corruption after assembling with event counter difference
 of 1
To: Song Liu <song@kernel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Song,

> Thanks for pointing this out. I think this is the actual problem here. In
> analyze_sbs() we first run validate_super() on the freshest device.
> Then, we run validate_super() on other devices. We should mark the
> device as faulty based on the sb from the freshest device. (which is
> not the case at the moment). I think we need to fix this.
Thanks for your suggestion. Based on it, I prepared a patch[1], which,
after manually reproducing the problem, addresses the issue.

The device with less-by-1 event counter is added to the array as
Faulty when the array is started. Then remove_and_add_spares() ejects
this device from the array, as expected. Later, the user performs:
"mdadm --remove" and "madam --re-add", which rebuilds the device. Data
corruption is avoided with this.

Please kindly note the following:
- md has many features, which we don't use, such as: "non-persistent
arrays", "clustered arrays", "autostart", "journal devices",
"write-behind", "multipath arrays" and others. I cannot say how this
fix will interoperate with these features.
- I tested the fix only on superblock version 1.2. I don't know how
0.9 superblocks work (because I never used them), so I did not change
anything in super_90_validate().
- I tested the fix on our production kernel 4.14 LTS. I ported the
changes to the mainline kernel 6.7-rc3, but I do not have the ability
at the moment to test it on this kernel.

Can you please comment on the patch?

> With the above issue fixed, allowing the event counter to be off by 1 is safe.
> Does this make sense? Did I miss cases?
Yes, now it should be safe.

Thanks,
Alex.

[1]
From 13ba53f3bc99b207386a69e3ef176fb5113d7ee3 Mon Sep 17 00:00:00 2001
From: Alex Lyakas <alex@zadara.com>
Date: Wed, 29 Nov 2023 13:38:22 +0200
Subject: [PATCH] md: upon assembling the array, consult the superblock of the
 freshest device

In case we are adding to the array a device, whose event counter
is less by 1 then the one of the freshest device.

Signed-off-by: Alex Lyakas <alex@zadara.com>
---
 drivers/md/md.c | 53 +++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 43 insertions(+), 10 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index c94373d..e490275 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1195,6 +1195,7 @@ struct super_type  {
                                          struct md_rdev *refdev,
                                          int minor_version);
        int                 (*validate_super)(struct mddev *mddev,
+                                             struct md_rdev *freshest,
                                              struct md_rdev *rdev);
        void                (*sync_super)(struct mddev *mddev,
                                          struct md_rdev *rdev);
@@ -1333,7 +1334,7 @@ static int super_90_load(struct md_rdev *rdev,
struct md_rdev *refdev, int minor
 /*
  * validate_super for 0.90.0
  */
-static int super_90_validate(struct mddev *mddev, struct md_rdev *rdev)
+static int super_90_validate(struct mddev *mddev, struct md_rdev
*freshest, struct md_rdev *rdev)
 {
        mdp_disk_t *desc;
        mdp_super_t *sb = page_address(rdev->sb_page);
@@ -1845,7 +1846,7 @@ static int super_1_load(struct md_rdev *rdev,
struct md_rdev *refdev, int minor_
        return ret;
 }

-static int super_1_validate(struct mddev *mddev, struct md_rdev *rdev)
+static int super_1_validate(struct mddev *mddev, struct md_rdev
*freshest, struct md_rdev *rdev)
 {
        struct mdp_superblock_1 *sb = page_address(rdev->sb_page);
        __u64 ev1 = le64_to_cpu(sb->events);
@@ -1941,13 +1942,15 @@ static int super_1_validate(struct mddev
*mddev, struct md_rdev *rdev)
                }
        } else if (mddev->pers == NULL) {
                /* Insist of good event counter while assembling, except for
-                * spares (which don't need an event count) */
-               ++ev1;
+                * spares (which don't need an event count).
+                * Similar to mdadm, we allow event counter difference of 1
+                * from the freshest device.
+                */
                if (rdev->desc_nr >= 0 &&
                    rdev->desc_nr < le32_to_cpu(sb->max_dev) &&
                    (le16_to_cpu(sb->dev_roles[rdev->desc_nr]) <
MD_DISK_ROLE_MAX ||
                     le16_to_cpu(sb->dev_roles[rdev->desc_nr]) ==
MD_DISK_ROLE_JOURNAL))
-                       if (ev1 < mddev->events)
+                       if (ev1 + 1 < mddev->events)
                                return -EINVAL;
        } else if (mddev->bitmap) {
                /* If adding to array with a bitmap, then we can accept an
@@ -1968,8 +1971,38 @@ static int super_1_validate(struct mddev
*mddev, struct md_rdev *rdev)
                    rdev->desc_nr >= le32_to_cpu(sb->max_dev)) {
                        role = MD_DISK_ROLE_SPARE;
                        rdev->desc_nr = -1;
-               } else
+               } else if (mddev->pers == NULL && freshest != NULL &&
ev1 < mddev->events) {
+                       /*
+                        * If we are assembling, and our event counter
is smaller than the
+                        * highest event counter, we cannot trust our
superblock about the role.
+                        * It could happen that our rdev was marked as
Faulty, and all other
+                        * superblocks were updated with +1 event counter.
+                        * Then, before the next superblock update,
which typically happens when
+                        * remove_and_add_spares() removes the device
from the array, there was
+                        * a crash or reboot.
+                        * If we allow current rdev without consulting
the freshest superblock,
+                        * we could cause data corruption.
+                        * Note that in this case our event counter is
smaller by 1 than the
+                        * highest, otherwise, this rdev would not be
allowed into array;
+                        * both kernel and mdadm allow event counter
difference of 1.
+                        */
+                       struct mdp_superblock_1 *freshest_sb =
page_address(freshest->sb_page);
+                       u32 freshest_max_dev =
le32_to_cpu(freshest_sb->max_dev);
+
+                       if (rdev->desc_nr >= freshest_max_dev) {
+                               /* this is unexpected, better not proceed */
+                               pr_warn("md: %s: rdev[%pg]:
desc_nr(%d) >= freshest(%pg)->sb->max_dev(%u)\n",
+                                               mdname(mddev),
rdev->bdev, rdev->desc_nr, freshest->bdev,
+                                               freshest_max_dev);
+                               return -EUCLEAN;
+                       }
+
+                       role =
le16_to_cpu(freshest_sb->dev_roles[rdev->desc_nr]);
+                       pr_warn("md: %s: rdev[%pg]: role=%d(0x%x)
according to freshest %pg\n",
+                                   mdname(mddev), rdev->bdev, role,
role, freshest->bdev);
+               } else {
                        role = le16_to_cpu(sb->dev_roles[rdev->desc_nr]);
+               }
                switch(role) {
                case MD_DISK_ROLE_SPARE: /* spare */
                        break;
@@ -2876,7 +2909,7 @@ static int add_bound_rdev(struct md_rdev *rdev)
                 * and should be added immediately.
                 */
                super_types[mddev->major_version].
-                       validate_super(mddev, rdev);
+                       validate_super(mddev, NULL/*freshest*/, rdev);
                err = mddev->pers->hot_add_disk(mddev, rdev);
                if (err) {
                        md_kick_rdev_from_array(rdev);
@@ -3813,7 +3846,7 @@ static int analyze_sbs(struct mddev *mddev)
        }

        super_types[mddev->major_version].
-               validate_super(mddev, freshest);
+               validate_super(mddev, NULL/*freshest*/, freshest);

        i = 0;
        rdev_for_each_safe(rdev, tmp, mddev) {
@@ -3828,7 +3861,7 @@ static int analyze_sbs(struct mddev *mddev)
                }
                if (rdev != freshest) {
                        if (super_types[mddev->major_version].
-                           validate_super(mddev, rdev)) {
+                           validate_super(mddev, freshest, rdev)) {
                                pr_warn("md: kicking non-fresh %pg
from array!\n",
                                        rdev->bdev);
                                md_kick_rdev_from_array(rdev);
@@ -6836,7 +6869,7 @@ int md_add_new_disk(struct mddev *mddev, struct
mdu_disk_info_s *info)
                        rdev->saved_raid_disk = rdev->raid_disk;
                } else
                        super_types[mddev->major_version].
-                               validate_super(mddev, rdev);
+                               validate_super(mddev, NULL/*freshest*/, rdev);
                if ((info->state & (1<<MD_DISK_SYNC)) &&
                     rdev->raid_disk != info->raid_disk) {
                        /* This was a hot-add request, but events doesn't
--
1.9.1
