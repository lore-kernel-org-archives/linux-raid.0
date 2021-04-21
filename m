Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06838C433B4
	for <linux-raid@archiver.kernel.org>; Wed, 21 Apr 2021 08:13:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C476061437
	for <linux-raid@archiver.kernel.org>; Wed, 21 Apr 2021 08:13:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234439AbhDUINg (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 21 Apr 2021 04:13:36 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:23645 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234074AbhDUINf (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Wed, 21 Apr 2021 04:13:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1618992781;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RthpS9XT3XrMxjpnKLahUWKSsuRhhlzqxzrzIqCFffg=;
        b=RZ2M2Y/bNXHdHJ7vlulhb/Aexaxtvxo6dGCCbsnkyciZiQe4M795Fzb2Ncsn3zqVRpEDIp
        LLLvmG29e3KU460Uib+ph/IJAwpjEakBonokTbOB09gaTbNrvlX5teRo2z8D292WLafF8d
        RMViJgKmqrXiPxgzx6GJFVzP5vArLPU=
Received: from EUR02-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur02lp2053.outbound.protection.outlook.com [104.47.5.53]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-24-S7TwJMqvMZaYSlb0vTqCjQ-2; Wed, 21 Apr 2021 10:13:00 +0200
X-MC-Unique: S7TwJMqvMZaYSlb0vTqCjQ-2
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QSh41sdal3hHGF432RfEaFLxHVYXAOMfI+skkDYJCYf591dtseF0rbrbOd5rx2wiINK/Gj2xkiSxkop4hK3K+8ZGmTb/xKLNGZihPbApKH47FF2BvaGJySFC7gwjBQBn+8gagRH2redBWa4On8pQ505KOOxlRf/D6kuaCN+Oh5+9FqNTwoBe0cMkCWZFtELkgiBuSDIXHFsxHV/RIhyBEhzB8byoxsKBINB+K9QdWUM9ELDKofGpeUTRw07NaiekAdh2gOt3UF3GMSZnV6xkdyAaDib2fRIPQY5rEaDpN8AKelZS639GpiX4atKD6i0nPa/pX6/4b8xrPUExqYawxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RthpS9XT3XrMxjpnKLahUWKSsuRhhlzqxzrzIqCFffg=;
 b=GZQ757Y7HCMzJ0tmNTb0YyTvg/8W3p/JYXbDlozpfFPbg/EoE49/w1BwNhaC8dy3WkwN0FiYS6x+wieiveZt6AUJpSVoO2UzOQ97mODo/2V3K7FMfG3qkcefbqrbVfa1YbYx8HRXFBL5xDuSFPvCpxhvSIYLi/c3T8BXghUj65WjbZRX1p/Ba2pnarZcO1f7KjAIKPKIOoylBja0KYzxuYndXNO6UpD9totElGCvsTWUReRxsQeLRNUyLBO8T+R3IsQ+IT+ibpj2/dE0PHbBd6knHOTbZhVNGxSqlCcRpWSe0tUnsxErW7wP5daf+3jqlcZn/0dt+yEbtsioyApZ9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB8PR04MB6699.eurprd04.prod.outlook.com (2603:10a6:10:3c::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4065.20; Wed, 21 Apr 2021 08:12:56 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::2c69:3d93:4901:ecfc]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::2c69:3d93:4901:ecfc%3]) with mapi id 15.20.4042.025; Wed, 21 Apr 2021
 08:12:56 +0000
Subject: Re: [PATCH v2] md-cluster: fix use-after-free issue when removing
 rdev
To:     Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>, ghe@suse.com,
        lidong.zhong@suse.com, Xiao Ni <xni@redhat.com>,
        Coly Li <colyli@suse.com>
References: <1617867855-17481-1-git-send-email-heming.zhao@suse.com>
 <CAPhsuW7QnNbAcjVOWzZMJPHiJ+EVcSyxBN9+MogkPHndXvaSBQ@mail.gmail.com>
From:   "heming.zhao@suse.com" <heming.zhao@suse.com>
Message-ID: <fbd6b3ad-1c25-dc75-156b-9d92cb55c19b@suse.com>
Date:   Wed, 21 Apr 2021 16:12:46 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
In-Reply-To: <CAPhsuW7QnNbAcjVOWzZMJPHiJ+EVcSyxBN9+MogkPHndXvaSBQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [123.123.130.223]
X-ClientProxiedBy: HK2PR03CA0055.apcprd03.prod.outlook.com
 (2603:1096:202:17::25) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.130.223) by HK2PR03CA0055.apcprd03.prod.outlook.com (2603:1096:202:17::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.6 via Frontend Transport; Wed, 21 Apr 2021 08:12:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 654ab2fc-d879-4c88-8080-08d9049d44ae
X-MS-TrafficTypeDiagnostic: DB8PR04MB6699:
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB66995B8F0519D6334FC69FF297479@DB8PR04MB6699.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:369;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PXD4WdYtv9VNFxD871lFU0Jpw7YksHEKDk7DtBs2Txkk8ilW1WRxh+Bw8a2xZeqcFvHX81BB3t4u9gEyAUnv5NE+MhIJvYHuAdnBxD0z6OxPPdQEFT38ExAmIIY+YtHBLHpWhdX+U+MZ1kLiKNnT0y7LJcot+renx0m17fJgtEh1joNVJafMWgKaZr2RMKYRlHot3+9+UIC8tPvrHr2p1ASmJb5lMC+LRKOritR/C+6AeSmmYrW1QDiDDwThIg9pzb5r9Q2vg/3PkGhOlvLs7+MoOrQ6scBRNZn3n+8HbbLQ2M87U4rW/wAzHJr70yrnb0F2hzBETGjOqVbtQV65aJvMgX7pTJmW6+WwE8zzT4U5LhBRJiG+S2wc/a8LLT7XJjVfnDKxuVhnzwvcwuK4xVBpwHRlLyFpfptCPXQP6HfB6Mt3FxOO5E4GqZFCfUgJpmnIeeX4nTroF8O4wCxKaeNXyGaWPKgWG7vUjaCxQurTjKvdGdjgrkz0CPKpkgmiCZWonV4kadNvyXmYIyhoNeeFOgINoWQj/+zWSIjNFIaDoFKvir7an45nNMM2w/pTgt3R4YWTvn0xjRx6wzGivwvgsqTB2K8832BKQGkjXfcGjsgX0RMtOE9H4FXBiv75NyAz3EPLK2NMFXNx9Ur61m0oc939zzU9BVr0bSgM3avEZig2PV5Sxuz7QYAYsqyIOs18hLbikai8fKvfwxlLoEiWNXwd5oWQ3jV0MuDitdw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(39860400002)(346002)(136003)(396003)(16526019)(66946007)(53546011)(54906003)(8676002)(478600001)(4744005)(31696002)(6916009)(6506007)(5660300002)(31686004)(8936002)(4326008)(6486002)(316002)(2906002)(36756003)(2616005)(38350700002)(38100700002)(956004)(6666004)(107886003)(52116002)(66476007)(8886007)(86362001)(66556008)(186003)(26005)(6512007)(9126006)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cGNpUFc0Tyt2bkxsR2R0bU5vNHJvZGdBdklISWxCUmpIZmwwR01ENnAwanhq?=
 =?utf-8?B?MHIrR2tqajNRNnhxazgwVm91VjN4UVNxRG14ZHg5MHovS2xMaVRyNDZpcEVH?=
 =?utf-8?B?aHVkN2xsR1FtRHR6azQ2L0luQmdhL0dkeUIyQ2R1QjRnMEQ2M0lWQjR0UGRO?=
 =?utf-8?B?Ni83S2MzcjJlTEZTSUc2TmZYMVR6ZDZnMm5LTHluNG4wYS96QVNkQ3NHU2ND?=
 =?utf-8?B?MFIrZFVyZ2F0c25nT3VWZUhnQ1FEQTNnbGpHaEJXamhpdmFRMnRKUFFOZTlx?=
 =?utf-8?B?QWNKNnU5d3FqRjFsQ3hQcFNtNGJVREVud0hzbXUrRWdDVkRJeWMvdTZSYkEy?=
 =?utf-8?B?a2N2Y2FjWUlBNG9VdlIvbTE5K29RZEc3WjJ2QVE3Q0RuSTRqQnE0NWxsRkNv?=
 =?utf-8?B?T3E2VFhiT3pRbDdQdDJuQkRodW9SbG4rME9wemJaRlo0UlF1TWI5cXRVaXpL?=
 =?utf-8?B?OHFQU3hTS1ZiQjE0QXVuVHVpZ1J3cjhob3p3cmhOS3NzVzhCRzQrQzNuTWtC?=
 =?utf-8?B?UFlGdUYycHZQSUxJSFQxU3NSakhrMkh3TnY5eU0rL0pMY2NYanBvUDc2Wk9a?=
 =?utf-8?B?SE5RQy9wcUMyc2JzZ0tKNStTY1VkY09tUURSdFpERE1WL3ZXcVM2SExMdVlU?=
 =?utf-8?B?MkN5cncxMkdpcHJCQzM2V0w5anUwS0hjR2I3WXd4cjFiV1E2WjVaQXRTNk1M?=
 =?utf-8?B?eWxHcFdoODJrMEZDdDVZMGlmSzNReGo4bm5PV0p0dmVWVWs3QmF4bkxEZjdN?=
 =?utf-8?B?V3hIWVd3ckQ3VkV2eCtSTGpXVG9lSUxrYTcvb09reGljYTllSnFQQVRUTTJ6?=
 =?utf-8?B?T2NGbG91L3ZHeE5GUElwNFlpdi9zMlBhTzJlRktRZHNadXN3ZE5OWTNiMWlZ?=
 =?utf-8?B?WmJYQ1dhSjNZYlhvUnUvYzN4Z1FxWUdiWThnZW41cXFnTDgva21pa1hNMWFo?=
 =?utf-8?B?cVJ2cnZKWDAyUEk0MFMvTjlRUGlMcWVXem5RNEN4UzNQOWFuZDJadFFFRUNv?=
 =?utf-8?B?eEJBTk9SRkM4TXJvVnJ2MGtmTFhXKzJtN3pFd21XaWtJSm8ySFVvNzBsems0?=
 =?utf-8?B?Q2F3RUNXRjNkSHhGVTFpRjZnNk9pT0ZsT0NjL0dhTllsY1NGRGF0ZXl6VGNy?=
 =?utf-8?B?Q3l5MFVOR0FxWHAwVkt2MmRGRjExRmNpUjRjbzhwMkV1dWoxamhsU1hUOWp2?=
 =?utf-8?B?dzg5NVlwR25KOUhGcTBtdW1IRU5iTkJJNzdpUkxLd25KOUlIenpSQ2NLTnVX?=
 =?utf-8?B?NU0zYW1TNnZRV21YSUlCWWE2dG9Ta2k3TkdwMWpGQkRMR1VMS244NDlnc3NJ?=
 =?utf-8?B?aGJ5WCttWk5jQnY5Z1hiN0xuVEg2aDAwS2F1YnBVVWxVUDV5eThaRk9ZZ2Vj?=
 =?utf-8?B?SHNySjhLMTk4WTRMUlJsanNWZ0MvYjhocGU2VnBqbnN4SStseXJVMFBKaHl2?=
 =?utf-8?B?YmY5bmhrOW9DKy9BaDljc2E4cDFIczE3Umw0dkZsVTFjQTV4V0FmVFc0TXA0?=
 =?utf-8?B?ekt2MEZDNm5UajE0RjduUFdlL1dOdE1kTzJGekJDeWlJZm02blpQd1FKUE5P?=
 =?utf-8?B?dyt1MzBhWGZmdHJYUjJ2a29uZlRKTWN6a3grUHBPSThUbHFFSDNSVllLdjJU?=
 =?utf-8?B?eHRKZzREak5KSlUzU1JuOWw2VFJNaVdrMFJ3emdYbUQzYzRBUHovK2lhdnVL?=
 =?utf-8?B?MGVsWGVnYko1MS9nOTBZTkpFRE9ka2FzWUw0ZjRwdmF0cWQ5LzhxV1NSU3lw?=
 =?utf-8?Q?o6IzPcimt3WMsXNdPQJqI9OI2Lk1OMlRhn5OKQX?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 654ab2fc-d879-4c88-8080-08d9049d44ae
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2021 08:12:55.9648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ggVdDOCm67NgozeFeK9jEi2DEaVJWc9zt7zY/x/qJ1T0aLdFx4XOSWm69KYy10jQY6EhpYpOgRysxRKFDI0m8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6699
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 4/21/21 7:15 AM, Song Liu wrote:
> On Thu, Apr 8, 2021 at 12:44 AM Heming Zhao <heming.zhao@suse.com> wrote:
>>
> [...]
> 
>>
>> v2:
>> - modify commit comments
>>    - add env info for test script
>>    - add 'Fixes' filed
>> v1:
>> - create patch
>> ---
>> Fixes: dbb64f8635f5d ("md-cluster: Fix adding of new disk with new
>> reload code")
>> Fixes: 659b254fa7392 ("md-cluster: remove a disk asynchronously from
>> cluster environment")
>> Reviewed-by: Gang He <ghe@suse.com>
>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> 
> Sorry for the delay. Applied to md-next.
> 
> Btw: I think you meant to push change list (v2, v1, ..) after the signed-off-by
> section? With this patch as-is, the signed-off-by section was dropped during
> git-am.
> 
> Thanks,
> Song
> 

I got your meaning and won't make this mistake again.
I will resend v2 patch with correct change log position.

Thanks,
Heming

