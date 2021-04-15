Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16CFEC433ED
	for <linux-raid@archiver.kernel.org>; Thu, 15 Apr 2021 18:14:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2EF76105A
	for <linux-raid@archiver.kernel.org>; Thu, 15 Apr 2021 18:14:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234465AbhDOSPA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 15 Apr 2021 14:15:00 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:19136 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233551AbhDOSO7 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Thu, 15 Apr 2021 14:14:59 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13FI6PEu013668;
        Thu, 15 Apr 2021 11:14:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=R5ur+9T56TEBEjhl4GzaQRJD2WBtvXxo0Ksnjd8KKw8=;
 b=VCrP3/ROZf5L9PPj4c5IXcv1en0Zfs8JnJg/blY5RClA2cTtqUyvZAjZVjaZYzy+P5Zj
 QewR72XF7Tj7eqt7KqE/r7Vokakn9lnjMUAPZgiiRUl3EXgYPitmn9PNdDF9yW5bSzbE
 eSwLTG2Wut+QcIq28NnTIC8OzaP0rVpwr+c= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 37xr3013p8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 15 Apr 2021 11:14:30 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 15 Apr 2021 11:14:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DUUCrNPsyS08RxIi6MzwpGJOoJukaFbbhCTW1Csl1LGBJObvnhIpEZ9XXMP0XYcWziBsj84LkHsgsTVTDBY+cpR/FwP8PmomPB1RgZCgv08d2Ol/4Hv2Z8mWL7FTP5dovzRrHoNh+2zm4aeCTHk1bgMs2Hq90g9a4HWmqjpiCMPE9jyTMTvVulA3ait77zpvwh+4fUCZjsfELiF0VIw8rWm+/zI5D/ohYC7nYdSc1TClfSORFh5nve5v7X14imotrRnpKg+BnUBr4ifZw86DBr8B2HE+OX3AsXLpXbehryljvkX+1cIwJaeA0qbLHN07vbEG/IPO8Wb0Hkm0YYQgFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xjel6DiaMoaJ3qTU6y3tOTWiHgVwtnIpuJ6xpvdnrMY=;
 b=S6Agih+zjFaTIKDhZvyu2X8VNdhzMB3eXRdHiilVduinKDg4oj05TSnTXc5R6HUJHMOtgBEg724UswWQ6mNQ9WU427aV3044pibOnG4330VQkDl2vyjfJydfPkydGJWceV1VXxmLeMD6gaaIhGM+BN5CIl490iBNHQx6YGqqgvCFUPiDVzeOAjpeWgdwpVqswhqUMOXk/EoEfZTKnJgugdI5OvFlQXLxZRb8cDxd60og3s6iFyjGG0ZY5yKH2ydUzJK/QcHsbMFAOycPi8YioY1gNEsox1mrmIcYS8uLGJS0TPbWq1g5OaPVn9CeNAY7IROagppw5rpqkZ3kHxuZyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by SJ0PR15MB4664.namprd15.prod.outlook.com (2603:10b6:a03:37d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Thu, 15 Apr
 2021 18:14:28 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1ce0:8b27:f740:6b60]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1ce0:8b27:f740:6b60%4]) with mapi id 15.20.3933.040; Thu, 15 Apr 2021
 18:14:28 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
CC:     Christoph Hellwig <hch@lst.de>,
        Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
Subject: [GIT PULL] md-next 20210415
Thread-Topic: [GIT PULL] md-next 20210415
Thread-Index: AQHXMiMseccvZuMLKk+Y0RvdpY4SZg==
Date:   Thu, 15 Apr 2021 18:14:28 +0000
Message-ID: <BE74094A-F93B-4989-9C2F-A25E85C4CC97@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.60.0.2.21)
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:8797]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c76bdd28-4537-464a-421b-08d9003a4f2e
x-ms-traffictypediagnostic: SJ0PR15MB4664:
x-microsoft-antispam-prvs: <SJ0PR15MB46641EEA2C35FEA929888C05B34D9@SJ0PR15MB4664.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:2512;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LKrqv5MW3+2aZh6S8Xjx3tzpvO+h+Boh1+YK+CVnWf67V8XzsJ9bRuG+4RF5xcYUvg/sIPZEgT1Ktpc1HID0VnT3p8e/k08PcN1uJIClj7yJjf71wWED5iKxk2pRZ2RX6PYaQnMLm9/4eyWSAAGfj7x1git+CJ8mffyzDEGjqmrWWnuz0uuYOdYTuQx4vz465JNi5B6BsyTWYjpfuqETA7CbOIHS/LK+r5Y+RgKHkdy2IXGplkktFuFWINgqcisis7o6WQkdy7sFBozNt0FUvGry8WwpYV6ow6PZDUP3pkkCHmbftCotIRqHWYrtpTpxIuHYsota2FuriyW315RVKMWAAr/gaXHcZeGuPLsw2WCXpQxMbBPwn37/c4eXIb4WwLvR9ajJ+wY0S4ipygUstzgW9XMrwp3Qa0YuPpY6KtorTPjI2EZkT4J1re6dymQ0imbFCJ6I8U3tKfrtCMwXGZ8JVcfWP9yEV6xFSuNbOI4CfpPP/+v62/m/S13fznHlhlAvsleUEYg2CAOcZtMMwgfHJ1evtzsrJkFEpoqLP9R2LrtHelX25wlrHq6VvvrkFSbIBk9lmnZoY7ply4AmpOeW121Vd1F6uklNW3YEPmDKPNjup5CiG/IkFzsibofHYIENqmqmbss1dSwYGM8hKj/riN1QJCnid5WI89p/6eu+FUvyWTwULFwtQIYolpYi04ceoYQlarnAhoJbe93m3Uy6Jvi2aQ/G9cVQGiLSKrcYx8wtvS7Pgi4PFrphLgAb
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(376002)(136003)(396003)(346002)(2906002)(4326008)(2616005)(38100700002)(186003)(83380400001)(478600001)(122000001)(33656002)(966005)(76116006)(71200400001)(316002)(66946007)(91956017)(8676002)(8936002)(5660300002)(6486002)(6506007)(66446008)(66476007)(66556008)(64756008)(86362001)(36756003)(110136005)(6512007)(54906003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?G7vGFyXWP6Re57ySScP7swqBXRorQJGGmfB0AosP3Rq83lJ+1eZQrja+CieZ?=
 =?us-ascii?Q?hGBmEKtgqcIWdxXfwf9AvRfozBSSLw10EWeBH22kZZQMiCyx3z5+WnH0K9D/?=
 =?us-ascii?Q?EeftIS5D2vcdC8Byz3DRyORZh9d6Avi2VbSwX/EGuARXmwxqCb6OmdNm3PFG?=
 =?us-ascii?Q?NSCXdOd7VuzWvmhm99p/nskpaKtWIKvJIxIsiqBTJ//posx9adEQO8Oh9w4Y?=
 =?us-ascii?Q?+q8TDcM9htQrfJpCX909tAbqGmc/0T81XYV1jiKcif9BW0mcjtQW4e9Bhpdx?=
 =?us-ascii?Q?nQzxY/XgKPXggKBQHHC70QgGD1QLYtqglrMmi/QaOu2Cwc99ZGSJI6NqwB4O?=
 =?us-ascii?Q?q4xuOrSDvWC0UgWNTFV+JoM5Mocx4OFUlQpTfGKb4++R4iKDt1QqQAqylrsP?=
 =?us-ascii?Q?3rchOTba5AcsQ1TPtN7VSTzujXUlMEFrCmm4ZU+nw9dzjm1ndNQv9JnR1mi8?=
 =?us-ascii?Q?+unkYO3yUEiSlBmvsm0I2G6LuHLp7+56BbDO2LGhLJRc/hOfNbR9Wy1edxwK?=
 =?us-ascii?Q?cRzRGnClLPv7lD7R1BVMlLkvU5UOBsSAxLsj47pouGv/3AcR96q/IOVxi3+N?=
 =?us-ascii?Q?i+SMTSl6JWvK1SFA0Zwggl8lTDaIuMKIcicC1IggdJ0fiNz4T0sktghrtsyA?=
 =?us-ascii?Q?cLSNe1t03/J+d7rUPWfdJfyN+CZJw2FwcccrhuLRHH3JeSOkfjj71/MZGsN5?=
 =?us-ascii?Q?R/sl+p9LypUrOGf0ijYa1s7yiesWrnzAsMhHczyhrykXjn6yqELLKdOR8LrE?=
 =?us-ascii?Q?K4yWhzIgWxx5eNoJ1bxgpko8Nzew+LzvXebhsT9QJ9XezJ26hNr4Fp23F1eU?=
 =?us-ascii?Q?Al4H2WjkZChR1dRVHrSkarexqOszPEIsSTAWQ8A+mZpFVLL10HFv6JHIqd3B?=
 =?us-ascii?Q?3HamgcCKkEEvPgyGZH2tnAeHY8olEFRfWGwfd/Bc7xpsZhbhFWPenOqs8GZt?=
 =?us-ascii?Q?JopSwmAM90EFdlKbkRdTlo2aubGWNZe3Hod8y8uygbUX2OOpyNI3XTuM3+IY?=
 =?us-ascii?Q?53HBWtlX8/Yy2+6kyzCCMixFKr1Fs8rqSDzA1ARmgqX0Sa6Qcq6qvDGns+Fw?=
 =?us-ascii?Q?1d8TprWy+c/9jDx3vSCl1XuHsSj41Sn7wRzgj0X1vrK21L969kLWjwkI04mu?=
 =?us-ascii?Q?O/t+Abei5sJ99ahqplnZOkS0bBh0KdOL1skgTQgvPhWyK+tO1WtXMY4Ut/Sh?=
 =?us-ascii?Q?lR/lZSsR0+3Kk5aoIwTfC8tCyWgYQYeR9b1bf3p9XxvTe0jzkmbhlEdRMiFZ?=
 =?us-ascii?Q?2W1RRAsRntlrXx0eTuvuX8BYSNLBODEracaUUmOWoon0E4Yg/QScctbBHxHP?=
 =?us-ascii?Q?FRfvPIAsUlJMsmVD+Ile49+DHhiQd8zh0BL5xy13KghddgYASjtKMVSSxs/Y?=
 =?us-ascii?Q?+jM4vD8=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DEDEB70F6305864AABC7A675961C2F47@namprd15.prod.outlook.com>
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c76bdd28-4537-464a-421b-08d9003a4f2e
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2021 18:14:28.5471
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1oz/OV/6gkeaJRQNKEBw1ONFP4U7ytMB0kTx35q2HovkX/ADTjewMQRHfnEmHZA0zrkKnsBwbyc1ek0jIM3xlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4664
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: RGyfBFh2VIDMbgOUTq15sgx2gbHldBy1
X-Proofpoint-GUID: RGyfBFh2VIDMbgOUTq15sgx2gbHldBy1
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-15_09:2021-04-15,2021-04-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 lowpriorityscore=0 bulkscore=0 clxscore=1011 adultscore=0
 priorityscore=1501 impostorscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104150113
X-FB-Internal: deliver
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens,

Please consider pulling the following changes on top of your for-5.13/drive=
rs
branch. The major changes are

1. mddev_find_or_alloc() clean up, from Christoph.
2. Fix NULL pointer deref with external bitmap, from Sudhakar.

Thanks,
Song



The following changes since commit f8ee34a929a4adf6d29a7ef2145393e6865037ad:

  lightnvm: deprecated OCSSD support and schedule it for removal in Linux 5=
.15 (2021-04-13 09:16:12 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next

for you to fetch changes up to 404a8ef512587b2460107d3272c17a89aef75edf:

  md/bitmap: wait for external bitmap writes to complete during tear down (=
2021-04-15 11:06:32 -0700)

----------------------------------------------------------------
Christoph Hellwig (3):
      md: factor out a mddev_alloc_unit helper from mddev_find
      md: refactor mddev_find_or_alloc
      md: do not return existing mddevs from mddev_find_or_alloc

Sudhakar Panneerselvam (1):
      md/bitmap: wait for external bitmap writes to complete during tear do=
wn

 drivers/md/md-bitmap.c |   2 ++
 drivers/md/md.c        | 139 +++++++++++++++++++++++++++++++++++++++++++++=
+++++++++++++++++++++------------------------------------------------------=
----------------
 2 files changed, 69 insertions(+), 72 deletions(-)=
