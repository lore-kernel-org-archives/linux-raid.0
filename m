Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50A2CC388F9
	for <linux-raid@archiver.kernel.org>; Wed, 11 Nov 2020 12:15:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFC22206C0
	for <linux-raid@archiver.kernel.org>; Wed, 11 Nov 2020 12:15:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="D+MjvL+8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726516AbgKKMPN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 11 Nov 2020 07:15:13 -0500
Received: from de-smtp-delivery-52.mimecast.com ([51.163.158.52]:42898 "EHLO
        de-smtp-delivery-52.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726522AbgKKMNq (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Wed, 11 Nov 2020 07:13:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1605096807;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k5MyFZjoyShrWMABf7G9UaCQRf/jWVtI7HMwFQGxKYY=;
        b=D+MjvL+8+BRSK5SfG1tquayPaMLznsf+Gw6oAqk+KjUFr94iGX70CHgJNuMvLm1GulUFUf
        laFmU5ZkcljjLmsfeuGuwlqB82/Th9Uzx/1prd8mssuS7LWT9RXNo0pSK+xiW2FeJM7yZ6
        eKpU7TKBZD63lZXPP+G2zJ4unXM9QhQ=
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05lp2107.outbound.protection.outlook.com [104.47.18.107])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-19-iutz_yqTOQGR52o6NmBpzQ-1; Wed, 11 Nov 2020 13:13:26 +0100
X-MC-Unique: iutz_yqTOQGR52o6NmBpzQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=assjgg76GRQi5fhTLa4/GsDbkG7rOrr7Y84lpIumhc+zOK0J3YTk5v2pfhunHQ8YhVg5R16Jwd72FicM/7a5WqbWHnSGXVkEoj8GdseD1qOUWWMynOixNZ4kqJdgJKPQ15PC960KZKKFqo1xICyJixls2VdCMkZ2cUHv6NGpHOvJSvckE0yigdViRQ1UMgd/h9GIQGoI3XCa3oXA6VfpWURraCycTRrRiiVDTQ1NHiNc/qeXUVT3IfuQP2rfHSJZS7Qd43tDHR6zymEzLQVf/pGw+TOWfPhx/HAu7QDflF7ud3LheiY0widnZkDuNzkFz1bw6HRlvU0zo8fyMYeV7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DDp2bhEdy74eXjbmwdtDCtkbBjotV7i8d7oBTJKi6ZM=;
 b=h+ME2P7TA1jHMzwgo4lA7+JMBXJAX8pUIJNrbub+g/Hyohv470AFXyt+pTTXcPOxRX0aESBHPfxyvMzGBniYwNeHzIwjQh4YXmAoLxvbY7wGcPZYCdW9JwSOnOpLfYHzugb3DFDhDqcOFMN821B3lx1fdRWrIbe2UmNK2iRWF0fR9omljgDsYkRJKdL6WKmRymFEEILmvj0sfeSH0ABOchaJolFiGdwBBLiTx/GaZMgOwKu9fJk5Odx3NIsvCHvx5jzKnAEI4jNeTQcWPY2Ch04zqFPpk7P0Cb7x0iYcSTHhwNJX5Nr08RNh6244Vtc3dLjAvkbGX2p1DMDeTczFHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB8PR04MB6650.eurprd04.prod.outlook.com (2603:10a6:10:10d::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.25; Wed, 11 Nov 2020 12:13:25 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::197:4f2c:bd9d:ff7a]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::197:4f2c:bd9d:ff7a%7]) with mapi id 15.20.3541.025; Wed, 11 Nov 2020
 12:13:24 +0000
Subject: Re: [PATCH 2/2] md/cluster: fix deadlock when doing reshape job
To:     Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        linux-raid@vger.kernel.org, song@kernel.org
CC:     lidong.zhong@suse.com, xni@redhat.com, neilb@suse.de,
        colyli@suse.de
References: <1604847181-22086-1-git-send-email-heming.zhao@suse.com>
 <1604847181-22086-3-git-send-email-heming.zhao@suse.com>
 <b6ef581d-2eaf-37d3-7a21-a91630b0836c@cloud.ionos.com>
From:   "heming.zhao@suse.com" <heming.zhao@suse.com>
Message-ID: <e5ab9dfc-46bd-ac84-e79f-468f4ed0512f@suse.com>
Date:   Wed, 11 Nov 2020 20:13:12 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <b6ef581d-2eaf-37d3-7a21-a91630b0836c@cloud.ionos.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [123.123.132.155]
X-ClientProxiedBy: HK2PR02CA0168.apcprd02.prod.outlook.com
 (2603:1096:201:1f::28) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.132.155) by HK2PR02CA0168.apcprd02.prod.outlook.com (2603:1096:201:1f::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Wed, 11 Nov 2020 12:13:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b4275068-8a46-457f-2ca5-08d8863b3053
X-MS-TrafficTypeDiagnostic: DB8PR04MB6650:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB66500AC8695AF1C3011A2A0D97E80@DB8PR04MB6650.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:626;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WiKAX6MNoFbMVSMbH/xYiTrt2UEr4Qq2Yi9khUZOO6feURUzwyWxFA0Ijs/kxwoQVwOyG1qfpMdR40x1uBHUNnJYIzhtm6ZHEL2XQIiumoZ6GqUCZOnoZ2Zr6QRMgOV7mc1TniOdvWqqIUpDE07sahEE62rqRJxlayxGJkxJDFY9nKlIN0+HDO03zje+lE98CJ0cdhvdinYJDDvv0c7VkW4RCHFeZVosGqSa+JFnFnt50HKmyeqHsZAftt8wrTyeJgL5dhjqab35NtfDbHSTg56Ta9G6x53JnVMFvajwzEfKue7+eYWISClxFoWlV1H8i/+l3fIvUT1RT1kIYZDhYfomN8PnRlEUoYnnlDa6xNMDW+4OKmRuBIA9Rr9KsHp+V0vpOYzDBW7ZwSAddK9ozQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(39860400002)(346002)(366004)(396003)(6506007)(478600001)(316002)(2906002)(52116002)(66946007)(8936002)(53546011)(6512007)(8676002)(86362001)(36756003)(31686004)(2616005)(4326008)(956004)(6486002)(5660300002)(6666004)(31696002)(8886007)(83380400001)(16526019)(186003)(66476007)(26005)(66556008)(9126006)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: jEmedPvVb+EsoTSeISrYnMyrs1SLmXQJ5ggzJWehaYcmCf5eQIvycY2rr96KvnrNdXD4i4+pyYR8VZlhzwmI2GEmGYQE+tG5XTo+iXzT/oU2NsoIxqmu5GnODLIO0mAB4BFn/TtRpNDYs9uXCrhRC9kNzm94RB3QctGF4tu4FZSQgf8TSkN4VhDsKsdCCXdoDxFulXuBuLq9j9MoC2tEMbpevrDf0R7CrUkGyUdZTUhpdASLMd0K5gk4jrUicK4+5Vbbk2OxC8UEXi4oO05wsDn+F80cfi2VXN4qU1YxoOZAjfSegzB3i5m61I2qryJRt2n+t8oMuhCGeU8R2n1xIfqV9ICCCA3bYrPMO8GUfKRSU00OShHvqt5hs+TFH1b3SDrleIxGt/Ki5k4gp15Srztoz9vHLtV/gBXBr2Azkxv6SlYbh6b5VLMB8djv1Efe5+s3ApA5eXYuNMB0xpA1lP78zV7ZMqCLolMOyTpLtuKmAf7paUlAW0i7NSXPYaEwOet4+RT5FyBEzMm+fh0OV4HcLGUhrROvCVSI0P1LGFgrbnko+WTF9KTkzcIU/gpfXYYZG7uPWMdyUUTspdhHY3rMN2VbPxDVy9xwbPoDLHYJZNDQX0KpqxyBe7xZbtzylmNs+Ksfva13ctjBMstnCA==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4275068-8a46-457f-2ca5-08d8863b3053
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2020 12:13:24.7863
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HzGTbWDqPQy11tgHCKf8LPd2DAZvRPrDcQHK+jeCFSm4TwE5PmymtZTGGsJLlVkrlESBLm9QWMnZNuoy5jocNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6650
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 11/10/20 2:36 PM, Guoqing Jiang wrote:
>=20
>=20
> On 11/8/20 15:53, Zhao Heming wrote:
>> There is a similar deadlock in commit 0ba959774e93
>> ("md-cluster: use sync way to handle METADATA_UPDATED msg")
>> ... ...
>> =C2=A0 static void unlock_comm(struct md_cluster_info *cinfo)
>> @@ -784,9 +794,11 @@ static int sendmsg(struct md_cluster_info *cinfo, s=
truct cluster_msg *cmsg,
>> =C2=A0 {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int ret;
>> -=C2=A0=C2=A0=C2=A0 lock_comm(cinfo, mddev_locked);
>> -=C2=A0=C2=A0=C2=A0 ret =3D __sendmsg(cinfo, cmsg);
>> -=C2=A0=C2=A0=C2=A0 unlock_comm(cinfo);
>> +=C2=A0=C2=A0=C2=A0 ret =3D lock_comm(cinfo, mddev_locked);
>> +=C2=A0=C2=A0=C2=A0 if (!ret) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D __sendmsg(cinfo, cms=
g);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unlock_comm(cinfo);
>> +=C2=A0=C2=A0=C2=A0 }
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ret;
>> =C2=A0 }
>=20
> What happens if the cluster has latency issue? Let's say, node normally c=
an't get lock during the 5s window. IOW, is the timeout value justified wel=
l?

5 seconds is a random number first from my brain when I was coding.=20

below I gave more info for my patch.

The key of patch 2 is to change from wait_event to wait_event_timeout.
After applying patch, code logic of some functions are also changed.
I will analyze the two sides: send & receive

*** send side***

Before applying patch, sendmsg only fail when __sendmsg return error. it me=
ans dlm layer fails to convert lock. But currently code should do access th=
e return value of lock_comm.

After applying patch, there will have new fail cases: 5s timeout.

all related functions:
resync_bitmap
- void, only print error info when error.=20

update_bitmap_size
- return err. caller already handles error case.

resync_info_update
- return err. caller ignore. because this is info msg, it can safely ignore=
.

remove_disk
- return err. part of caller handle error case.=20
  I forgot to modify hot_remove_disk(), will add it in v2 patch.
  So in future v2 patch, all callers will handle error case.

gather_bitmaps - return err, caller already handles error case

We can see there is only one function which doesn't care return value: resy=
nc_bitmap
this function is used in leave path. if the msg doesn't send out (5s timeou=
t), the result is other nodes won't know the failure event by BITMAP_NEEDS_=
SYNC. But if my understand is correct, even if missing BITMAP_NEEDS_SYNC, t=
here is another api recover_slot(), which is triggered by dlm and do the sa=
me job.

So all the sending side related functions are safe.

*** receive side ***

process_metadata_update
the patch means it won't do metadata update job when 5s timeout.=20
and I change my mind, 5s timeout is wrong. Receive side should do as more a=
s possible to handle incomming msg. if there is a 5s timeout code branch, t=
here will tigger inconsistent issue.
e.g.=20
A does --faulty, send METADATA_UPDATE to B,=20
B receives the msg, but meets 5s timeout. it won't to update kernel md info=
. and it will have a gap between kernel md info and disk metadata.

