Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C3BBC4332F
	for <linux-raid@archiver.kernel.org>; Wed, 15 Nov 2023 01:00:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234263AbjKOBA7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 14 Nov 2023 20:00:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbjKOBA6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 14 Nov 2023 20:00:58 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEBFBDF
        for <linux-raid@vger.kernel.org>; Tue, 14 Nov 2023 17:00:54 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AF0ETH0024867;
        Wed, 15 Nov 2023 01:00:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=fegHYtugFLIJgJ5tp/sUaf4COLHrmT0XD3uZ7rwy0oY=;
 b=gQyDAfIEDe2/C3dy2J8Sxgb78gJXyZH4s1sGkuL2V5DKxbJSy0g3XiPQjfjoAmcf2sEX
 GXqYCLV8IXgBHNqlFSTFpGiAAwvFTYXD7bTOZE0fai+NzCZnkOZmGuULOxTQpD4IGQGL
 gVQUyuYgbFxa+Gwu7wYF2l6kt2ToV8W54zR9ejlt/Jmlu3NgarCYuTfYfz6fBwU065iW
 pz4AaMVs9UjMaaNbmmT/t4rmbpHwBFIo/Gkz3A6bbNYsIgW+EzjlymoOz3VxKHOqlPi1
 uGqaLyC0if/0c8alOGsnHECXlcWiQismh/yozXG71whaWL0e9teXao1JzVpFoVOosqmM mw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ua2m2f12c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Nov 2023 01:00:30 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3AEN4Spn008932;
        Wed, 15 Nov 2023 01:00:30 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3uaxpwyyp3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Nov 2023 01:00:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W5taOJUoDHnUjPCQp1MoYTbpRXeojqM5Sk60On/lF8+QSAX+QrBL8HuSOSpC8GqSZsCEt4KQphkYiqtsYpDZOl32PXBfCthtkjJjZMGuySL0tDfpvHtXQa+XTvh53NEDC/O0hW01yTxtyhXg3vuwSUwbFbbDpOKvBBzW1PRA6ucpCvD/2OdNHM60wk4XkhVXvVIdpJsYOkxnMpMngztKwTIy7R2gVYwSOMRc+SjkaAB5KVIB/K/tHEcCGaJqXLZhvRDueZuxCkv4KvPQfES0z6C76TGb02Ejb7SyjztVNfx+g4ckyWSlYaCAbVs5SNzWQ9WaOd7MWFhZLWTEoSJQWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fegHYtugFLIJgJ5tp/sUaf4COLHrmT0XD3uZ7rwy0oY=;
 b=RPSVNHlRktvYwGj+Tz29U4+29SIe291ykEzCTTZgBkGKtGo5o+kzrF9dtF0LnXwmaF1KgxXoTz6+NifijfBLG/p1HRCeJm9yDy4NM7IflwibE4JSlBdW1ld5eomiP2J6H1MFm3dvtIXBiPJsG0X7adTCzJwdjDAr0gtmYjU52pUMljam+UUt+JAz3U+h5P0wtfdabYGvic2t4vL8BlCs77oNm35L5FiBKU8s6HZXWbZqVq7xNBjjJxJKnsG6LoppMvAyTx25eLZN3nr4xCdvEeD6in0SLIv26RgP6ulbp5nSEsjOn3iC+NMa5P2XMTem8ty68j0Gvdef2Ezyxxb87Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fegHYtugFLIJgJ5tp/sUaf4COLHrmT0XD3uZ7rwy0oY=;
 b=KaK6NKN+v4NaGKwWfmCYieJvbbz6FshHU4Bg8QOHCj40wzz/O+ACBz+cya8IiGSTXqUGSpWOHesIZSN3Fa2gyDUg43cEDv2gFZjxNjJXSHd0upw/uCJGfAbhJkzmwqaQ7f/OOQLhcxeGzi5s7vTGRk5s0RVy06Lu15XcwNKlYiI=
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com (2603:10b6:a03:2d7::19)
 by DS7PR10MB7192.namprd10.prod.outlook.com (2603:10b6:8:ee::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.31; Wed, 15 Nov
 2023 01:00:28 +0000
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com
 ([fe80::baa:8a05:4673:738]) by SJ0PR10MB4752.namprd10.prod.outlook.com
 ([fe80::baa:8a05:4673:738%4]) with mapi id 15.20.6977.029; Wed, 15 Nov 2023
 01:00:27 +0000
Message-ID: <ee2330ea-6fca-4360-a981-26df47d68cff@oracle.com>
Date:   Tue, 14 Nov 2023 17:00:25 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 2/2] Revert "md/raid5: Wait for MD_SB_CHANGE_PENDING in
 raid5d"
Content-Language: en-US
To:     Yu Kuai <yukuai1@huaweicloud.com>, linux-raid@vger.kernel.org
Cc:     song@kernel.org, logang@deltatee.com,
        "yukuai (C)" <yukuai3@huawei.com>
References: <20231108182216.73611-1-junxiao.bi@oracle.com>
 <20231108182216.73611-2-junxiao.bi@oracle.com>
 <a08baf6c-ae35-f83d-2524-4715263c512a@huaweicloud.com>
From:   junxiao.bi@oracle.com
In-Reply-To: <a08baf6c-ae35-f83d-2524-4715263c512a@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR04CA0028.namprd04.prod.outlook.com
 (2603:10b6:a03:40::41) To SJ0PR10MB4752.namprd10.prod.outlook.com
 (2603:10b6:a03:2d7::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4752:EE_|DS7PR10MB7192:EE_
X-MS-Office365-Filtering-Correlation-Id: 1884f0f0-1e6b-48fc-9862-08dbe57641df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pU84nFEIP8ZO0Th9oOEEM6XfORkOiIuFOrzzdfuui+ORgxEIyk9lLngYFOiS94W/vr6nw+/wZRkPpiCUXU7PvMcr/XJQTbq4+83iGd28rls1aUPuASyAxaIfCLrfhkkWDhsTxd6qYypiSrPSUXR41s+kqsNw5ds5I+uD3Dx0ByFBhcqQ6f86hbRpt53zQtA1Vl4ROoZw2GeIUvWGD6/Mwlg3dk1t6CPqRgLRFCq/bG4LXtiurrRwTybg4qYC40ZjCXALulm23zseWPzVPvAlosjL+hydyAHgcALiemsVpYKIPnGdI+YD4UYFoK6M6dAlLsP+VGJpB0mTk4/nwtfjBInfO70rq7Y8nVWB2UyYqbxSzxceCk5vODExGfWqPmo85us1dEi6T9+jN1qHwZvKqwhq+2ELyH8tPK8B7slexnIUGPe/BvXLKzSzm8NwpboHeiHI3U/zbJV3WjDxV0aXkPnZmv9vVhxuobv7bf3caQGTtu9FPMXKUk2G8nklJRLqaeVeeT8RdXrSduRuV1InuhhNmBV4I2zW5rTABzkPdH88symYH4bSy37lyMXd06y8hvkYLK3/IU/l8n8hNT4ADdUxCpqPlCH8VCZ760XfySQ2rwMn7KOJb26NsA9/UB1L9PD7iwLRabZ255xJ+RgzCg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4752.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(396003)(346002)(366004)(39860400002)(230922051799003)(1800799009)(186009)(451199024)(64100799003)(31686004)(4326008)(8676002)(5660300002)(86362001)(38100700002)(8936002)(6486002)(6512007)(9686003)(66556008)(66946007)(316002)(36756003)(31696002)(41300700001)(2906002)(26005)(66476007)(2616005)(83380400001)(478600001)(6506007)(53546011)(32563001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UlFpV0ZoMGhMbk9rSGZjNy8rRndTbVIyc3FiY0hzcmxMcDRVcE96N1B0K3A1?=
 =?utf-8?B?eWNSTWdONHlRQ1hqWmFOTzduV3RPUDROM3kxODdRbGllczNoaUdtZ2d6c09T?=
 =?utf-8?B?dGZwWksreGI2RDRIcndiWFpkSzRIU1hObnNtaUkrZW43eGdLVTJpeVIveUVx?=
 =?utf-8?B?enVtUkNIVEpQcEdHSkdRT05wU1dNVjNwOTl6L01RMzlJUEJ1ejhneGdVNkp3?=
 =?utf-8?B?RUF3bUNraGpUeVhqWTlGTXhnbWdVTUtIcmVEaVB1OEpkamxqbUtZU1VkWHZY?=
 =?utf-8?B?TEZCblRKVGd3ZU5wWklQUVA4aktLRHpHZ2V3cDloRHlpQmlYUkRjK1ozeUVu?=
 =?utf-8?B?KzNBTkQ1L0hQb0NiM3N4SGl6QXpqWWdEZngzYjF0a2djNjgyeWVLSTQ3K2RE?=
 =?utf-8?B?Z2hPZWdtSEpNc3Jrd1V6OUVQcHBYeGozTG5BaFgzTG5lUE5ZcUFDempTNUZS?=
 =?utf-8?B?ckxVUG05Skh6Ti9MUVVwZ1o5SkRER1NpTUNtdGNQUjVYc2hQcFNoSkVjTlBD?=
 =?utf-8?B?MEl1amM0TEdBalJoMlVlNnhpYXR5QW4vNlBHMVRHWElNckRlWTAxRy85ekZ4?=
 =?utf-8?B?dUVzYjBVZExkYjRrNmd1N1lEWGh1bkJ4SGJRYlk2SzlJMldlS0V1YVNvYTdO?=
 =?utf-8?B?M1dPOFVHSkdyVVZMTzRzbm55V21pVVNENy9wa3FyTzZxQTBFOXY3NE5hc3I1?=
 =?utf-8?B?bFdZZkJjVC8wMFVDMTRKUlRUWkk2czdvcjhCblBoT2RiSjZHQlE2aTFZcDdM?=
 =?utf-8?B?RVFKVmlUWUY4Sm41ZTA5dmh0V0cxa21Gc0tKbDdhTWxFYWpsQWtiYTE1UTRu?=
 =?utf-8?B?T1lOUHdXZnhsSXRnSE9icy9PZk5OVllDU0tjNmRXUGtXSTgyZ094dlZzSThG?=
 =?utf-8?B?N01SMmNXeVgyYkY3aGl3TklpMVBPbjJBS3dLNXovemRGV2FYYXFzSFVHUnJk?=
 =?utf-8?B?ZjJ3YklXcW9hbjNuVU9JSW11RUorcm80a0RxQjFiamVUSGRrcEd6K2VJQ3dN?=
 =?utf-8?B?Vyt4bnhVSmU4UnI0TDdGeTZyZnBqaFlnZ3Rsc2FaNXhvY21FeWxSemtnWWts?=
 =?utf-8?B?aWhnM2dpKy9FS0JvbFdzRHNST283aER0NGxOWUZjeGdMTUVBeVcyNHpTbmR3?=
 =?utf-8?B?RGFKWG1ITUJ6bW85bExMeXI1ZHNUaGpHQkwyaEtDSjNYay9pc0dhRC9pcFBS?=
 =?utf-8?B?cFp5TWVOdzRTUmE3dTk3UE1DQ0hnODZQRW5GRlRodXpKczJlc0Y3aXJNczY5?=
 =?utf-8?B?TzlJVXBrTXFyL016WXF0MnNyYkpNemhjTFFvSmN2RjZoTmxlYzF2K0xEMTE2?=
 =?utf-8?B?V2hKcmJtK2YyQ0NJVGpnRTVNamZXcHdHTTY1cHBseEptTktOYWQ4amJHUk0y?=
 =?utf-8?B?NDJ5UzFaeVhCVUFuY1VWejA0bWdkK0VzQ0JsMHhEdFFsMkN2UXVYbzFzSElX?=
 =?utf-8?B?c00vSkdhY1BCb1greUdwdFJXZ1dsWHJzZ3REMjlOcVJJNVV6YnNsSzNiS3g4?=
 =?utf-8?B?MC9XUFkzYk5wWUtpbTFtNnh3M0hPRmVsRnFOU3FObno5VWFqQlZjdktVWmI1?=
 =?utf-8?B?U1VOeWV1NnZOWDJUTkpvUEdrQko1Ym91SmQ2RDJTY2l1R0VvZUpjSFduZVhN?=
 =?utf-8?B?VUJaWjRlNzVocXZhUTF2WDZrVVRyS3BYS2FJcWQ4SUdkb0NnMEpzbUhZdDFh?=
 =?utf-8?B?Z0J4NXRaZnhldWtQVldnNU9DUHZzbmlLZTczMTlkekZIcmlBYzRyVndQYnVs?=
 =?utf-8?B?OWJJZWpuakZ1NldyUEJWZWhZSGdXRk1vUllLZ2czTHNuRWZaR2pmb2Vkc25r?=
 =?utf-8?B?QmNEcElIckxXMU9zUVdRdGdUMlNxamY0Nit3TUlqbUhVZVdaMnlyVVFOSmJ3?=
 =?utf-8?B?VFhjS05maXBrWm5OWUg5N1dTdmVZRmhiU2xjdmFsOHJsSHZTUEc1c2pad1k3?=
 =?utf-8?B?R1ZDaE9Kc3k0WXJDVmRCZFVWdzdNaktIZnRMd1lPT1ZzNGdVSVM1Z2NSa2Qz?=
 =?utf-8?B?SVhnQnZZTXkzcDFGT3JDNFV0bzJLYnhnSUVpT2JVT05XYUNab0tYZHF2a0VN?=
 =?utf-8?B?WTJxcmlOMWhnRnRFNHU5Q0pZM0h1ZDBWOGUzZUxoVlQ3S1FybUJDaVMxdFBF?=
 =?utf-8?Q?f9nDMeFkHA9Sd0w8EaXNctLDo?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: BP6xotdjeQfV3Y0v7ErgO+A2r7tu0ywks+4pT9xC12+CKr1fgbRLEHKD3724hikXiuCzRKQQhx7vCkF3y6shoDUfqTFxj4Tc/IIG6GpZ2twR4pZknbRHidMM0EBSZBDbLw18vrXUO7By4j0YT7Ha3Z8AOH3Ij9uFr1PYOrQQlV7qu0Yaigbhh5PDwFsaDPxB2AuhYp+6VssR3Le6k1u269SATsi05rpWbSi4dCyjN1R3+k1U1ezg0EQjW4Fp2/Em5oLgg/oBG/vnq66Ec/PUOQsp+29oGkg51SVPTNdDooNjUxer+/w11lItQVfjBluUv3zjllGIayzFiWq+8kIOaMw1UGz4uYCLlor3YhrdjWIZ4pIbUT076gwn2Koo7eFeYsFI9GqKMAYgvl6holMQzWXkOsKPGYtRdjrSMk1yl8PTfVN/2wXjveqygMBhs5NWj2uJf4Mg0qkacd/SwrQ11D3v32HIolVx817PPAtQEbylvYRFIgxwWp6hCAs8T+weYJcpiRS8ZF/eqmMnq8IJg1YRxdS6XDd0m/D2MGCCz/5lzOjIUhL9Dbtvu9DHJsrczula9t/kG9ouwYVoau/H5osqvy6J+y/wJVbmsRDpBpjLV4H8HZI9EsLASbZvn6DJ9e9SslkZvuk/GHdCRKsf6fTV5CDpa/Jz/OJHOx9rpljYMs+r3MF+30SMXFkCumKI7+DwkN25KYurZaZ2olfdoB9bliUhbDfrQnx92lmk/VmouXn5GxJOq4lBP2DwYjw8BmHQeSta6V5BuLmpB3YMYWgivVjxStxglEUtoFjzOMlZ9IVoTzWACSKInm6BP1eV7ct3aCIPLb0jkSd4Gx4OvWJHgHi+4dJC7JCFmBYaQg554fj2QHkdH/rCs+iEpnc1+J+4E9tT5ieHBHyhfdqu8g==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1884f0f0-1e6b-48fc-9862-08dbe57641df
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2023 01:00:27.8455
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4EeWgwMl4GW1puXipN8ICO8sTg0XoQy0UvBiCDJ3Doq5VpnUzyirDDPl4+4PYHiTorkmi20brnykq3YCu3BSOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7192
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-15_01,2023-11-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 phishscore=0 mlxscore=0 bulkscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311150006
X-Proofpoint-GUID: 8W9LSbcMwqw67kUtqysu1vHId1ClQ9CN
X-Proofpoint-ORIG-GUID: 8W9LSbcMwqw67kUtqysu1vHId1ClQ9CN
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Song,

These two patches get reviewed-by from Kuai and Logan, I didn't see them 
in your tree yet, would you like review it and pick it up?

Thanks,

Junxiao.

On 11/8/23 10:28 PM, Yu Kuai wrote:
> 在 2023/11/09 2:22, Junxiao Bi 写道:
>> This reverts commit 5e2cf333b7bd5d3e62595a44d598a254c697cd74.
>>
>> That commit introduced the following race and can cause system hung.
>>
>>   md_write_start:             raid5d:
>>   // mddev->in_sync == 1
>>   set "MD_SB_CHANGE_PENDING"
>>                              // running before md_write_start wakeup it
>>                               waiting "MD_SB_CHANGE_PENDING" cleared
>> >>>>>>>>> hung
>>   wakeup mddev->thread
>>   ...
>>   waiting "MD_SB_CHANGE_PENDING" cleared
>>   >>>> hung, raid5d should clear this flag
>>   but get hung by same flag.
>>
>> The issue reverted commit fixing is fixed by last patch in a new way.
>>
>> Fixes: 5e2cf333b7bd ("md/raid5: Wait for MD_SB_CHANGE_PENDING in 
>> raid5d")
>> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
>
> LGTM
> Reviewed-by: Yu Kuai <yukuai3@huawei.com>
>
>> ---
>>   drivers/md/raid5.c | 12 ------------
>>   1 file changed, 12 deletions(-)
>>
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index dc031d42f53b..fcc8a44dd4fd 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -36,7 +36,6 @@
>>    */
>>     #include <linux/blkdev.h>
>> -#include <linux/delay.h>
>>   #include <linux/kthread.h>
>>   #include <linux/raid/pq.h>
>>   #include <linux/async_tx.h>
>> @@ -6820,18 +6819,7 @@ static void raid5d(struct md_thread *thread)
>>               spin_unlock_irq(&conf->device_lock);
>>               md_check_recovery(mddev);
>>               spin_lock_irq(&conf->device_lock);
>> -
>> -            /*
>> -             * Waiting on MD_SB_CHANGE_PENDING below may deadlock
>> -             * seeing md_check_recovery() is needed to clear
>> -             * the flag when using mdmon.
>> -             */
>> -            continue;
>>           }
>> -
>> -        wait_event_lock_irq(mddev->sb_wait,
>> -            !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags),
>> -            conf->device_lock);
>>       }
>>       pr_debug("%d stripes handled\n", handled);
>>
>
