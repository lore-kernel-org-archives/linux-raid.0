Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D9D7EB64D7
	for <linux-raid@archiver.kernel.org>; Fri, 23 Jun 2023 15:45:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232258AbjFWPpv (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 23 Jun 2023 11:45:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231539AbjFWPpt (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 23 Jun 2023 11:45:49 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C64E32122
        for <linux-raid@vger.kernel.org>; Fri, 23 Jun 2023 08:45:47 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35NDj3gR024441
        for <linux-raid@vger.kernel.org>; Fri, 23 Jun 2023 08:45:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : mime-version; s=s2048-2021-q4;
 bh=+akKE3pgkyUHm73OhxVLHyJ1Gm5RM9+Ewvq2n/lL008=;
 b=HKplsgUkGba7d46lJItqS4/cK99CQ9V3+s3JFlAuUoY3r904QCnRX50V8Ix+BeMtN/DH
 XZ3p2BME824YLg4TH3ynOFo6BQkOeZZJ2kuQmUSzMhlb4dixvMP991MJjACes2oJMseX
 A+IUE4oluRm5bQwgbgFsrjX57ScVAKLiZUhIjv62T8d/ZRAAPky6jVZewsaQS8Vaelax
 1qgKsEHHFgESOT0jr2Hl8bTnK/+BhoZOjPmo+r9RRABgpxJcuMa7zp/+k74Nfk3H7nqN
 LqcZJGYyVmq1z32P9yodw2CM8aGW4kQDNcNJrhOvQXwO+Y+Qp2QnuzBEp3FD5+O8L4JB Hw== 
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2177.outbound.protection.outlook.com [104.47.73.177])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3rdcj78y8v-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-raid@vger.kernel.org>; Fri, 23 Jun 2023 08:45:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XnWbZZdOgGR61/SlB/sOGVil4rYfNFUy2Nb2/tacY+ImJf5eUsYUH3g78ba3d8z+dtj2Rprm68aAPv0wFAoSyFtw560lCWGDQnXp5FXwWzBU5idu7Wt0uGy4Xlf+0xvCfsdcWXGHdPmIdVQBwZWUPk7d4Wh/vaat1/jEJ41phD4oW9AcVfqk061KFd57iqziDpEnpWxjTKuJc8LX4OmpwzjTbA0/MhvDdkSJ0DZQRNC2P8Nt2Z3WLgmNEtUR+GagvDmOqh7ou0h5PeVQU9Okp0zhUDD/sN5QscBAXGp9LeUH1tqF+WlrHxrErXtCtiQj48oWA4bBe7HqU79WKrLYtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+akKE3pgkyUHm73OhxVLHyJ1Gm5RM9+Ewvq2n/lL008=;
 b=FiHtfaWNIxIwtv51YyFbUbqHiyYRUkqFXtL90DROlZbfPPEeHN5X1Wl1VRcSu63XVV2wMn3/7K1vJGunwewDHbh+WOAVVGESTUup7g/9NSpMWtQV5U42Z/wGp4tVNPG98DbUVhvNWOJ0dopve673B1ETzlCcoiGDu6FTYmaqgyaxUi5oZIYN6ROB3rslG/+nvgA6BH2CovJc03+6bmLL2Nv8V7a1AaFudrL8iw1tjvGAa3TMKWEZTkmuOz5iyxAIimkd0tlFc3h2+LNUooTQdvS7v665IlZElUVNgOPPhCg0g76g/f6hfM8Q9epM8Kq3/cn+UbNlcN3pK+HYYLvbMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by LV2PR15MB5357.namprd15.prod.outlook.com (2603:10b6:408:17e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Fri, 23 Jun
 2023 15:45:43 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::a353:7e78:2a58:dac1]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::a353:7e78:2a58:dac1%7]) with mapi id 15.20.6521.024; Fri, 23 Jun 2023
 15:45:43 +0000
From:   Song Liu <songliubraving@meta.com>
To:     Jens Axboe <axboe@kernel.dk>
CC:     Song Liu <songliubraving@meta.com>, Christoph Hellwig <hch@lst.de>,
        linux-raid <linux-raid@vger.kernel.org>,
        Li Nan <linan122@huawei.com>, Yu Kuai <yukuai3@huawei.com>
Subject: Re: [GIT PULL] md-next 20230622
Thread-Topic: [GIT PULL] md-next 20230622
Thread-Index: AQHZpZZGsF0fcMg7G0SBiGVFcgbVP6+YbjAAgAAP1QCAAAIbAIAACDCA
Date:   Fri, 23 Jun 2023 15:45:43 +0000
Message-ID: <CCDF243B-B82C-4371-9987-8F5E057EF4A0@fb.com>
References: <BCD9738E-472D-4AA7-B4F9-CCF36B5DA0E1@fb.com>
 <83240030-681c-9ff5-6e2c-600e83b0cc71@kernel.dk>
 <392A5BF5-2961-4F2C-A1C6-D6532B5AAFC2@fb.com>
 <480ac9e9-9257-b1a9-520e-50feb54dfdf5@kernel.dk>
In-Reply-To: <480ac9e9-9257-b1a9-520e-50feb54dfdf5@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.600.7)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|LV2PR15MB5357:EE_
x-ms-office365-filtering-correlation-id: 7a5c01fa-a001-4a91-d488-08db7400e762
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cpq9M3ck+Nh1FCilh+XMm3MAf+uwsd5FyGvvJ4iLj1rvsA9Gg1imdOXH1Bx66AWdEfmobn+MQ5K/zQ2/95JtGxU/LGaTgr3/N7ulH6IdnwNJPgEoa3CT7LxDIQC2Dgha5yXa788vKBN1vE8Wp4+aJU+PCvxYyGVNAlZt3KfdVAOt0rJ6RxY9snNktiTvbMR8H8zkmDatp5d0TyKQVt8I4AJNo9lzhHGj2U66187TW/LXur+oEhGnOEja0U7WagJcfhikuIyGcS6/FNPX40vg1PilJ+diurZVcpwhK1D+WexoSY0dR7N8mjFfkNN+NPlEKydFJAyd53hofn7K1kyTB+m+jHTWbO7rjXncmC+BWhrAeNI+Q/pJdFX+1UTdyoQarlKHEBDONQvm03SOdnEF3HLaeORAXSfxb6z+UkgIQKa/VBXvC9ywqABU9f3iD77Xcrz/rkjLpYeSt25JNDM0ozEiOqMU3EX1J8ToU+kBAmvru+c1hWXaEOOjnsW3TKxN9o8okDArfR/SY58RVg/N5NTbcLohtTzVEB7uQ+kvW5oaT2EYZWBec2CrdltUUyy8d1seqF3Vl5MeFqc+V0R8ucD25BKc9KK/J0O6Oe2Zl7iCVtWqkUmJukP1Lp32w0M6
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(366004)(136003)(39860400002)(396003)(451199021)(53546011)(186003)(71200400001)(6512007)(9686003)(6506007)(33656002)(478600001)(2906002)(41300700001)(8676002)(8936002)(86362001)(122000001)(36756003)(38070700005)(54906003)(38100700002)(4326008)(6916009)(316002)(76116006)(66946007)(5660300002)(6486002)(66446008)(83380400001)(66476007)(66556008)(91956017)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7RzlCtPWjHwfa/VFozHatbvoOC2tOeOW7ImdhqqhDepCzeefkvJi1MNxEi6o?=
 =?us-ascii?Q?+uJPNe1wEPQPWsK3u4WLNDLNnEfRuz72R0bIg6SmQzfaMf6NOx322SF+Bn/l?=
 =?us-ascii?Q?A0BTfDqO7j5rVeYuE1aW0UFi57UAUS4eQzj7j0WXxhpJJV1Ra0kjltJrXj6O?=
 =?us-ascii?Q?ILRgS1Bn4h9mTaEeaDIpZePIEyaydqfCDYukHU9nfNbDixvJ3aqmZGrrbS0Q?=
 =?us-ascii?Q?CqPlKwy7NG3Ncgi9Vpp9swgr++Z2RQYZ70jHc5RJeSxOk2xSII8Zpv/0r96/?=
 =?us-ascii?Q?kF8uTAsZBZQgHXohDKrpJ50FKBghqMcduGQk1fKvebIC2C62fuRaVrv8IF54?=
 =?us-ascii?Q?lYTenxuYr0cN2S5NVHcCVHl1idEb5f9/U255OD+Qcr667umoYKxcuOU2sZzf?=
 =?us-ascii?Q?vcJP0fuXJZb+iu/JoZH2etGT4lkzcDRimmILbPMwu44v3DJdPG1jz8XGGnMi?=
 =?us-ascii?Q?XiYhvuMhD9UPwzul0fdvrLhn2wakI90Z6AhmCKKZLNA8Hp7p16k/P13UNPzf?=
 =?us-ascii?Q?MCgDTssPS23nqsAtUHx8k9Sii6n200d9+mmROTA6KosJdw71cl2b2o9pj6mV?=
 =?us-ascii?Q?l3ENvIeIxFLfiZaN4F408OieuD+ahCrXDNPYd/X3YlmNPbV3nWqtmE6WYS9+?=
 =?us-ascii?Q?Ho1LMcLjSUguQPcv/3qOsmVCJPc3yy+4tJ0i8u+hTDcA8dVPLkfu4cHi1z6C?=
 =?us-ascii?Q?J4RkYHLX0r6FfRD0zUrnv0wDFsnvVjYfa/RGca4l0fJ50qgHh+E7du4xv8Hn?=
 =?us-ascii?Q?2niCt9nrdpW6297jvr0SiXxxWgzZHu8pjAypoKSM+yP/IO6gWgZlppsmrEQa?=
 =?us-ascii?Q?5PSUawZX+8I41MmiGUOUNjZ7uLYo58cvDGgbWrPbaYLrdOwuaOvT8pM0YbZV?=
 =?us-ascii?Q?I9p1Sf51RN7/q5bdCW0Jf2DP+VqNn+Lss99yqm//b6deNahKq+oDU5mJDZnt?=
 =?us-ascii?Q?2qWevtgdCoOYciLffH8c2MbK27/teSnpx7ZOQC0nzTvb0/V/lcer5jnG0ILx?=
 =?us-ascii?Q?2pg3vMPYR9T0FMTrNCvur51lfNXnFp/3scWnTkmGgQ/U0z6EEbzJC/WoD7AF?=
 =?us-ascii?Q?RhXy/spfymbzWPSUVeZsaCJeQ9cNLdQdcvBbOONmBt4BnVxaDntF7fjHrlt4?=
 =?us-ascii?Q?Oni14kEntmUjJlfabMjyteyP8WS4tqCLx5JCV+BZd9BVnNbZ3R959eB23jXS?=
 =?us-ascii?Q?5U6csFquBQIousWgftOy7a3W9MsrAqLjpb3TB3+fYpgJZ0lOc7vbDqI8/oo7?=
 =?us-ascii?Q?xmJqlX6MCj0EGRaurZI1xMQOscOxy8acaw3IJhBjm6rrbd2eAXmvs9hv8yHW?=
 =?us-ascii?Q?4W9Ynnv6gmpmpD9IIekpLGyciDfan8l80pVk38jOUc1WZ6+2zIrohgdwnnWu?=
 =?us-ascii?Q?GcON2wqTMM0YFCphYcWUthRppL1MpQPLLBFZxDBDPlHg0TrKbUVRWmUZM2ze?=
 =?us-ascii?Q?pjJy+fEb0iTfbU/b6iSlAF6l0w8IUzPVwsj+X6tTrSZCoKATy2zJUevIHHg4?=
 =?us-ascii?Q?XRD15D+otkHNCWnLQs0kOAf0qj2rC+VusIWB2EqIgqCklKUz76SfEa3msHOy?=
 =?us-ascii?Q?4J8sPvNrWDTB5B9gD4ZXaseB2tofuFJGHokmkI60Q5mYVl56WLuCeM/L/mf1?=
 =?us-ascii?Q?/5Z3CsMatvMYGxhjtbfEKYI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3531227005A491478E8396A33F12B83E@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a5c01fa-a001-4a91-d488-08db7400e762
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2023 15:45:43.3421
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +r8gIYp3V7BQ4RW5iFlKzQDQ3+hDu9OygqSaXFpVrpzHmHzH2zw46tRHoQbf1vJls8yhJT5X7ZYsE5rgmFcNTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR15MB5357
X-Proofpoint-GUID: ydnpf6G7h46Xg9DZFhvi7hG8bC1uWB59
X-Proofpoint-ORIG-GUID: ydnpf6G7h46Xg9DZFhvi7hG8bC1uWB59
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-23_08,2023-06-22_02,2023-05-22_02
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> On Jun 23, 2023, at 8:16 AM, Jens Axboe <axboe@kernel.dk> wrote:
> 
> On 6/23/23 9:08?AM, Song Liu wrote:
>> Hi Jens, 
>> 
>> I am so sorry for this problem. 
>> 
>>> On Jun 23, 2023, at 7:12 AM, Jens Axboe <axboe@kernel.dk> wrote:
>>> 
>>> On 6/22/23 11:48?PM, Song Liu wrote:
>>>> Hi Jens, 
>>>> 
>>>> Please consider pulling the following changes for md-next on top of your
>>>> for-6.5/block branch. The major changes are:
>>>> 
>>>> 1. Deprecate bitmap file support, by Christoph Hellwig;
>>>> 2. Fix deadlock with md sync thread, by Yu Kuai;
>>>> 3. Refactor md io accounting, by Yu Kuai.
>>> 
>>> This is quite a lot on the day that I prepare pull requests for the
>>> merge window... I've said this many times before, but just to state this
>>> in completeness, maybe it'll benefit others too:
>>> 
>>> 1) Major changes for the next release should be sent to me _at least_ 1
>>>  week prior to the merge window opening. That way it gets some decent
>>>  soak time in linux-next before heading upstream.
>> 
>> I am aware of the rule. A couple reasons caused a late PR this time:
> 
> Then please be explicit when sending out a pull request like this on why
> it's late. Otherwise it just looks like a normal pull request, which it
> is not. If your original pull request had any kind of explanation on why
> so much is being sent so late, then we would not be having this followup
> at all...

Indeed! I should have explained the case in the first place. 

> 
>> 1. Set #1 and set #3 are relatively new, especially set #3, which was
>>   first sent earlier this week. Set #2 is older, but there was more
>>   discussions on it until recently. (It is still my fault not pushing
>>   on set #2 sooner). 
>> 
>> 2. I wasn't very sure whether there will be a rc8. The announcement for
>>   rc7 didn't state it clearly. (Shall I assume there is no rc8 unless
>>   Linus states it clearly?)
>> 
>> 3. I was hoping to group more patches into one PR. I guess this was the 
>>   biggest mistake, especially when it is close to the merge window.
> 
> Most of the time Linus will be explicit about _maybe_ doing an -rc8, but
> it doesn't really change the rule that I should have bigger stuff in the
> week between rc6 and rc7. When -rc7 is cut, my for-next branches should
> be basically baked and done at that point, and then post -rc7 just fixes
> for existing code. If people stick to that rc6-7 timing, then it'll
> always work, regardless of an -rc8 happening or not.
> 
> Even when Linus has -rc8 musings in his later rc posts, it's not a given
> that they will happen. 

Thanks for the explanation. I will get big things ready before rc7 in 
the future. 

> 
>>> 2) Minor fixes, either for major pulls that already went into my next
>>>  branch or just fixes in general, can be sent anytime and I'll shove
>>>  them into the appropriate branch.
>>> 
>>> When bigger stuff gets sent this late, then I have two choices: reject
>>> them and tell you to send it in for the next version, or setup a new
>>> branch just for this so I can send it to Linus in a later pull in the
>>> merge window. Neither of those two options are great - the first one
>>> delays you by a release, the second one creates more churn and hassle
>>> for me.
>> 
>> I will prepare another PR with just fixes. 
>> 
>> Christoph, 
>> 
>> Please let me know if you need set #1 (deprecate file bitmap) to 
>> unblock other work. Otherwise, we will delay it until 6.6. 
> 
> I've done a for-6.5/block-late and put your stuff there, but it can be
> dropped very easily. It doesn't really matter if Christoph's stuff can
> get pushed, it's still a lot of commits late. So regardless of that, the
> only real difference with a new PR would be that we'd drop some bits.
> It'd still go into a late branch, as it is indeed late.

Thanks for taking them to the late branch. If it is dropped, shall I
1. Delay bigger sets until 6.6;
2. Send fixes in a separate PR (after 6.5-rc1)?

Thanks,
Song


