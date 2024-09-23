Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 961EE26AC3;
	Mon, 23 Sep 2024 10:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727088073; cv=fail; b=slugQdmzQVjMl0fifuA+Q2ycM3WKqz95rgEyeQwbH9ym2BgHnwTmpx2ky53s1Y0qfwYEDDTO/QWmlRpwNkUmww6khgrMyIJx5+78MsXf2wRIHRbAVNGjD5b1IJvBqEXtuzu4W1SMu/jNVPW3ArHl6DMgbNMXxBrziA9CD0ypdu8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727088073; c=relaxed/simple;
	bh=vgx9PYuhtd75DDdIcY++AzzEnMJdokbes03awWCOtVw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SY/F+noCA29o4gsB/XpihQHTMATX2yEKNO8DI/9ySiLAHS1DaU8VGaYz6LlDlMX7ebjXHbHn2BU38o1qjtkSKK9paFwGdva7kUQLmdPfoqYcEwpc1Z630UN0yYos1vPTbS9v/uIF5OyfqbsO17uUEcGgFyB/PtkF0fzgG6f7SmM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RL9a5oM2; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=FntJl2Ii; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RL9a5oM2";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FntJl2Ii"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48NABkxC010226;
	Mon, 23 Sep 2024 10:40:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=sXntBT5Ei+RnDQfty6TCbCsKdT5s3rGvClNBF5ZHchc=; b=
	RL9a5oM22q/k3iFgp4lxz9U4z+pY1cx7XBh8GbG7QRIAXSaKlSD4KIwvJT0EpY4L
	UGorK2BknD+I1KuYQoaDyR57xptbmaYbzlnCLYLHYl7tz2d+AjYZ1PkAiCUTbEnd
	tyNlQABQSUvTeV/s82W2Vu9jOIOoXhJkjU6WmKKkbFucbugJGtnPjbr5UqQXoDHE
	g1TpsNN7IVWMQPnNXgcl5rbRBxBGOecWBMHowYQ7crrax+OhkRMuAokQVPHBy4wj
	LzOgIsGw4vEvBDemR5gbZpGTJuDeKq8l1kZ5x9X5aCuHme6QHVlbYUB61yllfeqn
	K2G/LRiOEjh99dJ1p/dkjw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41smjd1vqd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Sep 2024 10:40:56 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48N9uAp7024940;
	Mon, 23 Sep 2024 10:40:55 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2042.outbound.protection.outlook.com [104.47.55.42])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41smk7m1e5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Sep 2024 10:40:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rMLv048tCYTJ8q6YyVyzWeR5uTirefWartZ0DiPjMEw3GMQ5XRmyQhT+cNQJP+3awA/XhUvhdOcr4xFKcB5T/8bX5bicVodZBVyilZvf9jYQlpoy0ALNtRdrZCb9nUQ01UdsjKipf1pfIHhjCrUrH5Dzttme2WYlXUUBvT4XZjNs50UiG2qtYgOhdeD4ph4aiamE6qe6t3EEL/aCeg1/3S+lNg/W1kEyLVXxs1a828FIA4wt3RHEcE0WIZGAG390waeSoOdb2s1w32YfhfmCUBTmMSlMeiU4HAdqT6UxA/tMTeusTSAJAdJfSDVHioMWL5qQjb8o3H/VdB86gcHceA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sXntBT5Ei+RnDQfty6TCbCsKdT5s3rGvClNBF5ZHchc=;
 b=nztpO/wbUTIKxQ7ls4oJF5HYRiv9XCoBkXeV56XCiC+VR+SGpO2b9KI6QHtk7hGCV2GyAzVDtzQEdH5DxRQcn96yNomHLiGKNlgg7T1PT3Dc2V3LfWd/lKVKaBLjw41xKflC/OUi6JL5Qs2jPOaFCZQAHCQMJCZZnMUkiw/2ErdgsqOouIA3yVJOOUVCUffIMuPVNIKdtOaXq0DFOYJ1a8zKF9qbbaI46g6z3Pq8vdboPWJydM4MckhPVhGHhquRQLxnNZoY2auAMJUprw+TZXzmZaqGDDQx4OVyIrUXsSWeitjHlradsCEwMw7qcVHyVSacD8rO5qR1iGlBRjxkSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sXntBT5Ei+RnDQfty6TCbCsKdT5s3rGvClNBF5ZHchc=;
 b=FntJl2IikbI0vZQs5KGzSCjQHxNTFED4BUa4Bq33UkoIp8eUsOf2MhfHDHnfnhRFe16fyY/Ex+IjUjbLEaXhwSjeBMmnFsofNhiqnUJtoFhchoGAO+z/AOQ/gcfkHzeNuvt6PWuXHLe+CudaveZ76jWFCuwT8wFCDH1bz0oc27w=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SN7PR10MB6497.namprd10.prod.outlook.com (2603:10b6:806:2a4::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.12; Mon, 23 Sep
 2024 10:40:52 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%3]) with mapi id 15.20.8005.010; Mon, 23 Sep 2024
 10:40:52 +0000
Message-ID: <e14a87cb-6f83-4725-a556-0819bcff8a98@oracle.com>
Date: Mon, 23 Sep 2024 11:40:48 +0100
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
X-ClientProxiedBy: LO2P265CA0201.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9e::21) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SN7PR10MB6497:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a3895a6-f61a-4d6a-657b-08dcdbbc325b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SWR4K1l1WTZ3RU1ETDQ2d2RQRkRFMW9BbXFYRyt2SUUzVTNHb1NGQTFMQXZI?=
 =?utf-8?B?VFNQY042bmU2SUh1QUNWL25NR001eFZqRHMvdTRyV1k5eFVFR01tRkxKV2g2?=
 =?utf-8?B?ZFZ1WnFUTGROS2tSTHJPMFl4Mm5tZHVGQnQyc3dpYTROQkE5c3dpNDNrT2Ix?=
 =?utf-8?B?Mk1zeFhRRG9JcEF4cGphb3BFK3lZL2dBOUlkSWlDeTNkTzRtSk9iaUliT0xC?=
 =?utf-8?B?c2hib0pOQ0pIVHJQdjJ1cG8xTkJZRDcwbWNBTDgxSVJodnYwcTNLYVoxREY4?=
 =?utf-8?B?d3p5WXhOVmlHcFQ0UmZtS085cVVxdWxBUUhLWjI1Vkxic2FjN3ZWWDZhU09E?=
 =?utf-8?B?Y1lSMFlKVEg2djJxZHpvR3UxYnVLTklDbENuazExaFpjeXdSQ00rcUtYQmhH?=
 =?utf-8?B?SkVRb0NiYUJqT2diejlmWmFIZU8razNYRm5lR2lWQ1VvbklYL0VuMXVwSWpV?=
 =?utf-8?B?Z3A2M1czTEV5TEp3ckVZay9PaE51OW1IZ0pvT0hHMnU4WmV6R1ZQcnd5ZmY3?=
 =?utf-8?B?WXB3Nis0S1ZmWDU3T2ZjMWpKTDREdFoxSVpkRFJaV1p5VFJ6S3Y4S0REcndo?=
 =?utf-8?B?R2MwZjdkKzhiVnlLYm9Yb0paMVYzbi9jR0dBOTJrSGgydmtlZnplYm16dkUx?=
 =?utf-8?B?VXlVSVM1c1hDNUdFU1RFcHFtS25EN1EvV1VtSHBsM05Rdk04alNDSHpFYk01?=
 =?utf-8?B?bU5IajNmRDF6V1RJNjdZQ3N0NjBkVFBwQTZGS3FaNzJzSmVKZXBmYXpHQmpp?=
 =?utf-8?B?cVoxRjJ1WG1tU0xWNER3N1BnUHFPcXlMcFpaTkpaRzAyRy9SdXdiUTBqMkxU?=
 =?utf-8?B?R0pSZ1dFZUxZb0FZSHhJOS9pb2wweG1HckxPUDZwY2YvZGloTFBWYWxjektN?=
 =?utf-8?B?bDNocnZXTjU1N2M4N251Nm15SUl6UUFXSFJGTUszSFl5UzNBakR3TnBDQzBt?=
 =?utf-8?B?NWQ3SDIrdS9MUDRYcURNR2pPWGZORFFDVHRtem5SL21nd0RZK3ZaM2hiSmJl?=
 =?utf-8?B?TjRGQjE4a01STWNQdDF2SjBqaElJb3VnUkx4eEpFWHVnUTRkM21ydnkxeXhu?=
 =?utf-8?B?QjlkMmFNSDNEWFlMREViUUZsbWdhRW92TUM2VWdiYXYvRlh4WnJvSC8xSmpH?=
 =?utf-8?B?aGkwQ0pPTTdxNE94bmNtZ1R5MmY3MlY4WG43KzE4L1liaUI0dXVaN2RxWUUw?=
 =?utf-8?B?K2l1aEgvSVd2YVBQcUk4YnlzYXcxTndNcEFJbU5uR3NJMWl5SHZIZmJSWllD?=
 =?utf-8?B?allPQnFVc2lWQ0U0VVl2NFdQcWF3dDZtU3JuZnRVczVQUlF3V09NbDJDdHV6?=
 =?utf-8?B?MzNIWmN0UDdvckM2cUhpVlhGSDZqdXo4TDlDSENRRGJRYStXVlAvRnZyLzlH?=
 =?utf-8?B?alJtS2lNcC8wNXNyY2Q3Z3hJL2M5dmYrTEF2ODA3NlQ4dHp5UFhrSUhvN0Zj?=
 =?utf-8?B?Z0Y3K0ZYZUNIK0hRUWYxcml2N1ZsY1l4Y3B3bUdEUVZNNnV5Qm11TjFsSWht?=
 =?utf-8?B?ZUgzNDVsbVg3UCtLWWZySHVlSFdoa0JnOFNHR3ArbzhnUDIvWTk1b1dtZ2hi?=
 =?utf-8?B?enl6RW9zdlhuVHJGQk55Z0JEc3pRK2xOb2dnNk03R3d0dEdKRWZ2bFBSMEgx?=
 =?utf-8?B?anIrT2FJWnVnR1dmM1NURC8veDVYVzQ2Y2JVY2FWUEtXUEFXc3Q3ZlVxSDEv?=
 =?utf-8?B?ekJ0WUd5bnA0bkYyb0Z3clFTa0d3bU54OXdDZ2RKY0tBTXZtMXRUczlaSklv?=
 =?utf-8?B?cWZyNGVXVTc0WGc4cU5sQXV3R1pEYUVBaUM2MHhuSlRxQnRhYkxHUVdaRDRO?=
 =?utf-8?B?SlliamJ1V2tSaHJHK2JDQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TWphdzg4REROa3crekZvT3Z2OWF3RDRjcWlaVnl1eDNKOHR4a1ZncFBHdEhF?=
 =?utf-8?B?N0MwZStsbmtXck4va3JyVHk3WUxEdkJtdFNSekhtRFpNQzFTa1hvalBRNTVl?=
 =?utf-8?B?VS8zZ1lIVisrOXgvaVZNYUYrOTYvQmszdEZyWWoxaXhiSWYwV0dvMlFCVnpm?=
 =?utf-8?B?bENZZmpEV1BoSzhna0g4dTB1MzBVL2JoN2hDNzdjYmhEN3Q5ekphZTRwQmZC?=
 =?utf-8?B?bXFPVE9JV2RBLzEvRFM4WDlNazFURGxSRjIrSmJwVFpzZmpiais3YjVNZFN0?=
 =?utf-8?B?aEg4ZDVTRWkwS1EzUkx5a3lzU2NWa3duN2RVUmZURUZVZVVYeFE0L1JGVEpx?=
 =?utf-8?B?dU9DaGM3VWZZb0Rvd2tPUS9abklmbnVzcEY0WWYrWkZuRVVITjR2Nkw1MWRN?=
 =?utf-8?B?Tlc3NVBVNUlLL1REY0FzRnRoNkhGUkQyMkdJb1JpV1FWYmU3VWxYS2xuelp2?=
 =?utf-8?B?UjZBNHljOHdVYkdIK3dxOHJUaHo1dWVKOTlrR2hpYzZDWlVKZXRjZ08xc3By?=
 =?utf-8?B?YjJLMm9ZR3B1RDEvcW1YZHZjTUFZOEwwcHRpVkRhNkltSHd0L1FnaW8vYSt3?=
 =?utf-8?B?R29jZWhWY0FBQU1OWUwrK29ja2h0VW8rdVdFNDE4cFFvYW9HdFR2Nm9TeENz?=
 =?utf-8?B?MkJTbStOSGduWUV3VkVyNXcwM2ZFMDJabERlMXM1ckVvREtlUHc4RWxNQm15?=
 =?utf-8?B?amFnVmlzNGora2R4S3U3VytJSytuUFU4dWY3aEFZTnAzYk5GN09DUFdKV0I2?=
 =?utf-8?B?RDZ5MCtpUGV3czdTV1hQdC9GcE5idEJlU1hhNDNpak1GZm5MK2VGTUN4S0xo?=
 =?utf-8?B?NjQvN0t2OUZmdG0wczRaYTd2NlJrQmdZd2lxUDhXTEptU2JLRFNyY3BPbFVX?=
 =?utf-8?B?UUVrS1BpNFU5RFA1bUIvVHhaZDhnOHZCamJGMVlpTDRoOU9wL3hIRDNsV1hI?=
 =?utf-8?B?MU1sbXpJV1VUZ3U3aWlaV1ZXUGdrNXIvaW9MNXZpWjBzMnlvSEllYmRvRDFa?=
 =?utf-8?B?bGx2b045bkc0eUFYenNSeExnUC8rNUcyN0Z0NlYzbWMxS0ptOTgvZ01kN2gx?=
 =?utf-8?B?MW1zeTBudDNza0pXa1Q1WUVZK3piMUdCOURHVmEyR2pXdzJxYWRvV0U3QVov?=
 =?utf-8?B?TjRoRlFGUVBhNXp6WjR4L2dpS2piYzNRdXFZdW93bXNrcWVZSU9oR0RXNUdB?=
 =?utf-8?B?MmUrSzQ0UUI5NnRkYlV3RkN4OW5kZEhmL3pNcDkxV25MRGJHak1icEZ5M2VG?=
 =?utf-8?B?eit3S2luNEd3ZDZxV2NsOUhOU1VadjVabUpORjRZcXB2eHg3c3NVVVFqUzg1?=
 =?utf-8?B?cm44cWxJTHBma2pWL2h6dXBucXdFK0pQblQ5VlRqNXgwa0pVcGMrM0huRStK?=
 =?utf-8?B?b1NWNDZaSGdsL1lzK1MwVnoyQ0tCWis4cUp6TUFVL0xoaVM0S1dHZUIrV3hn?=
 =?utf-8?B?d08yWUNMcldtRkFJdDdsckVmR05aWlp5VnBjVTVsQW5Fc0VodllBTHlLcjhv?=
 =?utf-8?B?Yi9MN1F5bHUzdWx6VjhUQTRsQ29scVp4NUhzdEplS1FXM2gzWkgrQThWaXE4?=
 =?utf-8?B?TW5mMXBYbzVvS3gzeTlZRysySk95aS9hVVA4ekkyUkJaQjEzZXdoYVRMVjRE?=
 =?utf-8?B?UWtVdXNiVmF1MmFKSXFMQS9PZUxzRVhLTzFiOUR6NmtqYVM2NEh6aWkvSUV5?=
 =?utf-8?B?eWJXeDNPcWZyQTdJN0hGTGtaWmpoMUNpeE9zSUtCQytEa2pnOGp2Q0c5djhJ?=
 =?utf-8?B?SXo4UmxVMzFZVmh3emlWNGtualBGSjRUd2hjemtLdkZBWjVhSGtWUDNrSno3?=
 =?utf-8?B?Z2Z1MFpnMHhpc0hydjVZWmZWOFQ5UzdxYm1Zdk51THh3d1ovMnJDRjlFcTd6?=
 =?utf-8?B?eS92MjVxZVk0SHNlak8yVjlvK3Z1dWZQWElTeklUalFBUXk5dkduKytXdjlF?=
 =?utf-8?B?cUQvVStFdEUvNFczZVFsamo4cnJPYlVENk9CNE1YaHM3WkxnWkZhSGRpTE0x?=
 =?utf-8?B?WWRhRThrUVgzdVlvRURCTjJUTHdEK0o4WHV3S3RrS1MwckFldXlOejdBR3VE?=
 =?utf-8?B?Yk94SFVvOUNvZG4vaWZBT1ZRZzZwSnBQdGFTcElMbEpSOTZSQk1GNVNQWmFk?=
 =?utf-8?Q?l0z6SheIAOw0qVKyw/01SWC8a?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0sfg8bKsvMMYQqyy0btLNxK1dhAEP+CyyhQPtQxDEiDW3VIeWUwGh06iQtjGiKHH7SvO9sYDBBvo6at88ktN8VphGVgwEXJsdDv4HxH5HYDOtkwhAovZYRBtxLdVmdmtTXbmvZe/r1wbecDJaGhvuceRu+LvPZr53UJ1aQDtzwq8wE5EqpAe7BdBJVTULeaxrY8zwCXlGnBN6FOChii1C8yw/M9EqE2k6VlfyWrprcis7NIqN6hXQreMUpQagH/iBVqJsncEzq7BvZDQdYlrZ793WWirqyzrKRPJzosGW1aTpAaYBMDud5U/4UC7+plvTzrBNuJKOObnFVwJjG5UEAXidZveESiF8E8k4TztUhqSvTY6vLF3D1SceesaHHGeBx7EUM6V/l59lktcjIekxXyfdmBfH0DPlB2E6773C3t8u4b+lrDTRwCvW9QnpRZgn2Is1+SgXuDEGyn4I7r6cyhDrlqPMKstjXiGBCeS1B6r6HfLOz8ui2306q0LD/SkkzYxSIf/W+lXjEJJBkPW1yNExwpIEBGN9FuZQSg44Kcrefum9z/qo2guo0PvGHbH2iHYOAptMFsjWeyTatjHWxeRa6A99DhoQk4182qVYtU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a3895a6-f61a-4d6a-657b-08dcdbbc325b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2024 10:40:52.6814
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U4WY4sES7JSSCxW0kNc3W+Ybu+Kf9szKGE6nxjjcJZX3eSVnIjsyhTXIVO369q4wZIWBv3HhZ3F3Fu1Hj3TdrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6497
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-23_05,2024-09-19_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=997 adultscore=0 mlxscore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409230079
X-Proofpoint-ORIG-GUID: xHWcrRT4VTM47bCkbArHdE0hGYFue0km
X-Proofpoint-GUID: xHWcrRT4VTM47bCkbArHdE0hGYFue0km

On 23/09/2024 10:38, Yu Kuai wrote:
>>
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

ok, I'll check the badblocks code further to understand this.

The point really for atomic writes support is that we should just not be 
attempting to split a bio, and handle an attempt to split an atomic 
write bio like any other bio split failure, e.g. if it does happen we 
either have a software bug or out-of-resources (-ENOMEM). Properly 
stacked atomic write queue limits should ensure that we are not in the 
situation where we do need to split, and the new checking in bio_split() 
is just an insurance policy.

Thanks,
John
