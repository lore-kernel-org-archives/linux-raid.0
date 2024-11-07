Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3D6185B56;
	Thu,  7 Nov 2024 19:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731009290; cv=fail; b=a12miJ/XgzM57BwCQ0x8xm71ZOu+4HR6tF9ueI13BfB26a4/d3wMb1YQLzEm0Nalmnw48DuUysBMQSkoZ2tmrOU+QtL8Ykftxhx+ue/n8B7ISvweNExZeRa7s6AFjbtz/uwZQGPqWCetLqJsUInI0qo2YvZGgpEKesNHbZpDAg4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731009290; c=relaxed/simple;
	bh=ArkGIMYnfaN1hTBLG51+S+kCLHTR958XXS7IZKiV0hY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=n01DoerBxZrp0L38KSlLvnxqnHEQEvWT+cxiDNM0XS4WUTeSR2F+5HuGaXq8DVjzi3XIap4xNxEyUxjPt8bWtvM4TKo/OLyWIjaM0eXd2o0sDRGKHB7yZGPnauk/QoDkTNW2gwBvQ6TA0BsPCedk0pdMAhS+CoAIEe+q4cI7XNI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UWzKTAyk; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=p5AO1xQh; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UWzKTAyk";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="p5AO1xQh"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A7HBgnj004760;
	Thu, 7 Nov 2024 19:54:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=to3ReZrJfAtE76ItySSW4A54gh06VcuAtMeS+1UXd+I=; b=
	UWzKTAykcSbcs7knT2xIKL3ISdEVHrrqUxVyJG0Bgz4Ulqq9sTDwmoNZ9zuQDZMl
	3i/c+nS5qQ1vrAwqsgnhscpK82nwNYdcLRJzOGiUYULZ7RrM2Cv0+8N/M4hLGOVS
	0gn4wrjhw4Z74qWHtOudWOMJCO7AKO6bFkj4pCvKMjanZvbVCAaY3HHkpmFgFqt6
	7p//PJ4wS4BJ2qgK/xyrgKiVr8jqvCuzCmEmUwhAOIDK8F+yYxx2NNEuP0PjnTNa
	yPaU+cUs4hOVqS7PqBiCbQZPW8oUMZKANKsnVd7aAa++wUk7MGA4OHSP/JRq4IBw
	ouoQ7LswdyRNbhRKNvTIvw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42nap03g5k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Nov 2024 19:54:34 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A7J8eZo031416;
	Thu, 7 Nov 2024 19:54:34 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42naha88e0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Nov 2024 19:54:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ODo5kl7GY0Xc321jwk7hPTbn+OLEL8ADqkdZb3rmI7Emf1xtqpdli4E81LyFotRhvq0dc1ngY/ieSxhrIdWE/y5YIO5QPFEHX52z7y2l5RCpGs9lJC3dMtPJq9E0RR1/ucWbMPNkT8DiEc8lwhAOpBHu5Ool1idpGe+NzBGJRRMxNNuTeeXKkWibaSNmnMl5oHJwTtDBUlJoCIZIwnhZtxVurH3jNX9DaP6bo4XCOClnsEAR/BQHFQesXguyY0Y6mvzsl+5A+OAjKCHNJWMoFIgR0oofWox2CgJzpQTc7OAxrBv/kaJPWdGUxGLMajSpnYBDgoK7CFUyCt8H1nkIYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=to3ReZrJfAtE76ItySSW4A54gh06VcuAtMeS+1UXd+I=;
 b=yMc2m+buVvkR7KSsCbLlJ2A5jmSnh91MDPq6RcygE2vYZCcSgJhi2DH4xsjMTqnaDDXTp7Korb3yrupnuq+IbpJqFGjz8QBwFZriMxfL+gsH7tSigl1IpluPG7IW/8J64klUkTi+egfNwgIHFUWcKjGQVoDs2kCycwrOaXA6UgYsNO8LdL2gK1XFOa2r1OV6MdYmVgLzi8IVO+CCtes3Pt+nubLRrLqjYL32DpeQNqSNWfhXvh7Qi+Ow8cJXUkkPAYPrGXmay1Q3pbXbbZMRu6z7HOfwqw2960636JPbkvY1EITTY9hBJLh2YnairZxnnws8SvXixldO58UG9jngOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=to3ReZrJfAtE76ItySSW4A54gh06VcuAtMeS+1UXd+I=;
 b=p5AO1xQhqeGwtkRbk43mtjz1Faeo7EDf2Kt2K7/vh2yuyQGND6+Rlb81TkM7JBdcv9Dp8yZFPhxpcdr6uu+jZq1syoeCHbGlkhKQu4ApwvG9qDsmXdEauAV2Jml/zyX9QP3jJkuU7BikLSZomn5ys6xDBWnI4rA1LtvELAT96qg=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS0PR10MB6152.namprd10.prod.outlook.com (2603:10b6:8:c4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.20; Thu, 7 Nov
 2024 19:54:31 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8137.019; Thu, 7 Nov 2024
 19:54:31 +0000
Message-ID: <af9fe882-2cf7-406a-aaaf-18d4806cdd67@oracle.com>
Date: Thu, 7 Nov 2024 19:54:28 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/6] bio_split() error handling rework
To: Jens Axboe <axboe@kernel.dk>, song@kernel.org, yukuai3@huawei.com,
        hch@lst.de
Cc: martin.petersen@oracle.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hare@suse.de,
        Johannes.Thumshirn@wdc.com
References: <20241031095918.99964-1-john.g.garry@oracle.com>
 <e0a82859-6c9e-43d4-b6ee-4b96fa193fa9@oracle.com>
 <26049689-238e-4f04-9a68-db002ed5c1e0@kernel.dk>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <26049689-238e-4f04-9a68-db002ed5c1e0@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0023.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::10) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS0PR10MB6152:EE_
X-MS-Office365-Filtering-Correlation-Id: 6321b252-8cbe-45c2-e4f0-08dcff65fe5b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WFIzYzVHaDFtTkVuZ0hKRTFaQzc3TWVPYjdOSXpMSGxlcWdNbmYyL2tJZXJB?=
 =?utf-8?B?OGVXUlFweVk2L012ZTUvOHptWDNrLy84Z2JkeFptb0diRHZjVzlJQkZsZXFO?=
 =?utf-8?B?K094OEVpS3dXWjlEUkc5cVVYZS9SYXMrd0ZCbHZlSUo1dkc5T1l2aWJDcklw?=
 =?utf-8?B?U1dEWXNLWU40V0dsUGM2UTRDcHpqbGZRR2s3Q1IvajVqd1NzZVp5bGRHYml5?=
 =?utf-8?B?V2I3d1lYOU4xc3pyMTIyakVVbDVGcUtvVURWQjRRYVhjS0xtMlNqQkhkbkkr?=
 =?utf-8?B?Q01oMjc1cFUrOXkxZ1FLbS9pRFJxVTBJQndLdnZpMTU3ZGtUbGlXQm9kVnBO?=
 =?utf-8?B?MU8xQ25nRXB2VXBtQzExQ01KT0JjdTdPK2R0Q0RLMEU1a0RpZ0dSMjA5cndZ?=
 =?utf-8?B?OU9mVU1Pc2lGejZkWEFscjV2TTJ4Z25XVXMwamlvV1ZWdHpmd084WDdIRzJ5?=
 =?utf-8?B?aFUvd1ZmcEpOUW03cG5MSnRCNnhlVXhnZGRLd3l1S1hYcnJDSi9LRGpBQW9n?=
 =?utf-8?B?dnB3cHpvZlpubjZhdUh4VGUzZ1JQNHpJV3RoNHpTS2NzcFFCWUVGNGYweGc5?=
 =?utf-8?B?RnlDZmw1SnVzRjhsTUUwQVI3NkFKZ1lqTEptdzdVZ3I4UE42ZXZCdTBaN3ZL?=
 =?utf-8?B?YVN4cjloajV0aW5GV0ZQN2MzeU9VN3ZnWk5vOGZ3OENVY28vUk5WTFpZeVFx?=
 =?utf-8?B?Nm5Jc1BSMUVOTmVrMC9kUWp0eXNtdVBaRExrdWhQb05zVzNJQldSYnhBTGxI?=
 =?utf-8?B?bWtFaWFnaU5TQVZleVFkVFBvMVFDMzlzWExVQ0JVSkJHdVo4dW9DOVdMS04w?=
 =?utf-8?B?b1lGbVJ5WE5qQ3pwZFdLeFFJSHc1OUF6SkJRYllvdDJpTU1wb0xOYXZTS0k0?=
 =?utf-8?B?dWFPa2JsdUZBZWJJcG04YWZuR1JUVFhZcGpUT25iMkc5ZlJqS3k5dWM5eEdL?=
 =?utf-8?B?Z1ROM1BTVDRYRGZEN1VhTjZLdjBRSmsxYkF6bnlyREo0QXpscWhic0JWRXR1?=
 =?utf-8?B?ODY1UlBiUzh5azA4NHRxZTZiTHBNdldhbTIrVlFoSEsxY0g3eXMwbmhBVW50?=
 =?utf-8?B?Q05Jc2p0L2M2NkZ0WUpFNVZmWnN2eXhnbTRCUGlkSDNTSEJ5UVp1YWlRamFs?=
 =?utf-8?B?d1M4NXRZOXA2ZWZDTExmVGYyVVpMeWRsNW93QTV3bjZmN2J5WERRSURQT0RP?=
 =?utf-8?B?bENVUVVLb1hqTkVvdldxcWNVbDZQdTVqQUZuU1RoZDV5UWtnL3hYUXZrZGtH?=
 =?utf-8?B?QmxPNjkySEZoTEVyYU51dDZ0UGlSbi9oRnNjOGFrT1BsN1lUelNrQW1CekxC?=
 =?utf-8?B?blF5cTFHMFg1V1hvNWRDZTlkbVdMZXRUVVcycXhkRnc5SE5PRTQ4bW9LYXJs?=
 =?utf-8?B?VVREbEFKaE1LOThMaGU3WlE2ZVQyZ1JFZmNSTUMwVHgxMTltZjVXOVNsanZp?=
 =?utf-8?B?dHhYekN3M3ExOXRaTjVwWnd3dHVIOWxLbGh2d1htNUhLUUt2SVNqcHg2TFcw?=
 =?utf-8?B?dnFZYnNYMWpEQk1xMmo3MklKcG5oNmRwbzlTc0ZVdVhKUzdSenBvbmNjbzZV?=
 =?utf-8?B?enFWeHlOTVJCK01DbTNtRnZGMWN3RjFjMFBYQnNYYm1SYkN1aThEdGtTcFFk?=
 =?utf-8?B?eFJybnY2ZzlwMzl2aDR2NURLb1hkOXZSUTVoVEgvdjZCT3VzSmFDTXBtaHMx?=
 =?utf-8?B?dGlnU3VmeU9oSG9STVNUS0daSndOekN4aS80MjFwUHZLUitnbnJ6SzJtN2RQ?=
 =?utf-8?Q?bmNzN3edodEoASGfRPzrX76V0ovfz0i6iG0RC6M?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L2pUUlRVNzVrdGxqdUx2ZmtsT3R6YXh3ZjJCVG9mSTZEUkprY21vRnlZVGxS?=
 =?utf-8?B?TGtJbDlHK1JqcmF2dWpSbVE5NGREcDlyV2grNiswK1c2VytKWm93VVpSUCtD?=
 =?utf-8?B?N0lLMTFlek9rQzlYVExYYlFyelRoUkRHYUJpYXJ3cFJCRzU4b1JwV0VrNURp?=
 =?utf-8?B?bk9kNW56TVRGT2pMbWhjNlFvS3Z4L0tHcnhWVVplT1ZQVWdrY2ROWk5BNXZV?=
 =?utf-8?B?cDlOd3U2OHp3dzFwa2FER2ZQR0MwOWNyZEp3UFMxT3pxdU5MUXREc3BxVFZX?=
 =?utf-8?B?c2ZSdVY1UkxGZ2ZkUnNPbTRVQmJNbjR0R0ljQ1I2S2FCdkNOdUVCakltb0Rt?=
 =?utf-8?B?YXNiU0hMNmdzdHgrUUV2ZnlnVzAwTjBsNE1LL1R2TzNOMmVaTkpjRmZtZ2RZ?=
 =?utf-8?B?dm4vY21yeDJLN0hHSkhhZkhUUDZzM0RkVEljaEJCODdFRXpsWXIzbkNxV2V1?=
 =?utf-8?B?R3JWaERmWGJYRjUzZXE1dlZtMWpiK2lpclo1UXhySFFYN0hFZ0l4Smt1REZD?=
 =?utf-8?B?NE1MMUhMekRRYUdzK2dPdmVNOEE5VmxtaWlGcDVxZmt3c0pDd3ZQS01XWXZp?=
 =?utf-8?B?TERuUEJrRXdyeEtTVCt6Nm5VOVZ5c2xEOUhjcThyOEVGNGd6OFhvZFg0WFV5?=
 =?utf-8?B?YUVNRStKZTRmZkJpTm82dVVvbjB2c0o3TVZMWFRrV2pIMHBOLzB4cFVJSWxF?=
 =?utf-8?B?RUp0NWF3UnZNT0lBeC9MMVJUUFRtSkQwV0NYMnV2MEFNZE9QTUVhakw0MFRr?=
 =?utf-8?B?Q0ZYMHdYSkYvd21xZSt3dDFyZkxoTUVMR1BCMjdqcHhSQ0VCZFVMWFFFMU90?=
 =?utf-8?B?ek1BZU9yYXdFTzA0YWNaZ2F6MHl2OGJneGFrckZHVitqTVNwb3ljY3ovVmRY?=
 =?utf-8?B?RE9YYXRUZlkrdTlsRzVBK3ZXbDV5TjE5TXllb2plbWQydWt1TlpLcEtXN2VU?=
 =?utf-8?B?am1zWGUrLzRaUVVsc3YwMnY2YmpRYlRPZU92T3RSbGh5Y1hXbmwxRXZvZDZq?=
 =?utf-8?B?bG1rUVVDeGl1ZGI1dmVZaWt2WFpRUEROZUNiRkNpei9sbnBzZ05jbXhwUjFO?=
 =?utf-8?B?cWVTR2czZFY3SDFJbVpqRWpRcENqV2x2cERnQStMVnBrOFhBTkNjTWVCakN5?=
 =?utf-8?B?R1lGdlJhYVg3TWNrTDFMMms0T2VtcnR3UkEvZnJNbHE2N1BuVWo1RE1pemhh?=
 =?utf-8?B?aVp1UDYwSm5tVUJybXdqbkx6QmlNQUhjbjZoalg0ZmMwcFZLdkl5VHNwVm5L?=
 =?utf-8?B?enNyUDhWbURoeXNlNlBHdlplVG0vOFdNMGNlUEZicHZ0eXZFNzcxZzRuV0dN?=
 =?utf-8?B?T2RTcGVHL3A4ejdGbVB0VnBDZmQvemZyc0hrS0g2Z3pSMzlUdEdyclNpdkNo?=
 =?utf-8?B?VlZDOVJCa3RUS2NFQXZUajF3dGdreWdJQTBZMWJrVVVzSVlhU2UyUE56VTBz?=
 =?utf-8?B?VmZnUGdxWDRzbS9qTmF5NVY2TWZNOWM3SGd0SzA1N3B3S294MGdsa3lteGoy?=
 =?utf-8?B?TWlrazVJMzQyMVprb1hvcXU5YmxudytKcjgxRUg2RW9JL3kyWnhQTXJmRDZI?=
 =?utf-8?B?S29VOUxIOW5SQ2pYc0o5YmVsbkc5VkY4NVNZZ3BrSWR4NHhEK2NBU1J5dGRu?=
 =?utf-8?B?SUIwN3JXNVdvMUpXRnRDV2huY0g3eEt2Ym5lVlE5TUd3dm5pSlV3Tzl2WU1s?=
 =?utf-8?B?Z2VHYWFQOUVrNHpEZGZzZGtWSDFBT1ZoT2FuVVhQd3pSLzRCSTBoRWtUdW14?=
 =?utf-8?B?MlZXWGp6eG5zY1d1M3o2aHl0a0oydkU5RDJxZFFjd0o2Uy9lcFdjYVZqL3h4?=
 =?utf-8?B?bHk5VS9BMmJ1MENMeWJ4aFVod28wMCs3UGRROFc1RStvVXBhVXY4NXpqaG1X?=
 =?utf-8?B?a1cwQm5EaW9zL3ZPTFQ3QWIvazA4UDZjNXNGWGtkUGdacm1uczVVSjViTWJs?=
 =?utf-8?B?MjFEV2tXbjl4MnlVcjJTc2htZDdDU1VhaTVVQUtDWUN0ZVJqZVV5SHNUUmhE?=
 =?utf-8?B?R2RHK3FrOS92U0lzQVdEYzY5ZGtKYmVLa0I0bWhBQmErZUxqcFJpSm1MYW1C?=
 =?utf-8?B?ZkZ3WFVmTnI4YWZMTmJxMHgwdllZM1RjN045V1hjNzg2d0g1STM2amc0SU5k?=
 =?utf-8?B?dURxajZKR0tvejVSREVNWFd3QTRLc0F2L2h3MjJtSjd6OGs2Rnd0T1RXMUpQ?=
 =?utf-8?B?VXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qEpB581gObXVDwp6k6C5v6LpWmS8Bv6Tozh0lFTsa13Kp79+GFkco+0YxbCuTcfyjN7JuWrt8tgmMRC7jt5ptHAPa9bX3VaiH29UMc8LJHIcehCYTMyA+xhWb6dG1MKVjcW0yPwFIn4uSdB86t+0jCQEBJjU+QFwz8vaONLIOTOCPTw2+Ze4htK2833MM24LUlTWBMk1zlK3DEVn2jYmb3FajHEcoELhTXMNe4im/hkGso2eKbpthKepJ19QJ7+cJy9wxjQ7BdRMMWTxQf/nJcePrKhirqLxH2Fop71Ltcx5XLm2CnuS6j263RVtX9hxOov85f0gaQRM43FWm2nu3Orh4MsDWLafMXliA7/PRWGjO3KlY58JfA2FLhLfsNpGInDfbXn7nUNL4hwTaMv7N9KXC+l+20IFx2IjU8/YvKzkeBv2Jk8Kp0YdrH88Vb/xi6Sfo3s8zNp97DIRIlTRu2zsKK+5MxQKcUWE0uz8/3L3U9+JKjMe9FoOFxWIt2e4oHM9PcaUA4qVehdWWnowKfiDKGCsnlVxzNB9yxYC84HKwoq7E9QHRulxute3DmJ7r0vv3pgcbdnvs/Q06JvwhGiy+15rVmR3HfAFl+d7Ilk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6321b252-8cbe-45c2-e4f0-08dcff65fe5b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2024 19:54:31.3053
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oAmYuroHK5WVxdS2phkbpAcjmI/3BgRAN6CW6cgb48sbEULyVcppnuxPUw7GjBKgkSRVI0m96WU7H7FUQOKEgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6152
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-07_08,2024-11-07_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 spamscore=0
 phishscore=0 malwarescore=0 adultscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411070156
X-Proofpoint-ORIG-GUID: Y-i1L8tK4Ub6feCnJwZ5rkdLgZe9hxl3
X-Proofpoint-GUID: Y-i1L8tK4Ub6feCnJwZ5rkdLgZe9hxl3

On 07/11/2024 18:27, Jens Axboe wrote:
> The series doesn't apply to for-6.13/block - the 3rd patch for bio
> splitting conflicts with:
> 
> commit b35243a447b9fe6457fa8e1352152b818436ba5a
> Author: Christoph Hellwig<hch@lst.de>
> Date:   Mon Aug 26 19:37:54 2024 +0200
> 
>      block: rework bio splitting
> 
> which was in long before for-6.13/block, which it's supposed to be based
> on?
> 
> Please double check and resend a v4.

Hi Jens,

I was based on a recent commit, 133008e84b99 (block/for-6.13/block) 
blk-integrity: remove seed for user mapped buffers

Anyway, it is a week old, so I will rebase and repost.

Thanks,
John
