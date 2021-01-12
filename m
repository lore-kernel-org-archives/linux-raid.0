Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EADBC072B1
	for <linux-raid@archiver.kernel.org>; Tue, 12 Jan 2021 21:47:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DE9623125
	for <linux-raid@archiver.kernel.org>; Tue, 12 Jan 2021 21:47:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732704AbhALVqq (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 12 Jan 2021 16:46:46 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:65480 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437968AbhALVhC (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Tue, 12 Jan 2021 16:37:02 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10CLWtmx020828;
        Tue, 12 Jan 2021 13:36:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=hF0hriGfy1XMZnfNzRgCATJ0L3FKoFzOJIaWzlMjvJU=;
 b=QVkXx1a18F8kdKxAojbdU8rAJw1OAnYB8Z18NbVS+AE1pPmZetNTCXV9qnwnb7s1L/X4
 NFjMQILiHjucusFAE1TLZNBR5Ildlvr/COckifK4clG38Ml5Sm3q1CeyHYxWem1qpx3C
 0L14V2wxJE9hvdOoM5VzAjpx4XSgiYip9cM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 361fp2sp82-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 12 Jan 2021 13:36:18 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 12 Jan 2021 13:36:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=METMWbKrPNeJY6SJsQs4euD4RyUjQS9sk8eaBIDHMu2Q6nK2YqKJgAuK5cfDRBBTfrRKboiWdq0BKtg10NNH0wU4zSMJN3HefK+8G4Xmok15XdBApaM3RwDHPPj2mbT1HYEMEH1ruhOG/8mS/cmRl7GkFz0pPPczN8it3lT5vvNBbZVxK5PbohCLypIpu+e6MeDY4HBQaDcgqTArdrRmCVAnu6h4JtFySQ5cUWKAIvEvlWdXKRFyn7NRKQYNSkLrVMAz1ALpyGM7lQWxdoAXeHfMWFlMWMnM2gui3DgQye7xsPVktkq79KqfleQeLG/9nBGgFarqf7Ie2IfEsu75Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hF0hriGfy1XMZnfNzRgCATJ0L3FKoFzOJIaWzlMjvJU=;
 b=BWf8Xp9MSzrhPXR6+2GbKA+zxEf+ad/QdKxIBwf6FByCWnHhdq4UxnPtQ1EJ+SJHZMUy3KANeFvWrfYfLzD4uy+7i/EWt70EPahKKuIugmp9jYHU6ChzOyln7/H/9qwyqtqSqeAyHCGLk+f1api2bEr9apodDUQJzUx1L5wve0jI8malSNbkWnA2xxU+zKo7Kp5XdfP+J+oOS6eZev8rrFwtGmjhjc4IeK+hofRUsKcX6IKEBrvqnoqQmMCpJWfkoRBVAO+nugzF83I+8KV4pOHNKyCgt26JYUzHXwl41qa9PLFoPylZpJfDMjKGRW+s82AsHnOU03bV1M8QJOxkSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hF0hriGfy1XMZnfNzRgCATJ0L3FKoFzOJIaWzlMjvJU=;
 b=J08bYPCZiFiFhT5x91z90El6TEZJICwRHCNRMLyXsCVFVYvI+M0AfhslvAmwBPPD9bT6fV4KTCWdu/IOlX2tuRqN5gl+bI4Sj2doT3FM0nT2Tzn8orgvagqfwBtH/FnIr7jMLkuS6rMSC2qyKc9+6AEQZ2yxItcazBNVxjw8t5Q=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3000.namprd15.prod.outlook.com (2603:10b6:a03:b1::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Tue, 12 Jan
 2021 21:36:17 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::c97:58e4:ee9:1dc0]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::c97:58e4:ee9:1dc0%7]) with mapi id 15.20.3763.010; Tue, 12 Jan 2021
 21:36:16 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Xiao Ni <xni@redhat.com>
CC:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "ncroxon@redhat.com" <ncroxon@redhat.com>,
        "heinzm@redhat.com" <heinzm@redhat.com>,
        "djeffery@redhat.com" <djeffery@redhat.com>
Subject: Re: [PATCH 1/1] Set prev_flush_start and flush_bio in an atomic way
Thread-Topic: [PATCH 1/1] Set prev_flush_start and flush_bio in an atomic way
Thread-Index: AQHWzr5vTEBlzEimgkSykEp35O2G56oj6+6AgADMfYA=
Date:   Tue, 12 Jan 2021 21:36:16 +0000
Message-ID: <45D2E6EF-116D-405D-A708-C4397B19393C@fb.com>
References: <1607582012-9501-1-git-send-email-xni@redhat.com>
 <f1f2ef45-6fc0-4593-d312-b961a0fb1174@redhat.com>
In-Reply-To: <f1f2ef45-6fc0-4593-d312-b961a0fb1174@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.40.0.2.32)
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:f14a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 35c1632f-ea88-4ebc-980e-08d8b74217bf
x-ms-traffictypediagnostic: BYAPR15MB3000:
x-microsoft-antispam-prvs: <BYAPR15MB3000103D668B7F79B769BA61B3AA0@BYAPR15MB3000.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vGj6juhlnbGcvlglCwM4+joJJKigCNhqvGDJHoLklRMgvpeXxMaxqFUJJLxs3FjJ2xQ7ZtevdorlGxeYTpnRfXXyDVxQanaZbOJeQhCetZzeFU1hmiZP0Q1EctD5mmmGw71S6LokQLAVb2Z+DWp0cA1mJIjdEqNcP2Z1bhoM6E6ZX4Gw0hkBJU8krPM3UwbWdrPWxwLADXNC2op064EunGDMw4CaIYrVoQSU7XFEbxzWsAkSCIlIZfNDWrh4tng6SsKMzOXE4weGfSGjG4ZSJAUyMJHmfOYiplYcONPz7AzrmtAcjZOwrH9Jgs+vBVdmvc/xOtpqsVxkZMCBODRDpsrfACmFQ0Cj4fmNsQB18UQE1MyAUrY8HSzbDBknNg/t4Ny3gMkf4HfplRbGpsf7tcLm4HZoBzCu1WmOf9PcTDY9KmUnr55DWur1mNugCy86
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(39860400002)(346002)(136003)(396003)(53546011)(8676002)(6506007)(71200400001)(6486002)(66476007)(316002)(478600001)(2906002)(2616005)(186003)(4326008)(91956017)(66556008)(64756008)(86362001)(54906003)(8936002)(66946007)(6512007)(33656002)(83380400001)(76116006)(36756003)(5660300002)(6916009)(66446008)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Sls7sMOdKat2KBJ4Gbr5j77o/fbZyQN8icdBmztQM1S/I6g4TyLZAWNA8YLC?=
 =?us-ascii?Q?YKHnBDirJQqhbrNJP9BgQrpMAVUrc2hs7/6BwZMWHHYLf6Gd7zA1yy6kkHeW?=
 =?us-ascii?Q?XpQl2rAEDkLC+kedUpuQwm26Q/bwnd/JVN661X80ukABeclJFtEPOD6G6vda?=
 =?us-ascii?Q?lnQwqAYpsYfmRq0XbHHL8680rf1ILUANYBV0j/NHbDrK1hosGGPY71rLdC1k?=
 =?us-ascii?Q?7gdOyGfwziZ5pEXErnoxT0yCBW8psTwl+DWXild5ycYg255rwnO5569Kgtrh?=
 =?us-ascii?Q?dYsENdGvV15CfLMZFTX0+GMxZSCyV+LXpzkOHkalNpxvGneLl7Fdx7wgv6Wa?=
 =?us-ascii?Q?7MkKJYRdWPE9ksl/USRSCZv4C+ALxAhYHAGQIZiv7iNeDTQxmIOYAckOj05O?=
 =?us-ascii?Q?1uvGoSGkzGEgpP3hIO2eYncWwGFvHiCCUbAQCmJ30bvVGMubQg99n3ljWVcb?=
 =?us-ascii?Q?OxCkdrt51t8XAxg8fwpfdmyUfkP2O5rQaXJdBNB8oAMonCJ3Rq+zynA/JmS1?=
 =?us-ascii?Q?cRWb0+ph0HHFw1CjaM03I3TpthuIyrGEkJoKG+83C2Aosp7fDzXea+jeWKPj?=
 =?us-ascii?Q?wW3zZR8pWBuK7kJNu/QYXZt8PoBPEgOHfc2ZJCOr5YtAztjRtOJJ+47YWlqk?=
 =?us-ascii?Q?FmcuBvutmbU2FoTQuRpBcYLvOpZ9RHotn3OnWR5WIMTE2xeYfjl8HvvElns2?=
 =?us-ascii?Q?FMs5tysnCnM290AEja3NMS6LWeNBc7Z4ZgJm1KWX4FjmO6F2MQJPVAHcyMMK?=
 =?us-ascii?Q?8SyQUeAu+vp+0RWd4AOiXo1YP6+jJrDGvkGcZvIr8LX1Aw7t0VJ50APaoxi+?=
 =?us-ascii?Q?6S9VkgOiFstMmoPUbtKCELB1W86QINFAqTnBuPzqY3X/Z7TDZ+Baki2v30Bn?=
 =?us-ascii?Q?f6tBb6N9+nCNQCgRZyH+UNB++R2zuNDm0UWumQf3vMowWcSu0MiDGmH4Fi1U?=
 =?us-ascii?Q?Uo5gJujbvEFY/lxE4fWS3vPMVxrDsidnvdMgJGy24vivBuLAYSr9SvHx4ZBQ?=
 =?us-ascii?Q?zlbW5sZUhwsrvHaW1fzzeEENPQPrMb3qOS4B6vlRU3CDXcc=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4531F0BDA9F87A4B81574A5475F9DBE7@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35c1632f-ea88-4ebc-980e-08d8b74217bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2021 21:36:16.6342
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K9AJbZvesQqxwKFMqez5NBh4L2vUs0f9Q7WrwEzyA0zMb77kFwvLdIhnjrPiHTJ4sdOI+KCq9G2m4AZ8mw3rLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3000
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-12_16:2021-01-12,2021-01-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 impostorscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 suspectscore=0 mlxscore=0 bulkscore=0 phishscore=0
 adultscore=0 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101120128
X-FB-Internal: deliver
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> On Jan 12, 2021, at 1:24 AM, Xiao Ni <xni@redhat.com> wrote:
>=20
> Hi Song
>=20
> Could you review this patch
>=20

I am sorry for the delay. Just applied it to md-fixes.=20

I made some changes to it
 1. add md: prefix to the commit log subject;
 2. Adjust the width of the commit log to 75 characters.=20

For future tests please run ./scripts/checkpatch.pl on it.=20

Thanks,
Song

> Regards
> Xiao
>=20
> On 12/10/2020 02:33 PM, Xiao Ni wrote:
>> One customer reports a crash problem which causes by flush request. It t=
riggers a warning
>> before crash.
>>=20
>>         /* new request after previous flush is completed */
>>         if (ktime_after(req_start, mddev->prev_flush_start)) {
>>                 WARN_ON(mddev->flush_bio);
>>                 mddev->flush_bio =3D bio;
>>                 bio =3D NULL;
>>         }
>>=20
>> The WARN_ON is triggered. We use spin lock to protect prev_flush_start a=
nd flush_bio
>> in md_flush_request. But there is no lock protection in md_submit_flush_=
data. It can
>> set flush_bio to NULL first because of compiler reordering write instruc=
tions.
>>=20
>> For example, flush bio1 sets flush bio to NULL first in md_submit_flush_=
data. An
>> interrupt or vmware causing an extended stall happen between updating fl=
ush_bio and
>> prev_flush_start. Because flush_bio is NULL, flush bio2 can get the lock=
 and submit
>> to underlayer disks. Then flush bio1 updates prev_flush_start after the =
interrupt or
>> exteneded stall.
>>=20
>> Then flush bio3 enters in md_flush_request. The start time req_start is =
behind
>> prev_flush_start. The flush_bio is not NULL(flush bio2 hasn't finished).=
 So it can
>> trigger the WARN_ON now. Then it calls INIT_WORK again. INIT_WORK() will=
 re-initialize
>> the list pointers in the work_struct, which then can result in a corrupt=
ed work list
>> and the work_struct queued a second time. With the work list corrupted, =
it can lead
>> in invalid work items being used and cause a crash in process_one_work.
>>=20
>> We need to make sure only one flush bio can be handled at one same time.=
 So add
>> spin lock in md_submit_flush_data to protect prev_flush_start and flush_=
bio in
>> an atomic way.
>>=20
>> Reviewed-by: David Jeffery <djeffery@redhat.com>
>> Signed-off-by: Xiao Ni <xni@redhat.com>
>> ---
>>  drivers/md/md.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>=20
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index c42af46..2746d5c 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -639,8 +639,10 @@ static void md_submit_flush_data(struct work_struct=
 *ws)
>>  	 * could wait for this and below md_handle_request could wait for thos=
e
>>  	 * bios because of suspend check
>>  	 */
>> +	spin_lock_irq(&mddev->lock);
>>  	mddev->prev_flush_start =3D mddev->start_flush;
>>  	mddev->flush_bio =3D NULL;
>> +	spin_unlock_irq(&mddev->lock);
>>  	wake_up(&mddev->sb_wait);
>>    	if (bio->bi_iter.bi_size =3D=3D 0) {
>=20

