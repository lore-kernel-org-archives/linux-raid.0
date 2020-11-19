Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B05FAC6369E
	for <linux-raid@archiver.kernel.org>; Thu, 19 Nov 2020 11:42:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36618246F1
	for <linux-raid@archiver.kernel.org>; Thu, 19 Nov 2020 11:42:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="iVe2W14M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727127AbgKSLmK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 19 Nov 2020 06:42:10 -0500
Received: from de-smtp-delivery-52.mimecast.com ([51.163.158.52]:55507 "EHLO
        de-smtp-delivery-52.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725843AbgKSLmI (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Thu, 19 Nov 2020 06:42:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1605786125;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=cmcIjFIbtvBBScGlkST5GqjI2+Ov1HAFOGsHJN5t9ek=;
        b=iVe2W14MFIh/LL275a4sP3z+F5W0pF44BxKeKlo6TmZgEUbeHbBi3UkcdQmxLDSfFLYqEV
        Sq2t+jcOpxss7bNXqAVhrba6KMWOWox9xHfxM0MFsNPFE85Awm4fug9vyj50xDPMh24WG3
        gbtjgzIrdNIibCjKlhqmlnsKIZkQGsE=
Received: from EUR02-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur02lp2051.outbound.protection.outlook.com [104.47.6.51]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-27-y3o0qDBjNHi5orSczFWmOg-1; Thu, 19 Nov 2020 12:42:03 +0100
X-MC-Unique: y3o0qDBjNHi5orSczFWmOg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LcMTmckGIa00F4KOHf/oWcX6RqLjHxfksMLLPEuPosDhX5uUMlzEsE8P5j2ZdwSk0ZyAfan9Cm2oqE5X5W88cIUDRpCuZi4QKo8Lmk4IqvAiUfgDPDhNmo4CrVxRH9wyVgSRSCKjg8SLoyDC7+AWDhta0FDiqFYoP3GUlDxcfAAqqaaM+Tf0hoOn5UluOK0mnEm8lCBZOTVQIhSQhL1ESywrcUNbtB3O0XCajqNKFkoFaetW79JX8xMpPgXF4gJba8jbFhMHgawsW9wqv3B0h9qSaWN6tSJMr4ue8Kw4aiy+8E4s4MMb7pHmzx/7WOhbj9wlht1pxwXh4mghdJaF7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cmcIjFIbtvBBScGlkST5GqjI2+Ov1HAFOGsHJN5t9ek=;
 b=VdqTyFSk0e08ZiJLOCdM6Ynzj5f0U7Tl9I+SbAWFQv+LxcOBjsTHQTVykOnpQJ0HBddcZQp1PH9UNtQk2YswGj4u9pa7lHM9/Atfg/59EjzM5uKOXJqOvTo7/a0oBtmUjsPFTo14IODth2J68eoOBRy0cZL2FNMwbPLoSYFdpyqLMEPN7amaWccT/keRGU9/HW2USq+C6gkIC4ZtSCHYCLsptgEqzgTKqmvKfIsF6sQfg7biSPkEYwYrIX8y28RkExjecbO5/ZRMwV77QYKnP1iGmI86ysJJ1iIa1WSxHsel9ZMEeI8ht8UmgrjopgTVBgAHrDZUpcOM7J1LVq7Jgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB7PR04MB4668.eurprd04.prod.outlook.com (2603:10a6:5:3a::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3564.25; Thu, 19 Nov 2020 11:42:02 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::1c22:83d3:bc1e:6383]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::1c22:83d3:bc1e:6383%4]) with mapi id 15.20.3564.028; Thu, 19 Nov 2020
 11:42:02 +0000
From:   Zhao Heming <heming.zhao@suse.com>
To:     linux-raid@vger.kernel.org, song@kernel.org,
        guoqing.jiang@cloud.ionos.com, xni@redhat.com
Cc:     Zhao Heming <heming.zhao@suse.com>, lidong.zhong@suse.com,
        neilb@suse.de, colyli@suse.de
Subject: [PATCH v4 0/2] md/cluster bugs fix
Date:   Thu, 19 Nov 2020 19:41:32 +0800
Message-Id: <1605786094-5582-1-git-send-email-heming.zhao@suse.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-Originating-IP: [123.123.130.58]
X-ClientProxiedBy: HKAPR03CA0033.apcprd03.prod.outlook.com
 (2603:1096:203:c9::20) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.130.58) by HKAPR03CA0033.apcprd03.prod.outlook.com (2603:1096:203:c9::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.15 via Frontend Transport; Thu, 19 Nov 2020 11:41:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4b889f65-7bba-465b-59ca-08d88c802174
X-MS-TrafficTypeDiagnostic: DB7PR04MB4668:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB4668FF2F505B3E2648A2A12A97E00@DB7PR04MB4668.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i66oqvQoy2k5p4VLZWp7DbvP+VUrrpoKkHubWnrMd5x1nki22RNchq5TggJPJKolyS3CzghCbqysqQ6yhv3vEceTCinQ+8n1RtNQ1yAV/Br8OonGTuqmLFqirw5eRm+2VbH5nUosVfQacIAzrtm/GBqM5Wy3SiUC0QsOMUlsgP7GNXxsQGn/VpFekGNb9X+2dYChGNzEE3wimiC+xL6TiXylVIeVAnm+cuWrU40Ix+WhMTXOOXoZfbv+YDDmK6Obi1fcqFy0zSte0AUANQd1LwV5udoGDyxhXu/GA4NpW/+xcAwiiCGTiNe0sjbcShoLwuMwSFn1nN4aThsY4i/EJpHZM6btHMRa4Fwqs59NSJB8z5OAMiyFSkf82J6AEvAq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(366004)(136003)(396003)(39860400002)(956004)(36756003)(6486002)(2906002)(66476007)(66556008)(66946007)(6512007)(6506007)(2616005)(5660300002)(86362001)(316002)(478600001)(52116002)(16526019)(6666004)(4326008)(8886007)(8676002)(83380400001)(186003)(26005)(8936002)(9126006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: RXxX2tmvu7D3D1lwwpYDC6qdDM8NmxQ7Ttd8UvULyyUTbBCv4dMpNmqNHFqUW1Ys2HT3qlGdUcEVsBaGkA87UKclVSzOXdiBHAD54jZBGEq5Fi4ClXfgtDv+VMCZR0plxFouT+unil8JOz/N16X18ZVu4ZAJX2fN7chTYCI/tYkLl85V1n63YEcdMBPaXNnhvqqTKw7TGurzqevJ++ctAyNsS4XYtmqmsiNWcTBIWAIpFIyRhP6g2o+WZ8ym5iNUTHHSIKdIJsjyd9hN53LMsBmXx/XqCwqsRpgMMHsff5hz8NZvt7Q4hQj4dacVRW9Zr43WemK9AbXmu2y/sxkXmR5yQN/1hT//uBeV8PrpgG0czjSyPnH4NkZ61MJ0i5XLEqGQe4K6WYjOqnwhWWBO8IhIDg1WTsD2arBNFkfw6t/yCzDJz8swvxsmMzksl/hAbpNTdTB0eUywPVuDC5lnelBQMyNlEbmm2HFMywk4RNj1C9Q02b8UkDHCgM72WJGMi+uWId8oD2IVsH48gq18SvT7/37s2IZq5G057DmOYEZ4KAyYCci84QZOg8OUcqVRzSPin+rtMUxEdVzmPiRLrEd4TqfB8kNJ/q78OMC8lKJz+jf9SP1MtGgvXOVn6Mhyo9GxNyT8P8a5k3Cp23YOpw==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b889f65-7bba-465b-59ca-08d88c802174
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2020 11:42:02.1608
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hz4ehoj1CHV5dAKQlDdOz7CNQwVN4ZT5yTvQoCXJEl1daqSxj3lGZGb/A5lktBRG9Xb/EtsqkR5aUCs/DqJfGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4668
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello List,

There are two patches to fix md-cluster bugs.

The 2 different bugs can use same test script to trigger:

```
ssh root@node2 "mdadm -S --scan"
mdadm -S --scan
for i in {g,h,i};do dd if=/dev/zero of=/dev/sd$i oflag=direct bs=1M \
count=20; done

echo "mdadm create array"
mdadm -C /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sdg /dev/sdh \
--bitmap-chunk=1M
echo "set up array on node2"
ssh root@node2 "mdadm -A /dev/md0 /dev/sdg /dev/sdh"

sleep 5

mkfs.xfs /dev/md0
mdadm --manage --add /dev/md0 /dev/sdi
mdadm --wait /dev/md0
mdadm --grow --raid-devices=3 /dev/md0

mdadm /dev/md0 --fail /dev/sdg
mdadm /dev/md0 --remove /dev/sdg
mdadm --grow --raid-devices=2 /dev/md0
```

For detail, please check each patch commit log.

-------
v4:
- revise subject & commit log on both patches
- no change for code
v3:
- patch 1/2
  - no change
- patch 2/2
  - use Xiao's solution to fix
  - revise commit log for the "How to fix" part
v2:
- patch 1/2
  - change patch subject
  - add test result in commit log
  - no change for code
- patch 2/2
  - add test result in commit log
  - add error handling of remove_disk in hot_remove_disk
  - add error handling of lock_comm in all caller
  - remove 5s timeout fix in receive side (for process_metadata_update)
v1:
- create patch
-------
Zhao Heming (2):
  md/cluster: block reshape with remote resync job
  md/cluster: fix deadlock when node is doing resync job

 drivers/md/md-cluster.c | 69 +++++++++++++++++++++++------------------
 drivers/md/md.c         | 14 ++++++---
 2 files changed, 49 insertions(+), 34 deletions(-)

-- 
2.27.0

