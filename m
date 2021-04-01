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
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF8D0C43461
	for <linux-raid@archiver.kernel.org>; Thu,  1 Apr 2021 00:45:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAFEC61055
	for <linux-raid@archiver.kernel.org>; Thu,  1 Apr 2021 00:45:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbhDAAo1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 31 Mar 2021 20:44:27 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:44484 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232585AbhDAAoO (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Wed, 31 Mar 2021 20:44:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1617237853;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N1QLSJNTMNUGwLs/udr0D8Gz9LarEyqA5yxdItftOik=;
        b=hkhx+RCHNHDjlJ3woNr1qfPe2ohyLp5KL0cqkf47S+5nqF1K0vZ/A2N8t6ALgnk2sqMgFu
        CX3OmBJ/kg+5jnvcQLLygsWKGX3sqlwUsJCegq/kJtFcds7fF0tL2mvaDhSeqt2klbTPhS
        qmldvoCW4U2E7yhBmRxImdzGegidwkE=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2173.outbound.protection.outlook.com [104.47.17.173])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-40-efe0sJXMOuWGHc8kkAm_BA-1; Thu, 01 Apr 2021 02:44:12 +0200
X-MC-Unique: efe0sJXMOuWGHc8kkAm_BA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bd7e0/JEldU/MOyS24tNFP64M2PqdhyAPchJgj6MAf9bog/xuIPokVQOANkqoCTsY98Fsjp4u9HURTD4WY0dLF2hxceqfMIVT56idADe6G3EZi8ImUpCd1vY37VLtjZBkwhexfHiZAxdT2n+xw/kINHq3heuEikvbioOv6jEWRcpgu9LwwdeEeSvH62tnei+AiBHFRNi8rYL7GBX02PEXbxmc4RmwR6kIoTRBBT3BBkaQmF4D2MoURshqd73liwJFrdFXXqLYOMSJmFEo063V4vqdT8MPp0B0hZzp7wOwVwXKLiMa21ML8P+Sy2D9aCmBDQndVaVu/3AeB3SVNXKug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N1QLSJNTMNUGwLs/udr0D8Gz9LarEyqA5yxdItftOik=;
 b=ij3hqwzdUio1UH/3B6uqsKhb1JLgyH/DsJHcOOClUeRsvQ/oq8CZS7VKGpupUFEqksMeG2hnvCzM5zEU6k2HMK69nLg6cZ8cKupMQnm3cnk9hdQK4E5YuFo0p18GePDNakksDrxeXdnVJEHsbHpny0dmI7TQGjA0xj8JdpNSQLJLuBAjcKjjTYrZmEiy3+yfC+j7z8jF3zeLrPO8+NaiRTRRk1+3DtY8Wj0vH8VOT1/2OlL1Fh428Lc8risHxTpUKtJcygCOsw/aPEpJxuTbNUVtdXnVcN24kP4ANaNISzYV/x82xJ/1HigB2agiInZ+MoPWPQG3QJFDd7rKH+mYlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DBBPR04MB7579.eurprd04.prod.outlook.com (2603:10a6:10:1f5::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3977.29; Thu, 1 Apr 2021 00:44:10 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::c5e3:4b14:8fc0:b393]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::c5e3:4b14:8fc0:b393%4]) with mapi id 15.20.3999.027; Thu, 1 Apr 2021
 00:44:10 +0000
Subject: Re: [PATCH] md: don't create mddev in md_open
To:     Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        lidong.zhong@suse.com, Xiao Ni <xni@redhat.com>,
        NeilBrown <neilb@suse.de>, Coly Li <colyli@suse.com>
References: <1617090209-18648-1-git-send-email-heming.zhao@suse.com>
 <CAPhsuW5HPP8kqR8LKhLHESbLnrmXu5Qrkub6kW0kQNofrHi6kQ@mail.gmail.com>
From:   "heming.zhao@suse.com" <heming.zhao@suse.com>
Message-ID: <2605c173-f6b2-43a5-6ae9-106093d93d6f@suse.com>
Date:   Thu, 1 Apr 2021 08:43:59 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
In-Reply-To: <CAPhsuW5HPP8kqR8LKhLHESbLnrmXu5Qrkub6kW0kQNofrHi6kQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [123.123.134.184]
X-ClientProxiedBy: HK2PR02CA0192.apcprd02.prod.outlook.com
 (2603:1096:201:21::28) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.134.184) by HK2PR02CA0192.apcprd02.prod.outlook.com (2603:1096:201:21::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Thu, 1 Apr 2021 00:44:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6cb0acc2-4a26-4901-0b78-08d8f4a74321
X-MS-TrafficTypeDiagnostic: DBBPR04MB7579:
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBBPR04MB7579C614BE781A5C4F704334977B9@DBBPR04MB7579.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:268;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R44oSzwuuE8pTpthlY3XYKcMDDAl6Ls+TlFn8I8zPPzCJVCVhb0mDuNPOFppxW+WIHjh+S7toug0wY7E7LZrotkmnTKOJ+Oz5rJQd4MFZD9LTs1xNVwthEBvCs9CBDYVtai6ewq0a8cirzOlSVyWPc/6FfGclSHDsNNpvN9btWPNEtnjEpMuadn0eb2/oxfY9N+/4XgQ41mu97hR+2BfbxyF12v4xKMZ0lgbtry9sxxUiqY5kqzxxMZwTj7jK9+XDclKE/vVrYB38zwLDreG+nn1H1XIoyJYH/5zzVFqpkE2qXHL3aKU+SDLV1ewVJ2fglxOM6I9pPTRwgbegvYTCu2cEVeXH9OHadBmFG95gbY06HP/vveP5gc+QUuH7SmDSbUkVuTs2vc4xdtxXYb8i1+fRag2jOerc3AlFqTFmpYXdG3lzvK12I2X2AZgUo92mfyZdlOlj24C37lcB6N72HHWvVhgtHk01AguLVyQK4jJA+iMWx2KmOpDNr2oZ5PgjPvj53SAOWMv/WGQO2RCQVN8cF7R/ogLGmOW0UJu4YOV11updQjIakdsuqu0c+TRrAQek7QkuTiQ4yOqTwtpk+GqvmC8T0o5IknubHJrW0Plhs5Uz8G5RhGlhrc7vKd++ov8Dw2BsRfOgFxF0SLeacMjFwhyz/EYzTs8FDKh9caGeFyiPk/ZIML1hZNCLIrDqCK9w4xVGyq+n16iZ/g8neodbB47LyWSxr3LkUC6fkSxioqvayfVegY3yrvaZ0xu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(396003)(346002)(366004)(376002)(8676002)(38100700001)(31696002)(83380400001)(52116002)(107886003)(5660300002)(16526019)(956004)(54906003)(186003)(6666004)(53546011)(4326008)(6506007)(478600001)(2906002)(66946007)(26005)(8936002)(86362001)(6512007)(6916009)(6486002)(31686004)(8886007)(36756003)(66476007)(66556008)(316002)(2616005)(9126006)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?QUIzM25ZelpuTXNaTkwyWllxa1pLakhMTEx3YWR2bHVvbHpaNTZVQzV6cjFl?=
 =?utf-8?B?MlAvRFRjbHZFZHQvdlAwSE5XVVJyMHRFbEt1dHQ1dWZkNFJJdGpaTVhBMjZx?=
 =?utf-8?B?NVRhV3djZDVtYURPdWZBZ3ZTbDFLRnBmT21iL2JFWkozZTA1dmd1dWduenpU?=
 =?utf-8?B?cFZsZWVFZHh1Tm9SM0x5Z2hTODJVR1M3WXdYSHhTd21QWEhCM2NKcTd1S0h4?=
 =?utf-8?B?NWdaMko0L1dMdm9VQkdCalFKUjV4WHkvVTVrWW9mbHVpRkV1WlVVT1crOFNr?=
 =?utf-8?B?MlhGZXdDcFB3MkFLeStNS1hJY3pwaTJyRm5NeTlhQ1lQSCtqN2hXNklJcW4w?=
 =?utf-8?B?QkFGa1I3cFMxaHBTY2gzMHdxS1ZtQ0puaHhaeU9IZ2VaUkNyT25EU0xHV2Jm?=
 =?utf-8?B?cEYyb3pLZnFsWm13WVBFYWd6eExiVm5qalNHN0JPWGFIUjQ3TUJlNHZaQ2F5?=
 =?utf-8?B?SVpuUEF0SVZxQ2lOYXRwenI3SjZaSlpaQk9MMWY1cUdsUDhqekZXTUxCZ3VD?=
 =?utf-8?B?dGRaUThWMWcvODBvQ3NyWkdsWjRZNXkyeTZnRUpReGdnUDFIem1DK2trSThX?=
 =?utf-8?B?NThGSi9SV3hCeFBHY25CM0kwZEwwT0g5N2toMGFDZ0dXRHVnVWNsRThhdGlU?=
 =?utf-8?B?Wm9nbmROemt2R2dqVDNtRTUvVElQWHRpcFB6NktQWEUyY21uQm1BQU1BZXhs?=
 =?utf-8?B?aE5ONWtIKzJVRk5VekNOalNnVUo2WDlhMittckRtQnBFZ2JLRjdGcEtpVFhY?=
 =?utf-8?B?cXZZMlg4YnRpY0JFd1oyL0RDSlpjclp0UlA2RllHWHRYNzRnSkJLR3VUbEVD?=
 =?utf-8?B?T0RQMm8rd2hMS3UydWZJd3UvTUIvYnpwdkZmOW5sSzR2dzhqbEtZNTFHb05s?=
 =?utf-8?B?c3JLdlBIaGdJQ1ZwZUpBbnpzUTZ6Tzk0QittYVlTYXFTM1RSS21iL2tPcGdp?=
 =?utf-8?B?N0hNbDdYeUhUaG5xclk2RUpuRCtFY0kzeEJQYkpGU0hrQkhtVWsrdjh6Zk9B?=
 =?utf-8?B?Q2YvTmxuaGxSUTZQQlFmdFFlQ2RyRlE5NkNoUjRLbHYrZHcrZXJ0QU5zR00w?=
 =?utf-8?B?NlZaMTJ3QTRiV3d0VngvQUVCWjlmb3k2cGRkN0U3NVBXTFJ5VDBLZkRPK1JX?=
 =?utf-8?B?OXRqek5GcmVnRHBud09nSWlaZ1lTaWkwMHdFem8yeGp5dFhVcFUxa3JzeEZC?=
 =?utf-8?B?Sll5TDlGZjZlOStuWkdlMDNQbFExb3FHOWJyQmd6RXljUVVvTGdYeTFjQUsw?=
 =?utf-8?B?TXhjVWdqQUdXOEhaSW5zMFYrY1pjVERRQXBFcS84RDZPZExtUVNJdmhSQlJD?=
 =?utf-8?B?RjlFZ3NZeVdKQzZ3SGRtdGNRMnd3VE5CR21VcFhpQVJ3d2lkSDhvNGlQaS9S?=
 =?utf-8?B?T3FUaXloVTNlN1NKRGhnSVpvN2h3eUVnQ3NTbzUvMDJWNGpERDhFZXlRNmg4?=
 =?utf-8?B?MU16WTFMVW5Fd0VhSVJsUlp0Q0N4dGVMSGZheU8yL0NFN2lHNStJc2JYdHNk?=
 =?utf-8?B?eU1LN0dDYTcyU2xTSkxnSXJhOXFTNzVJS0d0QmdpVVNsWk5GaFNnUVZNaEtk?=
 =?utf-8?B?N092amV0K25qekZsMC9OSlJJWHRLek9iUFBPVHBQU1RJa2VrcTZKUEhwUkNu?=
 =?utf-8?B?U09qYks1cTZuWS9jRnFsLzZ1aVZ4K0dYUmZKaGdUbnFlSDRBTUt1M2UvYkg2?=
 =?utf-8?B?REh1MXpjUlVIWXZXVGQyVXN2Sm5jVXF0emViYitVaEpFWmlneUk5cjZwRmUz?=
 =?utf-8?Q?NhjSmOIu1bnHLIuVuqpLZaMxJwKf3ssYyfQMA0u?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cb0acc2-4a26-4901-0b78-08d8f4a74321
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2021 00:44:09.9517
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c/q62FBTOoyp/GtwnadDC8WQc7YxjHf8a1wAc4grj9Omr7sfCJN4R0i7noYi8sox1M2nb9/5mE/hE4GY07QAvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7579
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 4/1/21 6:46 AM, Song Liu wrote:
> On Tue, Mar 30, 2021 at 12:43 AM Zhao Heming <heming.zhao@suse.com> wrote:
>>
>> commit d3374825ce57 ("md: make devices disappear when they are no longer
>> needed.") introduced protection between mddev creating & removing. The
>> md_open shouldn't create mddev when all_mddevs list doesn't contain
>> mddev. With currently code logic, there will be very easy to trigger
>> soft lockup in non-preempt env.
>>
>> ... ...
>>
>> Signed-off-by: Zhao Heming <heming.zhao@suse.com>
>> ---
>>   drivers/md/md.c | 8 ++++----
>>   1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 21da0c48f6c2..730d8570ad6d 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -734,7 +734,7 @@ void mddev_init(struct mddev *mddev)
>>   }
>>   EXPORT_SYMBOL_GPL(mddev_init);
>>
>> -static struct mddev *mddev_find(dev_t unit)
>> +static struct mddev *mddev_find(dev_t unit, bool create)
> 
> "create" is added but never used? Wrong version?
> 
> Thanks,
> Song
> 
> 

ooh, sorry, I wrote code and tested on SUSE sles15-sp3 & tumbleweed.
Then differed and merged code on upstream branch, missed 2 line.
Please see v2 patch.

Thanks,
heming

