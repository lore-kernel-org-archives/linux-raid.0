Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E3331AA780;
	Wed, 23 Oct 2024 11:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729682518; cv=fail; b=MD3tNlOgFt0YM6689b2DYUoRPyobNd+2YAJvcqkicRt4xklZFb/MgGtXacaiyApMRdSXz25Ld8Lf00WDzUKMuKU8bahIu/hoMxarnZrGZCFZEdziiOhMS+/N2etJk3AauJxvEdsLZxRI346VmBrYNrZRXdjhnJifie15bbVsbCE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729682518; c=relaxed/simple;
	bh=sq+9IJiAn4boHk+sSOOf4BLEgjwo2Ep88TMBSEDyPKk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=A9EEU2DpannFwa1dmNyxWxEsfdDNzs9hZsbKVNcfPdDQqwUxoN4f8dH58SNTxsn9G1pMU2MwVTowv1PTQA7sISKXrkH1Ik4m8EfQ+bTKQAmAMo0WK2kA47nn45RUKcNziZioBL9Nohq0SNc5pl8r+hrnnUL62Fd24W4OIdYoP3w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UPWMCSKw; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=l6M2DeK/; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UPWMCSKw";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="l6M2DeK/"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49N7u6DS002245;
	Wed, 23 Oct 2024 11:16:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=73hpBuGVdM3+0CM9pv0KCTO7LJBtoFgADBk4pgXcRAg=; b=
	UPWMCSKw5Jv+v+RXj6OLqQrCc/Se+uuuP2MwoO1q+++72F+EUUscIrjPodD8LCy2
	EitutjM+8fd4QWqXJ7MWtE8CSLh6jS0hB4yyzRKc9WanFGmFVoOyM5/k6+uQZnw9
	oAvJW0rZrIEBds8pmfhOKSZw8UjS37MWd6cLy/7/UIk04hhYLuCo1x9qIeCWihjp
	87WXLckFnL8FuYXHBPVRQeD7E0dABMeOkK6WRFMtgutDewH8A9gxM368+X4pkZwK
	bCeuEDw750eyYODaTXjIkSgi1N4j+wdySBROLEEe5BnpuV+f7c2lTlTU7XQNOTAd
	RJ8DoCwz1BLWonY3rcTQ3A==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42ckkqy686-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Oct 2024 11:16:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49NAtWPu039532;
	Wed, 23 Oct 2024 11:16:27 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42emhaw8mk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Oct 2024 11:16:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IRv5DVFIy91nrY+gWqdbgCSr/F6SBUzY9TdyzWFj89KgTfwEwmF+YlKGX9oO0SFYLmQkVGDqfdveeZ+VYwoZ4Wu6nJQkjdWSqPZMLcAWrEoAhoYUhxjrv0Mvo04i/dlWrn6oTUBVpNAc3Ug3vSznt7DhDSYtpO7FerPMONzZuXa3agVr8viS2rD3hAvOJNZyDcALTsvq1CCHLL9JO4zBiXSyrgjCH9NklcAKENxA89iBfZf6p/mDuFgFwBJJ71wUsXO3IGBH00OF98PFUPfVp0uV60lQ3RoSKh0m4iekQ46tfNKaOfi+hzMVKYL1YXNqoMpQ/El0lFwaYK+sRlcKtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=73hpBuGVdM3+0CM9pv0KCTO7LJBtoFgADBk4pgXcRAg=;
 b=jW4BuVZcul5qpOgdCVmqgR876JRoFprWnE0FsHyR8AFb7L2r3kyxKr+h/Mdr3Jq6Xw8phLnPxtoe9UazByWi/ETu9pXsQdCZimTFZ8Ibxr3Sw5y3g1JUIvUM0/tNlr0cII7qX4bsX1rr/c/83NAEjYJvV0yaqMn64q94epk9gzD/CQI/FPupJY6BqLthbst0m0fEzJWcHZfUIWj63tUYboZOVBEdzVOA1Xy4friJcC8Dq4NKr7FOPFxHuxlTvmtkyoN+PxHfWVdX9QL+NzjRpg6jkeFhNH6tzTkMGjg/KZj3PtYbd4l5H8nCL0vFgOvxRe1EYPjQ5EPAXq2VHLrPYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=73hpBuGVdM3+0CM9pv0KCTO7LJBtoFgADBk4pgXcRAg=;
 b=l6M2DeK/loCscVsmM8n1Jl4Q+WQwI09mzDH7KIx7HfrFOobao5Z5JxZSHB+ywpz/U1d4Ie6wx3mpcPX1amrBI3sBJJUEC7HZB0V7QCeF7L2ecdpnhGTxjB7elzWyz1anz5Ehnrha/BAkLqPRCzggGn+p3wLdbKAR/IgfslLXeuE=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS7PR10MB7132.namprd10.prod.outlook.com (2603:10b6:8:ef::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28; Wed, 23 Oct
 2024 11:16:25 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8069.027; Wed, 23 Oct 2024
 11:16:25 +0000
Message-ID: <0cf7985e-e7ac-4503-827b-eb2a0fd6ef67@oracle.com>
Date: Wed, 23 Oct 2024 12:16:19 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 5/6] md/raid1: Handle bio_split() errors
To: Yu Kuai <yukuai1@huaweicloud.com>, axboe@kernel.dk, hch@lst.de
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, martin.petersen@oracle.com,
        "yangerkun@huawei.com" <yangerkun@huawei.com>,
        "yukuai (C)" <yukuai3@huawei.com>
References: <20240919092302.3094725-1-john.g.garry@oracle.com>
 <20240919092302.3094725-6-john.g.garry@oracle.com>
 <bc4c414c-a7aa-358b-71c1-598af05f005f@huaweicloud.com>
 <0161641d-daef-4804-b4d2-4a83f625bc77@oracle.com>
 <c03de5c7-20b8-3973-a843-fc010f121631@huaweicloud.com>
 <44806c6f-d96a-498c-83e1-e3853ee79d5a@oracle.com>
 <59a46919-6c6d-46cb-1fe4-5ded849617e1@huaweicloud.com>
 <6148a744-e62c-45f6-b273-772aaf51a2df@oracle.com>
 <be465913-80c7-762a-51f1-56021aa323dd@huaweicloud.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <be465913-80c7-762a-51f1-56021aa323dd@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM9P193CA0014.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:20b:21e::19) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS7PR10MB7132:EE_
X-MS-Office365-Filtering-Correlation-Id: bcae71c7-cf40-4c83-d4c7-08dcf35420be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TDFtM3RaelBleEs1cjMwMDl1UmpzbmppYTlkQTZoWDFpZnB4aXJFUkNjUFBm?=
 =?utf-8?B?TnZ5SXBvS2c1ZHBPenRyRGhCZTFrRUpMd09LMUhiK3RMS1JkK1pJKzg0RitR?=
 =?utf-8?B?cVNhNUl1eVhqdjhBUElQeFJIOWxlRUMrUE9MN2Q5V2dhNUJNR1dBYmprRnZB?=
 =?utf-8?B?N3ZqUkVGdnpLbnMyVVNkVDJkMjljRFFuSUNFeHlEdnM3KzB5Qk9sRC9pdnZR?=
 =?utf-8?B?c00vN3hidkV0dG94dFQ1aThEWmNZWXNlT3RTd2M3MzByN0RPSTJ1SVBKa0lo?=
 =?utf-8?B?VllPa20zZy85SHRIU1M4bW80cXN6OUpBWkR1TERuenIxM21rRll6RUVyRStw?=
 =?utf-8?B?c3lqUlRsTGZqaDlWdmF1UC9EUHdWdysvWFhqQ05zSi9JZ2JvdzhwQmRPYXB1?=
 =?utf-8?B?ZzJxTHFkL0JzODdoSXo1NEpxMEJJejNRMzVVVEg5WldCeTdyZ1JGNi8vSGZE?=
 =?utf-8?B?MjJKR09HOFR5WXBDTDFhQTY1dFZScytFc2xhSThjNzljNnJGd0ppeUx5MURE?=
 =?utf-8?B?NEVoblhVWVI5c0JVV1FOUnlxMjdSZ3VZMTZHWDdMT3ZyYlpzY0lmVXNwclVZ?=
 =?utf-8?B?Um9UY2dyM25jV24wNVZxTzFHMWppaUxNZFBmcUZCd3BGRDM4MEF6dGVkdDc2?=
 =?utf-8?B?blExeVY2eGhsZDFpbTczOWlZL0sxS2lUaFdTV2pKa25Vb1BWbEd0SWROYm5V?=
 =?utf-8?B?ZWhyN20xRGxoaFpaeXBHd25LV2p5MmVmbng4QnJmUXYvL2FVWWlBRFVmcXZQ?=
 =?utf-8?B?Q2JYRVlzN3ZBeWJEajhIVDZDcEpHMmY2RXBkQXVxYXRRSXF4L1UvWC96dmhW?=
 =?utf-8?B?Rkg4UC9YdVhKaHJWUGt3aHJyN0Vxb2Eva0FxSFIwNWI2WitBU2EvczZBK1Nw?=
 =?utf-8?B?QWRWSmpURTErUkQ4WE03YmVwd3VnMWpyVVk5OXh4REdTV1F0TFZha3FUK2hv?=
 =?utf-8?B?YzV5MktGanU5KzlDbDZ0ckNrRDFyZk5DR1dpNmVGYXlTQW94czg4OEhXVC9H?=
 =?utf-8?B?bFcwS3RKWklJTXVMWVNoNWgvTWpsbEdnMkZRY3kvcHdEaTUyUnlma0hiSUNH?=
 =?utf-8?B?SW5RVm84MktNL2pjak5DdldkME9kMnlYOGVpeUlab2NjZ1hOQ3Q3YTlaV0Iv?=
 =?utf-8?B?b0c3SzltT1VNcDBDVGhKazI5bHBUTjk1TytFU1dvdCs1emtJTEhoeXFqZjBI?=
 =?utf-8?B?bGRPYk8xaVlrTng3cGNTZFo5bEVsSlNMbU44Ri82Q0RXY0FzYTIwMmdBZlBO?=
 =?utf-8?B?VUE2TXVoM0ZoQ3R2MTFaMWoySlNobGdZcURnOGNKVUdwaUNwbHpOYmJvY1dC?=
 =?utf-8?B?S1FlWm5oelJ5cTV3a2orU1ZUQ20yRmZDUlhJb2RST0lIV0d0eURaVk8wOFV1?=
 =?utf-8?B?NTlsaHpqTXJKMXEyR0tjSlAvUnJpcVpXQUgyMERQODVZV3hWYWhyUmpQT3JL?=
 =?utf-8?B?ZHhVUGlpek9scWdXSWRUK1AycFROMlVRU0c2K3NCUnVwM0tZMmpDb1hVRlZV?=
 =?utf-8?B?dk50azIzcTQ4VFBGT2pBZDJGcDFNQmFrZ1ltaHpDZ2ZDVFhueDN1Y1ZmbEZl?=
 =?utf-8?B?eEIrSTlJSk53ZnZyenExWWN5R1dLeWJ0L1RZdytpbHhYWk40Rnl0aWlPU2Fv?=
 =?utf-8?B?djBtaGQ1R3NKUzk3UHpUL0tmU2ZpaEw3OGNtZlE0dlZvdmxya3hzTmJ1dkZB?=
 =?utf-8?B?M0RoQ0pTSGdIQzNaK0tUcTRCUnNDcHVuR09jWHd6b3RlZUJrOUgzQ0x1U0pz?=
 =?utf-8?Q?3aO/CdcuKjw7sfTiefoBSp+Yb2lT1CvC2V7dUFG?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eXRZYzg0L2k4Nk1wYVlxSTY1WmFsN1ZrVWZYek9mcFNLQ3JQaTZPZk5mQkVt?=
 =?utf-8?B?aFJZNXJPTHdFZlR2YjFsTUJtRVIxZmt1NTJnTEFFNVN3WVh5a3JBT0h4Nk5U?=
 =?utf-8?B?SnhQa0k3UktIZkxvZ3QrU2syTWZQSERja3R5SCt2bHc2Q09SRHBBcWZhUngy?=
 =?utf-8?B?Zk80UkRWUXNzUnVRdkRBQmtKT2xaZmtNQ0xjZW9pSmZUUURMNnIvOE12S3pW?=
 =?utf-8?B?Y3A4OEd3S2V1K2s5eldLbE9SdkZnOUZ6Vkc3UFpUMmZUaUdWZnFVdGFLK1kv?=
 =?utf-8?B?RXhhc0xwY21VanExVjIrbjRmV0NGMkFoWldqcGl6VzVIcU9INlVTUlVsS1h5?=
 =?utf-8?B?ejlqSTM4OGovVjNKemlHRkVOVVZ5V2dQSFZaRWRhb1NHQTVkYWZLREtaK1F2?=
 =?utf-8?B?a2phcUc5bTJCMUdOUHl4RE9UL0lWVUNzSEFnZU44d2VFQjlRZFBrMlVGcW9u?=
 =?utf-8?B?c0czUzN1aytHMXd4MjhHUGZ1QzBZbWpHRHp4Tmk0T1d1cTI0TXpYOVlFdTZB?=
 =?utf-8?B?ZUp0UnZYK3Y0R2ZxRmlVcmx6V0Z2dTNwWFlBcWEvOXZ2WTJkVHRQTkdXajFy?=
 =?utf-8?B?SkVpbW1EcUJpLzFZb2hXMk40Y1ZSeUg0bDZwMUhlaDBqZCthYUk2YWtoRnFW?=
 =?utf-8?B?RnRWb2pJdElpQ3JTeC9hZWlhbXl3clBHSzR1SVcrYng0RGlYWjdSUnpQQ0tB?=
 =?utf-8?B?L0tWa3JVd09BK2hDZWVFUUZFVlFpTVdPdi90N0dGSVFhRHdSSUQvQjUzQmp0?=
 =?utf-8?B?SWw2amFDQm1CQThmb0toYlBmUTREZXlLUVA1WVptVVhlZ1pieTl1OFAyWjRZ?=
 =?utf-8?B?NCs2TUJQTnl5ZzV4a2RpY1V5VmRiSXlGQlhkakt3WTRUMkg3UGk5MDlsTHAx?=
 =?utf-8?B?QXBEWjhxVGczL0k5WG1IMUl6YTlnTUNRbG1hQ20xQ1oxUUR6bUYxd0ErVFcz?=
 =?utf-8?B?a3BDVWxPMVpwSTZ5cFZheElpZ0xaNFZETjVwdE5XcU05RjBNZUpMTXdvNEhR?=
 =?utf-8?B?cnJLL3ptNUFhSmFOMVdmU1dTczBNdFdoWkFGUUo1WHp2M2FVYnJQYkhpUEw0?=
 =?utf-8?B?SXBjN2hTU285ZUZqMWM4NGVBWDRYaXFzeXhaVUhVRXNPZ0ZCTWFGRDdTRHpU?=
 =?utf-8?B?VmlqR1NpQlNwcVB5WjdZRUtLQVM5KzFLcUpLN1F3dUdPYVFLeGI3R21sVXhP?=
 =?utf-8?B?azdLZG1qeTVJMEFSdkhXRjVCdElSNFNZUXMvb292dzlJRFJvRFRaUHNqcmlV?=
 =?utf-8?B?MXVnR2NaM3BsT1p4dkRLaDFhTHdOK3hQVGdnMnlVQ3pxRjR4K0gxazl6Qm9G?=
 =?utf-8?B?VXVBNTJaSGVsUDh1NjArR0xDWUZ6TXhuWEl0ZlFqajNNWEdLNkpSdXo5aGxF?=
 =?utf-8?B?anFxUk5uYWt2Y2twTXIyTnlmVERla2tOSlFTcWs0M0J2SVUrb09hSXAxY25j?=
 =?utf-8?B?RFQxcUE3R0Q3WExzUGtCbVpjdTlCNVA0Qng3T3ZUVjg4NGtVcWZmakwrcnlq?=
 =?utf-8?B?VVJVZW5qSldsRlNtWTNVN2xzdkNscnRlWSs2bFljQUVmQUM5QnJiU1UxMUVo?=
 =?utf-8?B?K1Y3ZVN6RVAxNXVkL3NBVGNkcVhFek4walpacURIcmpjQy9ZTDZjeDB1dXU4?=
 =?utf-8?B?c25sUlNqdTR2T1lBUjZoQTZhTzB5NjF1RzZGOTBvamUyQlNXOTlrZUdrSnJG?=
 =?utf-8?B?UzZ6MHdQMWNJemIyQzIwSW9ZWkRLVFBxSzAwWDEvazB0bXoxL3BOYm95M0Ix?=
 =?utf-8?B?aHdnYUEza0NEaUl1WnA4NjMzWjM4Y296cm9CNHBvV29IQUlNS2VBQUZPOWVa?=
 =?utf-8?B?Z3ZkZEhLSVN3SGxxRXE0QmZuQWZVT0FOQkRka2pScStUdHdDbG5DYjFFYTFw?=
 =?utf-8?B?cWdwQ2Y3U2wzem1TRlluZndyTnJ0OUJ2aG1tNnh4QnUwdGpDNDZFRmk3aFBs?=
 =?utf-8?B?clZJeG04QmpkelRpWlZiK0lJaVlhZHdmajZxWWM3MERJSlI1VU5rVE1BanlD?=
 =?utf-8?B?b0x5NktPaHYwMm15dEREaDJJMnRhZTNYRFdubWlHdjJKVEVBeWtEQXZDbUVv?=
 =?utf-8?B?T2RMWkdSRlQ0UnFtMG9rOHRPbHpOUnFhNzZmQWdtNDQwUDZwdWtVOUlEK2ZZ?=
 =?utf-8?Q?yKQB6ZGu62JrkS3ZNGj9iSSuq?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RjvvA6XDSu0ujqKQVnpz+HjLHBm5zY1C1x+s51OJ/po8hqv1ly2TxpNaNsXrj2kKl4utUgGLuA21EDLZYIF4ixOMtxytxcGjmD5f1HBgYsfDpQn2dCvSU+huIlUj/FnK/oUJUvsmMLakAHsHdm1sWIupfuDKq8BhRnUXudqI6szEofYrldZZilF5oOmJIl59QbaNIATXfjZ3qVLrbh9XBrfYW6h/lkPhPxyX7vr3+SHq/zAN379g7xJoyErt37cd1qSXakbgfjFd0eikQxP15C/llqwVpXTwfP1YxBYSOqqCPV1lhXVvKYoOlJefUryJyz4dpySDlsB4Kq2Hjn418IiELz8+qTM5vtEzgYsdmODBy0aLDP2FQWtzPiWpVaylWTeu1TsQwlTf41UsNfgKdxPyUf7KGcYK67YpAvzUzvOSRL8uSVBV8wlTuM5E2/7tE09njHmxuPC6luM06DUwLL9QfdUWq3zSVEZL/7M4dA4eM9pjvJg2PnyNS8L+TfGhy4w+QDVkokKzZnGgPQNP+E5M5EREZsP0dzvZ7z2DLVss6VcTRH7JT9GEBR6xxDX7BzxkH6BmFz5Tklwa3WsMKFr+PEHUuVpdholzjqmovYE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcae71c7-cf40-4c83-d4c7-08dcf35420be
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2024 11:16:25.2521
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /LwrFUVJ8rNiJQ0KkxlfC87DBRq0h4B4Npanx/D0Oz82aW9bbuUr3WY3nYF4nUCabhJZHvfA5NB+S1qFSt7gdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7132
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-23_09,2024-10-23_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 suspectscore=0 bulkscore=0 adultscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410230066
X-Proofpoint-GUID: D1QmlXKEawTC4K-XDVy5GWzv5UuSjMmm
X-Proofpoint-ORIG-GUID: D1QmlXKEawTC4K-XDVy5GWzv5UuSjMmm

On 23/09/2024 10:38, Yu Kuai wrote:
>>>>>
>>>>> We need a new branch in read_balance() to choose a rdev with full 
>>>>> copy.
>>>>
>>>> Sure, I do realize that the mirror'ing personalities need more 
>>>> sophisticated error handling changes (than what I presented).
>>>>
>>>> However, in raid1_read_request() we do the read_balance() and then 
>>>> the bio_split() attempt. So what are you suggesting we do for the 
>>>> bio_split() error? Is it to retry without the bio_split()?
>>>>
>>>> To me bio_split() should not fail. If it does, it is likely ENOMEM 
>>>> or some other bug being exposed, so I am not sure that retrying with 
>>>> skipping bio_split() is the right approach (if that is what you are 
>>>> suggesting).
>>>
>>> bio_split_to_limits() is already called from md_submit_bio(), so here
>>> bio should only be splitted because of badblocks or resync. We have to
>>> return error for resync, however, for badblocks, we can still try to
>>> find a rdev without badblocks so bio_split() is not needed. And we need
>>> to retry and inform read_balance() to skip rdev with badblocks in this
>>> case.
>>>
>>> This can only happen if the full copy only exist in slow disks. This
>>> really is corner case, and this is not related to your new error path by
>>> atomic write. I don't mind this version for now, just something
>>> I noticed if bio_spilit() can fail.
>>

Hi Kuai,

I am just coming back to this topic now.

Previously I was saying that we should error and end the bio if we need 
to split for an atomic write due to BB. Continued below..

>> Are you saying that some improvement needs to be made to the current 
>> code for badblocks handling, like initially try to skip bio_split()?
>>
>> Apart from that, what about the change in raid10_write_request(), 
>> w.r.t error handling?
>>
>> There, for an error in bio_split(), I think that we need to do some 
>> tidy-up if bio_split() fails, i.e. undo increase in rdev->nr_pending 
>> when looping conf->copies
>>
>> BTW, feel free to comment in patch 6/6 for that.
> 
> Yes, raid1/raid10 write are the same. If you want to enable atomic write
> for raid1/raid10, you must add a new branch to handle badblocks now,
> otherwise, as long as one copy contain any badblocks, atomic write will
> fail while theoretically I think it can work.

Can you please expand on what you mean by this last sentence, "I think 
it can work".

Indeed, IMO, chance of encountering a device with BBs and supporting 
atomic writes is low, so no need to try to make it work (if it were 
possible) - I think that we just report EIO.

Thanks,
John

