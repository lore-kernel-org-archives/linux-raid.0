Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9F11D540
	for <linux-raid@vger.kernel.org>; Mon, 21 Jul 2025 12:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753102137; cv=none; b=KlGnnQqmWTam/wiXD8DIMIb3i/hFw2CA6kCcCmH3LWB0H3FcLsx3RMz7wvxtVNM6qmZNde0+Rc0ZSCl6xW6lTEA2Gqohqiih+M7pMYf7VfexlethQFLZbo+yrbRIwnUhz/uTrIBXsIhzLBjOZ1VwtyFhopxtd0feW6aJKLNDth4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753102137; c=relaxed/simple;
	bh=4GE52SiGJB/ojEwjnOxVeIjWYPfHFUMmPmk2SPFAcc0=;
	h=Message-ID:Date:MIME-Version:To:CC:From:Subject:Content-Type; b=hXzEJ1lN6lg5BMK9OIoLpd7R6ds+bxRVXwwi+U5MCyVTIsQDc+YUbjJNr39r+f+gNX9PMsj71PyAemEpzpyLeZoqLhhFemMPrzfxnn8Ao929Y0fT7KAylSLO9SBaAhi44YtDWJ7KTeM2/+utCe7sBdsi8J2L4iDImp8nMwxS6Qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4bm0Tj4xDQzdc2W;
	Mon, 21 Jul 2025 20:44:41 +0800 (CST)
Received: from kwepemg500011.china.huawei.com (unknown [7.202.181.72])
	by mail.maildlp.com (Postfix) with ESMTPS id 3ACA8180478;
	Mon, 21 Jul 2025 20:48:51 +0800 (CST)
Received: from [10.174.187.148] (10.174.187.148) by
 kwepemg500011.china.huawei.com (7.202.181.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 21 Jul 2025 20:48:50 +0800
Message-ID: <3a9fa346-1041-400d-b954-2119c1ea001c@huawei.com>
Date: Mon, 21 Jul 2025 20:48:50 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
To: <linux-raid@vger.kernel.org>, <yukuai@kernel.org>
CC: <yangyun50@huawei.com>, <linan666@huaweicloud.com>
From: Wu Guanghao <wuguanghao3@huawei.com>
Subject: [PATCH] mdadm supports --logical-block-size option
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemg500011.china.huawei.com (7.202.181.72)

Links: https://lore.kernel.org/linux-raid/20250719083119.1068811-1-linan666@huaweicloud.com/T/#t
The kernel supports configuring the logical block size in this patches,
and mdadm needs to provide the corresponding parameters.

When creating a RAID device, you can specify the logical block size.

Signed-by-off: Wu Guanghao <wuguanghao3@huawei.com>
---
 ReadMe.c |  2 ++
 mdadm.c  | 31 +++++++++++++++++++++++++++++++
 mdadm.h  |  2 ++
 super0.c |  2 ++
 super1.c |  2 ++
 5 files changed, 39 insertions(+)

diff --git a/ReadMe.c b/ReadMe.c
index c2415c26..137a80c9 100644
--- a/ReadMe.c
+++ b/ReadMe.c
@@ -149,6 +149,7 @@ struct option long_options[] = {
 	{"home-cluster", 1, 0, ClusterName},
 	{"write-journal", 1, 0, WriteJournal},
 	{"consistency-policy", 1, 0, 'k'},
+	{"logical-block-size", 1, 0, LogicalBlockSize},

 	/* For assemble */
 	{"uuid", 1, 0, 'u'},
@@ -331,6 +332,7 @@ char Help_create[] =
 "  --consistency-policy= : Specify the policy that determines how the array\n"
 "                     -k : maintains consistency in case of unexpected shutdown.\n"
 "  --write-zeroes        : Write zeroes to the disks before creating. This will bypass initial sync.\n"
+"  --logical-block-size= : Set the logical block size (in Byte) for the RAID.\n"
 "\n"
 ;

diff --git a/mdadm.c b/mdadm.c
index 14649a40..50d39f67 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -76,6 +76,32 @@ static mdadm_status_t set_bitmap_value(struct shape *s, struct context *c, char
 	return MDADM_STATUS_ERROR;
 }

+#define BLK_MAX_BLOCK_SIZE	0x10000  /* 64K */
+/* is x a power of 2? */
+#define is_power_of_2(x)	((x) != 0 && (((x) & ((x) - 1)) == 0))
+
+static mdadm_status_t set_logical_block_size(struct shape *s, char *optarg)
+{
+	char *end;
+	int  size = strtol(optarg, &end, 10);
+
+	if (end != optarg + strlen(optarg)) {
+		pr_err("Logical block size [%s] can't be converted to an integer\n", optarg);
+		return MDADM_STATUS_ERROR;
+	} else if (errno == ERANGE) {
+		pr_err("Logical block size [%s] more than LONG_MAX.\n", optarg);
+		return MDADM_STATUS_ERROR;
+	}
+
+	if (size < 512 || size > BLK_MAX_BLOCK_SIZE || !is_power_of_2(size)) {
+		pr_err("Logical block size [%s] is invalid\n", optarg);
+		return MDADM_STATUS_ERROR;
+	}
+
+	s->logical_block_size = size;
+	return MDADM_STATUS_SUCCESS;
+}
+
 static int scan_assemble(struct supertype *ss,
 			 struct context *c,
 			 struct mddev_ident *ident);
@@ -116,6 +142,7 @@ int main(int argc, char *argv[])
 		.consistency_policy	= CONSISTENCY_POLICY_UNKNOWN,
 		.data_offset = INVALID_SECTORS,
 		.btype		= BitmapUnknown,
+		.logical_block_size = 0,
 	};

 	char sys_hostname[256];
@@ -1185,6 +1212,10 @@ int main(int argc, char *argv[])
 				exit(2);
 			}
 			continue;
+		case O(CREATE, LogicalBlockSize):
+			if (set_logical_block_size(&s, optarg) != MDADM_STATUS_SUCCESS)
+				exit(2);
+			continue;
 		}
 		/* We have now processed all the valid options. Anything else is
 		 * an error
diff --git a/mdadm.h b/mdadm.h
index ce9c216b..dada3ff4 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -502,6 +502,7 @@ enum special_options {
 	ClusterConfirm,
 	WriteJournal,
 	ConsistencyPolicy,
+	LogicalBlockSize,
 };

 enum update_opt {
@@ -663,6 +664,7 @@ struct shape {
 	unsigned long long data_offset;
 	int	consistency_policy;
 	change_dir_t direction;
+	int	logical_block_size;
 };

 /* List of device names - wildcards expanded */
diff --git a/super0.c b/super0.c
index 4a462bdc..15a1ac17 100644
--- a/super0.c
+++ b/super0.c
@@ -830,6 +830,8 @@ static int init_super0(struct supertype *st, mdu_array_info_t *info,
 	sb->layout = info->layout;
 	sb->chunk_size = info->chunk_size;

+	sb->logical_block_size = s->logical_block_size;
+
 	return 1;
 }

diff --git a/super1.c b/super1.c
index 84d73573..f783c4a5 100644
--- a/super1.c
+++ b/super1.c
@@ -1591,6 +1591,8 @@ static int init_super1(struct supertype *st, mdu_array_info_t *info,
 	if (s->consistency_policy == CONSISTENCY_POLICY_PPL)
 		sb->feature_map |= __cpu_to_le32(MD_FEATURE_PPL);

+	sb->logical_block_size = s->logical_block_size;
+
 	return 1;
 }

-- 
2.45.2
