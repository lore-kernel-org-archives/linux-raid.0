Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17E4AC48BCF
	for <linux-raid@archiver.kernel.org>; Thu, 10 Jun 2021 00:54:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3307613F5
	for <linux-raid@archiver.kernel.org>; Thu, 10 Jun 2021 00:54:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbhFJAz5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 9 Jun 2021 20:55:57 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:25355 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229507AbhFJAz5 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 9 Jun 2021 20:55:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1623286441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L70FvUW9WQa8lvKGWLh1bwxNZPuJRy/641BI1YpPUQI=;
        b=LZy6ANRa+DYn/fj+eFApKliLwq9hIjlBFKn7Kh5Aiuiq2oYkRszI8gsEBIA+QojtutH0cy
        ycNrZ838NOHsxNqrzlJZ4cRJayNBiMLWquz6SCMRDeZnQRzZ5CkEzsb05VbCyqM7wfDYB5
        LvEW0eCeJYUeWE12eskJWY7y8J8FTzo=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2053.outbound.protection.outlook.com [104.47.13.53]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-32-Hsop1es0NTW5wbBYkpLxrQ-2; Thu, 10 Jun 2021 02:53:59 +0200
X-MC-Unique: Hsop1es0NTW5wbBYkpLxrQ-2
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XxetfBLh5usRyvSz6tBuVPnmqeSqNzgu52+egAFjVJYXCuoUBHatX7ANS5Vloh04N/ST7WbloPkzFA38/AB1ABJU/pafRhKwSxuy2z23GizzNXw1Bm5IrMFnZCGI4LoODhU6ZD5EtFOnQmv93+eGL44OAAPIOcJ9zKPQaR/Yk0C1U2MAeyMiuIL04O2AQ2KE06maa20y6KLlL60L7H+rNEoUckcct/F/Ma4syuYw0iSvVVehm2uaN2uOZJffeE6oGmmenJFi+iL1GnlR4cO4HP/bbTbj409TYDKzR9n90zsjNR2VaQAYmZlaypg9GM+obQjvTDEKYN8HrDe4l9Wziw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L70FvUW9WQa8lvKGWLh1bwxNZPuJRy/641BI1YpPUQI=;
 b=fLO39FhHpm22JiR7Fo8OTz5trBw6HEYdu1rz9Tg4p+uztudEb2YdWvZ0wDbeztGbp8vtwEdU0IODJlltrZHEXcX5+55jOOM2uuhk9hneNNxFc9OQ1MEJH+pl5ioOulpEy1Qxi/+IqkJaTyyMI+wtboiLdaNmUBrHum1h74HpavGPvV9fonw/OHymG9VPJtAxejdfrA2oFNnfxU0y60qHD7I2wa0UhcCr9sVUQyDOzvyOD3blI49c9SQsMncyhfz/WZf2k7zzNhFcDdWK79BQlEd4pH92KVclbd7CCJTV8uEmZIdmHph2tryPyxNa04jRajE8eZCFMhbDJp+XqQXG4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from AM0PR04MB6529.eurprd04.prod.outlook.com (2603:10a6:208:16f::21)
 by AM0PR04MB4564.eurprd04.prod.outlook.com (2603:10a6:208:74::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.27; Thu, 10 Jun
 2021 00:53:57 +0000
Received: from AM0PR04MB6529.eurprd04.prod.outlook.com
 ([fe80::99c0:486c:b9d7:5740]) by AM0PR04MB6529.eurprd04.prod.outlook.com
 ([fe80::99c0:486c:b9d7:5740%5]) with mapi id 15.20.4195.030; Thu, 10 Jun 2021
 00:53:57 +0000
Subject: Re: [RESEND] md: adding a new flag MD_DELETING
To:     Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>
References: <20210605152917.21806-1-lidong.zhong@suse.com>
 <CAPhsuW7jGANVSYEWQVUkYu2W7ctKiUKJ3KxNEpjMz+P1bePZXw@mail.gmail.com>
From:   Zhong Lidong <lidong.zhong@suse.com>
Message-ID: <ffcd8729-46cf-49f3-05cf-49cabb998e4c@suse.com>
Date:   Thu, 10 Jun 2021 08:53:52 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <CAPhsuW7jGANVSYEWQVUkYu2W7ctKiUKJ3KxNEpjMz+P1bePZXw@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [112.232.225.71]
X-ClientProxiedBy: FR3P281CA0028.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::19) To AM0PR04MB6529.eurprd04.prod.outlook.com
 (2603:10a6:208:16f::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from l3-laptop.suse (112.232.225.71) by FR3P281CA0028.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:1c::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.9 via Frontend Transport; Thu, 10 Jun 2021 00:53:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 673eaef3-ea1d-4d41-0f2c-08d92baa3a89
X-MS-TrafficTypeDiagnostic: AM0PR04MB4564:
X-Microsoft-Antispam-PRVS: <AM0PR04MB4564C70088C7AFD91849A7C2F8359@AM0PR04MB4564.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R8wbm9D1Z6YiGKSizYmGXqX7B/kaDYXEo/dvmjKF0JuJWYvpirUrjixY2zW7IE3tCnzbw+8q97fw9lYlwCj/PSeqN7wFEqgn9hyBiMYuNAOOxWPu4/mjzAIHC2lGKxHtZ+ucuOm/Cp6D/GkDO9FrCESxq07zlz/P8K8GkGN0gCH6OB9s3/rvfyks4/rjOwb/OmIoClvER3HqGP3dZNsTNbUjLqr+NQbR1nx9jYL5RNZMAl0J40DMkDy3NjKKAVUQxr+KIqK+a328EVntA+5nLP5UEdDSP+woAnx+IfP2Qk7bDaXVFUf2FxAfsbfuaTe38HaXOntFU3ZUoSmrIwmYefbl0pFLr/3I4UmyqMqrjHlJoSuzwtJpUkS2sJ+x+qfq/1TFqONdawwo8DkSuztt/tmZabeW+9AgXORYKYcbcJbroug6D+kI45P1yx1bCs+LQZKEwmx6QlVNzP1Z698EA3tA5q6VGKMFAuuyCza4+wFu3OVCFsj5i57ubK3xQzYk0ZtuoVIq2I7eyJasyIpyEAvX2fFZxDU3LAW+fQ8txfVVWctmMTDf34PMS/l2Atoh4rhz+Z8zV3u4yRGAJvPanJbsWazDc7p46fWS9Gf21ZG3ZqqtVBQIQIYfiXHTbWLOiU5ymzp+EFCT4rI/GWjlqz3rRDcS3l48t4tOieyXzmG3YKZHp0VsfNqYoJhlHWMr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6529.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(136003)(376002)(396003)(39850400004)(186003)(316002)(6666004)(53546011)(66556008)(6916009)(8676002)(83380400001)(31696002)(2906002)(36756003)(5660300002)(8886007)(478600001)(16526019)(26005)(86362001)(956004)(4744005)(66476007)(6506007)(6512007)(6486002)(38100700002)(4326008)(8936002)(66946007)(31686004)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?VQ6V7+mSDF/dwsJubu6ln/j4qpuNhHjEAGjhMnK+w+rt4FXMnuR6Qjsy?=
 =?Windows-1252?Q?fzpx0WkVhnrfbeHiKYdS+uToHQaGBjJwLcjQUh3HL2OUD5ZqEC5Jgn2u?=
 =?Windows-1252?Q?1drwYe2DKCH4/lR8jvILnPLnD8L5dPRhmshnBXuTsAZF8ttR+QVqh1P4?=
 =?Windows-1252?Q?0NP0OVQ+O4AZSxp+244DcZN9UDP/z7v0UoicuF0IqKD0oFr17gPDbJ37?=
 =?Windows-1252?Q?z51xAHfgeVFj3gtJgjl2hoDG8Gw3UF+/TgU2OEUDpZ9pNS7uGqKnURvW?=
 =?Windows-1252?Q?zZc/grlNyYVs/V6fUhVIZS/IjwdUbx+hHQ04J+RHuvWiaUZIM3tPtCst?=
 =?Windows-1252?Q?4RvfmcBYkk/c9Yz6bc0LCeOTum+SrHkOhwL5kDM+DuYXA4/6xEo4qZUj?=
 =?Windows-1252?Q?uR+/XLag/uLxyth5UeeAQwMVWMqZXCu/mbDoPneLH67gW4i7fzUUjI7u?=
 =?Windows-1252?Q?p22mR3iw9TuQHO9DJRIgCVRZ32ffl/jbWe0Kxbp2dTK/Ireb7pfc1IWL?=
 =?Windows-1252?Q?fxCriatam3m7xbWvQExwLqPN6Ne5P0iDeLCRL/PEPbI20mAuHcYcBqQH?=
 =?Windows-1252?Q?wlQWOllgyCIW4JsdOlxydwiIqx5CDX//lL0/JYObVIKbxteRUj+vc/g7?=
 =?Windows-1252?Q?iAeStK1g47fBgISyg3pbdHYuWoXHTJouyomI7pncwtAA5i87ck2DjqNY?=
 =?Windows-1252?Q?89TDwrjw6NlBGQ8scbSbdGWBju5kRsxfVpLbtgXQtFs+gbe6Ge0Yaz+L?=
 =?Windows-1252?Q?q6Ypbi2i+io65t9HC10gllzY4vqQl5JD5eXqMK8gBzReEBpTuMTLlkGO?=
 =?Windows-1252?Q?Dgw+i2huqLJf2Dw9cUom/oOJ3QJLPvP6cV/00v8okNgdj/UDCf69/Seg?=
 =?Windows-1252?Q?MH1pZ6Pw0L7fhJsoyFwFq3xnEoOw1sC/LUrAWgRG2gJx6jlhyvMX8L0I?=
 =?Windows-1252?Q?t/aI3An+RX7IEtiUHyeFSVmhpTg+d8/AITwBPihcKugViXyQ1TROt854?=
 =?Windows-1252?Q?n9DWWyM/JNcp3GUN3ufRxnYQrNkFJJByz559FvJulJUfF1MpchEcaV5g?=
 =?Windows-1252?Q?1Ywt5pVgG4TRxX6JYxf2n3Y0nI4rIXRLHmiKvfcVBBRu5Ch+qKrKhPaw?=
 =?Windows-1252?Q?uGAzbAuO3WPJGeT6KLU5g1xBWYGP2HkkGF0p0sb0jM50kP6PBTdkw1jd?=
 =?Windows-1252?Q?0zeusPaD8RiDrljmH8zbq5r0wf8vxXHBcwOTTEWligfx41B3ajFnhwCI?=
 =?Windows-1252?Q?b0LEO8vjtiUBT9OU22fQXRS1ptO4pmrHzHIA0R8PCW6yyAOHLGSkZSm5?=
 =?Windows-1252?Q?rKlUNMtTlCGL2nOoPZfuoVqdjOZpXD/1zeUIik/fElBEuL7I2tpfNjwy?=
 =?Windows-1252?Q?ktZu8pA+xbAkZQtijot/xam0Zxr8sakJds85mUBsEVtqbL7SEpfxN6k7?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 673eaef3-ea1d-4d41-0f2c-08d92baa3a89
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6529.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2021 00:53:57.7560
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aDdBXoQ/enAWoTFV5OxKk40iXaMaYv7aya6UzqguER1VNxiUfapHtXAowvq3U/G6m8B128Vf6PHBJTvlYqBGEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4564
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 6/9/21 1:29 PM, Song Liu wrote:
> Hi Lidong,
> 
> On Sat, Jun 5, 2021 at 8:29 AM Lidong Zhong <lidong.zhong@suse.com> wrote:
>>
>> The mddev data structure is freed in mddev_delayed_delete(), which is
>> schedualed after the array is deconfigured completely when stopping. So
>> there is a race window between md_open() and do_md_stop(), which leads
>> to /dev/mdX can still be opened by userspace even it's not accessible
>> any more. As a result, a DeviceDisappeared event will not be able to be
>> monitored by mdadm in monitor mode. This patch tries to fix it by adding
>> this new flag MD_DELETING.
>>
>> Signed-off-by: Lidong Zhong <lidong.zhong@suse.com>
> 
> The patch still contains a lot of bad format strings. How did you send
> it? I guess
> it is not from git-send-email?
> 

Hi Song,

Sorry it still doesn't work, but I did send it from git-send-email. I'll
send the patch after I figure out the reason.

Regards,
Lidong



