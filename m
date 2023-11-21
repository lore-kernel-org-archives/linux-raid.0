Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AkPpw/vx";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="KSJnrlvB"
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62886112
	for <linux-raid@vger.kernel.org>; Tue, 21 Nov 2023 12:11:31 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3ALITM7t032703;
	Tue, 21 Nov 2023 20:11:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=DfGqjeiTmdxFlrsytJy/MeQhKhr9E8ZoqKicXb4L3W8=;
 b=AkPpw/vx0k17/uK0lPdMHgTU3L7OJDK/4BoGNyDCDEKsymwNUgcC6Z90L7uKzQTQX5jJ
 oY6aCNNsbBdEYF+vvg6exUEoYFs9orqW/EnwkFuzVAl3AEpHH8ei+NgyZiOA/vR7b6t5
 nLvVkWCh2Nwdg07P89uyRjVVdIRoumXe3wqAlZcBskVyE/mbGvnOuPAJ1gJGbREHP3NX
 NGl3L13CfKMSitYl8SokaHZwr4IQ6gbC6Alg81CQEjFOtJ/FfRjaAN2P7+DUvs1YId8w
 s5rKuYs5GkEnSf7+gWJoyhYJbQoRFmVoZeLxjNhTdFUT6GjKH55kIyp3TIbfrl2QL5h1 2Q== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3uekpenyjk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Nov 2023 20:11:09 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3ALIWMLC022585;
	Tue, 21 Nov 2023 20:11:08 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3uekq7c454-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Nov 2023 20:11:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fN/Zz/AJuI3vBrzH3mlma6UcfnpKk4zkrKvPY02RiqGd2DYn/4bttKZQQ1wo+D26mMv6AMNK9djLB6KczRg9ep16ODpJECPFAU4IKxDwT12fVdPuTXbBFk52STOVEDOr4C/lIwpSSo+/5baa7ZPqZ/nXCGwDXZZA2a5Y35Rqaa0yUh3qxc/Z6BiatcbCgntU1THAgZliVgNA1O3WWc84WFlXPRQTv0uKudn//1CK+NYIWhZ9NbFF8j/8Xrw/hB83oizP2+Vm6MSIVaFPVGErpmlyl0iGHtCaLxqPAf/oVhGXjF021LZvkXQ4xtR8/1kXB9lhwAKBZVlEHiLxuAVXDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DfGqjeiTmdxFlrsytJy/MeQhKhr9E8ZoqKicXb4L3W8=;
 b=Us7IXsdgNEq1qMh2hdI8TpD9V8btTNC33vzmy7auG/1785g8TscPiiRBIR5jLk/1LbAIkL/ZlnJDBaovrryUooXHbdFg2inzA1Rg5QV07PhrD6XbbTJNQ3hy9gtv7nneJN0g7X8ypPt7R1mcBmtOkQsAkKDIxKJv6Hs+H6a+JAmwTcnogRidqZ/1Usq9WiM+pdm4MYEj7FgJ5NL/CqmP+0RxcSXiGb2zbYBEIJF6DWfob4GFuXiyoFgAOI9ob1jl8mND6AE2z3fB1frZYyodRzhISKHBJin3gP9HPFCk3hA7Vvp2fQwheJ22zcLValI+G+o9eoPtReC2wob5PcAc2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DfGqjeiTmdxFlrsytJy/MeQhKhr9E8ZoqKicXb4L3W8=;
 b=KSJnrlvBnb0CWxmjrrWSFr0y2yXZXIkYiapM7/NpbHRVigKtks0lvjrBPKJQQ2KtjwOVLc0X4zHW1ccVT/2XdL+KpUcA2J+mLMy0Lhn9checSzaFwZ+IX83yHfz0MS4qn68tgsJkIDOlLOKCk6MHg7tLqYPnewmooJCA2fREOGM=
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com (2603:10b6:a03:2d7::19)
 by DM6PR10MB4172.namprd10.prod.outlook.com (2603:10b6:5:220::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.18; Tue, 21 Nov
 2023 20:11:06 +0000
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com
 ([fe80::baa:8a05:4673:738]) by SJ0PR10MB4752.namprd10.prod.outlook.com
 ([fe80::baa:8a05:4673:738%4]) with mapi id 15.20.7002.027; Tue, 21 Nov 2023
 20:11:06 +0000
Message-ID: <462ee8c9-8331-4921-ae9a-f7223ee73f0b@oracle.com>
Date: Tue, 21 Nov 2023 12:11:04 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 2/2] Revert "md/raid5: Wait for MD_SB_CHANGE_PENDING in
 raid5d"
Content-Language: en-US
To: Song Liu <song@kernel.org>
Cc: Yu Kuai <yukuai1@huaweicloud.com>, linux-raid@vger.kernel.org,
        logang@deltatee.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20231108182216.73611-1-junxiao.bi@oracle.com>
 <20231108182216.73611-2-junxiao.bi@oracle.com>
 <a08baf6c-ae35-f83d-2524-4715263c512a@huaweicloud.com>
 <ee2330ea-6fca-4360-a981-26df47d68cff@oracle.com>
 <CAPhsuW6TTf2n7B01Y+ZJYCtxsgGdaNf5Zo-99og5nvwedqSp4Q@mail.gmail.com>
From: junxiao.bi@oracle.com
In-Reply-To: <CAPhsuW6TTf2n7B01Y+ZJYCtxsgGdaNf5Zo-99og5nvwedqSp4Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0P220CA0007.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::15) To SJ0PR10MB4752.namprd10.prod.outlook.com
 (2603:10b6:a03:2d7::19)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4752:EE_|DM6PR10MB4172:EE_
X-MS-Office365-Filtering-Correlation-Id: 036b32b9-83bc-45db-fe0b-08dbeacdfe42
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	QrBBKKWTym75omDX5zglwRr7c0BpFIrl89dLbnZmxgWPfJFQubUhCsxs27UXPyspxKrK0hN77NkpooM3gR1SREKND6BlhELcm6khY80AGpr+cBIiri/18iQNCQrEdzsVwuQiuqTzsiEIqtBSmMEmDzN/xrm1cf4XSxJogSe+0fp/nJyD8wEqbSCteTnJtulOC8pFJ/lWGXosMRdWxM1H0nLWOl5QoLeHsjvrdbfdBUMkjMOo7sdGDCuMBztD+8SNrgB9xK8sgotunek2zVTsXxGx1l2QIGZ2c3q95bLYd2H31qcaW6kvkISmUyaaYBO66w2r9zRXjAQw6rPF4/b5p4xjWtKBwZIzBk9Y8LqJu1dWSci6Y2keuzUczuZPij+h5rrbPixVh3/yuQuehFTUKf14B37HEmy3VJlmvi5NcPzlph6umOTTLYafZItwto4//j3XGcSkCNGblhQj/z/MQaIh0R49L3H+pD0Tr5OmU8sb1AWZnSIL/l1GyEoOKJFS6EaVGqkqh7QQ7g/2eRGr+BG8FjAWvVsvFElTBRiHGniGf4gs+NVwl00h7xj1X1RCYY32onKEct2a5+MtPsvoRvmXddNFYvSi2iEwxdCD3A3ceoyPF/RHyTT9JOuNdfi+M03LexQtidVMFZoigEjw8A==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4752.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(396003)(346002)(376002)(366004)(230922051799003)(64100799003)(186009)(1800799012)(451199024)(31696002)(86362001)(31686004)(6486002)(6506007)(6916009)(66476007)(66946007)(66556008)(316002)(54906003)(36756003)(2616005)(6512007)(9686003)(53546011)(26005)(4744005)(478600001)(41300700001)(2906002)(5660300002)(38100700002)(4326008)(8936002)(8676002)(32563001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?dXhpQ08vSFJqeEYySTZ0eWpKR3ptRkZlelVKUWdScUZvdWVtOFZXQ3Y2QW55?=
 =?utf-8?B?VDczYzNQMDJNdHJYM0FNNTVCbTVBRlVUMDBQOTl6RXYwWWtKUjZ6cjF4N2lL?=
 =?utf-8?B?eXh5T3kyK290UGdqZXM3dG1oNGkyeTY5Ri9qWjZHVzdNSmVXQUl6R3NLTWZj?=
 =?utf-8?B?WHk3cHNmSmt4ZXVpS29zTVgxdzhUTno4Um83Q0xXR0tvdkNZM1MxRjhSN0c2?=
 =?utf-8?B?RStyNk0zRTlhREhaSmtJWlZZMFVLSmQ0UFFYMjBnZlF3dVk5YTVpdnovYXlq?=
 =?utf-8?B?U0tRN0VqYURKWSt1czdORFB0ekNSV1Y2Q0QxdDIxOFA2MFNpc0pjOEs3d2JF?=
 =?utf-8?B?R3VmVVc4WURPZjZBblU2SFN4dThpdTF3MmQxTm9acHBxRWwyTDB6a0NlWGVZ?=
 =?utf-8?B?K3ZwaUlmR2RkMk5vLzUvalZVQm45dnF4VWNsVW16UHFVQld6QzdkdklqUGVZ?=
 =?utf-8?B?ZEpPSzlXNjRkVXpIckdoMzR2M2ZKRWNUTTJtSW1BbnRxSnNtb0lnMWFmSTZi?=
 =?utf-8?B?YTVvTzZ6VGhLQjI3N0VTcFlVWUxpNmFKUzRzNHhHUXpRejNhMHpabmVrbURw?=
 =?utf-8?B?VTBXKzlMMFowZ1ZGQlA2STdkVnpDQVBzdHA5YWx4dENsY2hSQlVBUlptTDgr?=
 =?utf-8?B?dnRnNVliWWN2MXYzc0J0bUY5ZWVWdDc0YjNaekFMckM3aXlpVm1ubVNlN0ZS?=
 =?utf-8?B?cWhhY254UHc0RkV4KzR1eURmMFp5SDNzVUlHSEJnK2Vyb3V6T3JRREM3dzZM?=
 =?utf-8?B?endta1BQRVVEL0orMHdGbjNtRU1IQUFiRlJzUkFoL2ZVTU42VnE5TWhTSzdQ?=
 =?utf-8?B?Z1VhcVBCYWdMT084aFZOTHMwVTNkblNzdkdlU1RjUHlyeW5lbEZHbmtTMXlH?=
 =?utf-8?B?cVVWdk1IZ1ZhVm54czFrTEtVRmFTVU9iZHNXeThGMDdIT2dDazVXTnp3Q3RO?=
 =?utf-8?B?dlBqS3o2MkIvaGRjK1dVNUhWdlpKczArbmFZQ29BaStuVndsQVk5ajU1ZkN4?=
 =?utf-8?B?UmJabkVYd1BLb0psRzJKdXQ3eHAzU1pBUTd5Y1ZhU1JFM1lMU1dXY0lsNVc0?=
 =?utf-8?B?VnhZb3JreU4vNkhkMEZMK1FxU3JJc2pFallRR1VjWXR4NERIOHhKRFRpWVJ0?=
 =?utf-8?B?YjB6d2dvNml0TVNZcENvaVBQMVJXYTlQMEJNS3pmeDVNL2VCazRKQjAzZklV?=
 =?utf-8?B?anpwQjllZm1XSUNVMFNCbnc1K3V5aGhXc0FreHNIZDgyNGg2Q1pueWxnZTdm?=
 =?utf-8?B?UExtcHJyQ3hxK2hKUjZiTVVIQy9FSG14eVFyMDFvZXpHS0dYOWhQOTM4UEps?=
 =?utf-8?B?TzdBOGMwZ0dWdFNlWGFBZ1hpdDNKaVl1a3RCMXZTVEdqaHJ1VlAvN3NwbUlq?=
 =?utf-8?B?VTFzNFovS3EvZVZYVXFzdWQ2bVNUdkl1ZmdRMVVCaDRkdHlTbnNJMGswRkV4?=
 =?utf-8?B?NG1TY0RNVkxVMTg0ZmJ5K1hVLzJoWFJ3RTdYRU1WMjYvcmNhbWpVRkN2K0w1?=
 =?utf-8?B?Z2tYMkdiSnFPTE9BM0NiNUt1TmpvWjBEbytVTFJzS01WTlNNRFdEUHBRNmZH?=
 =?utf-8?B?eWFLZFdUaW0zU1UvSDNCclFIUjFqZU1vQW5EWVdwMGdLUjUrZzdMc0YvZ2Va?=
 =?utf-8?B?dHkwWnJlOC95REdSTjRmYWExYk13VFFqSXRWQWdua2xGc002ZWE3LzhuS0Nl?=
 =?utf-8?B?M3BuaW1GUTdXU1R0ZG9ZSEZRSk5JKzNodmtOTmpaTlpTYllrSDJyTlVpOFkz?=
 =?utf-8?B?L2ZaQnFqSWNTL0NOV25BRjZiK3J6V1htYXdBZXpSY2EzTDh1QkdTSDJaSmhz?=
 =?utf-8?B?RTRRTDNiMFByWjkyVzJyekNRWlBnTmt2d3VncS9KSTI2OHIyRFZScWhZU0Rw?=
 =?utf-8?B?dHd3azdXN3NTeGZxdThsU09zVWFDQjh1MyttTTk5Y0lRbG9NSWRLR1Y3OWkw?=
 =?utf-8?B?dUQ5ZjQzVmtoMTRHTkwwQm5pNUlNdUN4ZCsvUVBSdEh3dHh1RXNKRVhlNEdM?=
 =?utf-8?B?WitHeXc4M3YzdlBVc1NTYkF3dkNhQi9CdVJidUx5U0NkQml4b1pmbElOcUMy?=
 =?utf-8?B?eXVYQzQ1eGdzRjk3OXA2RCtQd05KbisyQkY4RG1yKzAxTSsvbEcvVnJjdjFm?=
 =?utf-8?Q?/PGf0NrjwQPj50VMqw2kyNmPp?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	JotpCV6/Q9KYYdgsLAq+gx9PFtz/k7+VHVfPRq7zUEyGT7qIQUlIy4l7Cqf/+E0OsTlF+eN5o1KGqn7D2n93z2mg42mKqVrzsldu8sJO/8SWxdoH7RT/bGSrhIupiaAcTDYzW3+2c2VuPJUhaPbPessmMhnQDrDJ24kyWiD1k2IxTjUcSAxxAjGJrmU686ZcSV2ftmiXZ32rRIqHhw+YqSjctDgGO/F1CiELI3cVzRNBSBTno0lTK/x+8Hjsy1Pf7Y/dtsdeqrGU65hczWFIjvdxsK9SB0Mn2tNWstTYlrAKBC4F1HbgnEyW8LMsFNE1RznoRuULOthQwkGEy3X9MjECoVp2OOKnMoPTo72QrWB8ldrRk6LYH2sK1/i3IonI1u3Pdmo22/W6OSnQPxT0uThxsR4Behs93h+mZFpVRZ3K0LfZa9XgU2Hs9iJboBhmiiDQmDcKJrB488BxhGeahwGook9jHQlEbW8gW9XIagrGt+CzVJXQuOzbgwkz7/ksad207DvrvwxHVs0ctOhCmOnFEkx7ACq6AJ9muFQoet4ih4xgeXsQJaVP1FTsCapNUWJq7fmaDUucToRTNOpuPLpQOiN56jjRUHTeJb514Csq3WNOEAdrR9h0CVXzsZnr1yNVOcp5pmJLlczaoJkDOH3hsXrAY+Z9zjhY9jvJcrdfYBoh+OG6zozp00pION0BdLmEnm8FO9CszVTf1J2Rp4oDiViG17LoSVx6llDyczwrXaQHkQW/rKtCfdKnTjYF4SY2VKTg1JGe2vrk21PeUAX1arfGO5dXMChaK6ZdFCTiBg1VAhYnt3Vo9wjSujH+lnozCK+z2yoE6p7NrYWq7lOAiWVFemzp6/X0qpi3ZKtJ7enK3+dPyEvJFQnOu6KqwdR37+AUILawcYE6C+3bXw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 036b32b9-83bc-45db-fe0b-08dbeacdfe42
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2023 20:11:05.9627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TGnJjW2p5CUNTlj01/1QdsSggVg5ED2h8iMPKhrMBf4UmbO9kZ/lvidMAGE9tFHD+lcxTc7yzMyQRSggM2yJpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4172
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-21_10,2023-11-21_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311060000
 definitions=main-2311210157
X-Proofpoint-GUID: CjBvs4Z9BoMQWAqOCG95A2E5vEh83Z3m
X-Proofpoint-ORIG-GUID: CjBvs4Z9BoMQWAqOCG95A2E5vEh83Z3m

On 11/17/23 5:14 PM, Song Liu wrote:

> On Tue, Nov 14, 2023 at 5:00 PM <junxiao.bi@oracle.com> wrote:
>> Hi Song,
>>
>> These two patches get reviewed-by from Kuai and Logan, I didn't see them
>> in your tree yet, would you like review it and pick it up?
> Sorry for the delay. I was traveling for LPC. I will look into these soon.

No problem. Really appreciate your help.

Thanks,

Junxiao.

>
> Thanks,
> Song
