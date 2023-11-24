Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="W0+/G4gY";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="pKZhwU3i"
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C698173D
	for <linux-raid@vger.kernel.org>; Fri, 24 Nov 2023 15:18:50 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AOGHwO5013893;
	Fri, 24 Nov 2023 23:18:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=yCn8h8Yp0hGaTmM785M1FcfiYnoj5xFU7js8aHbcaIw=;
 b=W0+/G4gYcOyWchmub1nSVfH4ylBZ8k9cscPJaw5dByuVyCkadk5tujORNQDSeEp7hjyF
 D9pHoenSg8RsK6ex+ljZBd4eq+mj84lgleoxSU6VXJbPvcScwY009N9MURQT0d+sc0Cp
 ZLuxhyPezMn1pnOu01rb+q/1zVLi2gMDC0EQGRqXTkfSDKT9NXAzmjHpTms/DbbC2iZj
 PVG5vtJ+WZbq8Vyn74IXs8C8vj/f5r6TFLpFuqjObHICliuMYeco51yGcrQHJ9N2edhb
 N81G/fsUJsqIGocPvDS2uZxCP2WzVK76PKTJNrFRVY+dvVFR8aw0vMVGfBuQHJqHDy8e Qw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3uekv33vrp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Nov 2023 23:18:32 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3AOJsQA6007309;
	Fri, 24 Nov 2023 23:18:30 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2040.outbound.protection.outlook.com [104.47.73.40])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3uekqc3raq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Nov 2023 23:18:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RNJiYYMp/7VJPavE31v+SP8vqBSltPAhGMDqpqOF5bixG3LGxsZdSBOyUDGhAl3B59YabQBRCFNPR6Q8RcjtmW4+hkN/0BNaI9CaRCzyaCMLtmUIOa4+ITGo0sVC7ILrAb0PbjMiitNDhFR4QMHIPyyg0PtSu5R0Mn8+rHFF++nv0owdiBi9colIIhGWz4RCT/OLDIW0E6fLEUDJYk5JqJ2kuhelVQp3XS/3sEoIa/YTNaRBzGdyvUwFHRkUoyZ24Lvf4p1oPxQO1c/MbFn1QN3hKnjvnLsbRqgia3i+FNTysO51/OD3RaeuTIRZlMFGZkjlLUgkyFmqxNhr4ZljoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yCn8h8Yp0hGaTmM785M1FcfiYnoj5xFU7js8aHbcaIw=;
 b=Mp5NdKBPt0LFYxNUQCoYA/2LiDB9QKyRav+1W7OUCSWunFhFEfxiKMK5lNtOppnNnSEzMwBtXt5l1yBPWEw8+VvzmtVcGsuUplQkkPuUMKCmQOyLtr9pJ0TYVk1Jbu8Wy+FNPQ/b8YHyUMTQArDh4iWTPs7dlP/00FwmZoBMnfJUgvyBSHoFSTuCGCEjavNDInZdZemZuzoRsv3TdnWFzXq/0TAmvrblK+dCY3GkXIGVnJbWP2oOVSEbvFEoZtx+rPoTidfIaGh/ZrMtDA/5/wT5M2Cp4dn701oHLQVnHO/pyOdHAXx38vlitOHvj7o48qWtUyqqPUIXZczgNRVLCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yCn8h8Yp0hGaTmM785M1FcfiYnoj5xFU7js8aHbcaIw=;
 b=pKZhwU3iDhosS1W63EEtq2T+V0v7549BQ3uUkbKqppuCMEGiPuf+gHRKWr8O5dTKeV/bFevUy4QkHDzV8EGSePt4aQHHIKfuLK+0mK2L02eh0QM5H47LyR0t/bIpzDZ05vJpeZwFTnM2QGj9FHX3MDpmSE8Yu0G+m7Q30ZTKQxU=
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com (2603:10b6:a03:2d7::19)
 by CH2PR10MB4152.namprd10.prod.outlook.com (2603:10b6:610:79::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.21; Fri, 24 Nov
 2023 23:18:13 +0000
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com
 ([fe80::baa:8a05:4673:738]) by SJ0PR10MB4752.namprd10.prod.outlook.com
 ([fe80::baa:8a05:4673:738%4]) with mapi id 15.20.7025.021; Fri, 24 Nov 2023
 23:18:13 +0000
Message-ID: <33b81c46-4d82-4bf1-9892-2c213c0b3d64@oracle.com>
Date: Fri, 24 Nov 2023 15:18:12 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 2/2] Revert "md/raid5: Wait for MD_SB_CHANGE_PENDING in
 raid5d"
Content-Language: en-US
To: Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org, logang@deltatee.com, yukuai1@huaweicloud.com
References: <20231108182216.73611-1-junxiao.bi@oracle.com>
 <20231108182216.73611-2-junxiao.bi@oracle.com>
 <CAPhsuW5HCEbxTciUDiBJ-RkNBbmf76RSZZWvc88ABX172CCsOw@mail.gmail.com>
From: junxiao.bi@oracle.com
In-Reply-To: <CAPhsuW5HCEbxTciUDiBJ-RkNBbmf76RSZZWvc88ABX172CCsOw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR11CA0059.namprd11.prod.outlook.com
 (2603:10b6:a03:80::36) To SJ0PR10MB4752.namprd10.prod.outlook.com
 (2603:10b6:a03:2d7::19)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4752:EE_|CH2PR10MB4152:EE_
X-MS-Office365-Filtering-Correlation-Id: e33526c7-c868-4976-279f-08dbed43a1dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	jNpf8TbP4TnGf+NVO9x5RwzWxKGMsXQQbeP3g3qnL9Uw7y6R1i092zCA5vLn9wlcMnclSDKgPk1tg3t6YOOjScQHbPPixPCD7eNBCgQ8hcC9N9yPwOI5L+X9nzXE7nGpLxInJNgha8kKauZ0jCNPJfUKho1fsM+AEQ97DX4GFrNrQSu86IvJpZFaLPZcwSVMhk7WOUhgPGtP5N2g3tjqwExo3p5RIc/sWTNKnHq+OetdtT56/bDAc415VjuQj57kEipwUx1CtmsMoA5rtm/NSKi6KRjS+JiWttf2mhbNrWunV2OOsy752J4h+VZ+gn7s9AeLpIYdw5ZeEY8WKkWHBIQwc3uADlUt6wqmKjLqy8tNus1VE7TN1Q9tc6wFqIOTMr4UsNxUqBVZcpXn0quLexQvSkQ6c+lMs3WQUtZD/HP6Zr6Kmqqu9+/oFZ7NBh/+aKgDu/2Bm+tJx/NQvi8D6AuROLiiX4z5DmLxy9noUEA7Ixe/4Unn39Z2VOoVgan3RfUhSznuEAA//4VTSx7TQpFGGrdw0zRCJfFr4njtXWxwoheC1ndgiO5gfbAVn8ty3MtKezQNKzYwjcfnDLwfrg2XDldNin9oT+fZYoyveL+p9//wPmLZ81x9b7blbmh3+7W28prjDMqUp8WXX7MF+A==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4752.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(366004)(39860400002)(396003)(346002)(136003)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(6486002)(41300700001)(478600001)(6506007)(8676002)(4326008)(8936002)(86362001)(66946007)(31696002)(66556008)(316002)(6916009)(26005)(38100700002)(2616005)(83380400001)(66476007)(53546011)(9686003)(6512007)(36756003)(31686004)(2906002)(5660300002)(32563001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?ejgzajZWdTVCVG9OVGJiSENBMmpjU0hzSGxyazVSaEEzZmgrNVRNYlZJQnhn?=
 =?utf-8?B?ckZTWjhlRUdJODM1U2c0bkJ5M0FvSU4zQXJXRVNXYzZkbTFJZit3Wk1PMzdK?=
 =?utf-8?B?dW01V2RsQ2VLL0tlN1E5RkJTSWJvT3c2eHIyT1MyM0drb2FwVU9nZjZhLzA0?=
 =?utf-8?B?ak1MZjdLUHZsT211Y2hpQWtDUWk3b3R6ckMwVjZVMFNKQXZxVXR6cDNXYURm?=
 =?utf-8?B?eXV6Y3RpTmlDYUVpSHpRT2dlQXZkSFM4QmVkN3FiOEZPaTJSMGVNNFk3SEtw?=
 =?utf-8?B?c08wK0pRTVl1ZUpaS1F6SnVnQ2pVZytmcWZ2cWJ0ejRqYWxmN21IRHQvblY4?=
 =?utf-8?B?d2NlWjRVUEgxS25uOWxybmU5Z0FxWXVZWmNXaFNSRXVTVDB4ZDZGeDluaFVV?=
 =?utf-8?B?SDF5QUs5NVRIbFVhUGdqRndZdjhjSzFTMmFhQWh5VElHTExBVW92ald3amE5?=
 =?utf-8?B?Uno3OFVhUk11TVUxRFNmM2NJenRSTjZyUE0yY00yZjNabmFSakJKUWtJTXRq?=
 =?utf-8?B?Sm5oTXNTM1BLaUZ3cXl3aWJ0OHhMOWlMSEpsdG5XRHFVd3p0bzFnUTBiaDFI?=
 =?utf-8?B?OUlmOWl1UG4wcmMyZDlXQ2J0RzQxckZ3Sm1YV25BaWE2U3Z4b0dvQkJsSzVU?=
 =?utf-8?B?enk0cURZZ0daTFIrOFIvY0xWVGJ0SzFJSGZyaVFYbFNQVnRQQmxWVU04NFFw?=
 =?utf-8?B?YmNENTBJb0RRckR3MVRJbjh1Nlg2NkdNTHMyMWU3RDh6WUt5RUtOT1FjbCtn?=
 =?utf-8?B?a1JMajZhWllGcjJpdEM0cUFkM0d6YmxMOEpLUkdINDZBZitTKytoYThCNWVv?=
 =?utf-8?B?STg5dEhZdzUzOFVlanhQbzdpSmp3N2hkWll3S2hJR1J3NmkxRUczZkR1N2U2?=
 =?utf-8?B?dVRRR0VxSUVtOXg5aEhjTkNQOW9EbUR6YWRLaWZSZjRrMkZTUGJEMXJwMnJQ?=
 =?utf-8?B?NUVhdlV2dTdNYlN3OU5pK29yYjVvWGNVZ1pLczNBMTV6MnI0RVpuRjFnREpN?=
 =?utf-8?B?N0FZeVJaRnNDOG5OZU1uQWIrRzZDd2FvRHFVWCtpMmF2c2ZkMEdNc1l5RFF0?=
 =?utf-8?B?K3FXTHNvejFTVzRCR2U0K21vZGFQM2FjaHA3VWZQSWNvQVhyT2RpS1Fyc0Rh?=
 =?utf-8?B?bk0yYVAzSmFndXpGcmdRUG5mN3BNUXNYVDY0eGdITDFwOHBaNld2VlJtNGtn?=
 =?utf-8?B?SDhjcFVRcFZXSlQzNG16TTFHMG1xSGY0L0ZmTjBuM09IeXFCTTB0L0t4OXB0?=
 =?utf-8?B?eldjVVBuM3duV3ZpN3ZnbDVIbjFONm5OWUlZQ2RqZVEvTHE4ZXROeHFOTlgv?=
 =?utf-8?B?aS9tV2tzUE5EV0lrTk5OVjVEaFgxR092ck1EVWdoejM2eGRibnlpanFIVmFN?=
 =?utf-8?B?dnNPWWpUYWQxMk02SWx5cllJUEtjbEREQ0ttRTRSbTZXMDZHNlpqbXZWUEx2?=
 =?utf-8?B?ZEJzTkpiZDkzWUNJelhtTTBCTlBLbkNMZmJ0SzVYcXNmRDh5QU96aWNrdnJN?=
 =?utf-8?B?dnhsNlljcnJMZ1p2c1NkWFBoNjJKbGlHS1ZMTlpFZm04b3dkT2kxYUxDdXdT?=
 =?utf-8?B?QzZONUVuR1N6MnRTbmJ4eWpxdk9FZlQ0Z0JKQVJmMlpvNmtxTU5ucHRSc0l1?=
 =?utf-8?B?NktXZUxtMVhWNUlqT0VlV2hOdmxVa0QveExmZm5CSlhHcE5vYjdPZm5KMUts?=
 =?utf-8?B?d1B4aElRZ29SSVljT243WVkzWGtUV2RYcGtSemdZUkUwV2dSeE01LzlRcThX?=
 =?utf-8?B?emgrY0JiS0dEeUsxUStwM3BMejR4OFJPcGViRjJaUVpnMzd2ZCs3bVhKTjY5?=
 =?utf-8?B?WEFDTHJtTzBPbTkrdVBPZndEUFNzQzdZKzFCaTg2WjRUQXoxejVoSVNmQjVR?=
 =?utf-8?B?UkVIN050bGlhWHUyRTU0M3ZnOGpoU3R3Z0t0ZmdQRitYVWRnVis3RjdDd09H?=
 =?utf-8?B?Vy9raVdtditWalhaQWwvRlpyUjdiaklYMTFrN2M4eHpDVVJndGNmbzhyUno3?=
 =?utf-8?B?cnQwWDlsRHJOOE1vVjZJQVBkcldIRU5YNGFUTVJnM1NSSjdUSWJyaXdqUm1o?=
 =?utf-8?B?SjNOWFcxcWhRbm5aYmhEbFlETk5CdWVzaGkzOVlzOXU2YlpCOWt3M2o5Qmh4?=
 =?utf-8?Q?sR/cl+goqUguK6uBxkIAYt/rb?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	rq/q2sQWfyuMXKeY9asxKBQNo649gj5MFbYyb1YA6Fgk39I7UIAmR6jB0C/2at/tJ/QpAmHBwyR5Du1MvyVgXtZGau/+XeXtoef3FptrVyaYHuADg3P3bYrpVAa4JlL9VBekYGzs84eBv/P9wSrI1svr9XnxvSIKwGOpghES30tcV/CHEvOJrREnBY+uW4Cm7hIqZmCbeI3fpX5pIVuJRHLpUdDR+q6kjif6Vt+SxRT+DVGfvm1Uk2jqx3Z6KRA9DCKZ924f+c18FbYqcOiAzks8jHrK91PNJiDhSq+O7TdqzSDA1drcQMNRVtUHwhZoXDherBukDHiitwKGhsfQKN+W6C2mcKiP25/VeC5emlNZXwVS8sOepKBRI7Dyver7qqJgPx2AScwV4rwv6FnQ9sfBovZKjaHgWgq6xUVyfXxREYSdac6AC+RuUpqy8GPyY/L06pr/iGv1HvrWZ4kzlPSFs7SPWWLz9yHs+35xsNvk5biRlLrORR+puJ3TuebAnsr8vrXZ8wC+34XcIRC/2y0gOrmzZZrgz7zKRvIxWy6wN61eKP5v74CW4fs3544pVKh3qs4JOYVix1dlW8c9OHohWyu5FXDrBQeTPr6fN05ywRlACBcOB16lXYBK16Bte+nM7e/YzjyIYF+BfBiOEvdL7W+bTFCbXXjCN33V2OqpRSBHA6ewwNf2MCcgSIlRdNAqOsvYTsVBUSf920QBdUOMR+YtF38s+lPR4NBfxsktT8hsLQo9DJfS+ba2SgraJcAWXTK6sneegdU2uNkWwLda4wpZxNuXfJ6cZE3yU1JNlpf97fs/J1dbiRh+q/wakaZLKkxnt1eKAp0AB8kob8cQJpD4Im4+hyGSayYpmuQOL/L1SeILgFEZUMlmDR25
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e33526c7-c868-4976-279f-08dbed43a1dc
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2023 23:18:13.8125
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OiTuzjjfNPv0stn/M1IY9L69S2fOKxoI48Ar8MdLOwHQsClbJaFTU4MjN8RYg9wqzhpM6yYxA++AvBJbuvXw2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4152
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-24_09,2023-11-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 spamscore=0 bulkscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311060000
 definitions=main-2311240182
X-Proofpoint-GUID: uN0zLeWYWI4YM6euHqlVneJHR0BE5HrJ
X-Proofpoint-ORIG-GUID: uN0zLeWYWI4YM6euHqlVneJHR0BE5HrJ

On 11/24/23 9:29 AM, Song Liu wrote:

> On Wed, Nov 8, 2023 at 10:22 AM Junxiao Bi <junxiao.bi@oracle.com> wrote:
>> This reverts commit 5e2cf333b7bd5d3e62595a44d598a254c697cd74.
>>
>> That commit introduced the following race and can cause system hung.
>>
>>   md_write_start:             raid5d:
>>   // mddev->in_sync == 1
>>   set "MD_SB_CHANGE_PENDING"
>>                              // running before md_write_start wakeup it
>>                               waiting "MD_SB_CHANGE_PENDING" cleared
>>                               >>>>>>>>> hung
>>   wakeup mddev->thread
>>   ...
>>   waiting "MD_SB_CHANGE_PENDING" cleared
>>   >>>> hung, raid5d should clear this flag
>>   but get hung by same flag.
>>
>> The issue reverted commit fixing is fixed by last patch in a new way.
>>
>> Fixes: 5e2cf333b7bd ("md/raid5: Wait for MD_SB_CHANGE_PENDING in raid5d")
>> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
> The set looks good to me. Thanks!
Thanks for the review.
>
> Quick question: from the earlier thread, the issue was observed in
> production. Have you reproduced the issue and thus verified the fix
> works as expected?

I didn't try reproducing this since the system hung on the code where 
the bad commit added, after revert it, this issue will not reproduce any 
more.

Thanks,

Junxiao.

>
> Thanks,
> Song
