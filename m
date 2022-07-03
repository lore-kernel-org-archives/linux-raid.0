Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAEF7C433EF
	for <linux-raid@archiver.kernel.org>; Sun,  3 Jul 2022 23:49:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbiGCXtp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 3 Jul 2022 19:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232313AbiGCXto (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 3 Jul 2022 19:49:44 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D66AA1CB
        for <linux-raid@vger.kernel.org>; Sun,  3 Jul 2022 16:49:43 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 263MEAVj029779
        for <linux-raid@vger.kernel.org>; Sun, 3 Jul 2022 16:49:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=MPKsEpZokkaLxSXIx/XW9a7NwkP84gMhp6/2iiHht3Y=;
 b=YHc5nMD2P4zOlrmgfnizpzlqvcyJ4JAOJyoLrcQxsawiL4Z6NlpOFeA0TvUSMdtanYNI
 N6OjfmTb0cJnBuKKxu7s14n6ploS1b1IKA0kE2MTT/1v7DudI/3nMlEO+5URZlv0e8kG
 EdvWRQ1zppn9+lOopRLTDmZ43capK0at1Gw= 
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2049.outbound.protection.outlook.com [104.47.51.49])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3h2kj06w2r-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-raid@vger.kernel.org>; Sun, 03 Jul 2022 16:49:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F5tdkwRsuZEURCgoxUvfGG0dnsHWMcSQglfuTfcwE5Dj2ZTlK9e+w4qjYNvGlkELNTCSz3zU8LsjRHAlmHYrUW/aV/QRRpHEWziov2L/i1j/VVXIuws9jkG0FasynpjHxxyNjNDaTa6h3ncvoixorrN4KS0TKZ7Y1mBGfC0P85G89V3aKClb5hBtDgpHn6mqZ+ksnHb9/hv62VtCwlDip9ftaJ6bpC8qxXR2mmDKONcgVB670pPiH4Kb56hcimRGPHxUgPwgcM6JjkWRCOBC1oP1Mf+7Fe54RDfY1GeSSFT06XMU3dYVRRqBUFFHYvrRoll5bKYZ2hlXJoa2nmuVWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MPKsEpZokkaLxSXIx/XW9a7NwkP84gMhp6/2iiHht3Y=;
 b=FYO5EYnMa+EXYrN3hVb0haNLz1N2CeCNFDebGTYdv5Xxalgt7FGCRYkjvXnhJCvN1wdGcRqMHA0VW01zsPb/vA2Ni90vI8bFziFmm5xwtR9+36OFxTXcTn2haG+dWIkO/PRfx+lg4Md7EXW0Jtph+SDVOQK1JrtFjQ0B3ZS5fzcd46XVqGTWLxW0MXeQ5vspDfmdHjTpkzXmkOutM06FEw4GiG/it6b3G158KEH3jTFYN0fEaSE1tdHQGTSb+aoZzKLnEdpWSG7VkRAIg9REbnAXAhvydsEtrm8w7ubFZdeIUN7KaKiHZESzMMbkRQRwG5iL5d7Vvgh7ndcACU1IGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by DM6PR15MB3814.namprd15.prod.outlook.com (2603:10b6:5:2bb::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.20; Sun, 3 Jul
 2022 23:49:40 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::e8cd:89e9:95b6:e19a]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::e8cd:89e9:95b6:e19a%8]) with mapi id 15.20.5395.020; Sun, 3 Jul 2022
 23:49:40 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jens Axboe <axboe@kernel.dk>
CC:     linux-raid <linux-raid@vger.kernel.org>,
        Logan Gunthorpe <logang@deltatee.com>,
        Guoqing Jiang <jgq516@gmail.com>,
        Chris Webb <chris@arachsys.com>,
        Zhang Jiaming <jiaming@nfschina.com>
Subject: Re: [GIT PULL] md-next 20220703
Thread-Topic: [GIT PULL] md-next 20220703
Thread-Index: AQHYju99fHO0MZOPsEuXF5weQ7qpfq1szpgAgAAFBICAAH2igA==
Date:   Sun, 3 Jul 2022 23:49:40 +0000
Message-ID: <E5976072-2F61-4B96-98D0-FADE94F96B5F@fb.com>
References: <9727B564-F3B3-4CB1-A609-01AAD3C193F6@fb.com>
 <d76ca8b8-b827-4928-6286-47a0dbb6de25@kernel.dk>
 <275e61e8-44bc-2247-41c0-730d0e0f3bab@kernel.dk>
In-Reply-To: <275e61e8-44bc-2247-41c0-730d0e0f3bab@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6d500e2b-62b3-43aa-7320-08da5d4eb207
x-ms-traffictypediagnostic: DM6PR15MB3814:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yUr4BUEw9C+gmtn0q4W0aEaR7uzJYd3LDx1B6pNBX4yG/uqa1q4q3O/TeV/7GA8H3cxVjfZS4miLiInfMF97k4sBUUQyG9rlrSVhwg36tq/FCwfLjcExuGl6YLOjCY2uCvGCD7DVHrOxU5Bsi53Mp9MlxbnEwpGBaCG3RKeZTEUoTst5DKHTJG0T2iB85LtlT7fJZsgZCpQDvaW5LFneXlJ2RrVnWpQykjaMQNlR6sUwpAgVxNolz9sBIveVgfrBbX33K+xx1NJLQg4BADXhUezUnS2nxgtC8KxOn50mJ0X0DiSaNvjM6ArHtStVZRXASJI0UCmlGJlP2x3JXBCQ2I7ttZBYTFkqt5b+D/nG0M84dmFAUBc5AifIjtYKjQ2auNQGZ19Smgg4Z7JMPDieeabMComDd3BqkdcViMdHOQ4/+cLrXkTUvgTxqP+Yc+IgWUC8WH8QL1vp/580YYfanwWVtFV8R8Tf6KcnwM2aD6+pOyEbtpGczf3ryBg6PaDoV29nIkfGJTznD0Oiw/yUxzbq2LjliXnK1xOxSIjRdndgdmdUiGUw8RKbTPH/jBr+Pw6Tse44a9TdZVI4KZZQj3eGtOmWmON937GyYoBdX13PN4axHSvETrW20ZWu8nSzbU34DDBTZtV9SuuL3yQfQCSdAkZASSmX1dgIw8jxK0Trjy3gDVttHpEKEDUOaYO8RG1FSYNUiIc975BafvIxGFGt3+1U0bJXt0fzfAv6WbZTTD6iYB3f2PDGnztvKLT5AWMX8w7t1WfxcIKNA/xuh3iuJo2BdPbUR8VS2JhSdaitVFExbZdhfo3kjJ328ReqQ77ipr0tYXm+7otK9pJdmmfVGGrXSyafTYYQz9FaUxQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(376002)(346002)(396003)(39860400002)(136003)(5660300002)(6512007)(2616005)(86362001)(478600001)(8936002)(6506007)(53546011)(33656002)(41300700001)(2906002)(38100700002)(38070700005)(122000001)(66446008)(83380400001)(186003)(66556008)(54906003)(6916009)(71200400001)(36756003)(76116006)(66946007)(4326008)(316002)(66476007)(64756008)(8676002)(6486002)(91956017)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DUtNmG+IbuWkWUUWAGEXuVkvYj2X3DTw5W0HTOIIuMmEAe85qp+lkKUIpmGC?=
 =?us-ascii?Q?IOhIBdk8HMnBon0b5B1DRvh6Zsp4b5GLsmS53Hj6Lg1ihAWwFMOnInKsGDtg?=
 =?us-ascii?Q?AhtuqF2qf8pF7GqRqdnpTY2Dql6wMeKTYDJ+HuY5+625DgIfkWlO/USi3zUd?=
 =?us-ascii?Q?ZsxmEIr1VT55rXvXphkCYQgFcY8qtRHGIOFNB8r4TetWNiCgYAF9/mAbaXey?=
 =?us-ascii?Q?PoprRZnZNnImDsUspwiBPqs8rrV8Cm6n+Ch63pPVV8Bl3wsqfkav2QqAur4U?=
 =?us-ascii?Q?/yvKSrawIuK8DWd9r6MbkCMYrxFfSJ3b1Cy8ckx/ji04YUNKzjcqKmHzE+7h?=
 =?us-ascii?Q?/D2C9zxK53FG6EH9G/poKO8mM4hcuEvLrogjg8hbJvF5jY2m4oy59+PFCzJB?=
 =?us-ascii?Q?m1pSuLWEa7ZMpG3JdDSGIclAUm1v94O0F1CJWqaxmYnzEXDEA9ZrK4jA4b2m?=
 =?us-ascii?Q?2k8uC4S9V10aZ5xzFNlbfjQkqE4Qaj9otBWVpdhj8bwLMXt7V8wNrejAr6nM?=
 =?us-ascii?Q?prqZ8b3RdXJZ9R0fMqzmBilxzpPa3sEiQ951kn1r18s2sREfm9Y+TuzabGY+?=
 =?us-ascii?Q?VVeiSStQGDLCoAYVw4m6kbm4jyt93/nspTTzJJgTQgy8GzUl5ud1nQmQe/mO?=
 =?us-ascii?Q?uDzPpwO0Dk3s9EnEiMSP/JNO1Nk60O+37WOYSLibTly8tSikAW0vNffUS+TK?=
 =?us-ascii?Q?gALrXUHUqvLXgrydkSb7MsyV7RSPHlWbg8u7xFwVxt0yoafRUvB0N0+n1yk+?=
 =?us-ascii?Q?jGBVjdQ/68v4U3iGbbjOT0SuwZMJrYB0/TpwumStHRJq50WZmvIr1L/K82yW?=
 =?us-ascii?Q?Mfwc0Ix11fSIOPU4AvvK2Bd6VGnJuP8oTMn1//Ns8LAXwEDqdITxKmzjlQMg?=
 =?us-ascii?Q?y28eLAQrfKLUnpt5UPxK2urDOQYAUa30Nn8GVoPFUaxUIagbeJHKNQ4+Qz8/?=
 =?us-ascii?Q?hzkYgD6oLEHAxu6w54FGUSnzsplcI4jzzm29OYr5OBADG7daMKmJoITTNsrB?=
 =?us-ascii?Q?JShwTlVv3Diivvf+PECgdGOC85HH/Ap4ZUaAEvlYqPMsakAnwx8CRo9gAJVI?=
 =?us-ascii?Q?mgjnyp6USfzvcd+GJIcefr/Tgbdlo/Aq7tnPVZDaNzwdamDtJNAccYvpV/np?=
 =?us-ascii?Q?AQybLjwOJSY2BLTZnBWGCefCkszyMTBHbEWtQSDsXpGPfFNOdEGSNIzTc6qd?=
 =?us-ascii?Q?pEmJrlGf9ehKBm+ROzWc3owGJyHPTSvYw/1nkazxVY85LTH4v6pHfpxihEWf?=
 =?us-ascii?Q?S7JkNPqhpNmHiArGZ95cQtFYefw+y/oK6W73Colmygdq8zNUGVm68E8CwymS?=
 =?us-ascii?Q?fa6aG4aLqBGz8Z536rxnxWPJJ25coPaElS2XNbmyWODxF85vFtdbUsIyWaBz?=
 =?us-ascii?Q?syKLePcsfzbNBxo6KveSn5cRGhNBcbI7o5ZZVv21fSJexcs7u3QfA1/Rqtcl?=
 =?us-ascii?Q?UsHOyac1kc23eWYi8veC00I6oFzFY/2PtWx0Qnzr+s43Ea28ThpKnpn8+NAa?=
 =?us-ascii?Q?CLjjPw2SwNN2/Q6XgyfJtLbYiA9OeGU3acPdsoV3FISDAKRE+/wr1hfgS8pi?=
 =?us-ascii?Q?Zy6RqkIFZ2SxNhyrpFSR/qC1OXVT9jKVCrS76o7YUbFBDFM1jp0Zo3T0gtrX?=
 =?us-ascii?Q?zzyqYrELOr961xqRsLCcfDI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F52B825546428A4AA425726994E2C92F@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d500e2b-62b3-43aa-7320-08da5d4eb207
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2022 23:49:40.1538
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: isMDSkuTh6o2uZ7fUVgUrtzdCOkjC+lxa0YKMvHTfw5QOWf9HR1U0/GLn3D1Xi3aCeW1byEGpNFDs6lu9kYlNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3814
X-Proofpoint-ORIG-GUID: P6IRoEYucm9dYuTO_B_dut-fhOALb6sL
X-Proofpoint-GUID: P6IRoEYucm9dYuTO_B_dut-fhOALb6sL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-03_18,2022-06-28_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> On Jul 3, 2022, at 9:19 AM, Jens Axboe <axboe@kernel.dk> wrote:
> 
> On 7/3/22 10:02 AM, Jens Axboe wrote:
>> On 7/3/22 9:13 AM, Song Liu wrote:
>>> Hi Jens, 
>>> 
>>> Please consider pulling the following changes on top of your for-5.20/drivers
>>> branch. The major changes are:
>>> 
>>> 1. Improve raid5 lock contention, by Logan Gunthorpe.
>>> 2. Misc fixes to raid5, by Logan Gunthorpe.
>>> 3. Fix race condition with md_reap_sync_thread(), by Guoqing Jiang.
>>> 
>> 
>> I pulled this in, but what I pulled doesn't match this pull request.
>> There seems to be an extra patch in there, and diffstat doesn't match
>> what is in your email:
>> 
>>> MAINTAINERS                |   1 +
>>> drivers/md/dm-raid.c       |   1 +
>>> drivers/md/md-autodetect.c |   1 +
>>> drivers/md/md-cluster.c    |   4 +-
>>> drivers/md/md.c            |  76 ++++++++++++++++---------
>>> drivers/md/md.h            |  16 ++++++
>>> drivers/md/raid5-cache.c   |  40 +++++++------
>>> drivers/md/raid5-log.h     |  77 ++++++++++++-------------
>>> drivers/md/raid5-ppl.c     |   2 +-
>>> drivers/md/raid5.c         | 646 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------------------------------------------------------------------
>>> 10 files changed, 549 insertions(+), 315 deletions(-)
>> 
>> MAINTAINERS                      |   1 +
>> drivers/block/drbd/drbd_bitmap.c |  49 +++-
>> drivers/md/dm-raid.c             |   1 +
>> drivers/md/md-autodetect.c       |   1 +
>> drivers/md/md-cluster.c          |   4 +-
>> drivers/md/md.c                  |  76 +++--
>> drivers/md/md.h                  |  16 ++
>> drivers/md/raid5-cache.c         |  40 ++-
>> drivers/md/raid5-log.h           |  77 +++--
>> drivers/md/raid5-ppl.c           |   2 +-
>> drivers/md/raid5.c               | 654 +++++++++++++++++++++++++++---------------
>> 11 files changed, 595 insertions(+), 326 deletions(-)
> 
> TUrns out I pulled it into the wrong branch. But even after correcting
> that, I now see:
> 
> MAINTAINERS                |   1 +
> drivers/md/dm-raid.c       |   1 +
> drivers/md/md-autodetect.c |   1 +
> drivers/md/md-cluster.c    |   4 +-
> drivers/md/md.c            |  76 ++++--
> drivers/md/md.h            |  16 ++
> drivers/md/raid5-cache.c   |  40 ++-
> drivers/md/raid5-log.h     |  77 +++---
> drivers/md/raid5-ppl.c     |   2 +-
> drivers/md/raid5.c         | 654 +++++++++++++++++++++++++++++++-----------------
> 10 files changed, 553 insertions(+), 319 deletions(-)
> 
> which is still off, with the discrepancy being in raid5.c?

Hmm... I just pulled your for-5.20/drivers branch again, and I am still getting the 
original diff:

 MAINTAINERS                |   1 +
 drivers/md/dm-raid.c       |   1 +
 drivers/md/md-autodetect.c |   1 +
 drivers/md/md-cluster.c    |   4 +-
 drivers/md/md.c            |  76 ++++++++++++-------
 drivers/md/md.h            |  16 ++++
 drivers/md/raid5-cache.c   |  40 +++++-----
 drivers/md/raid5-log.h     |  77 +++++++++----------
 drivers/md/raid5-ppl.c     |   2 +-
 drivers/md/raid5.c         | 646 ++++++++++++++++++++++++++++++++++++++++++++++++++\
       +++++++++++++++++++++++++++++++++++++++++++++++++++--------------------------\
       ----------------------------
 10 files changed, 549 insertions(+), 315 deletions(-)

Is is because different git versions? My current version is git version 2.30.2. 

Thanks,
Song



