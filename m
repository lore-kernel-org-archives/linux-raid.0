Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DB8AC433EF
	for <linux-raid@archiver.kernel.org>; Tue, 29 Mar 2022 02:37:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbiC2CjN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 28 Mar 2022 22:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbiC2CjM (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 28 Mar 2022 22:39:12 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0876B2467D0
        for <linux-raid@vger.kernel.org>; Mon, 28 Mar 2022 19:37:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1648521448;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Yr5qApSYU9hAGruFjyNgZ7F5GCDPcrA1PRCxsvQpT0s=;
        b=KRRiTNxaHoZFRZ/Siy45X2hz7qm7YsYEghVAYUYkET4wY1y5QG7usnHPhnm74/oUTaRm8y
        fOaXZEcs3GNHjhD7LxD9wByAKyBwZSEbyiWEdtiIL4cavslABhJUXqe9hEim+QjPTyfwPx
        W0IJYBLNm+L9fNVIVt4X6yPtQ9I3hWY=
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur01lp2053.outbound.protection.outlook.com [104.47.2.53]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-33-RR1UiTIIMsuxD_MQTbVCaw-1; Tue, 29 Mar 2022 04:37:25 +0200
X-MC-Unique: RR1UiTIIMsuxD_MQTbVCaw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WxhzOLQFvq0KSLiip+NfQOjKQm+Y0u0d9+Cthpp49CjQWvqvoY8sUHioBxsZtWPWGu7fhkGs0N/Owdyk98JUnit2t7KQtRohAYPZ3jeYX8Mywuzyqs1TkjYto3vEGc3qmPwlget61U+Tph84e/SpVYjI4Rrf8SlXQzEz0JfeM8ptYIAQV4tMdM9+hEn9EGIazx3vS8T3Wc7nQe0QDe1gGi2CnnVQtYushK1Lp2Arr4mDQz81jaEyY7+GFy37BDa2pFyhU1LMkh6gLR2TSLkGeHAGZwo8IDDsAcWXT/eMmF3/vMQN5Ax8Pl82IulviepLEojFlse2VEM9HFtWRHEq+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EKVIW1op0U4cM2VehKzMrJIKh4B91SV7DkY/gGvaI2s=;
 b=X3ACr57TZ5sCkiRCH5t2V7+zw3nNuEfx4RKQJTAE9Q0MG6FlWiChfEMjJU+KCIHCkx+6ddgfvzNEhh1d+yiqKC/Up0/q4j24AGZxVDmXaF2fn+4AQh5pss7CsWIYv2tZKV7zkVQMOocbxV7pqedSCkSm26VkJYAfARKGXYoP0L5mjboYA3k9bvT395fOcK//mx/ZNao8PEaHeZCS7kxP7Fk1JsWLzuF96A+PB17zGBvCJ53GUkSK4Bi0ZM87DOpWUGBxi7kzdfcC6mbLm7ujYIr5YhokbTO8oYnMSIqsR4M6m6HN6FLfe8AwQ05AY5Wt4RQ2+PLQynnEIP5IJmE+8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB9PR04MB8410.eurprd04.prod.outlook.com (2603:10a6:10:24b::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5102.23; Tue, 29 Mar 2022 02:37:24 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::34b0:c774:609d:2764]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::34b0:c774:609d:2764%7]) with mapi id 15.20.5102.023; Tue, 29 Mar 2022
 02:37:24 +0000
Message-ID: <b9c2bbef-9bfd-1b60-9e56-9daedc016b3a@suse.com>
Date:   Tue, 29 Mar 2022 10:37:16 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] md/bitmap: don't set sb values if can't pass sanity check
Content-Language: en-US
To:     Guoqing Jiang <guoqing.jiang@linux.dev>,
        linux-raid@vger.kernel.org, song@kernel.org
CC:     xni@redhat.com
References: <20220325025223.1866-1-heming.zhao@suse.com>
 <cd198e0b-eebb-f13c-49e7-338aa6835099@linux.dev>
From:   "heming.zhao@suse.com" <heming.zhao@suse.com>
In-Reply-To: <cd198e0b-eebb-f13c-49e7-338aa6835099@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: HKAPR04CA0003.apcprd04.prod.outlook.com
 (2603:1096:203:d0::13) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4a15d855-2620-48d4-8495-08da112d0e54
X-MS-TrafficTypeDiagnostic: DB9PR04MB8410:EE_
X-Microsoft-Antispam-PRVS: <DB9PR04MB8410714E73698F6F36CDFFD5971E9@DB9PR04MB8410.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J5s/6dz8sJiop5Jpsnz9zd9ITM6lKvYBmvH9dJxQ9bw0eeVhJ6eUR5r3MYpxxEpu5Y7l3JUcxyt4yQg1RpgkWh/ruZFrgxvJmqXEX7Qr0R2wtLLmd12WEgXyoKxVnNkiklBKJzLY5hICsn1cBbN37FGIUh8OZCkx2dsUWpw8aSwEC8HlRU9Kaa7GLgnP/BBYhsavfwKqeKfNbn7EdXLlGeC+kn/R0mE/3TgUtAogn1ivto8PH0roiS2i04VAZSlaSjf8TDf0GBK3ZN3FgVvy8tmU02Wnp9VyuDCNViQog/gqGspgkJ+bXeYJfIM9bFu0LzNCrsgnfl2mi/ht5EpLC9a4lPiCJ+r80F8g47Tounvri8jmN5l72lnlZHgtCNy10PsYo/etOlGYinTFOnkYeUDRDiPXaLuSXAd7Df9YiuI9bEUD53byqA8gRvjJzTE3lltvreNDqu3qgyYfiu52F6WWR+Bw+wsYA6ggaaXRfpMVBg9zQWWRx88lkW4cxWb2dKjpHvVJWWdJ5arrK3mCQ+KboOiRMahy4GJKj54mAmL8HeiQ4glADZNM6GOX/xCCFA2uXIAr9BTdqX4zbtaY0VscNnjdvzBn9p0D/qkHzvKvoDqwtDZ5ax025GPyyWyWaIhvNu5D1C/QZa09/w0A3PihZIZXjrMT4LST6hzuY/LO/pw11Ggw4/wo8CP3xAKEbxmOyozXtrxNhxQq6i4NMdiT4fhEzQeDGgbYWEDv7nY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(31686004)(8936002)(83380400001)(36756003)(316002)(2906002)(86362001)(508600001)(53546011)(2616005)(6506007)(6512007)(6666004)(26005)(186003)(66946007)(66556008)(66476007)(4326008)(8676002)(5660300002)(6486002)(31696002)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VcU6bA3RB6aI0eDi9Y/4Jku53t2ZSN63gTw6ygwk/2p/GE/8NZHtihm0NWdR?=
 =?us-ascii?Q?KROoA90lGjD9hEHCGWPSWULNyKOEJiMecvDboIQ1SIS1BemWtqoWD/S9j2qo?=
 =?us-ascii?Q?6l8IlpOMRZxu5dcvs67mnXxacOJm+sxjfFk7eJFijPgu1LHjbNaFQX+PDODz?=
 =?us-ascii?Q?lR2yaVuGXXP+ctUuwcyDerL6TS8PSZ57HSnwnKx1MSGatnu/2SOYfh9TsoAY?=
 =?us-ascii?Q?lPp6VZ5PFBZi640cwQJXKDvnBjred1bngYKGFlqS5vMVcDX0gDGHcObx7tW1?=
 =?us-ascii?Q?Q+6W7Ux1RkyaCLQpusJVZc19JCCfyVGhpVyhUboSKONfwivKzt7WGYjjNuKj?=
 =?us-ascii?Q?psBkJG0CcK4slP9jd6rfLe2MKILp/a1a5F9CNwzfJxZ8y6IKHpnWVxT2Ztuc?=
 =?us-ascii?Q?wpbPGobhFQJUl5hCmt2FFh0xb8eYN8rX/tJYNnFdI0iyy0h+2IX30c3bieix?=
 =?us-ascii?Q?TbJidpbN81OFdMkGP6RWPhVipNA5XP0+JJnvI2hwG4Ax2DwORJMPM2yUE55o?=
 =?us-ascii?Q?D1SZbcHpbOEAbkzU1EKc0Ne2uoH6IHVdxmCBdEVrf8Vbxnwk1vbYDiSh8blK?=
 =?us-ascii?Q?VYgNgGugINenWzr/NKwe/Hsw8CnGVs3bY7NLfhOSdGOWD+n3yQ8FdMnP35/P?=
 =?us-ascii?Q?+DqOwe+rrcqMtxXjSxkp87J9jQkgGBmSvqyQWdG7JfiDGWIvo7Rc1L35uwQq?=
 =?us-ascii?Q?wLX1U7ocsiGEmmRghufICS2gWz9Bi+p/up7E0YGElimp5jZva2PSPNmpRCIZ?=
 =?us-ascii?Q?ePYiqiv/NEScraIy4GwoxI7nFmDDbjLwjC/8pokhPJh1F0+aPTckxGHV009l?=
 =?us-ascii?Q?MJ7/3gy8gf0kSpFNLCxlMYwlFsqe624yY5m4HL2KuvGkRGBUUcOmFMw/oJTJ?=
 =?us-ascii?Q?JdKyWNQDI8oMhe6sV5X24tmc082jmdG2xOhnWKOHR8Ebk2+xSsHGk45fziUJ?=
 =?us-ascii?Q?HqfPT79FUiLM/MJ2o8GenB3BHvIllY6LiKWKXUiVhypAXZHc/+0uidPTFtYW?=
 =?us-ascii?Q?lRofjpBNZAXQ8ahrZUvO8B8Ms+6VjTD2aXH8gs2jT4MIjC3iJHHgzoUFqF9X?=
 =?us-ascii?Q?MPbGi/aILngZ1OiLsluSRnGPd7hmQZn5R2JWBxkl2bjc0x6myMc4xbhdLLW1?=
 =?us-ascii?Q?hhBGJlECFhSmkyg5yiAzX4qzdnjgRiZBjZFAnBGa9gmy35J332DwEpj5R53T?=
 =?us-ascii?Q?pxvmpDixSCfhjVTOenWfuugdt+eM1HBK2Iydhvr5j0bTEZhcH9ET9NVWXqUZ?=
 =?us-ascii?Q?uG7eCdKryikOOPpGXFnTtQTGpGm6fu+fS7E71pbGBUkDtRcNB3VtTF1d30N5?=
 =?us-ascii?Q?XZsZpihluRyb/gLb42r4MiWqoJF0CiAeQ2Rvy6bEVTA63cVLebSz/DtB/KUU?=
 =?us-ascii?Q?iNMjU8Z7KyYAv2Cxczubx7JvYOKdd36wrX5BPc1OrZ8uyIQ3J2QmhhMWj3kY?=
 =?us-ascii?Q?35YsIESqcEWZ737eHtAUCT/peQPNlD1AF59Ncv2uG87lZCAARgmbJUvJ6Fp3?=
 =?us-ascii?Q?k1X7EdFZCkx5RXi6DHS8MoEJJDcmJRnjp3KtJuWFzkt2zT/mj4yLRqDzm6RE?=
 =?us-ascii?Q?HpwPxJwDRcoXvUbcPAj7T5IFmpIneJthhToKg1cxesGLIwJ0xJKFE547ahZ2?=
 =?us-ascii?Q?qFxUW8Hwew25vqoR7sMMQYfTpFg965gI4NF1gVuPkW6decAlxOoI6MJ/7iVg?=
 =?us-ascii?Q?GSv8CRWGUPhQ4I64S99NFc+CLtN7AXqn+AV3JhZI3rSCGQKWcNd52zqo9YY3?=
 =?us-ascii?Q?/QNsXrZESg=3D=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a15d855-2620-48d4-8495-08da112d0e54
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2022 02:37:24.1248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GK75bDBGFI69MTCkbGLHoI8y+vZtJNl7FVDwOik1hjROy8GMFw87AjtK/FEWt2YgxT/2x/FM/JOReBA+rEUENA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8410
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/28/22 08:43, Guoqing Jiang wrote:
>=20
>=20
> On 3/25/22 10:52 AM, Heming Zhao wrote:
>> If bitmap area contains invalid data, kernel may crash or mdadm
>> triggers FPE (Floating exception)
>> This is cluster-md speical bug. In non-clustered env, mdadm will
>> handle broken metadata case. In clustered array, only kernel space
>> handles bitmap slot info. But even this bug only happened in clustered
>> env, current sanity check is wrong, the code should be changed.
>>
>> How to trigger: (faulty injection)
>>
>> dd if=3D/dev/zero bs=3D1M count=3D3 oflag=3Ddirect of=3D/dev/sda
>> dd if=3D/dev/zero bs=3D1M count=3D3 oflag=3Ddirect of=3D/dev/sdb
>> mdadm -C /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sda /dev/sdb
>> mdadm -Ss
>> echo aaa > magic.txt
>> =C2=A0 =3D=3D below modifying slot 2 bitmap data =3D=3D
>> dd if=3Dmagic.txt of=3D/dev/sda seek=3D16384 bs=3D1 count=3D3 <=3D=3D de=
story magic
>> dd if=3D/dev/zero of=3D/dev/sda seek=3D16436 bs=3D1 count=3D4 <=3D=3D ZE=
RO chunksize
>> mdadm -A /dev/md0 /dev/sda /dev/sdb
>> =C2=A0 =3D=3D kernel crash. mdadm reports FPE =3D=3D
>=20
> Thanks, could you also share the crash log to make people understand it
> better?

OK. will update in v2 patch.

This patch derive from one SUSE customer's bug. That bug includes two issue=
s at least:
- bitmap sanity check issue. This patch fixes this issue.
- spare disk setup issue. I preferred to file another patch to fix.

And two of the issues are specific cluster-md.

>=20
>>
>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
>> ---
>> =C2=A0 drivers/md/md-bitmap.c | 40 +++++++++++++++++++++----------------=
---
>> =C2=A0 1 file changed, 21 insertions(+), 19 deletions(-)
>>
>> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
>> index bfd6026d7809..f6dcdb3683bf 100644
>> --- a/drivers/md/md-bitmap.c
>> +++ b/drivers/md/md-bitmap.c
>> @@ -635,19 +635,6 @@ static int md_bitmap_read_sb(struct bitmap *bitmap)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 err =3D -EINVAL;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sb =3D kmap_atomic(sb_page);
>> -=C2=A0=C2=A0=C2=A0 chunksize =3D le32_to_cpu(sb->chunksize);
>> -=C2=A0=C2=A0=C2=A0 daemon_sleep =3D le32_to_cpu(sb->daemon_sleep) * HZ;
>> -=C2=A0=C2=A0=C2=A0 write_behind =3D le32_to_cpu(sb->write_behind);
>> -=C2=A0=C2=A0=C2=A0 sectors_reserved =3D le32_to_cpu(sb->sectors_reserve=
d);
>> -=C2=A0=C2=A0=C2=A0 /* Setup nodes/clustername only if bitmap version is
>> -=C2=A0=C2=A0=C2=A0=C2=A0 * cluster-compatible
>> -=C2=A0=C2=A0=C2=A0=C2=A0 */
>> -=C2=A0=C2=A0=C2=A0 if (sb->version =3D=3D cpu_to_le32(BITMAP_MAJOR_CLUS=
TERED)) {
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 nodes =3D le32_to_cpu(sb->no=
des);
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 strlcpy(bitmap->mddev->bitma=
p_info.cluster_name,
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 sb->cluster_name, 64);
>> -=C2=A0=C2=A0=C2=A0 }
>> -
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* verify that the bitmap-specific fields=
 are valid */
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (sb->magic !=3D cpu_to_le32(BITMAP_MAG=
IC))
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 reason =3D "bad m=
agic";
>> @@ -668,6 +655,19 @@ static int md_bitmap_read_sb(struct bitmap *bitmap)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> +=C2=A0=C2=A0=C2=A0 chunksize =3D le32_to_cpu(sb->chunksize);
>> +=C2=A0=C2=A0=C2=A0 daemon_sleep =3D le32_to_cpu(sb->daemon_sleep) * HZ;
>> +=C2=A0=C2=A0=C2=A0 write_behind =3D le32_to_cpu(sb->write_behind);
>> +=C2=A0=C2=A0=C2=A0 sectors_reserved =3D le32_to_cpu(sb->sectors_reserve=
d);
>> +=C2=A0=C2=A0=C2=A0 /* Setup nodes/clustername only if bitmap version is
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * cluster-compatible
>> +=C2=A0=C2=A0=C2=A0=C2=A0 */
>=20
> I suppose kernel should print the "reason" if md failed to verify bitmap =
sb.
> And at it, pls change the comment style to

Yes, legacy code already handle/print the reason before "goto out".
For comment style, this area comment is legacy code, not my new added. But =
I could
modify it to follow the code rule.
>=20
> /*
>  =C2=A0*
>  =C2=A0*/>=20
>> +=C2=A0=C2=A0=C2=A0 if (sb->version =3D=3D cpu_to_le32(BITMAP_MAJOR_CLUS=
TERED)) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 nodes =3D le32_to_cpu(sb->no=
des);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 strlcpy(bitmap->mddev->bitma=
p_info.cluster_name,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 sb->cluster_name, 64);
>> +=C2=A0=C2=A0=C2=A0 }
>> +
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* keep the array size field of the bitma=
p superblock up to date */
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sb->sync_size =3D cpu_to_le64(bitmap->mdd=
ev->resync_max_sectors);
>> @@ -700,9 +700,9 @@ static int md_bitmap_read_sb(struct bitmap *bitmap)
>> =C2=A0 out:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kunmap_atomic(sb);
>> -=C2=A0=C2=A0=C2=A0 /* Assigning chunksize is required for "re_read" */
>> -=C2=A0=C2=A0=C2=A0 bitmap->mddev->bitmap_info.chunksize =3D chunksize;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (err =3D=3D 0 && nodes && (bitmap->clu=
ster_slot < 0)) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Assigning chunksize is re=
quired for "re_read" */
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bitmap->mddev->bitmap_info.c=
hunksize =3D chunksize;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 err =3D md_setup_=
cluster(bitmap->mddev, nodes);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (err) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 pr_warn("%s: Could not setup cluster service (%d)\n",
>> @@ -717,10 +717,12 @@ static int md_bitmap_read_sb(struct bitmap *bitmap=
)
>> =C2=A0 out_no_sb:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (test_bit(BITMAP_STALE, &bitmap->flags=
))
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bitmap->events_cl=
eared =3D bitmap->mddev->events;
>> -=C2=A0=C2=A0=C2=A0 bitmap->mddev->bitmap_info.chunksize =3D chunksize;
>> -=C2=A0=C2=A0=C2=A0 bitmap->mddev->bitmap_info.daemon_sleep =3D daemon_s=
leep;
>> -=C2=A0=C2=A0=C2=A0 bitmap->mddev->bitmap_info.max_write_behind =3D writ=
e_behind;
>> -=C2=A0=C2=A0=C2=A0 bitmap->mddev->bitmap_info.nodes =3D nodes;
>> +=C2=A0=C2=A0=C2=A0 if (err =3D=3D 0) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bitmap->mddev->bitmap_info.c=
hunksize =3D chunksize;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bitmap->mddev->bitmap_info.d=
aemon_sleep =3D daemon_sleep;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bitmap->mddev->bitmap_info.m=
ax_write_behind =3D write_behind;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bitmap->mddev->bitmap_info.n=
odes =3D nodes;
>> +=C2=A0=C2=A0=C2=A0 }
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (bitmap->mddev->bitmap_info.space =3D=
=3D 0 ||
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bitmap->mddev->bi=
tmap_info.space > sectors_reserved)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bitmap->mddev->bi=
tmap_info.space =3D sectors_reserved;
>=20
> Generally, I am fine with the change.

Thank you for your review.

Thanks,
Heming

