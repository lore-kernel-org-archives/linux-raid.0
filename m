Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793305346;
	b=S1mjL6U2y7iWrcWfcBKBzUleaE4OZoU4m9wEVxDq7Bv8hh2M8Lyfh9wzVt1F/veBZ7y6
	 dRtImw+qEg+xuwws5fWNtAlrQOaqbjpw74LyE9S4VA6z1SfZKJRX/rPCA+9LI414CqxXs
	 VjA1lsuu1A9uW3hTmM0KodtsbtBuaEQ9gpHIdMkva7kiMGNhDWXlbmaQP7h6zvXfkPgRg
	 GfO+3uTN4b3RdZD5JB0gH+1BUVU4iqVHD+9XctFeLAzH90qEq0yM/Lpuv8HjtBi3fgOy6
	 +i0UnBydTXQH5ZvlhVbyA1lds8wL4W5A+R02mhXvexyYHUOM/h5HOYi4vtO3K4M3FFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793305346;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=d5xdLg9rAjWYh0/cl+k2oxrUt58t/79pNohrY47ReRQ=;
	b=vofDCMfxreCDoXw8+Fpg/51ocQs7UiIX+h6oQfNYAzsgzerPds7iQsFOdxYtOIajIuqF
	 EUKW7VYzRky28rk1VFnCCIk2+jXuj6429OnhjJoIBR3XTt4qGb21JVoqHOrbvqZmBgC7M
	 930q6UYQM3N1venDV6NO82DsxLML34WpJgYMw9V7bLNEFWDUpP0uDcTSJGTkGI6Ba4zXV
	 SGtFDlo8P6+/y218GICzCrxw+hmu+JuSz9iot8saphn6+gS73ZH4YwZ+zNlv3MuAPMJ+w
	 iuP8mB/3Jzhdl6UCl6Kkr0a/bwBObwr4CDYSZt0KygurK4KBwnEolfsFawluDo4iUcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=HEonZHni;
	arc=none smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E82CB606A32A
	for <linux-raid@vger.kernel.org>; Thu, 29 Oct 2026 20:22:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E82CB606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=HEonZHni
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a2153c8525so19471565e9.3
        for <linux-raid@vger.kernel.org>; Thu, 29 Oct 2026 13:22:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793305344; x=1793910144; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=d5xdLg9rAjWYh0/cl+k2oxrUt58t/79pNohrY47ReRQ=;
        b=HEonZHniVL1vHgK6XVvwEa0vy47NPTvTBWzdrkMvmDrh3PrF7h5dZg6qak8DwRk3ni
         KGLZC/SDzhkEbbF9E5cpkEfoTKwSdH5nKUpz8ly/mcP4a80k8lxNgg0D8jeTs1j0ACv6
         2NNV1gqzG0JpmGZZUAb5YlqbEQVyzRdaE2r1HoLiLe+Vaes+C0Q0NCYKDL5IO9+diqkR
         PPd8YE9DAY/nkDJ882kx+KWbrgQnjyy+OWfN5p+N+yhxDyEciPd+pGIVwdKsQs2D80wo
         OA1aZnOCzF2mxeBEGSVW0Mj7E4tS9UeUIzMQNlkK7hFbPfRNKnf3GCRbdgynvWZ+PBkk
         4DXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793305344; x=1793910144;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=d5xdLg9rAjWYh0/cl+k2oxrUt58t/79pNohrY47ReRQ=;
        b=RX4kk/hAOfPgRXlQu1F94g6CCkbLeEYSvPDa0foNqyJWhrO6FFtM8kdRZjOcsw8Asz
         HWwAqVC0kjOQyvU6qbIjcVmCLNTBuxCkzbtnHry6yl+zbFxxjqRtUcwcuRnA/jfaKc4H
         GRt8WJnwpWMQcnPdyV9dmBday8eIsOwNM/+BAnR4ipoXD42tKbYVdJ85q6+bSQHSUovo
         T8V6n2pQ15FXyLxWuVRHsqtKQnoTN/TeOMNiSMeQu5hZ/jMHUOfZPnCczLV5eW1KruUo
         fDD0C5YJ5f3bjeyzGX6DjL9cgGaR22XxOABUnB24KmmDBcrU/ZCAP5pSPVE2XDb1cnNr
         +NPg==
X-Gm-Message-State: AFq9FYIeLC0NUWuXn+3D62FFyupUX0mXYJxlGD3PwXAVasJSs4INAZRY
	mLN+vrrGZPk+WaY/RzQmBOwG38+vJjkdhe5OepuRDxpYrkhyngXh1pxQ
X-Gm-Gg: AYBFou1vAyjxEBibjYpy0V3Jw9i+0LsLBbTGWIlLdx5376IFnRPNf3p0H9HY+SdmDNT
	gTiVsdtU4TGb1GGZDxsmP6pCkZgKseOJP0E8ZSclo9oHKy1ZNumK7yX/JyezM7sAmEMCHApOvr9
	1JL2IALt71COCMIaejjJNWOntruaUBes4KsccCuwz13DfAZ10ohfcEKob1Kxu7p43osD6+YJBwP
	hOTnBUvCFZt76A1JV0FzkwlvPbNczDsjZrz9JBLpWb6+27Hb/karAIpTJh04NpbDkG3K5tOtIcz
	j+90rIQ/pM9Gnmy6+Gv3gCUqzEBPxafb4wG+TbZkVaziThp46ZxnRpg86I9I4EP2u8KHmclQfYt
	2TXx4CFi5LPWQdo/dGDrKHeWIl0XMHi1WCEgXyVwW5bbkShM4ztWM2iWoinbphLW1rY8A9SurU+
	IBow4nPCXAfycMTcr+ABQZ5Y5aRCOTmvc2nUHj8TtTEIR+DYbE41+LfFtuDCywcxYPrDcMwtOsm
	1ZpN9S0j11pQPld/km+THERzVLaYpwBSX1rRpCwxdq0E0sAUGJsl8GGGB6qA64P1uQhZV1bLyZI
	tMDExsDx8moLoFkkqvWN5o+oGrlJjMVsP4Dy980uniFyWIyggW2UIlLf0hM7k/mXxgx1MBjSAUB
	mPkg=
X-Received: by 2002:a05:600c:4ece:b0:4a2:40:8d2c with SMTP id 5b1f17b1804b1-4ac17b2c396mr1900095e9.26.1793305344259;
        Thu, 29 Oct 2026 13:22:24 -0700 (PDT)
Received: from env.. (dynamic-176-003-098-140.176.3.pool.telefonica.de. [176.3.98.140])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4abf7146621sm9424335e9.13.2026.10.29.13.22.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 13:22:23 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: song@kernel.org,
	yukuai@fygo.io,
	mtkaczyk@kernel.org,
	magiclinan@didiglobal.com,
	xiao@kernel.org
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Subject: [RFC PATCH v5 2/4] md: pass struct mdu_disk_info64 to md_add_new_disk()
Date: Thu, 29 Oct 2026 20:22:06 +0000
Message-ID: <20261029202209.1422567-3-abd.masalkhi@gmail.com>
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

The md control device passes disk information as struct mdu_disk_info64.
Make md_add_new_disk() take this structure, so that the control device
and the old ADD_NEW_DISK ioctl can share it.

The ADD_NEW_DISK ioctl converts its mdu_disk_info_t with the new helper
disk_info_to64(), and md_setup_drive() uses a struct mdu_disk_info64
directly.

No functional change.

Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
---
 drivers/md/md-autodetect.c |  2 +-
 drivers/md/md.c            | 25 ++++++++++++++++++++-----
 drivers/md/md.h            |  4 ++--
 3 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/drivers/md/md-autodetect.c b/drivers/md/md-autodetect.c
index 4b80165afd23..9ba061f1a628 100644
--- a/drivers/md/md-autodetect.c
+++ b/drivers/md/md-autodetect.c
@@ -201,7 +201,7 @@ static void __init md_setup_drive(struct md_setup_args *args)
 	err = md_set_array_info(mddev, &ainfo);
 
 	for (i = 0; i <= MD_SB_DISKS && devices[i]; i++) {
-		struct mdu_disk_info_s dinfo = {
+		struct mdu_disk_info64 dinfo = {
 			.major	= MAJOR(devices[i]),
 			.minor	= MINOR(devices[i]),
 		};
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 154ee5a65cb7..ae893c6296ba 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7486,7 +7486,7 @@ static int get_disk_info(struct mddev *mddev, void __user * arg)
 	return 0;
 }
 
-int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info)
+int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info64 *info)
 {
 	struct md_rdev *rdev;
 	dev_t dev = MKDEV(info->major,info->minor);
@@ -8305,6 +8305,15 @@ static bool md_ioctl_need_suspend(unsigned int cmd)
 	}
 }
 
+static void disk_info_to64(struct mdu_disk_info64 *info64, mdu_disk_info_t *info)
+{
+	info64->number = info->number;
+	info64->major = info->major;
+	info64->minor = info->minor;
+	info64->raid_disk = info->raid_disk;
+	info64->state = info->state;
+}
+
 static int __md_set_array_info(struct mddev *mddev, void __user *argp)
 {
 	mdu_array_info_t info;
@@ -8452,13 +8461,16 @@ static int md_ioctl(struct block_device *bdev, blk_mode_t mode,
 		 */
 		if (mddev->pers) {
 			mdu_disk_info_t info;
+			struct mdu_disk_info64 info64 = {0};
 			if (copy_from_user(&info, argp, sizeof(info)))
 				err = -EFAULT;
 			else if (!(info.state & (1<<MD_DISK_SYNC)))
 				/* Need to clear read-only for this */
 				break;
-			else
-				err = md_add_new_disk(mddev, &info);
+			else {
+				disk_info_to64(&info64, &info);
+				err = md_add_new_disk(mddev, &info64);
+			}
 			goto unlock;
 		}
 		break;
@@ -8493,10 +8505,13 @@ static int md_ioctl(struct block_device *bdev, blk_mode_t mode,
 	case ADD_NEW_DISK:
 	{
 		mdu_disk_info_t info;
+		struct mdu_disk_info64 info64 = {0};
 		if (copy_from_user(&info, argp, sizeof(info)))
 			err = -EFAULT;
-		else
-			err = md_add_new_disk(mddev, &info);
+		else {
+			disk_info_to64(&info64, &info);
+			err = md_add_new_disk(mddev, &info64);
+		}
 		goto unlock;
 	}
 
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 6440da292105..a84c8b97fa2c 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -1043,12 +1043,12 @@ static inline void mddev_unlock_and_resume(struct mddev *mddev)
 }
 
 struct mdu_array_info_s;
-struct mdu_disk_info_s;
+struct mdu_disk_info64;
 
 extern int mdp_major;
 void md_autostart_arrays(int part);
 int md_set_array_info(struct mddev *mddev, struct mdu_array_info_s *info);
-int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info);
+int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info64 *info);
 int do_md_run(struct mddev *mddev);
 #define MDDEV_STACK_INTEGRITY	(1u << 0)
 int mddev_stack_rdev_limits(struct mddev *mddev, struct queue_limits *lim,
-- 
2.43.0

