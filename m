Return-Path: <SRS0=hplT=DP=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18BFFC43467
	for <linux-raid@archiver.kernel.org>; Thu,  8 Oct 2020 10:36:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 911592076B
	for <linux-raid@archiver.kernel.org>; Thu,  8 Oct 2020 10:36:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="DfyNFU6d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729311AbgJHKgB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 8 Oct 2020 06:36:01 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:32722 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725912AbgJHKgA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 8 Oct 2020 06:36:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1602153358;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1QlKsNfskmXC46DmOmCAEyxhokcRcEU+JAC0cUe4Kyo=;
        b=DfyNFU6dgR2fsrTjd0JfVJUUrLXHL/1ruwsKO2aRHOhDSZXYlieBsIclo4aa7ud7F4ijBW
        TRMqKAB292c+ro+zXjeINYUTtTWaCVJ8o50InmajakAm1RQwmN9mWPvanwysz8dtZm4Jiv
        aiA18eKNMkntWZKewxyqDPscKJTswCg=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2176.outbound.protection.outlook.com [104.47.17.176])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-8-cRiBXfeYPD-jQ9s0GWXSKQ-1; Thu, 08 Oct 2020 12:35:56 +0200
X-MC-Unique: cRiBXfeYPD-jQ9s0GWXSKQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lEjoB5RtVkwqQRJR91eE59+1jGikWqZf/Wh31bkGuuKttXEzCe68nkH9beZa1ny4Tbh/u/PCXpgKz6Y3fXC0LtdlYQ450uf6nzAq7aRyOLwi4LWB2N7m3r+/y0ioD2Gyy/LMNclXZDCDN+qEMV8UzhP9R6FDsgdquQclUI9H/dpDybTA9NIs4rjI4GJ11S96uGyVD19kVHYg4r2fKQtUSvrRzkMVaZMO1sUF+BDnPBxox9S+2jfdr0zuiMdV+vo17qy9U2t4l1aoAhvYYU5X48i0yAn+p54Rdd04OID8YSsAjZs+cMM/mUMXcS3PGNcarAF99hCxJvnWsqpG/3MG9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1QlKsNfskmXC46DmOmCAEyxhokcRcEU+JAC0cUe4Kyo=;
 b=nbqkwiSh/BZ/bExhfjg+S0k406ScmILwj0Q7juv0VLGsX1ldtDs4yh1yQD6Y2rK6wJMydn3nlHa+SVs3LkcTuGg1u4RCLPSKKwQFv6Y2wFbdtLIXjxIWQg8K6L4RMzOaK2ctgVwE7YUOSB5QwORox7E6e0NbF4pbH4LacTWgnTmNCbXcCvhZoN2IdRDqL1LdUEAjMhIgBKx8xDZQVNCVNYcRfqG3cZZieJrNx2YU/e4m+7RwVHN0DfNiTq0YCIwklIbZcxzJKt4wD98n+ueSiplcDI68QrBQJYtlMGDjaRpSn7m/rDr1pMzj3tts5WZ37m3Vq3Z6gXfRMpG3BMKgjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB7PR04MB4892.eurprd04.prod.outlook.com (2603:10a6:10:14::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.34; Thu, 8 Oct 2020 10:35:56 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::b59c:e9a2:d279:3904]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::b59c:e9a2:d279:3904%4]) with mapi id 15.20.3455.024; Thu, 8 Oct 2020
 10:35:56 +0000
Subject: Re: [PATCH] [md-cluster] fix memory leak for bitmap
To:     Song Liu <song@kernel.org>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>
References: <1601185213-7464-1-git-send-email-heming.zhao@suse.com>
 <fd2dddb4-13d1-31a3-a2ee-031a8e781634@cloud.ionos.com>
 <CAPhsuW4r=zwvKKs+WgqBfXiWF1Qn71OKH40ovVReJjPvkUcpug@mail.gmail.com>
From:   "heming.zhao@suse.com" <heming.zhao@suse.com>
Message-ID: <b9ffc967-42cd-9d47-fdb9-b920cf5534f5@suse.com>
Date:   Thu, 8 Oct 2020 18:35:45 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <CAPhsuW4r=zwvKKs+WgqBfXiWF1Qn71OKH40ovVReJjPvkUcpug@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [123.123.129.194]
X-ClientProxiedBy: HKAPR03CA0019.apcprd03.prod.outlook.com
 (2603:1096:203:c9::6) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.129.194) by HKAPR03CA0019.apcprd03.prod.outlook.com (2603:1096:203:c9::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.30 via Frontend Transport; Thu, 8 Oct 2020 10:35:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3acdc0b1-913a-42ab-f5ef-08d86b75f02d
X-MS-TrafficTypeDiagnostic: DB7PR04MB4892:
X-Microsoft-Antispam-PRVS: <DB7PR04MB48924667DE971650634D4E8D970B0@DB7PR04MB4892.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iTFqkOtjMBE6LTowoQpXf3UrOQR0W1Q7X4xhgBoa6QLxSbZyy6MCBGhYe8YUO0Ynd9pUR9pNJI1kNyRasCinK4PcFPLxycSUC5EiuOuP0Tk39rUSFA27lIcw3a4xONb1n1VuZl1REBOA1Zrb20NVm3BzwhfOetRdhDNHm7iHZwaRZdRqRTDejaqFFjlgz3hDUUNUxKEO6FrUE+4AmkELM1CkFUewt0J1JPtde/QneLbQ6tHcaThbl1/gEGMw/DLLTyd67/DZJAR/T5b6oscdz5HnehoAYIXCpRjPR+dyN32yWeROa+mjfC30QgOtAZFScfpDz8qKFh4oySyf1xni0V4qtSz7v/tBnC5tzzAcNt7VgcF+45v1yM3+B5MZtTaxjV45rjDIU8NNLQl42DLP2Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(376002)(366004)(39860400002)(346002)(6486002)(4326008)(86362001)(6666004)(8886007)(478600001)(66556008)(66476007)(2616005)(956004)(36756003)(5660300002)(52116002)(66946007)(316002)(110136005)(6506007)(53546011)(186003)(26005)(8676002)(2906002)(16526019)(31696002)(8936002)(6512007)(31686004)(9126004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 6ab1aaL4wdG3fH9cIfFmMPeIFy4vVtxjxT4UknSonPRsn8+0Hm5xbO1bDE7YnZSYNygIbGqfSmHpD4WIKfxzPmqY+S7zzgIFAwAXtqSJ9pW2J6rm6dBdnJK2W9lFcROkLZSbmeQJb32xy69LlysltC5CgZIixDQZGx3jdF7hKEAYRtJLcvnznMPFXIV6zKbCMOXoC3JAXonYRgQcKeaxCAIYqjfxyWMt0HDWLRqvS0Jwv8SVr6qekDSBI9SjLO5ttvA0KHdyy4DWFZj159g+exbPLlKe0RxwIXbdcrlYvJby4zsElzBJhektvZzjX0PkwRmco7tig/fIe5+pfVFHljXs4xHivp9c7jR8xOlzXswNxPx9wvHNYBrn998CalnKPdVZzF2KhGqtabFbE25N2kfLD3iGpY1Vxdi3PooDZzj6XlhUXotoBN8cC2100iczM83e1X/ZdAj2KWFTL011jOI6PMQ2CDrLiKApMQzeGZ1F6orDlruN7sB8HsVbAlpmlprJEO4SHQK/vqnAvbNwZW7/RvgcADjJyDlpizr4+8BAqLEiJM/s4dY9n8fcW18MubeCZL1RGznf9502sclc6wurqaB4V5V24Nd60mubVB8Ws2i/8v8qLA6kwHjj4mb6UOKYultmmJjLccUoEzAriA==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3acdc0b1-913a-42ab-f5ef-08d86b75f02d
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2020 10:35:55.9983
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4iqsXCvViTmBoI13EHjNA1ll4JnCNWKhKBfwGnKjRPV25ebS0CPFwigvxA17Uo+f2s0J29jiHLaci6kKNXiNfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4892
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello Song & Guoqing,

Thank you for your review.
I will take your advises & take more attention on later.

On 10/8/20 2:56 PM, Song Liu wrote:
> On Wed, Oct 7, 2020 at 8:36 PM Guoqing Jiang
> <guoqing.jiang@cloud.ionos.com> wrote:
>>
>>
>>
>> On 9/27/20 07:40, Zhao Heming wrote:
>>> current code doesn't free temporary bitmap memory.
>>>
>>> Signed-off-by: Zhao Heming <heming.zhao@suse.com>
>>> ---
>>>    drivers/md/md-bitmap.c  | 1 +
>>>    drivers/md/md-cluster.c | 1 +
>>>    2 files changed, 2 insertions(+)
>>>
>>> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
>>> index b10c519..593fe15 100644
>>> --- a/drivers/md/md-bitmap.c
>>> +++ b/drivers/md/md-bitmap.c
>>> @@ -2012,6 +2012,7 @@ int md_bitmap_copy_from_slot(struct mddev *mddev, int slot,
>>>        md_bitmap_unplug(mddev->bitmap);
>>>        *low = lo;
>>>        *high = hi;
>>> +     md_bitmap_free(bitmap);
>>>
>>>        return rv;
>>>    }
>>> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
>>> index d50737e..afbbc55 100644
>>> --- a/drivers/md/md-cluster.c
>>> +++ b/drivers/md/md-cluster.c
>>> @@ -1166,6 +1166,7 @@ static int resize_bitmaps(struct mddev *mddev, sector_t newsize, sector_t oldsiz
>>>                         * can't resize bitmap
>>>                         */
>>>                        goto out;
>>> +             md_bitmap_free(bitmap);
>>>        }
>>>
>>>        return 0;
>>
>> I'd prefer add a comment for get_bitmap_from_slot to mention it's caller
>> need to
>> free bitmap.
> 
> I added comment to the patch with Guoqing's "Suggested-by" tag, and applied
> it to md-next. I also made some changes to the commit log of all 3 patches from
> Heming.
> 
> Herming, for future patches, please prefix the subject with "md:" or
> "md/bitmap".
> 
> Thanks,
> Song
> 

