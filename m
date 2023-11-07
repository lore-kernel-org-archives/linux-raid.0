Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97239C4332F
	for <linux-raid@archiver.kernel.org>; Tue,  7 Nov 2023 21:12:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234062AbjKGVMW (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 7 Nov 2023 16:12:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343770AbjKGVMV (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 7 Nov 2023 16:12:21 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69DD41994
        for <linux-raid@vger.kernel.org>; Tue,  7 Nov 2023 13:12:19 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A7GeSkL023606;
        Tue, 7 Nov 2023 21:12:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=Q0Cn29Kt7Jv2kzFLHAgfBRIxWErlimu0O42SwxAdo/Q=;
 b=hhR+QfU5D73TWejkFjfIZlpoTsopZ0/Fw+yHUeUgPAbaZ7nyHKNT5+r7nGvGXWxjFby6
 PS/p/ogi6ZjGkVu6ddDZShMcy2Abvf1FirigYKmUdSR46n19PdR1gRc4+XP5ikyonjsW
 5N1UJb05Yg1LIN4eUfFSDN/8eFTlKz2NjTqRoiZhM+Pn2jc3UHOUI8xgEzKh2P15Au1/
 66hcncwvBsvcAp4XHw0pgAE4dBTkrMEvaEksxl4djAc5oTfLvAIv604peV0o/Pi8JIXT
 k8MRl+tDgnqQmtDMN21mdxaN0OC7pH7XNmTbZaRKAgKrpDhAtnWrY5yvNojEdl4Uhek0 Ng== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u679tnxn5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Nov 2023 21:12:00 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A7KsCg4002327;
        Tue, 7 Nov 2023 21:11:59 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3u5cdek4n9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Nov 2023 21:11:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kG0hldQKg5TJqNUMklJ5oPDQTMlhJs11DPry4th97MeFe6BdFVOuW9a7DPYzEugZU4De8kPDQ13lsARj8qr6NckyBrqKw+unW/LsLX7mn6kaus4mtoH1WJBlcLvJyuOyx+vBf65mjtbvhdziR/e0Fd+8LbYw7Nlt/vlghhxBJi+q1GXZQQBUMtNTzIj3BTC3ySjRbUuOm70NSQfbva5unZtn/aR8wUyfHIvHybIxX3szw5JALnuidHc8ljaeO4YuBj+Wae7D7NcP8zGDh1lEOAaoAei0s0ZgcYGRzAUuUQq0C7J/Ur2yxNsot4R4wOzio+3VL2Llz3ezW0WjAmA0ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q0Cn29Kt7Jv2kzFLHAgfBRIxWErlimu0O42SwxAdo/Q=;
 b=ciKaFaMbh/KJzRKNBUdXlVWbEF6sJ2kCoCS5jn1bNXg13zFfBXMCXngMUURp2wZACncPwKn41lulBBGhuF/V4Y8UoxhZ3dro7sNv5dR5KKJgVPDJRVlN2mKXA3VperZmVQeh4U4GgRyp7V3K0yh98tlQvDLeWxYooYVm1bXMg39a5tdMIhQpz69LjgugetuBNUgJpCrgLTeJ4RXlJHteoLh0OYZDCRvdSs5W7yoq64jzjnZYAGBdZ51UhMzzsY8U3PfNQtjNGq6cQWdhrM1C6nLwNebSdZ4mbuC3ok/JkbEEMvbFDjzxzQlP2+HGhBXJ3O3lhmUxERawlp9BgKRdbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q0Cn29Kt7Jv2kzFLHAgfBRIxWErlimu0O42SwxAdo/Q=;
 b=ZaoL2N7dYsjBSy4Vn4DY+Gq7hdQIclsaqFmtFv5Uhb+z6B6QYQGMfLhg3mueW2fos4LjMYsgB+Xh/88eFZQmQqXb5dI21psG9B2DuN+4+XF23HDwZOGmdM00ovrieTP7Tp9MIGWD+U3Kb02uDRpOvYPaHkORYxbAYX8Nm0FA3D0=
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com (2603:10b6:a03:2d7::19)
 by DS7PR10MB7226.namprd10.prod.outlook.com (2603:10b6:8:ed::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6954.28; Tue, 7 Nov 2023 21:11:56 +0000
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com
 ([fe80::915a:381e:a853:cf7f]) by SJ0PR10MB4752.namprd10.prod.outlook.com
 ([fe80::915a:381e:a853:cf7f%3]) with mapi id 15.20.6954.028; Tue, 7 Nov 2023
 21:11:56 +0000
Message-ID: <36fb534d-dac7-4480-94a5-976bcd58ec59@oracle.com>
Date:   Tue, 7 Nov 2023 13:11:54 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] md: bypass block throttle for superblock update
Content-Language: en-US
To:     Logan Gunthorpe <logang@deltatee.com>, linux-raid@vger.kernel.org
Cc:     song@kernel.org, yukuai1@huaweicloud.com
References: <20231107175736.47522-1-junxiao.bi@oracle.com>
 <20231107175736.47522-2-junxiao.bi@oracle.com>
 <9b95971b-ac76-46d4-83b8-aa1f67c6c0c9@deltatee.com>
From:   junxiao.bi@oracle.com
In-Reply-To: <9b95971b-ac76-46d4-83b8-aa1f67c6c0c9@deltatee.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0061.namprd03.prod.outlook.com
 (2603:10b6:a03:331::6) To SJ0PR10MB4752.namprd10.prod.outlook.com
 (2603:10b6:a03:2d7::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4752:EE_|DS7PR10MB7226:EE_
X-MS-Office365-Filtering-Correlation-Id: f27ab1af-ca4e-4237-c1d3-08dbdfd62c6d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5ch2r0DbN2DVg1e18nfQrU0sqyBGZlH04QR5lF1yawPRx2NRRcnU9ajEbuq6jgwHX3818mz2OORLVwJCkdgAmaDLfZtgl6DPsyBAvj3QnO1IPhl82+sTLCZonQECiTTJAin6NH3/IwXVfJsz3TeTxxG0Q0jJA+vWgNQ/PNDVsShVzyBt5cdR6Z2N47G7vtqi8yi7w9WTj4ul/5qIvirITHmErrfxem3wNGXgT8ODMitm/bVFWZDtjDIzaGIMkP3gayDK+VU+exnYPQTT7U+p+xBMst6+gHYV3gXNL1wzss4xz/slx8w8tJKKCYl8LLBc2zG8itmdr5eic85AxQsP7bvMLgJcmx8GnP0/9l7846at2y+bxVcNqWKq16K6TACKiE0wE8ftr7Y5CtqBtIshTd2sLmddfVYCtOS40Zs6lR7ZECT1exGmiPrsRvCxb5qeB8TWcLqodzGKAeJMMPAMjF7T9ul3KAXyH+PZUTtVTxsT35NcA5Z0j3ZdbDWQ8258voUY+El5vwzIi7B8/9dXR/f96urAguvdWFuVl/GqVv71Iz5DXaQ3+xLPsuRct0Fi3AMS7LNAb6V/l+F/8+0Oi4mM8m611nzerxxKHQ+WSJaCW0o/5jpKHfMUlmYYDTvB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4752.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(396003)(136003)(346002)(376002)(230922051799003)(64100799003)(451199024)(186009)(1800799009)(31686004)(2616005)(26005)(53546011)(41300700001)(6506007)(9686003)(6512007)(38100700002)(86362001)(31696002)(5660300002)(6486002)(2906002)(4326008)(83380400001)(8676002)(8936002)(478600001)(66556008)(36756003)(316002)(66946007)(66476007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WU1DMERLYWVCN25qRDVRU0FleE5udStZK3UzNzZVcXJCTjhsY0RyNi9GeHo1?=
 =?utf-8?B?L0l6dXBwWENsREZ6UWw4ZDUybkdNNVQ2b05GZGtFNERUSXFBTWZZQ21ua1dO?=
 =?utf-8?B?TW5PSVVnN0ZxcE15N1EybXJMK0JCTFZWbXd1ejZjaHZKWmtyejEreGRvVDMw?=
 =?utf-8?B?UmhkSkFlN0xhQ1hoQ2NWRERwbmNUMWNpM0lXZXVFUHIxenlPNzFNcENaTldG?=
 =?utf-8?B?N3JOZjd4VWczS2I4ZHp6bkNVN05lVnBWTThhbm1LcXZOWnVFbFNZWlJaZE85?=
 =?utf-8?B?Yk84d1BVK1Q4Y0tZaGxBNC9aTDcyQnYwbW44VG1GK3dQcnpvTHBvOFpqUCsv?=
 =?utf-8?B?KzU0c211K0cyL2wyVTdNM3lYMzMxZUg4VlhrSStsdWgzbHhWNFBldnNrQTRp?=
 =?utf-8?B?aks5NW1DOEkwYlVTRWNhd3dkMkRKRDljZWg2c1pESDlodHFPcjJQb1FtWkpM?=
 =?utf-8?B?SE1MYnUxVWdOMVFqVjR0VGh4ZUJJL1h0WVBURHJUL001dEJ1NzlCeXZUK1Zt?=
 =?utf-8?B?MU5XaXBBUW12TEx2dDduUlY0T0w4MEtPeXlJbUxaREZJK3oreDJ5cVd2NGlS?=
 =?utf-8?B?cDNhUzg3VDhYTlp6S3NCVXIrekxMblFhNjJHbXhka1ZwWU1NR085RHlGc3I1?=
 =?utf-8?B?TjZ2d2VPK3hyVHcza1NnSjFhQmlFMGJRc2gxcFFEYi9KdFJqaE5EcW0zaERG?=
 =?utf-8?B?bUx0T2k5dDlubkhEbWs2Y1J3Q2tieVJWSm5ZMFE3WjAydXVLR1JiMFJ6cXNN?=
 =?utf-8?B?aTQwOE9zdmV1L2o0RFpGU2wxdWdQa2liMkhISjJkVlk2U3lSdU5Jc2lLZzEz?=
 =?utf-8?B?RW5ER1lwalEvay9IRUhUV082YTBEUXFPbmwybnBUd0o0NEZ5TFRraE9JOXRB?=
 =?utf-8?B?aUVWS3JpRzZibzBsMkZaei95OTFJTmxmY0V0VDdDeXVjNTZEaVY4b2dXOGpN?=
 =?utf-8?B?TnY0YlFaK2swWkVScjNMTFJiZGNIS3dxWlBBWFFVYjRMcGUrd1kzWDhIbGls?=
 =?utf-8?B?L21mSVZXcFFNbTV3OEZ1RjkzYkVqL2tRSkJ2K0cyeGNXVm1DVmIxVW5paWhJ?=
 =?utf-8?B?YlBHWGJKaGpVcDNhTGFuN2lGZ2ZJZFhkN2tRbUlXd2NhUnduN2NvcWJ4VVBz?=
 =?utf-8?B?UjVCYVpCQnJoZ1d6Uk1qRGtrNXI1OHAwclptZ3BCTk12YTgvVDRFNXczcDIw?=
 =?utf-8?B?eDg3ZGtVQStHMGZmOVdScm9pUnc0UVBYbmRJRXAwVXh1V051ODJIMUdocDhI?=
 =?utf-8?B?OURmMjA4dWpvbmIydjd6a0R3d3JlVTNtTWw4L0UwYWhTdUhGMTh6a1dBVUtm?=
 =?utf-8?B?WnI4SzUrZzc1Um1MeDdxckJyMFNFMlFadnordEF1SmQvdE5PdlkraVpDTHcy?=
 =?utf-8?B?VlE2dG8zcDd0VWFpeEFaS1ozWi9wMDZscUM5cVI3NDQzNGZOVkNaRHZtb01X?=
 =?utf-8?B?UERrTHFKZ3N0Y3pyTVJES2wrb2hrQ3FYenE4NGU1TWZpQXJObU1Sdi9laCtQ?=
 =?utf-8?B?USt3ZndWRC9xYUtZYWY5eCtVS1FmWHJiRzFtbjY1UFNPUDFubUFLWEN1bDdl?=
 =?utf-8?B?QlhnQWRsMDNlNzZZczcwaG1YYlQwaTdjYTA1UXl1MGZ6K1ozaTJhY3pZTEQ3?=
 =?utf-8?B?NGRCTkFDeHRhaTlrV0k0bjdVNFhoMEN5N2hGeGZKYlQrRXJhQUk2eEJwdVRC?=
 =?utf-8?B?QXBmZGhVWWpMdjRWODFpSld6WFJ1Qlp3TnpVdXgza2VtaHY4M0FOVE9xYWVl?=
 =?utf-8?B?RGVmSWdzMVVVWEg5R014RWU4TnMyZGFLdE5ZVzlDYy9QNkt1OUcvMnNDaTNZ?=
 =?utf-8?B?MitDeFlMSXVSdmhQVVdVazFsSmpXRWhOMnVpR2wyTXkybGRldmREY3NvSjRX?=
 =?utf-8?B?TzA2cFl2YW90cDBibXFRM1lGclJBa2Rxc1pVK1RnNlJwRWZBZmJMZTN4N2Z4?=
 =?utf-8?B?WUtIM2kzTEhLRVdKU01kYlhKeExYNGRJVEhOdVRtK3JuQklKdVM1QUhZeFBs?=
 =?utf-8?B?eG13RVpRcm1SL3VaMDF1RzVCWXB5UWlTQndlUFdzMW1uUHgxRjlOajVUWHBQ?=
 =?utf-8?B?cXJhQ3VOTE5Eei80U08xMnEyOFhuVVBnMzRtVzgrVC9wYTVUc3R5bHNJbDlV?=
 =?utf-8?Q?uQUit4kTGdhpirONBG8ar00Fp?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: UTLD+QBsSLqAtzoOc662L52W8QBg7QEx5PvRfAW85nXwGKQtXjN74TR3oGM/hdytQsm5MSR55up1B665OJP36jplQQkFjmgTFhZUuv/KH3QEv/2fDrENY5WhgfFi7FVFrvpnXEG/dZIZNMF8tWyfN2h+7skwt/QbsWiYBFcnPzs+TZ8sfIMwTVrJxqC8FKX5QKX8ZLGoLBSSSEOZig/+Cy2X8PpR26VkSeDaP+4WUnu8IFp4qMjyXJ+eT+dK0dd/3Em5EDePXj8YXQiOOUQsynmtaiPywWBi8ppy6xHtHv9Wv4doI2P9t3Oygi2/BVyM8pFswhnlV/Q+7/Kp0MF/pzhDTAhGmg1duJ+/kpIE8fhW8eHzugiiyGBU45AKCyQoupiwWvP1FeONzw+MDFm+SLUVfDG4XYF95iQByj5VxJPp4DPHgGxfREc4BOXmkh6lgSBCYh4k1E4kbYd5T0ThpIVObZohMRMCGSWo5IcNGODYn+cszuEfVBPbmOMJ13klXx5Jb+FD4kGCye68PifcjFP2ASa+iQ6PU0baCIF0ON0kqjkvbcdnhQt9gAKxelj+8MegH6oMGKHwzgBNNdk0HZPjjhKSJLmKXssIpb6gZb5K7yI5spukrfk4qAcJJHAXX3HuPnj/VaQzS3HTXnDYWR91A73MjndQ3VEbwCKBZTpf7U+qX4yNlmpcxcwIBOdAB8/aFkiACCdPjSCSHoKVQuRedashdoMrskj6UOvWlFaz7N00TQ0K0u2nVeP1pkAJblqOScGzAlyqSbFdyw/3Egw0klA6pTOx8wLdD74zrN74F1q1IAZlH5eIUv5B0LEW0iasWLB9BkBJXiI6H1YV4P9BE2fMGCnyv+ewyoz1H6ioUoS2ufVp5TxpFueae5Ba
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f27ab1af-ca4e-4237-c1d3-08dbdfd62c6d
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2023 21:11:56.6038
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mqp5Zhn2USB/LrFwCOeTTIC6yvh2r4RMHPRnoboeY5KhaOYswkw6LqVt7M+WJ5MUwbdPqU3J9moG+3GClT/yEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7226
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-07_13,2023-11-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310240000
 definitions=main-2311070175
X-Proofpoint-ORIG-GUID: 9fo0CiWt-UveLiHxBEQVDg38b44oBepl
X-Proofpoint-GUID: 9fo0CiWt-UveLiHxBEQVDg38b44oBepl
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 11/7/23 11:33 AM, Logan Gunthorpe wrote:

>
> On 2023-11-07 10:57, Junxiao Bi wrote:
>> commit 5e2cf333b7bd ("md/raid5: Wait for MD_SB_CHANGE_PENDING in raid5d")
>> introduced a hung bug and got reverted in last patch, since the issue
>> that commit is fixing is due to md superblock write is throttled by wbt,
>> to fix it, we can have superblock write bypass block layer throttle.
>>
>> Fixes: 5e2cf333b7bd ("md/raid5: Wait for MD_SB_CHANGE_PENDING in raid5d")
>> Suggested-by: Yu Kuai <yukuai1@huaweicloud.com>
>> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
> This makes sense to me. However, I haven't looked at that bug in a long
> time though and I haven't tested the proposed solution to ensure the bug
> is indeed fixed.
>
> Would it not make sense to have the fixing commit first before the
> revert? So there isn't a spot in the history with a known bug?

Yea, that makes sense.

Thanks for the review.

>
> Besides that,
>
> Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
>
> Thanks!
>
> Logan
