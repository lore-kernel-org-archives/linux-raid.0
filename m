Return-Path: <SRS0=UpcO=D7=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31736C2D0A3
	for <linux-raid@archiver.kernel.org>; Sat, 24 Oct 2020 15:07:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D489B20757
	for <linux-raid@archiver.kernel.org>; Sat, 24 Oct 2020 15:07:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="jFZiDLIZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1755245AbgJXPHk (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 24 Oct 2020 11:07:40 -0400
Received: from de-smtp-delivery-102.mimecast.com ([51.163.158.102]:36562 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755236AbgJXPHk (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Sat, 24 Oct 2020 11:07:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1603552057;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=56onaHx+nPEANTl4ti7b2zY80QcaaSMRPMwUFPAyW0o=;
        b=jFZiDLIZK4Puc8dIh3K8vxzCLLKaIWKqi6WJ+WgKh7Ri3wdHS5+OEF2I4al3x31o5mX/+z
        gGOxtL69sjBTDw7JD7gqs5YxoesAyKMigFWDTjIcSJadsqbIVObCg2IMo/bw4feubn9YjO
        UqFbSoFP868LrXAgzkRH76GkSVJ6uXc=
Received: from EUR02-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur02lp2058.outbound.protection.outlook.com [104.47.5.58]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-39-Xu-C7zMpMCudiHd0N_mf_g-1; Sat, 24 Oct 2020 17:07:35 +0200
X-MC-Unique: Xu-C7zMpMCudiHd0N_mf_g-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V3r0hTfTMzNi+nqEcdJAROEuZYqtL5AL3atUNgJ70PD+JySgyfVrCeHMPJBfoJsJPzacy+RgmR03Yz4HrpzTv14EepmBmGsJCEgzK1vFjLOgKjmgIsssZhj9TLW60j6RvfzP2nD35x//1E1yl7Jjv6AINxcJdVK6/hOqBwOUvC1nwj9nGC3bSlQ4v+Dh8QLVLp+UWEZB6GQqgPfWEdR5GEtjaM8v1rLo7y05qo7iLiTy9LY3Rocc//Zv6iYrH5xBbGOPLHDTktaCDmjTU8ezX/swgwu65Fyw+/1TDuI+SmEIJyxxygHNmCREQV7a9iNCX7m5Us5TmCXUvHPTawhhlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=56onaHx+nPEANTl4ti7b2zY80QcaaSMRPMwUFPAyW0o=;
 b=lpUVGRpT2JpEHxDrfsbdpKvEZFqv5X1BHPnuMul0oUv7YiCISY8Xra+17QMRdzHq4FpLR67IWO/NHbs7gBtpTlv8+i0mcNMgKw3FGV4FL+w5+hJ36qB52OBGSjz5A5UlJArY4ACtbtBPYcxMmV7ixXfuZkapce/PabptQBF5SZFS7WXsSjr2VPnCsFxvxAWntiOfZjg8wrXp9vDqyqJpcEqSrHkGxkKw+pl1ZzQmTvrSrMR7QbpFW/zkTILiG7MGKHK8d2i6OjHc/tNTP39k3XrHYwRHIoqDC1K+BBzDTyArVguqqUQ+q6vKs/mlsu6mbt32FNAeWix1+lzaXDC7fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB8PR04MB7004.eurprd04.prod.outlook.com (2603:10a6:10:11c::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3455.26; Sat, 24 Oct 2020 15:07:34 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::197:4f2c:bd9d:ff7a]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::197:4f2c:bd9d:ff7a%7]) with mapi id 15.20.3477.028; Sat, 24 Oct 2020
 15:07:27 +0000
From:   Zhao Heming <heming.zhao@suse.com>
To:     linux-raid@vger.kernel.org, jes@trained-monkey.org,
        guoqing.jiang@cloud.ionos.com
Cc:     Zhao Heming <heming.zhao@suse.com>
Subject: [PATCH] mdadm/bitmap: fix wrong bitmap nodes num when adding new disk
Date:   Sat, 24 Oct 2020 23:07:07 +0800
Message-Id: <1603552027-10655-1-git-send-email-heming.zhao@suse.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-Originating-IP: [123.123.129.82]
X-ClientProxiedBy: HK0PR03CA0101.apcprd03.prod.outlook.com
 (2603:1096:203:b0::17) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.129.82) by HK0PR03CA0101.apcprd03.prod.outlook.com (2603:1096:203:b0::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Sat, 24 Oct 2020 15:07:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c2652a53-ced8-4bfb-3dea-08d8782e850a
X-MS-TrafficTypeDiagnostic: DB8PR04MB7004:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB7004F8751CCE53B4767C20BE971B0@DB8PR04MB7004.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:189;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RmkdjLHF6q4rphnTRi2566SCO69ZphTe0xfZFijj/0MjYKjgB50zUzHNnbNrPKYBFtZyGW9A9MEsuhi2BQKAw72kW3xnKtdUjE72vlJM4A9SpJ2Ugj+BEhn/k5aWNH8xUygDRzMPXYwSK1Xs8q7lolaww26dUxtKBZfFinrH4HC6TjEO9iSVu88hkLPLL7byTuLTzYztURkNmScpE08UDYZ8qcwD6O04pV7pYw6WLTovMhzL7NumC0E6W3FE7UXH522hGJRUecPONgUQijyV5gCBCeRYUSiK7jGdO8o8KITjCuBcw4QtwerWCBqpHchDNS/ZEdGKyelZxTjGk18cPTsRXwNOXYlBbAlgpxPHPiaGeDrW1SsZFuhL58P0xUuK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(39860400002)(366004)(136003)(6512007)(107886003)(2906002)(6486002)(66476007)(8676002)(66556008)(26005)(186003)(66946007)(16526019)(8886007)(6506007)(478600001)(6666004)(5660300002)(36756003)(316002)(4326008)(86362001)(956004)(52116002)(2616005)(8936002)(83380400001)(9126004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: cVhTFmIN/2yUeMS5aOzEJp3j/HKWsptzzLyJ9uLZ3OoBF8W8CYO9yMrTy5ZOKg964WP/dop/5fyDIdYMXJz+RVYJ9nk6ktELChZP1vMNJQLmOkNS4Gx027gS7WFiFgAQ4vpJDucVB/ihvGgmF6OEB3jELoJdWyQrLXWe0b3q6/qKwTVRwFNKEDJ1dfIZZQ84stjaSpjYLS59nHNfYcw+bZF9smBcof54Q5h/JP19EAv/UrHPtFnidt7mLZmI7GwLlRV1+uV+K7qC5YJn+lKa4Wwfei5X9fp2Vuyw4m4n+oqbylVyqJioCtQzhg9vYf/gMo5fbjpmfQ8UT38YW9bvfyDVCjeaVbmK1tfBUozm/R1rxqY17rl9VbawqZ2IsIF5TJ7EXpCa4j39Jj7OkL8iucqXKSwwIripZpePdPtDJzmYB572z3q1CRnR0DOZOygUaQ5udUmGeqyQ2ZIO1TAypE3/bcB/vfALbBAf/s/bNHzgF4FlYSjW9KwhNGCByhKFk/87VmOB7YfjMpwdG09hPBgjM9NMpalpeaI6hT7ASGxBbRZ3p8JseXm+D2xIU7ARrEv4tAOTEj0ISuw7O2MQ1kNsO135D8Pboc9vH9o5aF0lSgdNBPQvRshxS7WRDYevgxMAqynudQl7hDhgEuZ6Jg==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2652a53-ced8-4bfb-3dea-08d8782e850a
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2020 15:07:27.3742
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ec9DA7J+WXmQCDkSdBnVWx8g2L3qatrbd0uhenTgQjA/C4TXqVjZsdSxAnpbSE5ZfWxaqMLrHToeb2DfOvWZcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7004
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The bug introduced from commit 81306e021ebdcc4baef866da82d25c3f0a415d2d
In this patch, it modified two place to support NodeNumUpdate:
 Grow_addbitmap, write_init_super1

The path write_init_super1 is wrong.

reproducible steps:
```
node1 # mdadm -S --scan
node1 # for i in {a,b,c};do dd if=/dev/zero of=/dev/sd$i bs=1M count=10;
done
... ...
node1 # mdadm -C /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sda
/dev/sdb
mdadm: array /dev/md0 started.
node1 # mdadm --manage --add /dev/md0 /dev/sdc
mdadm: added /dev/sdc
node1 # mdadm --grow --raid-devices=3 /dev/md0
raid_disks for /dev/md0 set to 3
node1 # mdadm -X /dev/sdc
        Filename : /dev/sdc
           Magic : 6d746962
         Version : 5
            UUID : 9b0ff8c8:2a274a64:088ade6e:a88286a3
       Chunksize : 64 MB
          Daemon : 5s flush period
      Write Mode : Normal
       Sync Size : 306176 (299.00 MiB 313.52 MB)
   Cluster nodes : 4
    Cluster name : tb-ha-tst
       Node Slot : 0
          Events : 44
  Events Cleared : 0
           State : OK
          Bitmap : 5 bits (chunks), 0 dirty (0.0%)
mdadm: invalid bitmap magic 0x0, the bitmap file appears to be corrupted
       Node Slot : 1
          Events : 0
  Events Cleared : 0
           State : OK
          Bitmap : 0 bits (chunks), 0 dirty (0.0%)
```

There are three paths to call write_bitmap:
 Assemble, Grow, write_init_super.

1. Assemble & Grow should concern NodeNumUpdate

Grow: Grow_addbitmap => write_bitmap
trigger steps:
```
node1 # mdadm -C /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sda
/dev/sdb
node1 # mdadm -G /dev/md0 -b none
node1 # mdadm -G /dev/md0 -b clustered
```

Assemble: Assemble => load_devices => write_bitmap1
trigger steps:
```
node1 # mdadm -C /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sda
/dev/sdb
node2 # mdadm -A /dev/md0 /dev/sda /dev/sdb --update=nodes --nodes=5
```

2. write_init_super should use NoUpdate.

write_init_super is called by Create & Manage path.

Create: Create => write_init_super => write_bitmap
This is initialization, it doesn't need to care node changing.
trigger step:
```
node1 # mdadm -C /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sda
/dev/sdb
```

Manage: Manage_subdevs => Manage_add => write_init_super => write_bitmap
This is disk add, not node add. So it doesn't need to care node
changing.
trigger steps:
```
mdadm -C /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sda /dev/sdb
mdadm --manage --add /dev/md0 /dev/sdc
```

Signed-off-by: Zhao Heming <heming.zhao@suse.com>
---
 super1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/super1.c b/super1.c
index 8b0d6ff..06fa3ad 100644
--- a/super1.c
+++ b/super1.c
@@ -2093,7 +2093,7 @@ static int write_init_super1(struct supertype *st)
 		if (rv == 0 &&
 		    (__le32_to_cpu(sb->feature_map) &
 		     MD_FEATURE_BITMAP_OFFSET)) {
-			rv = st->ss->write_bitmap(st, di->fd, NodeNumUpdate);
+			rv = st->ss->write_bitmap(st, di->fd, NoUpdate);
 		} else if (rv == 0 &&
 		    md_feature_any_ppl_on(sb->feature_map)) {
 			struct mdinfo info;
-- 
2.27.0

