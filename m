Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6728535893
	for <linux-raid@vger.kernel.org>; Thu,  1 May 2025 07:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746082836; cv=fail; b=NoBzMZlCZA7/QQhMxBQKAmTXFkG7L04Li8gd9fhbflQyzzxdF3c4oqBrc3vF+VvUhETtUDCXTFzPZGwaxHVhxohafA1gREoE9X9sr2eurHedGpZDFkomXQMSB8ErkD7FyHAP7gbsG+2lR3mxLIAHSfU2rKO6wD//bwHYLpBVQU0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746082836; c=relaxed/simple;
	bh=jeL7LlKjVdn33bFSJUeVejUVLEgwhp7uWtzIIND/uhc=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=WSsPAJDltJyfUb0PRY8sI5wk+4IvWqBUYdZxr+nkzOya7pJb8sCkVBxvKQANvpelpTIp9cNCua9G81IwxbZ10UR38Fj+c1jiiuL2hUT7kt87YODgB/dp19dOSWRNNQd+WOfnaw9a8NLIsHdksin3JtsOjzuGD1OW3Ss3QLurXgU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FIhYa+r4; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Cfxd7wsg; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FIhYa+r4";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Cfxd7wsg"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5414Wv7I028531
	for <linux-raid@vger.kernel.org>; Thu, 1 May 2025 07:00:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=lJ+ljMF8wsi3Kt0k
	P+qzoi3Tc8TN10kGHYRDyMyoFm4=; b=FIhYa+r4kG8piYKmogCl0uU/Gesbz/63
	IVSMZugI80SaCZk8MAd9BIBWKZvA6MEn/5tD1O2MoKNEFcfX9d56q1UgORLyJU+e
	UfSLo8U/4IGFLp/MsA1Vat+WVO9SAvj5gy/1KV+8JdZvijgLQ3q/ZlIx2ioHz8z9
	lo8/d7pLZ5O3tboVZRUJiidA5hkHGYrdMxh4KpKkS7puiIV5WXoedu61WYyFDGWd
	Zivs/0ZgygmT9x6bkBlihy1SSNW0lUdbi0n3nK8zRHrVdVN+h5eNp5Gnfv64rXvH
	5SynSy7xv75rc6U4/rPTy8slhTZeyd/gL3v8dVqbTEZDANXWsEeesA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46b6usjmug-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-raid@vger.kernel.org>; Thu, 01 May 2025 07:00:33 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5415qOph001375
	for <linux-raid@vger.kernel.org>; Thu, 1 May 2025 07:00:31 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazlp17010007.outbound.protection.outlook.com [40.93.11.7])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 468nxc8su8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-raid@vger.kernel.org>; Thu, 01 May 2025 07:00:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qe2Es0WltcOLrrMh7U7ypTPDzoguCWoPU5fTaCclsyuHfaCC/euDR1rji3WudSE+ZCD+1J3j5z0GIgBcbhwkVDyxpn2nyHVgbc9px+obQAfX63RXXs/QDFgEdH9hd9B80eYAXA7G3UolWbw3bWI8SdeP03r/7D2k5A/7cnPPr4ixCh1CQ4gFDW2dHMtbACezU8i0K90v9M4PujX8NnSYw72h5sYYLL/mscHtEsYkCh/i20krw1gUKPyHOawg1XOVn83CRQAoPIqIkHnUbltoNiUy0sdqg0f0Vd7E3NXzHc3s1lq3PUP8JLj5kZxBESQqKNeCxspOiVrBR8+hy3DgWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lJ+ljMF8wsi3Kt0kP+qzoi3Tc8TN10kGHYRDyMyoFm4=;
 b=MieidPph7ym+cm7sIHM5TVx/GcMAvBMXElajxlw9rpCD7uqUNWCXmNYYUpaW46wsgF2qgVb+Ge/mawJ+ZcA28tWa/HSAZL9pgfmUtOD3XEG7knfC5pFvchHUjz5iPqh7eCH3LXRByroVp9WLv7tETWWD+7e1qeJTDkSLCkyc1PC8iA0hkI5Fj7TCCir1oRaSc1nQaNc6gGVBHhd1mABzBHuxYiNQExE6w06VfL56fucla6H4H/jYHMFnV2XMcQHpF7X3TFHqHqjUKJwEDcR7ikTPSY1wIxhCrYV4oQLZCOQBwGzcXPWAh6BZFKBzYqyuRM3EOSzRnMthMIJ+bzDy5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lJ+ljMF8wsi3Kt0kP+qzoi3Tc8TN10kGHYRDyMyoFm4=;
 b=Cfxd7wsgv/aDtbtDyNTWeKWyFylDk+4JW+TGC3NriN1GZnodHXJifBN9SJfhOluNpFh0ExxfaIPBOZsIN8KiibAp2hL6gQ/TZdZv2GwlX3hlISmwsVPxuD7lez23ThZoyGnxvUrJVjlqV1gcDv56IyOQ+88X0G+V4ynNngzwimM=
Received: from DM4PR10MB6040.namprd10.prod.outlook.com (2603:10b6:8:b9::13) by
 IA1PR10MB7287.namprd10.prod.outlook.com (2603:10b6:208:3fa::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.21; Thu, 1 May
 2025 07:00:28 +0000
Received: from DM4PR10MB6040.namprd10.prod.outlook.com
 ([fe80::ced3:7ef9:5d82:5a66]) by DM4PR10MB6040.namprd10.prod.outlook.com
 ([fe80::ced3:7ef9:5d82:5a66%4]) with mapi id 15.20.8678.034; Thu, 1 May 2025
 07:00:27 +0000
From: Richard Li <tianqi.li@oracle.com>
To: linux-raid@vger.kernel.org
Subject: [PATCH] mdadm: Fix IMSM Raid assembly after disk link failure and reboot
Date: Thu,  1 May 2025 07:00:24 +0000
Message-ID: <20250501070024.111317-1-tianqi.li@oracle.com>
X-Mailer: git-send-email 2.43.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR08CA0072.namprd08.prod.outlook.com
 (2603:10b6:a03:117::49) To DM4PR10MB6040.namprd10.prod.outlook.com
 (2603:10b6:8:b9::13)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6040:EE_|IA1PR10MB7287:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e9b7e6f-6a1f-4c1b-78ef-08dd887dda74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TExPNmltTE42N3V1VlhyR2VIbFBPejErTVYwWW5TZTJMdjRuOCthdjJJUy9u?=
 =?utf-8?B?UThyOXdzaGVOK0FaeXMwSWI2K25CcmRLREdneGRSQjNLRlMyM3hjMlVwQjZr?=
 =?utf-8?B?bThNb3NSd2pWNWxnNUpNWmZjZXhoMWp0bmU1Zy8yRkdBVUhpMjJyTUwvUG1v?=
 =?utf-8?B?U2RyZHJPTTVvUEE4eFVJZXR3TnVrdHNxaWk2WXZmcnBON2hsY1l2SWRoejRZ?=
 =?utf-8?B?dVhqdVRCUllGRWUwUytTV3kwcFovY2ZNa3RPellLQlhpK2ZJT2ZzNkV2ZmlU?=
 =?utf-8?B?UEJlaG9yVlNjM0FNTmp0a1hmdjZzVjhsY2RuUmpQcGhvVmp3TCtRd2Z3OWdY?=
 =?utf-8?B?RzQvQnE1RGFxdlJSSWxDaWhkYXQ5RHNWN3RtRGpuVTM1QUJUVTY0azIyc1hn?=
 =?utf-8?B?RUhCK1dKb284YnlNREFEb21QZzRwbkRGaEYxQlVxVVRPemtrbnV3MXJ2Rk5m?=
 =?utf-8?B?dmZEeWhLbjR0V2Vyalg2UW5adVdGbnU2RzVjSUpGSk5GU29EbDJqaUg2b3lM?=
 =?utf-8?B?ejJhYjY0L3VqNEJXNkhpQkdOaUhRRDczMWRWcUhqRmVsUm1lYW1lbjdsN0F2?=
 =?utf-8?B?VzkzN2JzTDV5MDVGWUxqSVdzd0g3VFU1eEVWZjYzdXRNajdXVEdUMGR0aWEy?=
 =?utf-8?B?cjhDeUc2REU1U0tOaUcxZTh0dXBUc1JwN0JyTDh5cnNQamFZZVh0UnFXWXJo?=
 =?utf-8?B?Vmtlbk9xT2EweW16OTFXSW50WnBDRmU0bkRYZk0yMlc3bHpZaGxTNXdkTTNS?=
 =?utf-8?B?S1p6ckFFV09RMzVmRVR5djdtZjBtVzZtMExSV3cxamtiM0tDRHJJZWh5UVJl?=
 =?utf-8?B?Q1dWaFdXYjJnT2hibjM3RUhBV01yZ1VPREY5dXBPb21RTGJjUGtYTUU2S2E5?=
 =?utf-8?B?eVFXbjVOVWlTL2ZGOXBNRjJJRE4xdmVGZ09qcFRXY2dISmIyNFAvREt2cUw4?=
 =?utf-8?B?a20yZkJnOGdZSitKNHA2Z1dOa2lpRlpGQjF3VDdnRTNDMGhpaTZ6eUpKcEFh?=
 =?utf-8?B?VzJpSVh6aE96RmtLYVFGZ0hHN3BickpzNWsycm1NNlFvOTYrUnBrQ2xHdDhy?=
 =?utf-8?B?Q0NQemlOYnV4RnJ1WXY2b2lialZBUWxRZEtJSzRPOWVQZmR4SHFqNGRzZHcw?=
 =?utf-8?B?NEZ1R3VYK1dBdytDNGZhMTFNeVpONE44b3pWbmlXSmtOODNLb05WMXlZRUpI?=
 =?utf-8?B?OUtSTDViN2FFZE9OTndMZjdoMlJlWEFVT2xkR0hITmlycVZVM1RyeTF0UCtL?=
 =?utf-8?B?RlhzaGdCM3g4L090YTFtbFV2Q2tBU1BLenJzeHZlVVF4NCtMaU5VSy9rQS8y?=
 =?utf-8?B?YWdhZUhsYkhWMnVCZE8yQ2llRHAzVWIzZTd1OWd6VHVOQnROdkZSSWNQa1JW?=
 =?utf-8?B?MUkyTWRiTVIrcStYQnNyZGxKTmpnb0J6L1U1OXpzeENaRG83V0JreUZ1RzdQ?=
 =?utf-8?B?eHdHSTBndzFnTjdKNEVuQkJxeVcvVjliSUt6elVydTFPM1p5cDdhYWo4SFNy?=
 =?utf-8?B?NmlveXdLenltWDJiZnV6VXFRZGN1QUlmajdCMFJjVS9sTGlILzdDSFZHb2dB?=
 =?utf-8?B?ZnJYMnFlSG45VmRRWlVDK3FiSGp0Z2FpWVV2djRQcnJzYzU2L2dtNDdFOE1o?=
 =?utf-8?B?SDdVZUY1M2lpaEREUCtVWTA4d3FPbTMvVmZsTEJhemN1U3phMGkrTVQ0YjEw?=
 =?utf-8?B?Z042dU1vak8vNjdweXRZSGZvNnNOUWhHcWQ2dlpKWHFHRzY1c216OVhFdFNO?=
 =?utf-8?B?b2hqczlYN2VWWVlsQytCVmtKdDhXR3JpV1FGQnBUcEgrYVJFNjVwaWtFd3dW?=
 =?utf-8?B?NnhVdC9FZ2p1cVQ2N2U4bWNtWDBwY1FzcWc4UGgwNGlpNElYaXV1Z080d2FP?=
 =?utf-8?B?U3lpelErM1orYll0SisybExoQ0Y3RHlHM1FLR2Y1SEZoNXRJMCtGL1JPaW9O?=
 =?utf-8?Q?FW0GVGZG+q0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6040.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WWV2OXN6N3JPU3haZmlJK0FQdFBSbjhYSnJyQTNSOU5rUjRrWGlRZTRQbzd3?=
 =?utf-8?B?aHBGTHFHWHdGQ3ozZ1FJcWVJZ1Y3M0V2U3hTY2FLeHlTZ2Z0T0c4ckxOVDlx?=
 =?utf-8?B?dVNiNlJRaTVLRkE5eW5lcDlxT1RwZTV3N2Jid3E5NmFqQ2dWU3lHdFd5Z1li?=
 =?utf-8?B?RVVBOEhLQk91emJhY2VUdzBsTTR0NHJDSWw5Y2NFTFB4N2VlYURrM3ZUbXRR?=
 =?utf-8?B?d1pWTUFINlJpdkFrZk1RYVFETEF5cDJkeUJyL0l3ZnZEMmpWTGtuU1Avb25q?=
 =?utf-8?B?aE5QcStTektGZ1dsMjdkOXRqTnB4NC9yRk1JZmVicHpvMTQ5TGtFVHVDWk50?=
 =?utf-8?B?S2lxOXA1am9tM0xvN09YRW52U2lOL2l5QTZTaUNaV1d3Q2pwa1JpbGdHR3NT?=
 =?utf-8?B?STJjdHg0MnhjZktqeHFHc3lFUVpJVlpCVFFPbGxDZEFta1NjcGhyRkw1K2ZJ?=
 =?utf-8?B?UUhaRDg3dEo5c3ZMdy8rN29JZy83YU1oajF3SWljWEpLM3loQXMvZzdSYnZt?=
 =?utf-8?B?MDNSZVlLMC9QNTJ5dmZEeDJjTWliTlZ1SEY0Z0JoWmVkZVRkM2JhcWVCanFQ?=
 =?utf-8?B?aXgyZmNEemF0blJKYUdPWlYwT0NkWHlGTCtNaUhNL2t4ZmZyUENPaENJeVNs?=
 =?utf-8?B?OG9YVThYcVJhNXB2eXRNaFRpRUd5Smw5SytGZzh5RG9HRk0vNTh4SElxSnV2?=
 =?utf-8?B?Y0psbWk5eEVORXU4WEIzNXE0bmdFeXF1bHJRSFFUMXM4USt3MVpqMDIzWXZM?=
 =?utf-8?B?aTJyWjg1MmVjOXZhUFJEbGh6dDFRK285bmcxa241MkxKY0JtdmZXeEZSZ2o5?=
 =?utf-8?B?SHI3MVAzS2FpWCtFUGg3c2gySjNkZXEwK2tQQTF6Z1cxVHRpZVEwdjJjc1c0?=
 =?utf-8?B?K1Y0QWIwVzdXTWdQNU5uamxRKzd6SG9nOU1CTUcwT3EwZlIySEM1a2prUWNU?=
 =?utf-8?B?Ykg0bzdId0NBOWxZQ294K3VlL05WRGRZRGxadUlya3QzaTBqcFVnZDRzMmZa?=
 =?utf-8?B?MC9sdjF5bUN6TFBNaXQzRUpVOFUzcmxLZ0wyMkRKTXFOak5ISWtNYTNqRTRX?=
 =?utf-8?B?SXBzL0k4cHZCbURJN1pPUGlQalJRc1Arakg3dU1vbSttemt6L0pyaVlzR3ZO?=
 =?utf-8?B?elZtKzkzNy9sZU9jK3d5NFZzaHNWQVJjcXVpMjZBL3ZRRnc2MkYvT1pmK2xs?=
 =?utf-8?B?K2E0T3VhRXUrdzROSWR0N2RLemg3QjJ3ZGhaWTc5OFV4UEdYZ2lGUmltc1N6?=
 =?utf-8?B?c29NZkRiZG5HSVRna0FSR01GSTRSc3dZVk9EYXkvREd4K1k2ajI0Y243d2p1?=
 =?utf-8?B?bWVETXdBNGU0cHhXWDNJbGxNRDV6UmhUeElvQ3kxZmNHSi9WQzFIWVEwVEV1?=
 =?utf-8?B?TSs4MlRaeW42NStoZDNETC9RTU5VaXgxQnZIOGFtaEhOTmdpNmYzd0NrZ1Nt?=
 =?utf-8?B?N2l1Y1VXMjZJUWl4N0lZSXBsZ2FMM2VuUFNFakJ5dU1zaEl2SXJJdDRBc1NY?=
 =?utf-8?B?N1JkNHJyM0NQRWN1N24xYXVsL3lINTJMMzVJNVhSd1d0cGxMWjJIQXZyUlRC?=
 =?utf-8?B?WEh5SmhBcmYxZHNRYWxWZTBXSTZ1QkFzMmRSOHNoclFZRkVGYlFjczRxWFVi?=
 =?utf-8?B?S1YwV0xLeHVrdnJMbmNMUHBGRHpjNy9VY3pEZTdXN09QNWxMRW10ejE1S0di?=
 =?utf-8?B?QWlaNjl5NER3WUtwU2Ryb3JEODk4dDZ5QjlrNGYybVZvS3kzODJQUnRtMGR5?=
 =?utf-8?B?WTZydVpHMzZVbmxicFRjZTFGcG9jbnNYd2UvU0JVeTZPcGZ1UHlVQm41SUxj?=
 =?utf-8?B?MFVlYTRpRG9WVFg3WnN1NHAwOXRjV3hiQzhKN0IycDFvTmVXdWZ4My84R25X?=
 =?utf-8?B?SGxQMm5zREFldlY1dk5HcmxhbC8zTnMwSzRTQk9HSDU4QmJkTk9WdC9JNlY2?=
 =?utf-8?B?ZW5tWHhNUGIxV2M3bUFuSE1lUGpUTEZDZXM0WkdiN25aYU5YdmZGK2hGYkN6?=
 =?utf-8?B?TVRaM3VpaTN4b2Nob29maWxsSFJlRkEyTEJQZ2tGeWhTN3hEWFQwVXJHbHMw?=
 =?utf-8?B?VlhSRkpPdWZmUmlweEhUTWFob1k4d1poSjhWZXJoNXNGK1FOaUZHRjVydENo?=
 =?utf-8?Q?yEKZ9ebhGeao8eXWHcbvR+Gg2?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rIF/J7qWfzIz/tQmq1D7KTd582tulw/+C4tAk85Y40ZD1bK9dl9NSpOl2epYXygm1mj15SlCirAHiGTdwefHrmIsxi3eu7n0aLv8dPDiGtAprRWUZUmw/fQG0rK4rtKJ5svKWGPdegc8A/EEllPOqDHdQSyOsUBqzwNOR8Gkz0zC0qkVd1fsFFofGj3wY6MynG5+VVJzEUetDLvdayR1AQxbfWkPoeFHCkKDepPyyD6Dh7ZNRqgodk5FnA+n5Z3HIfreClzhxf9Qq8egAmyeKVtGUOtTimewc9uBgNSL57looSEUZudU+hRbsKLuh1YkSR5RdZ5de/sfo7aKFWqq+rJQdhfzb54EGB0iq5mkosZCu9jvdoMtkfQZ0JN7t/0Hp6UIj1ipRL6UzBmnrvYGrzYvsW853vB/GsZShuZzCH8QKu0aLsOao85mS6k/zfMsKSNm+L0NiryNTzlnGQLfTsgaRMaXBDXx5ukRU2X0zddlVR+6JUAlFEz5E8R6LXuKm//OwL+lT4MA8Ynr/0URR9g5kWBsbAJygMV9DkvGv2A4uOK/94/4ToWymVcPAdszNAxInoiCTpgf2yonuMs6nC3+i0V0FmsDay90trruNos=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e9b7e6f-6a1f-4c1b-78ef-08dd887dda74
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6040.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2025 07:00:27.6200
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EF4Y4FEoawIJh0hVwuk3aklm0So9yMebMTpKI8KBRpYlgDmoOfoPP6P4gowF4J9k/mvbkYqv2lNHUXWKwkbwgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7287
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-01_02,2025-04-24_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2504070000
 definitions=main-2505010051
X-Proofpoint-ORIG-GUID: iYLHCXjUgp7Tgaxr1N6kfqbm-LpDJpuX
X-Proofpoint-GUID: iYLHCXjUgp7Tgaxr1N6kfqbm-LpDJpuX
X-Authority-Analysis: v=2.4 cv=Hd0UTjE8 c=1 sm=1 tr=0 ts=68131c11 b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=CSnNaLoam6terLhnIKsA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13129
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTAxMDA1MSBTYWx0ZWRfX7Rcz6uJ8WVII NCmWqMliPqMLgpOcB7/GPglb0WtT6bK+Z9VMXSzvWQBzMBljvuW/glh51EqsvyOnNBII+hdx3fd AR5zQLQhkWNduFzM5REPOUiuyhyT7psNfnoC4XmmihPnhJj2mIgNMgoWNyk9z6XW4JegquhTxJl
 HU6Xd4TdyCf/4u1ACV8A5xtKKToYc/HR2yrJ32iJe3NETQLMGaqmD4aEdjfjDe+fJemA+IP7lDw ZdJN6hnIHV/A3x6xMgfc2mbp3JU4CRSVAJ9JgJhTcAlhZLHOs7XJGQ6iPcK1UJGaGDgSBgBMkhk pti7J6xX+oTXDOlZhsA/h2uo2JBjpzTmKOEarH90loMVuqDvwse3Tkl71G2vP4HY+mcEYjCFhls
 w45vyOAjoxP71huArgNDIKftKl0r34frWtT3tiLIv9WdTMjB2e/hvFvt7jP+bW+gDwyXbqIK

This patch addresses a scenario observed in production where disk links
go down. After a system reboot, depending on which disk becomes available
first, the IMSM RAID array may either fully assemble or come up with
missing disks.

Below is an example of the production case simulating disk link failures
and subsequent system reboot.

(note: "echo "1" | sudo tee /sys/class/scsi_device/x:x:x:x/device/delete"
is used here to fail/unplug/disconnect disks)

Raid Configuration: IMSM Raid1 with two disks

- When sda is unplugged first, then sdb, and after reboot sdb is
reconnected first followed by sda, the container (/dev/md127) and
subarrays (/dev/md125, /dev/md126) correctly assemble and become active.
- However, when sda is reconnected first, then sdb, the subarrays fail to
fully reconstruct — sda remains missing from the assembled subarrays,
due to stale metadata.

Above behaviors are influenced by udev event handling:

- When a disk disconnects, the rule ACTION=="remove", ENV{ID_PATH}=="?*",
RUN+="/usr/sbin/mdadm -If $devnode --path $env{ID_PATH}" is triggered to
inform mdadm of the removal.
- When a disk reconnects (i.e., ACTION!="remove"), the rule
IMPORT{program}="/usr/sbin/mdadm --incremental --export $devnode
--offroot $env{DEVLINKS}" is triggered to incrementally assemble the
RAID arrays.

During array assembling, the array may not be fully assembled due to
disks with stale metadata.

This patch adds a udev-triggered script that detects this failure
and brings the missing disks back to the array. Basically, it
inspects the RAID configuration in /usr/sbin/mdadm --detail --scan --export,
identifies disks that belong to a container array but are missing from
their corresponding member (sub)arrays, and restores them by performing
a hot remove-and-re-add cycle.

The patch improves resilience by ensuring consistent array reconstruction
regardless of disk detection order. This aligns system behavior with
expected RAID redundancy and reduces risk of unnecessary manual recovery
steps after reboots in degraded hardware environments.

Signed-off-by: Richard Li <tianqi.li@oracle.com>
---
 imsm_rescue.sh              | 148 ++++++++++++++++++++++++++++++++++++
 udev-md-raid-assembly.rules |   3 +
 2 files changed, 151 insertions(+)
 create mode 100644 imsm_rescue.sh

diff --git a/imsm_rescue.sh b/imsm_rescue.sh
new file mode 100644
index 00000000..7dcb0773
--- /dev/null
+++ b/imsm_rescue.sh
@@ -0,0 +1,148 @@
+#!/bin/sh
+# Check IMSM Raid array health and bring up failed/missing disk members
+
+mdadm_output=$(/usr/sbin/mdadm --detail --scan --export)
+export MDADM_INFO="$mdadm_output"
+
+lines=$(echo "$MDADM_INFO" | grep '^MD_')
+
+arrays=()
+array_indexes=()
+index=0
+current=()
+
+# Parse mdadm_output into arrays
+while IFS= read -r line; do
+    if [[ $line == MD_LEVEL=* ]]; then
+        if [[ ${#current[@]} -gt 0 ]]; then
+            arrays[index]="${current[*]}"
+            array_indexes+=($index)
+            current=()
+            index=$((index + 1))
+        fi
+    fi
+    current+=("$line")
+done <<< "$lines"
+
+if [[ ${#current[@]} -gt 0 ]]; then
+    arrays[index]="${current[*]}"
+    array_indexes+=($index)
+fi
+
+# Parse containers and map them to disks
+container_names=()
+container_disks=()
+
+for i in "${array_indexes[@]}"; do
+    IFS=' ' read -r -a props <<< "${arrays[$i]}"
+
+    level=""
+    devname=""
+    disks=""
+
+    for entry in "${props[@]}"; do
+        key="${entry%%=*}"
+        val="${entry#*=}"
+
+        case "$key" in
+            MD_LEVEL) level="$val" ;;
+            MD_DEVNAME) devname="$val" ;;
+            MD_DEVICE_dev*_DEV) disks+=" $val" ;;
+        esac
+    done
+
+    if [[ "$level" == "container" && -n "$devname" ]]; then
+        container_names+=("$devname")
+        container_disks+=("${disks# }")
+    fi
+done
+
+# Check and find missing disks of each container and their subarrays
+containers_with_missing_disks_in_subarray=()
+missing_disks_list=()
+
+for i in "${array_indexes[@]}"; do
+    IFS=' ' read -r -a props <<< "${arrays[$i]}"
+
+    level=""
+    container_path=""
+    devname=""
+    devices=""
+    present=()
+
+    for entry in "${props[@]}"; do
+        key="${entry%%=*}"
+        val="${entry#*=}"
+
+        case "$key" in
+            MD_LEVEL) level="$val" ;;
+            MD_DEVNAME) devname="$val" ;;
+            MD_DEVICES) devices="$val" ;;
+            MD_CONTAINER) container_path="$val" ;;
+            MD_DEVICE_dev*_DEV) present+=("$val") ;;
+        esac
+    done
+
+    if [[ "$level" == "container" || -z "$devices" ]]; then
+        continue
+    fi
+
+    present_count="${#present[@]}"
+    if (( present_count < devices )); then
+        container_name=$(basename "$container_path")
+        # if MD_CONTAINER is empty, then it's a regular raid
+        if [[ -z "$container_name" ]]; then
+            continue
+        fi
+
+        container_real=$(realpath "$container_path")
+
+        if [[ -z "$container_real" ]]; then
+            continue
+        fi
+        
+        # Find disks in container
+        container_idx=-1
+        for j in "${!container_names[@]}"; do
+            if [[ "${container_names[$j]}" == "$container_name" ]]; then
+                container_idx=$j
+                break
+            fi
+        done
+
+        if (( container_idx >= 0 )); then
+            container_disk_line="${container_disks[$container_idx]}"
+            container_missing=()
+
+            for dev in $container_disk_line; do
+                found=false
+                for pd in "${present[@]}"; do
+                    [[ "$pd" == "$dev" ]] && found=true && break
+                done
+                $found || container_missing+=("$dev")
+            done
+
+            if (( ${#container_missing[@]} > 0 )); then
+                containers_with_missing_disks_in_subarray+=("$container_real")
+                missing_disks_list+=("${container_missing[*]}")
+            fi
+        fi
+    fi
+done
+
+# Perform a hot remove-and-re-add cycle to bring missing disks back
+for idx in "${!containers_with_missing_disks_in_subarray[@]}"; do
+    container="${containers_with_missing_disks_in_subarray[$idx]}"
+    missing_disks="${missing_disks_list[$idx]}"
+
+    for dev in $missing_disks; do
+        id_path=$(udevadm info --query=property --name="$dev" | grep '^ID_PATH=' | cut -d= -f2)
+
+        if [[ -z "$id_path" ]]; then
+            continue
+        fi
+
+        /usr/sbin/mdadm -If "$dev" --path "$id_path"
+        /usr/sbin/mdadm --add --run --export "$container" "$dev"
+    done
+done
diff --git a/udev-md-raid-assembly.rules b/udev-md-raid-assembly.rules
index 4cd2c6f4..fc210437 100644
--- a/udev-md-raid-assembly.rules
+++ b/udev-md-raid-assembly.rules
@@ -41,6 +41,9 @@ ACTION=="change", KERNEL!="dm-*|md*", GOTO="md_inc_end"
 ACTION!="remove", IMPORT{program}="BINDIR/mdadm --incremental --export $devnode --offroot $env{DEVLINKS}"
 ACTION!="remove", ENV{MD_STARTED}=="*unsafe*", ENV{MD_FOREIGN}=="no", ENV{SYSTEMD_WANTS}+="mdadm-last-resort@$env{MD_DEVICE}.timer"
 
+# do a health check and try to bring up missing disk members
+ACTION=="add", RUN+="./imsm_rescue.sh"
+
 ACTION=="remove", ENV{ID_PATH}=="?*", RUN+="BINDIR/mdadm -If $devnode --path $env{ID_PATH}"
 ACTION=="remove", ENV{ID_PATH}!="?*", RUN+="BINDIR/mdadm -If $devnode"
 
-- 
2.43.5

