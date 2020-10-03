Return-Path: <SRS0=R9UH=DK=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DDE5C41604
	for <linux-raid@archiver.kernel.org>; Sat,  3 Oct 2020 16:26:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E413F206C1
	for <linux-raid@archiver.kernel.org>; Sat,  3 Oct 2020 16:26:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="aGvr/kmg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725794AbgJCQ0c (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 3 Oct 2020 12:26:32 -0400
Received: from de-smtp-delivery-102.mimecast.com ([51.163.158.102]:42656 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725789AbgJCQ0b (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 3 Oct 2020 12:26:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1601742388;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TEd+rpyYfsExqKgvV0gLwzdS22PnQRjBgs5K8TUEQRM=;
        b=aGvr/kmgOsyo4ohSfggxhl3ItO4zINJvbTt2MIAhL22TWPN7xkrzQvltTpO69LQeYuECl+
        juTcbNaEM/8a6X248pkf8ARurNTLTvP4ZQW3GkKHKVu/a6vonFxLyHdsnvPQeL3MPinM6p
        gDBv1qxvGhL9RcXA0OnCgGhYenF1k5Q=
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur01lp2058.outbound.protection.outlook.com [104.47.1.58]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-17-XKZxu-WaMeeX44RdOu7FIA-1; Sat, 03 Oct 2020 18:26:26 +0200
X-MC-Unique: XKZxu-WaMeeX44RdOu7FIA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XxRzezrfQGxw64GBwKR2DZxN5sNgkM4cXnKP7GHvTjQ0Si5QWIz8bQcfCOwZOALtWwaHVLUvew4fqiTxfteYFiacn5a/msCv06B+MvhvKCAc7/1ogI0O5LYmIhgaUyuH7lTt+MdOnwGctGY+qb2HjvQstGhVzHDQHCTZKbUDuql3jIJLL0r/rFg2BgjU18hNXKaWx2EFv2vTAOfhcMRZ9NMJHOuGIr44rsuzU/JFcHjaEiXk8lqIWgGF6UVsj0/tk0r8eClFnBpe+g26FroZBVa79WCeSk40DuCGuzYz1JwRfZHDWfjZG1miDMOZX1ibTJhMuRMi3d3KkN7DyAYEhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TEd+rpyYfsExqKgvV0gLwzdS22PnQRjBgs5K8TUEQRM=;
 b=gzuqsrUNegzLdneCEafcHemPPyUsOiS+KD3+5pPb5ckO/j+dzyH6KCss5YlEvNPCa6nQE1rCj9FjWLQgnVOAJNWEgHGK0fLISExdtNpXWJQKGClEE4CceMiPsOwTgpA1IOKFuUUBm6BDJ5bWhHl1BrSjaxhzBp3idP8Y2GIriUkx3Oy0yUIe5T/JJLtBf75hrzpiwmvxQu22Crf0OMninKjJM6Liun2mmLsI0G+kbGyZqKDKSeahRzG52QJ2DdoJITV+N1DgKSv/m637qYTFoaDze8fDe9GP6v49AHE1yeLfUIhaHLsL/TUfBJFK0UbNnZNLl97MuUUdCo2VWYj5yA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB7PR04MB4059.eurprd04.prod.outlook.com (2603:10a6:5:17::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.32; Sat, 3 Oct 2020 16:26:24 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::b59c:e9a2:d279:3904]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::b59c:e9a2:d279:3904%4]) with mapi id 15.20.3433.034; Sat, 3 Oct 2020
 16:26:24 +0000
Subject: Re: [PATCH 1/2] [md/bitmap] md_bitmap_read_sb use wrong bitmap blocks
To:     linux-raid@vger.kernel.org, song@kernel.org
References: <1601741492-17696-1-git-send-email-heming.zhao@suse.com>
From:   "heming.zhao@suse.com" <heming.zhao@suse.com>
Message-ID: <51da8823-aed1-dc45-d14e-3b30c8f88aa0@suse.com>
Date:   Sun, 4 Oct 2020 00:26:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <1601741492-17696-1-git-send-email-heming.zhao@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [123.123.129.194]
X-ClientProxiedBy: HK2PR0401CA0018.apcprd04.prod.outlook.com
 (2603:1096:202:2::28) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.129.194) by HK2PR0401CA0018.apcprd04.prod.outlook.com (2603:1096:202:2::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32 via Frontend Transport; Sat, 3 Oct 2020 16:26:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 23d744c7-fcad-4bc6-ab78-08d867b91218
X-MS-TrafficTypeDiagnostic: DB7PR04MB4059:
X-Microsoft-Antispam-PRVS: <DB7PR04MB4059839CF347A9EA67F42DDE970E0@DB7PR04MB4059.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1360;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rvrUkvCRqZc2LuFDJj0N5xVTNhdp/IICiVMYORgs+bhG0OR4/Ohb2CRv4vptbaisLeJMnOnlAJ6W5BWMP47cQ/l1EP7JFG9yhTJBHT+1Fxesy4iA1rLSTSGsUej3gUomWaZ1I+CmnwLQEbtygkC1N5hoJWWCdGnf3GcOjGCnt7eG80sEScHbhiVO0oYfG8e0b19KI/uZ4Qt13ijUpISkrMc/E4VJdqeSU4hb12UVgo+2bTgQ2FGgnFvoBKyVjvSZrljlufsaq2Rz0rJkECNeqvzEZTm0ncfO+bZf5eNjzgchcixNmgy2gCEpcc9/9Gp6DMF4kCqjX8ot/hmTPorcJf8/Pwl4G8GkxnsTAFp5Gsh7jqruAuo3WYIexKL+avkS89DlC+TKyUnqruV2kKlIEw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(136003)(376002)(396003)(39850400004)(6512007)(316002)(83380400001)(53546011)(6506007)(31686004)(26005)(66556008)(956004)(66946007)(2616005)(478600001)(66476007)(5660300002)(52116002)(6666004)(2906002)(8886007)(186003)(8936002)(31696002)(6486002)(16526019)(36756003)(86362001)(8676002)(9126004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: HgxJFWEpCSu3aYd4s5xfpvyOjrIPKudhcW0ZWryRAahPyc7gy8BzLjE1hkuQMBdq+fu02r6qGL2CK+e7pn/AzWPOvlQR5/hFc/LduVXHAfufZNch/HtOccbNtA6eXHcwi8B9wB8dtGg+tOEysjz+okUkN1FbSwvSl0kvEuefgOtnhiNTMtPac+8aELmm6kh6cNRBH5IUB2w1I8cuCn5lnDGLWfMR8+uHcBugu84N4WkTl16J7CPPlrZWEGO3nCGEyodnf6/j5zmTNtvZ/iBkW1IezwbhEfTijun90Qwwz5Op5VtldoTkCDzndbCiqabQoWqZMX1ZWcv+CO/+pHtSVQqGwJ0Gh5fAAi/YSwWNpALXs8vm9+4xFLQZibpC8+S6cxs/hvnoou2j8WWTCiG5Od/QKS3I1j51zgSmLqgwTuJp0Pz5Ymh7uYiyOg9qSOVwwvzTog70PXfPtDT8yYhifn5l6c7Qoyk3OO7DEosWJQF8xVaPSbJItEqG2da+RIfguCAJ0P98KLi9nA4CqWaP6NvZe1IxLHinaygJweA8THuug80uLq/VV3Xw0I6fkpoAG3z3NWzE3Tb89UDj4xXnlkgSB9znFdQ98YhqNqA8endrIcbGus65G+l5a4j9T8da0T/vHieq7btqdAwuuGJC1w==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23d744c7-fcad-4bc6-ab78-08d867b91218
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2020 16:26:24.4241
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hhb69ZoHBrOkBRNTJoEA074c34YOwH+bMDE2YaMkp7ejAENOCtHqu+1biFX6QN0U+0cpIl7qZ5IMs4PwMnNZaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4059
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

very sorry for my mistake.

the patch should be change from:
```
-		sector_div(bm_blocks,
+		DIV_ROUND_UP_SECTOR_T(bm_blocks,
   			   bitmap->mddev->bitmap_info.chunksize >> 9);
```

to
```
-               sector_div(bm_blocks,
-                          bitmap->mddev->bitmap_info.chunksize >> 9);
+               bm_blocks = DIV_ROUND_UP_SECTOR_T(bm_blocks,
+                          (bitmap->mddev->bitmap_info.chunksize >> 9));
```

If my patch would be accepted, I will send v2 patch including above lines.


On 10/4/20 12:11 AM, Zhao Heming wrote:
> The patched code is used to get chunks number, should use
> round-up div to replace current sector_div.
> The same code is in md_bitmap_resize():
> ```
> chunks = DIV_ROUND_UP_SECTOR_T(blocks, 1 << chunkshift);
> ```
> 
> Signed-off-by: Zhao Heming <heming.zhao@suse.com>
> ---
>   drivers/md/md-bitmap.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index 593fe15..1efd2b4 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -605,7 +605,7 @@ static int md_bitmap_read_sb(struct bitmap *bitmap)
>   	if (bitmap->cluster_slot >= 0) {
>   		sector_t bm_blocks = bitmap->mddev->resync_max_sectors;
>   
> -		sector_div(bm_blocks,
> +		DIV_ROUND_UP_SECTOR_T(bm_blocks,
>   			   bitmap->mddev->bitmap_info.chunksize >> 9);
>   		/* bits to bytes */
>   		bm_blocks = ((bm_blocks+7) >> 3) + sizeof(bitmap_super_t);
> 

