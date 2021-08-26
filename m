Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E1FAC432BE
	for <linux-raid@archiver.kernel.org>; Thu, 26 Aug 2021 15:35:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BFC260F25
	for <linux-raid@archiver.kernel.org>; Thu, 26 Aug 2021 15:35:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242947AbhHZPf7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 26 Aug 2021 11:35:59 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47066 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237807AbhHZPf6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Thu, 26 Aug 2021 11:35:58 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 17QFUOnO014897
        for <linux-raid@vger.kernel.org>; Thu, 26 Aug 2021 08:35:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=mZGZ+iPgPNcvaOB3A98QLklrGWrRfJL0+DK7oDd6ZW8=;
 b=eOnCwJD1BRJgpZtBJKRcJ7hSQonRmCHQ4z3/H04+PHvVnhHph2+I35loi8jeZ5eZ71z8
 1JZyALZiClTtMZ/9IF5v/BDUYKYEmfxs0Ayoi4/y/6as7ZqQbqkK5fbn3V4tOUeIdEyF
 GuESi0NNX2aQK8UuNiAtldkMAPy5KiiairQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 3apaepsd55-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-raid@vger.kernel.org>; Thu, 26 Aug 2021 08:35:10 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 26 Aug 2021 08:35:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZTEuQv+GlRGuqqK7/nX0C8J+wlUDC9DyukKms/YvmxukrlhT7LrsaKGY08GuDO31sWWSYXLYuKRivCJi03o/aGJUpeVjdIhg4tMMp1jbdWyuRUGV4pRzYrjVmt0V9ofEqXy7P7ilwEVBTrg93ntp23dv5iQ+fIrPL9Odnp7dGM1OgRyR9692pG03cOD26RdpyCYFqN20xqtMPn1ByJ9HKaKh2d0K/xlEUgsL3x3sEGouxUcvezB8s/Pwdudk7xcznrrcyXvYrJNCZrME5pKoTljJmmmBpJydiJJVMJYPiUHYAZxiF9ITMDCnLC5vL3M+efDOKyFIqHayzQkzhQU2sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mZGZ+iPgPNcvaOB3A98QLklrGWrRfJL0+DK7oDd6ZW8=;
 b=Wr+T6LIJbIzkYeMUPPJWe+Sy+wHxZxT6zFD5WW23qfDnSYfdBagCM9I+5FtJ7lhBJnYR7ZxQWUGzbd/mMZ9u/5WYJKpPmcHoDVzbtcgJCARxP+9S4alMMOAFZdCKVyQ90u0umm010MIL9pfQvyY+pfj1LnIxUnrBPwSmxGo5CxxpVBQEZxQ6YWg/m1BS4HbFcOvllAyfHaBESeTgWuCVwget7TJvI+YiBVD8VbAypqoPwZny54o/kNLaZ91YXa0SGdBKSVWYUNk4z7LVtzJoBaoFCGjw3ICFdWfy3Wa8CQ3PNlD4HsBQBAlIu9y6lVM1I0jWNOnhj/MMZbLdzHcDrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5062.namprd15.prod.outlook.com (2603:10b6:806:1dd::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.21; Thu, 26 Aug
 2021 15:35:08 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::1959:3036:1185:a610]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::1959:3036:1185:a610%4]) with mapi id 15.20.4436.025; Thu, 26 Aug 2021
 15:35:08 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jens Axboe <axboe@kernel.dk>
CC:     linux-raid <linux-raid@vger.kernel.org>, Xiao Ni <xni@redhat.com>
Subject: Re: [GIT PULL] md-fixes 20210825
Thread-Topic: [GIT PULL] md-fixes 20210825
Thread-Index: AQHXmhdMWGCkW/niY06dQWmiEKOiTquF2MeAgAAS74A=
Date:   Thu, 26 Aug 2021 15:35:08 +0000
Message-ID: <10DDB1FD-1E07-4F07-AA72-D82E818CA5B4@fb.com>
References: <9E359DE1-AFC6-4D46-97C3-C8490D051B6E@fb.com>
 <167d18b5-f3bd-30fe-62b3-dd2b128739fb@kernel.dk>
In-Reply-To: <167d18b5-f3bd-30fe-62b3-dd2b128739fb@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=fb.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1deadba5-62e7-4754-2314-08d968a715ac
x-ms-traffictypediagnostic: SA1PR15MB5062:
x-microsoft-antispam-prvs: <SA1PR15MB5062FA354ADB48905EB6845DB3C79@SA1PR15MB5062.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bS9uTR+NMP8zJ9eY4DQfHjm/sYSU5r7YG3WPZv1n9hTu8/QvrIuQ15GnILkihGQKbUlvB9wCTuuksHh8fKOF7j4f6VFnSG8DAkLwm35zDTMT8RCKn60ym46pexBKJcjEyXLWEu12WF4f/7wTCCfn7DvbZM2Vz/7F9i3ghH/iV4VXhIH9s8L10aum7xz0oB5xQn7TV6CWaIKTrPv88Tn23xdYSGDXo8gpYQo5mcXZeeiJD/pA9Rdh1pmKq95ki5TZg2nqjCe6A7LHfJDxsBlanoa8dOLjSvwCNYKD6HGU/idex2O3rZZ6+x/t8eWe3Tntuv2eoO4naD/3Ce2yDTpIiIvY/rdk1RzO3iPFGPNjFfnsmWomTKzuG3BxbZvlVEUIc4e6PS4rphs/0q0uP7zwK/yFKtp6UEogWFhSF645hEZVycbLOUAGDMhRVgCImvFszZD5MDtqZuoX4LTiZDKvY8ZHHuN/4QI+WS9HvAyhBqqV3h8tFudjLzRXkpqSvvakGsndGw9uFShkxpyayIGE0tnrNLroTcVL8um1HOls2Bg1cVS14Kpi+CUexqN2lcjzr3r+e3rtn+xjcgSdK2gIBfRfksZhMQXquOO02mbZoWF3dMXb49OPTKYU92MnbIT53yTZqRdD2E257snXckwbaPE5HLnu85vKU8FATDQaTMy1cHxkoBUBu04rVN+0lrkfMid3nxUbmGxRXpFUQm9Hg/p685vXVLqOSCNNDwaA+SWTLp3nt6CPcon1Jj/cMCEr
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(376002)(366004)(396003)(346002)(54906003)(91956017)(4326008)(76116006)(6506007)(36756003)(122000001)(6916009)(6486002)(6512007)(4744005)(53546011)(186003)(38070700005)(38100700002)(66476007)(71200400001)(66946007)(66446008)(64756008)(66556008)(33656002)(478600001)(8676002)(316002)(8936002)(2906002)(83380400001)(5660300002)(2616005)(86362001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?r6DlFEeNymMtNm8uCXqntSgvsEJ/AVo2u/XOTsR6s567aPagUOsoQ0UjvDAH?=
 =?us-ascii?Q?L5l1qH31k8l9JSmKjr3zbJX9HgIvAW4iwgooy2MSR3WdfDpsg3KEtmgW3Q0n?=
 =?us-ascii?Q?fBgNksbofH3tIFHPHgCDJZ2I19dntHcLg92/BCoPWFOZTb9S3JhUIXQJWBVi?=
 =?us-ascii?Q?R6gV+x4ZphDE8K84eR0alaLJ4ydxnsyDPU5ouE+8Bh+Fty6Em54zknQLHhR7?=
 =?us-ascii?Q?32ThGL4bvwD6o6Jp2GKFy7BITRijdgPC9MUdBj4xAFzJEqqyvSZ4/ONsgTxk?=
 =?us-ascii?Q?JYihwQY3Rpm0DrDybL9V7B+abSZRDvkpIlr1oZcziEar1toPgAc3GMtkrUv8?=
 =?us-ascii?Q?WMRrreINJPJEjasxN7se2BXlwwp34DRy7bRo18hgbrdX8BF0yrq8NZwUXAzb?=
 =?us-ascii?Q?hr0kUQahYT4efJ0Aihf7v2/cLAbBkArIoU3Ab9eQtRWg6CXNgZL0rVIRyOUs?=
 =?us-ascii?Q?TgcWBmsaLd3ENubnqquM1JxJo/gewSWmIPT9vbT+glQMWyCb1VFfRxJ6Qk5g?=
 =?us-ascii?Q?O7qWdoFDyJfrW5BIwesxGRCPYYZqM8PHP1Z0A+CCWK9Rknztk+md2fEnqQtM?=
 =?us-ascii?Q?hdq+6Ui2ICCfGCrOP7lo92ALHBK4RqJxnJQWCHtnA6eUeBAP8TODYm3Nnnd7?=
 =?us-ascii?Q?97bxTskVDhnH7eEjZhjopAKKxmspSUPZQMXPjq32is9S+x1nj1tuipS75rKz?=
 =?us-ascii?Q?eSYvzQWoGCS5FwQY/U6A0jQgD1PxY2F5/cZtC/7v6MydtUYub4g5ThOophUT?=
 =?us-ascii?Q?MDqq6qfRofN/J2S8Nz7ESoZdyrdD7bnBI0UA7RwS9uWSXa52HClx6JLDlc/M?=
 =?us-ascii?Q?ZlgW9w1ZCgC1e/n189wXcAmiJUiMna7YzllayLHcYzhTMpL+Gjo5cTq/iyo1?=
 =?us-ascii?Q?jhivtzeR2WKHXJ6EfFfD+ZF/bLW5JyNBq4Iux9GKwYweb8NnLS1SdfZtTi+K?=
 =?us-ascii?Q?n7Rpob/jkwDA+MUAFs5qHun/2s+0cV/hGMjOVfdfZjCDE0qOlkwv7RM5MCwW?=
 =?us-ascii?Q?aHT4WP71No9O9E6UyO+/D+2J25LFo4EnJYDOyBPPPG788aTg7YYvdwsJ9ulj?=
 =?us-ascii?Q?GQV52mybDUjGgw4RHQfxRqFuamwZIQibzTJoZuZBUSIYM0dPnkPBrHMNd6FD?=
 =?us-ascii?Q?oeBfkZhhCNQWPgfuNY0TKXERS/ZD8BMOQu/o8zo5IvQU4ZhW2hJeu4JGDQu4?=
 =?us-ascii?Q?AX+QSAzDxwkKD9baew+mbCbSA6YhQeZI+QGETIvdZnnc3vlW42nyvBB2n6eT?=
 =?us-ascii?Q?jq5TgB+kzYDLa9B6k4HlwXvbS7DYQxfeR8NCIL05bmWSIwUODzI0i8/R80h/?=
 =?us-ascii?Q?eQDeDdAtPnk6FzLxDaIIcZweNYNIIrhHW7/1BKsTbdkiqoBa+fWeqlSLkr1I?=
 =?us-ascii?Q?b1LA95s=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A0E68DCAE7838640B1F6D58644BF96D1@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1deadba5-62e7-4754-2314-08d968a715ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2021 15:35:08.0562
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 10aKL2lWGPSgFsZQjGlfYgqHihKtNbJcwcX4LdYyqxUzGuc6VdMfxM67aQxcVt4PqQaoAD6yfYdeXT9XTVWLgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5062
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: z7GtugjqUPAXtT6MTExgaMioJIJEjPin
X-Proofpoint-GUID: z7GtugjqUPAXtT6MTExgaMioJIJEjPin
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-26_04:2021-08-26,2021-08-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 mlxscore=0
 suspectscore=0 clxscore=1015 priorityscore=1501 spamscore=0 bulkscore=0
 malwarescore=0 impostorscore=0 phishscore=0 mlxlogscore=929
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108260088
X-FB-Internal: deliver
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> On Aug 26, 2021, at 7:27 AM, Jens Axboe <axboe@kernel.dk> wrote:
> 
> On 8/25/21 7:11 PM, Song Liu wrote:
>> Hi Jens, 
>> 
>> Please consider pulling the following fix for raid10 on top of your
>> block-5.14 branch. 
> 
> Since 5.14 is days from release and this doesn't look like a super
> critical thing that needs fixing (not something that was introduced in
> this merge window), let's do it for 5.15 instead

Yeah, this is a better idea. 

Thanks,
Song
