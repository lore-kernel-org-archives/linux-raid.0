Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F2B4C56201
	for <linux-raid@archiver.kernel.org>; Thu, 26 Nov 2020 01:44:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2B4E20B1F
	for <linux-raid@archiver.kernel.org>; Thu, 26 Nov 2020 01:44:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ZFx1+kqY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730231AbgKZBoB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 25 Nov 2020 20:44:01 -0500
Received: from de-smtp-delivery-102.mimecast.com ([51.163.158.102]:40603 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728631AbgKZBoB (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Wed, 25 Nov 2020 20:44:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1606355037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O2gMYrb0n1Yo42tHmE6/4Qs3qHHUshUPD73ko0pcJkE=;
        b=ZFx1+kqYFDcXmLOa3TQa0DjmCo1k2MYLGtZl/BU2nYgxvegrw4NtHkY/j2bI4MGbfVM0Mf
        BmwsSVyKGD8xFZT7QW67pRQawXz9k4GgsVekiWEdihEYz6tcbk0cZTypcBgYMHGUAQKWXz
        eo7rUnhZU+oHrk7Fv/j/QFHR00Os1tM=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2051.outbound.protection.outlook.com [104.47.14.51]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-11-Q5tzQoAsN4asn3I_4YcrJw-1; Thu, 26 Nov 2020 02:43:55 +0100
X-MC-Unique: Q5tzQoAsN4asn3I_4YcrJw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oPya2h0BRmPvkKUEs9/VRHZ16NCeby4B1AgVNixsl+Q3q49gQMH1DYRgf2rU2g59lABiF94haRBbGKmDdzMmPyO3b7L54D5EAB0uzPXyiytsjA3rz6rifS2VJb+J7Dx/vjd/6e2LrYuwYFn0eeho2ub6o05fGscZiyjjfxppTZ9Wq4w6pZM1hpzvVExC6tpxAALS4RbcNBq7XEs64C1RxCY1vH1PCLN0DoG9+66s4HJGWHQ+EiTGdJtE2W7XvDz9qjfmF2Jla7I/3lyWlfZliqoabDPNwiAZ7iPQSGRSl8sfyy8JqyAAdmFEyZsHHFk++PFXm82IOtTl8Wy7nVzHvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H9Mp65fRsJJJ8Ssg6wXS1Rp6oADBW0zdLjpuzAPDPxk=;
 b=SJU16SkQLW+Y8fHeQGC26bf6erqX0e4PGqQNOVe5oSITM7gBebUV4MR1aISKBzxKCADvScoR0eWL/oajyPDWsDdq8aEFzQkep6apXqyICQiXUuz4YVjKFw5jLogpRrciSLecbfe38MmZPyqNaom8GkeuRMnHIB4KbVu38+axLuZbzkA8f13xL5wXonmlx7HzcePLSmOJLGeu7Ilq8FDmOMcShjAQxzSJcrikBZitNw3ZUI82O0aP5UpX7gbY/2z0+CpAcW/gZhbWAb8s/L8UlQ/9gjQcaNSVuchG71cvxa6e1HMnbKY/vc7BCKI4G2B6GeeL5juukYDpMOK/a1jf6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB7PR04MB4667.eurprd04.prod.outlook.com (2603:10a6:5:37::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3589.22; Thu, 26 Nov 2020 01:43:54 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::1c22:83d3:bc1e:6383]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::1c22:83d3:bc1e:6383%4]) with mapi id 15.20.3589.030; Thu, 26 Nov 2020
 01:43:54 +0000
Subject: Re: [PATCH 1/1] mdadm/bitmap: locate bitmap calcuate bitmap position
 wrongly
To:     Jes Sorensen <jes@trained-monkey.org>, Xiao Ni <xni@redhat.com>
CC:     ncroxon@redhat.com, heinzm@redhat.com, linux-raid@vger.kernel.org
References: <1603865064-27404-1-git-send-email-xni@redhat.com>
 <95046dfe-c770-8950-c720-6b1d30bb1789@suse.com>
 <f0616f2c-7156-8717-349d-7dcf349fd421@redhat.com>
 <779a49d4-43d8-2f8b-59ec-6d45d61cc3f9@suse.com>
 <73df4806-177a-9aca-4968-61c593e3333d@trained-monkey.org>
From:   "heming.zhao@suse.com" <heming.zhao@suse.com>
Message-ID: <78bd8657-b033-734a-15dc-634ba09804b4@suse.com>
Date:   Thu, 26 Nov 2020 09:43:18 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <73df4806-177a-9aca-4968-61c593e3333d@trained-monkey.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [123.123.134.103]
X-ClientProxiedBy: HK2P15301CA0024.APCP153.PROD.OUTLOOK.COM
 (2603:1096:202:1::34) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.134.103) by HK2P15301CA0024.APCP153.PROD.OUTLOOK.COM (2603:1096:202:1::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.0 via Frontend Transport; Thu, 26 Nov 2020 01:43:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2357681f-2d7a-4430-707e-08d891acbb5a
X-MS-TrafficTypeDiagnostic: DB7PR04MB4667:
X-Microsoft-Antispam-PRVS: <DB7PR04MB466726A06D8F5AB5A3F1BF4297F90@DB7PR04MB4667.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sUcAkfG9vhyqhye/kqeBG9COEbhOC6fjMFLkENfT93gf2eOfVER5dwu9yW9aAIZTsIkREaGqINnROPIyU6yxf0Zz00vVhjTdmFPZN8mmT8ShSRcs4ZCkAf/glBJZEEWARtGLalQ+/NyeJybYNix0BU+txEgTQM/El4qiy657VZXnD9ARcL/arUYa0mZgKozyX4n7PyQN767LW93IUxSwCFzXXaugpHp8grupuk2iEVVAxs95oNEP/TPWkzocYggpBpg4FY5NStGUoMxuOY2mE2zKQeklbOcKbc1UGD3NlV2P0QcLYeKGJw/mX6kEtAVlQrgn64gZBpZ8u4TTSk4eoxG2wFv6kYb84VLFH3bl75Fm4UvZw3nqHSYRGoCZbSycgKCLM+0u47FLbiiwHBFb6A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(136003)(39860400002)(366004)(6666004)(478600001)(6486002)(186003)(2906002)(16526019)(110136005)(8886007)(26005)(83380400001)(52116002)(31686004)(8936002)(53546011)(316002)(31696002)(8676002)(4326008)(66476007)(2616005)(66556008)(66946007)(36756003)(86362001)(956004)(6506007)(6512007)(5660300002)(9126006)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: k/SxRQrmIrBxwE7XJTUgEMd1wDpwwQirZ4Be2a2ImOyO/fjAEoxnY/HyjHDvRUu8Dqs/3R7/hOlAR1YjQC/u9oVh5hTgXei94PefuYmyMnX90ahXtGlBn123aFJw0Zamm8OF8tfDTATdm2rtWcEYg3E5KFxxUCxMilbOEp8HeViILXx5P91LN41pxOwo1wyj2QUk+W3YXxDwRyFRnlotc6XOMxnT4ObbPf2CDYgcsCZhTsyQ4XqEf+3o1iXMKYZBQRcwpDrK/QLi033QNaWRnWuR35aAhLh6/1a/8yspu/Oykh148GZ/m0oaM0IDVOAi3C5Bqdt5weWft+goeWialWdxogt4sqeI5xpfpEQEjtaThdBOblKn2Wo4ksK6awrdt/CeJ2GPm6Pgw7kMggbMC1DQQvM5VvyDGGG0d84c7pgWKkA95WPCg1lvudG4GR/9tRzxGUbBNSu+SMweG73q4DufScOaj7d9SK+GmFItoAJO0GygdNR/DUT+2OQYjMt47NqcLC4J1w2VaWQQdBk2lPMv4o8TH4I+GJVkc0NvSz2sx72GLVXuXiBHnHpJs7jzRoWyKtUpKXahLSGsP19sWahi0OMCzXWe8f2a9QxEiWxzJcSVI1E2zZdttUMKAtltdPhjP4NMlMG6ssE23NzUT+eGr9ZOEmcpDJtnlCtgrutnECOedocY5KTw1zPgs8E6K85yHMIx+enI2kjeLAw0lLCBK0nVff0D5Kzb913Lw/nl3ZK16G3sp8+/0emUOsjPAGzVCN5fkrPQhK8MTa/j4wIappEAuECnetts4Eqj/C+YcgpSn4I3xdc6yOspq4tBR2/2sQ3t5IpYu5DiBmTlnGTyqS/XLkMWDeJ+e/KwMSh6fK2fOkel9WXxv0rk1EnHzkr96nZ9U9XByyEUqpOgCA==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2357681f-2d7a-4430-707e-08d891acbb5a
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2020 01:43:54.1731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h2XpRh/TeClgi9KeJS8QoXlgSi3o55ijhxDLVd2Du+s9Y/IdEd6tA/rU9G+mSKnmj8DfIC4XX3RZ8ldy6Zfgyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4667
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 11/26/20 7:18 AM, Jes Sorensen wrote:
> On 10/30/20 2:44 AM, heming.zhao@suse.com wrote:
>> You are right. Only cluster case can trigger your patch code.
>> Hardcode 4096 is correct.
>=20
> Just catching up, was the conclusion the original patch was correct?
>=20
> Thanks,
> Jes
>=20
Xiao's patch (original patch) is correct.

Thanks.

>=20
>> On 10/30/20 1:53 PM, Xiao Ni wrote:
>>> Hi Heming
>>>
>>> The cluster raid is only supported by super 1.2, so we don't need to co=
nsider the old system when
>>> it's a cluster raid.
>>>
>>> Regards
>>> Xiao
>>>
>>> On 10/28/2020 08:29 PM, heming.zhao@suse.com wrote:
>>>> Hello Xiao,
>>>>
>>>> My review comment:
>>>> You code only work in modern system. the boundary is 4k not 512, becau=
se using hardcode 4k to call calc_bitmap_size
>>>>
>>>> In current cluster env, if bitmap area beyond 4K size (or 512 in very =
old system), locate_bitmap1
>>>> will return wrong address.
>>>>
>>>> Please refer write_bitmap1() to saparate 512 & 4096 case.
>>>>
>>>> On 10/28/20 2:04 PM, Xiao Ni wrote:
>>>>> Now it only adds bitmap offset based on cluster nodes. It's not right=
. It needs to
>>>>> add per node bitmap space to find next node bitmap position.
>>>>>
>>>>> Signed-off-by: Xiao Ni <xni@redhat.com>
>>>>> ---
>>>>>  =C2=A0=C2=A0 super1.c | 12 +++++++++---
>>>>>  =C2=A0=C2=A0 1 file changed, 9 insertions(+), 3 deletions(-)
>>>>>
>>>>> diff --git a/super1.c b/super1.c
>>>>> index 8b0d6ff..b5b379b 100644
>>>>> --- a/super1.c
>>>>> +++ b/super1.c
>>>>> @@ -2582,8 +2582,9 @@ add_internal_bitmap1(struct supertype *st,
>>>>>  =C2=A0=C2=A0 static int locate_bitmap1(struct supertype *st, int fd,=
 int node_num)
>>>>>  =C2=A0=C2=A0 {
>>>>> -=C2=A0=C2=A0=C2=A0 unsigned long long offset;
>>>>> +=C2=A0=C2=A0=C2=A0 unsigned long long offset, bm_sectors_per_node;
>>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct mdp_superblock_1 *sb;
>>>>> +=C2=A0=C2=A0=C2=A0 bitmap_super_t *bms;
>>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int mustfree =3D 0;
>>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int ret;
>>>>> @@ -2598,8 +2599,13 @@ static int locate_bitmap1(struct supertype *st=
, int fd, int node_num)
>>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D=
 0;
>>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 else
>>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D=
 -1;
>>>>> -=C2=A0=C2=A0=C2=A0 offset =3D __le64_to_cpu(sb->super_offset);
>>>>> -=C2=A0=C2=A0=C2=A0 offset +=3D (int32_t) __le32_to_cpu(sb->bitmap_of=
fset) * (node_num + 1);
>>>>> +
>>>>> +=C2=A0=C2=A0=C2=A0 offset =3D __le64_to_cpu(sb->super_offset) + __le=
32_to_cpu(sb->bitmap_offset);
>>>>> +=C2=A0=C2=A0=C2=A0 if (node_num) {
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bms =3D (bitmap_super_t*)=
(((char*)sb)+MAX_SB_SIZE);
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bm_sectors_per_node =3D c=
alc_bitmap_size(bms, 4096) >> 9;
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 offset +=3D bm_sectors_pe=
r_node * node_num;
>>>>> +=C2=A0=C2=A0=C2=A0 }
>>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (mustfree)
>>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 free(sb=
);
>>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 lseek64(fd, offset<<9, 0);
>>>>>
>>>
>>
>=20
>=20

