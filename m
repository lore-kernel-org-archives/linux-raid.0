Return-Path: <SRS0=7JT0=CJ=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1972EC433E2
	for <linux-raid@archiver.kernel.org>; Mon, 31 Aug 2020 01:28:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E46192076D
	for <linux-raid@archiver.kernel.org>; Mon, 31 Aug 2020 01:28:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="EN+diPia"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726940AbgHaB2Z (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 30 Aug 2020 21:28:25 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:50828 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726692AbgHaB2W (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Sun, 30 Aug 2020 21:28:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1598837298;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=0vrpTQOrte44r4NNcrK4JC5H+f91yIdQpc4IQgb+mzs=;
        b=EN+diPiaUvqRq8cFaPlYf9NEoGUa89svjktXox8rryBstAuD0BUUqSZplRLSR2blvnSkmW
        lB8xCpobXBhT2ghUcQdQiVzt7QkZiAgFytBv3GQW1iSTndJCKLYMP2kuvslCB5y0vm7m4J
        kxEY7mEye4Pdmuc0CbcT8+5Ag8WZghw=
Received: from EUR03-AM5-obe.outbound.protection.outlook.com
 (mail-am5eur03lp2059.outbound.protection.outlook.com [104.47.8.59]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-24-ScFL973gPraZ75GFYRj4xg-1; Mon, 31 Aug 2020 03:28:16 +0200
X-MC-Unique: ScFL973gPraZ75GFYRj4xg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cSX93U9pjpeJzXS+rT6sTcqNJK7eLIaHC21ZXSk09AzTzUL6ImUruv8f1hj4FV3hUADoWXDQ1HX/zR8jkMkWOklNT4MyWvsvHXNt4xebqaobpCr4ywMYGpmpWvjZh79VmQgkWx8oTz67PdnIRGJo8wqd2w+20IcWkIWxN+t+iAq4Pz4ifd2l8aSXjgxD43vNnAM3xeCbgH9ltV5npLbNo9mXhLbmGRBcn+jAOx4gwAPUxEBehaKP6acWwWMoaNtptmuXyFOWnIAUJu2GlNsxH23MYvd6qiVLjzAfixz74xYnimQoWZV7M+u2lv5BwkTLRW28DGIOnNeL1Ma1OLKjwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VIGOoHTNzYKpldxQmWttEsurHOImyjXRXLKWqItDApE=;
 b=L8b3uWpZBu+mLvIow8cp0Puz83bFmkxq0voORPAlN3tShx5obOwi0IT7ydGQ9zEFj3Qey9aWyIe8hPKTMPf41n+kFvTirlv8dfaC+hyXe6LBYer9x4kByjlp/pUcKKd55yG7V2bsEhVWcj+QAlS5gioWx/ybgTjdZRRUa6gpjqtHwo1KhePtFgkAGnDtH76OIvc2YP3G2UVUmVxPcujeYaNvdO9fusOY4ONH5e/DCpvnXUkUfiEORjBZ5+wHs6IXX5WP9hpzcIZkf+jdAg7+KNsGuf++1PxVTV7wjUfPKwEbXSytIfBNidK3Tb3CRCfrH1MoybMYxsxNWzrTaYJJ9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from AM0PR04MB6529.eurprd04.prod.outlook.com (2603:10a6:208:16f::21)
 by AM4PR0401MB2241.eurprd04.prod.outlook.com (2603:10a6:200:4d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.25; Mon, 31 Aug
 2020 01:28:15 +0000
Received: from AM0PR04MB6529.eurprd04.prod.outlook.com
 ([fe80::c8ac:ffb6:8e0d:36e7]) by AM0PR04MB6529.eurprd04.prod.outlook.com
 ([fe80::c8ac:ffb6:8e0d:36e7%3]) with mapi id 15.20.3326.025; Mon, 31 Aug 2020
 01:28:15 +0000
To:     Ian Pilcher <arequipeno@gmail.com>, linux-raid@vger.kernel.org
References: <20200826151658.3493-1-lidong.zhong@suse.com>
 <ribbtt$t51$1@ciao.gmane.io>
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
Subject: Re: [RFC PATCH] Detail: don't display the raid level when it's
 inactive
Message-ID: <0468dc70-7309-44b1-f094-67b617bf4c98@suse.com>
Date:   Mon, 31 Aug 2020 09:28:09 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <ribbtt$t51$1@ciao.gmane.io>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: AM0PR06CA0119.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::24) To AM0PR04MB6529.eurprd04.prod.outlook.com
 (2603:10a6:208:16f::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from l3-laptop.suse (39.71.186.250) by AM0PR06CA0119.eurprd06.prod.outlook.com (2603:10a6:208:ab::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Mon, 31 Aug 2020 01:28:14 +0000
X-Originating-IP: [39.71.186.250]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: adbada56-61e6-462e-298e-08d84d4d21f9
X-MS-TrafficTypeDiagnostic: AM4PR0401MB2241:
X-Microsoft-Antispam-PRVS: <AM4PR0401MB22411027EE356D5E22FE887BF8510@AM4PR0401MB2241.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: czT9EXjEnisMp0td9JMyCpPXGr9klIC7CXDPdpfaI4p9Jv422h2wsZ+8DdZ3GrZ0JCJZLz+QKtqy0TbCCO1gC4/rc1+eIuOzB1ZkyMHQ1adh/CqvwoiUREFuZ4BzFqqEE89nbaTKAAtNz6Ff8UAaqzwtwwbDebAapQt8swHjMSUsoQlP9ZDCuW/sfE3N5tt/uG4n5yNzyINjmkZTutuYAAvXML18raty4bCIQLlobY1aSqlgrSMEG16Ziq7ffPEOTZhjzKtE1ZUNunvDtqf5dy3pRFAJ4GqNWac0e+FAcMbxqQwt89kTAcCI7Nt8c0Z31szamtcDBnDkoPqowQB1V5H7cwbRdVXkEE9/yquWpZbPtqgp8bMRTnrUaseQtiZ1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6529.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39850400004)(366004)(376002)(136003)(346002)(186003)(16526019)(2906002)(26005)(5660300002)(478600001)(4744005)(31686004)(316002)(6486002)(31696002)(6666004)(83380400001)(66476007)(66556008)(86362001)(8886007)(53546011)(66946007)(52116002)(6506007)(36756003)(8676002)(2616005)(956004)(6512007)(8936002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: +v4Y0q7EqtgvnybjRoPEFuYX7DGa9LiVQ4ThSGM1vqwQDkgr9Tg4Fb9qwzatE9uD7loz61eeJ/Vf9QZjxZAe1memDEl5fyd5ZWGmbypk9NryqYtwbJK8sNPywMS2QLLYhRf6kxufq1Qj6BqSblV7BV3aSshcG25YJiaBaJtFwuTzx7a8lYDt6TcH1aG2u+77sUmB2Im+Ftbz7KkN/ni7oo8ZHCsZQG+ij8hUshyBuwUVk5AunEDWQWb9NYdwSqU89RQfZSj8a/OaU+VxRL+tvB0VramciqD2HBLSd+h2gL/fxbqhDXofwLF7mbumUIv/I3dkTP6KpEsHmE+Qvmf9UlAsinesG8X7g4jrEeJeZqcwps0rzZWnZ4Nnn1ipnzj64ztF0mrWP7RDKH48kf+NZs2YdLaGerhRe6gPlOomrEd5lGoSUF1rIJGHcfB6Gp9dl4W7pRgnKNL9ytCAJEswK85SnLgvFYOiCkAC1E/uPh+hid0lr69FPvz8tnR+aPOZCMHiOjbHQO6irSRjviXQLO3sGlV8W/qwn49Z+5x+/GzulvzkzFY6fUxto+Bu+SD6buH6IlqHADZkJlQw0aiOo2VnM0hc9zE5CjfQOJKbM+KCTCXZTZMPKC/wJMCODHCw/eqBcWKSx0cElETcdMY84w==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adbada56-61e6-462e-298e-08d84d4d21f9
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6529.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2020 01:28:15.2921
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vcPETSZ72nLz/IiSUED1ZhEqAFgRznlfOA20+xdik6eFBmabx8SdbiqvOjQfIBRZhUDUi7PDa28ZqjQeLOwWvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0401MB2241
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


On 8/29/20 12:38 AM, Ian Pilcher wrote:
> On 8/26/20 10:16 AM, Lidong Zhong wrote:
>> ...
>> So the misleading "raid0" is shown in this testcase. I think maybe
>> the "Raid Level" item shouldn't be displayed any more for the inactive
>> array.
>=20
> As a system administrator, I'd much rather see "unknown" (or something
> similar), rather than simply omitting the information.
>=20
Thanks for the suggestion.
Yeah, just removing the Raid Level info is not the best option. I also
considered to show it as "inactive Raid1" in such case. Anyway, I need
to wait for Jes's review.

