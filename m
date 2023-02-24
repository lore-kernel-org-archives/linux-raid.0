Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFEE2C61DA4
	for <linux-raid@archiver.kernel.org>; Fri, 24 Feb 2023 00:13:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbjBXANA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 23 Feb 2023 19:13:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjBXAM6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 23 Feb 2023 19:12:58 -0500
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2060e.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe1a::60e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C89113D50
        for <linux-raid@vger.kernel.org>; Thu, 23 Feb 2023 16:12:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HPmZyoztWm4q1lYinCNsxHVGlbt8/9NLdsUQDWYROUilAhdKkGE2COfPtMRzQqvKtQxoYflSSRj/tEDlxrtP5ZsY0kdnd8xhubd0CXgLrtLG8FSvnACDy7ov+QUUl7Wk35yA8VgwUc44lt62Ig5b+so+MdqfyZLXlAQDZXCLi0wJ2D4PAalPcM0UMGUCOKuMJNVH32ExicBSiAMkZxvXDkc8TGAwR/6rFpZDeGxKPH20QuVo5U6TOvnHzeOKJ4do2CVZgBJRTq+AGsnfJunWVLbXnBd/1Wtc23NwtJiREhbN9InuKpSsdaIXx9doezqHWQmEFYpXwOVu3vpOWFrJng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XhHJvnpMk3rsIgEfkDuq2df1xT4HIEfi6/TI/tWstPw=;
 b=h1v8kz2an705cdEzUrqBYHNdENzAM38v3L/WVHcOmnFth1c/9Xw+LRT05dyH+tLG60N7Kuao/dYFlC4Z/fVxHLxTZCLmMVg1ydXLz30ZCA3SssO49pyixFQ1OX90sWUa0tKXj8dgvS2Gy56MVMGLrCsg5uhcBegi2e7Jmh5zHXbtetHfykBxQNLCJSzEUAYEZDVv2x4T67h+OAth6Ho+yX9WVmKi2DP+uUPFMpmXjqrdrrQ2pRONCIFnKnxUrgJ8xL7G/FRJEDKXATalxYmBgP3Gn3Kve7gmSGG0iIx/NVs66ZCrNZWF9gu87Fd9x2MYDYvMXxWXYmsRhoQ1IYgiEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XhHJvnpMk3rsIgEfkDuq2df1xT4HIEfi6/TI/tWstPw=;
 b=Qjg+yhU9HdD9omWtfhAWkbQQCD/557zPHhXTJvahK9fUV53lOmDyyWU0uQvlOfZy8Itgk5gRqK07A6UpMXeSQvI4VRkrn6hFmXBX0v8+2+kCc/ZIa5QMzuqLelItAzJ73jn7nvMB6FQY2fvB4c5XaCOwG7ORdUnEdUyNVbN6SwHAxb6ZFvUEV5bkxHGmus+8wihUdfdN7lf/5NlDFdAuZF0WU2UL2ZKA6IwBKf+7nJTFzJE/azvBgx89hwwSBw1XBpEPcefZGHvoepe31Zo9k1b6Y/TOCi2f7MVGydvxXMCYMWV71FL8T82iBt2SQDv5FWLtS5bZG6FiRyNFqbEg/Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from PA4PR04MB7997.eurprd04.prod.outlook.com (2603:10a6:102:c9::6)
 by DBBPR04MB7884.eurprd04.prod.outlook.com (2603:10a6:10:1f2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.19; Fri, 24 Feb
 2023 00:12:53 +0000
Received: from PA4PR04MB7997.eurprd04.prod.outlook.com
 ([fe80::8b1a:ccfc:b5e:4b4a]) by PA4PR04MB7997.eurprd04.prod.outlook.com
 ([fe80::8b1a:ccfc:b5e:4b4a%9]) with mapi id 15.20.6134.019; Fri, 24 Feb 2023
 00:12:53 +0000
From:   Heming Zhao <heming.zhao@suse.com>
To:     linux-raid@vger.kernel.org, jes@trained-monkey.org,
        ncroxon@redhat.com
Cc:     Heming Zhao <heming.zhao@suse.com>, colyli@suse.de
Subject: [PATCH v2] Grow: fix can't change bitmap type from none to clustered
Date:   Fri, 24 Feb 2023 08:12:42 +0800
Message-Id: <20230224001242.7232-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.26.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR06CA0045.apcprd06.prod.outlook.com
 (2603:1096:404:2e::33) To PA4PR04MB7997.eurprd04.prod.outlook.com
 (2603:10a6:102:c9::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7997:EE_|DBBPR04MB7884:EE_
X-MS-Office365-Filtering-Correlation-Id: eb1a620c-e87a-466d-a31e-08db15fbdf6c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AtYGwNxPUZBkXRyMUMHhgNDILpFxACmf1zrSo6uXv8TjdY2DgD4e+ySJgtRpyGsV3LREIUHKmlcmTZqpr/eacTdfo60/xfUMNJaMAvpz/kPs4bV+Mh+YLWv8pJ2sltOdAOeBOMXN5LrbffSJOc5zqk3grCE2Qzi/+ZnnBhy8iNPg0HqNxA3zC16cl6Y8Do9Wp87ptvRs/G4xlzbp6Y+daeriEtMEAjh3uRaTO0hx/NUYPBhWSx96i5Gqi6b8sKwzWekXgpWYelOMQRTgfdmqIWLNIGx/C9/sfPunyUP6zJqz1Gdfrhxy8asV9uxFHQnfxK1GadXz5OYQYBwXUCbCLR4i3WH3dHFs6lQSwDT5+E+glz+zOCm83YPI19PQE2STygGTa5l9YwplRxI0Jp3txV/5VsX7tRu2jamtQGJ9VsyFDMzbKea4PV6Bvjn9zPAv3+U03GKZlLppsG0mYz8nus5aiymuXmHSVlN2Z2qN7Xq830pjgpm9jY7jFJhEMZfh0xkvOCdvuh2gOJejjWH1smxQgG9eyCSxj6QxoesCo6vBwuK2rKqNLhPvvhXMfAbNUhYTxTklqAIjT0Nm6x2FiTppg759XBbDRwFLMo2eDtggnDLrt3S4A4trsbYXwOiO4VsrMXEgUK5NI3Uv0guDBg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB7997.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(376002)(346002)(366004)(136003)(39860400002)(451199018)(86362001)(44832011)(2906002)(5660300002)(36756003)(83380400001)(2616005)(186003)(6506007)(316002)(26005)(38100700002)(4326008)(8676002)(66476007)(66556008)(66946007)(8936002)(1076003)(6512007)(41300700001)(478600001)(6666004)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bFDDp2Ve22HWQSah6hR87Gl1ibHH11G3MLF+5IIbrj5b0lVdPwYaN8hdz0QQ?=
 =?us-ascii?Q?w4dnMrM0niT/kPO0WzBp3mdktpQbx+BigcdImVVG/zINeM4KzMJ+huaM9wyP?=
 =?us-ascii?Q?2Kf2fVmd/QaKIX1/GAjz6A6S/M5Tb8a9gUsJhemkXExZ9Q1JtN0pgG3MX0VJ?=
 =?us-ascii?Q?Y7kHfpqD5FF0WlD+3VGq7FKaw4Cqd40pj7uauNk5lGZnmIWLxAjhbrxqZ8ZY?=
 =?us-ascii?Q?Y5k4JtX3UD6f6x7zmg0wjlH8Vu+IHEbPgmc/j1saB5hCstYDMxDPyqgP8vgp?=
 =?us-ascii?Q?Qr5MsmZDVqWPU7dStMEF91hRRI/cM4M5visw5O2Yh9roVkr9VZT2FDMn/ENg?=
 =?us-ascii?Q?sIxG70ik/L7Lfa6I9EFg3rTtG48fsNRhVXitqUpDNcytaEn6lyJ3+ewyss2x?=
 =?us-ascii?Q?Dz37LqpK6UV7iXouam5zgMoJn1CpC0CiYxeEJKulizJZMSjgoh2LczdKECOQ?=
 =?us-ascii?Q?dZu/FLMSBwSMG3cbOEJplQ5IG6Yybogx0GiMCymHmckOWlsxCnMbf0dz5CzO?=
 =?us-ascii?Q?JtoqyTOGV52n7MDtTjrkeb6yDBSSilBwtnvQM/bt5q/dqiWUr6K1J0TmfvaY?=
 =?us-ascii?Q?TMyKwTbqARfs6A8LY8bh+sUfiWmvu8vdAekB/UypjMWzPD8crbGHfgQfDFBZ?=
 =?us-ascii?Q?hSWKA+fKia5C2dbKnQA9KbXIoAPbaSxURDdZP36tqhBn1sYj7xzrdaAqagqP?=
 =?us-ascii?Q?1EU5ePrHJXnY3XSZyoLKzg6JCWkqZ29csrhl079VeXNQPCPZhU+/spl6vtia?=
 =?us-ascii?Q?qfw8GB870lmB6v8ORXYBgo31dFe0YNWYzzz7jAmZMhY72zq19Vh6JyQ4H8iv?=
 =?us-ascii?Q?FFD+RggN//j9P0C1VZ8mxmapy4zRtsKvmdLDnbzmLFeWfY/LkfXZDoVhRd0z?=
 =?us-ascii?Q?GgcH3o/2DIA0MhdGfCz9CixzroJIjxgfg9ogJY5RS4LjuXPtBPUyWOuwPbwd?=
 =?us-ascii?Q?evXp25E0wdZsjZAPOi9rAd8n1XEBsaSom2a521mfdEEa0KFaZdvsQNX6v4P1?=
 =?us-ascii?Q?lsa+L7lr/Wcp2CenCi6wefmv/D5oZv7gIC58/oplMO40tHJUe35KV9PQEyMT?=
 =?us-ascii?Q?p/ihmZpUqiiuH6h69XirktLTuetoVq0TpKs1uRh9XMdMhXDIHm70+UgTnhQM?=
 =?us-ascii?Q?QJUxSqUe3SqGGqzuKR7fPwIda2e08vkCWMoHmQJCo4dVLHbR0AyZbbzsaoAA?=
 =?us-ascii?Q?K3m+wdVwUL45cBLLR+M93eYQcNIeDGZbuMCPFAdeYyw8y0Xqh1jVpGZePgfw?=
 =?us-ascii?Q?KuB1EWtl7q8ccn+uXRZEktY2K9FzNn+j7wv37ofNSRHzBP4s1drMWmQCu/tK?=
 =?us-ascii?Q?3XOIe81eA/DBNeIIGpccpRUkAqjTOWUp3K22rqZt/pCSfugilCOcQPATFzk8?=
 =?us-ascii?Q?mFQjX+uWCrylpkMaw07PRPSk3AELXpgdYczW7bqhGGZe6uSbLSSbNi2LYcyQ?=
 =?us-ascii?Q?8nFPUaKTJaqD/0et8sAa08XPGQkyq5Z50yDC8BFZh3XETlQevjwiZK9gGjUO?=
 =?us-ascii?Q?pYDUesDxJ6BBFnxaaS+VkNJMbarooXkXqK35oTBWc5kh1zttQRLXt3DQTG9F?=
 =?us-ascii?Q?1fhgVQ6pdEDQQHtqEpvzGpdmTXJ4WnBysJw/+Vgc?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb1a620c-e87a-466d-a31e-08db15fbdf6c
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7997.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2023 00:12:53.3407
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fs5RHbsnNukN6OEGlkFEj4D7rQpBjfTS58alSm4qs8UeDWll326YnuZEFbM+lAz0pxiv83aBDghRP7+r0tmIkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7884
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Commit a042210648ed ("disallow create or grow clustered bitmap with
writemostly set") introduced this bug. We should use 'true' logic not
'== 0' to deny setting up clustered array under WRITEMOSTLY condition.

How to trigger

```
~/mdadm # ./mdadm -Ss && ./mdadm --zero-superblock /dev/sd{a,b}
~/mdadm # ./mdadm -C /dev/md0 -l mirror -b clustered -e 1.2 -n 2 \
/dev/sda /dev/sdb --assume-clean
mdadm: array /dev/md0 started.
~/mdadm # ./mdadm --grow /dev/md0 --bitmap=none
~/mdadm # ./mdadm --grow /dev/md0 --bitmap=clustered
mdadm: /dev/md0 disks marked write-mostly are not supported with clustered bitmap
```

Fixes: a042210648ed ("disallow create or grow clustered bitmap with writemostly set")
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Acked-by: Coly Li <colyli@suse.de>
---
v1->v2:
- remove dot/period from subject
- add Acked-by
- add 'Fixes'

---
 Grow.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Grow.c b/Grow.c
index 8f5cf07d10d9..bb5fe45c851c 100644
--- a/Grow.c
+++ b/Grow.c
@@ -429,7 +429,7 @@ int Grow_addbitmap(char *devname, int fd, struct context *c, struct shape *s)
 			dv = map_dev(disk.major, disk.minor, 1);
 			if (!dv)
 				continue;
-			if (((disk.state & (1 << MD_DISK_WRITEMOSTLY)) == 0) &&
+			if ((disk.state & (1 << MD_DISK_WRITEMOSTLY)) &&
 			   (strcmp(s->bitmap_file, "clustered") == 0)) {
 				pr_err("%s disks marked write-mostly are not supported with clustered bitmap\n",devname);
 				free(mdi);
-- 
2.39.1

