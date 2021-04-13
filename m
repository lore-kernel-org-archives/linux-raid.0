Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C473C433ED
	for <linux-raid@archiver.kernel.org>; Tue, 13 Apr 2021 01:39:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4EC9611F2
	for <linux-raid@archiver.kernel.org>; Tue, 13 Apr 2021 01:39:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239038AbhDMBkF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 12 Apr 2021 21:40:05 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:39768 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237115AbhDMBkE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Mon, 12 Apr 2021 21:40:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1618277984;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sorDxXs+/GeZIL+AnGIzZwEYoZPoZ/1rQkkWZAsT+Ik=;
        b=OGuDTiA7NQq1C6/d2c4jN4ZOZEuTiC1pXt7lzvHBHzG30zUkcBm47tyWrMpPxmjb708LRx
        sxAiH5iTpA5GEp74vB8zq4c8Lu2GyahqJJ1TXVvRh0F/SpX4WrtVW2avcekONYwxlgOrRh
        kt9YEmjv/wkOrYcA83gLoTmD4ZPxIDs=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2053.outbound.protection.outlook.com [104.47.14.53]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-18-k_2J485qPRuwhA2hK1T1kw-1; Tue, 13 Apr 2021 03:39:43 +0200
X-MC-Unique: k_2J485qPRuwhA2hK1T1kw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hgHz4eEddCM8woBlBLvptEn7q4XTHP8PQlop/WpaVsRVYy1eDazfm2Q5bwjES4ym/uMuddRPnNBjotWM9qn6PG3YrwvUJ64ERz12RDFIlPcISAWukhhSJbH1qY6GvMfj46yPmN71hFpSwAae0dS1cKwtWGHptev2CgTfn6bOIe/RmUBCD6FmdlOvzIDoBJwQ8oBV4LWkfnepQWkOjf17sN984w8GL3zk2xQYxryX/uXhxiyPlbIdlhRBoChTVvKNGpZTjcBbkYuVQoKQ5T0/FHbMKHkUBenjLVSCsE4trnWb/DqRwNd2Lar3ziWXOF7wqpVLPOW7ytvUND5XMDTg5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sorDxXs+/GeZIL+AnGIzZwEYoZPoZ/1rQkkWZAsT+Ik=;
 b=WvtlrRaxQRL9hX4RaMNH7hGs20uI6u/hUiEJMYJnS7gEz7HTadioFDTp1Oo9X+4WT+h+MeSiHkdvmv4EJ3gEpiHPvZMzJVxozBm9ALDd3V71Zkzg9kquU7BMGNCQuMoo7EmPrLRsSxwl48+1r8kamEHYcYKPIiwuQ/lT4kNjbuRY8f8tphD3aY3/0dzl41jOzeV+iBH/jhpYzW3lAwwt7DNnOYYXh2zel0dxuHIzTb10xTO6cqjdFiz0iGkLG1DcLPVeorn2NqFuU4UMhckb4luhwyysofCLba9vp0RRJ9vbGi56lsdyuOHdEcJ43w/wdH0cMeC96t15sP+Wy2zPjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB7PR04MB4443.eurprd04.prod.outlook.com (2603:10a6:5:32::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4020.21; Tue, 13 Apr 2021 01:39:41 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::2c69:3d93:4901:ecfc]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::2c69:3d93:4901:ecfc%3]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 01:39:41 +0000
Subject: Re: [PATCH] md/bitmap: wait for external bitmap writes to complete
 during tear down
To:     Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>,
        linux-raid@vger.kernel.org, song@kernel.org
Cc:     lidong.zhong@suse.com, xni@redhat.com, colyli@suse.com,
        martin.petersen@oracle.com
References: <20210413010703.GA13817@oracle.com>
From:   "heming.zhao@suse.com" <heming.zhao@suse.com>
Message-ID: <3cffdb3d-b5ee-5c50-32a0-328fc806d4b8@suse.com>
Date:   Tue, 13 Apr 2021 09:39:32 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
In-Reply-To: <20210413010703.GA13817@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [123.123.133.187]
X-ClientProxiedBy: HK0PR01CA0069.apcprd01.prod.exchangelabs.com
 (2603:1096:203:a6::33) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.133.187) by HK0PR01CA0069.apcprd01.prod.exchangelabs.com (2603:1096:203:a6::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Tue, 13 Apr 2021 01:39:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8b274dd0-26b0-4c70-db51-08d8fe1d0207
X-MS-TrafficTypeDiagnostic: DB7PR04MB4443:
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB4443F11121781B86E81C6CA6974F9@DB7PR04MB4443.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sIME6IxdEOqbM7GXWca22qDxeZuZwTPt8VI9BJmx1UKInOfo6tSUzIGZzB6rSUVQZmZheZs8V2qKVZ9oBPVRZQiiUGxEdhNhNzJJyCmO2kf3OQzhl9hLnigINOQp/RBHwhFWqB7V0xJ3c6BEvAuCKZQtKJuz+kpxkU4dCzZgMaDdIH4+fz44uLX5oV6/53v8lEDJFufAGUxC6RWrTLWdcmdx2qCmV45iGo5KBwpafTLEKTE1U4zf2+ItbwlO3LU2xqgPt6pFnXylbzT8gowMb+5OT/MkMF1UuF9MXXaPTWye/Ybi3PleeDx0RQpyad0x57LOTdYwKXJCUF/XUyQ2nwZ5P+UYJ8j+sJsuad4ZQXOzvwSMjKjgHIzaw3OZehbQEOczKqtWOHh2+Z/kbxTqT9ohbKQoiaxDpWA9xq5Ln6DsJHvs3oqhYySwKhO7O2XGhxEJk+g0NN+7x+v91FUTVP1MmyjLiOQXtvq9E3fYx8LoyxgcHMWOfNVJuK+mfmhy95BND5BGKHgakUOwKfNUE1UG/K1IUfeVZOiQJSmRf1hrJmYUBsPEHJ5+VpSyI/e4P3K/k5QoQft3FkS1OK7eQ9l5od/abmflfctjqts5wU1E9yYSv8y7U+tNJaAEBzu+i4hzb+o70oekidniXyS2t+c1KGC7/pJsEw291eHksPH43ZPa7rvh69L/cpHrfOn8JTsDYuuJksaec5KP3ABGzA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(366004)(396003)(136003)(39860400002)(26005)(38350700002)(36756003)(2616005)(16526019)(4326008)(186003)(31696002)(83380400001)(66946007)(316002)(66476007)(66556008)(38100700002)(6506007)(8936002)(8886007)(6512007)(53546011)(5660300002)(8676002)(31686004)(86362001)(2906002)(478600001)(6666004)(52116002)(6486002)(956004)(9126006)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Z21ERXRDQjdyMkRtLzgvdStMWnBDTTJ3NEl1UENkSUVhNlNIRFM5bWc3UlNC?=
 =?utf-8?B?NUMwYWJCSWpqTUlKTXZ3RHJzeVorSUFUVGw4MlNBcDM0NXlZOHhscnZUVnJR?=
 =?utf-8?B?YVpiVDdBMFRiSW1mY0dlNzVmLzdyY1hTVlpSMGVYVUJadHJZZGFBMWpUcHk2?=
 =?utf-8?B?di81QWRIZGMrS1hzSmI0NE5lWm4xVXd6aTdNTVJQcmRjV08wdzM2Z1c5L29x?=
 =?utf-8?B?TFJGM1o0YkxxaXBObnBobk4rUVIvSHZQblpPekZraUdFOFJKOUxHTzNyTnU2?=
 =?utf-8?B?cE5HYjlkakhuWi91RmRkT2tYYnR2K1RucG5nM29ZMUtnVW1lbEVuTEc4OE5B?=
 =?utf-8?B?R1dybmk2cHlQbXQvY3dZaEYwWVRoVXBuM1g0bTBBc3hiNVREZngvSlp4M3lE?=
 =?utf-8?B?eXhHSUJLcGhjTWJnLyt2TXE0K0hvamVjSjRCQTlDQkJEQjJYRXJHeUNjVTc1?=
 =?utf-8?B?ekY1VUxkUFloZkYvazBka0JMdmFYOTRvK1VjQXgvSXJ2dm9JQitnYlZmV3po?=
 =?utf-8?B?U1FZMzczTWNHR2N0S0IxRkhlTElmUzV6dkhTRGI5MVhQLytUUU9jbW9ISHdU?=
 =?utf-8?B?UUs1azFYV3FqRVIzWHkxZW9vYVhBdXVxK3Fqa2RPN2c2QmlxU1JPemtidFM2?=
 =?utf-8?B?cGdTUDhWeUFpYjNjWEtCZklNaS9RZ2gxcmxFcFh4VWMvN09HM2N0cnZJQm5u?=
 =?utf-8?B?UXlndm9VRnZMWFM2S09RZ3pRQ0h4VkVwWE1vVEc2d1l4cHJZaGIwbDR4UTZx?=
 =?utf-8?B?b3A5a01xMnZpSytoV0gzKzF4a21tMDUzcG0vMndnS09VbEtweE1SMmdwU1I5?=
 =?utf-8?B?bldQMTQ2RndvZ0VrUC9HVWg5WFllQWpwL2xNOUV5Zll5Vk9XL3FBbFZZWXdO?=
 =?utf-8?B?dXdxMXZTOHRUb2xRbzlNcnpvdWV6ck9xdXg2dkJPZ2Z4Ry8rZ2JCQngrQjA3?=
 =?utf-8?B?KzVSMEd3QlFocXg1c2VCTEdsd1FUMXBxbjh3VjdZNkZpekZYYzNRSGp6RWgw?=
 =?utf-8?B?VXhGSndxaTRTbmxrSTZ3TnU1dzk0MDFORTIzV2FaWktwVTNjSXY3NkxDMUtV?=
 =?utf-8?B?THczLzJGYXdZQ3RrNmZwa0xSajFzYVNIaWVISW5CeGVHOHk1RkgzTmMvM2xa?=
 =?utf-8?B?cXpScS9SK3RpdTA0cWkyRWJXQmk2V1dGdTlvWnhhQmt2NzdqUTd5Q2ZNaFBY?=
 =?utf-8?B?TjdMU3NxYWxvT2N5RGFTcDYrNVluZzlhbjRvSnlqNEMwUi9aZWQyeWtqcTNj?=
 =?utf-8?B?NE1qMDkzL0E4UEYxMVZWNnViUldSOGVwTHl0Y3daVjRQaVlvUHZrZnhKOWJr?=
 =?utf-8?B?UGVRQ2JETFk1TlBQNGZKeUk0L1Z6Snp3OGpyRHFiTEh3VDVpNExMSDVDWU9x?=
 =?utf-8?B?YVZCZThpYWR6SHV4ckZaU1pxSE1UcXp1ZHRCYTZtcXlvejZrK0RMcERFdEFo?=
 =?utf-8?B?V2RreUJpOGZjMVdqdHJUZ1h5bi9hYXVKOVJSQmdmNmlCdEsxNThKb09BR28z?=
 =?utf-8?B?UUtHdnFqdXpWOXhjZ2ZsdFZkbmxQRG94MTR1K2wxUDBxUkhvTXEweFNpcmQ2?=
 =?utf-8?B?UTEzelB3MmVzTzNvWXU2SHZjNzd1TVQ1Y2J5bzhlSGlYakFuODZGQ0JoM3FN?=
 =?utf-8?B?YTNIVUVGK0RZdWozajhobUtXdFJldTh6UFUxL1plTW1xbHlnMjR2ZS9wd2Nv?=
 =?utf-8?B?c1RkdHN4R0F6RUJ6bVNQWTJ5MGtPNzFncHN3dmE2d2lWZ0wzRXp0c3FLVzVL?=
 =?utf-8?Q?kE7uT/N0dJL70zv9s0g1m5SRMs6yUHJWwIizFAP?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b274dd0-26b0-4c70-db51-08d8fe1d0207
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2021 01:39:41.6150
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y5SzTs3cX5KZPOC3uBSuAqsifVsmssSsN8JZFnBn62KG/vOG2Gy8bLfXqlT6JoaMIIN/KSCDfPtYc8PvCgaDog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4443
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 4/13/21 9:07 AM, Sudhakar Panneerselvam wrote:
> NULL pointer dereference was observed in super_written() when it tries
> to access the mddev structure.
> 
> [The below stack trace is from an older kernel, but the problem described
> in this patch applies to the mainline kernel.]
> ... ...
> 
> The solution is to call md_super_wait() for external bitmaps after the
> last call to md_bitmap_daemon_work() in md_bitmap_flush() to ensure there
> are no pending bitmap writes before proceeding with the tear down.
> 
> Signed-off-by: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
> Reviewed-by: Heming Zhao <heming.zhao@suse.com>
> ---
>   drivers/md/md-bitmap.c | 2 ++
>   1 file changed, 2 insertions(+)


Hello Sudhakar,

A few info to you. If I understand kernel patch submit rules correctly.
1.
You couldn't add the line "Reviewed-by: Heming Zhao <heming.zhao@suse.com>" before
I give you this line in my email.
But take it easy, you can add my name now.

2.
This is v2 patch, you should change title from [PATCH] to [PATCH v2], and
also need to write changelog in patch.

Thanks,
Heming

