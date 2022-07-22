Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEDFFC43334
	for <linux-raid@archiver.kernel.org>; Fri, 22 Jul 2022 17:01:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232305AbiGVRBi (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 22 Jul 2022 13:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbiGVRBe (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 22 Jul 2022 13:01:34 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C357A18F
        for <linux-raid@vger.kernel.org>; Fri, 22 Jul 2022 10:01:31 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26MGJwFf024024;
        Fri, 22 Jul 2022 17:00:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=eLtN5mTlcMQpee9iP0lIXFmtFQnwk7M3RkecdWdXM/0=;
 b=My6QTig79+Kl8APqATC+eGXMw7QgjOb+ibx09v1O2zbiiVw3x7KjM9oI36/krHp6HImM
 IX8kwcGi55bH6oaZPmGAUSwqQOl0dzMZw/Pf/Y9l5FRnpu2YgQXQi4BmblFlR334ta5n
 zlU2tpPR5F9lCQwj5TUzkrDsUdATY0hA2AbBAmyI4weUUO8F7mzn2wg7WXbUs+WbXHjW
 L10MoRWCpuB2kFJu7uc+zUnCzkqj+yMf9BnMOKYrQdBWXPu+rSjvwoxwpYYPplKwVjWW
 UBu89fZ9q7QqDjAfS3LIVs+Gq279OVqEpt5Nn3hKHO3vzHjn67fN3Q2m/BBEcy5znJKN vw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hbkx182qv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jul 2022 17:00:45 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26MFY9BJ007822;
        Fri, 22 Jul 2022 17:00:44 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2044.outbound.protection.outlook.com [104.47.74.44])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hc1k6shnw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jul 2022 17:00:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g28lppz4CemBIS4NbDAjB0ngXX3OaoV2lLmTSzrEuU994OZD+FFc0l6Tcepgvw6VrU5/J/99/Dhhxq+u+NaXXmcf8sctmVthUiDRfjz3gg8g/GICP6XXuk++tjWFaziZNZn2C56YU9FKRoY7oBakxf4NY0GplMeIE6weVG0udCbcSrbjfi/Ke63OPsDsFJH/HD9DDfBY1LI2vfcECsXhIwuBbGttltmNIpELbvnAeFiwylHa+kKeEROMFMGxkFC23JihtwZeLFmbYZgWJ70FADIlD9RzQELLP4HoM7ZDg0MT6IjO6Ch2xYDyRJpHtrWEXDJBu3kZFkKutITUJx1onA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eLtN5mTlcMQpee9iP0lIXFmtFQnwk7M3RkecdWdXM/0=;
 b=bzQcbabqD4UMJAxBZRgno9z7JJexn8HoPjzzlGDyIVi/9zTvnAbvE08/f1C/NCj4yk1wOQjRgtL+2+YgrQycIGvQJIFA/VWmj5UNWV3cF9RaYYdbpeq5LcPmgbZ8VWLbJIGjJ1p5ZLvF+vCCHFMKqFUPPEhc1ImVPhwvXcmaVzvSOCWBWtnSjGz1BZ8iooGhd944El2wCYyurGVc3VrjavOEc/4RJjDn0cLrQTIbNlFnwldYTypgLAPnjH6davFySg65zP/WQvCiPlU3qK6rkMOakyLlo75zK9QbzwpWP3n5f/Ao92h6IooSJvhEldjRf6fg8h4rzwlqYNE65mrjSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eLtN5mTlcMQpee9iP0lIXFmtFQnwk7M3RkecdWdXM/0=;
 b=REiX74gL749U/ig3slpyIjyU+uV6GjI4bUyNecthxRJB4L48azpYfwypFVnhzHJZ9ksDI8rT1/oKxGAtAUNDekUzM/ap4OsVnwOA6JXfgMN2dSG8W22iS+XtX7LtfL9+6Zhm/0MzXefF4gm3Ozikb/jL76gC8YXts+HanxKQ5o0=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by BYAPR10MB3493.namprd10.prod.outlook.com (2603:10b6:a03:123::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Fri, 22 Jul
 2022 17:00:42 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::a99d:1057:f4ba:a4eb]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::a99d:1057:f4ba:a4eb%3]) with mapi id 15.20.5438.023; Fri, 22 Jul 2022
 17:00:41 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Logan Gunthorpe <logang@deltatee.com>
CC:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        Jes Sorensen <jsorensen@fb.com>, Song Liu <song@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Donald Buczek <buczek@molgen.mpg.de>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>, Bruce Dubbs <bruce.dubbs@gmail.com>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
Subject: Re: [PATCH mdadm v2 00/14] Bug fixes and testing improvments
Thread-Topic: [PATCH mdadm v2 00/14] Bug fixes and testing improvments
Thread-Index: AQHYhnZDGlCZAf8takmUvi7d90dio62KzDmA
Date:   Fri, 22 Jul 2022 17:00:41 +0000
Message-ID: <1561DA98-8681-483F-A14C-FE6877B9DC05@oracle.com>
References: <20220622202519.35905-1-logang@deltatee.com>
In-Reply-To: <20220622202519.35905-1-logang@deltatee.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 05fb128f-605f-4561-58ab-08da6c03b5ef
x-ms-traffictypediagnostic: BYAPR10MB3493:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fcAdZW5Pp7dAVzeDzbCOHRnw1XeqQdxYYIbp/Qgu7cQV2LQZ5nteEVVltQSiKpNzNQDFvv5NhcdkBiUDiMbx+5Qyy2Jverl3xn/glUeYqONNBJ4h8ll/kqcpkbpHfzZ2xZerhZoWLaBbNYFqm9WB7Fv693xxBo+9IbPuYiE5eOaVEVbZQ96mV8Qr7lPivu+5SDDJPQqU0oks58KctZ2w6141XBz5SNaE4eNbqc/0j51YLwEZ4rEYecgoL1/0B/+LxRGBXY4KCk2ieL5clabRunWarX/Zav3Q9UWpnO/cGJPerlro51F131sn8c8O1dymUmtcy4Dj+Pi35wAEAz2tkGDv2wvgWDCDjj9qtCWuQdx0if9dZoUcxUhi8+eoHB2xLLLIXqPO95YT74GcZwkwGb3MCdO1H/x1CKdNY3xKZv/Nn1YHFrzVM41qMYfTuEHyCgYVIDyPHXJ/RC0ElAX4XEYGBrEwDycnHQyAm/t+cGrj19ZfiXIgsNVPec4Ngc8HAYTSre/teWLhAWcv7QTQLF+4Y2IfX9M6xZmsTX6AYU8NjU2d84HlGrgsQYCurCA6AkdamF5EkLEd7SOG+zhi3Z/Bc2+yaHNsSBEoJAdXNbJjKEkrOy02on3JUEp0CYhIdR9inqKZ615lDhPsi12o7vIE3OngcaMVyLLMsQJtgor5/iRnxaoF49jnDt/DxaTTvIfmBPMZmNXUyOqlqDdcrZLZieDW2TT5NNtugJ1QaSHg8guK82kZKuThiIAf8RE++pT63tvPBcgrti6JIdsKfNgPoY+h9Xqf6pOAgoEKrRxis5udVZr60/EEcfk8Gp968G1ANByfQjsk8btJ06r33Ou9d5SFDffYCH7ud75mUCI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(346002)(396003)(366004)(376002)(39860400002)(2906002)(41300700001)(6506007)(966005)(8936002)(64756008)(71200400001)(33656002)(76116006)(66476007)(66446008)(66556008)(86362001)(478600001)(6916009)(91956017)(6486002)(316002)(8676002)(36756003)(6512007)(2616005)(83380400001)(53546011)(38100700002)(54906003)(38070700005)(5660300002)(7416002)(44832011)(4326008)(26005)(186003)(122000001)(66946007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?cHYUSIVxxfOyDvPvJBIpeK8LsyJq5o291YNFwzXIhYKVjgaEXyhXJ6rqfm82?=
 =?us-ascii?Q?wfweUU9kwJbu05Y5cDkfj7ZwTVKsVy8SpJfs+DJo9bJGX+AYm5IXwBn7qw90?=
 =?us-ascii?Q?CG5DsPl5VwXfZ1pphnGv3fF+KVBW9BBjlDejT/JlpQ5204s6K8MvIHcr55CV?=
 =?us-ascii?Q?2fS+pa5oqACzVLJjlcewelZDbhntIvMeu84VKlAbwmcw4IS/tLV2HtVnatUm?=
 =?us-ascii?Q?oJwzdbNQ+5V6kpMbH55P8DkofBcJzkA8A5DQl56WikAqmVJhCtwOyDuwzNWk?=
 =?us-ascii?Q?lrE0+3xB+DwBngwHQhMN+rn4YMZFI8TqGpvSgloAje4QSRnqS0ouX0NJM95i?=
 =?us-ascii?Q?cPtUNMZJURqYdH5RuIPIojRx5aTXXI/33Kr4UhJEG8zeJ1MVVFpiVDFUtvkn?=
 =?us-ascii?Q?sZF8psZwrkFF4Na3bolixErEPLR7WuwCSFXDjQBP9jE7Q9dNxWeL29LROdAn?=
 =?us-ascii?Q?2/w3HFbD6EfJilaPRVUtV9OOaT8OwduiuLAdRmEAyE8mXLR8+wBs7OlJzpWf?=
 =?us-ascii?Q?FKWzyuEj/5UYPUlCIYK3weZsQZ9sA9S/C2G1coAwpHItoM1pSxlp6/1fHILl?=
 =?us-ascii?Q?1wiQv+7iy5HGSqPGnMaSmAtaiKLD1r40rD/w9nik9D5diWTHsUWbssTLPBWe?=
 =?us-ascii?Q?rL3YldL4M1TEzezF04CNdJcBUdD5bzbIAufCZWampcSZh8PsioZyleEJddGn?=
 =?us-ascii?Q?+GRxkh0a5bEeeCD8sk3CZtMSXy/twCFp+hpz7z9ZfsvV7kjj41VMJl7fhAfE?=
 =?us-ascii?Q?q5gWwSwiWc4/qoFWk4+ROaJbPP36p8d3QIL93CBd91B6KL+OJKUdI7fAlsZM?=
 =?us-ascii?Q?l6DkBK0xvI6tZcPIg/ywUbRDfK7p0l5AWbjfVwcjF77ELmU2ma364B2bXW3k?=
 =?us-ascii?Q?kav4a2uQVTPQPQhTwbCV4Oihh56Czr68VeR8akqMEGBrPVFD/apJpOs2HdfG?=
 =?us-ascii?Q?YSrQzZZf9fGVF8wcHpEMUdGJ+MYrfJgBxmUYanWt8rNP0ca/hjSvIJnLiZig?=
 =?us-ascii?Q?aNJeDQPjEo6tRO9jgzAO/6VccSjhjmJVny3/OQtJuUT0P9IyssvQJy5kmIl7?=
 =?us-ascii?Q?W15Yax3TD9hWApIlQsuqhKeq+HNpOfsAKhVb6pk5ysd9TOlj8FJudIyRpE4T?=
 =?us-ascii?Q?mVL6uJcDHEqwY61MRGK7ytzAmkrkfHKnjCw6c6TOAiwc7JlfytM8YtvJeNNZ?=
 =?us-ascii?Q?akDpbIL4PZ1wcWtL+q89onbJexdKA2NKQ04F1XF65fbb8Eh//v5oyLhYYoNU?=
 =?us-ascii?Q?ipU6h4Iau2eEQqMddDQ3bUsE4uy+9m3U8Ms5/V2nNZ9c7Vr9YpxP9XM4Ft5d?=
 =?us-ascii?Q?wRlhMSR8wcwXNhqJ6wOqtTfIYWgRUB5qtKBTjhATJeVQSTintN3MC6f1OX3q?=
 =?us-ascii?Q?qLe3o/D7R7l7AwnsH4ZMRdtmvRJSA6pV+a5yogaJZ5Gms35Pm0nYBgji2Bel?=
 =?us-ascii?Q?CPhZe/wFed2xRCQbGhjz5neABipz18kADbdwuO4pxZk9TSJr0hAF+B5aAiI+?=
 =?us-ascii?Q?x628JrcKLyWiIdjPsO15MT7E7yZPqzAcVr9KMFQAPhtThRZu5yLRfS2Wt3ie?=
 =?us-ascii?Q?WMyqPML/d/XJVuGf4tmCXbEDhTXYV29vpB0uB++L/Gohv2fDeShrfnbtKh3a?=
 =?us-ascii?Q?yA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <50062B9A1B2A4E4FA118025BF11F7187@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05fb128f-605f-4561-58ab-08da6c03b5ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2022 17:00:41.9097
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BclcaigH6Y3RuUXlvlBUuS2rJpJxzbrYgSSgn24f11sbPkQNqRyQbP+fV7j6abPWTD4grnGSKcphn58ltsDkPyiUcAbBfEKlX6lSRKR3laE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3493
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-22_06,2022-07-21_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207220071
X-Proofpoint-GUID: _cqVHbIdIFXLdpRVZX66WBBIWMQ3_DxF
X-Proofpoint-ORIG-GUID: _cqVHbIdIFXLdpRVZX66WBBIWMQ3_DxF
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Jes,

> On Jun 22, 2022, at 1:25 PM, Logan Gunthorpe <logang@deltatee.com> wrote:
>=20
> Hi,
>=20
> This series tries to clean up the testing infrastructure to be a bit
> more reliable. It doesn't fix all the broken tests but annotates those
> that I see as broken so testing can continue. V2 includes changes
> requested in the feedback so far.
>=20
> As such, I've fixed all the kernel panics (in md-next now) and segfaults
> that caused testing to halt regardless of whether --keep-going was
> passed. I've also included some patches posted to the list from Sudhakar
> and Himanshu which fix some more broken tests.
>=20
> I've also included a patch which adds the --loop option to ./test which
> runs tests for a specified number of iterations (or indefinitely if zero
> is specified). This was very useful for ferreting out tests that failed
> randomly.
>=20
> The last two patches adds some infrastructure and annotation for known
> broken tests so that they don't stop the processing (even if
> --keep-going is not passed). Tests that are known to be broken  can
> optionally be skipped with the --skip-broken or --skip-always-broken
> flags.
>=20
> With these changes it's possible to run './test --loop=3D0' for several
> days without stopping.
>=20
> There are still a number of broken tests which need more work, and there
> may be other issues on other people's systems (kernel configurations,
> etc) but that will have to be left to other developers.
>=20
> The tests that are still broken for me in one way or another are:
>  01r5integ, 01raid6integ, 04r5swap.broken, 04update-metadata,
>  07autoassemble, 07autodetect, 07changelevelintr, 07changelevels,
>  07reshape5intr, 07revert-grow, 07revert-shrink, 07testreshape5,
>  09imsm-assemble, 09imsm-create-fail-rebuild, 09imsm-overlap,
>  10ddf-assemble-missing, 10ddf-fail-create-race,
>  10ddf-fail-two-spares, 10ddf-incremental-wrong-order,
>  14imsm-r1_2d-grow-r1_3d, 14imsm-r1_2d-takeover-r0_2d,
>  18imsm-r10_4d-takeover-r0_2d, 18imsm-r1_2d-takeover-r0_1d,
>  19raid6auto-repair, 19raid6repair.broken
>=20
> Details on how they are broken can be found in the last patch.
>=20
> This series is based on the current kernel.org master (190dc029) and
> a git repo can be found here:
>=20
>  https://github.com/lsgunth/mdadm bugfixes_v2
>=20
>=20
> Thanks,
>=20
> Logan
>=20
> --
>=20
> Changes since v1:
>  * Rebase onto latest master (190dc029b141c423e), which means
>    reworking patch 6 seeing the original patch was already
>    reverted
>  * Drop mdadm.static from the make target everything-test as well
>    as everything (as pointed out by Mariusz)
>  * Switch to using close_fd() helper in patch 4 (per Mariusz)
>  * Fixed a couple minor typos and whitespace issues from Guoqing
>    and Paul
>  * Collected Acks from Mariusz
>=20
> --
>=20
> Logan Gunthorpe (10):
>  Makefile: Don't build static build with everything and everything-test
>  DDF: Cleanup validate_geometry_ddf_container()
>  DDF: Fix NULL pointer dereference in validate_geometry_ddf()
>  mdadm/Grow: Fix use after close bug by closing after fork
>  monitor: Avoid segfault when calling NULL get_bad_blocks
>  mdadm: Fix mdadm -r remove option regression
>  mdadm: Fix optional --write-behind parameter
>  mdadm/test: Add a mode to repeat specified tests
>  mdadm/test: Mark and ignore broken test failures
>  tests: Add broken files for all broken tests
>=20
> Sudhakar Panneerselvam (4):
>  tests/00raid0: add a test that validates raid0 with layout fails for
>    0.9
>  tests: fix raid0 tests for 0.90 metadata
>  tests/04update-metadata: avoid passing chunk size to raid1
>  tests/02lineargrow: clear the superblock at every iteration
>=20
> Grow.c                                     |  4 +-
> Makefile                                   |  4 +-
> ReadMe.c                                   |  1 +
> mdadm.c                                    |  6 +-
> mdadm.h                                    |  1 +
> monitor.c                                  |  3 +
> super-ddf.c                                | 94 ++++++++++------------
> test                                       | 71 +++++++++++++---
> tests/00raid0                              | 10 +--
> tests/00readonly                           |  4 +
> tests/01r5integ.broken                     |  7 ++
> tests/01raid6integ.broken                  |  7 ++
> tests/02lineargrow                         |  2 +
> tests/03r0assem                            |  6 +-
> tests/04r0update                           |  4 +-
> tests/04r5swap.broken                      |  7 ++
> tests/04update-metadata                    |  8 +-
> tests/07autoassemble.broken                |  8 ++
> tests/07autodetect.broken                  |  5 ++
> tests/07changelevelintr.broken             |  9 +++
> tests/07changelevels.broken                |  9 +++
> tests/07reshape5intr.broken                | 45 +++++++++++
> tests/07revert-grow.broken                 | 31 +++++++
> tests/07revert-shrink.broken               |  9 +++
> tests/07testreshape5.broken                | 12 +++
> tests/09imsm-assemble.broken               |  6 ++
> tests/09imsm-create-fail-rebuild.broken    |  5 ++
> tests/09imsm-overlap.broken                |  7 ++
> tests/10ddf-assemble-missing.broken        |  6 ++
> tests/10ddf-fail-create-race.broken        |  7 ++
> tests/10ddf-fail-two-spares.broken         |  5 ++
> tests/10ddf-incremental-wrong-order.broken |  9 +++
> tests/14imsm-r1_2d-grow-r1_3d.broken       |  5 ++
> tests/14imsm-r1_2d-takeover-r0_2d.broken   |  6 ++
> tests/18imsm-r10_4d-takeover-r0_2d.broken  |  5 ++
> tests/18imsm-r1_2d-takeover-r0_1d.broken   |  6 ++
> tests/19raid6auto-repair.broken            |  5 ++
> tests/19raid6repair.broken                 |  5 ++
> 38 files changed, 361 insertions(+), 83 deletions(-)
> create mode 100644 tests/01r5integ.broken
> create mode 100644 tests/01raid6integ.broken
> create mode 100644 tests/04r5swap.broken
> create mode 100644 tests/07autoassemble.broken
> create mode 100644 tests/07autodetect.broken
> create mode 100644 tests/07changelevelintr.broken
> create mode 100644 tests/07changelevels.broken
> create mode 100644 tests/07reshape5intr.broken
> create mode 100644 tests/07revert-grow.broken
> create mode 100644 tests/07revert-shrink.broken
> create mode 100644 tests/07testreshape5.broken
> create mode 100644 tests/09imsm-assemble.broken
> create mode 100644 tests/09imsm-create-fail-rebuild.broken
> create mode 100644 tests/09imsm-overlap.broken
> create mode 100644 tests/10ddf-assemble-missing.broken
> create mode 100644 tests/10ddf-fail-create-race.broken
> create mode 100644 tests/10ddf-fail-two-spares.broken
> create mode 100644 tests/10ddf-incremental-wrong-order.broken
> create mode 100644 tests/14imsm-r1_2d-grow-r1_3d.broken
> create mode 100644 tests/14imsm-r1_2d-takeover-r0_2d.broken
> create mode 100644 tests/18imsm-r10_4d-takeover-r0_2d.broken
> create mode 100644 tests/18imsm-r1_2d-takeover-r0_1d.broken
> create mode 100644 tests/19raid6auto-repair.broken
> create mode 100644 tests/19raid6repair.broken
>=20
>=20
> base-commit: 190dc029b141c423e724566cbed5d5afbb10b05a
> --
> 2.30.2

I have not seen any updates or review comments on this series. Any plan on =
merging this series?=20

I have been using this test series for my developer testing and this has a =
very helpful
testing framework update. This update improves baseline testing and predict=
ive failure coverage.
I find it very useful to work on improving the overall test infrastructure.=
=20

You can add my R-B for the series while merging.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	Oracle Linux Engineering

