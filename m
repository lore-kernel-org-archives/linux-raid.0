Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18D63C4332F
	for <linux-raid@archiver.kernel.org>; Fri,  3 Nov 2023 19:12:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbjKCTMN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 3 Nov 2023 15:12:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbjKCTML (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 3 Nov 2023 15:12:11 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9F7ABD
        for <linux-raid@vger.kernel.org>; Fri,  3 Nov 2023 12:12:05 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A3G7M3N001475;
        Fri, 3 Nov 2023 19:11:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=yipe84LOPdowWWwruzULEbZ8/H4+F453MK86yAEaeP0=;
 b=fWv7742fS5uYjjk5K9OgYiW27H7LRxnnmHeQBwvbJVMPBw6QZCNyVh6RGpqa5iFPacIY
 Hzh0R2pLnrQYU59MiH3g2Yc221ics1X3uGl18ARyg5Qt3ASLQCAx+lBs16Eg9p0TI+2U
 kjstB7sr1d+1PgB+1SBC1WMtOGd2dV8ptcA42AMhaO1LW+uXg9IAmpX3hqys4zOCipGO
 gUTvu7XDl2GbcLiTQu+nakkA1lDPN2D9DgQwdlOrcYn+9rkQryBwC8sTBZKxlalw/Egd
 bk861Lf1fZsUQrEMXz3eQY8M7IU+D0NqlxOkjOjN5YNypTvr8qHVlRdTyAjNcBQ/GBRU yQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u0rw2cngv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Nov 2023 19:11:31 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A3I7Xef020372;
        Fri, 3 Nov 2023 19:11:30 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3u0rrgrw15-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Nov 2023 19:11:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jvA7kXXqQDp4CM5eLjd4qp6n48uyFiJZ3gnu9Z3uEpcX/WlVaz3UQz8Q374No1s6Xfl6kB1Wo8+6Ddd+Py9/bg/ZFMI9epSG29mFWnuGJr6ufr+iK3A/lpZHINw+ojHbpVDsH81JeUcvz38Lk3mii2QcHm9OHPxum0pnhY9Qhj1Mv0BroZ4Xplb+vDD0g/fQMDf3gMd600U1kGpsMGlH74FPp7zTAXzKN36fuKvlaFqf1LN9TV3JXZNd1qyCryCumcDHzmrSEspgtn19BRW0jNY5KkeUtsLz4SBB6FXEzyVjoQad/LtDsO3e2sh34l3T1VLq7ZP1I2RVA1SNhn0+Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yipe84LOPdowWWwruzULEbZ8/H4+F453MK86yAEaeP0=;
 b=BwMlg6THcIPTVjBXewbMP47l2B02pY2vmQZtsaRHRNPo3jJFJ8yH/IlRCjSyayvAKurd/YpVW1iCtsXe9SHYOi6ZCstgaeMcBOF1ZhitQhjjUXXsHANBmJntclyhBgPK/J1dKdKb5jBosB/UxlLPa6k0NYMljQ91+aNUWPc8Nk3Um65o+6Ydf/gOw+HkBwTA+QClKb+ts2Z3Gq8Fa89/g1fKxdIXoqbSprqp+79Vqt7K/mHqT0yg9Q3LrDayErRiWHTZUxaKZnhyh5DzpwbHEf3DA+rw8Lw4icfsxMF7oJRnCjofPuR8hodiNzI6KG/Fflc1tvw4MvuYspjA0CM+9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yipe84LOPdowWWwruzULEbZ8/H4+F453MK86yAEaeP0=;
 b=IIgi8fmp8GSemnqXdCvbQYhgmlYfL/fYNPN9SawK2YtLvu/U7qXsCA8FOxTEEVQLg3vrkkNbPXnPQcJYQKMMYqtLDzji/PMHBSULx7HHWKt3fzjOepAx3kicdQyH57n3joBViOWi34C7yFKGloryDYu6/jfQqzMFs9wGR4xkQ50=
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com (2603:10b6:a03:2d7::19)
 by SJ0PR10MB5614.namprd10.prod.outlook.com (2603:10b6:a03:3d7::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.24; Fri, 3 Nov
 2023 19:11:28 +0000
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com
 ([fe80::915a:381e:a853:cf7f]) by SJ0PR10MB4752.namprd10.prod.outlook.com
 ([fe80::915a:381e:a853:cf7f%3]) with mapi id 15.20.6954.021; Fri, 3 Nov 2023
 19:11:28 +0000
Message-ID: <9ac4dd36-6232-4efa-9ca6-21a7a2d29da7@oracle.com>
Date:   Fri, 3 Nov 2023 12:11:25 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] md/raid5: fix hung by MD_SB_CHANGE_PENDING
Content-Language: en-US
To:     Yu Kuai <yukuai1@huaweicloud.com>, linux-raid@vger.kernel.org
Cc:     song@kernel.org, logang@deltatee.com,
        "yukuai (C)" <yukuai3@huawei.com>
References: <20231101230214.57190-1-junxiao.bi@oracle.com>
 <6183bbd0-09c2-3629-ed93-a7485c13e6bb@huaweicloud.com>
 <434b8632-0ec3-4b73-8146-94371a3563bb@oracle.com>
 <50024c2c-c807-3471-191d-40e0cad9db89@huaweicloud.com>
From:   junxiao.bi@oracle.com
In-Reply-To: <50024c2c-c807-3471-191d-40e0cad9db89@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PH7PR17CA0065.namprd17.prod.outlook.com
 (2603:10b6:510:325::9) To SJ0PR10MB4752.namprd10.prod.outlook.com
 (2603:10b6:a03:2d7::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4752:EE_|SJ0PR10MB5614:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f9ac44f-5f5a-4e79-1bb3-08dbdca0ae18
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3RC4iZWOzhC8PKhzm4aiGOqLnKhV22bOq2pM1xLa2NE+NmPiqKu6pqkFs4my/wIGr/EYFfA9kJNKgYq3tQ3sRHmj00Dkj4g8CmQIS/vAG6pQ9PCTg7DiTtIAttr5Vb3iyUMjxkfPKgTxWBQ+l+wCeyA+hb1VF5YyTN4Xy4FkayFQPcTjwl70i3pWCIWYRwWyukMiiebkOvlj1RrbU13eJYAMRbaSkeT2Yhhqpx7fKnxbrkGgew4qyGaCB8B4kTfZJOGJiF4WHYqLNF81hKZ79TVY4fptMHeC3yG+ePU33QhBnTJGNQph1ntReQFYgndAyJ0WI6PqL3JOl7J31RA3foPAuiw+bT4a+HiSut/LtWu4Zs9mMd0HJc4JYwgUj5osOA+IKhOUfRpvsaF2nNxUdcC8CDewR3gA4mmOotcvHVRVl6cXyfJpJF4EeA0BXVXt8DhbYhfUk+ogAE9JvA8TRZbA9PQvD6R2tiDLGAqLUTwivHoKn51R9hQJ5ikXnlLnmdNO7dhMULrmB8fwAc7k6ade+sIItJCdjQeRh5cZAuw+jXF0l1L2fi8sULJXNEfI7k87C5lp8fsgZLOkWHX9R9wwmYALYBcYJizIkPe8b10pVI8CbbEkLtx/YPnMduQg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4752.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(136003)(346002)(396003)(376002)(230922051799003)(186009)(451199024)(64100799003)(1800799009)(53546011)(6506007)(6486002)(478600001)(26005)(6666004)(31696002)(2906002)(66946007)(66556008)(66476007)(31686004)(2616005)(36756003)(6512007)(9686003)(38100700002)(41300700001)(316002)(5660300002)(86362001)(83380400001)(4326008)(8676002)(8936002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WmtRQlVTMzNvaFNEeVNmZGk1MkFuTVBSN0lyVDBZU1gyMjNzb3k3US8yRHp4?=
 =?utf-8?B?QkdKV2RtbS9ST0gxVjBRVWY2RjlFeDhGdzV0dlZoTkZudlBUVWhlaVAyUzEr?=
 =?utf-8?B?cWtTeTdrWEtQekhiSHlrdHpJWXV5UmdaTWc3WU5ra3J3eWZHTlIwWmNxcVNr?=
 =?utf-8?B?Y256UlNkNlFmQkU0RUdGd0dYalRoZzlTalZXMCtsMmFWVk1nTm5LN0x3emtH?=
 =?utf-8?B?VjkxaHhyQksxam1ueDRuVjFQeDEreGZqZThRYis2SXVzcXFuTytUcERRaGMy?=
 =?utf-8?B?b3N0VEdVblFxYmllQnM5c2Z2UG0wa1QxRkV1OXBVaThLYjhjZkltYlU5UFBQ?=
 =?utf-8?B?ZTA5RFBrN0RZdXBkU3A5VFVlUXJqcGExNWk3dERBc2JQRUd1UWdQUkNrcGV5?=
 =?utf-8?B?cjIvUmxTQ0hKcVY5WjZsZXVKa1hES2VNQUZ4eUFzcllXWE43UmVFYlZ1K2hv?=
 =?utf-8?B?WEMwT2FJOTRlek01dy9TTFlJY3JYYUpiUDlqTzR3Wmd2RkhpV01sdlFnK1lk?=
 =?utf-8?B?bHJmbjJnaWtXd1pscVFyemcrZDE2UHh3RVFRKzhuWHU4SExKZkExbjNENno5?=
 =?utf-8?B?L3VhTGNYV0hCbjM1Qm12dTJaeE1EUkFoMXlCV3ZuYzdPNnY4bnVxNXBwNmln?=
 =?utf-8?B?Tzc5MVVrR3pxMUVSY2lFR0tPOWdHeG9DQ0dxdk9VNmM2Q3h2YTlmNGhOVkJ5?=
 =?utf-8?B?Q1lDdTRjS1F2djFreXVrNFBpcXJ5bzZLeEFiQ0xoYVRtU3RyUkJjWDdIWkty?=
 =?utf-8?B?bldBTFdxSDlzbkN0QTBRb2tCeC9TblNRWmpRMjlnUWdEK3dUeDNqbVlhdStC?=
 =?utf-8?B?Y3Bwbmh0cXFCbUJnSWNtSzBHMTc2N2RiZGFyZzdRSW5QTkFBZTN5ZWdEVll3?=
 =?utf-8?B?MXFvZ0FPU3pqRnRtL3VmSVp0bVRPMVQrZUJLQk5kSVBpN0pSRGFSRjJFVUd0?=
 =?utf-8?B?OVB4cDhwMWhOWEpxUUk2bWtwSE9FUlJWU0pBM1FNczVUVlNwUDRTSHptMXdm?=
 =?utf-8?B?anNTWXJoU3FTbVNEL2h6akU2TEdXNG5GTEkrZjc3Rm42Y2NmVmEyUEJYV2Np?=
 =?utf-8?B?MDdveWFuZHVDRk5DS3kzRDdWYVc2YVBvOWRQYXh0aHdiNkR2RlFFVW9mYjdq?=
 =?utf-8?B?VW41aFBhN0RYc1RJODJmM2dwR0JKeldRRExnNml0UzJWUXBoWXZscFZiTWo1?=
 =?utf-8?B?RzVNQ1VYcDduYVd5eWtmdS9nWTV4MzFiNzA0V0pHKzdrYW5WVGpub2NMSnZh?=
 =?utf-8?B?dElHSkJoWmpOTm1zWDlWdHJzdnROYlJWeFBjV3lsNVd2aDIvcmkyR3RVOHNv?=
 =?utf-8?B?MWVBVVJWbXhsN3gyU1NIbVdsNTE3dmtEU3ExT2tEamxRVEtYd3FaOWYvdG1Q?=
 =?utf-8?B?UU40eXNmQks0disyRnM5RDM4UXN4NHlFSTZGTmpxNVhYb2wyU2xQVzVhOVdN?=
 =?utf-8?B?Wjk2TXAvWVU3Y2tnMVhWOVoydUk4ZVNsTHNnTG04YnRHdmt3bWpjcjB6di8x?=
 =?utf-8?B?UE8rTEtDZ0Qwdk5kRFRVWWpiWEpvaFhqZXh2OXVReDVnYkxHZzJtcGZCSURO?=
 =?utf-8?B?MFFGOERNSk1QNklBa1k0cWMvTXZLRUhYcHBwTG0rMk1zcmxFSWNqM3JlVGRF?=
 =?utf-8?B?ZDdUOHhhMXhzVFp4bVFTbFpQNnZPYkZNV3A2V21nanZOUmhFa2ppUXk2WkUy?=
 =?utf-8?B?dmE0Y2FIS0dGUUE1TVBmWDZwdlZYY1lyV1NxdFcxSTRvdzVNWEdUL2s2V2V2?=
 =?utf-8?B?bW5IR1QwVzVXWUt3OXBiaVJwMXZaTEkwYlN5ZnZPQW9YRlVka2lRNmplb2or?=
 =?utf-8?B?Zk5aWjBRUzg0aUdGVVVJSlVJTHZjbHIrR3I1ODRFcHFtdXpYVHpNMGJPdk1U?=
 =?utf-8?B?ek9TajluTWRlcEtoY1NxQi9tVWNPTk5RdlFJY2JtZlUycDczcStIalV5dTZM?=
 =?utf-8?B?U3l3VWMyVm9kbzlsdjV2bDBjdkt6KzRkQW5IWFg5U1BZdUxORjhGTmdqZEJQ?=
 =?utf-8?B?RHI4blowKzRMRGljTXFZdEdvNzJpMENCN21TREt3cTBCN3ZZV2E4MXU5NFNR?=
 =?utf-8?B?cmlBWkZLNVZIRlNJOXVNSDhBWmJsdzIrVWVwcWdsSDRnS1hZaWhXRXZydUNQ?=
 =?utf-8?Q?c0JDMadMlNyIhZkTcZBAIHQ5x?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: lu5I0MlPlJC9EtsxoFwImV8hFpcC2bq7sPb1xt3u8LgZv06O9X4x1cE+vTZpz/fwXV4Ig+lGfpQ6Wt4CwkJejVV0qX/Eqlk0EN30Pxi0ggkrm/FgmB0ilEOt8zFf1Hq1yqtB/emTEZUekpk6sTJDvHZTZxm9beRatoRjAxyyQoXPs/saK9ZnzUo0ms1Z8LQTj2A/SbYFEAgIn+E1WrI0wMHpdBYGzHGfvqMQ+CeCBigNaJ/vscAeS/utOuOai++n70/sKPaP1HpzDIk78YuiBDC+Vg9rbuMJRyN+mMCtU3cqfWw097oQj8AAZqcWKHbS/btqHPMe7ZqK4fyj6tC2PMUWYZ7p+63pOEK7xi+TqeMTWBDI6lVbg1mGe3/S0NDiCAEU+kDJxRD/SlL1UGeyQ9MA99U+sEzAaygF0Ua5GZSgldb3LVawmCz6AzwEE+I+kgf3g74fbuDB/mZ9RiAeZnqHn0NFTTHbcxbP+MIcRaA9hVfhZlzUXV406tziagwACe4Irb019eaaSLJs6RadXXe/f949R496c8NUugwmBOKS0TG+JjLdJ+QxBatPJHq5gPzyooCJ7RlP5QAP6ZiJyM4YJFiNHsH6FLG61BAJ1y5SVmUTt/fORLDgP1uHQOGYTb8yKTMvuRzunbAW3IUZJXVooog3P/OY9pKIwKjzMk588WKkoZs2a5RfAek2Is1OoPALdtXj8RyXdd3nW3oh7/MWLhN1rNbwOdLv8h9Xt54EJxRIaqw5BpD26dSZzB1cciBbCLWWiqwlziEInNPKmfURJHgWUpEty75F/K9domU/jvBo2AqU1V5LUBrtuoM9xiGHzisd/K3hNC2U3AaHBj8APw5VsKVquaDKy91lLs9NOzie3Xqc0v6O9upzi/UEnJBwiOTw91511KalKGCvYw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f9ac44f-5f5a-4e79-1bb3-08dbdca0ae18
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2023 19:11:27.9694
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2vAc3fQ+uMmMhG6g5r0wHWElD/0qgFqqpqFHS9yFkXLm86pWeBYEwmN6DUvFQ3GkIYAcikX/P42Zh4UNN5GUoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5614
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-03_18,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 spamscore=0
 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310240000
 definitions=main-2311030160
X-Proofpoint-GUID: bOeKVZcZVRk732L6whCoetEvxWSaQCM8
X-Proofpoint-ORIG-GUID: bOeKVZcZVRk732L6whCoetEvxWSaQCM8
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 11/2/23 12:16 AM, Yu Kuai wrote:

> Hi,
>
> 在 2023/11/02 12:32, junxiao.bi@oracle.com 写道:
>> On 11/1/23 6:24 PM, Yu Kuai wrote:
>>
>>> Hi,
>>>
>>> 在 2023/11/02 7:02, Junxiao Bi 写道:
>>>> Looks like there is a race between md_write_start() and raid5d() which
>>>
>>> Is this a real issue or just based on code review?
>>
>> It's a real issue, we see this hung in a production system, it's with 
>> v5.4, but i didn't see these function has much difference.
>>
>> crash> bt 2683
>> PID: 2683     TASK: ffff9d3b3e651f00  CPU: 65   COMMAND: "md0_raid5"
>>   #0 [ffffbd7a0252bd08] __schedule at ffffffffa8e68931
>>   #1 [ffffbd7a0252bd88] schedule at ffffffffa8e68c6f
>>   #2 [ffffbd7a0252bda8] raid5d at ffffffffc0b4df16 [raid456]
>>   #3 [ffffbd7a0252bea0] md_thread at ffffffffa8bc20b8
>>   #4 [ffffbd7a0252bf08] kthread at ffffffffa84dac05
>>   #5 [ffffbd7a0252bf50] ret_from_fork at ffffffffa9000364
>> crash> ps -m 2683
>> [ 0 00:11:08.244] [UN]  PID: 2683     TASK: ffff9d3b3e651f00 CPU: 65 
>> COMMAND: "md0_raid5"
>> crash>
>> crash> bt 96352
>> PID: 96352    TASK: ffff9cc587c95d00  CPU: 64   COMMAND: "kworker/64:0"
>>   #0 [ffffbd7a07533be0] __schedule at ffffffffa8e68931
>>   #1 [ffffbd7a07533c60] schedule at ffffffffa8e68c6f
>>   #2 [ffffbd7a07533c80] md_write_start at ffffffffa8bc47c5
>>   #3 [ffffbd7a07533ce0] raid5_make_request at ffffffffc0b4a4c9 [raid456]
>>   #4 [ffffbd7a07533dc8] md_handle_request at ffffffffa8bbfa54
>>   #5 [ffffbd7a07533e38] md_submit_flush_data at ffffffffa8bc04c1
>>   #6 [ffffbd7a07533e60] process_one_work at ffffffffa84d4289
>>   #7 [ffffbd7a07533ea8] worker_thread at ffffffffa84d50cf
>>   #8 [ffffbd7a07533f08] kthread at ffffffffa84dac05
>>   #9 [ffffbd7a07533f50] ret_from_fork at ffffffffa9000364
>> crash> ps -m 96352
>> [ 0 00:11:08.244] [UN]  PID: 96352    TASK: ffff9cc587c95d00 CPU: 64 
>> COMMAND: "kworker/64:0"
>> crash>
>> crash> bt 25542
>> PID: 25542    TASK: ffff9cb4cb528000  CPU: 32   COMMAND: "md0_resync"
>>   #0 [ffffbd7a09387c80] __schedule at ffffffffa8e68931
>>   #1 [ffffbd7a09387d00] schedule at ffffffffa8e68c6f
>>   #2 [ffffbd7a09387d20] md_do_sync at ffffffffa8bc613e
>>   #3 [ffffbd7a09387ea0] md_thread at ffffffffa8bc20b8
>>   #4 [ffffbd7a09387f08] kthread at ffffffffa84dac05
>>   #5 [ffffbd7a09387f50] ret_from_fork at ffffffffa9000364
>> crash>
>> crash> ps -m 25542
>> [ 0 00:11:18.370] [UN]  PID: 25542    TASK: ffff9cb4cb528000 CPU: 32 
>> COMMAND: "md0_resync"
>>
>>
>>>> can cause deadlock. Run into this issue while raid_check is running.
>>>>
>>>> md_write_start: raid5d:
>>>>   if (mddev->safemode == 1)
>>>>       mddev->safemode = 0;
>>>>   /* sync_checkers is always 0 when writes_pending is in per-cpu 
>>>> mode */
>>>>   if (mddev->in_sync || mddev->sync_checkers) {
>>>>       spin_lock(&mddev->lock);
>>>>       if (mddev->in_sync) {
>>>>           mddev->in_sync = 0;
>>>>           set_bit(MD_SB_CHANGE_CLEAN, &mddev->sb_flags);
>>>>           set_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags);
>>>> >>> running before md_write_start wake up it
>>>> if (mddev->sb_flags & ~(1 << MD_SB_CHANGE_PENDING)) {
>>>> spin_unlock_irq(&conf->device_lock);
>>>> md_check_recovery(mddev);
>>>> spin_lock_irq(&conf->device_lock);
>>>>
>>>> /*
>>>> * Waiting on MD_SB_CHANGE_PENDING below may deadlock
>>>> * seeing md_check_recovery() is needed to clear
>>>> * the flag when using mdmon.
>>>> */
>>>> continue;
>>>> }
>>>>
>>>> wait_event_lock_irq(mddev->sb_wait, >>>>>>>>>>> hung
>>>> !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags),
>>>> conf->device_lock);
>>>>           md_wakeup_thread(mddev->thread);
>>>>           did_change = 1;
>>>>       }
>>>>       spin_unlock(&mddev->lock);
>>>>   }
>>>>
>>>>   ...
>>>>
>>>>   wait_event(mddev->sb_wait, >>>>>>>>>> hung
>>>>      !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags) ||
>>>>      mddev->suspended);
>>>>
>>>
>>> This is not correct, if daemon thread is running, md_wakeup_thread()
>>> will make sure that daemon thread will run again, see details how
>>> THREAD_WAKEUP worked in md_thread().
>>
>> The daemon thread was waiting MD_SB_CHANGE_PENDING to be cleared, 
>> even wake up it, it will hung again as that flag is still not cleared?
>
> I aggree that daemon thread should not use wait_event(), however, take a
> look at 5e2cf333b7bd, I think this is a common issue for all
> personalities, and the better fix is that let bio submitted from
> md_write_super() bypass wbt, this is reasonable because wbt is used to
> throttle backgroup writeback io, and writing superblock should not be
> throttled by wbt.

So the fix is the following plus reverting commit 5e2cf333b7bd?


diff --git a/drivers/md/md.c b/drivers/md/md.c
index 839e79e567ee..841bd4459817 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -931,7 +931,7 @@ void md_super_write(struct mddev *mddev, struct 
md_rdev *rdev,

         bio = bio_alloc_bioset(rdev->meta_bdev ? rdev->meta_bdev : 
rdev->bdev,
                                1,
-                              REQ_OP_WRITE | REQ_SYNC | REQ_PREFLUSH | 
REQ_FUA,
+                              REQ_OP_WRITE | REQ_SYNC | REQ_IDLE | 
REQ_PREFLUSH | REQ_FUA,
                                GFP_NOIO, &mddev->sync_set);

         atomic_inc(&rdev->nr_pending);


Thanks,

Junxiao.

>
> Thanks,
> Kuai
>
>>
>> Thanks,
>>
>> Junxiao.
>>
>>>
>>> Thanks,
>>> Kuai
>>>
>>>> commit 5e2cf333b7bd ("md/raid5: Wait for MD_SB_CHANGE_PENDING in 
>>>> raid5d")
>>>> introduced this issue, since it want to a reschedule for flushing 
>>>> blk_plug,
>>>> let do it explicitly to address that issue.
>>>>
>>>> Fixes: 5e2cf333b7bd ("md/raid5: Wait for MD_SB_CHANGE_PENDING in 
>>>> raid5d")
>>>> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
>>>> ---
>>>>   block/blk-core.c   | 1 +
>>>>   drivers/md/raid5.c | 9 +++++----
>>>>   2 files changed, 6 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/block/blk-core.c b/block/blk-core.c
>>>> index 9d51e9894ece..bc8757a78477 100644
>>>> --- a/block/blk-core.c
>>>> +++ b/block/blk-core.c
>>>> @@ -1149,6 +1149,7 @@ void __blk_flush_plug(struct blk_plug *plug, 
>>>> bool from_schedule)
>>>>       if (unlikely(!rq_list_empty(plug->cached_rq)))
>>>>           blk_mq_free_plug_rqs(plug);
>>>>   }
>>>> +EXPORT_SYMBOL(__blk_flush_plug);
>>>>     /**
>>>>    * blk_finish_plug - mark the end of a batch of submitted I/O
>>>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>>>> index 284cd71bcc68..25ec82f2813f 100644
>>>> --- a/drivers/md/raid5.c
>>>> +++ b/drivers/md/raid5.c
>>>> @@ -6850,11 +6850,12 @@ static void raid5d(struct md_thread *thread)
>>>>                * the flag when using mdmon.
>>>>                */
>>>>               continue;
>>>> +        } else {
>>>> +            spin_unlock_irq(&conf->device_lock);
>>>> +            blk_flush_plug(current);
>>>> +            cond_resched();
>>>> +            spin_lock_irq(&conf->device_lock);
>>>>           }
>>>> -
>>>> -        wait_event_lock_irq(mddev->sb_wait,
>>>> -            !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags),
>>>> -            conf->device_lock);
>>>>       }
>>>>       pr_debug("%d stripes handled\n", handled);
>>>>
>>>
>> .
>>
>
