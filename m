Return-Path: <SRS0=Dxgx=ED=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADA3DC4363A
	for <linux-raid@archiver.kernel.org>; Wed, 28 Oct 2020 21:33:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4920924858
	for <linux-raid@archiver.kernel.org>; Wed, 28 Oct 2020 21:33:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Ogh3kVZ0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725834AbgJ1VdK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 28 Oct 2020 17:33:10 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:32784 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725875AbgJ1VdH (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Wed, 28 Oct 2020 17:33:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1603920784;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uVgmLpYb2mjBKacS1EeNi5BLPri3k9kMFNJ8j9W5O4U=;
        b=Ogh3kVZ0uWgnnOgno210v21XC0hzOpiZtXOyx5YP8t9ScVYNol4sh/ZgnoX63R07v/ms0A
        xA4eUYBHrvhXLGoHlbTiO+e8m3G1ghMK9dJK6KFyrrcj0+ROzJ+zxHYKUZUCHKHEn2FIC2
        GFYBnh0J3ydcbI/PU28pSCYjt87qTDA=
Received: from EUR02-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur02lp2056.outbound.protection.outlook.com [104.47.6.56]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-30-W0iFeYBQOy24xgPK676iXQ-1; Wed, 28 Oct 2020 13:29:34 +0100
X-MC-Unique: W0iFeYBQOy24xgPK676iXQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kKCJukbSFgXdbqHoZn8ALqnO8gl456tF5BlLzkYnyLGvVA3YELTaeErfHKZyzhB9Mr88ZGpE2ForlymxYV89QAAT5falJPb079Ng2R7V9+5mflgwG68oHR0PWS+NGFJluCOzQ1ZveNtNkpDAay67yhhQjhvo0hD0GVCzpTXsFdBz1S/DlrM8wpxmEAeQsrhbJ3aFNwLc+hGQ/bHPbQkxU0SYXqTCrnGQuY0igapplnAgUf93J9pnj/WkicEXpp8vyq1NfvXf5JtS3lcfDS+gN9By8Pbh2zo/P44DHPXDuCaeo+NWFcrRwrNRXOTlmtvPiSmqLJLgkHDKdSTg9PhXIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uVgmLpYb2mjBKacS1EeNi5BLPri3k9kMFNJ8j9W5O4U=;
 b=DchzqppvuLHXRkNnfB5s1epe2ygckq3nGa6Qdht3yFspM6TQbvVJHSSn4kh/mWL2d0m2F0MLInuAA1xgiHMTKRgkxdASVCbN62beKKOhmer+S2MpnlEm5IVfDD2v811Q44rSA5je+r9Y/CUNFnD1C/8MYmkdfx9rWTUqS77POtLe9UrzFDtb+af1/+XUnCGPC+iE7JtJrDpkJtvOYsRgva/mR0uxfk2cRYVPPE5E1A5/yFh6w6J5P/rXd9m6zbxB+ZIBk1j2g++D8UZLjg8FEDkry7Q+MiX3YpEP0rRwZQ2RFI13TpR9qcPyqVXYIznM+eI2/iMuVluU2kqQoHbgVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from VI1PR04MB4671.eurprd04.prod.outlook.com (2603:10a6:803:71::11)
 by VI1PR04MB5918.eurprd04.prod.outlook.com (2603:10a6:803:e1::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Wed, 28 Oct
 2020 12:29:33 +0000
Received: from VI1PR04MB4671.eurprd04.prod.outlook.com
 ([fe80::9d47:ec0a:56e1:f3e9]) by VI1PR04MB4671.eurprd04.prod.outlook.com
 ([fe80::9d47:ec0a:56e1:f3e9%6]) with mapi id 15.20.3499.018; Wed, 28 Oct 2020
 12:29:33 +0000
Subject: Re: [PATCH 1/1] mdadm/bitmap: locate bitmap calcuate bitmap position
 wrongly
To:     Xiao Ni <xni@redhat.com>, jes@trained-monkey.org
Cc:     ncroxon@redhat.com, heinzm@redhat.com, linux-raid@vger.kernel.org
References: <1603865064-27404-1-git-send-email-xni@redhat.com>
From:   "heming.zhao@suse.com" <heming.zhao@suse.com>
Message-ID: <95046dfe-c770-8950-c720-6b1d30bb1789@suse.com>
Date:   Wed, 28 Oct 2020 20:29:20 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <1603865064-27404-1-git-send-email-xni@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [123.123.132.188]
X-ClientProxiedBy: HK0PR01CA0058.apcprd01.prod.exchangelabs.com
 (2603:1096:203:a6::22) To VI1PR04MB4671.eurprd04.prod.outlook.com
 (2603:10a6:803:71::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.132.188) by HK0PR01CA0058.apcprd01.prod.exchangelabs.com (2603:1096:203:a6::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Wed, 28 Oct 2020 12:29:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bf174437-9ec9-489e-924e-08d87b3d1ff0
X-MS-TrafficTypeDiagnostic: VI1PR04MB5918:
X-Microsoft-Antispam-PRVS: <VI1PR04MB591895F58FEE34644C02166097170@VI1PR04MB5918.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Dkd/xH5jh/S5PXappe9Bvk71K2CA3dQWuNqyUyaMD5KwUJo3CaRAQsPJ6Yi4PuJBs1SU9h3VIO410K0jizh+f6jh6aNV9PcJYhkno9pMkwkBqM1gcmz6ZoF4PLZzetn+Q8Vs8PBaShew3PDRgrt/ps89HG2Rgw3Z7sKwBrjhmzAG0pK0PJytoCDVl5pEXPHCF3a5AzT3MtzXSejm4XvvpkLdOBSLB4X8+0rPx30EcdncQAXYRST6f9K0qbF7wl8EQvtvd6fkkyF9kg2htwCKuWSnqO91O2xrbJQs/uwKWKSBpgQoeglBBxu5QqMcqZSrVTbFsg2Vnx9B2iKgJqduo9nEJlWEelVuOGtDtgcPB557+sAkGUjJoWvJbCKX8OYxeB2L5KaPBAx+/MD4cQ5deQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4671.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(376002)(136003)(366004)(39860400002)(53546011)(8676002)(83380400001)(5660300002)(478600001)(31696002)(52116002)(2906002)(6506007)(8936002)(66946007)(66556008)(66476007)(4326008)(6512007)(36756003)(316002)(2616005)(956004)(86362001)(8886007)(31686004)(6486002)(16526019)(186003)(26005)(6666004)(9126004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: QI9RqlH1nIsOos5darZibatcYY2hLLWvUFjQxWSImBdJAxjr31kcOQjwlqhHh+hXgAk31vOB5k1yRYAT2waWrcx8IaWYGPdgabrx3h9jqCkxxKuNdUr7BLSQ7emTd1dS1NV4TB0ksKTrRJnvIueNsyxjSzJpXrHGxdOwZIcgbbO58drk2JvhLgXvppaudHNANYbMO31CTnY6p9gNMCCzAeuASqrCw8O1ddkWB1+ZFnaCYZGVo/1Ax3+ZNoSOuE95XnMJ3H2C8hCLnOQRnvdE8Wn2Po0/DBdQUY9JKlD/AHzkLbzZQTdci6loSdbUoqFAYtys6EjBGK/wRPWh8W3IZTwXPALDBR3hu+Rhao7TLFWEsOTZLgjxRh6A2F2vwycL3rn6FraK/pMNEt3SAfZowkZLRExdqvBUsYPa4x+hQNOI0TcQE6yMOxbWPMwLpMPw2AlAiDm78HER5dTu0UW7vDuGXOG1q62/CcOOQL0xfmODpSLOPuRDoW/hZSWItb5s90lGKaExJU2f1YZ/N4x6KL3Jms0bkjXF5544a4lEzgMism9RE+Jhe5CoD1HnmRv8BFcZIdpoMy5Cv5lJdYLGOCRPthlbDCmr3120ss/1X5j4SG1k67MiWLg80cIDk8K535P7+Sh4R3REdbhiVjgqfg==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf174437-9ec9-489e-924e-08d87b3d1ff0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4671.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2020 12:29:33.4225
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C4QjXLeNRNUQ6V/BM8LoUUGMmYXIlE7Dlrhh5m/OVKhW0QJIK7Mo45MmWz+Xd09PgNh/DsHGaN9hA79RhGTwTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5918
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello Xiao,

My review comment:
You code only work in modern system. the boundary is 4k not 512, because using hardcode 4k to call calc_bitmap_size

In current cluster env, if bitmap area beyond 4K size (or 512 in very old system), locate_bitmap1 
will return wrong address.

Please refer write_bitmap1() to saparate 512 & 4096 case.

On 10/28/20 2:04 PM, Xiao Ni wrote:
> Now it only adds bitmap offset based on cluster nodes. It's not right. It needs to
> add per node bitmap space to find next node bitmap position.
> 
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>   super1.c | 12 +++++++++---
>   1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/super1.c b/super1.c
> index 8b0d6ff..b5b379b 100644
> --- a/super1.c
> +++ b/super1.c
> @@ -2582,8 +2582,9 @@ add_internal_bitmap1(struct supertype *st,
>   
>   static int locate_bitmap1(struct supertype *st, int fd, int node_num)
>   {
> -	unsigned long long offset;
> +	unsigned long long offset, bm_sectors_per_node;
>   	struct mdp_superblock_1 *sb;
> +	bitmap_super_t *bms;
>   	int mustfree = 0;
>   	int ret;
>   
> @@ -2598,8 +2599,13 @@ static int locate_bitmap1(struct supertype *st, int fd, int node_num)
>   		ret = 0;
>   	else
>   		ret = -1;
> -	offset = __le64_to_cpu(sb->super_offset);
> -	offset += (int32_t) __le32_to_cpu(sb->bitmap_offset) * (node_num + 1);
> +
> +	offset = __le64_to_cpu(sb->super_offset) + __le32_to_cpu(sb->bitmap_offset);
> +	if (node_num) {
> +		bms = (bitmap_super_t*)(((char*)sb)+MAX_SB_SIZE);
> +		bm_sectors_per_node = calc_bitmap_size(bms, 4096) >> 9;
> +		offset += bm_sectors_per_node * node_num;
> +	}
>   	if (mustfree)
>   		free(sb);
>   	lseek64(fd, offset<<9, 0);
> 

