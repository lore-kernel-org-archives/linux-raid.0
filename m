Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1459EB64D7
	for <linux-raid@archiver.kernel.org>; Fri, 23 Jun 2023 15:09:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232194AbjFWPJZ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 23 Jun 2023 11:09:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232211AbjFWPJW (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 23 Jun 2023 11:09:22 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78E931BE4
        for <linux-raid@vger.kernel.org>; Fri, 23 Jun 2023 08:08:58 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35N4GWnO015585
        for <linux-raid@vger.kernel.org>; Fri, 23 Jun 2023 08:08:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : mime-version; s=s2048-2021-q4;
 bh=F6Tmf64j6cAHik+UDxEXPeNUH3KLuYTwkSL+JtIXl+w=;
 b=j7eZ2/yzZMlTPgokWpthO3GMuwuPpb6LPxfvpgc3SRYJQw5ogVLCJ+Sso08Y8/N/uGbz
 UCWLOqxLIw5ds5hjM6eC+Vpy6qi5hsL30Op9menVSSOivHheFNw2ZIZ8YouSpbv+lScq
 DRFJt1A5kDKRCzCcZyxvICD/IQb2qlk/XPYZ6qT2Uu1BCSe5hiJR8pmB2ZqDAZlrDT/x
 AsQ+P0VDhjtuKHqBG0O5G+7oSx+a0X7oqp+z+QrM7EH5puz65UzanDKuAe5YXN806e6F
 knReArIq420FyENas8qS56yeH+bSFxkvYJcqU8m/hPEDCSnU1OG40r66A9B2DLHBu1Hf lA== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3rcqahkkdg-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-raid@vger.kernel.org>; Fri, 23 Jun 2023 08:08:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kSbu6HT6HYmw6HJqJRCRrSJrFbS9Btl2sSa0CIOwJ66pQQSBY40UMS0SepfE3xJtSVkEGHm6mkdc9H5pSI2Yara9EZjpxXlxaI6xLrzLqTHXQt6mTfe1lP+eT+e0uR7oHhhASNOrr2eGFRXn+Rn/kRQRLLmlN2qZjjngwVgEA7M2EszbddSz924gPao4PzUGiumgfD3wY62pAF8KeqOmq4PCbrW+uiJOe5L9F+mrEu655qkVYt7zVeTKKQ00Q0Lxmvk7TvYuHiSYT388ZY1mp2KHouVaJbCKD6C/0RzI4InIwXkvuut3Nc6R24/MMNWENQrLlK6/yB3pxmUaW9lE3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F6Tmf64j6cAHik+UDxEXPeNUH3KLuYTwkSL+JtIXl+w=;
 b=M6xjC58js+damPAwF0QaYTt7YgiaQ8W5NqJTC4v1sXUbK1MO4Iatl4Sv8K7Le/a/CGC7eJcYTOaeUoEQktp4jUZIND2BIBfmrp2P4Zzw4yxY4sM2vUMd/OkPKrnlXkPSyQv59zxT6SSML2V3Y1WnSmk4ip0v993W2AtjXU3HEwOcZ65RA6U8FhCDk7JUB3oRcCksK+cf9IuClDLtV7KJmHt6lXPz48FY38ujX8Uo8drXRezzqmw4zAzsK4JXpq5lHcLbOmBV9Q5MlMrvw0QIllrhxMpQVOct4Ycm7pR+F6JHy1CuCYWT/4h9pzKyn1rlrRK/V2DTyVwBCih8wU95bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by PH0PR15MB5286.namprd15.prod.outlook.com (2603:10b6:510:144::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23; Fri, 23 Jun
 2023 15:08:52 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::a353:7e78:2a58:dac1]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::a353:7e78:2a58:dac1%7]) with mapi id 15.20.6521.024; Fri, 23 Jun 2023
 15:08:52 +0000
From:   Song Liu <songliubraving@meta.com>
To:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>
CC:     Song Liu <songliubraving@meta.com>,
        linux-raid <linux-raid@vger.kernel.org>,
        Li Nan <linan122@huawei.com>, Yu Kuai <yukuai3@huawei.com>
Subject: Re: [GIT PULL] md-next 20230622
Thread-Topic: [GIT PULL] md-next 20230622
Thread-Index: AQHZpZZGsF0fcMg7G0SBiGVFcgbVP6+YbjAAgAAP1QA=
Date:   Fri, 23 Jun 2023 15:08:52 +0000
Message-ID: <392A5BF5-2961-4F2C-A1C6-D6532B5AAFC2@fb.com>
References: <BCD9738E-472D-4AA7-B4F9-CCF36B5DA0E1@fb.com>
 <83240030-681c-9ff5-6e2c-600e83b0cc71@kernel.dk>
In-Reply-To: <83240030-681c-9ff5-6e2c-600e83b0cc71@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.600.7)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|PH0PR15MB5286:EE_
x-ms-office365-filtering-correlation-id: a1efd59d-c5a1-4203-9a0c-08db73fbc1bc
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: M3TKivdhITwq5ZFZeUgX8aUesbANLg9rL30mDLsYjEjvDp/KwLYwuvr7vCDtTFLndN+I4i5adI639wGWMplfzfQmN4INZtvh9WrsGX8+2OqK2sTj/FSv6kqDp4cpCvrr2EvvMFgLE60VyS9IDUBn0cZLft9LfF0SlUTwO+31WopdaH5padefltWYjQMzPW7aqeZJB/Ydxy7NJp66EZPz7SKTHsShLFTrZIk+oIPvRtW3gmJBvrbL5yUU3FT/hEwzCtd6mC8oA6G7J931lOvGhQo39hchW4cAq0GgjNZl155IrAoe9xGelzzmPpXzk82LnH/zX4bbrsKnOb8ZW98++5WlAgSJqidThGhmUm5t+J0qdZ1D4TYwjsi6xSirk0vCuYfmltJ+8v6Gt8yxt1rOHyKb4yerm5cdXBek2Tyu9tuIhUs7AGl0BRaLYn+nXEJ9GrLMR/tMcxPYhbjOAkH05nDBDL1yeamZ26wAHRxEAaz04iZAaGYIGgEe8jY8mXI828r6jkra0ReVR7kcflPvHyScrpexxCfIi1hXLE8rmcklclSIEn+QkghRZZYBdL80xnYKvi+t/oNfI6PkYm1yRymtyyZ3G0jFeOQy/uBrMnrAcIfFHM+p5bAjQSum+17R
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(136003)(396003)(366004)(376002)(451199021)(38070700005)(86362001)(33656002)(38100700002)(122000001)(83380400001)(36756003)(110136005)(54906003)(9686003)(41300700001)(71200400001)(6486002)(64756008)(66476007)(4326008)(316002)(66446008)(91956017)(66946007)(76116006)(66556008)(6506007)(6512007)(8676002)(8936002)(53546011)(186003)(2906002)(478600001)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ab3zu2foe0oGPLLpXvGFHYybcwSiUfKfQqqq2vkOjusKmsHhS0o6ElW2riFO?=
 =?us-ascii?Q?3hbd/Vhcs8iR5VB9CmX5ZLrFzoaoFDTa0CYj5UKdVd5FScVYexlBUeu2nfwx?=
 =?us-ascii?Q?9kDpup2nJszDKyK5D2yS0i5L5EoIqHA7JX4ulIq9gS1kcy5nYNZ4UwmjUvbI?=
 =?us-ascii?Q?sDyRtM8+0PSUfYNzGpOChkiZ7T3CWRz2A3/GNYg56OSv6vLDSJCi0HMO+nuN?=
 =?us-ascii?Q?jMvUGY3NjGHqkZWy3WnqWnjlSOyXIyvQ729pz1XVwkZxOAnjBRI87jDC15ey?=
 =?us-ascii?Q?kFk9+98RqwLCdBbA8wTfq+QXf0e80Jwk8qml4wVBPyuyxHIaEzKJtzOqijaZ?=
 =?us-ascii?Q?cwAWpNEgRrZ1tKJdAxt0NGJ1hyAC1FvZdFTHOIvTffkYdyidDjDz/vuiaw50?=
 =?us-ascii?Q?3ca0FkKH14srTuszUEyviqCeK9guG1+C0GE3PE011xIuFISi49wtbCjEKAAI?=
 =?us-ascii?Q?gzN18/NBZdbPtD245IKyC4vWH994FWpOSK+GiYAx5LaXH5BN/pAqXEnIzSRL?=
 =?us-ascii?Q?TmETvufXCS94iBnlo4oNOrTmlUqbpI+8kNn5bixGh5wGLDy2AcFL/CQqgpTJ?=
 =?us-ascii?Q?aXl4qy0LDvoPNfzj0a3wJbiIt8gse+OyyPSfs39xFeZz7nWd+aypiKlDsnzt?=
 =?us-ascii?Q?dvgbAehJfleV0UHs579cnvMrN9jJeYujYrNwpXkYAzyvxWao/AsVvr6ZjT+A?=
 =?us-ascii?Q?puU0NE2aJK6nJTCinB7jrzc7XK8Y21dLZ00ltNEeSkP/z7GuoGBCxECoGc4T?=
 =?us-ascii?Q?6kAdPuAT5BYzxIhvQdAza51hHjCN4YeQiS++5iI3FsEfvBVLqJQbwYr8GA6p?=
 =?us-ascii?Q?lHsDHg1XZVAVbtX2ksMw2a9az3m0+D3wUran6sApaRtCCj+4hyVyrHN832bS?=
 =?us-ascii?Q?G+xsO/887RNRC2S+n+CUFGmKDGHVLcgO+d3AVeUadeBc/WDXofN8SPC+CdCB?=
 =?us-ascii?Q?BmyCXfL2gnqGFuVcJcADy7ElyT83j0yyZ4Pi9VJ9MjUXAveVY4PvRJDr/CLD?=
 =?us-ascii?Q?QO33GCm13EknV8AbiURFo7Qd/bBlRsQqmW/oMDwxfYnBEju6MOHNXJpA3Ehr?=
 =?us-ascii?Q?c5S6QMhxRNRFCtkBQFbnUupmIPcYdse/5HvMdDojXmUSb2dCqWnB1sDB06MS?=
 =?us-ascii?Q?+1r50LtZRNd+i/mZ0lWUoKJOjBEJJvO16Zq+z2E/5S+5+fHVFpIPLEePnRzY?=
 =?us-ascii?Q?/afcBYs2j2617JStowOkbQ0XVSK7nXZ5b0NgQAlnRgeorwZeXzED63mutZko?=
 =?us-ascii?Q?gfkkL4xz29Uik9UnUYonhgjK6ZF0h2ZNhG0fRWB6RFu4dPNa8c6/TQaGSBZ5?=
 =?us-ascii?Q?Aiw9Q1X805JM7De2P2jla8eUh0lTBLi52GckGHsKjfkUuxm6JorNUprtNG9o?=
 =?us-ascii?Q?dsvzzHtVGXSER+J2VvYV6gx82IGC1YIVUSQzO3Ge6lAKC2UVqQVgObd5TJLb?=
 =?us-ascii?Q?DVEX8YtjQ9r1p7UhGJfAqP/FnxfsmawfdOalLbvqv6aEy5pC4oWxGUVN33BS?=
 =?us-ascii?Q?rCIuqaBzC/a3o1sW9q+RiGbNYPoif4zeW24CyxXIlaKQUj78OqruLo8keK3c?=
 =?us-ascii?Q?JNaZeu8N7FzkU8FuLEaO9WXzLFhXB2OZPZ17voWFqH3gNX/nTzhZSHYx7IcO?=
 =?us-ascii?Q?sGy/M3JmorPrJoTJHXrgrrM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C3B2E12180385E48B702C9403BACE419@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1efd59d-c5a1-4203-9a0c-08db73fbc1bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2023 15:08:52.7389
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ylj08bGCD06wKwc+L8By4j1N5hNGQFKonf3922JKT9gaCcaz1x/U5eAC/YpIDLk/EbuEURniikCSFSgTuHCW3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB5286
X-Proofpoint-ORIG-GUID: Lnp8oMELYjdXor9-7vPLh9uz3VLVDWYc
X-Proofpoint-GUID: Lnp8oMELYjdXor9-7vPLh9uz3VLVDWYc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-23_08,2023-06-22_02,2023-05-22_02
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens, 

I am so sorry for this problem. 

> On Jun 23, 2023, at 7:12 AM, Jens Axboe <axboe@kernel.dk> wrote:
> 
> On 6/22/23 11:48?PM, Song Liu wrote:
>> Hi Jens, 
>> 
>> Please consider pulling the following changes for md-next on top of your
>> for-6.5/block branch. The major changes are:
>> 
>> 1. Deprecate bitmap file support, by Christoph Hellwig;
>> 2. Fix deadlock with md sync thread, by Yu Kuai;
>> 3. Refactor md io accounting, by Yu Kuai.
> 
> This is quite a lot on the day that I prepare pull requests for the
> merge window... I've said this many times before, but just to state this
> in completeness, maybe it'll benefit others too:
> 
> 1) Major changes for the next release should be sent to me _at least_ 1
>   week prior to the merge window opening. That way it gets some decent
>   soak time in linux-next before heading upstream.

I am aware of the rule. A couple reasons caused a late PR this time:

1. Set #1 and set #3 are relatively new, especially set #3, which was
   first sent earlier this week. Set #2 is older, but there was more
   discussions on it until recently. (It is still my fault not pushing
   on set #2 sooner). 

2. I wasn't very sure whether there will be a rc8. The announcement for
   rc7 didn't state it clearly. (Shall I assume there is no rc8 unless
   Linus states it clearly?)

3. I was hoping to group more patches into one PR. I guess this was the 
   biggest mistake, especially when it is close to the merge window.

> 2) Minor fixes, either for major pulls that already went into my next
>   branch or just fixes in general, can be sent anytime and I'll shove
>   them into the appropriate branch.
> 
> When bigger stuff gets sent this late, then I have two choices: reject
> them and tell you to send it in for the next version, or setup a new
> branch just for this so I can send it to Linus in a later pull in the
> merge window. Neither of those two options are great - the first one
> delays you by a release, the second one creates more churn and hassle
> for me.

I will prepare another PR with just fixes. 

Christoph, 

Please let me know if you need set #1 (deprecate file bitmap) to 
unblock other work. Otherwise, we will delay it until 6.6. 

Thanks,
Song
