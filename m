Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8681DEFFB;
	Mon, 28 Oct 2024 16:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730133511; cv=fail; b=qGMez+YHUK9o3pGjXCser6bA3XHaZa5aD8oSp+4nu+oj1qm8atRv7NhNuuisVuDp5JNBam7Im+Y1hFaGjMR1bq9LyBtbXgOlMqSjRphwO6GL23DziV2n4BsCwhu9WarhPTwO1zHXSuCppMRmOepMtNCfM3e+evq0NS9HRzRsONM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730133511; c=relaxed/simple;
	bh=2C4PQAzU461OfP90TswWb5BE4rFAz6Te4vwOTFIawq4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=h+OBWh5kXyOs7mEbqgsG306aRcx/pyNDQJc2fFnLY7X7ix1rgqr6ie3rY2H8JcQywSEpOj2dL6l7zIQ2QOq49VDIIEUMYjQJ8QGOF9eTBjZBe/husV8XOdhkMmXo6Jzsw3KeX/TXn3GtQe087xuhsP9b2t3VNdhPDzZ/Tr+BFbs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BGWVc/Hj; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=yhhyYKTP; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BGWVc/Hj";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="yhhyYKTP"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49SEtdM9020881;
	Mon, 28 Oct 2024 16:33:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=/xIPoJWV18ON54hzQdGByZ4h+dLSSd/U2lFooSLtHZY=; b=
	BGWVc/HjfBlBvHQ/PSRKO1NgFOBXaL3Q2GuklQG/hI8T7S6WWosbJd/7W00ltiAc
	Q57TAfEHtebmwn6w/ZMyHXALOvdqBfcZMYb93V8xz38xNAdCuJTexTvAMi9ref8a
	PY3XLG0oNqMANGVovRsKKDuhvOQg0paKSuon99tNeaKzjf0zzYjddL9pXy1k6VmH
	tWm4+IJBgH4noqjD0XR7ezXviuJ//sv/sWgfez/H2VgWDD1e0ZNt+u+t32llMZrD
	NP9tfuuzVOFsC+iHGfkLs+OcQtw5zXIdPoQ67+XQVuFuuBffh/T7Y5f1MZ+2viqg
	XN+PLDhAmNdLGeHGiIuviw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42grys3b2k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Oct 2024 16:33:14 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49SGT91C040411;
	Mon, 28 Oct 2024 16:33:14 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42hnamnj8d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Oct 2024 16:33:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=exO/aocmZxzDi8Z8BpXsBuK52uw6VVWjGpABRkIAfia0r3yInC9E1s2nmkwmVxd4zEE2v215xV9yxyBATGize8mQ2YDvuXDzrmz1cb9Ko/c8zo+i6X47PysA8rztd7cH8dj29w+IdS1tipnupOswdCjk47G7JWlgYsu2crBChqyhF3D/Cs5aYmHgTTd0bjKLNgb0C4L9vAtEdWqzBE6TWHipHp1XsfdgGGtEgB0/C5Z5trjYoan5URww4MFEWua9oRrciscNBMa6x/kbaJk0lMfzVh84z1vlnsoUpPU0GksDp40dxNibO2nPZXRoKyZEzC17Rsyr9KL/wzyrsBIHwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/xIPoJWV18ON54hzQdGByZ4h+dLSSd/U2lFooSLtHZY=;
 b=fAsVGYnzTbI2Tk1Tf7LtsohDCBLTFUWNHpk2xJRNPVLdwM1yFN2nZQVG6zZ5a1Ei3ojtVojRCpj16whaJM8KJEO+BOKNZe+FXt2hJMuQoyR/erB63cZzad8EuQnBe/eN6IcCX+UCuKsDKTA719Xhlbf3UgFpvjjYVqhQ1NNqfODMZfl5isl2Gjql+RHyg+V0twF67mgoe1toM5/80zgBzKU8+KPICQI6qalAU3/y7CaAOU9lo11mOS8DGxN+Xe3F3GdUdAlPBhhYgBZpfjOnrJGjYzC0PaSIiUIXNLB5UgjewxH8ad2moiM3oBFdDQ+LfhmaPYESWj6QmBNkcDCzmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/xIPoJWV18ON54hzQdGByZ4h+dLSSd/U2lFooSLtHZY=;
 b=yhhyYKTP15Y78xYAdfon5l8V+n8cku0FhSJrLHautpN7ta3JAjxKhk2HMS0Q9k6Y5ecbXAo/meh1k985ZpV+41iegKfMAeEj7QCKSY/p6CIP57O4PxXWtER+q0Cn8pei8/ebFGq5NrYrfK0DS8mQrSLM8pK3m0RbLiHKslSk0fk=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS7PR10MB4942.namprd10.prod.outlook.com (2603:10b6:5:3ab::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.24; Mon, 28 Oct
 2024 16:33:01 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8093.024; Mon, 28 Oct 2024
 16:33:01 +0000
Message-ID: <3e7d2823-5fc9-4c92-8278-ecde863bdb01@oracle.com>
Date: Mon, 28 Oct 2024 16:32:57 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/7] block: Use BLK_STS_OK in bio_init()
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com,
        martin.petersen@oracle.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hare@suse.de,
        Johannes.Thumshirn@wdc.com
References: <20241028152730.3377030-1-john.g.garry@oracle.com>
 <20241028152730.3377030-2-john.g.garry@oracle.com>
 <20241028161128.GA28829@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20241028161128.GA28829@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0184.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:311::10) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS7PR10MB4942:EE_
X-MS-Office365-Filtering-Correlation-Id: 71891a3c-b17e-410d-d0fd-08dcf76e3062
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SFFEY3RPRHM1TjFJbGFKNzA0SGpTbHRybGJYZ0MvOGtabHRTQXErd3VlWUNv?=
 =?utf-8?B?aG1lcUZ6U2ZIQWsyUnBDaHpxNldla2xHMHI2RTlwRk5oT0FESmh1STdiUFVK?=
 =?utf-8?B?TEZybFgwM2ZxQVJLM29JZTRyeW1aVUdqWTZUNUZXUHFxMlZpdVh3L0RBVmFZ?=
 =?utf-8?B?cUw3SHZKcjJ1MDNXaWhkV2s0ZVhuUWZZN2t0ZWFvYXZXUmE4NXQ5WXBWVTNm?=
 =?utf-8?B?ZzlHRVk2V0N3RVV0cUk5dTZCWDVkclkrbUIxZXlwditmUmNCUllibHk1UWI2?=
 =?utf-8?B?RFpkUzdUaUNLMzJqSzRSbFdLOXlBWWlSZGE3MHZCeUs5WEpXdnhoQ0NJTHpI?=
 =?utf-8?B?R2N6VHpSOFlIc2RnYUJjL3FqNHZsdE9GKy9QcUFWQVp1T0xJcXpDcitrSWVZ?=
 =?utf-8?B?YWlIaC8ycEFFcW1SSnZnRk5aOUliK1Zabkg1aTV6MXpjRGdRa3o0WFJrcnVs?=
 =?utf-8?B?OXU1aXg4M2ZCTlU0dDJtY3RKK1dyOXJwRzZtdTZjbWlzMlJBeWpBSUpvdE9i?=
 =?utf-8?B?aEZpckphMG8vVE1HNTVjd0hpZk1zcllvcW8zdXlqbWY5eUpOSEgzd2YycGVs?=
 =?utf-8?B?TmR4RjRERGFvZ1ZkTDhLc0MramFRQStMTURvL0VYY1ViU0tsYnkxWFlJb3RG?=
 =?utf-8?B?R2dHZ1VER1lSMHh4ZWtvZW5WSzhMaGUzTHlTYk5GQ2RseWVsU0hrM25pdXJY?=
 =?utf-8?B?bW4xbTBRRm9RditiZm00aVg5OS9EU2xyaGJtM01ZTDV0YVVsOHo0V0t6Q0tq?=
 =?utf-8?B?dFdHcDVUamlzN0tQNWFjc0twM0kyTzJsK0NyRFdmblBDd3JYSEJjTlZMcUF0?=
 =?utf-8?B?STk1WHkzT0NpMEFlNE9QRFZ6alpmRzBiTmxoYmJ0eVRJQmlGc0w5TWV2ZW1B?=
 =?utf-8?B?N1dQNnJyZEhQRGRQYW9KWDJrSHFPS05HZlhDZnhRZWoxWTlvR0N4QnQ5Q1hv?=
 =?utf-8?B?bWJuSitsaWp3Z1hVdHF0OXRtZnRaanFRRjVuV3JqQnNvMUd0N1hIS3ByQ3Q2?=
 =?utf-8?B?V1VtbzEwSk8rZG90WmRpeEFGUjE3RTRzYk1RRVJFUE1TeHpobWk1ajdsWnkv?=
 =?utf-8?B?bld5WXlhbkZsTzRkS0R5d3V6TjYyb3o2OW5qUG81TVBkNkNjVEY4Yms4MkdS?=
 =?utf-8?B?dHVxbndKbjc3R0l3aTBETFVvMTBZZjA3b1lSZDVDa1FMVjVtSDA2REVJUkFa?=
 =?utf-8?B?aUVzVG85d3ZOR1gzSnd1cFhxMU8wRHRweEp1V1RBRU9ydlFyaGhsaEoyVjcv?=
 =?utf-8?B?RGQ2U0lGSUY4c1o3amc4eVE1b2RlRlJaYkdkZDhJL1dZN3N2WUkvVmlPOUI0?=
 =?utf-8?B?clRoYjA4QWRwYVY1dWV4c0VMRDEvYjZWNURBSDJKdWhrUEt0SHNZa2pjaUtX?=
 =?utf-8?B?SEtjTnVnaEdSS3R6dmlCbW5QWFdDdTEzVTgyZTdXeXBXOXFDNjRkR2hPL2Uz?=
 =?utf-8?B?QmFINEhiam1xbVo5SC9qSmV3T3JNM3AraVBWU3ZSQ21sdmp5TU1oUFdsREU1?=
 =?utf-8?B?VDU3SmdFcjJhWG5wM0RQWEtsempPbG8raCt6SjZvOEYxakNPUG1Qblh5bHo3?=
 =?utf-8?B?a0VpOWJaSHpqWFNycEMyN2lhUVRYTGd3em41alY0TmZvMkR4Wll6V0lZQXVK?=
 =?utf-8?B?RnZ1VU9sQisyY0lDVDIzMktoWDBwbExZSU1JSysrck1EdDUxZllaV0hLUGdk?=
 =?utf-8?B?dStaOHJzaXhsY09ueEJkdzRjblhFZ3orcnVzWHNuaVZxanVFdFFlLzRlMGhm?=
 =?utf-8?Q?CP6Jtpj54MPsSdHzoR/XVr5xCLffBAZsia6Jn8S?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VWdtdVlXclNNTXJpVUlHcW1xWDNBUEVGMVBSd0Y5d2tQRjZ5dWdzaklLS1RR?=
 =?utf-8?B?Umw2TFpWbGFmY2VKUERtb0Z4NHN5a0pmMU9PUlozeXZyemkxNXhoVUUwSlo4?=
 =?utf-8?B?NnJ4VVZpbDVsVjIyVUdVRWs1anZQckR0YzFjTkhDMkgwNmR4LzJzWWpla0du?=
 =?utf-8?B?RXVScVk0VTErT2FUb21wVUNWUnE0dkwreFEwMTI4SS9laUo3em5ycjZQaFlS?=
 =?utf-8?B?NHFwK2MyZHNhWk1BaVNIVnFSRnBQMVd4YWprTjFQamNZMTk3NmNHSjJzd2lR?=
 =?utf-8?B?aUs2ZlpLc1AzdGJFQllOYjRTbTU1d2VyNGJWVDl1QlFLa0JCUFd1d3o0VWpC?=
 =?utf-8?B?UFlpL0xpM2RyNk91TkV5dVlXbzZ2MkszZGRMMEtIVVRjUUt0VVBWU1FOY09P?=
 =?utf-8?B?S0ROdDR2RXMyKzRBZDFxczlQZEtjUEQ3MHVKUzhoTW56RGdpdXhXUnlucUFv?=
 =?utf-8?B?Yzk4ZU5kQzBlM2ZUNmQvdnBOajZ3RTF1bXZVaThPMldXUFZOeGJRS1R3d3dE?=
 =?utf-8?B?NkY1U0tPaXE4ajUwcWh0aW9Od1VWaE9rZzNYd3VKSStvQXczVnlaSXgrZG9y?=
 =?utf-8?B?cEZ2bXBEUlpFT05DaGp4YjIwSDJJeE1mV0JzeENTR0JJSml4emFsL00rMEgr?=
 =?utf-8?B?cDVrcm5LNy9ISkM5azRJdkdBRDdacUovVDBWQWQ5Y1YyZ0ZsVWFJTmFtVENR?=
 =?utf-8?B?cVd1UkN6RFdlS2NUd2J0NmpZbzBZTWZPallONlgySkczSk95VWEwOUordDhP?=
 =?utf-8?B?VytDcmhrb0tXc2VST3p2U3VQWE9RQmQ3dmxkOUlqN2tyNTBRR1ZZcFBWc1Bs?=
 =?utf-8?B?Q1pVRUFXR1pkdXBTMURtbmRjQ0JnVXpvOWw4WHc0NWdCT0FBVnVyMWN6YXJt?=
 =?utf-8?B?VXNHTElYczE4TWp0Y2d1ZXVzQ1d1cEI3dnhtTWZ6RFdhLzNyVnVmK0dtZ2pG?=
 =?utf-8?B?eTNDZWRhQ0FsWnREV1pmci83enRJdXQxSVIxUCs1VndyTElBbHZBN0NrT0RK?=
 =?utf-8?B?N1k1cnNCQ3djVHgzR1pCSkNaSitMM1JXYVhMNE4rVlM4WFpsMFEwcGhFV0Np?=
 =?utf-8?B?b0Q2MGlaZ0dCRlFLQ1dxdGlDMEFEZmZnd1NkZWFqU1h1Zmd3WlBuWUQ5MURE?=
 =?utf-8?B?Qlg0dzdSRWlMcDJsOW82SEthTVBFak1WRmZGbDEza1ZoUkp3eUp3WFltUlN1?=
 =?utf-8?B?OGlGb0NLWEJkdWUySGpXZ01ia0luanEvbnVzenA0T0FmakFMV3lLaDA0RzFs?=
 =?utf-8?B?c1JJZjVpNjRxb2JNVjNqY3IyY2F6UlZ5TnpkLzZoUzdWMFhqS3hWWS9vWDAw?=
 =?utf-8?B?b0FoY1U0ejExcnJnUVd0TnpYV0VtR1Ezd0NPUU1BVGFLRWVXNlRDQzVsWUsr?=
 =?utf-8?B?ckZhblB6T3JMNWlIZVlhbjZrVUpnTmtQSCswbFZ3L3R2VS95eWtrenF0SjZr?=
 =?utf-8?B?SmF3WkJRRFlyOVJVeUdsNkVVekVheEwrMnZFVHdmQm1SSXEweTdrMUZoZHZB?=
 =?utf-8?B?VWF3VW1LN2JtaEt5N2pjRW1HczI4V3JmVkxjUmJ6Q2dqN0dkK3NXNGk3VUgr?=
 =?utf-8?B?cFY5aGtwOEdZc2dVd3JOaUladWo4endxYW9KbE0xRW5aYlFoVzhYYUpxWVVE?=
 =?utf-8?B?K3hyTTF0aWF2OTJ2VWJOdHNBZVFSRWxyMzhHaE5ybzY3NlZSaWNPME9BaGdX?=
 =?utf-8?B?U1kzTjN5WU5Xc1Q2bVdnZG4vNVJJVis4N0hHT010ejNkalhWekpiV2JZQW1N?=
 =?utf-8?B?V1FZcHBpRlJwNGtkOGU1YTJKaURLa0Y5U2prWmVhU1V0MjhiUTVyWXRoRG42?=
 =?utf-8?B?Ykhjall3SU4rZDNEN0FZU2ViRXNVT1JSY1BUTm5CWi8vbE9aMUErNGdHVGRi?=
 =?utf-8?B?dS9Mc1REUVVVR1NSaVpnVkZ1Q2UxdHFwWm52T1JsTGU1TjZ3UmlzakVjL0Q4?=
 =?utf-8?B?ZFhRM1VaYkYyOG5xdERlbytBMCs3WEZGdkQrajAyWEc2UlEwcjMvckR1TElS?=
 =?utf-8?B?K1I3emlUb2ZyZGVGMTBzOU81eHlFZ0FjV1dScjJPOTdMbWd6ZkF1emxCU0Ra?=
 =?utf-8?B?T0xMdGM3aFlMU1RzakpUWWJGbE40Z2xHL0NLbDZXcTkrejZYZjJNbjVGRFFQ?=
 =?utf-8?B?RFEza2RGV0w1aVRhQTFpYzF6NWUxMGU3Y09PWmJIZERhaUZZa2ZCcEsveVdp?=
 =?utf-8?B?dHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6+EpZTx7J5HC4fuMO41Xn0iWosy8J6F7oG62F1XfFsyQtfkQiU45kCr5oIU6bY14/7t+rhKuyKHIqEsdDgXGsMLl7DnJRggrK8ey0OP1VoE4uUBQsyzgVmDRkB4et/FNCR/O26dM7X9yMPgbFqeZeiknjaWaXG1KsLRkBOW/qe/jGEndsLyt48AT9e8pSKiEM5rfvKFz2RGWhQt4yz5HNdQPk8WOXcPDMsiQm1Z14A3gkXGyVytoxkdzMp1SGaYjDejquaqWIWHg/NlbjVO1511KpcpFdpYW9dS+66WQbShLpSv+bnZePNnULKJK2lifExpb0ay37uSNbNaILLww+wJGe42WLlJ6aEwPQBB1r13XZ9GfoEu4s1Mq2c6P1XzmBeSJlfy7xg2AdJUEXArQccY0QoQy+kjoLs8wCuUSZaC4406Lf0uaxTmSbdql2B0asVXKLhRcUH7mz7W8qO30dTBrr0AnC4dC4eP7+TFiUPaF9YvNm4YZhJxqC6PQrKnVB9gz1QCEIvF3SZmDFasovuLXB9hbPs4Bab6/MC8Kg1xb6ZIvB7JSKs39/whG0IaIyrRE550FQnnTiCCOVXKjbKdRVi9yqv7ooK/iTsI4/OM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71891a3c-b17e-410d-d0fd-08dcf76e3062
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2024 16:33:01.2425
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q8fXxBmflmJD8+EC1nX/wZSi4Au3dFJtZKRkallDUBuE8mVYEPxdHnIVre7NbUYOdjbQECJjBMggwGz8M6ls+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4942
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-28_06,2024-10-28_02,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410280131
X-Proofpoint-ORIG-GUID: Phz3c7GUTjVW2kpQzmLC2_u6hbhv2Hhc
X-Proofpoint-GUID: Phz3c7GUTjVW2kpQzmLC2_u6hbhv2Hhc

On 28/10/2024 16:11, Christoph Hellwig wrote:
> On Mon, Oct 28, 2024 at 03:27:24PM +0000, John Garry wrote:
>> Use the proper blk_status_t value to init the bi_status.
> I think 0 as ok is a very wide spread assumption and intentional.

Sure

> Personally I think 0 is fine, as it also is special case by
> __bitwise types, but if Jens prefers it this way I'm fine with that
> too.

I just found it easier to grep BLK_STS_OK (rather than 0). And also 
proper to init to the declared macro, but I don't feel strongly about this.

Cheers

