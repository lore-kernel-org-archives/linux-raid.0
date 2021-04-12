Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A09B0C433B4
	for <linux-raid@archiver.kernel.org>; Mon, 12 Apr 2021 10:03:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D30261221
	for <linux-raid@archiver.kernel.org>; Mon, 12 Apr 2021 10:03:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238802AbhDLKDc (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 12 Apr 2021 06:03:32 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:33252 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243779AbhDLKAA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Mon, 12 Apr 2021 06:00:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1618221579;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lLpICJvHgJvwkP4UQ3Z0LhM4sGCA7fwE5A668pP5p9I=;
        b=LmkKq7nbh/rtjV89H6M5j0qu8aLrnDDLGJlixZ9Z1bxx0wllIOM9ZpHpJljVAQ2mid2djc
        Ern68SYr6jd+Zr9fcffOBqJEZKUBSbgvoGzhvBknnftVVSgMU7TpWaXRHqLsKVnMzxTg8k
        TxrbpR1KcJ2UShZMI7APmruIwjclwOM=
Received: from EUR03-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur03lp2050.outbound.protection.outlook.com [104.47.10.50]) (Using
 TLS) by relay.mimecast.com with ESMTP id de-mta-3-24qiOdjHOkyRQky57BVb6A-1;
 Mon, 12 Apr 2021 11:59:22 +0200
X-MC-Unique: 24qiOdjHOkyRQky57BVb6A-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X4flWdCNziSkcYKYlNRR2xSpL2FwRVYrkw2ON8zH9XB9BSrGLFH5Mt2JS1zuYyRJhm17Ww6yHTiTflmtuw1elMfFwREUX6ozEf1nztoeAIJRCDSOsDyc30aTji/vNaAAw8FjpE1outP4wEAyeWiJWmcb0wP3fvt/5Db3sVNn0yYV4ub8Ambs/8KfwhgMW1xfwr4v1KqvM6R790EJw0TzMtuzDngZsqSZWQ7bsGzvUJEHv5w8pPINmgzMmWRfRxlI+j95F9E5vqT+WoT+FDUD5pfOAitv6J+4RNUpgfS5UK+OYLqCGjz8XbTMXYqoXDrC+XZpoogae50rb+gaxOi0UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lLpICJvHgJvwkP4UQ3Z0LhM4sGCA7fwE5A668pP5p9I=;
 b=B6m6m6GMPcYAck/P4q/QgDLABSfysKs8Sn9AATPCuzvQM8ihiL5WhaRa6aydIvrr098gLFvSIoVqyPT7BfHhUD8T6xL/u6HCaakL/m0XerdaCIJtv+0KyVMbVwg+iCkOIvZGKmLSZWRQoF7fLdmJZqk4qQWuXRBuKjqWVSDX3IPa1mRpLLEo4D4XqFnw1UobXPqIOj7iQ2kxIWDPEr7zxc3qRigN8ErKd+9UwwVqiGgAkHvUT1gXrQY8/tfgWbK/ohBGW7IhZPQFphOjWd74MjgVozUtO0H7/8GwrtLpQB2+lA3qQ8nLXP8I6+ySoWMm2OacVV2A/A4bnmRyEPZSow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB8PR04MB7065.eurprd04.prod.outlook.com (2603:10a6:10:127::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4020.16; Mon, 12 Apr 2021 09:59:20 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::2c69:3d93:4901:ecfc]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::2c69:3d93:4901:ecfc%3]) with mapi id 15.20.4020.022; Mon, 12 Apr 2021
 09:59:20 +0000
Subject: Re: [PATCH] md/bitmap: wait for bitmap writes to complete during the
 tear down sequence
To:     Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>,
        Song Liu <song@kernel.org>
Cc:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "lidong.zhong@suse.com" <lidong.zhong@suse.com>,
        "xni@redhat.com" <xni@redhat.com>,
        "colyli@suse.com" <colyli@suse.com>,
        Martin Petersen <martin.petersen@oracle.com>
References: <20210408213917.GA3986@oracle.com>
 <ba0f4827-83ae-b7e2-2230-5f4afca2538a@suse.com>
 <CY4PR10MB20077F9F84680DC1C0CAE281FD729@CY4PR10MB2007.namprd10.prod.outlook.com>
 <2becafd0-7df7-7a79-8478-b8246f353c9b@suse.com>
 <CAPhsuW4S-FERHGfj6ENC3K70+9tMsupWVmc9yhLoLWB6qX0jMA@mail.gmail.com>
 <CY4PR10MB200755C47FFA2EA54F82E8DCFD709@CY4PR10MB2007.namprd10.prod.outlook.com>
From:   "heming.zhao@suse.com" <heming.zhao@suse.com>
Message-ID: <a33cc4b5-2ced-86e5-ae20-242b4f3478c9@suse.com>
Date:   Mon, 12 Apr 2021 17:59:09 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
In-Reply-To: <CY4PR10MB200755C47FFA2EA54F82E8DCFD709@CY4PR10MB2007.namprd10.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [123.123.133.187]
X-ClientProxiedBy: HK2PR0302CA0022.apcprd03.prod.outlook.com
 (2603:1096:202::32) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.133.187) by HK2PR0302CA0022.apcprd03.prod.outlook.com (2603:1096:202::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.8 via Frontend Transport; Mon, 12 Apr 2021 09:59:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fe61a4cd-368d-49ad-fb0e-08d8fd99a429
X-MS-TrafficTypeDiagnostic: DB8PR04MB7065:
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB706513DB5B5DDCB97A9C762497709@DB8PR04MB7065.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: apVDvIvY8AMh7j2zCX9GZ1WTG7JBoyTu/2Kg4cuWV2fiQekxmroHdNKKQ0fvSIx5sI9Gh1rGm1Lhg9/GNB8LLbza0UboH8PxxQw21Dm42hAl9YEAuqTsHDwnT4PrERNxZ6dEzohi6PAE3R8njAoVbfdk5XB6G3ikYXMYY1Zyf43vSuAeNuP/jKW/xhgzdk9BJHWSMclABWSSOK4549EKQbTmtefpqWZ0t106313UaWmKnksqZNrXuL8u40J8gZCSEL8jiYgQGvaJyQ/KlPOGoSx+7lY9b+dNRbGGUsXzaAroSFb3PUlKDvjY0RpsFfY+4xEMgiFNFaWdOWp46tsdtbiEbTiaWMr5LhyQIBL4/YRkzRc4pSGxZVbKckrndf08VXXX2XWSRT/C0KmzaqdwG6LupnB9y7KjnQrrtuNeF4ubMgJ7DGeaupYT9nNhJnwFxUYkYPgD0blSlnomKrNEfbqgN2YEX9psZ0QMYL9crYv4AREEkvJlK5yWAlQnZEGb6q4ZgJykhmeOsxKyit3LQgiHMNAzeVOAvf00AmAatsRx/3iwISYG7e8eQ9/bj1QIACOB5TPt0AELMzbLrGc+PLlhA7aGe7bUyBA/UqJOMxOecVh0Kck6RWidGzxaTRW0f72kyTtAk+Pq6XjC8oTW/q4HVZfbYfslj1fKrm+jv2Vke1+tqN/ut8PSGp5gfJ2A3MS8HokU7cVLvLRm36U5pDLbNshrSNr+WjdxrJHDeJ4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(376002)(39860400002)(136003)(346002)(83380400001)(31696002)(36756003)(110136005)(316002)(6666004)(186003)(86362001)(8886007)(38350700002)(4326008)(38100700002)(54906003)(956004)(478600001)(2616005)(26005)(52116002)(66946007)(5660300002)(6512007)(8936002)(8676002)(53546011)(6506007)(31686004)(66556008)(66476007)(16526019)(6486002)(2906002)(9126006)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?b3JLcnhzN2JKamxKR0YydjBGbmpYUDdQY3lQd1Z2VWluNnBnTUJRS3pGNDBs?=
 =?utf-8?B?YTYzcW9jbVgyYkhyTVpzais4VDFPdE4yTFh2K3FHbEYxd2diUmhnWjJSU2lW?=
 =?utf-8?B?OTNpcUhwV1QvZGFjRmJLK2Vabkk5MTNZaW5lTVBsQUtWZUlnblh3b3VrTmh3?=
 =?utf-8?B?MXlxRDRsVW5kYWlNWWsvWVl4K3YrUnQ3NHpvWGJmQ1VpOGpwTjNUWVlnRW1L?=
 =?utf-8?B?UENwWHZPNm5jY3R3QkxHbTBRUE1scVkyWnJ6cUlvc25HOW5abkZ6eXdPK0gv?=
 =?utf-8?B?NHNBR3BOdFBGVHA4elNDZ0ZqTThUNlJpU0drZTlkZzBwTlNuQnZDcTF2Rmx2?=
 =?utf-8?B?ZG9icWFpWlBRSnBlVUVpKzlBV1VTYk0yTzZqRGhmcXdWT3prYjJUOFpnSFdV?=
 =?utf-8?B?ZUR6VmpRcG1kL2NZTlFpclQ1MG9jc0haamJXT2k2NXVJRE42ZWcyVkc1Rlhq?=
 =?utf-8?B?b3RzVWZnMXhMbHdYNVlhQlJCelpZU3B1Y1dMMnI4SHJmMis1YzA0QlB5VFBQ?=
 =?utf-8?B?TXFTa0VsQTVVODUyUVoyRUxBTUlwZG5LYk04MnhHNXMvaTFiYUlyVEUybWFX?=
 =?utf-8?B?M0c4a1BUT1VLQmhBR1l5Z2NHRHdta3pzUys1UXVaUFNPdGp3SEtZaTA5azhh?=
 =?utf-8?B?REdQL29SaGpwcUpWYmtOdmdVQ2F6VHczY0JWMXVkWFQxNUdmZTBkMG1vYWln?=
 =?utf-8?B?MDFhTFh0QmpSaFR6S0VjT3hPS1hyWktPYmh5b2hHQVdsbWRzUHJ3VEVJdUt4?=
 =?utf-8?B?WEhBQU9sSnd4dldFTkVPV0NPRGVJNnBGbTdXTVhrVkwwMThjb3JMT2VtczZl?=
 =?utf-8?B?ZHhTaWVSOVEvbUdobUFCcXJjdFNwSWJCaVMyNmJucmNiNnMxTVFTaUYwMGQz?=
 =?utf-8?B?dmlWVTZ6WUJBUFpENklaWmQvUHRDVkNoMTNTMWJ5M3Z5SHRRVGJwZk9JWmhJ?=
 =?utf-8?B?Slg4SjRhWVh0YWZ0SG5WK3FqSFhyVTNJM1FUZGp0VUNNZ1NpaUJ1VzRPbFFq?=
 =?utf-8?B?TVJkcUxmaDRiTFJwRFdKQkZhTnd4akdrMVNYVFBON3dUSkFaUDdnWGFVT3Vj?=
 =?utf-8?B?dHZ5RnRyOEVtWndmSERseTF5QUZ0ZENIT0NhL0lhckc0NmtWckt5VDgvcTJk?=
 =?utf-8?B?d1dCSDNZZXBiSjZrYUdUNW5ndE5qWTFTUTZjbFJoSFdHMXEzcXhGOEtPRDVK?=
 =?utf-8?B?TjZ4Ni92N2JQUHJ3cVU4cnNkQUs5cGtvb3lWUFhNdDIrZjlSK3pTL2VhUllQ?=
 =?utf-8?B?UU8zMStoakd2aExkZ0JvZG4wNlZrOVJWaG1aREFrYXNVbjEwL3F0LzI1VWZw?=
 =?utf-8?B?QUcxV0d2YnhqcXBGYkhxRlc2R0VmblR5azBISjlyWU9wSnF2Ri9KMHZJLys5?=
 =?utf-8?B?c1VodGFLOUlldWoxTHVKaXNpemIraVVVaUNab0wrZjdVYXMxZGRicEZJQVpJ?=
 =?utf-8?B?eEI0d1dpQVJBQTRWV2dZN0JLOU12TVhPY2x3a3dBSmhmd1p2VVNEZTVNWHZN?=
 =?utf-8?B?MHRpeXh6eXJEaWNwbzIzKzhqTTV0czdpNWNmQ2oyenFMbFRiMUQxTEdrZDFx?=
 =?utf-8?B?TTcybVR4aW9pY28ySEx6RlN0M1ZwZVpSQTNSNzZyY29UTTVadEVxSThubVNL?=
 =?utf-8?B?U3pkSWZLVjJDK3BXclVTeDRvNGh5ZzR4ZDNNcUdTak9mVXQxSXJNQWROazlp?=
 =?utf-8?B?YkdZMTNPaytjVlI0SGt2T1ZVcTBoeEJuZENyV3duWSttSVA3SGpsVDlpanJj?=
 =?utf-8?Q?6vIXUbgi/hq5Rxp8HXgRSiS200wA9Ap38c72baO?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe61a4cd-368d-49ad-fb0e-08d8fd99a429
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2021 09:59:20.0802
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kf79/wrFdqNboHFGMQh+WAT/Y/8LetFbPkPu88zJpDFX1sCdCpvugD/zUeACt5Y1x8/oexkrc6fftdLSXgEb1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7065
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 4/12/21 5:38 PM, Sudhakar Panneerselvam wrote:
>>> In my opinion, using a special wait is more clear than calling general md_bitmap_wait_writes(). the md_bitmap_wait_writes makes people
>> feel bitmap module does repetitive clean job.
>>>
>>> My idea like:
>>> ```
>>> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
>>> index 200c5d0f08bf..ea6fa5a2cb6b 100644
>>> --- a/drivers/md/md-bitmap.c
>>> +++ b/drivers/md/md-bitmap.c
>>> @@ -1723,6 +1723,8 @@ void md_bitmap_flush(struct mddev *mddev)
>>>           bitmap->daemon_lastrun -= sleep;
>>>           md_bitmap_daemon_work(mddev);
>>>           md_bitmap_update_sb(bitmap);
>>> +       if (mddev->bitmap_info.external)
>>> +               md_super_wait(mddev);
> 
> Agreed. This looks much cleaner.
> 
>>>    }
>>>
>>>    /*
>>> @@ -1746,6 +1748,7 @@ void md_bitmap_free(struct bitmap *bitmap)
>>>           /* Shouldn't be needed - but just in case.... */
>>>           wait_event(bitmap->write_wait,
>>>                      atomic_read(&bitmap->pending_writes) == 0);
>>> +       wait_event(mddev->sb_wait, atomic_read(&mddev->pending_writes)==0);
> 
> I think this call looks redundant as this wait is already covered by md_update_sb() for non-external bitmaps and the proposed change in md_bitmap_flush() for external bitmaps. So, can we omit this change?

Yes, it's absolute redundant step, to add or remove this line is up to you.
I added this line for following the style of bitmap->pending_writes. The comment in this area also give a explanation.


