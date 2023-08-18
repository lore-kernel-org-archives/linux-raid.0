Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19354C71133
	for <linux-raid@archiver.kernel.org>; Fri, 18 Aug 2023 04:52:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357890AbjHREwN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 18 Aug 2023 00:52:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357885AbjHREvo (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 18 Aug 2023 00:51:44 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64CE835A1
        for <linux-raid@vger.kernel.org>; Thu, 17 Aug 2023 21:51:42 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.19/8.17.1.19) with ESMTP id 37I2tNJ8025991
        for <linux-raid@vger.kernel.org>; Thu, 17 Aug 2023 21:51:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : content-type : content-id : mime-version;
 s=s2048-2021-q4; bh=WjSdrmbIL8YRqB/L1FqSlccqG02LzzxLEnT6ay5KiIA=;
 b=Pks+QmMKuOOrSH6oLR4LP+J42YbsIbWkNd8ct2Q3c81MBXZxtXiA8iaD2u3O3uLXQGIN
 q9Zom2xt3d8KLvw16wSNCm/UOPFR60qg2QS1JtYFvTkVMlFovi9FWqno/F5z5U3tnlVm
 F4ZIKCPsr/JZEzCBeg9eo4QyZjq8tCKL6487zbrN7rab1P0qY0ZHRfMIiMowOjnS3qrc
 sYTcxFo2AAKYzuFOVHGBXABdoH4AWqBeLkGaF+XSkBkDx01YXqeDrrs0hrp+Rn0VPGwc
 t59p0eiFyFrhIXcwbW7ErYwzeZ/dlf779qeacwCyDqWyRWF0mEg56550b4UtSFGdd8vH VQ== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by m0089730.ppops.net (PPS) with ESMTPS id 3shauuc4nf-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-raid@vger.kernel.org>; Thu, 17 Aug 2023 21:51:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b3gUBzoFj2R6gdRTbQfd1IPcoch4l5GVi0Si0Ogs/FnLh2jsYjle6ENuek84ptJ/1KbVKEOoiZpo9vJig2FxFcdYS7JLdIXvzfXihnX6zjmO2GuN/ZJ7kUyaKJqsGfHGjrPqMpDDW5KuF5lDu02BDKOGo0WauI0fLUoRtECdQSXHjUsBtsrs5elJKyRjeolPEj5rtaE5n3NHQahFfwZdP4s5PwhMpYj8Ia+RCKlvVXb8iW5AYKtQCaoi69IUU14DZUK9zbQJQ/z62MmLNK+BZWEsc9rpx9/DZFR7yD1UxpglT2QpPsglPKzZ8m5s08SJGup+zDaxnqMq4nBjiyOkNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WjSdrmbIL8YRqB/L1FqSlccqG02LzzxLEnT6ay5KiIA=;
 b=fC9ICs6f80Z3EYNtCm665OkFP63gfScr26BffQiJE2agm8uyI6FtJp/dbldkpOEbhmFpvXdD6SQa6kKftJsplo4EtgtU2nbME2qrCcZdcJ8LdYtrgPtsoO8XtVxLxy9Odf+1omWQnp3TBMihkIy/kq6dL6Wezbmj7mog3BGlBQM1pr5N/j5a1r8jndqvNCLvDLkhzm8dC6qtWgSSgc0PhYb7L+S7KWISTvkVWT7WDq7kqjovUMxf5gQVyZRjvVPW4ZWxXGTeQ6EWJcKB259ELm5N5OJuKJpkq0fk6mEnklMM3mrXADg2hfjZKLdeQ+HiG85ReBYp1OMC3PWqxpY4/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by MW3PR15MB3769.namprd15.prod.outlook.com (2603:10b6:303:47::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.29; Fri, 18 Aug
 2023 04:51:38 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::57f2:86c6:1115:ad7d]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::57f2:86c6:1115:ad7d%6]) with mapi id 15.20.6678.031; Fri, 18 Aug 2023
 04:51:38 +0000
From:   Song Liu <songliubraving@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
CC:     Jan Kara <jack@suse.cz>, David Jeffery <djeffery@redhat.com>,
        Heinz Mauelshagen <heinzm@redhat.com>,
        Xueshi Hu <xueshi.hu@smartx.com>
Subject: [GIT PULL] md-next 20230817
Thread-Topic: [GIT PULL] md-next 20230817
Thread-Index: AQHZ0Y+sZQFZ88FZHE2OtGC8qE7XrQ==
Date:   Fri, 18 Aug 2023 04:51:38 +0000
Message-ID: <F71A83B2-C4A5-4168-915C-546CF34CFF34@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.700.6)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|MW3PR15MB3769:EE_
x-ms-office365-filtering-correlation-id: 0fe4128a-ef02-43c1-c88c-08db9fa6ce8d
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pdlDp2wtIoXKDYJ9JUKTBcNuHo9DfbrcehmN/SfmoX1gnIpXhAESZzZ1lq7y3Ju5eJb0dJKB6WFuDNNUAtdm8qKtTp8f6ocfbgszkj4FXNfmWiwqDE0CjJFI8gi0RRmnBirafc9Onz0o1nis80rvo9IvcrPG2mjnNoeqJ97nq1YPmy+yh7fTNOk7MxLDu2O1srcBe+OBxCuu6uCItFoeGK8dyWqL/Wt9F0isElGmqy0ArBTCb3pg2Uw1Za6SEkl1qJ+DrSghKIS/RFD0byf7BUFFh5Q0C+rXGyKLzejL0PpOEgI7SQcYcANBg40ykByGcS4YrS950rUIEPkW4RBNklzyvpVlVaFooRGRNXq7raFE20JeUZEDCIWs55gA05Tuh4RgjLYJaLa9nt8PVdWUdMm8JWcWS3+bNeiMXhqUvBDfOLoSIISO82+pk+1v0/fZNSlFq+WBg9WHfE2W0KOlSA+mazaUDS+TaRsBhgwNXjVLEy0JU3XAaTK3BENrdYazLnsa4YuDFdk6O21Nd4o6w9m2rJHYpSQHOYa45F5fTGO3m9xPZyQNRF+XgKGQI0rbL66UhwXieo5vixTuThbyTWs+RqDuQLzu7cwrVwaedmt3g4PN/RiMNTJzy83DJ7I6QTXwlHvQ7YNL7L1demYAknWiFTz3AiN7OT1mO0vxGFE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(376002)(346002)(39860400002)(396003)(186009)(451199024)(1800799009)(2906002)(83380400001)(86362001)(478600001)(6506007)(71200400001)(6486002)(6512007)(33656002)(9686003)(36756003)(966005)(5660300002)(41300700001)(66446008)(122000001)(54906003)(66476007)(64756008)(76116006)(91956017)(66946007)(66556008)(316002)(110136005)(4326008)(8936002)(8676002)(38070700005)(38100700002)(473944003)(414714003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DDjGzkUdzcajqRhLUfD0URDw7eGUOPkLeuIp99JSlaJHPSTZYfjiyeFBrpoH?=
 =?us-ascii?Q?olRYdKOtMAuH6lrC0/6OdMoIN66JfF8xmkEoj0xWhCSvspQGZpVvw3gsqMVv?=
 =?us-ascii?Q?0bxdWGfKnsQJf4d0ynWUKsUWw9BSg7vrnTnWQ53zDqDKG4MOE4OMu+0L3WPo?=
 =?us-ascii?Q?wFle4aUngQxT7WJ6HhGKVdROKEjjA38xGz4lZOGsRqq0lTUBVYEgX5cRD44b?=
 =?us-ascii?Q?3UIt+0dO4d+ShxKGLoSTkRB9bDjmmbL/43JQYv58SWpSP3NNB1+QciAXlMAF?=
 =?us-ascii?Q?yjmCJDxxWfaPa87zfCPGOaJgEKeNO5Gd2w7RSAmsysH/XrwVfjKQw7DwrQkD?=
 =?us-ascii?Q?uAA52FiEJi4ZCcfJgSpRd6ZSyiAq8PMwHMTx6QLSwKomiASwcCnSJVCt8Fe3?=
 =?us-ascii?Q?nTZRN0LaceM4NbuNBSFiZ16QzcW6c2jWCyuwHwELzdYA+Spg9u1JrBE7by1A?=
 =?us-ascii?Q?gneIit5poiRsDuqNWCqo4YGWCS25hQaeRWOIHlFVOShVGEfvzzXHJuRFc3aG?=
 =?us-ascii?Q?xoLIvcJ/MGrPc5Pg4WKPKVkdvBUUOztxzzpuOIttMWXMCCLhImHUMSpI0pPZ?=
 =?us-ascii?Q?q5IUaKpCYVgX23SKnHdSbdd17v4uEGNJtn9430e+9Rk3BKbxH9Cmupw0QDnw?=
 =?us-ascii?Q?U1sansOSpUGnhIgzBFNhfGjoA9dU1Wu4ISNG1pjGb1Kxrgu3ICIIf81pwdRZ?=
 =?us-ascii?Q?wkNGYx+MrvtMgH9EyxREHByTZ4OA4JTAriMTfodHFuD1fxK4FmJKRCE919YT?=
 =?us-ascii?Q?SG6Gc1kO4VTFS44ZTQxQ/MwqLwB9zmZLmDdZY062eupRJC6a97eIBFT4Zuhb?=
 =?us-ascii?Q?i5A5r3oYF7c5tf2MMisV89fBgBjHqtOwSwv7j4g1D9NDnf29yV3AkyXKuZIp?=
 =?us-ascii?Q?JolKKVzLA4Ka+VTqOVVBgFwuGUD9DPh8JhOxX27ujoiZJAXu3blSuH2rZPI5?=
 =?us-ascii?Q?yF5q9i0cCdZykgU8VoD2K6EVUkFNptZ9H3qdxJHIlx1qHHaCoytVe31eaAqY?=
 =?us-ascii?Q?JrkxMfCQg3qPhLNeW+JiHnI8rT3yWCPeaqlJNqMvZaV4EiKa5mwG86Yp0ZWn?=
 =?us-ascii?Q?xQsiMTYdKfzPr9wicRUV1TPj5BkPAaSy/R5MDrjs2Vsm5sFVLZZscWTOGdh8?=
 =?us-ascii?Q?/Dz2ntph221irI3ycizPuljvnlOjcZ609uYkcSK+0doVKuXkwcz5GYljmdGc?=
 =?us-ascii?Q?TZb4A/UxEVYet2cKnS7kpynuUh/DrPB2+IkGS770HAeVJK+Je6j3j6aX+NQk?=
 =?us-ascii?Q?XwNurOzY1rV60qiH+9+zqe9J2QQJ1yQ3GvjnRXCrMdNjpiVpkr1690LvP34a?=
 =?us-ascii?Q?BV/coarrPHTQJLvbhgsoAjudc3C5TwPB8MPJZeCSo+hZGZzPpP4QbmcdBx2M?=
 =?us-ascii?Q?8rVYtyW6zpr8hqGrC1Ubsw2HJ5+DY4iQJ2gA0Rh3qMVzaKhhWE3NEpzErX7c?=
 =?us-ascii?Q?DulS6n/m0agcP9lxyxH2g9nVGfrlHK6qSAdQnQJKowXjzHxhZFWgXVn4tnsv?=
 =?us-ascii?Q?H4Aupf4290kP4ilR6kqEuSlkQE5bEsa5ny8gZ4uyCUi/GddBzlKlibKx7f/A?=
 =?us-ascii?Q?ZHoZGR7/wV3r4tKOEAgtLhzmJPQYwdoiLo+mUX3s3Ds0EtaNq62cgDQO8f0w?=
 =?us-ascii?Q?yfav/cZaTHt9vxpHrsEr/vQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5748225D94CAD8488DEBC20BA18384A8@namprd15.prod.outlook.com>
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fe4128a-ef02-43c1-c88c-08db9fa6ce8d
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2023 04:51:38.1463
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ITzM9+6g0EOs+Ui7harFaF2fpBCxLsio2IGc4bX3jm/+M6UgqKR03eHOIfRUMadwhulwcE9qKPxQ8OS9OjUS4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3769
X-Proofpoint-GUID: nUWOlZQO-2EzBazuGJkWaHFcLf1zJigZ
X-Proofpoint-ORIG-GUID: nUWOlZQO-2EzBazuGJkWaHFcLf1zJigZ
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-18_05,2023-08-17_02,2023-05-22_02
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens,

Please consider pulling the following changes for md-next on top of your
for-6.6/block branch. The major changes are:

1. Fix perf regression for raid0 large sequential writes, by Jan Kara;
2. Fix split bio iostat for raid0, by David Jeffery;
3. Various raid1 fixes, by Heinz Mauelshagen and Xueshi Hu. 

Thanks,
Song



The following changes since commit ec14a87ee1999b19d8b7ed0fa95fea80644624ae:

  blk-cgroup: Fix NULL deref caused by blkg_policy_data being installed before init (2023-08-17 19:21:05 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git tags/md-next-20230817

for you to fetch changes up to cc22b5407e9ca76adb7efeed843146510b1b72a5:

  md: raid0: account for split bio in iostat accounting (2023-08-17 21:11:31 -0700)

----------------------------------------------------------------
David Jeffery (1):
      md: raid0: account for split bio in iostat accounting

Heinz Mauelshagen (1):
      md raid1: allow writebehind to work on any leg device set WriteMostly

Jan Kara (2):
      md/raid0: Factor out helper for mapping and submitting a bio
      md/raid0: Fix performance regression for large sequential writes

Xueshi Hu (3):
      md/raid1: call free_r1bio() before allow_barrier() in raid_end_bio_io()
      md/raid1: free the r1bio before waiting for blocked rdev
      md/raid1: hold the barrier until handle_read_error() finishes

 drivers/md/raid0.c | 82 +++++++++++++++++++++++++++++++++++++++++-----------------------------------------
 drivers/md/raid1.c | 18 ++++++++++--------
 2 files changed, 51 insertions(+), 49 deletions(-)
