Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF9D0C433F5
	for <linux-raid@archiver.kernel.org>; Tue, 12 Oct 2021 08:22:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBC68608FE
	for <linux-raid@archiver.kernel.org>; Tue, 12 Oct 2021 08:22:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234713AbhJLIYo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 12 Oct 2021 04:24:44 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:38170 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234501AbhJLIYm (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Tue, 12 Oct 2021 04:24:42 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19C4m6AB002822
        for <linux-raid@vger.kernel.org>; Tue, 12 Oct 2021 01:22:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=B9QpfT93vDtc1WJOeBk3Tf4EqcYcexz6Ls+XCXTDrec=;
 b=G3AvVha/BZZbNdw+xo9EMWXIiw0/WV+WqbtQDaFJBjmE10JKI5cLQdpjItp0k4lbMauU
 jp/C0tX5C3z9elll+rWWejVgtOFtGlNdypfpZpUAcJ+5tXpDv0TIehteCU3ND13Qfi1O
 uF0WptCAdxbUA7oEg/tTbLrrGuLgWaHDsDo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3bn3n990dg-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-raid@vger.kernel.org>; Tue, 12 Oct 2021 01:22:41 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Tue, 12 Oct 2021 01:22:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BEO3JgCsmuZhqrNPSLRQxyaMAaQCR+FZQQd+YMpqYxQ0h84zRNjuRCcmNPi0uMs15qqe8usZLkn7gtshZGN+V02jM4UpV7jI4/1UIRbEl9IJDqYepnUXkffVeFJ/DozoJS9EW2VC1DwkkBpDZK8sKQj1GOBhCLuUz5e+cBlTswFlMpoHOewPUjkG4Lxtn1MFWd5UrJqUtT+6Qmarrbqe/npW6ZSkYRfZuvibdnMQZxv8iCJXekBK4F5TiYobIPBx/DiOZ0Pn03ipsKPXYpQgMpQDZ+NLxPOT7s+2YsGJ0wYIJ6QzEfc//RMTyaKPq3QtVe9zxZMbyFXP5GT3pFqKmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B9QpfT93vDtc1WJOeBk3Tf4EqcYcexz6Ls+XCXTDrec=;
 b=T9Rd2PEEO4u04bV9E39Oz6Glx/MGReQoG7GAXf2mBJodsT2sLsMFoOiLqz9nTJAWjwA4c9YKUmVNlFd89rww7I+Ix6GTEwaQ1kdIxNS08nY2d713stoF4SuzItyJDmrtnXc9Bs24rIXkDP5/SSca1cqPvQ1p5d0/dN4SPk7BNUjOn4MuYky+JLAYJ1oaFbJsFJ7bJBrq0DJk4XQXlvBxoxh9X3S5KAkM8JE8++lmPfRASW4N04U+bZQRMnX7VAmqm3yaOVq1R0ytffSxK2SUKdhtZw6Db4u263JCrdbtuLmKJ4BoCoM8fsgucT+WCNvnAwGgE6+XaeXxbgBssNGtSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5096.namprd15.prod.outlook.com (2603:10b6:806:1df::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Tue, 12 Oct
 2021 08:22:39 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7d66:9b36:b482:af0f]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7d66:9b36:b482:af0f%8]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 08:22:38 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
CC:     Christoph Hellwig <hch@lst.de>, Guoqing Jiang <jgq516@gmail.com>,
        "Luis Chamberlain" <mcgrof@kernel.org>, Li Feng <fengli@smartx.com>
Subject: Re: [GIT PULL] md-next 20211008
Thread-Topic: [GIT PULL] md-next 20211008
Thread-Index: AQHXvKA9HKmmU1tJ4UKsjQS9W9Cw5avPC2CA
Date:   Tue, 12 Oct 2021 08:22:38 +0000
Message-ID: <6AF487F1-2217-4E5A-9327-61FC2871C640@fb.com>
References: <3ACD8384-A1C0-47B1-BF6E-CFB9600370D1@fb.com>
In-Reply-To: <3ACD8384-A1C0-47B1-BF6E-CFB9600370D1@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=fb.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7bd17538-df72-4423-f0b5-08d98d597420
x-ms-traffictypediagnostic: SA1PR15MB5096:
x-microsoft-antispam-prvs: <SA1PR15MB5096D32BBC69FDC00CBD5D1BB3B69@SA1PR15MB5096.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3MsIB9ng4UtWEbkSN4x+6sazvVRllfBFa9WIinaYpm8tHkw/tlja0WyOQQoQJzUCN5A+l3qmBFW/QYNdKNaX0XmCkQNjE/QpvjrIlPfFBxDysGG9CyClqGlrbi7O/LkqyCXMtFE16Qw32cphr3gtT5n8T/EeIndf0a82Gphyl8ZnOOEFR56NYoKDtOR6UvmVpST6oSkpTc7Ys0y0PxunYUn5NMAcFI7LWAZCHyAS4C5Bq2KdmWBYdzek2EFF0oKzo3D/bWDDsd1DNMSpwLdt8nTan8oGj6k65CAt0K77tjJ4sLb/ltXmcs92tIsrfCzcMMOwBqIxA8zBMstM0kFv+97cxhf3y19wWM58af2bKH5B96ges5cXbpnpN31cayom1s/9mwmYaNWOjqbYoglSvJV+t3E0BLk4+g184l/sv9uL8/egYZ5DTrRJy3gih3kLyUKwwbSmMbGVzaXthwciC8HReXqS0O6vOMPxtdgIMLDvIPm2gfbeTSyuGOppgc9duFPh1lvwws/s/X+f7L/yGQU8wtmxE1th3AWNmbNlaqHg6ro9GiMoOfg9kThaU1nxSCn2QZ9EpryOQ2jfvXG45Htgw1ITMrfnjWV6NjC3+oq8C/FTljod5AbVOIh4nk32QyrM6OAHTaINszfUwDpnImrTbISbNulKWsamBejDFW6UAX4Qce6S214PAc6xFvbtP0khf2L2LmoOj7SoxbB6I/32fXFwWPPam2ofHZVm7c6kl3wpx+yBv7+0qjbRLTIL
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(8676002)(6486002)(66556008)(4326008)(76116006)(86362001)(186003)(8936002)(71200400001)(91956017)(36756003)(66446008)(66476007)(53546011)(508600001)(66946007)(38070700005)(110136005)(83380400001)(122000001)(64756008)(6512007)(2616005)(38100700002)(4744005)(316002)(33656002)(54906003)(5660300002)(2906002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?zS/Fw0bi3M6f2Ll9pPijTQQE/gXAAGkSKSahpDR4a/kybEoo4brNds0aP5UB?=
 =?us-ascii?Q?706gPBbhGCfx3KYJIPdGKr22shGbDEJClAvdL3UIs0qs9ZdttBRU6d4PGWqn?=
 =?us-ascii?Q?Llyr5WzuqxdECo8OvTACBSf9XjFxQKdrOY30KoYr5sqo8Bk+2hql8oq7B7U+?=
 =?us-ascii?Q?QNgOiavrWKifaUM2eRT8auck46bLNoXl7VJq4FedJEUJJLOLTLNTilGKMBbs?=
 =?us-ascii?Q?wogDu9PXQ6QIw7hE5nwhZfjp5SRF7QUXtf/3bxvSpU1pHfeYVvqXDM6441KU?=
 =?us-ascii?Q?AeN6cWRrNMJE4bhvUnbRgHdUjDNKFHmSNkSHw9L6pl0jjDUoChRibqSTkkZf?=
 =?us-ascii?Q?NRh92mLrowrxpMHj23W68HFcyKXa46Yo2CknfPnzEh8oCj4eaSnZvosKnfij?=
 =?us-ascii?Q?8gNbNxALoaptzgBYDoMIiggWUTy+DDxzXyOmPMpaUU+fTVgN69s/gNCg84e8?=
 =?us-ascii?Q?A6N3OPEqvlvI6jDiBZdGTkFxC+etbUQnwZGvo4vEfzc9ZKguv9cFY6iM9LX7?=
 =?us-ascii?Q?ip1ml2aXCMTE48DM4uqWiE0dlLWAl5t23ebUO1SSHgcOw55J7Udl88dyhibc?=
 =?us-ascii?Q?QdunAWZ9W+6YuQczRY2pQ9+cZh0OtsRgVYYvHtawteQvVIewR4QcR4Pfrt55?=
 =?us-ascii?Q?Fj6s6PcFFXV2LbGI4IDVySR9roU3FgIHryP2KIil9Zq25N6jzjR4dWir+1Mq?=
 =?us-ascii?Q?anhKgPilTvCdLcw2mcXjZVTcrnFWJ3kIjX0GT/BsR20tC+eGFmLxXPYhfz0m?=
 =?us-ascii?Q?OM/dcQh/QKcpbOt3qFNyDur2GK28FKtDj5M3aVS8wLeLxk8DiAmZgKutjWX1?=
 =?us-ascii?Q?9a/YxiwveA1FKi481xwWtsfcogXZgCSO5ng+sSwZR0SKfsYFnvRL0t+Ky65s?=
 =?us-ascii?Q?S663n1xuezL8AdUdL8+OhrBgCBrMnVOmDf9UZsZ/7t8iLrtYUiVoeiPP+2XK?=
 =?us-ascii?Q?6RryJzT0++u55TPkfSfQpR5V8RND1RGqnMacAchz5mbjTr9oMF1P4Wh3hMcX?=
 =?us-ascii?Q?o88+E1CyYZKlT63ZBiKktNA9AXitB5uiPjt5o/hD9HWKNuFIJM1fz/zh4MIw?=
 =?us-ascii?Q?YI5fk5GxZ0gIccutXbK6JhUM/Fh9Yu7mrwo8Xlf1tBtAMR2BNWyJv76d3NSM?=
 =?us-ascii?Q?YPK0YKyU0bwaNoEd7iE05C/O4cFvuWJe9J77hCfUbau5oKf85Q/u0RprDsL9?=
 =?us-ascii?Q?Hg+l6/nkwzBFksT6rnzEGqWVqhuTCsVpgDqLh+posMtBUbvm4mLKbdiBEZlP?=
 =?us-ascii?Q?zvRP5JDGX8xuGmQ21xdrfCZhupWat14MsJU0T8rXk+7uNbHOdtIieZMQjp8V?=
 =?us-ascii?Q?YrOFc+dR6rt/nP76ke9EDqOwzKtJjtx4FwtDZx56o43H62AJbfycqsF+1mxZ?=
 =?us-ascii?Q?6WhF6T0=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D0A7E65F2567E24BBDD629CF734C62E2@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bd17538-df72-4423-f0b5-08d98d597420
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2021 08:22:38.7795
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Cvfo822CIdwJ67dgdMEOo/p8H+X+wE7OhvLYe19kWm34M9Kb+YoBWfYOegm67phKNZ8KMbkx/Ugcaf91y2EKlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5096
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: tnjcHWBIuqJ-GT0u4LDlVMybyorAdGA0
X-Proofpoint-ORIG-GUID: tnjcHWBIuqJ-GT0u4LDlVMybyorAdGA0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-12_01,2021-10-11_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 suspectscore=0 spamscore=0 malwarescore=0 phishscore=0 adultscore=0
 mlxlogscore=812 mlxscore=0 bulkscore=0 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110120046
X-FB-Internal: deliver
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens,

> On Oct 8, 2021, at 4:57 PM, Song Liu <songliubraving@fb.com> wrote:
> 
> Hi Jens, 
> 
> Please consider pulling the following changes for md-next on top of your
> for-5.16/drivers branch. The major changes are:
> 
> 1. add_disk() error handling, by Luis Chamberlain;
> 2. locking/unwind improvement in md_alloc, by Christoph Hellwig;
> 3. fail_fast sysfs entry, by Li Feng;
> 4. various clean-ups and small fixes, by Guoqing Jiang.

Please hold on with this. We may not need the new sysfs entry. I will 
get it sorted out soon. 

Thanks,
Song

