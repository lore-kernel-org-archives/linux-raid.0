Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-22.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A49A8C433EF
	for <linux-raid@archiver.kernel.org>; Wed, 22 Sep 2021 16:11:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80525610D1
	for <linux-raid@archiver.kernel.org>; Wed, 22 Sep 2021 16:11:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236557AbhIVQM3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 22 Sep 2021 12:12:29 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:47738 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236506AbhIVQM3 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Wed, 22 Sep 2021 12:12:29 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18MAPF5i005605
        for <linux-raid@vger.kernel.org>; Wed, 22 Sep 2021 09:10:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-id : mime-version;
 s=facebook; bh=c4Chx4uZuDYrFmdZatfrnQev5rfOgv8mUmU1w43Xwm8=;
 b=L+CEHqRIkqj82uHLFqlwl+PQhHboB5YEDPFkoFBlFyY0xAcz5tRpJFHXuQly99XBbuuP
 fbQhf6AuCvfZy+uqaWuwI62e6e95iqxowFix586ZaMybNfCQf0GWJ1w/CieBuG/DVbH/
 alXTMWYtib4cvQeFu84WxTj+D5i0ojzBoXw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3b7q5867jc-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-raid@vger.kernel.org>; Wed, 22 Sep 2021 09:10:59 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Wed, 22 Sep 2021 09:10:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JKWtx/8hiooQn/28rgJz/c0iiZiSO7+xFD3gZGY8F1g+AbTZpdFIp8P7aL72puquILFHc46Jk5PPx+vr3dJAb0djfL+YeaXvDn+xxtSbnnGeCNCqp5OxKlsgQgRElAOgGkISy7fpqznI2IimylDligQAMD2KwbE0iAMQbTkFUNXwmO+cNUS/rsc8J7Zw5pMZLMMtY4ed/wEoNQksCUXW+hIef0xuUxJfa/Oh5Cdl9DvJ/ThtTR5FgmF6QDo6MN4/yolZ1+riCgBBhc1hVyCVz0Vt/cvNtzeMPuzhEL85MPM07gdG+iWkJaQRnRvdBI8/t468A7MoOYW8X6r+LLrCcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=c4Chx4uZuDYrFmdZatfrnQev5rfOgv8mUmU1w43Xwm8=;
 b=gj4chLNxR8s6JdGv3KoLz/Y9wAHUYCYnTFh08JfNTyCREvvh29XcO6zexXX/19RpLKL0cqLVdRZmVVStcb5HM4v3ApqrZPeGFqkSnxBPMfm4zcYeIYn6dzzkmMfsNkl5iJVxjSNsh+X7Xa+Z3mUiAShqGjLUeq8o/gjUu9Or5g0DMjuCjKKOhOoLxN6K4uWToDQgpHQ1vfMyF6Y3F/sNZfJ2yHtoqonkunbl7mHdUV6Fz58pVt+STP/dFBLBvueGghl3oFR3IyPRWWrVR9AWiVMvyfLTVCybzMMY8fSbyrav3tMAl9QzBXRDXnwBHqJFk7wDSTCR1Ybr+2m70mcRBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5096.namprd15.prod.outlook.com (2603:10b6:806:1df::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Wed, 22 Sep
 2021 16:10:56 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7d66:9b36:b482:af0f]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7d66:9b36:b482:af0f%8]) with mapi id 15.20.4544.015; Wed, 22 Sep 2021
 16:10:56 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
CC:     Christoph Hellwig <hch@lst.de>,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: [GIT PULL] md-fixes 20210922
Thread-Topic: [GIT PULL] md-fixes 20210922
Thread-Index: AQHXr8xsxaknAdiErkaO7JjmBxen4w==
Date:   Wed, 22 Sep 2021 16:10:56 +0000
Message-ID: <A739EDD6-BF73-458E-B674-D426564E13C0@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=fb.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 19197e52-8305-49be-3284-08d97de38f74
x-ms-traffictypediagnostic: SA1PR15MB5096:
x-microsoft-antispam-prvs: <SA1PR15MB5096C2A57D7D8CB489828DCDB3A29@SA1PR15MB5096.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:1468;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: s62w9odSnledArkap6VuOR+3F6CMt/qpTpOod+4SPpo2Vr/mBQYJLBqReRtlf3MFbb3iUhPJOF/RLTWYPuJTc87Nz1DEowQnHx+WOYWVBwVAzd0wkdszKHgw9RuZBIzd7M+TIcm0QdVROgtUpnCCeO2Bef+aqQiIXcuBm/Nhkqv72pGU5xdcDg5gB/g8LeSsh0cZEvbMF0/TuHT9qAmsltSrcYYNsyWdVZxNu/+0ovys/T34Ct4oeyIyHN6tLKIuduiLI3FWN5tzGBewkXrrjnKNzBPAoMnzoCLdqqwk0h1kQ/evDAeFXxfZb8VvNv0QJcuUavfbdJsRItxhAo7ddJQBl1mj7jXJGJbbB+ZylMqY9NeDogcPr38VmuM5uPVPWydu2dLvyT1FY7hyKBgaCBDyxTla+KUlRTF9mqCQSB+uydh/sJoBJio95np5gDpYExCabPnqIF4PCwBqN/js2uR7OVLgOk0NT1zWsPOcOwEsQTWNRS2i4ls2CeHGQFEGyZBfyEvq05U/Rl96k/NkcEPySheYc5baAXrfyTRbz0kZSoKjY9QJM6/GkqZPlfuw5S2rwj+rWqwuIHCGEa9SCDG7vNN6D1CQlTmz/+iGk4/mYJZBIBizVGarS6yXeIPf//9dbiDioCKabmUc7yVbr1wT/4Wa3TRMid/l0Q3UBJdpFpJ/eQhMemOqE5pqsgmiyp6QzlK8BNvSm7kOKFQlKsB51858ceOtSgU8+03pNJcOZRX2otKiFT7sPKV3cMar1uYWXGBZ+ur5yosverh19Ia6lOKG+0QsRwCthtN5TK4zD4UOgwpJJo5usHFWj3ip4qAiyxDgZr15sXngfZpc/A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(8936002)(8676002)(86362001)(6486002)(6506007)(83380400001)(5660300002)(38100700002)(36756003)(33656002)(6512007)(122000001)(64756008)(71200400001)(2906002)(186003)(2616005)(316002)(110136005)(91956017)(66476007)(66556008)(76116006)(66446008)(508600001)(66946007)(966005)(4326008)(38070700005)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hHnsRroQrDGIbbnOR887FsAjrHX6g5nsdHY06Dl2dMBoMdcki8fsJ9LlWzhq?=
 =?us-ascii?Q?Y8FRCdht38hndryXryWF8yyW8+2iYw9/8KXizn2dh+UdnhlgkXbL8w3fuh/u?=
 =?us-ascii?Q?wai7ZuMIaDAg9Wc1Ue5zBLNMfooWjl2BIno+DiQpzyRf9Tfn/FVjhL6ONgIN?=
 =?us-ascii?Q?mj0cMO2Iul0cKjKvbeE47JDwivCzLCWCxDv9ck2RPvO1SLaZgDEJIGEFVDjv?=
 =?us-ascii?Q?7Aq100QhT/GqFbnIZOgyZvWl4zjRsAZNjRsqsi/Hm8k9js4omhLn6AFcasKl?=
 =?us-ascii?Q?tZbKAxjVxSB2LNxIiwqpqYArr/iBMrxPOT+RuSKeI0QuOgZqLXnHV+Jq7vQC?=
 =?us-ascii?Q?8Ohbq8UOgqkNK9ul0EaF8LgL2cpUrxq+rDXHN5T7UGf/lw3WIVqu0AEUImu6?=
 =?us-ascii?Q?mfLz/Cu9duGMJIVOBp36VCOqHoAMBLpwc+v0zaK+OfzfV4fMGDPFa9EkadEe?=
 =?us-ascii?Q?vim1b9XiXwd80fwi8lAugsE605z67WdMn9RjZyimfXjY4HpZy7i459g6bHH4?=
 =?us-ascii?Q?NHcgqVnszZw8GPjVGF4TX4Ph8dypxMii1HC17gKm4WUSsGHxjjV/XRwCCa/m?=
 =?us-ascii?Q?U8A+0Bwf5QO/DL3qanM+yDMG8Ry6KhPoqk+QLjEHyAlIAjfOXzA5RdWblzoW?=
 =?us-ascii?Q?q42YjsNux1KZcS1+HfWWDs70Wiz1GjqZ+2BUvwUd6gnwK5dPYxiyPSRVLcch?=
 =?us-ascii?Q?gEv7m/CiLKqWUOcB0bYPKquWhhw3IpOD+ZreLAaoODb/0coHBfa16ufeTVYL?=
 =?us-ascii?Q?ufCqplZnu7b3It1RGL19REAVFFMYbbuQ4q/cDRklt/xlWpstwzdVQlksLJ2a?=
 =?us-ascii?Q?iSQKYvGe+XcFgRt0C9xG7ayVADn4w5WnYsVY4yRCje503c6DMcqBp43m36pc?=
 =?us-ascii?Q?qxeHhfiPedEyQ254cxZwD8w0wrhFYkMQJ/6638CpPzlkPVapLLN8XhC9ww7y?=
 =?us-ascii?Q?o2QjkVMW1F9StMFWgL/KaQYVis5NUqpYMO2sHwy3vp3Vset3346Uphp351mD?=
 =?us-ascii?Q?Ry77OQutNnWfM4O+w3m8FeGYAFu/UBg7ATOoa5Zvz0OEIp3eMQx0wfSdks1+?=
 =?us-ascii?Q?ja8tZTxW98Ffo9dVZ+5nNcJNO26iQhzZLqelQ0xbzalufkw3m8JHymppieIx?=
 =?us-ascii?Q?/lzMHaVsAcC1BHD6iiyL3knSFFo9XDQMQry1G7pRHTHRzgqqh328QcZ6+zES?=
 =?us-ascii?Q?sR7iQAmkG/CZMRAOkunkvXHe8tSoTarZri8otds5UAKE2/1evSzYoA0XOIAs?=
 =?us-ascii?Q?xmtp3quRXfVi99XXFODC7UgY3Hk6SSA5X/yRdWAUmuSqrIh677LG1ghM6GW1?=
 =?us-ascii?Q?h16m6rY1DzEIFYIUZ9gxzMelzv7l5Fxd9uQC/xKujpWmn4XBRW1eqHJrtcK1?=
 =?us-ascii?Q?SdCl3Ss=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4F9D52CB4976264C9BBCFC5A6E9BA96C@namprd15.prod.outlook.com>
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19197e52-8305-49be-3284-08d97de38f74
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2021 16:10:56.5967
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mFqHTZMqc/+vEYYRzGTol1wbSmuyRrpl7pXdNZWStAA1j4BiqYjYfZ1wruVPK7OdjZoNv2Z2eIH7oxWS1OLENQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5096
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: gDN7tICP8P4QCiculk5OLh5mBZrtamiJ
X-Proofpoint-GUID: gDN7tICP8P4QCiculk5OLh5mBZrtamiJ
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-22_06,2021-09-22_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 spamscore=0
 impostorscore=0 clxscore=1011 mlxscore=0 adultscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109200000 definitions=main-2109220111
X-FB-Internal: deliver
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens, 

Please consider pulling the following changes for md-fixes on top of your 
block-5.15 branch. The changes are:
  1. Fix lock order reversal in md_alloc. (Christoph)
  2. Handle add_disk error in md_alloc. (Luis)
  3. Refactor md sysfs attrs, included because of dependency with 1 and 2. 
     (Christoph). 

Thanks,
Song



The following changes since commit 858560b27645e7e97aca37ee8f232cccd658fbd2:

  blk-cgroup: fix UAF by grabbing blkcg lock before destroying blkg pd (2021-09-15 12:03:18 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-fixes

for you to fetch changes up to 36a0f29442237275abe33b73eac475c410bea6fa:

  md: properly unwind when failing to add the kobject in md_alloc (2021-09-22 08:46:00 -0700)

----------------------------------------------------------------
Christoph Hellwig (4):
      md: fix a lock order reversal in md_alloc
      md: add the bitmap group to the default groups for the md kobject
      md: extend disks_mutex coverage
      md: properly unwind when failing to add the kobject in md_alloc

Luis Chamberlain (1):
      md: add error handling support for add_disk()

 drivers/md/md.c | 56 +++++++++++++++++++++++++++++---------------------------
 1 file changed, 29 insertions(+), 27 deletions(-)
