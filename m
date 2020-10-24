Return-Path: <SRS0=UpcO=D7=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35A5DC55178
	for <linux-raid@archiver.kernel.org>; Sat, 24 Oct 2020 09:43:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D34C12226B
	for <linux-raid@archiver.kernel.org>; Sat, 24 Oct 2020 09:43:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="fb5LqdoP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1760504AbgJXJni (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 24 Oct 2020 05:43:38 -0400
Received: from de-smtp-delivery-102.mimecast.com ([51.163.158.102]:55458 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751459AbgJXJnh (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Sat, 24 Oct 2020 05:43:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1603532613;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=1+sV7L2m7BoNCi1p7K7TZYBiC2NwM/vQmABsiiCUzt8=;
        b=fb5LqdoP77ypN8eVtxIJdVexakhsCXHwDze5dQLN48H+EFrXQp/+5p3W6AD5BzxuWg8lEB
        vEZIt5H4flG25VflEV2C9xDKJnciOAQoIVnWXKx83MH1ql2JoCp+v7pkEBNo8jYIA9t6Cq
        WxvPA+dE64hTggJ/UKbdJTAWsWYgS9A=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2177.outbound.protection.outlook.com [104.47.17.177])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-5--91zo8nlOqi7haQakOswNg-1; Sat, 24 Oct 2020 11:43:31 +0200
X-MC-Unique: -91zo8nlOqi7haQakOswNg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SUj5jVm7Wk24kH66YED0voqfZ90b4keuY0srwMbW6q/vXjIJbSkUns1o9nyQAe7bhjVqJ+bxzum48mdtKi94XNJLdt2KgndpNjmnbCIQDG6idemqXusbo4ROLs8Ro/7UaEZhajG69qNAhvGAyFNQcBZc9Jf2uT50OCohcwPX1tcXVfVFNsLWfzbnjCoAeO3wmDLNgNUA+VFEauHMeg0JRlq1nlJXbKMCtBvwxETwrfVE/E/vVg9S52NYNtbScsdox7Fq9bnycM369L5F0Hjkwnf7NwrnhhXU6R7QtHa5PqnpI61i8+KbYSldq5if3HVkZQQBRQaC83DVmawHAYz3sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1+sV7L2m7BoNCi1p7K7TZYBiC2NwM/vQmABsiiCUzt8=;
 b=WHg5X9m3M7gIoTykCv+JJG8k7RL9F/dUApzovFytExrGiRflIZlAPncmj3CKkmN+Eyy0lqPbhqVQzN+5vGQWsV/iE71e0JV9+dhaMR8V/ffx3nDLRq+wyJaz6sTGM2FxmYv1XjnknZWWME6Pz99uIQEA8R6AF14bfQi5+q+gYTUILZH/McY8oMR6x8yDAX9Oi7kzabwIh0+5dRWfbTTro2n8QTq6uw6kzQ0cVGGpxg+0oVILIABOq6dpHJLdNv7lFkCFpBSO4XRUUXtMoMBfM9KOtp0g8KqC94STumevN0YjXJs1mm8Kr4sMdh8DXEUew62KtJbpUaKv+dHLXq+bwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB7PR04MB5452.eurprd04.prod.outlook.com (2603:10a6:10:84::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3477.21; Sat, 24 Oct 2020 09:43:29 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::197:4f2c:bd9d:ff7a]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::197:4f2c:bd9d:ff7a%7]) with mapi id 15.20.3477.028; Sat, 24 Oct 2020
 09:43:29 +0000
From:   Zhao Heming <heming.zhao@suse.com>
To:     linux-raid@vger.kernel.org, jes@trained-monkey.org
Cc:     Zhao Heming <heming.zhao@suse.com>, neilb@suse.de
Subject: [PATCH v5] mdadm/Detail: show correct state for clustered array
Date:   Sat, 24 Oct 2020 17:43:12 +0800
Message-Id: <1603532592-11802-1-git-send-email-heming.zhao@suse.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-Originating-IP: [123.123.129.82]
X-ClientProxiedBy: HK2PR02CA0215.apcprd02.prod.outlook.com
 (2603:1096:201:20::27) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.129.82) by HK2PR02CA0215.apcprd02.prod.outlook.com (2603:1096:201:20::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Sat, 24 Oct 2020 09:43:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c16f6251-8c66-4ed5-59a7-08d87801435d
X-MS-TrafficTypeDiagnostic: DB7PR04MB5452:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB545225D4399D1BCCBA1FEBD8971B0@DB7PR04MB5452.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yUp6gN3OhUh7PLj0Ng0VH9JzJDBo7ZvCqPPQz9nCJb86QBUaol9ChiNVEmAaJ42VgfdweIWWS7HXrR1xHoSDj3PUvu/jnP2fxiBd36IjbZbq4AOiD5tVz9ufhq9wieVicLDcPvxnH0234g8mgn8XIwXDkYdEojVvWL24oQXFTyVk6Vb5AN9IveyfMe/vguibJDFc7Ii9ibPEsL4F5G7GsgQ1069FRHKy/yy9YdMnn/yaR89Hh/LkmrpeBRcM/b2rLYeu8vCXBpJUgRzI67F9tQlSx5xIoyRBgXn+dcBqPk7/j9HM2UTu4ATNMZ2LBXc6hR99xUypLUHqY9VJAJqE6KyQK8UWAvUsuFUW6uPANwU64YE9MZF7x0TOinFxd3FY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(136003)(39860400002)(376002)(346002)(6666004)(8886007)(186003)(956004)(478600001)(4326008)(52116002)(16526019)(6512007)(316002)(36756003)(26005)(86362001)(8936002)(83380400001)(2616005)(5660300002)(66476007)(6506007)(2906002)(66556008)(6486002)(8676002)(66946007)(9126004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 3Bt8+GF0MqaruZn3HC2rfbPql+zJdqjUUI9rmOZxcOpxP6XcwE2bb+A6TeDH9kmsfk+H8X1fj2h0X7/rFO1AYiHDUmOZwcgDNY2NRX1qV5Oi9f3WwLcqFl2/9372LhZdUSIBDFAkQ33YCWGODQn5DuLUxcY/Rl6qI/QeH/1qMKR+QjFk1UEPZX0pEAup31K6Ax8jYMCyt3KJ/32RMJgiNARUTqxJZKh+mKY87tV9FGgIqUPg+/Y4BAcOEUFXaXRxx3BbhEF7BA3h6zfIuwQcDiCCXC140LGrMWYbovOLvnWOGxf3sfxhFfl/j0yfe109RUZvcbfmmfkgRU5SSV7aAZVhG3f0cb6KvxQRtgxprD66RRxtm2STrdHgi3RBCALNZoinoE7icwciMGOQF5PEIAH8uANzHYAA4RYESGTgexpAEZe/6CUvxA/O+EiRa22zd22/xWwWKsS/srE4KposAG3Fqm5vjx0YfM1zzzpGoNh/x8ubwGJkDPwwGZ3wnEDZAi2y8xXyK1/gMr1orDppQKUcokQmO3VGsI7Ko8K1dVRf4Z7JrWb8UK4hyl/u5kHE2HcpdM8xGEMpICxg8ZaIophx/sRVcFwKodD/yq07MPhbXx0Ag+S8+X8PLXP+t11O/5E2zIAcx4u+PEUoqymMHg==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c16f6251-8c66-4ed5-59a7-08d87801435d
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2020 09:43:29.5635
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qA0OItHWWP1CDlJsfwr5lY5d0Qv2rs1TfSw2kFFCK6tuCUZ52DzIK0ec9rPkoG/N68bKkXNLPZc0+FmZiEmALw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5452
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

After kernel md module commit 480523feae581, in clustered env,
mddev->in_sync always zero, it will make array.state never set
up MD_SB_CLEAN. it causes "mdadm -D /dev/mdX" show state 'active'
all the time.

bitmap.c: add a new API IsBitmapDirty() to support inquiry bitmap
dirty or clean.

Signed-off-by: Zhao Heming <heming.zhao@suse.com>
---
v5: (polish code)
- Detail.c: change code logic to only examine valid dev.
- bitmap.c: redesign bitmap_file_open() to support fd reuse. It won't
            make dev multi-opened in clusterd env.
v4:
- Detail.c: follow Jes comment, split if into 2 lines.
v3:
- Detail.c: fix error logic: v2 code didn't check bitmap when dv is
            null.
v2:
- Detail.c: follow Neil comments, change to read only one device.
- bitmap.c: follow Neil comments, modify IsBitmapDirty() to check all
            bitmap on the selected device.

---
 Detail.c | 20 ++++++++++++++-
 bitmap.c | 75 +++++++++++++++++++++++++++++++++++++++++++++++++-------
 mdadm.h  |  1 +
 3 files changed, 86 insertions(+), 10 deletions(-)

diff --git a/Detail.c b/Detail.c
index b6587c8..14cb7f2 100644
--- a/Detail.c
+++ b/Detail.c
@@ -498,8 +498,26 @@ int Detail(char *dev, struct context *c)
 							  sra->array_state);
 				else
 					arrayst = "clean";
-			} else
+			} else {
 				arrayst = "active";
+				if (array.state & (1<<MD_SB_CLUSTERED)) {
+					for (d = 0; d < max_disks * 2; d++) {
+						char *dv;
+						mdu_disk_info_t disk = disks[d];
+
+						/* only check first valid disk in cluster env */
+						if ((disk.state & (MD_DISK_SYNC | MD_DISK_ACTIVE))
+							&& (disk.major | disk.minor)) {
+							dv = map_dev_preferred(disk.major, disk.minor, 0,
+									c->prefer);
+							if (!dv)
+								continue;
+							arrayst = IsBitmapDirty(dv) ? "active" : "clean";
+							break;
+						}
+					}
+				}
+			}
 
 			printf("             State : %s%s%s%s%s%s%s \n",
 			       arrayst, st,
diff --git a/bitmap.c b/bitmap.c
index e38cb96..9a7ffe3 100644
--- a/bitmap.c
+++ b/bitmap.c
@@ -180,13 +180,14 @@ out:
 }
 
 static int
-bitmap_file_open(char *filename, struct supertype **stp, int node_num)
+bitmap_file_open(char *filename, struct supertype **stp, int node_num, int fd)
 {
-	int fd;
 	struct stat stb;
 	struct supertype *st = *stp;
 
-	fd = open(filename, O_RDONLY|O_DIRECT);
+	/* won't re-open filename when (fd >= 0) */
+	if (fd < 0)
+		fd = open(filename, O_RDONLY|O_DIRECT);
 	if (fd < 0) {
 		pr_err("failed to open bitmap file %s: %s\n",
 		       filename, strerror(errno));
@@ -249,7 +250,7 @@ int ExamineBitmap(char *filename, int brief, struct supertype *st)
 	int fd, i;
 	__u32 uuid32[4];
 
-	fd = bitmap_file_open(filename, &st, 0);
+	fd = bitmap_file_open(filename, &st, 0, -1);
 	if (fd < 0)
 		return rv;
 
@@ -263,7 +264,6 @@ int ExamineBitmap(char *filename, int brief, struct supertype *st)
 		pr_err("Reporting bitmap that would be used if this array were used\n");
 		pr_err("as a member of some other array\n");
 	}
-	close(fd);
 	printf("        Filename : %s\n", filename);
 	printf("           Magic : %08x\n", sb->magic);
 	if (sb->magic != BITMAP_MAGIC) {
@@ -332,15 +332,13 @@ int ExamineBitmap(char *filename, int brief, struct supertype *st)
 		for (i = 0; i < (int)sb->nodes; i++) {
 			st = NULL;
 			free(info);
-			fd = bitmap_file_open(filename, &st, i);
+			fd = bitmap_file_open(filename, &st, i, fd);
 			if (fd < 0) {
 				printf("   Unable to open bitmap file on node: %i\n", i);
-
 				continue;
 			}
 			info = bitmap_fd_read(fd, brief);
 			if (!info) {
-				close(fd);
 				printf("   Unable to read bitmap on node: %i\n", i);
 				continue;
 			}
@@ -359,13 +357,72 @@ int ExamineBitmap(char *filename, int brief, struct supertype *st)
 			printf("          Bitmap : %llu bits (chunks), %llu dirty (%2.1f%%)\n",
 			       info->total_bits, info->dirty_bits,
 			       100.0 * info->dirty_bits / (info->total_bits?:1));
-			 close(fd);
 		}
 	}
 
 free_info:
+	close(fd);
+	free(info);
+	return rv;
+}
+
+int IsBitmapDirty(char *filename)
+{
+	/*
+	 * Read the bitmap file
+	 * It will break reading bitmap action immediately when meeting any error.
+	 *
+	 * Return: 1(dirty), 0 (clean), -1(error)
+	 */
+
+	int fd = -1, rv = 0, i;
+	struct supertype *st = NULL;
+	bitmap_info_t *info = NULL;
+	bitmap_super_t *sb = NULL;
+
+	fd = bitmap_file_open(filename, &st, 0, fd);
+	free(st);
+	if (fd < 0)
+		goto out;
+
+	info = bitmap_fd_read(fd, 0);
+	if (!info) {
+		close(fd);
+		goto out;
+	}
+
+	sb = &info->sb;
+	for (i = 0; i < (int)sb->nodes; i++) {
+		st = NULL;
+		free(info);
+		info = NULL;
+
+		fd = bitmap_file_open(filename, &st, i, fd);
+		free(st);
+		if (fd < 0)
+			goto out;
+
+		info = bitmap_fd_read(fd, 0);
+		if (!info) {
+			close(fd);
+			goto out;
+		}
+
+		sb = &info->sb;
+		if (sb->magic != BITMAP_MAGIC) { /* invalid bitmap magic */
+			free(info);
+			close(fd);
+			goto out;
+		}
+
+		if (info->dirty_bits)
+			rv = 1;
+	}
+	close(fd);
 	free(info);
 	return rv;
+out:
+	return -1;
 }
 
 int CreateBitmap(char *filename, int force, char uuid[16],
diff --git a/mdadm.h b/mdadm.h
index 4961c0f..21aa547 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1447,6 +1447,7 @@ extern int CreateBitmap(char *filename, int force, char uuid[16],
 			unsigned long long array_size,
 			int major);
 extern int ExamineBitmap(char *filename, int brief, struct supertype *st);
+extern int IsBitmapDirty(char *filename);
 extern int Write_rules(char *rule_name);
 extern int bitmap_update_uuid(int fd, int *uuid, int swap);
 
-- 
2.27.0

