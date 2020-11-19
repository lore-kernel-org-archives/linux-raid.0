Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ADE1C63798
	for <linux-raid@archiver.kernel.org>; Thu, 19 Nov 2020 11:44:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FAD1246F0
	for <linux-raid@archiver.kernel.org>; Thu, 19 Nov 2020 11:44:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="bk4SmRi0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727665AbgKSLoR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 19 Nov 2020 06:44:17 -0500
Received: from de-smtp-delivery-52.mimecast.com ([62.140.7.52]:47354 "EHLO
        de-smtp-delivery-52.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727652AbgKSLoP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Thu, 19 Nov 2020 06:44:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1605786252;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ybAupXrrYtUK/eio3fYWAmqg/yi6EVlkWefizAP8j2E=;
        b=bk4SmRi0K3GHzRncC3uuk7tj60CWeHISuAY4PgA2x/f940qERFeWpNnhqEfx9rowNAu+wm
        Zacl5UxdqTrdhnUMHBX0k9+HSqV4f+hFQNjNCwv4xFrxBfPbhuzP85oNTX9HKm+SB8bkLH
        eTe0WSdlCnt2WpIupvzU8oaPis325+E=
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur01lp2050.outbound.protection.outlook.com [104.47.0.50]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-28-9hmo6ooeMI-a3VOIGT1F0w-1; Thu, 19 Nov 2020 12:44:10 +0100
X-MC-Unique: 9hmo6ooeMI-a3VOIGT1F0w-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c8aohLTikEd1mG+79v5SzT5qrJdwLJs+QTr7nZCTMZQpobhxmsN5I8eFYaV1Ar5OIoQfDk0V7nxbk10wQRm4PBTj9rjg2+AD1OUI9cpmmKPSaz5XOof0OhpIipaDm0RaMgomiiOk1PVMeZZbdSM2xlAuMg3LSo1q5SyNrhQEEzygTUkW/YonxNMAj6pj9KINX2jXdzy8u5B4C7PjQ1DONX+GKIQYMGlsLnaYeV4+QWvkIZl2yl8dxQiCd0eshVWugX57jgxSLMWOn/fZnBPWOwd5luw+SXLASTjSuH37S+fngY8F/GhilVmMVoqbr+wZz7/lpgVPZrBG5vc9w6HOTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ybAupXrrYtUK/eio3fYWAmqg/yi6EVlkWefizAP8j2E=;
 b=P0P0Ri2MLRbf1wUf95S9VfZ8nlfeQlfnOYKLSptUTmsB3AcVeN2oTAePYEcA5gw7jysFmbjXcjIoMgVS0Hwket/5r2lXwmbzNsQUZmUmuSf/5YXdb/Ri45c4BNmk/9VKjHyxoZ79YMJvmVTi2PWAsiM97aNNrciu8Ajiw3G7SimAK/1gLERS8oAPi24mCkPFDfjLbM2aB4xeLOMIADkiiQqLuseT1rIEgq0vmYiDtNtvS6mLkh5rJyaeRhZWD+dfpoGRaFj1DprBaTfa4AY3uurHww4HYMgP059LEnc2x1Z4bbVVMAqJvVzDhup0jIhfKqjLsRBKgH68JN2ZwtY7hQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB6PR0402MB2806.eurprd04.prod.outlook.com (2603:10a6:4:97::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3589.20; Thu, 19 Nov 2020 11:44:08 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::1c22:83d3:bc1e:6383]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::1c22:83d3:bc1e:6383%4]) with mapi id 15.20.3564.028; Thu, 19 Nov 2020
 11:44:08 +0000
Subject: Re: [PATCH v4 0/2] md/cluster bugs fix
To:     linux-raid@vger.kernel.org, song@kernel.org,
        guoqing.jiang@cloud.ionos.com, xni@redhat.com
Cc:     lidong.zhong@suse.com, neilb@suse.de, colyli@suse.de
References: <1605786094-5582-1-git-send-email-heming.zhao@suse.com>
From:   "heming.zhao@suse.com" <heming.zhao@suse.com>
Message-ID: <17e4c848-8d29-c759-a667-06eb3e215104@suse.com>
Date:   Thu, 19 Nov 2020 19:43:56 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <1605786094-5582-1-git-send-email-heming.zhao@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [123.123.130.58]
X-ClientProxiedBy: HK0PR01CA0054.apcprd01.prod.exchangelabs.com
 (2603:1096:203:a6::18) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.130.58) by HK0PR01CA0054.apcprd01.prod.exchangelabs.com (2603:1096:203:a6::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Thu, 19 Nov 2020 11:44:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 25598d4c-8506-4b2e-8bf8-08d88c806ce3
X-MS-TrafficTypeDiagnostic: DB6PR0402MB2806:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0402MB28068C05FF8F3C5DDED5C74D97E00@DB6PR0402MB2806.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q8CkjH5PpRGi1M9VVysCbEKtyU3W6zTlOLiP+yPC9jDOfh1hVL2pvbbwa1lDt/rbyU9tnAUIt9UeVMfza1zwvhNpCll7IbD9ESFIM5K6qQ2IFiqj1G2ISxRrqi1mfufu2PyX8TVHVSZ0A3WFFdfQOUrXTM29GX8PacSxOhAvbFPGbVeki4XiJq3zONkXkihv1ydoADyB15PKnuvkEadl7zgY3lgcuRlCt1+FdHsc9ANJ2onZZYwdfbDXFMR5KBkbjFZ1YlAk+avOozwywmGAIkBBGt/T+8xD0c7Ue9fwCY52/KY7u5a+AaC/J4Ng0p42qUOHzbng9rT2sGo5gSJ0/Y+m8UQBipHVZrk8dt+g5E/h8OSu+2bgsAttXjYGCzjTlPqnIedDBDzwTaDAYpOlGA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(136003)(366004)(39860400002)(396003)(86362001)(2906002)(6512007)(478600001)(5660300002)(53546011)(31696002)(66946007)(8936002)(66556008)(52116002)(66476007)(6666004)(8886007)(4326008)(31686004)(16526019)(186003)(8676002)(6506007)(316002)(6486002)(956004)(26005)(2616005)(83380400001)(36756003)(9126006)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: hHA74qH1EaAhP/BemmumJ2RiD217LxmaPi0k6IKO6yh6zEh4+aJRuDvy52g8JO07ZEJHKapWvqeU5dTsxWZSIQ+SLHhJekmBK8cA1AY72syv91gb/v5dsUM5KvCNBDY3TutwNVTu3lQ7IpQ3UT1KtxwAqf4UryiYY06rUNx4R8vOIyDnphHSWpG3jwZohtzLSmIgBuaq7HMaUCXgNG7TsxJ2LLzwcdU7UfEK9Lst8DnbYjnY7lFM6iwEk/VjsmsoeFvi5sLIpAyCK4oUoqvga2IFdEBKe58sREww+zYgtyToHyRd5nOexmAwR/474URFInN17opU2Q9xrFyVhrLUeK0KjIADv9eIkyXYc7q/XMxUvDf/5YRl7FfkR4AT1QMitNiizibVU1Yfaao2xf0IqOZ9SHOGFhZf3leKttItdwvJk+X7Ij+7io/ygzsgQOjnO4q8Wh050sJTLpAJcdJ2lbJrXbbp5fr0qcr55AV2SPS6p6pAdEbgPsPbnIZFDZSCR4XZuPYt4DcWyUtUAZP6K4FpJzIflEFqHAmM0pE5poBAm0jWbIyzndUZjaicMpGiCNkkApCaS3RgQv5wph8fVtgM1YNaHbkl35ii5cginuVy7Nx0jqp2j/lt0L6IueJ7Ba45S2afLs3R3MicyHv1iQ==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25598d4c-8506-4b2e-8bf8-08d88c806ce3
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2020 11:44:08.5318
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hfW9DW7zhnAW7AteqD81R+AMjEHdis6roVJRL/65OI48KCaQJ4lMn/NieYDQf5uZ/2DrIQq/Kwrraki4CykeoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2806
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

I resend the v4 patch with correct Cc tag.

On 11/19/20 7:41 PM, Zhao Heming wrote:
> Hello List,
> 
> There are two patches to fix md-cluster bugs.
> 
> The 2 different bugs can use same test script to trigger:
> 
> ```
> ssh root@node2 "mdadm -S --scan"
> mdadm -S --scan
> for i in {g,h,i};do dd if=/dev/zero of=/dev/sd$i oflag=direct bs=1M \
> count=20; done
> 
> echo "mdadm create array"
> mdadm -C /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sdg /dev/sdh \
> --bitmap-chunk=1M
> echo "set up array on node2"
> ssh root@node2 "mdadm -A /dev/md0 /dev/sdg /dev/sdh"
> 
> sleep 5
> 
> mkfs.xfs /dev/md0
> mdadm --manage --add /dev/md0 /dev/sdi
> mdadm --wait /dev/md0
> mdadm --grow --raid-devices=3 /dev/md0
> 
> mdadm /dev/md0 --fail /dev/sdg
> mdadm /dev/md0 --remove /dev/sdg
> mdadm --grow --raid-devices=2 /dev/md0
> ```
> 
> For detail, please check each patch commit log.
> 
> -------
> v4:
> - revise subject & commit log on both patches
> - no change for code
> v3:
> - patch 1/2
>    - no change
> - patch 2/2
>    - use Xiao's solution to fix
>    - revise commit log for the "How to fix" part
> v2:
> - patch 1/2
>    - change patch subject
>    - add test result in commit log
>    - no change for code
> - patch 2/2
>    - add test result in commit log
>    - add error handling of remove_disk in hot_remove_disk
>    - add error handling of lock_comm in all caller
>    - remove 5s timeout fix in receive side (for process_metadata_update)
> v1:
> - create patch
> -------
> Zhao Heming (2):
>    md/cluster: block reshape with remote resync job
>    md/cluster: fix deadlock when node is doing resync job
> 
>   drivers/md/md-cluster.c | 69 +++++++++++++++++++++++------------------
>   drivers/md/md.c         | 14 ++++++---
>   2 files changed, 49 insertions(+), 34 deletions(-)
> 

