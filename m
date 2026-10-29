Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793305349;
	b=R0OPN2xQ/y4vAfr7yEvr0EzXHI6GYlefTjxOuRLLUidk+mnMY33ce98Fnm95uzZA/oih
	 xd5ryz0zna3dUst3vRVywm2+CXz3rYMzg+03FlptrFVynulQKQ6Un8pNpQ2m2X8OSEZPL
	 cYaG92BdZzbpO5MOOgRPVJSjg9JZ3eBmrS8DcKLucbCE1mTRNHvASS7R8gGogesGgNREW
	 c8PDpc0+4OboMsBzgmkvFhv7lt1SD4tpsh41JSuGVGK/GgsiENagHDuJzbGUbO9st3qwD
	 Jdo+joQuLwp3zWGwDIrfR4txBML2oTsZrJAL6OxvTkjudiGcNZV7jGCVR3iW/sP0TZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793305349;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=1VIlXvJnDq3cC8Ujwt2OtIlcPxyApHxjHQ4NkJe9UNE=;
	b=kWOixaiPORT0SoeQaZ1AtTQ0XCscglPdGbMJWMlrfGiLm6caddpL2SLolspPUWAdvs/k
	 v7xORa+jlk1us+K6C98Q8rw41RucPdZGLeEA5vqfnhLlLSsFwjBX4CQaBe64EPjUcDQ7C
	 bedS6QPQ2wab1Cdi9yUDe087tjVww335H6AQkHT7zzq0IiHMxK2r9fPFS70ar8dY0YWyl
	 Hdrnt5oLNRgTcFGyxrHTmoZCRXzAdG5QpVd12S25jhtWKJJs7DyDW3KsCF5h5UOJbneKb
	 EJUWbYkqk3W7SM5WMyS74Iz4NwnMo+ldM0Rr3WzO5cM1I4FVnTZF5DOWQB4RwFLmBOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PcjJNViC;
	arc=none smtp.remote-ip=209.85.128.51
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE80C606A33B
	for <linux-raid@vger.kernel.org>; Thu, 29 Oct 2026 20:22:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CE80C606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PcjJNViC
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a5087a5348so24221185e9.0
        for <linux-raid@vger.kernel.org>; Thu, 29 Oct 2026 13:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793305347; x=1793910147; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1VIlXvJnDq3cC8Ujwt2OtIlcPxyApHxjHQ4NkJe9UNE=;
        b=PcjJNViCcl9XZIu1vVCKUOSntPYWz6Ik0rtLxUQyihu+OR4bcD/rOQACt2yc63HHCN
         jEAg1iESRGro8sCFGmBI58F0m1zNdUS2fY/MIgdK9vaF/qjSM/ojRLqA6CF4In0n0mXw
         cMM0JSoHXSdxzAAXaC2PaWFU97+tT5+ihGl3K5RAQcVrDzdu0Z4E8ylOhulyHBq7Ulg8
         RDidof5xXmUyguU0C8WtQ1WUY5Bd9qRAd59fgE7HB+S9MyQoTsfKpHR/Iorrax8a+LBv
         PPlWZZQLecEjWztqnA6Nnzrc0dwsfHl2fFXHQmFI4QRTkyZz7w1J1QetExwZUOn4ZLNQ
         BN1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793305347; x=1793910147;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1VIlXvJnDq3cC8Ujwt2OtIlcPxyApHxjHQ4NkJe9UNE=;
        b=mrwjqn0vJfpqOlNSrARAtc8IZ0jU5zaxcdGZKjoweV/ZnBWT/7qJ6fkYV7cMhBAwle
         DME+2yq8RKO1CS/V2FFGBz69FfP+DXWzLdHDqeZ4GvVRxUGK79NPSoQcfcUSxj+gIk9g
         PkTaBVZ0YF7f8MmYtrNApdwdRZE5bOCLFgHxhH7sSfZwkTPwMT5h3EFcP8nrdvIU4WNG
         n4SaS89YMqLdDgotQA5Y+WjMi421DzEbTAJJIrti1ywjhL2xExpORKUjOh9Q8dekWZ6Q
         D4hsgtN7Dq2eCFhuKIzmp/1XoolDdM8nhoLY9foT0KC+u/T1BMFsYMYnQn5jSlNEJsle
         q0rg==
X-Gm-Message-State: AFq9FYItBBleCjjGRveWfgNbntEcuba/YZip/pXj5yPea9YaKE5iEki2
	kGjFIZXWlLu9IEXBwd07sDYWLV4Dy1xmp0b8EsIRQHH9gVth3OVxjgCB
X-Gm-Gg: AYBFou284nk6gxU79xqUvuxwxclSNRoBVPeRrtXEKLlGiKZk5KHDtN2xC+xSs24YW+I
	cZXK8a9bQDu0D6xSZitl2zsUFuMX8r4pTcZljP13Zjf4qSw+Q9XFCn0jLhk1w+At6rbKA++72lM
	2Ye0e+lHEp9qvI5JUgPMjEHq2oCdZfk/OmCm5/TG0LHSquVaIB3lHNeK3Cj4mQo1N5LFoLIrFj9
	YJY2lSvos12Ykm7i6ebxaGSovMdm8ayAic921VSdFJwxXwhkv40HbRajLfLpmkXSYpzAq62hTqO
	X85+AJ4u57w5zOVsgQ2KcfgBTuiFOfRTlVymcitMdKtMlCnI9GaaDf4oZBqsL5q9qIRW/v3v69u
	P9YQUrFLZFK97WR4azI1L5QMCNdjGnGEHCssKoVW0aoBtRcft91skvTqbqgvcIU66Bz1uSZVjex
	UahgJ8t7n/yo92lUZFGUkMfA4BvOf6Nd7Ce3inaokugwkXgivDoHfzrLT6xpAwlMQRdA2SSx/UR
	UTfaZd+mi/bWIj4T7RgZRd9DkyPLX9ikIafUzdsO4rX1152woDGGTjF106OEK6tUlIesFnpwZKB
	LKDlzsjrzQJeeZLIZW8sQNzf/5KAfK2ahBS8v/DXM2ksH2mm9dDIKdxEsoRU0xXEI3DevNdC/5r
	+DV4bxJQNHHoZqYYGnUtkK7A=
X-Received: by 2002:a05:600c:8b55:b0:4a1:f736:79f3 with SMTP id 5b1f17b1804b1-4ac17ffb30fmr1981195e9.5.1793305347156;
        Thu, 29 Oct 2026 13:22:27 -0700 (PDT)
Received: from env.. (dynamic-176-003-098-140.176.3.pool.telefonica.de. [176.3.98.140])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4abf7146621sm9424335e9.13.2026.10.29.13.22.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 13:22:26 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: song@kernel.org,
	yukuai@fygo.io,
	mtkaczyk@kernel.org,
	magiclinan@didiglobal.com,
	xiao@kernel.org
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Subject: [RFC PATCH v5 3/4] md: use struct mdu_array_info64 for SET_ARRAY_INFO
Date: Thu, 29 Oct 2026 20:22:07 +0000
Message-ID: <20261029202209.1422567-4-abd.masalkhi@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261029202209.1422567-1-abd.masalkhi@gmail.com>
References: <20261029202209.1422567-1-abd.masalkhi@gmail.com>
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The md control device passes array information as struct
mdu_array_info64. Make md_set_array_info() and update_array_info()
take the new struct mdu_array_info64, so that the md control device
and the old SET_ARRAY_INFO ioctl can share them.

md_set_array_info() no longer checks for a negative major_version:
the field is unsigned now, and the existing check against the size
of super_types still rejects such values.

md_setup_drive() uses a struct mdu_array_info64 directly.

Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
---
 drivers/md/md-autodetect.c |  2 +-
 drivers/md/md.c            | 37 +++++++++++++++++++++++++++++++------
 drivers/md/md.h            |  4 ++--
 3 files changed, 34 insertions(+), 9 deletions(-)

diff --git a/drivers/md/md-autodetect.c b/drivers/md/md-autodetect.c
index 9ba061f1a628..227cd4a688a5 100644
--- a/drivers/md/md-autodetect.c
+++ b/drivers/md/md-autodetect.c
@@ -124,7 +124,7 @@ static void __init md_setup_drive(struct md_setup_args *args)
 {
 	char *devname = args->device_names;
 	dev_t devices[MD_SB_DISKS + 1], mdev;
-	struct mdu_array_info_s ainfo = { };
+	struct mdu_array_info64 ainfo = { };
 	struct mddev *mddev;
 	int err = 0, i;
 	char name[16];
diff --git a/drivers/md/md.c b/drivers/md/md.c
index ae893c6296ba..3b4497b615cf 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7904,12 +7904,11 @@ static int set_bitmap_file(struct mddev *mddev, int fd)
  *  The minor and patch _version numbers are also kept incase the
  *  super_block handler wishes to interpret them.
  */
-int md_set_array_info(struct mddev *mddev, struct mdu_array_info_s *info)
+int md_set_array_info(struct mddev *mddev, struct mdu_array_info64 *info)
 {
 	if (info->raid_disks == 0) {
 		/* just setting version number for superblock loading */
-		if (info->major_version < 0 ||
-		    info->major_version >= ARRAY_SIZE(super_types) ||
+		if (info->major_version >= ARRAY_SIZE(super_types) ||
 		    super_types[info->major_version].name == NULL) {
 			/* maybe try to auto-load a module? */
 			pr_warn("md: superblock version %d not known\n",
@@ -8101,7 +8100,7 @@ static void put_cluster_ops(struct mddev *mddev)
  * Any differences that cannot be handled will cause an error.
  * Normally, only one change can be managed at a time.
  */
-static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
+static int update_array_info(struct mddev *mddev, struct mdu_array_info64 *info)
 {
 	int rv = 0;
 	int cnt = 0;
@@ -8314,9 +8313,33 @@ static void disk_info_to64(struct mdu_disk_info64 *info64, mdu_disk_info_t *info
 	info64->state = info->state;
 }
 
+static void array_info_to64(struct mdu_array_info64 *info64,
+			    mdu_array_info_t *info)
+{
+	info64->major_version = info->major_version;
+	info64->minor_version = info->minor_version;
+	info64->patch_version = info->patch_version;
+	info64->level = info->level;
+	info64->ctime = info->ctime;
+	info64->size = info->size;
+	info64->nr_disks = info->nr_disks;
+	info64->raid_disks = info->raid_disks;
+	info64->md_minor = info->md_minor;
+	info64->not_persistent = info->not_persistent;
+	info64->utime = info->utime;
+	info64->state = info->state;
+	info64->active_disks = info->active_disks;
+	info64->working_disks = info->working_disks;
+	info64->failed_disks = info->failed_disks;
+	info64->spare_disks = info->spare_disks;
+	info64->layout = info->layout;
+	info64->chunk_size = info->chunk_size;
+}
+
 static int __md_set_array_info(struct mddev *mddev, void __user *argp)
 {
 	mdu_array_info_t info;
+	struct mdu_array_info64 info64 = {0};
 	int err;
 
 	if (!argp)
@@ -8324,8 +8347,10 @@ static int __md_set_array_info(struct mddev *mddev, void __user *argp)
 	else if (copy_from_user(&info, argp, sizeof(info)))
 		return -EFAULT;
 
+	array_info_to64(&info64, &info);
+
 	if (mddev->pers) {
-		err = update_array_info(mddev, &info);
+		err = update_array_info(mddev, &info64);
 		if (err)
 			pr_warn("md: couldn't update array info. %d\n", err);
 		return err;
@@ -8341,7 +8366,7 @@ static int __md_set_array_info(struct mddev *mddev, void __user *argp)
 		return -EBUSY;
 	}
 
-	err = md_set_array_info(mddev, &info);
+	err = md_set_array_info(mddev, &info64);
 	if (err)
 		pr_warn("md: couldn't set array info. %d\n", err);
 
diff --git a/drivers/md/md.h b/drivers/md/md.h
index a84c8b97fa2c..27de34a8bdf9 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -1042,12 +1042,12 @@ static inline void mddev_unlock_and_resume(struct mddev *mddev)
 	mddev_resume(mddev);
 }
 
-struct mdu_array_info_s;
+struct mdu_array_info64;
 struct mdu_disk_info64;
 
 extern int mdp_major;
 void md_autostart_arrays(int part);
-int md_set_array_info(struct mddev *mddev, struct mdu_array_info_s *info);
+int md_set_array_info(struct mddev *mddev, struct mdu_array_info64 *info);
 int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info64 *info);
 int do_md_run(struct mddev *mddev);
 #define MDDEV_STACK_INTEGRITY	(1u << 0)
-- 
2.43.0

