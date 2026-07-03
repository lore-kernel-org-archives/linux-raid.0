Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 452F133E344;
	Fri,  3 Jul 2026 08:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783067359; cv=fail; b=BpTnf9zhRzRQEDc0C+DZYvGorOs8sxksexG67Ug2dPNnwEXWDPuDtW6XEA3sSJkWmE7J8o2OZpg2J/ok39mxyEenLGZCiiWqLNhacAfmhSYefFeAOvaN1qgrZIciBaiuEVvTErXxF9QGpgLFyjEY6MtE6sNhr7OJcTXEiNAdrwM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783067359; c=relaxed/simple;
	bh=bzZu4Z5TyMFJ58SoO8JMkDY9EI0IIp7C8gdmele9HZc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CkxrzF97R7ZQY0oG9q9pQr6gtxPznsL1conQ97NL473ntnKwp8jBPGAKtARRYAF+eiGb2hH8jm/114gm0tyClDOL986w4Hu+Zznfe7gsIBjtRpJJjaSzpsrmcl/qIrPkn/qCAAJccONpTUSCWgyGRPH8yPut20zw4GvioXyLF1A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RUKDdVC/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=OdUSNgoq; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RUKDdVC/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="OdUSNgoq"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 662LUV6g1000053;
	Fri, 3 Jul 2026 08:29:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=2C4Hp1B8NqyBfX/AeVYdFgVOpHSB9x1vAJLk0xkWRBU=; b=
	RUKDdVC/oiAkHUx6IfifJTai2gZIG8rEJfAmROceo2gUgDl/V8+qCpKglk6eXkfO
	XZQpR3/E2itFWW1N+3M1RRxZosgXvAbN+0PFwYHHHScQE9oHhI6DmV7otWip3sjc
	+c9dTSb8WwVFT+l+9sQjAmLMRNS89HcWyDzkAS8cKLL0JTRUpQT1AfgJ4pAKUFvO
	jE4YX8HVFZ7/KN5sSlpW8jyPo8mPmZdit3To/N0SLdP/WGdCQUvvKigGipmGmqzS
	koRzQBgdV9dENDHR+Wxn+eNEOQrefK2dc04MUBmGSBs41iibD+xZvHNy9+8pPWCc
	agFzQwGze1842i6HQVNZMw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f26kfj6cp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 08:29:01 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 6638S8Ik022948;
	Fri, 3 Jul 2026 08:29:00 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012062.outbound.protection.outlook.com [52.101.43.62])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4f50yus8v8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 08:29:00 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S7xIyAyrmpFX/QTo5Bu/Sv3/x8HjtAcH6sC8YJMeJHkaOuFUNmXmFucJucQ5SWai47VXOQaMS8XTEqV2btsaLZzEu2UaUrkTaEGMEFao2Eq+8wTDPfaVc/VAW200i00rLrx9ex7jhvhhHvc2HsqL0O55QCXoG0GajFo7gv7Qsi0Jb2TGc+Oy+MIA1TRF4OywLbjfzBvLrI9czgXDwO3Vdp2T+Mb+aXaiEcDFqA0rSzguE1A5VHf9ieKDR3rnf78rhCR+gN7WS72JLBTM+oxpywwJTCEiE9iA4sxBPUCE0e2UI12qZL+tKf8rfgv/1321xQn8EhcV8mhNrhO2UtlFHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2C4Hp1B8NqyBfX/AeVYdFgVOpHSB9x1vAJLk0xkWRBU=;
 b=RChaFxcdZOJwjydizmLmLIu5b25+ASBos+aczYMRrO5ZJehdl6KSEPaSnm1RE9UqsmbbT0pAeXWeejCSjOJqbYCb6LmSte1kL1vohIi2clNBzzUcAolPR9VtImNgL+6dpkodxSNVgxEpgozAk7LZX27aV4j7ojFIQCkOT0JuYmZCG1yAOjwNWXLJNhofRBlVAT0EmUFP+KkOD72UgOs1iyVDmYL6rEcE3/aTiwKbn0BB0AbVihY2/2hAcNZWGCEk6WaPFy3wszBZySdI+0r/RBFDsINVjlhyQgZNSVHHC8OCQNrLkG4DaEGMvYSjLGdzTspl62Rvhpt7eWVradXkIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2C4Hp1B8NqyBfX/AeVYdFgVOpHSB9x1vAJLk0xkWRBU=;
 b=OdUSNgoqr0mh/0QvqUFUvSV5fI7mDC5nyevD3rVoTcva+Xn6hPexFZUj8T5veq3QKLWl9rKh2xvwEs3eh/Q5FPY1BO5gNER3PxvPya2+Q3FjpCvVxROhAFxJNlOXw0uGJ3kR/+DACq6XueLCsABgtyAb8fK9vHJMKPF/AASy628=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 MN6PR10MB7997.namprd10.prod.outlook.com (2603:10b6:208:500::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.10; Fri, 3 Jul 2026 08:28:56 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Fri, 3 Jul 2026
 08:28:55 +0000
Message-ID: <856abedc-d2f3-4248-9583-4d7e1a11abc1@oracle.com>
Date: Fri, 3 Jul 2026 09:28:50 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/7] md/raid1: advertise atomic write limits and handle
 runtime constraints
To: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>, song@kernel.org,
        yukuai@fygo.io, magiclinan@didiglobal.com, xiao@kernel.org,
        axboe@kernel.dk, vverma@digitalocean.com, martin.petersen@oracle.com,
        linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org
References: <20260628142420.1051027-1-abd.masalkhi@gmail.com>
 <20260628142420.1051027-3-abd.masalkhi@gmail.com>
 <7cbaaca3-4eb5-434d-a13f-f9574c9f977b@oracle.com> <m2se64zak9.fsf@gmail.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <m2se64zak9.fsf@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0048.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:48::10) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|MN6PR10MB7997:EE_
X-MS-Office365-Filtering-Correlation-Id: 23efce52-78ce-4901-364a-08ded8dd1f18
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|6133799003|56012099006|4143699003|18002099003|22082099003|4133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	ntlSyjob+gNQAuBCx4iOZMFDBfUMUL30Hl5boMti1TndpPpjZ0wNwuPqNaNN+zUMxHKnleZwyT9rgtj/l4sSFMNoMJPHFm7RzaC4df9CFvjsBAjYW4wF2mT1yJx3N4igNCLmMXywdT/rZ+nbe9V1pVWjL76oIcyQ8hApIYMZzZxr7WJGK6XcROGXMs2ngY3cNqHu1B7ep+n6FpdvUUe+aMakKY6e59Fxle4D0VJrn5oJrObEqmBkENEYch/hAzP5f7RifzBnd2wlW3KjPgoW8nVaypnl5lTZbfmjxxeDB2z9HomUXGv2i40xm7v6HUNNUL6qnee4TTkLHo/PSMRc0WJaDHM2UmuYo/5BlaLywg3aRqARwhKvl0CzSoeHzyA61bznzfy5YqG9sDj4ZyXQUKvKTuUB+39JMkPIwCE3kkIZ0RAtNT0A3zgfsfmyWT/xyUivn3GcguTvqRf7735iplk6twsqpXE2JzTBUPGZyCXlORQrVQfVbauJQMm9OGA6xvbx3DpTwgxUhzP3ehTXBWt5W9RlAKtZxZS4eLZXatkQ5kgJdp2aO1dBuwM+DmTlz16kcJu+INnYIhi9Gk2dKF89lGsH5nsSTpmyLR0Wb1ukj3rBbavLIb5d8jC/f02OK437XG2K1Jg2n/n0D0OWMRqtScBjMXuhC+CIt9IG8JQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(6133799003)(56012099006)(4143699003)(18002099003)(22082099003)(4133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aGRwcnE4MUFTWnN1eHdYaTBCUGxsU1QyMk5NNm1PbGxPRWxyUTVtOGlNa28v?=
 =?utf-8?B?am5YR3JLMjBnQ3N0c1NpMEc5VlI3QWlBbkJFYWQ0U3BaTXZoS1dNamNsZGhh?=
 =?utf-8?B?eHNpLzlYazBKWXpHZkdNMU45N281aXpWV3J4cW92TW9PM2pobkhzSnNsZys4?=
 =?utf-8?B?RFlnWWI5MmI1V09nWW1GOUMzOWFzNUFvenpPQVVnZFhCZTVxVWVxVm9KWm1u?=
 =?utf-8?B?VkxvTFIwdllzTVYwa0ZTQ2NwT000aHhmck9QTXp5UFFLc2VzZHJaZ25saEYv?=
 =?utf-8?B?NTFQdnFZU0p0a211RVFLZUVSR1N6QTE3cUNnS2d5NysrN3BGZExUTGc0cjhl?=
 =?utf-8?B?N2lUNzBOamNLdHFnazJvclRsNklrU3ZwdEVHYnFXYlBzUDV5UUduWGQvZElJ?=
 =?utf-8?B?d2h1VXlFbmFLRlMwQmVvajRqUjlsSTdIK3lQWXAwY2FQbFdWRzhXNjRSWEpa?=
 =?utf-8?B?Q3l4UkplRG14Y1lWdDdqTnpwdHRRQmtiMFAwcThFTjE4RmZ4VnIvR1RjUjk5?=
 =?utf-8?B?bk1pT3MvSy9UMTZoK2pUVkw2WDUwOW15b28reEVvUVorNzJIT2pGUFQ1aEto?=
 =?utf-8?B?RHI2Y29IUWpscVc3RkJYYzBxQnpEN0NTRnB3SHR4aUN3bHQ0UFVZMDN6V3dK?=
 =?utf-8?B?Q0VLTk8wV05Uci9wVTMvVU9wNVg1S2ROVUdLV2FDZWRIdWJUajlaUmdoNTRJ?=
 =?utf-8?B?Mmk1VWxvWlNybHZhbXNibDlscllaUXNMamZQN2t4RGhvWGVjVjdSRE1PeThD?=
 =?utf-8?B?ZDFWNWNzZFpUYVQrZkhuc3VBMnlqQTJRbVplUEZrWEI0T0dveTN0b1ZyZk1z?=
 =?utf-8?B?ZVlVK1c3by9ueWF4OEE4T0FUQUxlamgvSXNTV2hmK1Frc0lodEUvSWFhQnBo?=
 =?utf-8?B?R2tBejZiTjFndE9MdFpXMWREWE16VVZvTXVDWVo3dXdWQ0hURzdBWVdOUWEv?=
 =?utf-8?B?OXJIV2h5ZnZHSDNsc2NXRXFzeTdvOHdJTi9OZzRrTXZ0eGZxOTc2dWhZQ0hI?=
 =?utf-8?B?aE9xNEtLcWQxNmlta1JOcFp6M1VYakRZQkc0MFRIRytCVjBkdEFkaElrR1Jq?=
 =?utf-8?B?VFl2d2dVWkZhNEJjeWxwZU1hby8vb3pDalp5bEFSUE5LVU5Ub0gyOWNSYzdN?=
 =?utf-8?B?dWxNQW10bk9qbDVna25FdHBzY1lLaEZGS2wycm5QaWN1TmZjSGtVcS9rZW9n?=
 =?utf-8?B?d01SNmduRzRXeFhLd1dIdzd2d2VsL3YrQ2VNZ2ZTUWdxbVU1QkorTnBDck8v?=
 =?utf-8?B?TndlQTVKVktvOUlDTmdnN0RXNFlLWEx4ZDR4UVhRMnViVFQ4Nm5RQVhPYzBo?=
 =?utf-8?B?RnVVdnRQd2NMeFAvTk1nMXBZaVVHWVE5RStpdWJOSUV6VGZka3orVWRiQTU3?=
 =?utf-8?B?NWY2OVlRcGpkQldVbGNFaGt3RnpWS2dpTCtEbU5DaEs0eXJqdXdTbmUwek9h?=
 =?utf-8?B?SXZZdnR5TmIyR1FsYk1IUi8wSHl5NUdPODl3dVZjSGJRb0RsSVkrekhlRXN6?=
 =?utf-8?B?Qjc1QnBLK0lXRHRFdkpMRHdydmNENmJONVN1QWlHSE5SM0tNTGNMb296bWZQ?=
 =?utf-8?B?Yml1Q1hiVS9vQ1dCOGtIUlhDRXpMQ3JDQTBXYVJlVjRXQ1dJWUwzZlk0d2xy?=
 =?utf-8?B?czg2V3FHb0ltNVJ3UGdoZHZWQkRxNXZzbVVjc1J0YnlrTlMwV1FYY0QrZW1q?=
 =?utf-8?B?ajl6dmdiOHlMaEhMbEZPVkdYVG94K0cxSkN1L0pjd1lYQ3c1RUR6TUJRSmZS?=
 =?utf-8?B?RUgyOHVCZGowVHMxVFVBVFgvWmZBR2pRdFEwc2VMRUNibFFEUVBUbTdiSDMw?=
 =?utf-8?B?b0lncG9NOExGTCtLcGVtb2lsMmgzQVJpYTlpalJUNE5QKzIySjNwd3V1ZkZR?=
 =?utf-8?B?dERrNTlURis2K0Z3VUlBT3c0ZGZuQWNzbS8zclllQjU2UkduQ2NzK21EdWtr?=
 =?utf-8?B?YTUwUnhVUGFvNzRiaDlKVTFSazROUzd2cHgrN2tvNTJQVDVkQkw5d3B3aHor?=
 =?utf-8?B?cGhXdm1EbjV5NjVTR2t0Y1hrYURpRlRmbTE2eTJ2MGxqYW1ncTh4a3VqWWxG?=
 =?utf-8?B?TE5LcWZ1YllMVlRNOUdNQ0pnWi9uK3hQN05teUpzc1k4eGgxb3BZVUw1RkRL?=
 =?utf-8?B?akdtQytoTk82cnRFOG9NbXJaVisyWG1nVGdaUFk1VlF1bnNLd2poN05aVHRS?=
 =?utf-8?B?TWNCeHlOejJMWnU4SzBvbTh0ekQwblFwTHRUQXNmTVB0cnR3eTRxNVRiaTV2?=
 =?utf-8?B?VHBYdVdKT1poVVNDV2FWSlNyOG5qc3RsTGdkNTY5SVlxTmJzc20vOVFHeTgz?=
 =?utf-8?B?Qk1iYy9aQmdtMUpvV3FWUjRkTjE1cUpyRXJDT0srSGxncHJIek5hdz09?=
X-Exchange-RoutingPolicyChecked:
	FSR3yDG1+rwPb3r0IHZkeO9kaoWf4Wg6XpasgRGqk0E4bqyj2kJC66BSuavcfP3lrGGg+9QfXKYqtlpEFenUU8LmluHYd4Mj/PhIa4QnAM9bO7cLiph8jqbYxHRHKr6NMnfK5f+rrSXdyBZN4q2uHsgUBLLswt5M90seJxf+bCWhVtJcXz09ZFzgHv5skSb6nyzaLSDtLYapJnaLiJfeldsBxkCZH+IE+faU6jkuoBL1XbwXaASsFR0MPL1N6/AMD2saBbm32qqRC6G6uwnGpfHLj4mBnEJfT3oKP0XhWLLuXv9DwJs4I7c8OQUWm3x/dBKNVotAUBrADC+PZfSLHA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	514j//lhv9ZTgxmhFP2Ck7O7+EY/fUMQwS9O/h48+5imjIsbQ5JdpW6ZVJBIh57POwnucgEYYW1OINQDM+a0bibM96NJaI+tm8uhpWAdiaQxy/CZI7o5Y26Z+kS8dQCZWXp4pfN53nbiSONi9MHP0C9wzgstkHIKiz11IN5XHxrFek00ztU6gAIwcTwYT2f4a0wVQYLcpu2WsaD5IkgWYxQR7mCQ0/91OhMUMG2nk8jOtvdBrGlhZgy2S1Z8M6qPaitAsnZ6iFFERw4L0PoLEVKN+eObbyMx631WGrz9ihbveUaslT370gglJrBcqhk73LL+wDWMmMF3Ek35BNb1XFxkvBtHrC1CeiaSULQtn08k0rTMkz4iYuSzQEUzxpPS/5inR/vAEEu+eN0Dka+c8og4icEIo8WIMa7FGYFAA2DmPozKOIXP4ryN9sG3C5W5hRcIOGL7C07B5p6aHa7BoK7YwvMJ+wLA1OYKSaePONSWb3UYgF0JiWrNRwtabgnaBxVW2/h/uVjKYBQOuy0pezkEEAzmJYemOXELSJODqeiMfesv2725gyqJpLjBsn0mIfy1K78gOQfdCNmvejj59RkyjovNhRriCKe+1eegGaU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23efce52-78ce-4901-364a-08ded8dd1f18
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 08:28:55.6334
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 51DVbLXNkY9vgKFm2mSpt8XgmhOD2sgqDp1+3L3rdOjC2f73Neh1J53+9Zf1c9JVUnr/wfMlzvPiBYjUcdflHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB7997
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-03_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=964 bulkscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0
 mlxscore=0 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607030080
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAzMDA3OCBTYWx0ZWRfXyoCGb/b8s0r4
 0MYhPHDE0Q0QE1D/SlXtPAiZF4+ia2QHiHKPwJ8oqwHeILC8sVsfld9GNF805M4kq/xzpl5QW7i
 taGystKWknMZUC0wkifPoNd7YeFwxdWoEWNUo7I1JKu/gQJxtkpm
X-Proofpoint-ORIG-GUID: jSLuo8N75dUaj0S6tTQfaTl-OcosEB80
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAzMDA3OCBTYWx0ZWRfX1io8AN9L20hR
 qlLRamsjcobTK00cdzNb6fDIIBsnyGGKlZyjLtme5JUCt9g2ovz+Jw5DCpcstBwZvwlHcoXbspp
 nNcOvTJLb12JjDS3L2AQkPcZq43FR2ILgfTlNMAGkmpfeviTGsdeW7X2UuiMIhh09zRcnaz2xKv
 HcqLsyxaHXtM8NovqzaG5pgqqNX2CoBakbq9/hv9QAybmj86Dgh3baPtZXglO8UxSXA7GGCV2DP
 9Wm4vw6p8ozrMoLubM6GmOE9F6pV6WZDIn2XI2OjiCJkR7wJxR6n4f9u4a60xrD2rTrH5AIXXGe
 jxkjkYlXJxrIkTOgU0BE/Spwfuzwmq6PqZYun+c9pBHLv5yHcAo4x7r2ERYkNxgCt3fyn+9YEVs
 yMMj0GZc6LjvHAXJf+86crQi7Q2/boMkqq9vaCvOEDGcAHGMM5acF34cO/Wq8mtZju1kvlVoNZp
 7BCG/HEHP6vT29OqEdQ==
X-Proofpoint-GUID: jSLuo8N75dUaj0S6tTQfaTl-OcosEB80
X-Authority-Analysis: v=2.4 cv=YOavDxGx c=1 sm=1 tr=0 ts=6a4772cd b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=488x_MSgb1rBO7ymSLUA:9 a=QEXdDO2ut3YA:10
 a=WmVTiCyuxqgg3mnwYu6p:22

On 30/06/2026 09:39, Abd-Alrhman Masalkhi wrote:
> 
> Hi John,
> 
> On Mon, Jun 29, 2026 at 15:48 +0100, John Garry wrote:
>> On 28/06/2026 15:24, Abd-Alrhman Masalkhi wrote:
>>> Atomic writes in RAID1 must fit within a single barrier unit. Advertise
>>> this restriction through the queue limits by setting
>>> atomic_write_hw_unit_max to BARRIER_UNIT_SECTOR_SIZE so that bios which
>>> would cross a barrier-unit boundary are rejected by the block layer
>>> before reaching MD.
>>>
>>> A bio that passes block-layer validation may still become unserviceable
>>> within RAID1 due to bad blocks or write-behind constraints. In the former
>>> case, complete the bio with EIO. In the latter case, disable
>>> write-behind rather than failing the bio with EIO.
>>>
>>> Fixes: f2a38abf5f1c ("md/raid1: Atomic write support")
>>> Fixes: a4c55c902670 ("md/raid1: simplify raid1_write_request() error handling")
>>> Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
>>> ---
>>> Changes in v2:
>>>    - Drop the early atomic write split check from raid1_write_request().
>>>    - Advertise the atomic write size limit via queue limits.
>>>    - Disable write-behind instead of failing atomic writes when the
>>>      BIO_MAX_VECS limit is encountered.
>>>    - Link to v1: https://urldefense.com/v3/__https://lore.kernel.org/linux-raid/20260623072456.333437-3-abd.masalkhi@gmail.com/__;!!ACWV5N9M2RV99hQ!LbMSGSClRi0PNBqQti5ZNWGDVjDd34-7saYEAwNyBNjpNTjEA7veqM5RHG8KB1QiscarW4UaIefjm19ywSImtIgh$
>>> ---
>>>    drivers/md/raid1.c | 36 +++++++++++++++++++-----------------
>>>    1 file changed, 19 insertions(+), 17 deletions(-)
>>>
>>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>>> index afe2ca96ad8c..f322048ab3c2 100644
>>> --- a/drivers/md/raid1.c
>>> +++ b/drivers/md/raid1.c
>>> @@ -1522,6 +1522,7 @@ static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
>>>    	int first_clone;
>>>    	bool write_behind = false;
>>>    	bool nowait = bio->bi_opf & REQ_NOWAIT;
>>> +	bool atomic = bio->bi_opf & REQ_ATOMIC;
>>>    	bool is_discard = op_is_discard(bio->bi_opf);
>>>    	sector_t sector = bio->bi_iter.bi_sector;
>>>    
>>> @@ -1603,20 +1604,6 @@ static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
>>>    			}
>>>    			if (is_bad) {
>>>    				int good_sectors;
>>> -
>>> -				/*
>>> -				 * We cannot atomically write this, so just
>>> -				 * error in that case. It could be possible to
>>> -				 * atomically write other mirrors, but the
>>> -				 * complexity of supporting that is not worth
>>> -				 * the benefit.
>>> -				 */
>>> -				if (bio->bi_opf & REQ_ATOMIC) {
>>> -					bio->bi_status = BLK_STS_NOTSUPP;
>>> -					bio_endio(bio);
>>> -					goto err_dec_pending;
>>> -				}
>>> -
>>>    				good_sectors = first_bad - sector;
>>>    				if (good_sectors < max_sectors)
>>>    					max_sectors = good_sectors;
>>> @@ -1633,10 +1620,24 @@ static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
>>>    	 * at a time and thus needs a new bio that can fit the whole payload
>>>    	 * this bio in page sized chunks.
>>>    	 */
>>> -	if (write_behind && mddev->bitmap)
>>> -		max_sectors = min_t(int, max_sectors,
>>> -				    BIO_MAX_VECS * (PAGE_SIZE >> 9));
>>> +	if (write_behind && mddev->bitmap) {
>>> +		if (atomic && max_sectors > BIO_MAX_VECS * (PAGE_SIZE >> 9))
>>
>> where does BIO_MAX_VECS * (PAGE_SIZE >> 9) even come from?
>>
> 
> BIO_MAX_VECS * (PAGE_SIZE >> 9) defines the maximum size supported by
> write-behind. The write-behind copy (alloc_behind_master_bio) uses a
> single bio, which can hold at most BIO_MAX_VECS pages, making this the
> largest payload it can carry. With a 4 KiB PAGE_SIZE, that corresponds
> to 256 pages, or 1 MiB (2048 sectors).
> This patch changes the behavior for atomic writes that exceed this
> limit. Instead of failing the write with -EIO when the number of sectors
> must be reduced, it disables write-behind and proceeds with the atomic
> write.
> 
>>> +			/*
>>> +			 * Atomic writes cannot be split, so disable
>>> +			 * write-behind.
>>> +			 */
>>> +			write_behind = false;

It's a bit poor to have write_behind initially = false, then allow it to 
be set = true, and then later be set = false. Can this be improved?

>>> +		else
>>> +			max_sectors = min_t(int, max_sectors,
>>> +					    BIO_MAX_VECS * (PAGE_SIZE >> 9));
>>> +	}
>>> +
>>>    	if (max_sectors < bio_sectors(bio)) {
>>> +		if (atomic) {
>>> +			bio_io_error(bio);
>>> +			goto err_dec_pending;
>>> +		}
>>> +
>>>    		bio = bio_submit_split_bioset(bio, max_sectors,
>>>    					      &conf->bio_split);
>>>    		if (!bio)
>>> @@ -3229,6 +3230,7 @@ static int raid1_set_limits(struct mddev *mddev)
>>>    	lim.max_write_zeroes_sectors = 0;
>>>    	lim.max_hw_wzeroes_unmap_sectors = 0;
>>>    	lim.logical_block_size = mddev->logical_block_size;
>>> +	lim.atomic_write_hw_unit_max = BARRIER_UNIT_SECTOR_SIZE;
>>
>> This BARRIER_UNIT_SECTOR_SIZE is a bit like chunk sectors, no? I am just
>> wondering if we just should set it to chunk sectors =
>> BARRIER_UNIT_SECTOR_SIZE
>>
>> I assume that it affects more than Reads and writes, e.g. discard also.
>>
> 
> BARRIER_UNIT_SECTOR_SIZE is the resync barrier-bucket, not the layout
> chunk size. Unless I'm missing something, using
> atomic_write_hw_unit_max seems more appropriate than using the chunk
> size. That way, the limit only applies to atomic writes instead of
> affecting other operations such.

well it seems to be that everything in the driver is split over 
BARRIER_UNIT_SECTOR_SIZE, so is in effect a chunk size.

Note that atomic_write_hw_unit_max is going to be small always compared 
to BARRIER_UNIT_SECTOR_SIZE.

However, can you check the blk stacking code to make sure that this does 
as you want? As I remember, for stacking we take the atomic write limits 
of the first bottom device and then stack the other bottom devices and I 
don't think that setting atomic_write_hw_unit_max in this way has an 
impact - see blk_stack_atomic_writes_limits()

> 
>>>    	lim.features |= BLK_FEAT_ATOMIC_WRITES;
>>>    	lim.features |= BLK_FEAT_PCI_P2PDMA;
>>>    	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
>>
> 

