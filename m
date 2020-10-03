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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50FD5C41604
	for <linux-raid@archiver.kernel.org>; Sat,  3 Oct 2020 15:59:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0463206DD
	for <linux-raid@archiver.kernel.org>; Sat,  3 Oct 2020 15:59:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="MYV8Rwwe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725801AbgJCP7F (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 3 Oct 2020 11:59:05 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:58789 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725791AbgJCP7F (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 3 Oct 2020 11:59:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1601740740;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Kv4B6UCchO5zvQwNOwbObn/NrrxWljWgsKas7fiGrrI=;
        b=MYV8Rwweht6iZLz1hvTbxVOwkHRTqqeHHxoXPmq+87eevJ9CozWCx88jv7BDIH1o7MpTQV
        uZ9C+zaa9F2bctmR/2ZCtvwF9DlRg3QSDzbVxvNGUjq2FeUbdwk4c0RELYmO1/Q68ZoTU0
        COW3DtNbrYn8QdiNY0DviuHck+Dev10=
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-db3eur04lp2057.outbound.protection.outlook.com [104.47.12.57]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-23-9CeRvQwTOVe1B1q1HB_fXA-1; Sat, 03 Oct 2020 17:57:56 +0200
X-MC-Unique: 9CeRvQwTOVe1B1q1HB_fXA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cU/v5hosWPp+BirbCwRxS9V8JGonhEyPLqebZKRSGePm4qCnRbCBRtuNrEzyezyogieaFE2bbkjVcWAq9iouECclE5R5uPUx382CKW8UYerBe3ZXztIUjKnSk9kNYhefDA90cBu4cGsXZHp7jQ/n9L7FMA/HROh0TwBuP8oStQXJdGt8Mw1OzmMomcCzNVa2g5pjkWIypVI6Ecc/ZqMZsLZVLi1mkf+PQJmspaZvcGRJNTOByvw1b8/qW710rvr9g1+sDH+hsykIKywxjRiET167yOPpneLadiBEnfeiMEp7qZMv09TwBv/khI7HwnzxPRMCYgrebXa5MVbetB8odw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kv4B6UCchO5zvQwNOwbObn/NrrxWljWgsKas7fiGrrI=;
 b=DIWlFaabSM5p62zznpknGBZ7WBW+yrHUGcRH2TnoL8TZAxmsl8bjol73ZKcoVImeUayfX/5+AupRZOLLlb7b4qUnn9a5jf0CEaIHS9BMeJKLtZtsCIsjKTasBLboErMgVfe1ge8kmLKYfWDqzHP+g6IPnSHtbMj+eHEYULao2g29OdGABTG13c2uoSgFw0fc+AgpfGeXJ1/Wtjeg/2KbpolGQQ7GqWQNmLBFrMOStxgna8WAIJiV8ghZqviPR7PNB02t/N4wl6S+v6g6MKn0hU2ETUO0Md6mXipRxyqyp2rrp6VE/clK0dwGpxeDqC4UzPKdZB3NgCP5aIdurScGmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB7PR04MB5115.eurprd04.prod.outlook.com (2603:10a6:10:15::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.32; Sat, 3 Oct 2020 15:57:54 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::b59c:e9a2:d279:3904]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::b59c:e9a2:d279:3904%4]) with mapi id 15.20.3433.034; Sat, 3 Oct 2020
 15:57:54 +0000
Subject: Re: [PATCH] md-cluster: Fix potential error pointer dereference in
 resize_bitmaps()
To:     Song Liu <song@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Shaohua Li <shli@fb.com>, NeilBrown <neilb@suse.com>,
        linux-raid <linux-raid@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <20200804101645.GB392148@mwanda>
 <824849e0-c98d-1f22-817c-7a76d3ee22b1@cloud.ionos.com>
 <20200804111549.GN5493@kadam>
 <CAPhsuW4EKCMhL0T=1iMbVYrh1azZOD-jQ-vXDMmZ5cy2m-oW4g@mail.gmail.com>
From:   "heming.zhao@suse.com" <heming.zhao@suse.com>
Message-ID: <33855895-3493-267b-fe86-f3fa472580a0@suse.com>
Date:   Sat, 3 Oct 2020 23:57:41 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <CAPhsuW4EKCMhL0T=1iMbVYrh1azZOD-jQ-vXDMmZ5cy2m-oW4g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [123.123.129.194]
X-ClientProxiedBy: HK0PR01CA0059.apcprd01.prod.exchangelabs.com
 (2603:1096:203:a6::23) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.129.194) by HK0PR01CA0059.apcprd01.prod.exchangelabs.com (2603:1096:203:a6::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32 via Frontend Transport; Sat, 3 Oct 2020 15:57:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7222ac40-22b1-4f9d-c19e-08d867b516cb
X-MS-TrafficTypeDiagnostic: DB7PR04MB5115:
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB51157A8221CA809C1F76FCD5970E0@DB7PR04MB5115.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u0D9WN2Rf66G+DAfceKpKskImfNHjG70AX4QtJER2MR0Xk6R2vZQPnfp/tdm+rNuXgjeuVqOTwmOFaRml4iAudv8j1jPbHeNWM74J2rbSb1Tgp7rII3oUqWgffW0F//oJJrE7xaPvgGMZL8hK3qjTNikOajDGjgeqHVdn3XbPiq6C9JzlmxO2kSCy4Sy/M1e+rdN0dPwcj18jw8SwIAqx8cZqJ9sKNXfC7gSHUPkv+3uEj/WsTGkNK8ls/3D3rLMX0A8XbtJyK6zIPlub7taHH0z828V0BuvrorSG0MYDPhwoH352IWlePpwdEhUOxYA5Up6ulV18oGLz+Q1QVMIeg9cjZ6sz8B3raeILFGSx4XQeoBUHP3XdBXZXW5fD5QMOuLcjh92AZEESrP7yM261A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(376002)(136003)(346002)(366004)(66946007)(86362001)(66556008)(66476007)(26005)(31696002)(2906002)(36756003)(54906003)(316002)(186003)(8936002)(6512007)(6666004)(53546011)(478600001)(6506007)(16526019)(110136005)(83380400001)(8676002)(6486002)(4326008)(2616005)(52116002)(5660300002)(31686004)(8886007)(956004)(4001150100001)(9126004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: I45j37WGZQWa+HirsgC0qjPoyzRooL2TXjAP6Ije9VquDh6NeD1NMJ7pbonVd90lZR4vOfdavKQvJn77NYGjOSD1HCMVHAj0IkMOouAaiJGiE+h+05p62mh3ibuDN5HCnFJVz0+SHChEvz4tsPK1+fUMWdruY5oEY0k2Nxi5r8g8KXlI33vv7sq5kpjwJAURr4qodCM1gv3L97+u7jOBe4u8hyujT/UzcMMIhESOch+7Zfa3pyDF5M6nhKuEi/Jrh8kFsRc6bLt2VQ0xkggWAJPRuSt673XI/DOyouEOdsNqdEieOst/y01kdVAH1LAzhB8b9RPPoP7vF2TAgCn3OBNb5AxryJ/qMFwgqf+XSuq79n5uez2kBmcM889PlP1uitAkt5+N0AnNyCu5fxayXyXLo+rP/OgwBoEZ2MqdtgEh/CZUfnSq5CT+HYMA9PZzmMz0XUpipbBEHZ8tcIJjQaSCIZ7CAqDJqXOwhXvbgv2ZS0G0yrxF8/ig7nDX5vuulEooihARRbUrdd790TH7Oc3+rZDOFZT/Q7t1ye7WrA07m/CHCMF7TXUQePCjirvJUlx+oLR2reyD1GyM+bHNPNVByc3dLddxc9riEP4hjGSZ1kLAoOHaw/vXqs/ldnoK4eHKKk10/XSYNsMj0maZ5Q==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7222ac40-22b1-4f9d-c19e-08d867b516cb
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2020 15:57:54.3917
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OnsaIeOOIxJ7sjoS0zUYUj+pTNmPkmPFdGbvgHVV5mFhQEmLkzHCwyuqQRXyRwpNG2dD02UlqFiA6uCZUQ+bMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5115
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello Song,

I just found this mail, and I send a similar patch on 2020-9-27.
From my thinking, Guoqing's patch for fixing memory leak is enough.

the resize_bitmaps() work flow:
- first use update_bitmap_size() to broadcast BITMAP_RESIZE
  to all nodes, and waiting for the other nodes ack.
- then in for loop, by holding bitmap00x lock to update not booted
  slot's bitmap info.

the bitmap in for() is temporary, it should be safely freed on every
time of end for().

Thanks.

On 8/6/20 8:20 AM, Song Liu wrote:
> On Tue, Aug 4, 2020 at 4:16 AM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>>
>> On Tue, Aug 04, 2020 at 12:40:18PM +0200, Guoqing Jiang wrote:
>>>
>>>
>>> On 8/4/20 12:16 PM, Dan Carpenter wrote:
>>>> The error handling calls md_bitmap_free(bitmap) which checks for NULL
>>>> but will Oops if we pass an error pointer.  Let's set "bitmap" to NULL
>>>> on this error path.
>>>>
>>>> Fixes: afd756286083 ("md-cluster/raid10: resize all the bitmaps before start reshape")
>>>> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>>>> ---
>>>>    drivers/md/md-cluster.c | 1 +
>>>>    1 file changed, 1 insertion(+)
>>>>
>>>> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
>>>> index 73fd50e77975..d50737ec4039 100644
>>>> --- a/drivers/md/md-cluster.c
>>>> +++ b/drivers/md/md-cluster.c
>>>> @@ -1139,6 +1139,7 @@ static int resize_bitmaps(struct mddev *mddev, sector_t newsize, sector_t oldsiz
>>>>              bitmap = get_bitmap_from_slot(mddev, i);
>>>>              if (IS_ERR(bitmap)) {
>>>>                      pr_err("can't get bitmap from slot %d\n", i);
>>>> +                   bitmap = NULL;
>>>>                      goto out;
>>>>              }
>>>>              counts = &bitmap->counts;
>>>
>>> Thanks for the catch, Reviewed-by: Guoqing Jiang
>>> <guoqing.jiang@cloud.ionos.com>
>>>
>>> BTW, seems there could be memory leak in the function since it keeps
>>> allocate bitmap
>>> in the loop ..., will send a format patch.
>>>
>>>
>>> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
>>> index 73fd50e77975..89d7b32489d8 100644
>>> --- a/drivers/md/md-cluster.c
>>> +++ b/drivers/md/md-cluster.c
>>> @@ -1165,6 +1165,8 @@ static int resize_bitmaps(struct mddev *mddev,
>>> sector_t newsize, sector_t oldsiz
>>>                           * can't resize bitmap
>>>                           */
>>>                          goto out;
>>> +
>>> +               md_bitmap_free(bitmap);
>>
>> Hm...  I'm now not at all certain my patch is correct.  Although it's
>> obviously harmless and fixes an Oops.  I had thought that that the call
>> to update_bitmap_size(mddev, oldsize) would free the rest of the loop.
>>
>> I really suspect adding a free like you're suggesting will break the
>> success path.
>>
>> I'm not familiar with this code at all.
> 
> Thanks Dan and Guoqing. I applied Dans' patch to md-next.
> 
> I think we are leaking bitmap in resize_bitmaps(). But we gonna need
> more complex fix than the md_bitmap_free() above.
> 
> Thanks,
> Song
> 

