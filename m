Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C38A5C4332F
	for <linux-raid@archiver.kernel.org>; Thu,  2 Nov 2023 04:32:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348462AbjKBEcw (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 2 Nov 2023 00:32:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348268AbjKBEcv (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 2 Nov 2023 00:32:51 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42955DC
        for <linux-raid@vger.kernel.org>; Wed,  1 Nov 2023 21:32:48 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A1MiIJM014130;
        Thu, 2 Nov 2023 04:32:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=Ofumb8ptNNxOnYWw6rvYZ0GUxn5nqLdc8nCG1+GYL6o=;
 b=vEGUQl0cOYU1ZoHbCEpLdtFOa3YPvBD4/8sgqqXxsxmq2TiA4B7fX9t+Tf/2YbB2cu1s
 7idydd/SYQ+QlrSwVhRgZ9yJCX5h4U0VNMZTqZhp8tFV+WJZik1USHrcnOULFm2YjbYZ
 p6AWBUv7aEovAf5hbmkGiX/BPYFJVkziyByQsPIvil2EhxewjqUBcm0g6Es8IdblxoBq
 zTBvkXiej+13EISilkzdSOj3WHuxwFas4UWcML6O5/dGgDthON2KLfTWtFFflcdOuEp7
 GM93Frx5wS/0tpyQbbL/3ka3u7+C2U4N7WfvjWeValruhwpOADhtrazym7vwOZSzKKiW pw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u0s7c0u1h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Nov 2023 04:32:15 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A22uFKU022512;
        Thu, 2 Nov 2023 04:32:14 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2041.outbound.protection.outlook.com [104.47.57.41])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3u0rr805br-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Nov 2023 04:32:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DSPxDVuYwHz50vqD+lRWetcQLhHWgQdNxHKHPSFJQMhggG5cZlG4cSwyIwdRUaSwP/B3ANpyoZ592yTG2dgO5A9TjOUXhxw7xcCoVugLR+P3xi4qA2+W1BGpgU9THMbiqbinfL9f3IH7oGhwoguAhWxhHJeX8DcOQ6a2e4XpYQn2zYRtHkjdJKEAoMD/O0RMfZ3952zMxf2txmaBt+b6WNs2d2LUtYMin7GCb/UZIUKX+3umZ8TYavlVbN2+flEDe9gHSKhyPU/rS6OWSYxkRSlIwAbtDy0OLv+IvNZ34G3JT9kcT4wYb6l7VpC4n7fEnQw6aR879mEuozaZMFZMWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ofumb8ptNNxOnYWw6rvYZ0GUxn5nqLdc8nCG1+GYL6o=;
 b=h5vC+ZuTqQBQDerqqjRu8g++2HtQjRQHI66c//oPVDNaTmTdqeoVMQ1Pr2Pndc8TId6ai6SbpdqIzvWlniEn92ETfSKal57o40E3t4VY9NGkKCwwURjcTAL+2UD5/5Stp04/uZ1iOOW1Hhyy2ZcyWLNjicOaoIm3oSmWaAHQ2NdOIdfep0Ktp5bckIzvZOWOXSv3U/hnfR6bSFDYb4k+1m0vCoHs9y9iQRdOFwymzhK+9I71BDQWSGFrxQc/Grm7y6oPJsrc0+uFXC6xmrI8SwyZjauxUPeXChLIw28xorCf5c8GYG0U0TYIF8Xy4jnTsbx9bNMNu1vpZz7INZhC9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ofumb8ptNNxOnYWw6rvYZ0GUxn5nqLdc8nCG1+GYL6o=;
 b=RWgB0pDxCv05uGS96MlFsAHoHkbvGFOvcgeiKb/V40JDW/9QH1QfVEd1o28a9ELVYGazukm/wTQvPJsC/Tc4CjZ0ZuWDR7L9uN/mafFMJlMqwzbyTdf0RsWK2x8a5IZGuyGRt3DFDlX2EEiA1Ydu2OvJUWvQ5y8eYQujtbO79P4=
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com (2603:10b6:a03:2d7::19)
 by DS7PR10MB7227.namprd10.prod.outlook.com (2603:10b6:8:db::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.33; Thu, 2 Nov
 2023 04:32:12 +0000
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com
 ([fe80::915a:381e:a853:cf7f]) by SJ0PR10MB4752.namprd10.prod.outlook.com
 ([fe80::915a:381e:a853:cf7f%3]) with mapi id 15.20.6907.032; Thu, 2 Nov 2023
 04:32:12 +0000
Message-ID: <434b8632-0ec3-4b73-8146-94371a3563bb@oracle.com>
Date:   Wed, 1 Nov 2023 21:32:08 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] md/raid5: fix hung by MD_SB_CHANGE_PENDING
Content-Language: en-US
To:     Yu Kuai <yukuai1@huaweicloud.com>, linux-raid@vger.kernel.org
Cc:     song@kernel.org, logang@deltatee.com,
        "yukuai (C)" <yukuai3@huawei.com>
References: <20231101230214.57190-1-junxiao.bi@oracle.com>
 <6183bbd0-09c2-3629-ed93-a7485c13e6bb@huaweicloud.com>
From:   junxiao.bi@oracle.com
In-Reply-To: <6183bbd0-09c2-3629-ed93-a7485c13e6bb@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR22CA0004.namprd22.prod.outlook.com
 (2603:10b6:208:238::9) To SJ0PR10MB4752.namprd10.prod.outlook.com
 (2603:10b6:a03:2d7::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4752:EE_|DS7PR10MB7227:EE_
X-MS-Office365-Filtering-Correlation-Id: 295e460f-c492-4aaf-3b68-08dbdb5caeae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +ebJbRnrzWG+kszwAGaEwjTLyJ2ftBncj3Er8+kTK0Fo6jXco6qd9TuQ8xLCI2NwK/9bJyUxsHK34KzuExr4DVQNvVyW9y/QXAer5WBKXqx0nWn0vaJhHz613fW/fahwIZRmQpJjgsAXjSuCImZrTaCZ/F6ScqCZ6h5P0KV99O7n2tHOQc7BPnU6PQ8sgVtvOU3LRwPwV+rjADUYJxSjbPYDKaicAH3AQ4vgahIkYelel3eWlWZRtPxnVzrGT0N4epYx2SSEC0uI4lt9fyx8hKehLn/7u5zELS085jiqm+P9hkX+Nos/bAuokoFvfJSOL+AsU/RGwiSQ8ntd1LPuAWxrnKdTkJEiFrIiA1ANi2A2UEYLxacpaWdkxl6SmRojS+nYsWmr+Qq0xNhhFGh7TeiSZbBgdcOWzlvvV6K/5IyWpCDOy0hsePFwCt9F9qkG5BydRfXWJcaSwLnWKEgAEQ48aow+aVi381qiZhphanNKzRxl2GDgAeaC6Ep+OTBfl+qkN6vXZza8M3LIpX23Ny8KNfx0dgQLlW0I/hK2SeP7FJyJVtxdA5gk5FsdTb90SIp6p4Ov/xg8AemPPBiKxg6/eiAZtl0P+SgKs9NT+62Q3Wk4BJClt64kh1nuqS4a
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4752.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(366004)(39860400002)(396003)(346002)(230922051799003)(64100799003)(186009)(451199024)(1800799009)(26005)(31686004)(2906002)(38100700002)(31696002)(53546011)(86362001)(66946007)(36756003)(5660300002)(8676002)(8936002)(2616005)(6666004)(4326008)(66476007)(6486002)(66556008)(316002)(6512007)(6506007)(83380400001)(9686003)(41300700001)(478600001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q0VoUmo0blJpb0t0SlNjL3A4dXZWN3A3dE5DajNuem93RlJsZDFod3J1a3pm?=
 =?utf-8?B?WDRFSjNWK0RKbENKTDZ4VHNUNWZ3R1JLeUJyLzJzays5RlNqeXJXWDdDREpC?=
 =?utf-8?B?ZXhubUQyMlRFTjEvZE1qRWhmdHMzRzJWcUJoa3dNRStPbVA2QWJJOW1xc29r?=
 =?utf-8?B?bTdUdTNPTU1KTk5IMzZYNTVwL3M3VExiaWN3cnkzbnB0b1RxYWNRMXB5WjNz?=
 =?utf-8?B?Y0QzcndDR0U2MGRVVnVMamlTUklzc1dTdVJXdXdLOS9may9tMWtzSWFObGNq?=
 =?utf-8?B?aTJ4ZFlMVTZFM21OV1lWUGNwSEVSeWZtdmphSThudCsrc1V0L2ZlVE5pdkw0?=
 =?utf-8?B?SkJmd1kzakpERzl3WDR5eVZaR0M0T0w2YitGYU9tajFQMGp3ZGE0VjdtSlB0?=
 =?utf-8?B?M05MbmZCRnRCT29QRzF1bFA3QTczNytsTUk2R3hvVkdKblAwU2RBclRiOVZW?=
 =?utf-8?B?MUh1anh4dS9HTDBoNXhxU0RDWUhQVHFrLzYzdDlRVlh5UUlPV3NCMW5FbWVv?=
 =?utf-8?B?eEdwV1ovOUhHZXNZUitiWEdjUUx2OWZwbTVMbHBsUm9jODc1U01vMzdqSmpO?=
 =?utf-8?B?a2JTVU91cnl2WWk2SUNrZUZ4SHcrUkJFbkJMbFRSYjlBNThTS0xnL0hXS21K?=
 =?utf-8?B?TFJXdHp4SFYxUlZETzAxbkVLa0NHYjNrMGRpdFh6anNOTC9QbGd4bUFkbzJE?=
 =?utf-8?B?ZGJuUVlPVklCWEppRnUxNldnWGk5VU1FYkk4bkZmd202R0NFV05TbnNseitJ?=
 =?utf-8?B?MVdqSnJPRk5ZL0Fuc0ZsU000OE9teDRSbStlc0FuZkJwQ1NRL3VRVXFFcHpM?=
 =?utf-8?B?OHVDeGJXMXRlak93YjRKdE5kR1dHNUhzRFVvTDErL09oSjAxdXhjaG0vZlps?=
 =?utf-8?B?UzNINFJ0d1Z4VENMS3lBaGlzaVZNS1FTZyt3L2J2TUhaN0Q0YnM3MGFCOWM2?=
 =?utf-8?B?Rm91bUkraCtJMGJRdHlyRXBDM2lvTDNXd2xPMFJrODkxeGQxY0hsMjl0TDVL?=
 =?utf-8?B?YXV1U3dqNFpWbXFMMEJxVEYrOWZnSTFVMDAwZ0pJOFV3WGg2L3lld3hYOEpt?=
 =?utf-8?B?Skh6QitXUkwvWTFsbVdBUzUzRGVSb2lCb0JJUW4wWHFWWk9kVkFaRXF6UlZD?=
 =?utf-8?B?WkliclhXZ2hSUHlUV2pkb3VLT2E1TVRHY0kyYkRQaUxzRXRteEJwdTNRVk4r?=
 =?utf-8?B?T3MrYTUrcElmZnhZK3YxdDErVG9EYStycjZKM05xQ1hDaFJoTUVhRnRPR0Ix?=
 =?utf-8?B?K3BYUm9SbzhGYVJQcTgvKy9uR2M3aTEwdHY0MVczU3g3SytrelhIWFRRTm5T?=
 =?utf-8?B?YkVrc1p0ZGNmVVBtSTdnVytXMHIxRm55ZjVCWG52ZmN5bUI1eklqTTBhQlRD?=
 =?utf-8?B?dUpLQUpoemVrYmFVUjJmQlhGTU55RU85MGFpVlo1cml4ZWtnRE9kMTZPNVEz?=
 =?utf-8?B?MUJ3WFEybHd4b0NPL2s2a2l3dFRqZnlSWWRwcU8xRUJpTXlCSytrTVhIT0ZZ?=
 =?utf-8?B?bG9vZjd6YTJaazhGZGNwU0FocmxHTGEyMzB3VVZ1aVkraGNpenJWWWR1TEQ0?=
 =?utf-8?B?Wlh3Yi9NZEdyR01TYWM4YjE2bklvQ0tsdTZVUTVhSDdVbjlXK3B2WFhOUEJN?=
 =?utf-8?B?VDFHWlZ3bDFXTGhJU0MzV2FMTkZ4dEVISnJLTHYzMVkvTUR0aEhManJWRDFw?=
 =?utf-8?B?L2Q0TThsSS9OdkN0Q2g3ZkFNbW13dGNRRTV3SDR6UmNxTW02aW5xajNiZ1p6?=
 =?utf-8?B?QkxzdkVNRERWRzhLeENmVjc2VzFybmorQmdxUHhydDlkU1JzNEw4TE9GeTJW?=
 =?utf-8?B?cXN0MGZ0MTMzTXhvN2o0dnNWb2dJVmpISXlHMWhZdWNyTmlBS1dWRDZrTkFy?=
 =?utf-8?B?OUw4VGdVbU9RRXA3Vzd4UlhONmltM3RuU3VLeU00dmJ1a3p6V1RtUVBLQjYz?=
 =?utf-8?B?ellMQzYxWlMvMEVsb2NNOWJqYkE4Wkc5K3R4a21jb0xnZG8rRS9md2hLQi9o?=
 =?utf-8?B?c1NYTS9zcTlqQTZQWERFa3FyUVV0M1NzVjVjTXMrQWVuV0EzT1FwZHFGRjBE?=
 =?utf-8?B?azN1TFh2ZG1NWFBNL2I2ZHFOTGFCK3ZyY05NZnVnUmtET3hoZTBLd3VNVWQv?=
 =?utf-8?Q?CsXRAvY2ZIkMKQ6ghPquKvEM2?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 0WfcPx6LUuHRoHlh9XWPDD2leJioCyyNp8nOuIsoPCWeCNZTaCY0QPgBUpFS2MlUWJDYBuTfRc02+IS/MwM/nEW67KfMVUIbWX9NXf/+aF9o5I9qZphbiYfx4PL1+J6iKJoSug5gsrbSSTVOMYsfkVLgXGH7gsBKCm74/sYyHW+CKH2LZHznQKsam61bmeAZ8jbOq2KdjEMuNUGG33Nm5ZrCj6dwN2GNfh1iXGxuVv9NDIk0fwwF4sxX3I4u7+PyXjfbJ4fYceTk/1viSZcfixqFL+18/DHQovYvV56YO8g0Vt+wpH+I9B/PiPQZHuzRxumnEEL5Poi4M4CEgPBMB6RkxuIpvmrcYvOhZAGZrTJVYrSElc3OyO8TpNu2odfoZ5I27gsv1lSx9f8k1mGE5+9cX4MYs3AZgAkEXEnuo7YyUovwF4aHn9ttXXsSAX4i3sOsxmVsO16LW4bZzRKa2VDvWJM33Ff++OMO2o2k5smLWGyCXjAij6ndpwduTeaK8EQ8TfyuheDkVku2DY36TCxBrVaW0uPfAUpMtXkzh9si56Ta+fZTjlQBKCDj0Iya11T8czzcgdCztdk0PXjN4rsUydPnUMTmDlTA4QhdQ2izoY/RrtS0y+4vTZcGw20ewKf120xak+xOPBTHscCqmcQ9rFxp2gIl1KbOR/q1YGhy3iXEZOuvz2823v6yo6nuTn2Bu+lIjYD1zAZSyPoEo6P4oJ7YgDtRALWPQmzxmp6Kvy3f4Wx8NQSojuYXbyC0h/s3sU6yFm4EPdpsgB73+2IQyyj8ZpPJcDuH9aBogj9UCozRQul5mgS7z2esiHbefisc+Wb96utNBYoSt6rcHRFvukfyVQVRIDMS7CsILzF3jCiAvcWUAIza51NYp/degk+h1MDKfbO70VMUwdNFKQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 295e460f-c492-4aaf-3b68-08dbdb5caeae
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2023 04:32:11.9434
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pDbpvjWsYuqOxMN/v7KC1/378v//T2VZDUMIacuomC/9LNpx24cWKPrJN4x/0+573BU/5jqgoU0AVkM+tCmM/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7227
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-01_23,2023-11-01_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2311020035
X-Proofpoint-GUID: cREQa_qYIBRiUWcvKu2HRwUFAzAD_tyV
X-Proofpoint-ORIG-GUID: cREQa_qYIBRiUWcvKu2HRwUFAzAD_tyV
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 11/1/23 6:24 PM, Yu Kuai wrote:

> Hi,
>
> 在 2023/11/02 7:02, Junxiao Bi 写道:
>> Looks like there is a race between md_write_start() and raid5d() which
>
> Is this a real issue or just based on code review?

It's a real issue, we see this hung in a production system, it's with 
v5.4, but i didn't see these function has much difference.

crash> bt 2683
PID: 2683     TASK: ffff9d3b3e651f00  CPU: 65   COMMAND: "md0_raid5"
  #0 [ffffbd7a0252bd08] __schedule at ffffffffa8e68931
  #1 [ffffbd7a0252bd88] schedule at ffffffffa8e68c6f
  #2 [ffffbd7a0252bda8] raid5d at ffffffffc0b4df16 [raid456]
  #3 [ffffbd7a0252bea0] md_thread at ffffffffa8bc20b8
  #4 [ffffbd7a0252bf08] kthread at ffffffffa84dac05
  #5 [ffffbd7a0252bf50] ret_from_fork at ffffffffa9000364
crash> ps -m 2683
[ 0 00:11:08.244] [UN]  PID: 2683     TASK: ffff9d3b3e651f00  CPU: 65   
COMMAND: "md0_raid5"
crash>
crash> bt 96352
PID: 96352    TASK: ffff9cc587c95d00  CPU: 64   COMMAND: "kworker/64:0"
  #0 [ffffbd7a07533be0] __schedule at ffffffffa8e68931
  #1 [ffffbd7a07533c60] schedule at ffffffffa8e68c6f
  #2 [ffffbd7a07533c80] md_write_start at ffffffffa8bc47c5
  #3 [ffffbd7a07533ce0] raid5_make_request at ffffffffc0b4a4c9 [raid456]
  #4 [ffffbd7a07533dc8] md_handle_request at ffffffffa8bbfa54
  #5 [ffffbd7a07533e38] md_submit_flush_data at ffffffffa8bc04c1
  #6 [ffffbd7a07533e60] process_one_work at ffffffffa84d4289
  #7 [ffffbd7a07533ea8] worker_thread at ffffffffa84d50cf
  #8 [ffffbd7a07533f08] kthread at ffffffffa84dac05
  #9 [ffffbd7a07533f50] ret_from_fork at ffffffffa9000364
crash> ps -m 96352
[ 0 00:11:08.244] [UN]  PID: 96352    TASK: ffff9cc587c95d00  CPU: 64   
COMMAND: "kworker/64:0"
crash>
crash> bt 25542
PID: 25542    TASK: ffff9cb4cb528000  CPU: 32   COMMAND: "md0_resync"
  #0 [ffffbd7a09387c80] __schedule at ffffffffa8e68931
  #1 [ffffbd7a09387d00] schedule at ffffffffa8e68c6f
  #2 [ffffbd7a09387d20] md_do_sync at ffffffffa8bc613e
  #3 [ffffbd7a09387ea0] md_thread at ffffffffa8bc20b8
  #4 [ffffbd7a09387f08] kthread at ffffffffa84dac05
  #5 [ffffbd7a09387f50] ret_from_fork at ffffffffa9000364
crash>
crash> ps -m 25542
[ 0 00:11:18.370] [UN]  PID: 25542    TASK: ffff9cb4cb528000  CPU: 32   
COMMAND: "md0_resync"


>> can cause deadlock. Run into this issue while raid_check is running.
>>
>> md_write_start: raid5d:
>>   if (mddev->safemode == 1)
>>       mddev->safemode = 0;
>>   /* sync_checkers is always 0 when writes_pending is in per-cpu mode */
>>   if (mddev->in_sync || mddev->sync_checkers) {
>>       spin_lock(&mddev->lock);
>>       if (mddev->in_sync) {
>>           mddev->in_sync = 0;
>>           set_bit(MD_SB_CHANGE_CLEAN, &mddev->sb_flags);
>>           set_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags);
>> >>> running before md_write_start wake up it
>> if (mddev->sb_flags & ~(1 << MD_SB_CHANGE_PENDING)) {
>> spin_unlock_irq(&conf->device_lock);
>> md_check_recovery(mddev);
>> spin_lock_irq(&conf->device_lock);
>>
>> /*
>> * Waiting on MD_SB_CHANGE_PENDING below may deadlock
>> * seeing md_check_recovery() is needed to clear
>> * the flag when using mdmon.
>> */
>> continue;
>> }
>>
>> wait_event_lock_irq(mddev->sb_wait, >>>>>>>>>>> hung
>> !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags),
>> conf->device_lock);
>>           md_wakeup_thread(mddev->thread);
>>           did_change = 1;
>>       }
>>       spin_unlock(&mddev->lock);
>>   }
>>
>>   ...
>>
>>   wait_event(mddev->sb_wait, >>>>>>>>>> hung
>>      !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags) ||
>>      mddev->suspended);
>>
>
> This is not correct, if daemon thread is running, md_wakeup_thread()
> will make sure that daemon thread will run again, see details how
> THREAD_WAKEUP worked in md_thread().

The daemon thread was waiting MD_SB_CHANGE_PENDING to be cleared, even 
wake up it, it will hung again as that flag is still not cleared?

Thanks,

Junxiao.

>
> Thanks,
> Kuai
>
>> commit 5e2cf333b7bd ("md/raid5: Wait for MD_SB_CHANGE_PENDING in 
>> raid5d")
>> introduced this issue, since it want to a reschedule for flushing 
>> blk_plug,
>> let do it explicitly to address that issue.
>>
>> Fixes: 5e2cf333b7bd ("md/raid5: Wait for MD_SB_CHANGE_PENDING in 
>> raid5d")
>> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
>> ---
>>   block/blk-core.c   | 1 +
>>   drivers/md/raid5.c | 9 +++++----
>>   2 files changed, 6 insertions(+), 4 deletions(-)
>>
>> diff --git a/block/blk-core.c b/block/blk-core.c
>> index 9d51e9894ece..bc8757a78477 100644
>> --- a/block/blk-core.c
>> +++ b/block/blk-core.c
>> @@ -1149,6 +1149,7 @@ void __blk_flush_plug(struct blk_plug *plug, 
>> bool from_schedule)
>>       if (unlikely(!rq_list_empty(plug->cached_rq)))
>>           blk_mq_free_plug_rqs(plug);
>>   }
>> +EXPORT_SYMBOL(__blk_flush_plug);
>>     /**
>>    * blk_finish_plug - mark the end of a batch of submitted I/O
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index 284cd71bcc68..25ec82f2813f 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -6850,11 +6850,12 @@ static void raid5d(struct md_thread *thread)
>>                * the flag when using mdmon.
>>                */
>>               continue;
>> +        } else {
>> +            spin_unlock_irq(&conf->device_lock);
>> +            blk_flush_plug(current);
>> +            cond_resched();
>> +            spin_lock_irq(&conf->device_lock);
>>           }
>> -
>> -        wait_event_lock_irq(mddev->sb_wait,
>> -            !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags),
>> -            conf->device_lock);
>>       }
>>       pr_debug("%d stripes handled\n", handled);
>>
>
