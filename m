Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-22.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 281CAC433EF
	for <linux-raid@archiver.kernel.org>; Wed, 22 Sep 2021 17:38:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 035DC6127B
	for <linux-raid@archiver.kernel.org>; Wed, 22 Sep 2021 17:38:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236815AbhIVRju (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 22 Sep 2021 13:39:50 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:17242 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236701AbhIVRjt (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Wed, 22 Sep 2021 13:39:49 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18MHSuw4027729
        for <linux-raid@vger.kernel.org>; Wed, 22 Sep 2021 10:38:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=vM6MFwC/h2VL91O06LgabUnM307884bnSXJOLH0wYOM=;
 b=XDNNrEMtJViLiiZNaeJ52+W4akBB6krhVc/ZyZD2sGxCckjGd3FivET7cIOR0h6QaEZD
 dfw2abkF3W641gBtC8V7Ou6qYgLenx/BAt2e75v2q3LLqoKG9hJ6Cvq4Qb9F+MFRdRs4
 LwVAPEGtEJAZvgPe8kKF60I3O5g+1TlnLmg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3b88bd8esd-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-raid@vger.kernel.org>; Wed, 22 Sep 2021 10:38:16 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Wed, 22 Sep 2021 10:38:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L+yLa+hMLGhhVvrAkBda3/Tp7xizIcGLYIyAlgH8aZPK5a+Xl6KyA1j12HzlH75weRl5Jqsx69Nie3wbdaZ6LLWpVhZT54mkJeHy2AqU9fSjemFqdYSA0y52mMo9MmWWOut0MiOvv022bTHlJV+sJBdc2NHg3rGnhamYbbcLPwC9a1IgMdIISoNPhrXOwk8NEOfiHk5azDvPavhak1bB6Rs2rHWMMwCCULmA7cYHY3qOwzGePhLlBRaB3aUMmqsV+sFM57hlUQnZJZnG2gR30ZXVicc5vWoxm+RWAtUjvVw8JVwLU4gJGuo2qOuC5TvMigFqG6r6aqjpUQALPgMujQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=vM6MFwC/h2VL91O06LgabUnM307884bnSXJOLH0wYOM=;
 b=EVHUEkDdQfSIwe7SljLZ31X5830TxBK/O5SiLG5JDYEUvlSuyDt2UNWKhs+AmswlFIQ5ntHvQZBofMwWouGFU1NPtMjn8ioZ5zqW4CZIRWtr1zOXJiweXjIUHc+2M8xHlAA1ZkCvbVUwE3TRZXoQa/2wehYEKFmutg68oqYB5tfZwLIcZbtxLpNe6MWOP4QONy9hBoI+aYX9n01S1L1c0zGQ2JgFjYQ5/NTZgkqjalSvsKpVTOVCyhPqn05DVZ2bgU88hYV8h8hS76uZRew/CK4UBAI+MhciVYtan+xtGgaJcXe0S4/HvPZTELUcQtcYCaXOXS7LLZiKvYa1q2jg+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Wed, 22 Sep
 2021 17:38:11 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7d66:9b36:b482:af0f]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7d66:9b36:b482:af0f%8]) with mapi id 15.20.4544.015; Wed, 22 Sep 2021
 17:38:11 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jens Axboe <axboe@kernel.dk>
CC:     linux-raid <linux-raid@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: [GIT PULL] md-fixes 20210922
Thread-Topic: [GIT PULL] md-fixes 20210922
Thread-Index: AQHXr8xvj7tVlHQla0SV4o7KJKRolKuwOi2AgAAXcgA=
Date:   Wed, 22 Sep 2021 17:38:11 +0000
Message-ID: <DE9C1858-5F06-4E1F-A842-19A6B70D3F4F@fb.com>
References: <A739EDD6-BF73-458E-B674-D426564E13C0@fb.com>
 <7f6f82a2-0f10-3648-e6ae-4a66e1e50bbb@kernel.dk>
In-Reply-To: <7f6f82a2-0f10-3648-e6ae-4a66e1e50bbb@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=fb.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ab401d45-d246-4d0c-f6e2-08d97defbf9a
x-ms-traffictypediagnostic: SA1PR15MB5109:
x-microsoft-antispam-prvs: <SA1PR15MB5109A36135ABF1038EEF74A1B3A29@SA1PR15MB5109.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: E06hQLBQzuCtN7GBM6KLrh9qh9ggfE2OdPwFzz79ktsKz4o1M2vfSlOC0rR4CiuiKSGO6JjuMjZzDNGp/xSNi90DpCh4yR0SvPv7Gu2BMGRaiSX2AVK58HJRnXuiwY/taAWaC4yy+cIaDz6USeQoKR4x7VxhJXXwpikFxotRHkDYi1NvmN32IcHSlo/xFD7ejH+/C+qt3GUbRH7hOaI6EFgc7YReBsf0OL5b1xkghkV+Atk7O9gea2ElZKFniQjhHHcyWoTF3UYuLjoreC1x/3RwZPVbCaFOposUvhQv5Lo7pVTFwmcEsjR5M9701YQP7V8SleMuB34xuGrnvyidX6ZYtWGijlrwF3kGafTdSpR/w7RTNUYUgKQgUmjam8HaSemP+W7se0bxudlc3D4rVEK1O9MsT16kPw+tUXcjf+7eNFrFcYLzKkFO0c5sCBz6HRbsgnlc14Z0XQnd1c5qVVcmsd8Cbn++SxdIKL0bgFTOJ07yYSkRjG4LocBJx9V9lpYGWLE3MWjW61f5sXJI7qcRsV9VmYd/ZWpTEJgIQb10Rpfx1xLsjABTLW3ME0ka6iGNfFd4Fq5YLTkJQAmgYNOTXYQMnOqNfqLFpbVWav9ARTHnZsLsUd2mczw3VyzbGwX+mF/smW6dsDgvs+X+q9Y+t5sShR1+v/XEKjG8B6aQ2ZmBBnVguHDCQH9wTG0SBKO6SiKDiiA/W2KAtxEzWwHwUPjdYlBOW12akalyV/ZcOkP6YN1IVGq9Ct/DZUaHixbLrXoxnfp65+RRT8ZT4VsTIXr0VEmZ7AqSI4jJmNZj+v2j4GYS2c8sF4P+4YQo/P6kgz68VSqKrIP8X12tTA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(122000001)(6486002)(8676002)(86362001)(6506007)(53546011)(38100700002)(6916009)(508600001)(36756003)(91956017)(4326008)(316002)(76116006)(71200400001)(186003)(38070700005)(54906003)(83380400001)(2906002)(66476007)(64756008)(2616005)(6512007)(33656002)(5660300002)(66556008)(966005)(8936002)(66946007)(66446008)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+1r0lfs1f/2PxZt7HbBF4VhRyfsryGIDm3ml2NuDoKMZyITVDCltCOjobyKd?=
 =?us-ascii?Q?DI6bE2runQwdR8YzrCSdmOWhIIZ7epBzb+4RV1V8+TToK76E6e85bh0fvrEo?=
 =?us-ascii?Q?ieOJ5nFF8YIDPecEg6Lm4eJs8LjG821BUCeknwA4tuY36nBBGMxWyPMUlFlm?=
 =?us-ascii?Q?Hq8BscCrmP8PPk9Gd/r6vdmNW2gTqsxr61Xyidw0oMJkTDIJpWCBv6dJrFWn?=
 =?us-ascii?Q?zdV3OnItrDpExq+rI6gwSgWCUW7bXh18UkMpO3Db+PDXeG2xy+SMKUYU8Lb0?=
 =?us-ascii?Q?kGAxk8KnyHYAq+CPzDLfWxcRFMswMih2h5vPD3TzyNcq5yWZpWiRF4IDs6jS?=
 =?us-ascii?Q?OMWQ80AaB3Dj2+92QGGXbQ1hJgT9dmQAC6BRa9U/bm5UhpyWXmyT+18wgwPr?=
 =?us-ascii?Q?jkMGgd1Dzp3NTloyBLHHCSjajw1aSnmCCQX9b3JTAgWbx8XeJBP7PfOQXEiL?=
 =?us-ascii?Q?UDLwtyqgF5q5IFb9vatxUbmGS01AaQV+l6sn1IIaDGq70/aum5Fhc54zwNud?=
 =?us-ascii?Q?KjYbjzu/d5/d+BnKCCxmktopVDRiplG0Wy50um+LxtgmIBK2Y8JjALr5BwX3?=
 =?us-ascii?Q?LhAo5f+puEFwvCfLWuxmQ23cASElD+c2JHgiIKl7hteaWOv5S+clYXFf526z?=
 =?us-ascii?Q?PebnZ6PObmw7mEeKDUznHIn3a8tD53a1uLp5RfzIi6/Rr7BdIKr2eNPzYaBk?=
 =?us-ascii?Q?PJI69IqocveAQwLJWflmBU/nVjPDKI+f1aahSU62hem4mOxmIPIwr4LlMylp?=
 =?us-ascii?Q?+FDMlPH4/mogdlpBKPDx0fzPex4P4S3zgCL1lClil6amykIcl+JbOnbraEn0?=
 =?us-ascii?Q?QuxwM0WARbDiA0Ey2gnG98czNSxZBbig4iC4rJ/F+DHLnKq53Onammoblpd2?=
 =?us-ascii?Q?g0F4R5D7CHO/5/jKbzM3PId5YAXp5pfN6rc26KByepsff370U4xDT9Japsht?=
 =?us-ascii?Q?CgYWW3WdsfFYHluAT03rcee41lwYNV3eQaImWZILDSP4IyV6aSEpyrV1o9bK?=
 =?us-ascii?Q?w81BdowjTm7684qtnO1X3+r0TUuoN25W926D/NmSTX7SvkaAJ2IJcefvP5SI?=
 =?us-ascii?Q?M9NVHoadS9KlJlBHG7YcM0hqSVgsoGWoz0r4JrQeTz2qcHd/BMxPleQcl2oz?=
 =?us-ascii?Q?BT+3nlU6Dy1YfwSdFNxyBfR57Tq7SNwMUGmyH+WR1FDArSXj+5uCsLvVq9j2?=
 =?us-ascii?Q?Hg+W/npW+kyXvP1T/31rw8tqXx8Zm9pYH6OizoN5IqWl+0HBpy44R3g+jWs8?=
 =?us-ascii?Q?fHfNk9DbfWWXjfU/WaDOLeHkDhYWKr/7fKbu8IDUwB9ablSLfcgOYAf3Eak2?=
 =?us-ascii?Q?H/Jce0ytPhqIArY/xg2eL1o9O8sHlLjKKHyu55GM8Ji/AVBCfM1WtnuBReel?=
 =?us-ascii?Q?xtpfxPc=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1D7DC230F0FC9A44AC34024C62134F89@namprd15.prod.outlook.com>
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab401d45-d246-4d0c-f6e2-08d97defbf9a
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2021 17:38:11.3651
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iBuDe6qR45iEMy2rvjWoK5QEubrooXfNtA14ZHOBBHsTOZ1gZCgGJEeWWZPNdhhXM2aDmIwhl+acQevDFeVJDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5109
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: ta9DM-lnsmmPXVhT2xAif4Yl0jwCdsaA
X-Proofpoint-GUID: ta9DM-lnsmmPXVhT2xAif4Yl0jwCdsaA
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-22_06,2021-09-22_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 bulkscore=0 impostorscore=0 malwarescore=0
 adultscore=0 spamscore=0 priorityscore=1501 clxscore=1015 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109200000 definitions=main-2109220115
X-FB-Internal: deliver
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> On Sep 22, 2021, at 9:14 AM, Jens Axboe <axboe@kernel.dk> wrote:
> 
> On 9/22/21 10:10 AM, Song Liu wrote:
>> Hi Jens, 
>> 
>> Please consider pulling the following changes for md-fixes on top of your 
>> block-5.15 branch. The changes are:
>>  1. Fix lock order reversal in md_alloc. (Christoph)
>>  2. Handle add_disk error in md_alloc. (Luis)
>>  3. Refactor md sysfs attrs, included because of dependency with 1 and 2. 
>>     (Christoph). 
> 
> I don't think the error handling for add_disk is prudent at this point,
> that's something that should go in with the 5.16 cycle. It's been like
> that forever, nothing that warrants pushing this for 5.15 at all.

Hmm... I see. The WARN_ON_ONCE at the end of device_add_disk() should be
enough. Then we just need the first commit. Could you please pull the 
following change instead? 

  1. Fix lock order reversal in md_alloc. (Christoph)

Thanks,
Song


The following changes since commit 858560b27645e7e97aca37ee8f232cccd658fbd2:

  blk-cgroup: fix UAF by grabbing blkcg lock before destroying blkg pd (2021-09-15 12:03:18 -0600)

are available in the Git repository at:

   https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-fixes

for you to fetch changes up to 7df835a32a8bedf7ce88efcfa7c9b245b52ff139:

  md: fix a lock order reversal in md_alloc (2021-09-22 08:45:58 -0700)

----------------------------------------------------------------
Christoph Hellwig (1):
      md: fix a lock order reversal in md_alloc

 drivers/md/md.c | 5 -----
 1 file changed, 5 deletions(-)

