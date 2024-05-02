Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA9657CA1
	for <linux-raid@vger.kernel.org>; Thu,  2 May 2024 22:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.145.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714688858; cv=fail; b=o7LXagJ+OPS//mKgOxgR41QuipQql3PeZ5n9NumzFutUGRzkI5B2Wm4HKiX1vIgyvMu/VtlzfW0Jppldj9gJeg1IE8e0aOLz5dfrverxRdRlYNzH0t4ALfNXs4FM6xPKqF/skExN252nxqFU2Jb05Pvq2ThaMbqX9QX/zmRyIDI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714688858; c=relaxed/simple;
	bh=oCxUYTkhmQRvSmBrR7B+mrKyid+SA3+QZpXBv/nVDoE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CeOW+kPjCDh8Cg/12YobgUh/DdY6xp9JcqR+rFp/G0DUp5pd3hM5W11uELaGK1QTGQ0phHsfAuul04bYXoz3C/Ksli007ftJy7ShJPJ0vcouuT6lvyriEW/TGtzxcKs9aPnmPFFHRXsMPOs9sxbEnD09tQt6Q4onWBiSeT16M+E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=K/QrDbVc; arc=fail smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="K/QrDbVc"
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 442L0TNr013598
	for <linux-raid@vger.kernel.org>; Thu, 2 May 2024 15:27:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=oCxUYTkhmQRvSmBrR7B+mrKyid+SA3+QZpXBv/nVDoE=;
 b=K/QrDbVc7eMhH4ri6im8Yclf0167pOS+nQE5/8/9rzDqjAiFws5fiMqfHNTmKqFeImR6
 /SYTIftdJgpR8fx9DyC9KcIpyHuf38Re2Ye0WyIKPZxduWrZt3yk0jnxARmKHdAKFb4N
 vYNKQv+yYgCyiS4ZXIOvTn0oD1Hm720UT/mVPyU8npJ8KqYRYddetqjNGizAwV1eYcmq
 Xn1N2eeeZACiuRBvhCeJbxncc/7xiqiUHc4krTtBeyy5xpCJe1xf1K9TQDSoMSPvjnCT
 wNQ27OKXnbYZHhxCfMMT74/v/eUQ/eqXtM64oy1k3DMZ0W/VPYDRQDy7D4RPfdqIntQQ gA== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3xvjbxreax-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <linux-raid@vger.kernel.org>; Thu, 02 May 2024 15:27:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D9yTNhtVeQm3JTyJYnc0NyZUoKaQGLGsP/uRg/9PmqLhmUPX5X8zJou7x8oC5uHUxzsVbQ2830lYMbmISTCmwvIKEHBXuUbQCoGrPiIITrimXfh2+AYA6N0Zxk/Y9LX7bUi+ndN57Li9cxZHf6sH1RHBJYGr8vB66CII+OdcZnYNDYZvK9kozg1zXu8PyrxMGySWUtsBLxzldjJrwRJ/zdvd/mK05rqZWMJnfKskMhHPlNeslqwuQyysmPHVs0/hWWm5meJJza2/tiUzkzEBLuAcGP72nrMZ6ljyZ+sKyoCUKG8sZbJ5ptS7Q3Dt+d480rZebBIgxCnOO+V0T06hDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oCxUYTkhmQRvSmBrR7B+mrKyid+SA3+QZpXBv/nVDoE=;
 b=Q7XEyz4JfeLbMdkPREru4Rr9oFp2cpd8WfASl46dtXI+ai1a/9Ga1LJ9q3RK21Y070IdRyT4A405AfiUFLdOv8o6indGvSg+69G15l6qAmpkn+IZSjr2iCFTyYkmKJ292az00+3DPlYqjmN8T3k2dytlDGh7iVje5rU3bVN9fLPdahvSWzb+5AjVO9ECBSSB7WitG6yMJBArr4fj0QlF5ig4QR9eYdthe2nqENtg+FNxtR5eMIi3Vy0i1ARjN9xhpCq0CzQBqDYhSFtPGShPQ7LlABtjbM4mJjoFbDdURckbaSxsgX90hwXefB6/7I5gQaq6TcuRgnmeEBvLYakelg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by MW3PR15MB3899.namprd15.prod.outlook.com (2603:10b6:303:45::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.25; Thu, 2 May
 2024 22:27:33 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610%4]) with mapi id 15.20.7544.029; Thu, 2 May 2024
 22:27:33 +0000
From: Song Liu <songliubraving@meta.com>
To: Jens Axboe <axboe@kernel.dk>
CC: Song Liu <songliubraving@meta.com>,
        linux-raid
	<linux-raid@vger.kernel.org>,
        Yu Kuai <yukuai1@huaweicloud.com>, Yu Kuai
	<yukuai3@huawei.com>,
        Nigel Croxon <ncroxon@redhat.com>, Song Liu
	<song@kernel.org>
Subject: Re: [GIT PULL] md-6.10 20240502
Thread-Topic: [GIT PULL] md-6.10 20240502
Thread-Index: AQHanNxTvSpI70sMCkyZBe0SWpP8FLGEhS8AgAAA5QA=
Date: Thu, 2 May 2024 22:27:33 +0000
Message-ID: <57AF0963-79A1-45AB-8DC4-306F81AF0BD1@fb.com>
References: <B0747FE1-2648-42B0-AFDC-017BACB64588@fb.com>
 <3f1523d4-941b-4e6c-863f-dd1dd49fcd1e@kernel.dk>
In-Reply-To: <3f1523d4-941b-4e6c-863f-dd1dd49fcd1e@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.500.171.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|MW3PR15MB3899:EE_
x-ms-office365-filtering-correlation-id: cc53d19f-2e6f-4ad8-2c4c-08dc6af70fa1
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|366007|1800799015|38070700009;
x-microsoft-antispam-message-info: 
 =?utf-8?B?VnE3UHpFOHBEZUVaczZYdDhxTG9Cems4a3YvcnhnZC9NTmtLTWluZUF0bUpQ?=
 =?utf-8?B?QjBHbjlpS1dTRGJzbFMzYWRGbm9ZZTJVeEVCMXl6YlI1Ry9yR3N6YlRLelFv?=
 =?utf-8?B?MGtweVdqR3N5K2pNcERFbVg1dzcxV2lDWVhzWUEyUVBDdGw3YzI2dUdnTWpr?=
 =?utf-8?B?eEtlNzVhNm5EMncyeFRkVmdTcGFUTVN4Nm5td0lWK0xkeXVkUHpoZnVERU5u?=
 =?utf-8?B?OTEyK2grYjA1ZE1RbjRrcEhsVnV5QUREYU9FVEY0MDR0SmF4WEFHMk5iS3o4?=
 =?utf-8?B?UDZyOWxRQ0wwVmxoektPVFV4alRvbU11SjQ3aXduRFBXQmF4SUtXSjh5aXNi?=
 =?utf-8?B?cGlUaGJuRFhrRjlzRWJtSnZYVExZeGxtL1hncTIxWCtUalJIN1drY3FERnB3?=
 =?utf-8?B?L2EzbCtxc2dEUDJxT2hyMUx5T3ZMNS9ZTStHUVhBSExkU0VXU3hFY00yeXF0?=
 =?utf-8?B?SWxpNS9mM3hXVzZ2NENpdUwwWktKZEN3dzBKandubjc0TzVZa3g3Q0dGb2cw?=
 =?utf-8?B?QythY2pSSVI1cDM3VGJhbnFmTXpUbWVqZUhqQjJpUEVJKzhjZmhwZGovTm9V?=
 =?utf-8?B?ZGQvOE83eCtGMHZqRU1EM0NKTEdTQjdSS2tyWTBiSFNhdktWVXM1VFJRbXJu?=
 =?utf-8?B?UDY2VUNhdVBpN2ZrSUI5Q3RRMVhwZndubUc3T3FwM1JwTXF4THVZM2VKOW9t?=
 =?utf-8?B?L3U1ZGJjRFVqa3J1aGpHN0NxeEdIaG5ubEVpOVQweDk5c2szdWs1Ty83RCtV?=
 =?utf-8?B?ckdOSmxZd1NNbWxFSWJyQ1lMdnJHb0k4aXlXU2xqSllDbWRENkNsN00yeHFo?=
 =?utf-8?B?QTAzZHZLT1BZak9jOXZXL0NEbGU3QWs0b3RJYTB6R0tZVjFlRVdlelBDOEtq?=
 =?utf-8?B?aCtiUjRSSGtJeDJNQ3NJWWN3ZVlxN1VxUTJUdGdjZHJabGpvQ0JoNW5MWktC?=
 =?utf-8?B?VWdWV0daL3diZDhJMjEyOWNCd1RWbDhrMlhFL1l1bC9GcnVYVWJvV3ZOdGE0?=
 =?utf-8?B?YUs5QTZWbE1oQ2pPUHFpU3I5d2FFdzUvQzN2dUxxS0F3MXhCeVE4T2NCKzI4?=
 =?utf-8?B?VmhxelF1Y0F4M2hMZ0hsSHlicjVsRXlURElIQXdpR2ZiYzQrVXBVVHpINGsr?=
 =?utf-8?B?WXN4TkRldXFBZThUajQ4azVMZFhzMVJLbEJEVjNuYXJFem5PWk55NC9XYzlQ?=
 =?utf-8?B?THdKVlBGMFIvWEJxa2prdnpmajc5L2w1Zy93WlQxT2w2L0F2Vmhsb0k1ODFs?=
 =?utf-8?B?WkxWMTdFMms5bDhZQVZETnRYa01iWlh6ZFJla1FzcS9SQldVU2lCQXZWV3Jh?=
 =?utf-8?B?Nit5eHRSa0N1T2VTYXYrQkg5R0Q2ay9ubi8zWnZoMzNWUW1IeFVscDNoS3k5?=
 =?utf-8?B?aVdHS0szUitqZk1pWDlJbTl3NUUyV05HTFFTZVhrSVQ2Ui9UTUwxMkptQWRw?=
 =?utf-8?B?disxeXI2bEFIWmxqaldFbEh6MC9JQ2E2azVkNTBpWDY1cHp1bVF1Q1BjMzc5?=
 =?utf-8?B?c0lCMzF1ZVpNMHJUVnpxS0lFZmVabU5DUDFVYkZOTjJMem9UaWlrWFU3V1V2?=
 =?utf-8?B?dVdQZXBsYzV6ZFNlbE1UelJQMHZWbHcwM3B3Rko2Z0VyeCtNUEhSS200dlBt?=
 =?utf-8?B?N1JyRW1ZRzcvWExjbmRnSEF5NUVOcjRlbGZwblQ1Zkh5bGlHRFhidjdoZnc3?=
 =?utf-8?B?OXFZM3orejE0ekhpNmtweHZWUnZIUTdvcktERFFBaHpyMmhYdGZUWTFxK2hv?=
 =?utf-8?B?aFBUcGxEUmIrWHJDK08yNGRlRzJJUzJKc09IOHpxd21uam0zUGR2cDMzbDVB?=
 =?utf-8?B?NjRVUmJpeW50ZXpMUmFqdz09?=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?anBCYkhBNXE5UWFySFdWQmswby9OU0RDZGVEblI0MHZSc0pqdDc4RDVBMkE1?=
 =?utf-8?B?RHFzL1BBQk1XbkdTQzhvUmxSQW8vR2xDb2llRkVaYzB5M0NQa0sxc2NWdThX?=
 =?utf-8?B?L1gzSmd3R0NRQ01XSVVjWjVSNjFUMGtOUG0vS1hqOXA0OUhIY09QYW01cVlt?=
 =?utf-8?B?dTZvbnZKcEdKeEU0bFp3Z05hYWFyUjZNdjZOWUxhNkFjYXlGY21KOGE0alph?=
 =?utf-8?B?Tk01SjF2K3UrQjIvVy9KM2FpSzBFVWppdjFXakxnOGhHQlhYcVFxTnByWmVq?=
 =?utf-8?B?V2YvRGFqUk1sdkxibWlaQzNiakVDdmVjdjdvc2tvU1RtV2tFMTNRL1BHdlZq?=
 =?utf-8?B?M1RMZmVWNXMvbnM1UVhVMDZydlJVak5TazV1REozcjB6R0Z6bXVGSDZjWDM0?=
 =?utf-8?B?dWluY3BIQ0R3Z2VuMHdYdkJSUm5tZkV2Y3JsWVNHMW1ZV2x2em5EWnNvMjhS?=
 =?utf-8?B?MmlXQ3NacWVqb0p4ZXdkc1J3ZVpuSGVZcjNIWk12L0pRd0ZIN1NYUnB3b0px?=
 =?utf-8?B?ektHZFREQzBkbzFJNytLT1IwMGNMR1UxU2x0R3hsblBlckVrK2NZMGJoUkNJ?=
 =?utf-8?B?Z2JCNHpXTWJkcG9pWVh0WExQMEJXbGJTODFaenVPM2RrOEx4SWQ5WFh2TThh?=
 =?utf-8?B?YmtJUWhHMkdmWTluMHpkS0hJZ0lxTTg2VTRCYjFwSFhhUGgzSTJpSmRvVkE4?=
 =?utf-8?B?bjFEQ0g1eFEwcVVkVkI5WHZRSGRSWHh3UXFCZDRzelVScy9ZT3F3cW8rWUd1?=
 =?utf-8?B?Y3dTYmdGRnJOVDRScWtrUGViZW9DSEZqV0FSWmU4cCtONkxPWThjTzdrVHBJ?=
 =?utf-8?B?N04rNGJ0RHVaeEJwbkg0MUM0cFpkS01rTGc5ZmtEWThZaDFGRUhyZGNZU0tK?=
 =?utf-8?B?blZkenZrKzZrRy9qRmZLanFWcXRzb08vTVpDVXBIMWdaOE9uUTVwMFRybzRw?=
 =?utf-8?B?dWhRUEVrbVlHbmpSWjRBSmZ5UzlnMTIwWENJYVhkTlByVUxoY0tONkdqa3l5?=
 =?utf-8?B?YmpQVHNlSUR5Sk1nS3J5azJVSWM4NzJFc0Z5RnA1a0kwYXRpWkk5Yk9ma1Vx?=
 =?utf-8?B?MEJaNkU5Njhzc3RqR1lqcVgzR3J5dk96NlB4dWZUaUkyb0J6TEwzVVdlMy9l?=
 =?utf-8?B?cWFRbUhoQUh4Y1JmbkpGTWVmRnU0cmdGY05VZ0I4aEMxR3IyL2hpUHpkRTln?=
 =?utf-8?B?ZnpXeTVuTkp2Ym1yU1lRYXgvdDk2Tzd6V2tNZVJuYzFvQlU4ZEtmOURIUDd1?=
 =?utf-8?B?SmIvazg5SllmMEJOOThQRGJFYUc1K1EyVkFEMGJxeUF2NWdLQWdrcXRMQ3Y5?=
 =?utf-8?B?RHpGRFBwZGFpc054OEJoSHNFd1IreGJPVEFMblNOdjI5blBOZStzUTBmb2Ey?=
 =?utf-8?B?MG5wTStkUm1VbHRZdC92d1cwVnJ2d1ltNUg0b2JYd2J6dXEyQXJ1cDVsOVB4?=
 =?utf-8?B?clkvVkFZYURlNDdzb3hRbHpBQ3NFL1hkVGtyM2FOQTVRSXlYalJTVjBSckpC?=
 =?utf-8?B?UjY4MHQ0UFNPblFCK2hFWFczK2M3RWZtOXg0NVRRYXlDTVR2azFqeGt3NGta?=
 =?utf-8?B?eXNGSE1wSy9oN0Y1VGlPV09tdjJ5bWZhSkxldGdzVmMvOVMvMjZhTlF3OE1L?=
 =?utf-8?B?akkvRVFHb0c1Q2JMR3AwTUo2N3A4eUhYMHpvQWJXY3JQVG1YOFlBQ0xoM2JG?=
 =?utf-8?B?ZXhlWllWQisxRzlwNWoya0dNRDZ6blZnWjMvbWF0eUtFRmJaVlM1VDRSVFZ3?=
 =?utf-8?B?ZnpYWEFzVkwrempHR2VTUkZlalRUUFk3UTB6TU5oVzVEYndIdTdyQzQ5WTZH?=
 =?utf-8?B?aEdHTjBQRHpJUUJJQklJckpSVVpDdmhQUkc2MGhVTlV4WHlQR1ZrdnVQdDJF?=
 =?utf-8?B?cE9hOTJHa2dqWjdtL0VKM0V0Vm9FWnU0ZzRRQmc4WEw2eEY5Nkc1L2tQSTZH?=
 =?utf-8?B?d0FBMUdJY1RCL0V0L04ySHN2ZlFUNks5ZWdSbjR1d0ZZcStkd0k5WitKajIy?=
 =?utf-8?B?dytZMjk2UDVYcUhYcjdRbDF4Rk9pNndGSUwxRWxrZXh3amN6VWVwN0hhNjVh?=
 =?utf-8?B?VXZjWUdkRmZwR1VMdVgrbkhXd0oxRW9xTWZlV3dZd2hPMXViQWx5NmNMdTlS?=
 =?utf-8?B?M3J2bjVaUlYyNWtBK1FleXYyZmF5MWd5VUlXMFpDNGxERnh2bEV4K0dNbGsw?=
 =?utf-8?B?RUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <101F34B27F3C28438DB825CDE7D5B948@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc53d19f-2e6f-4ad8-2c4c-08dc6af70fa1
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 May 2024 22:27:33.0876
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uv0t/fGSOciIEV1Rj4vpwahK7sH8gasZzbdngooqy7VXgdsWo6XHv7ORcitE8kDqXveHUexL+6NGpZ7ud4m9ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3899
X-Proofpoint-ORIG-GUID: NZNhesBHApRNarkYzITFHhE0d26FyulG
X-Proofpoint-GUID: NZNhesBHApRNarkYzITFHhE0d26FyulG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-02_14,2024-05-02_03,2023-05-22_02

DQoNCj4gT24gTWF5IDIsIDIwMjQsIGF0IDM6MjTigK9QTSwgSmVucyBBeGJvZSA8YXhib2VAa2Vy
bmVsLmRrPiB3cm90ZToNCj4gDQo+IE9uIDUvMi8yNCA0OjAxIFBNLCBTb25nIExpdSB3cm90ZToN
Cj4+IEhpIEplbnMsIA0KPj4gDQo+PiBQbGVhc2UgY29uc2lkZXIgcHVsbGluZyB0aGUgZm9sbG93
aW5nIGNoYW5nZSBmb3IgbWQtNi4xMCBvbiB0b3Agb2YgeW91cg0KPj4gZm9yLTYuMTAvYmxvY2sg
YnJhbmNoLiBUaGlzIGZpeGVzIGFuIGlzc3VlIG9ic2VydmVkIHdpdGggZG0tcmFpZC4NCj4gDQo+
IFRoYW5rcywgcHVsbGVkLiBBbnl0aGluZyBvbiB0aGUgNjQtYml0IGNyYXppbmVzcyBmcm9tIGxh
c3QgdGltZT8gSnVzdA0KPiB3YW50IHRvIG1ha2Ugc3VyZSBpdCBpc24ndCBmb3Jnb3R0ZW4uIFdv
dWxkIGJlIG5pY2UgdG8gaGF2ZSBpbiBmb3IgNi4xMA0KPiBzbyB3ZSBkb24ndCBlbmQgdXAgd2l0
aCBpdCBpbiBhIHJlbGVhc2UuDQoNCkl0IGlzIG5vdCBmb3Jnb3R0ZW4uIFdlIHdpbGwgY29tZSB1
cCB3aXRoIGEgZml4L2ltcHJvdmVtZW50IHNvb24uIA0KDQpUaGFua3MsDQpTb25nDQoNCg0K
