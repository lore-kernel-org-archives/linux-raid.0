Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6405B19A292;
	Thu, 31 Oct 2024 11:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730373508; cv=fail; b=DKAj0n66NknztbZw4SsUTWE9VdvhF334mFI3VCYXV3J1xFatPiZGE+Okq9kEQPgArbtDr3XLFo30NRjmaCablYzVc5rm4Wl9GnivyiCtnwi4/g3ULjnjFhszR8egjOXDECBFgTZTEEd/K58gvnJOqQZaCPj/i8dsnEIF5xhX0ZI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730373508; c=relaxed/simple;
	bh=3Cu495/6zf2d4uWVbkmdiH7yzoLK7pdRNutcL19k844=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VuBRp02qZS8ROWda7K09TLN6lRMS/sqote/mW//8i+pgiWMgmBCAm+/SxWMGfK36TIdQxrSa3gGI19v3noK8loYFQ5B97K4DA3gVCiWYUCxC1oB4d2o6vSyMgyrDCZpVi/10Qtu442VkcRvotAyHywCg0pw0Uox/LHtePVqbmo4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=N1BwEzsS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ixe832wI; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="N1BwEzsS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ixe832wI"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49V8tX3P023679;
	Thu, 31 Oct 2024 11:17:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=ESyxb2H4xhwCteWurmtIdkubb5/i88dJy1jZQR3vBmQ=; b=
	N1BwEzsSZAVeb01GmvvCeNTqxQbz3WxP2enlwiYBUpi0xd3KiYsWf881mWlj2iGZ
	RVaou88De8gCcAo1G92LLy+nOsOnwHSlWd7txaHwrGuN399juf5bdq9OaXKNe/bx
	liRWCifqFk75ohSRV3ALUXjWnmZk2OROawWSTCoRLsdtiSxPpICIjonxwm5Zn/F/
	DuP9gMTTW7BRkoXcbhPtXy+SrM1BSFb8SRw94x9j6rFSpYfbK2TUszJZ3IY12nPP
	fBELyyI3UkZJtwg/FdPLcHcDguNtocICf6u7hTwqaiyZhKvFCo5z/HLY4bc0DJaj
	Iu6Cd9VJlk/NN48O1c+CYw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42grgmj4gw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Oct 2024 11:17:57 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49V9Iugf035542;
	Thu, 31 Oct 2024 11:17:56 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42hnda965x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Oct 2024 11:17:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h9Z90PqcjEI/Dcs2d4Ij56RONAb/5d9Tr/Xr4SpWNEw3N2bW7L38YCAvXsjPhqUqgXttPmT6e2SNv9ZUWAEHgSfzsKpCWCJL8imMeUxeVnmFs+oqC7jOClQhg5Vz7XG++FGKmUASw2Mo6ar8V78gbNakicHGQ4xuShlKinFK+9yh8h6/WJd1l9gD9GA0iyqoDJW1x6FdqIiOtmextS7vuBIOgxvCuBktp+l+nRc5KpTYjn5pR3V6qvjXRGHkKd6fo24djlurES15ZsWIvi6zYKH7eFeIedjZm9nTO1AkChYAEI9wjYwV36gtbaiAaIBaVvQ0sSforGJEHo3tTqf8BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ESyxb2H4xhwCteWurmtIdkubb5/i88dJy1jZQR3vBmQ=;
 b=ddazIYdh0/0J5mMIWBXJc9CsVrojruoyBzl8S55g/9golSML9jy/K3HeVpdBwfJwQH3frS6i2JLaVRVBZ4ahKwSdN5V7gvrnHQi10Cf5F/Se5uavY61a3Vw+r9K47jMEYuXsM/izgJjkg26G4j0GIIRsQ/+P8OnEwIqyhYjuMUIxpbXpycui9W7kOUxOF5EOAZUBfdHhr44Iuc+bW9rINH0usgPfWTfnmaPc9scc2uaaTq66Z2IKcb9TrkksI1bPR+8hWLcs/VaPKWyD48H4VJcdYyjAX8gdIyJfeZZQQEs8lOgcE/N6SaWw8rdxtV04InBA6S2qpy9ZN6tgQs3ufw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ESyxb2H4xhwCteWurmtIdkubb5/i88dJy1jZQR3vBmQ=;
 b=ixe832wIgbygFgkIFUxMTjBblHcdjT8Cj8mxYEIArDzFkxNSWq/umoUtJbDM/te33yhXZIZmg+ZIvb1wDIpHs7Gs5t3OxPerTeH6yO/dB2BgNKN1J4N/qeS4p4z+GvK1j/q8Cfya8NPd1AWH8RQtXDC5WS3eNgg1sxhmc5XGC3w=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CY8PR10MB7122.namprd10.prod.outlook.com (2603:10b6:930:70::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.32; Thu, 31 Oct
 2024 11:17:54 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8093.027; Thu, 31 Oct 2024
 11:17:54 +0000
Message-ID: <e71e8579-1780-45b6-8f1e-605a1289394d@oracle.com>
Date: Thu, 31 Oct 2024 11:17:50 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/5] md/raid1: Atomic write support
To: Yu Kuai <yukuai1@huaweicloud.com>, axboe@kernel.dk, song@kernel.org,
        hch@lst.de
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, martin.petersen@oracle.com,
        "yukuai (C)" <yukuai3@huawei.com>
References: <20241030094912.3960234-1-john.g.garry@oracle.com>
 <20241030094912.3960234-5-john.g.garry@oracle.com>
 <d4d9d0cf-08ff-6494-172a-44694b6d13f9@huaweicloud.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <d4d9d0cf-08ff-6494-172a-44694b6d13f9@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0195.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a4::20) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CY8PR10MB7122:EE_
X-MS-Office365-Filtering-Correlation-Id: 45adaa40-6337-47c3-d45c-08dcf99daa42
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MDlmWWY3ZWdrK3UrWHZFeDZPQlczVGRJTXJVVzZaOXUvU2U3a2dGdWt1Rktr?=
 =?utf-8?B?M1V1RXVoNzNYRjlSRllQSmhxM3hZcGhQYTZRL1pPZVUxa3EvN1J2M1FWY2RW?=
 =?utf-8?B?K3RtMXRBeEFMcmNObWZxZGNxemp5dFdYMVdhRlpJTVZSd2VjVG5Pd1QwaGV1?=
 =?utf-8?B?UzRodE5pbFFDWUJSRFJNRTVQOXJWallYV3ZlcmR0WDlXR3crOEQ3UmJlVjJG?=
 =?utf-8?B?aVhxZU1nM1lrUklOQ250VWp5WnJBOHRTcFFndVhzZC9YOTFDVWI2WnR0YnQv?=
 =?utf-8?B?NFJ1VXVWRUg3RTRLQy9iZFNFb2Nwa0w3K3pBQUM4RU8weTJPVkVpa0xES3R3?=
 =?utf-8?B?Ty9kcVFDTlYxODlwT1NvU0FiRFpPemNpRjJrRVd2MjIyMHNFNi9PY3dwQjJu?=
 =?utf-8?B?eDJPenl3UGNzN3pTWHVuRWRxWjljTU9ya21hZ05TK21oMnlCVkFRbXlBK0hT?=
 =?utf-8?B?Z1ZpU014amJsWEJlcUVSSVQ1K1Y2ZFBNMlhPbWNKdFlvcXFQNEIva29kZFRK?=
 =?utf-8?B?TTlLbzExR2gxdHZjUmVwTTR5T2d3aGM4YlFwaG1Va2FBa0gwdkx2SittSm1R?=
 =?utf-8?B?eDB2cVBHSWJHSXJ0MmRSNmRySlNvdmJmTmhIeHdPbWEyVGNBQ204UGIyczdo?=
 =?utf-8?B?R2Qvc29Sb0tlR3lzSUMzbHNvdXBWcDI5QlR2dE40QjhJcnhwdEdONVliS2tp?=
 =?utf-8?B?ZjI0OVB3SGRQc1J2a2EwQjViTU83UUZaZ1g5UEQ4aEg2aTZTS3NTWlFjUkdC?=
 =?utf-8?B?d1h6VHc0SUNkbTRaZzVuV1hCQ1diM3FXUk80N29vZDUzYmVlYjRpdTEvWmxQ?=
 =?utf-8?B?a05ldkZMblZWa1lVV3JpaE9rR1ZIU01tLzRsUVBnZmxKbXNadmVIMjRDMHN2?=
 =?utf-8?B?L3grZ2wyZDUwR3VWRklQUGQxS0l1cytpSDgwS1NydklrOWdTNjFPMm5Wdm9t?=
 =?utf-8?B?K3JLUm9nZGxKT1lHWXpTOTdITDZPQ2hGQTNtVG5HcmtJQ2tUOFFEeEttWDgz?=
 =?utf-8?B?Zlhpc3dSbExsRS9VZUcwNDZLd1BqM0JEV1IyZDNKWURuWnVNR2N2M0RxNVJ0?=
 =?utf-8?B?QjVjZEtwdUo1RTFuTGRVb2RSTVduaHhVanBSTjdkb3lsNEZEQU5tWWVzS2pM?=
 =?utf-8?B?dlU5MEt3SGVGbFU5T205YmQya3prNEtESWsxNlIrZEdaTzA3RUp6U3VXb1Jx?=
 =?utf-8?B?UnBKUU5mQTlvZW54Ylh6bGtkc2RWRHlkV0p0eG16UGNRU05zcmcrQ3RZSk5Q?=
 =?utf-8?B?NFhydFhQRDZGUUpPRmFHU1pubzhhd1BmNzRQRXFoSW5XV05SQVNRcG9SS1Ux?=
 =?utf-8?B?T2Q0c3FFcmFUYzBsTkdLMnczNGJvbU0xZUxzdnBDZ2ZrN2hwbHJhdDNqREQy?=
 =?utf-8?B?dlBHRHI4UUh3TCtlYWpKdzhhc3pyeDJrb2wxZVgyQ1ZVOHBKWE5PWFc3UzBX?=
 =?utf-8?B?NlVlOUU1aVNBTktUUytlK3RBQXNrUXNCUXR6VGhsbDlRNnoydzNubkVPN245?=
 =?utf-8?B?cFpRZWJZMFM3c0ZmNWdrR2NrRWFqdFNZK1lrYkFLOWhCYXB5ZlNjRWl6dkFL?=
 =?utf-8?B?WVlVdkQrSHlrU2NMcWg0b0dhZFZUUVplTDY3aHdpeXdoVC9DN0o4L1hEbm9R?=
 =?utf-8?B?NWY4ZGRKVFVsYUJ2OGdlbGlIbG5TUUpaWFJaeGNTVWh4dndCb3BSQlZ0TzhD?=
 =?utf-8?B?bzhobGV3WmVSWldHclh4ZHdnK3pWS3ZUTGlDQ2dXSFpTOXNRdG5TR0NMdFJK?=
 =?utf-8?Q?jIsSciNJSiumfXYNOI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UWNUUHh2eStsNHUrSGFkSUhvaW9vZ0tyTkhYNGhKUUV6eUYyaUt3VnhsbkRs?=
 =?utf-8?B?Y0VXVUkvRVJVbnhwVVJzNG9LbytueTJveC9JdHFROUNSOVpwY0w5SDRzSVMw?=
 =?utf-8?B?YlBhSkszME9jL0J5MDlDYTh2dHVDdWdTMkhKYVMrZ2RJbDNkdk0xbXdIQ0ph?=
 =?utf-8?B?UWQ4SC9WYU13R3BVQkFIOHVmZG52SmNnR0diYmlEdlhad3dTd0s0UWcyTFpV?=
 =?utf-8?B?eHlycHp3a3Azc2lJK2N2TCtvZXV5ZjJwdXdUZVJCa2RPY2lPbG1qNTQwSnFs?=
 =?utf-8?B?WjZGM0tCQ0dGMW54VEF6ZHZ4ZFVVWTIvanpNb2hBRXk3VkRXOFU2T2xEU0Ny?=
 =?utf-8?B?NThQSkVEZE1vTXFCd1R1cDdRcXhNN1h3Ly80eVAxYmFvWEJ4ODBwY3hZSVJh?=
 =?utf-8?B?U3cyeDlzOVFjT3FMbDBZRC9CUDFiLy9Zem0ybFRvZlBDMnJpZWx6QWZyamFq?=
 =?utf-8?B?cTJGa3IveW0yYnRRZ3ZLdHJOdEs1YXF3emt3OUUwRUdEajA2eEI3Rnc2ZDFP?=
 =?utf-8?B?WXRlRVVpT1dWSGhIbmQ2ajZ1bzdOV1NJTHFoa21sME5PTW9GcThaZ2Z2VGxv?=
 =?utf-8?B?WS9lZkZ6VHR2c0R2K21mdUV5Nk1xZU5RcC9aajBYS0pWbHE4VW5vc0lDckNr?=
 =?utf-8?B?MEw2d2lyajRjRlFNN2dlUWduS2FMajBNaVRIVVNmdkU5U2w0U1ByMkVxZDdD?=
 =?utf-8?B?VTBaSlJLanhkVndEVlRneW5SRlIxMnJ4L0xSeHA0YWI5dmZHVCt5Si9zVEhO?=
 =?utf-8?B?UEZEK09jZGJ4aWJYLzB2dDV5aE9wRHdZeUFwTTNwZWdsZkIrTllRTDlMc0pT?=
 =?utf-8?B?RTl1aXd4QSt1UG5abDdISmMwbEtyUERzNExQdk9XQkkxT1JnMmcwcytEelEz?=
 =?utf-8?B?Z1Z2NEZjQ1Mxa3NHTjNtUE9pZDRkN1V5SnRUTHVJMVpVRlB0NG9QT0ovbm9J?=
 =?utf-8?B?TmtuMmxyVXh4bHM5S3A5Y3dmM2doOCtuY1QxNG9uZVR3eHdaOXNBaWYra2VT?=
 =?utf-8?B?U3E5ODVDMEJ0YnBxb2tIV2Z0RHR0d3ZkckNqQjhJenE5ZGNIZDJ0ZHA3SUc0?=
 =?utf-8?B?eXFnOUNyTDZWMi9ySDZETjZsRmpBQ0ZXeEpYVVBnbVFwRnFZS2x5RlVhaTh6?=
 =?utf-8?B?bld1ZWJsVlUrSytlTzZXVkVGNDArVXlud1hRc2F1ZDdaUGt1Rmt3clRTRHp2?=
 =?utf-8?B?T1pyNGRTczlwNHBoWWdSb3ZTSGxpQ0NEQnB2Tmlsc0VWNnJhZ0hNOHlTb0dq?=
 =?utf-8?B?OEFDQmZoc3BrUVNYVHRRTENEWTZyNGFvSVpoYmVqMjVEQ2txb2J6Z1RFYVF1?=
 =?utf-8?B?TWQwalhDdi91VFZaYm1OTXF1K29WRWQzWG5IVUtCRGdMUFpkRXk3YUpVdTR2?=
 =?utf-8?B?VzViY1JXWnEvK2x5dWxOTVd3SU5ta0JVSno2TkdEcXhiUCsreEtNLzlmaWt2?=
 =?utf-8?B?bDh3VVh6bmhIbnBlTVQ0dmVsYmNEa3JhVGNzVW9vbCtxVWZIVzNJdDhvNklL?=
 =?utf-8?B?NUw3VVU3bktQaG5nY0VUT1hDNjZxVUs5SVlBTWtPaGNtTnpybHZ1U3QwbkFn?=
 =?utf-8?B?d2pSNmp6NDRRUi9WNWVmMGtNa2ZNMlIybjJNcGxEbXFCcjdZZm1ocWpKa0xU?=
 =?utf-8?B?SEIvZEpEZ3ZZWHYvZmI5R1dGcXhCQmtmcFJYbDl3cjViRkRtT3ljdjlBOUpw?=
 =?utf-8?B?MjIvT3lNK1BsVTRUd28zS0t5V05oZHNWVDVtZ0d3TDdtN0xVeTVDeTlNNHZZ?=
 =?utf-8?B?eHRUZUdvN1NPL3BqQkg3OGxjcWJ1MHBpMWEzUzVlQ1hlQm03NWpkN3ZJUytz?=
 =?utf-8?B?eHFML2lKYlB1RGE2N1A1SFpNWjhxa3dzcmc5YVBZUmRETEpuaVZyMzlyS2pO?=
 =?utf-8?B?SmF0bmRZZVhHL1piRm4rbWpwV0M1WUt4UEFRaWh5K3FPL1E4emU0NHhYT3FD?=
 =?utf-8?B?ZTc4S1hDdTVTUlNjWE1UU2I5bkxJZ0p0c1MyNnJkY3BXZVFYWVdteVl1d1pB?=
 =?utf-8?B?bHhDVnZLSzJSNmo4WktjQ0xMT1NrQXJoc1RPeVRMVkJFTE9lUi92ejZpYTJ6?=
 =?utf-8?B?eFVockhQNVMycm01WkFFRTBrZDVEMERza0ZjbnBoV1VZMGwza1crWjVRTERC?=
 =?utf-8?Q?dqgDK/3X+fCxn9oAJ8gBG7NKb?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VH5U4yQpsxy4NINlsdX7PUblMYOpZE7xRFpmxqi+cNJsSo7pgFatlp9BW6rLf+dt3S2PARehPAWEXSpW0GU/Bl5wSjUby994SnxvWQOH0LyoYKfdFMWhc5WqcJE0LB/psmQOZt3Lk2CYaGF0rKfRVyrkAMKNfb9lHY23Tm/9gQELLUWXHTPNEuQdKvIfjHig1bXn8fxYhC21bJ1AZOSTj0fHf/IdREQt5Co2wQxMICUkPrHTo0BEjI63+dStdXigEZK2kfpOc6jDO855P6ewURIevXkiN1x997Kthb0mqd0o2jUIZn0lU/v8gjFE6z+CBQv+g9g/C60FU/CIHNhmWex70JGR/Yk1tE9bJvwnl1uD72VOBWR/9vSJSbEnDoSBnIpbGan2pz6kpcziQM9YeHHWTWuLVSdBMkEkA9rxcyMwbFcCB9Z26uTKKsoXAt5X45fiGq/+cTBtsVGEurHnd/eEo5HwE7ghSMfLpjjRfFSmZuNgCAiJq11liM87VZdNNp8z8n7w8bzQU2eMUQPWQLQz1mnW45LXoAK1a8ul9SB1W/dXwIcXm4PXjyl5Qv1qrF9QXcfKPRQQzuM4Ah5S44ExqzJi4qiFvhsOBy8UJ/0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45adaa40-6337-47c3-d45c-08dcf99daa42
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2024 11:17:54.3908
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qkNUWdIfWY3wyMoNkbAbfbvaqMeNaQdUiGPxVZQZrWO1gwnF81jB8BKd2MitD714xaKjv1B13Xw9cFuYrROr/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7122
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-31_02,2024-10-30_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 phishscore=0 mlxscore=0 bulkscore=0 suspectscore=0 mlxlogscore=919
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410310085
X-Proofpoint-GUID: mdHJmb2RLC1MsRtAxP4qtw_4Cq_QJs32
X-Proofpoint-ORIG-GUID: mdHJmb2RLC1MsRtAxP4qtw_4Cq_QJs32

On 31/10/2024 01:57, Yu Kuai wrote:
>> +            if (is_bad && bio->bi_opf & REQ_ATOMIC) {
>> +                /* We just cannot atomically write this ... */
>> +                error = -EFAULT;
>> +                goto err_handle;
>> +            }
> 
> One nit here. If the write range are all badblocks, then this rdev is
> skipped, and bio won't be splited, so I think atomic write is still fine
> in this case. Perhaps move this conditon below?
> 
> Same for raid10.

ok, I can relocate that.

Thanks,
John
