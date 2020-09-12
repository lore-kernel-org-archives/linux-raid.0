Return-Path: <SRS0=Qcx5=CV=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22533C433E2
	for <linux-raid@archiver.kernel.org>; Sat, 12 Sep 2020 15:03:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBB8420855
	for <linux-raid@archiver.kernel.org>; Sat, 12 Sep 2020 15:03:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="n77rMRg5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725860AbgILPDz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 12 Sep 2020 11:03:55 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:58583 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725848AbgILPDl (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Sat, 12 Sep 2020 11:03:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1599923016;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=nhklhS6Gk1DYmYXuqJBAKO6oR+zdH1oPrFmdQqtYhhg=;
        b=n77rMRg5lNcZX7masdzI84TJxGYiEz2p7AkhlCytIVVUTlpk+dZD3n0SFe5EyUE9pTJb5B
        KsC79OEHyAnM2knAbYrA7FM1jon85NN6PtU3auCIfLUTLkoDO0VW21x2KyN8aB62qcggQk
        KoET0kC1qQJD3v4Qy0hlJJ4c/1gUIwA=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2051.outbound.protection.outlook.com [104.47.13.51]) (Using
 TLS) by relay.mimecast.com with ESMTP id de-mta-8-LIZUz-pzOvKWY2PPJdYk8Q-1;
 Sat, 12 Sep 2020 17:03:35 +0200
X-MC-Unique: LIZUz-pzOvKWY2PPJdYk8Q-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m09WzWqvvRRrAm1L/wawP/GLuFbmAmz7+h5QbghULrsUXzex+zo1VDMINclvlOXYWS+pB1Ax7ehKmcOPeqJPNZtssgNpIdfX0Z+2h6FWB7HhOVA9NJeGY47MykgN8bwilbXiWsxMY3ANmoZNq1Ol86T0jPJpZjviQ2g9T/wHbN2+LqZ7O01KuhNjwprp7KbFfgjSTTh19gT7csN5c6UMBlgL7+ps2U1kVXVi43iahZotT6f2GPs1Ttq0TxRFD86UzBaCbFkv4CrNvJUclHNHX3lcPV6skBRCB3ZqsOo2S8FOTc/6ErCsCNXQLDsnH2Q/jJmmS22fILElFHP/HSbAqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nhklhS6Gk1DYmYXuqJBAKO6oR+zdH1oPrFmdQqtYhhg=;
 b=fALio8nmwHmjcjpNSYHx/pNoNg7djyfPDmOw98trWQSuUASjtyl8wr8vYYOVRxMlGKWAV2/FYUK30YWOr8F0KdBlxeQ6MxRj0xJu0qdtW3m+hkxWDva9B4rHrz1M5HaSNIoNJ5awJkWiHRp0WOYnTMaYV3pRXxV7kQExI4DupKkX5Jd2yVOrEi1i4fnDxPPFPx1cZ31OCIRYnr02cXEhPzHdH2khAf3w3mpsT70JoDw+rkbtVXpoQCL71JfA7vwFgcT7Z+zNMvUsxJ2SOJxtIA7yIXAa5V6hKVMzk+Y9AlryckZKX6We+/rWFBPGodS2Y3GwdHFGDfyvxfWEFuZzZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from AM0PR04MB6529.eurprd04.prod.outlook.com (2603:10a6:208:16f::21)
 by AM0PR04MB5123.eurprd04.prod.outlook.com (2603:10a6:208:bf::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Sat, 12 Sep
 2020 15:03:32 +0000
Received: from AM0PR04MB6529.eurprd04.prod.outlook.com
 ([fe80::c8ac:ffb6:8e0d:36e7]) by AM0PR04MB6529.eurprd04.prod.outlook.com
 ([fe80::c8ac:ffb6:8e0d:36e7%3]) with mapi id 15.20.3348.015; Sat, 12 Sep 2020
 15:03:31 +0000
Subject: Re: [RFC PATCH] Detail: don't display the raid level when it's
 inactive
To:     Nix <nix@esperi.org.uk>
Cc:     linux-raid@vger.kernel.org
References: <20200826151658.3493-1-lidong.zhong@suse.com>
 <ribbtt$t51$1@ciao.gmane.io> <0468dc70-7309-44b1-f094-67b617bf4c98@suse.com>
 <87wo1emyi4.fsf@esperi.org.uk>
From:   Zhong Lidong <lidong.zhong@suse.com>
Autocrypt: addr=lidong.zhong@suse.com; keydata=
 xsBNBFne5DgBCADQj9QdXtw20bP35mDylFrd0LWj4cjpQ9kHD693GVpwNqTmwJcxGJutRvhe
 8HJjiJhstnP60v6+Q+qoP7cNY4KS35LDZJHgXbdRcPYBSzabEdWfge6UH86HxK8MHY0w+GDu
 TseKNwt6fr6NH2FVQSTTQhpVv+fYGPTgAqaKD5J8JhTHS9c/sBsV1zNSQmTULpykXXcO/COL
 +Yw2A7P4+KR12wNAIhpITRykUtfKiHjdAFBLmQs0ES/c/MwQ2gOwEt7RAjJB9il71oR+9Kyr
 CDkHaBoNK/mkdDyXDL/FBCqEExeiYL3XnBWckoyPZT8ivA5DQuOuiG8Yv2TyTMSaSMQFABEB
 AAHNU0xpZG9uZyBaaG9uZyAoU1VTRSBMMyB0ZWFtLiBCZWlqaW5nIE9mZmljZS4gbGlkb25n
 L2x6aG9uZyBvbiBJUkMpIDxsemhvbmdAc3VzZS5jb20+wsB/BBMBAgApBQJZ3uQ4AhsDBQkJ
 ZgGABwsJCAcDAgEGFQgCCQoLBBYCAwECHgECF4AACgkQsnlJphZSmJJZWgf/VSvl+O1sRDI6
 VIAXiGzFCqVnPBARZFXMahzYrTbfb/LdxTCE9R5g2ex5jM7ME8Y+j/PtCS7z0TW5jF0R9LFP
 gjTHfaUqDq7sqzrONB85NMud+qtkn07HlgTCwhIZe972LHuv96iWv7n1nRyMHe8eAMK2xVL9
 sPS3L4LW5b2AN1BEwk3x/BVoXKNMzlKP8CyoDG03UaptcBRgbm+Ds9Sgx9ZuxkAL/nUdDqvB
 6Of+FleCNRmTm5c9gawOS3w24KzVCbhOKSp+y8FSt0gS05mL1P1wVos2sErKgOk6uSNo5oa2
 TIk6T5BpWytWKRcdn2NSmM68MqezUXMpD/eCjkohF87ATQRZ3uQ4AQgAvvWi8gOGzVm4uiUj
 pxeteRthpsdvm3YU7rAWwxPPSXjZDDoSL8ogSoj5/mV7wKxJemv/UHnxWO66KNkP5YlwBVpf
 yhLWvFuas8vKgrL6xwstjIoqQkAHwzFeMGKYdXZKZbJgxl56MeE6cpGoKpMHNkRVDhbmhfOt
 yrISWhBccrOsgeYjaPos8B53sAQry5PoVA3hNhpSZ23N37VZcs4KJOtNpxbsXC3KcbrisXUr
 MqkyYnccSNVGT1Bfr4nItAp3bdgyoMPh2kWkNtX7xms5fQs3kIZoCevbjQcJeerBG/E4rNtq
 wBYtagTg9m0/bn/w+iA6RfcLZWC7Z31ggkSZ0wARAQABwsBlBBgBAgAPBQJZ3uQ4AhsMBQkJ
 ZgGAAAoJELJ5SaYWUpiScgEIAMcAuAxnvRg5L9aB1/Xrmm+ILf7qB7FYxmavGMkZ+sHrLhw1
 Ycb5jYMhQQcTGCefKpsxx44PAw5DhJe7xnbHjRAWl8ScCGXmJUof3eaQ+7p3pWtl7R/J5W4j
 C5undogrFFcRimd5ah1tWc0t4BejelxpV+OiG4u/ghuCMrEQn6DgGL++gDs3vAspW/43RNZe
 BaxvvUMbNU0B3iKlwzXUxCDlBu8EcXEltM9MF02yoG5FxLaRXa/8kqeYAgH2vQjJqfMBMBLS
 tYfhW3GUnwUCN1GlKsguZWKprwgDzAp0JIeAatemSNtCzcTpgT0gTB+iTWYac12EQTu3Ckdx
 Rdu9+hQ=
Message-ID: <0fb181ac-e6c4-45e4-d29d-19a98343fb82@suse.com>
Date:   Sat, 12 Sep 2020 23:03:25 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <87wo1emyi4.fsf@esperi.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM3PR07CA0099.eurprd07.prod.outlook.com
 (2603:10a6:207:6::33) To AM0PR04MB6529.eurprd04.prod.outlook.com
 (2603:10a6:208:16f::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from l3-laptop.suse (39.71.186.250) by AM3PR07CA0099.eurprd07.prod.outlook.com (2603:10a6:207:6::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.5 via Frontend Transport; Sat, 12 Sep 2020 15:03:30 +0000
X-Originating-IP: [39.71.186.250]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f9177bec-83ba-4bf4-e4d0-08d8572d0366
X-MS-TrafficTypeDiagnostic: AM0PR04MB5123:
X-Microsoft-Antispam-PRVS: <AM0PR04MB51237E789A1B17E3B7303138F8250@AM0PR04MB5123.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3qA3ZLbvhdoG5XUrSbqDFRok4hKc0Qzy4llcS36Kp840+5zZifUT6LwhQJ/Q7vij9678TIwNyLc0amQco3etiCm7EuxfD6tJQgTslkJZS3CR/EAT+ueNnAfUcqJLaBL0pkf0skRNltVgkv6o7AipPdR4JlRtScf6VaX8SVmjSd0HBOf1WlY5VijZX85fvku46IvYgdRb0ORdechfB31hWHRD9Flh87RnNJZ9uxMajzqbFLx9K/2EdyvHaYFDL3H1ZK+mdX5y9CrX2MPmZpn1AeKzBd3xL0w+mlhPzoULmXD7cyglyEP6KZeJd1vajCdc+Cy7tf7OzESy7RnvKZ/WJGP5s9gUaJsuUuPENuI0wEj5tLXL0O2hOKBcXDZPzfvQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6529.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(376002)(39860400002)(396003)(366004)(66556008)(26005)(66476007)(6512007)(6486002)(8936002)(2616005)(52116002)(86362001)(31686004)(4326008)(316002)(956004)(2906002)(5660300002)(6916009)(8886007)(186003)(16526019)(36756003)(66946007)(8676002)(31696002)(6506007)(53546011)(478600001)(83380400001)(6666004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: rE+b5SLRpe4DU013E6csF3AVEuzAm/SgfZHWonT+Z+p15lTew41U+lUBevFn01cmlFOStDZ/4TtMF4BQJ7jaXGF1MZG1TNnHYrue+7Xg3uEksI0zpv8VZt8FYRyjy0G2KuIEyXT4YEuNVZ3t3p6kbnYwz7SBtmkOviGf+ra0MA2N8am9avXfjblLZjrZ4uveFJON+IuwT9dGhowQRmxTc1uE0v1Y3WsLlyXk8ERnP9x1p6luxzjfGGWvBYDzCCIOmMQs4iUy2iPz4M0/oANbONeytFeli7A9/nec7S8wVWoVluzW9lP2Ihz4SHtKOb4XYcA6eJ13v2Gus0RVGTnayIHZ7BDLK8roL4WWZI7k2dfxUdON92tqLZFXpU76nd+y5+lgcItV64lILHWU7unCxIDW5dAF6SnzPhTpLT8uQ85M+EwBRlf7R875GZZvmEb95OMpKm+9DseHM+djglN667Ug13oYAIDNgli1An+PbEFHs69v93FajnlOBzyelUbw7RwQIGPbalEYoy8QMaitJ2VfTxp68nBCDNcaoKE/REa5ULW2Nl/jyna21MCF/mABXuA7PXEBzkDpCt70iW9T9++pSjJV/Jzmh+6HSgg27SmAwI8ZKjyqWfRFlFIeFSICMLkO+r7g27l0/oii91wGng==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9177bec-83ba-4bf4-e4d0-08d8572d0366
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6529.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2020 15:03:31.7563
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gn8B+t18rdsyfRgW9kkO+I4KXmrp+2sxVyyO4GTN6YX2dNf6LjWrOVwFiruaramZwhazQvtsbasf5CjkjlDrLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5123
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 9/1/20 3:00 AM, Nix wrote:
> On 31 Aug 2020, Zhong Lidong told this:
> 
>> On 8/29/20 12:38 AM, Ian Pilcher wrote:
>>> On 8/26/20 10:16 AM, Lidong Zhong wrote:
>>>> ...
>>>> So the misleading "raid0" is shown in this testcase. I think maybe
>>>> the "Raid Level" item shouldn't be displayed any more for the inactive
>>>> array.
>>>
>>> As a system administrator, I'd much rather see "unknown" (or something
>>> similar), rather than simply omitting the information.
>>>
>> Thanks for the suggestion.
>> Yeah, just removing the Raid Level info is not the best option. I also
>> considered to show it as "inactive Raid1" in such case.
> 
> If it would be a raid1 when activated, it is still a raid1 when
> inactive: the data on disk doesn't suddenly become not a raid array
> simply because the kernel isn't able to access it right now. This is
> valuable information to expose to the sysadmin and should not be
> concealed (and *certainly* not described as a raid level it actually
> isn't).
> 
> I think it should say as much (if the system knows at this stage, which
> if there is a device node, it presumably does).
> 

Makes sense to me. I'll try to rewrite the patch.
Thanks for your share.

Regards,
Lidong

