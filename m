Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249CF198E76;
	Thu, 19 Sep 2024 09:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726737829; cv=fail; b=QYlLZ0VL5rkUx3SVGleaUCJ3YSA+a+XQ9aST/hVD4T4P/TgEb2GUhs3pM9f2Rg6Jj/+t9LJ/m747ZUC/oPPY8COPFKi6pQ3cxZv0iJPIOcvLRwXIe6Urg4K8gb++SKyV7WSL5M0EDpIApFcy7Ax6q5aUuMrgSoDNVe3w/1VFJCw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726737829; c=relaxed/simple;
	bh=y1KPiuAJszFrqOybDp325+Uo5QDXMvWJTI/XFPmUZ20=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=SWi0OjLvPj+oxNAvv37BQD22u2+OvaiwTtAUclpSO3w+4gW1FVVU4GQzNwQrOkitJF6BJBaRhtMu7SFQmHWLKA9Wx3B8SFlL6JHitbVTdTq7IaWJjURZn0YgsGVg8pgwMwyptAOmEwrBOBXjBUcyCTJbI6NP/BfFJs5ZsyA6iD4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WM7+V6KD; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=at+fvVfT; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WM7+V6KD";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="at+fvVfT"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48J7tZSF001207;
	Thu, 19 Sep 2024 09:23:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:content-transfer-encoding
	:content-type:mime-version; s=corp-2023-11-20; bh=lDa17fQ2OgCMHz
	g/7czJc9dgK0Y2rfQtysrd9cuID7Q=; b=WM7+V6KDD+3HIynHH2VBJBJnFU/Qwo
	4P5U352bRTbMmcmL732V1M/8Lw1JllQ1E29JoufU/qD3J9y6oqf3cGnqvm0mWcYc
	DVu8IwTyaMR6BWmfSBp8z3yIBOSnjBueuGNfaMiCAIijdpyyl9eEZjjU0imYhIGZ
	m2yx6fR8H32Qik0zBL2D3XVyuzmMaciPIRqOe+rddJIQMqjnmsJMQcFwpXh0ItZT
	kLJG6KgVgtPlQwsyZNIOm01tFAWz3mM97JGXpTmkNjjBTh04w7zwdm6JU5ov2kAX
	Op/QQbWouhHDW0yZsIaIxDussg0ECMUKggUhpdtEu62nd8SXWlDjg1Nw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41n3rk3cyp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Sep 2024 09:23:43 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48J7sScq017842;
	Thu, 19 Sep 2024 09:23:42 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41nyd08c6s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Sep 2024 09:23:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xH3jBjI8yMNMJyqTeFNzXLw87M3Xg7ASKs+oADMVBCmbaaZVNlbIMUMRgNbOmn2pUsXsFonj57zkMuo+ctunGIF6CUPsgFIfheUqFFNWkPXwtFmMorUrONSMT2k2xFMuX4E2zprUht7Zoo0OmtJHPLnKfLaep15gNEkDhWdy015qD4Mvj/6ec+hTJ3n/ELXQp3JfDwa08lfCU7RkKADLHa01upBMiHntwU7+LuwI1vOJv7rYVJkNrqt7RFYn+OVeQoL7eMRQNVi9FkFY0ljk+m10V8E8ymSuElb0jcFOp27805K5ql3Wb3Mx5elyQ8RmCgYqhbc/qkrseKfV+5lkcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lDa17fQ2OgCMHzg/7czJc9dgK0Y2rfQtysrd9cuID7Q=;
 b=WK8zuoa8ZlNVwhMrOXGq0fQ1jwBzeshlavuLYdgYMZHsZk1nVS0h08p+Dof7crjf+UZ0mba3k0b3Gi5B39I+YVaL9VoyUnz1SA3vnV4L7Jkmv1nvdi4zeNK6VkeNYhxkGuWy/8L7P6A6rZdkRDP6gWx5YcdG8Pb52/RN4OvIow5MuAVhmxZNgsc5c9PmkYEZiV0RV1m52gE41nnlMbtwOij8XzCHR1qWpHPReqjF7B0Y17XVbPqn81pp4tcmRukVMF/D9ezvGqqe8LaYD5TIQo39Z7WkaWHsUr9wXWNQtrJaTGG3iA5FAxXvBD79acRXYL4TREL8h72g5PBbwlNhYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lDa17fQ2OgCMHzg/7czJc9dgK0Y2rfQtysrd9cuID7Q=;
 b=at+fvVfTW4vJzyuwTCe6BE02EL9GjLdnTj0ouoSvhYM5j87f9pic51mkeYY6EzYdafNGaK7QSebFP6gLciXVpyvAUX+swuSvtMhyju5RuTKx+1Mwl8rz1awqNMLsfPfDlVl8mDT4ggj9Y9/ZchffeYO/ffCUcGOArtVesZ+/Efs=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by IA0PR10MB7602.namprd10.prod.outlook.com (2603:10b6:208:488::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.15; Thu, 19 Sep
 2024 09:23:40 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%3]) with mapi id 15.20.8005.006; Thu, 19 Sep 2024
 09:23:40 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, hch@lst.de
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, martin.petersen@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH RFC 0/6] bio_split() error handling rework
Date: Thu, 19 Sep 2024 09:22:56 +0000
Message-Id: <20240919092302.3094725-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0346.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:d::22) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|IA0PR10MB7602:EE_
X-MS-Office365-Filtering-Correlation-Id: 1004f7ef-44f5-4f08-a1cd-08dcd88cbf80
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OzJv2wasiWnH6axjzJ6njsXeQpVi0HHYnI+wWEbU0Thr/9NFqqHFd6Z22aPs?=
 =?us-ascii?Q?qIOAuzmxMq/YWHSe/0JN2NS/v0f6z57YD4Z4cEHgZ0OI40Q3FCMg5a94jEcM?=
 =?us-ascii?Q?BQ+p8gsDl/GFSCcUQW2Q6mLLnhMZ9/bDWEAQMGjXmlQY2eKrEpCqB4oONw/5?=
 =?us-ascii?Q?/7h6sOmbJcPA7tLHu7oGxJsKYWDYwutMJcUG+UuiA1g79zp0GQBL3DLhgCZr?=
 =?us-ascii?Q?NJT0ZA6ZPPMXZ7CqxEKkxH9L9jxH2/JuqyIDdT+MVrCSJ1QPZyFPAywtV/zk?=
 =?us-ascii?Q?Dee3+MLXodh8jPeCOz+C/Yg0ulX3iloQA6bNWg4OjXxLJA6BBy42J9PREO6D?=
 =?us-ascii?Q?iiJbJHqQDjHaA7DTJuebD/dPEJG3LaKP5ZoqjP9/o/gcoZV6P4OmJnVM8+yy?=
 =?us-ascii?Q?hyaaBpFFdC2WWBF5pGxW9e8AH7bDNHDur7qRl9XOxD7vGPP4TrOzQxrp0DzH?=
 =?us-ascii?Q?penys+MNxCXtDR88/yYUCiu7fPrv4qtQzkCChIIJ0B4qm8KMpYhnvzMp/r05?=
 =?us-ascii?Q?gXrKCc8rSI6eiezGeXmCQ+MzUC59ZzusY0QaDTFX7glzsgDEMaIQbqlmjiZO?=
 =?us-ascii?Q?P0ogvaSYnTmTwV6DDnNmhHYUpgC11t0YbrufhQJN8lkyuzEdjTuR4KtUKDuT?=
 =?us-ascii?Q?ZpjA1Ijf2j30goHx7vWGxRdLZgwoWlwVYBdhwoxIoOp1oS+P30200V3kdWdi?=
 =?us-ascii?Q?f+xtefU/1ToOdFznDwVRP2iSTxx4AaZyFeH3qzZ8XbmMBxz9ltl6PpOAGcnx?=
 =?us-ascii?Q?zjVzmZakz+sRLuCmi0ZE12uebCMUzlJdDoPKUfRWuCasQtYVhhLis6rkeddS?=
 =?us-ascii?Q?2lI4oA2DvK6zqKx+q8m7DzU5b/KDrB9Yj9gpVreX70+jelkELflMKlFTdMCZ?=
 =?us-ascii?Q?JvJGdKqd8m6KNUIIBa4wZ7W2xMmKLpsLFjRDwtB9biZzEdCCBuAXrlxeF80l?=
 =?us-ascii?Q?Ut0af6g34p3SOeY4pTifMQ6WRNYPFz5onTwz5vt8IZj8ppu6OF2qla0Pun7C?=
 =?us-ascii?Q?iN0Lv4U1iQesL0Kxd2SI3Tu+nj7dDArewIWAtB3bjMzTpPJPpU+gf1EgRFHX?=
 =?us-ascii?Q?eAjSUGmnS1g8RArKR4gPGvImvUXoeVOG8cIKCMiH71Wil7b1V9Vt2SEofBa2?=
 =?us-ascii?Q?ht57FAjXOHBIygHDXxBYA5lGoJHyz31Cj5D20HBgSRtgPjyxr/QQpQjk2q/j?=
 =?us-ascii?Q?6DXlpzKHdcSTg+3VgUhqH7OtEkevZiLaE0bt8f2VJe8HqcABnMqvtI2HEsf1?=
 =?us-ascii?Q?T8wVyu0axBSMIY6lOxmtvRPlONBSw0MIJWgqLigmpMJH61EuAg6/LLtSTNI0?=
 =?us-ascii?Q?/5SlLX+E/xB63hbREprkxCZgMFK8rFl4TZNWGyJZAAUECw9h226jcfZ3NYGt?=
 =?us-ascii?Q?3qPSzkY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Bva+PP/h6MO7O8QarTBNZF1P5lZsAfkd5+PMrE8iXWq9ucumJbIwYoVvZRPB?=
 =?us-ascii?Q?6YTnAxmGgmd5SN/L2CvRa8AVH7gPxLOqhwpHjkvijLicrO1LQTDoXcXqbcZD?=
 =?us-ascii?Q?nlIP27CBJlEAPImRbwtWu5zDhxAX0WooQBPXubyJwqbAaGguDffsKXH34/8h?=
 =?us-ascii?Q?J/0zkdfBlp6/dPTp+9U/sOu2nPtSOmtMTPIIl5+6s6WXUVQwBn3Zc9nQM4Mi?=
 =?us-ascii?Q?9n5Dj/1D1kgXVjSl+il6IelGhzwEg3eZne2AEKLeh2mpQ0i1WfmxpBx5M7Yj?=
 =?us-ascii?Q?UB8nytN4KiNMgnnZjTOIjIeP+Wzz6plbfoBnKEyYG4lEn7/OR5/GLkgaZKC2?=
 =?us-ascii?Q?m+BGVNBeHfFtz9nBWjLnZeR22iXx5L3sdp0uoGdWMxqPmP/lGDHPtfIHtsCO?=
 =?us-ascii?Q?2W9JJBPCguI/v95ALipR7Y1UWHg4x+0UT8bDBQkM56jBEnG0DbDzMuqevqSL?=
 =?us-ascii?Q?/IHbUo0DNZcl9WWXIGMfGM1p5rLpbgawMv2FVSAbOcfmZDuJxrLaVFux6BzV?=
 =?us-ascii?Q?CVcfo0xJDUJCtahCDogIRnNeXU+H4ES8dedon9++WYceI4TEzYu5uPBaYx7k?=
 =?us-ascii?Q?g/VkcdM3TbRTgWyFWjDd1c7wx6LrPJuG5wXmtkoKFog0YeYUjQcgEevZKC5B?=
 =?us-ascii?Q?MPkL33SOG5MEhgk9/D9Sh5kCp1U8W5HwBAZs7xyQlMHJvoywmjl4pwgafvux?=
 =?us-ascii?Q?I4DwbY8LvJxIafHCvodexQAPzcGFT5+BX834sZBn1T8iYZ2qNtPGlopdJ5y1?=
 =?us-ascii?Q?W1BdCZXmLAGaIXhLIsCoXFfz24w0bt4IegUf+3RtIpfznIyrwfzAClq6SkGp?=
 =?us-ascii?Q?iPGtgjcTD1ioiDGnPbn+dogJiBimPCc1wR7PppuZbybxj8yBu6IGQvgepY2U?=
 =?us-ascii?Q?/mv2NTYrucgpU0GIEzHJPJphFko7vKqw1LF6Wl3KRKC9OJlN3vMD+6bwhSIu?=
 =?us-ascii?Q?OJ3I7guB6b7rdItQrX83v7nmE8m1C2HXykyarSx3BNLkbFSsur0FBA+Bkt0G?=
 =?us-ascii?Q?BV/TWmg6WCLeWzJDMBrbbKeWa7Au0GpOlrXts0IRejYmAUZqtbKTL8jntsq5?=
 =?us-ascii?Q?omjBaZMBdgklEzLWG7R8PQfIg5neApRjwCq9aLfwscQpK7SF/WXZXtmEIaDX?=
 =?us-ascii?Q?SYaVKKCapw0pitM+qH6+QkiCkpmXrna3b8HHGKadXvIiwWtXyRyc7GCd3O1Y?=
 =?us-ascii?Q?srY+s9tJtVFOeLL93puWIl89xcU6hE9CPlCvIzcLIUk2u7G0QhOh63UVfbuW?=
 =?us-ascii?Q?L2fyrFmHBzC70Hy7EK+B2W+H8gYgNSez9L8znyK0/xEHUTFR7r5o1BOUhSKH?=
 =?us-ascii?Q?a5L6gseLz+E1ZJ/27E9jHAbEbNu9LfsFRAjKX2gbr3pUWbnVQBmVBV5fDBdv?=
 =?us-ascii?Q?w4P7T7NyYLG31yW47a2ta85qC/N7ZGwLqcPNNnGbdlICc7n+xupuCBptnIsd?=
 =?us-ascii?Q?YoQHMSLO7BPdLVzD5Tul1bXVTECqZvp6uLEaPniv4vltyX/WcyvyzxfoaEke?=
 =?us-ascii?Q?H2YR/7JGWSKUR7K3fmjH/S3FGXdg4Py0VtToZChzGt3u7mZpor3oTnT9iXGQ?=
 =?us-ascii?Q?mUvQ687VHvfX1YI59udDaVZxPxGheHE+xY5rYHhmQ+MvfAZyA6E0iF3GZWjg?=
 =?us-ascii?Q?dA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	AJbeRYd3jmswGqoUqwxNZxic3WqgwVAIM+K/LomMnwdUgkdm+6TNWekdCCq2mjLdAmL8tb0lMs1YcSLholTNYPgFJ5d6rWCHwlzCumYhQo/8h8fRz7pbbVFiNZ/H1SgonBCzzz/NWcPwL0vgWa+XbZBuZ2IhsK0h1+pHyNXehyXpxtMjwbdLVXcqclZZMxfztc0ps923pSXMk0Wp51bPQcZbbqCRUGmRhcUiIRQF4NVBrnRKGXFRrlWU/bwUURI/ocex4uwKRDTMpdgm6ZBYSbK3zjevLYePXcOP+N+ZPkvLdNDoKBiidIpEMc3D0Mcj6YcY8ROqozMIMm83veIDcxIIG4zZSwo8h1yzR7AtuB/STtBj6ckKjoZrfCYKTzALErJAt47f0jfrryhS+3RUtHnlAW/a9GXHYj/1i4oFz/tHvS5TMVAHtdmVSsiP7qi23GNkdFvljKmrOJOyff0ETikrrI+kbedW6fqIBM0S57HX9e1/HqPHMesQA1q362MuYHIfw9JTcvnRRxgE+JwQriA+KzgR4EpDn6OpIgdIufEl+HYa1dWfiShymf2y5pZngcG8JibN24B7wm57K7i66O8zmijTqbn8ugYoBweipaw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1004f7ef-44f5-4f08-a1cd-08dcd88cbf80
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2024 09:23:40.1913
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K0862JS8u6Ngi39npmCBd4wzBrlDIpaJkadLeoDq+XU1yKH54zhFGG2bFkZFkeuOb+djKcRNwnBn+rY2e4bZOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7602
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-19_05,2024-09-18_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 spamscore=0 mlxscore=0 phishscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409190059
X-Proofpoint-ORIG-GUID: gBI0ehWVtZsMT-bW79eXWINwir2HqzZX
X-Proofpoint-GUID: gBI0ehWVtZsMT-bW79eXWINwir2HqzZX

bio_split() error handling could be improved as follows:
- Instead of returning NULL for an error - which is vague - return a
  PTR_ERR, which may hint what went wrong.
- Remove BUG_ON() calls - which are generally not preferred - and instead
  WARN and pass an error code back to the caller. Many callers of
  bio_split() don't check the return code. As such, for an error we would
  be getting a crash still from an invalid pointer dereference.

Most bio_split() callers don't check the return value. However, it could
be argued the bio_split() calls should not fail. So far I have just
fixed up the md RAID code to handle these errors, as that is my interest
now.

Sending as an RFC as unsure if this is the right direction.

The motivator for this series was initial md RAID atomic write support in
https://lore.kernel.org/linux-block/21f19b4b-4b83-4ca2-a93b-0a433741fd26@oracle.com/

There I wanted to ensure that we don't split an atomic write bio, and it
made more sense to handle this in bio_split() (instead of the bio_split()
caller).

John Garry (6):
  block: Rework bio_split() return value
  block: Error an attempt to split an atomic write in bio_split()
  block: Handle bio_split() errors in bio_submit_split()
  md/raid0: Handle bio_split() errors
  md/raid1: Handle bio_split() errors
  md/raid10: Handle bio_split() errors

 block/bio.c                 | 14 ++++++++++----
 block/blk-crypto-fallback.c |  2 +-
 block/blk-merge.c           |  5 +++++
 drivers/md/raid0.c          | 10 ++++++++++
 drivers/md/raid1.c          |  8 ++++++++
 drivers/md/raid10.c         | 18 ++++++++++++++++++
 6 files changed, 52 insertions(+), 5 deletions(-)

-- 
2.31.1

