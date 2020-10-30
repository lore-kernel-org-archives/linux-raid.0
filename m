Return-Path: <SRS0=hsaE=EF=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0914C00A89
	for <linux-raid@archiver.kernel.org>; Fri, 30 Oct 2020 06:44:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48B8722202
	for <linux-raid@archiver.kernel.org>; Fri, 30 Oct 2020 06:44:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="hhhX/A4D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725808AbgJ3Gos (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 30 Oct 2020 02:44:48 -0400
Received: from de-smtp-delivery-102.mimecast.com ([51.163.158.102]:40234 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725355AbgJ3Gos (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Fri, 30 Oct 2020 02:44:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1604040284;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F72D3nTIA6+4PfP7ms0X1V+g51pjFfegYhMvbsq4UYc=;
        b=hhhX/A4D94lTaB2GF/qJWGkuV8sTl7LL5FQZCpemhTRQnNyIPcjOlCxKFjALhmtgs475I8
        IfoU2K1Vycf23ktm4zOnjuzxsdWj+bt9YOUi2Lhvi+Vt/bcDSXbPw+fst5C4b1BGdCyTmX
        DL/5Pm6J0clr4lyzHlaHZpw366xLK6U=
Received: from EUR03-AM5-obe.outbound.protection.outlook.com
 (mail-am5eur03lp2057.outbound.protection.outlook.com [104.47.8.57]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-23-TKoVmFUZOiWGMgcpcQ4kdA-1; Fri, 30 Oct 2020 07:44:43 +0100
X-MC-Unique: TKoVmFUZOiWGMgcpcQ4kdA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N/czIAAU6/g6R5a9swM3nSp9iiZapPZhtkAry4bLSuHp62+/k0mmPA3OK12ZLSjmXENyBZgPF8UVhuwIIVb1AXBIdqrm2w2bZgB3FDH4JK8M9ulybpldW3MJbrYzBFLAnjqPox7+L4xiR8uTrCWndS6WP1nuWwNVu7U2ETyfemQy/pjh+LEp3pJZI/LK8QcV0b/qu0uFRUf7Kl22tUklxZRKt0Qi6ND2ZhA3w9HhQ+As1wejy7p5SuapBxsmoDGh3VSiVWrD6T9cqxwa2bTESCwEuF+xES8+Jo7aFokMo/XWgQTmr2Oaz88HgBfwRbHUEK52llM5vv/eFOnA7uBQ0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L7lWluzHzb+8Mk5HwJkeXl8WfSuaS69I4tXwM6onYgg=;
 b=HIQBsqNznh2gpo2eLETaLkxaJz3doGxmbrVPHlti+DElprPyCk0zEf92CMOPRpDT4tEiNSiMSPTKgoHEqHnfp8yYQexVHvsH0TikPZxv3+AvAPEfAbcaOo76s9J8YVaWcQIrdlS3SLlMIdsGIPFcwHY5eFcIrTvdlr8vsWJaahirYFiq9zrofLE65owpWWBHOPBvkWZM5dTtmf8LkytWj8vJdWgnqIUIvY75uA3yExO/YDHnmgvB0A3CUfHmdc1dnX0ydqlJHJzEDMV5bcP60pC6ABx5rKIQx0x8t6f6VLLSMjc/YPzxf/hQusV1QdcsePhVP3FgyNybgpY+kboa2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB6PR04MB3030.eurprd04.prod.outlook.com (2603:10a6:6:b::26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3499.27; Fri, 30 Oct 2020 06:44:41 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::197:4f2c:bd9d:ff7a]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::197:4f2c:bd9d:ff7a%7]) with mapi id 15.20.3499.027; Fri, 30 Oct 2020
 06:44:41 +0000
Subject: Re: [PATCH 1/1] mdadm/bitmap: locate bitmap calcuate bitmap position
 wrongly
To:     Xiao Ni <xni@redhat.com>, jes@trained-monkey.org
CC:     ncroxon@redhat.com, heinzm@redhat.com, linux-raid@vger.kernel.org
References: <1603865064-27404-1-git-send-email-xni@redhat.com>
 <95046dfe-c770-8950-c720-6b1d30bb1789@suse.com>
 <f0616f2c-7156-8717-349d-7dcf349fd421@redhat.com>
From:   "heming.zhao@suse.com" <heming.zhao@suse.com>
Message-ID: <779a49d4-43d8-2f8b-59ec-6d45d61cc3f9@suse.com>
Date:   Fri, 30 Oct 2020 14:44:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <f0616f2c-7156-8717-349d-7dcf349fd421@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [123.123.132.188]
X-ClientProxiedBy: HKAPR03CA0036.apcprd03.prod.outlook.com
 (2603:1096:203:c9::23) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.132.188) by HKAPR03CA0036.apcprd03.prod.outlook.com (2603:1096:203:c9::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.9 via Frontend Transport; Fri, 30 Oct 2020 06:44:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a34c0bc7-908c-407c-7be5-08d87c9f470e
X-MS-TrafficTypeDiagnostic: DB6PR04MB3030:
X-Microsoft-Antispam-PRVS: <DB6PR04MB3030CEA300A7534E66E7E7EB97150@DB6PR04MB3030.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MP0/5T562P7qpL743CjHiQeGlBiM45BecdKMGa+egrEiTU94NtqMom49+lGAEGxoShJJ/9CRvBQL1rlJOoHLHIPwcLyYUeYqYeOxA4KhHZVinTB1EBUR0lNHHaQQMvBnelnDIa4N3c5kJe6oXEJU0DDcx4St61alcqYAusC0Xs/zMr7kyA65FsGgpzP8qMY5BomESsAXkaMslATYbdJvgU5nToAUOcv+ccpdW3czAjGVpoQHvKNGe8NC0XgkNbXnBEsu1Aw6PsREsNDIG3+Ns6soOuF8G/evm3g4o6DWW3vdMgxvk1mwvgrI/Cu5FMcwBKpuZflhUKk0glAbkXZLTXoMLi/VPgu/t4uVYLRy6mTxCpexw2MeEVfYte4ALzvJtKlrDJfKVhEc5IZ6pJFStA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(366004)(376002)(39860400002)(136003)(2906002)(478600001)(5660300002)(8676002)(6486002)(4326008)(6512007)(66556008)(66946007)(8936002)(66476007)(86362001)(956004)(2616005)(316002)(31686004)(52116002)(83380400001)(6506007)(53546011)(16526019)(36756003)(186003)(26005)(8886007)(6666004)(31696002)(9126004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: OUUpVOxBKtMzGErSkxz82gAJZRbaC0UsaZTBUoomndGY1dq87eB+bkSP991DLDsFrme1A5Utr7Bm0O/kJzg6AoixA77deZqXD+HehcQwcT+l9/+AeK5XRAd2/BLw6lRwc0M90G1b+HwUJz3JgthdbP0XhRqMebs+O3reeBAPEMBrB3W34Kp45ne+7zdmoMpdrTilPaLGd1EWmBAOkm4hMNIJRiHZirYBEmEgzCbfZarSEcvOwzgIIZp8KFqll3lsVDBkWjr4Qmrlsq42qntpJD+GgzXDWc/hmKO1U13bv2UsxoNiViIQROStf/LsUVnnU+gjpVw1l5E73A+wGg3p+InUGSWJ1t8GDGmoID1+OCylrJza4iAwUpqgwiSH1SR5ibRhpH7q4JpcLFsbL+yAPQ7UccV3eNJcf7mDTcDegABwAZ3zxPaCLLgjaFbUemS0+YNcM8JoWFAyeRPEZt4GXyMbRGaLP/4XaAMq1L4Wers9rjIfYpbP3sBNcrMcsN+XyaqSAt/f2DbTc1UNNHOQxO9wz++3XM8d66oQ/o3UaC63dFJ2qNGJjc9YNfp5yhHtyuaO7/XwwjbPoxusNfvXMXhUAUoaR5aqkU2dKtCB19fkIS4kHTllf2VEvyGvWXNFR3KZLwLeLNeKEjRpxS6Faw==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a34c0bc7-908c-407c-7be5-08d87c9f470e
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2020 06:44:40.9019
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I+tGkhRFuqfkZ21mVf3ssCSEcgQYE5RMA6O3RLE3/iiFPqsSAEZ5tjFa4rtdobfMKFP4J0eiW7qMpOaNQkq/tg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR04MB3030
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

You are right. Only cluster case can trigger your patch code.
Hardcode 4096 is correct.

On 10/30/20 1:53 PM, Xiao Ni wrote:
> Hi Heming
>=20
> The cluster raid is only supported by super 1.2, so we don't need to cons=
ider the old system when
> it's a cluster raid.
>=20
> Regards
> Xiao
>=20
> On 10/28/2020 08:29 PM, heming.zhao@suse.com wrote:
>> Hello Xiao,
>>
>> My review comment:
>> You code only work in modern system. the boundary is 4k not 512, because=
 using hardcode 4k to call calc_bitmap_size
>>
>> In current cluster env, if bitmap area beyond 4K size (or 512 in very ol=
d system), locate_bitmap1
>> will return wrong address.
>>
>> Please refer write_bitmap1() to saparate 512 & 4096 case.
>>
>> On 10/28/20 2:04 PM, Xiao Ni wrote:
>>> Now it only adds bitmap offset based on cluster nodes. It's not right. =
It needs to
>>> add per node bitmap space to find next node bitmap position.
>>>
>>> Signed-off-by: Xiao Ni <xni@redhat.com>
>>> ---
>>> =C2=A0=C2=A0 super1.c | 12 +++++++++---
>>> =C2=A0=C2=A0 1 file changed, 9 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/super1.c b/super1.c
>>> index 8b0d6ff..b5b379b 100644
>>> --- a/super1.c
>>> +++ b/super1.c
>>> @@ -2582,8 +2582,9 @@ add_internal_bitmap1(struct supertype *st,
>>> =C2=A0=C2=A0 static int locate_bitmap1(struct supertype *st, int fd, in=
t node_num)
>>> =C2=A0=C2=A0 {
>>> -=C2=A0=C2=A0=C2=A0 unsigned long long offset;
>>> +=C2=A0=C2=A0=C2=A0 unsigned long long offset, bm_sectors_per_node;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct mdp_superblock_1 *sb;
>>> +=C2=A0=C2=A0=C2=A0 bitmap_super_t *bms;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int mustfree =3D 0;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int ret;
>>> @@ -2598,8 +2599,13 @@ static int locate_bitmap1(struct supertype *st, =
int fd, int node_num)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D 0;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 else
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -1=
;
>>> -=C2=A0=C2=A0=C2=A0 offset =3D __le64_to_cpu(sb->super_offset);
>>> -=C2=A0=C2=A0=C2=A0 offset +=3D (int32_t) __le32_to_cpu(sb->bitmap_offs=
et) * (node_num + 1);
>>> +
>>> +=C2=A0=C2=A0=C2=A0 offset =3D __le64_to_cpu(sb->super_offset) + __le32=
_to_cpu(sb->bitmap_offset);
>>> +=C2=A0=C2=A0=C2=A0 if (node_num) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bms =3D (bitmap_super_t*)((=
(char*)sb)+MAX_SB_SIZE);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bm_sectors_per_node =3D cal=
c_bitmap_size(bms, 4096) >> 9;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 offset +=3D bm_sectors_per_=
node * node_num;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (mustfree)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 free(sb);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 lseek64(fd, offset<<9, 0);
>>>
>=20

