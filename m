Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6F21CD1FA;
	Tue, 12 Nov 2024 12:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731415419; cv=fail; b=Snvnp1Np9V4CMIgaNT+ZM9tEoKfg5AnGn/G1Uu3b9dh0eIVW+nc5+VVqqHdaCzjkS2+/HqznDGe5qtNlqiBBtre6Z2igF/NKLwCaBK7RPQTIdqvm2kQsezUfeoTkFmJ8DNh+GemS4KIwaDih9RXXb2hrIIL2FtjSbEIfj/2Dqb8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731415419; c=relaxed/simple;
	bh=pFzPiDhwgEb9Vm7aPcsLlta5qHsG3OBQRFG6wEuZ0a8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NbwvzE5tPJddU8JbgMBTLc6IKk7I6vCaGzlP5K1LN4pi6gBsClJuffZifAuAuBhCsm+gEEFDREHErM9Zz/lVmX5UKt5f6GPgiNmfpIcgYj5MhNrDNxvWF/tsYUCjZoa47hUuASOz1yihfZ73+xVtzBQ+ZVd/vfvytxpaOPlTEfE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=M+AbVPhj; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ppEhARDs; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="M+AbVPhj";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ppEhARDs"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4ACCfjfV028740;
	Tue, 12 Nov 2024 12:43:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=G91Cv8J+yFqaKfxp43iRVW+0cERpGYd7+gOfd8Zelg8=; b=
	M+AbVPhj2NhhqTD2XcS2+DIN3hqPDniO8X7DSFxPZxx16/tZ1Ke+Uq5oNf0yw7NR
	Egc988Snk7HGXnlPhUf5C556IeZc2m+fdM04UtaYtBM0BGICa/6uMUbDOU4rG6JB
	ZclEfMQGEBYqIhHa/PIqUhvMOjMRBOCv+fP4zIfA38Q4NBrTKj+7lxpmrR3FTJKc
	BW+gCGDihYpGHzYqmzXGcTpSep5FWxsrRdpUpRNAa02DX3vapvjm1w7UOYG8auQZ
	U2MYzvBqUTN/J5eAiN3LPuWv1lwGnQYkbV3qeeP9PdzBCP6Iu/EUP5yGhOhOuMLh
	1HyH97pewWF98384X6tarw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0n4v7uc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Nov 2024 12:43:10 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4ACCUS3G036106;
	Tue, 12 Nov 2024 12:43:09 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2047.outbound.protection.outlook.com [104.47.56.47])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42sx67u7r0-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Nov 2024 12:43:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UQgkJ8xrVOWSPVUAl1iMA3v8WaHTWySmG2bx38qOJvSXnlIbPQ6NbHD4v2n7io6p0Ui6H3ZGx19g3IZhuypX8SfvMb4sgQDATJP1znSLdcj2r/Lj9IZkRGIQBcoRkOxGs8r1maBRl2natjmezF4VGuTiFSIsCLgp06JdZBggxghVKXVh2YEGqcHZynlBOZsEr1THe22yWv7gqxnFJDGc9NRxqPFYuu59eMKNJYE36Kr2BFPnrdU/BvhNSJP4xYjzVYb90PWTjHNzt6/ZHUcCsKF9aKaMxRfAu9NA73D3CHVE0ZqOqM02qmXnHLtL4isLkLvYlX/lIMQCVqQlfmdwng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G91Cv8J+yFqaKfxp43iRVW+0cERpGYd7+gOfd8Zelg8=;
 b=gHn7Gw20NhNNxhuQYBwwsDLbHqbbsMkS0xns3cnd1PhqbVnL0RbA+OqwjAPGAqNcd6u8F5ot6sgK4Gx9lB8nIT+buGnznW5Ku07+x5OFfU7pyFhX1KvWSDj0BtNKetlJxJ+cGNBDpyTfS/ovCDXRvzPiSN1C2GyCxhID6TaYDzs5FskxPJdXfPm7/yyG4jrY/mBaV1GXrqyGEbYRvcVdUnnKvdoT0KqQKCYxfX15TlcBQQOPcGM4J1/a5UBScJYkLlSH6A3pepwrpqUAx9Xg6rE4jprWfqpNpaMa9/Q++TDxir6R+vJDR12V4lmesaqW5GxDOYVyrz7vqkXXa49n1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G91Cv8J+yFqaKfxp43iRVW+0cERpGYd7+gOfd8Zelg8=;
 b=ppEhARDspIXF0WxoBlZeWJwNiVQIsoTaDBLCMsiGBFOsMPewVRVlHWpO8rRt3yQAugisYuY6tHvT8odhscn0chH/vG/pgQaixVTazgExUTMofBPS0IGsnuTQM+7GM2FYl9V0tqUbGsTkbp73VgubdL3f6KSbGs6rpqOLCycQYMk=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SA2PR10MB4809.namprd10.prod.outlook.com (2603:10b6:806:113::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.29; Tue, 12 Nov
 2024 12:43:08 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8137.027; Tue, 12 Nov 2024
 12:43:08 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, hch@lst.de
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, martin.petersen@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v4 1/5] block: Add extra checks in blk_validate_atomic_write_limits()
Date: Tue, 12 Nov 2024 12:42:52 +0000
Message-Id: <20241112124256.4106435-2-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20241112124256.4106435-1-john.g.garry@oracle.com>
References: <20241112124256.4106435-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0140.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::25) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SA2PR10MB4809:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d5da35f-63eb-4148-2e6b-08dd03178f48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?V6Kf/1r/WtHjSsQKN1gvxi/AKaV4n09oErzyy+ro9R478yGSziNeKLKLpwIb?=
 =?us-ascii?Q?Ks8KkuA55QslZnh8b9o+zSec6eCO8mcwBdLdEiFsBUzz6r1y8q+5mEvLk+vA?=
 =?us-ascii?Q?AanDkqrwGeBVaa9tFMa5+9dw1opzisz8FM/+b3Nncq/CSk+cyNnupF7a6f5s?=
 =?us-ascii?Q?FpVpHx00bBSsBY2dTuk1pPzK4AETKeXBVz0ZL6tArvoeBX01uIt/7w8FXZnX?=
 =?us-ascii?Q?CYtbsR36BeJAL+gui2vdUG/cImcng/5+rDLPR1LQp+4hLqJ55/U3Bk6YuP9E?=
 =?us-ascii?Q?tXH20pXoeCKesojMy8GYKrzSRWS4ESWagQ2Po9LbJ/3iVCBwofLuy/hIuUgs?=
 =?us-ascii?Q?sLui/GiVeQJt75vTwQA9YZVZTqnybLqcLVgPrKXfw2O2PLb83cq3xFUiYspw?=
 =?us-ascii?Q?rV7mCzz4wewyAwChR5ExMgU1+iB420lYyip5nYkEPHUJDkxIYJRKWycjg2oh?=
 =?us-ascii?Q?Y8N9B4jrXO864mQFhbFyrmkWz5GxbGE2BQkf7yQwgSUAoWoLHEAOKpM7dcRn?=
 =?us-ascii?Q?9HRv+euRJptSEcFCEMdVbqskNI1JNErD31Gv2hnPB2mvyAQVXy/oui5Msi99?=
 =?us-ascii?Q?JzH8LejYl2hYMaBdd3ehhKdqJxWBbyZnC3QuKt+0debXTB/Iu/CylEc/PW9T?=
 =?us-ascii?Q?oeXCqUCbOCb6c/OkrReUJDZg3W7s9Y7Lr1bPFMMPsyRAytkO4UX6Htf53uaz?=
 =?us-ascii?Q?XR8jEtL1iyEBtw4RyG+nHLhbnO09H7mZIT/Mfu74unEOLePBkry92tfXLEd1?=
 =?us-ascii?Q?5danPzQq58iJZJX3k6jIZ8zxu22MpCdySML4QMnaoSIwhg6+YPMYi8Awq1eR?=
 =?us-ascii?Q?Up+Z/vyv6ChQKC9Te0f4MyX31hkMJM098uA0BGSrdryULV61/h7hkrONiZG+?=
 =?us-ascii?Q?d9ThhiaKS1oU2n7DQNW2MTEbWLj4Eae0n12c3VhiQs/IWF4lUH2oHkPN/836?=
 =?us-ascii?Q?QeeyEIKIL6ETM3LS98skMDBkvLdWoR+JznydHzHk/2NVTI3C4vQjFT/23ich?=
 =?us-ascii?Q?9qDANspPWMCfy4aYw8p9rJnZW10gzY/sAFANkWQuT7eqw8UGrGFQb0wRRse2?=
 =?us-ascii?Q?l1KJLJzyPlY6V4xC7CPKZmVd0dVh/1BY+zVaV2LVI/FkX1lzmD+aYheAflsh?=
 =?us-ascii?Q?KN72XQbDH26hAX2QWBDKCq2EvD/niuefeInTQ+cu4MGuR6D/9GeZAZqVLuRE?=
 =?us-ascii?Q?OzNoFAgx24OAdWO0X69Zb3Akl91YihokienTADErGqxsltULczIx2gZjB6Q8?=
 =?us-ascii?Q?6CupnLszu0vl62awolnYn3ik6YMZXgfcIuex29EY5t5irruwqsod9tkQpRnX?=
 =?us-ascii?Q?VW/sUCChKfmWHug6vZGoOeds?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Qlmx+1OwrThA+tJRMDjb+LAMIhNuZjMm0z6XxyyJqXrIzTYApAl/rlBg49QY?=
 =?us-ascii?Q?HqTr15ZEfwsU+ZQL98bS6DYiehVFSm2TSZ3blWNe05BupjZYmgwDm3xVs6Mt?=
 =?us-ascii?Q?d4SxrzhF/pqg7ZuDvwJeduEJWMsF5FqROZ4EDJsZkZWCXScONrHu+lG2h/MN?=
 =?us-ascii?Q?ZQlxQfSHTNCUzVtxX5NHWJs0CN/EA1HgnBcZ6JIQqargCajlurMgz9tFLSQw?=
 =?us-ascii?Q?NVBZLnCU8JGpXOYi6tJnIAnKqpUTSbqeKq0WThUt55N/MLvL9btuX9nP5LAF?=
 =?us-ascii?Q?RV7w3B3LZa8GqZBZuStNEjDI0ndHq9L9f5gkmE0NUgjsD6JMxmcPed+7Hp+9?=
 =?us-ascii?Q?8kojvlnELoHAhn0wRkYLAUCDRSaTJ0TtVxHJTIPLnI2c+DZZUV323yX4XvWR?=
 =?us-ascii?Q?LwxnA89UDDw8ceF26VlbaEfiDLla1KSnIbmDq3bEEpQIM02qkBWZy65QTrEL?=
 =?us-ascii?Q?YTEo0C1hIpJS2v+oCzcb4i3bl7w4hUHwyL2TfGS41QeMNW/7A3SFaRNvJbuC?=
 =?us-ascii?Q?eVouUXHBPj5qJeOrK5SVVAU3ixfGuqVc7OQlQGxYADnzxW8kLCKITHmm2feM?=
 =?us-ascii?Q?WK1N7WKogPGplFwQJASv4nzG5+aMsZ0rfVo3uDUnjXv1rmxCxSxekl+UH8yH?=
 =?us-ascii?Q?d4Ev4Ws/B8SZCSL7cQaYTSd/86W58s3kxWx8zdXJw+Qp9iEyu+OV9Yrrd++/?=
 =?us-ascii?Q?7WYCdouNS9bKkkpZnRQqqe+RPJH/ytFC8g4ja8gAwRGw6D/tKAB6LS2zT6KG?=
 =?us-ascii?Q?MRFeq0NM8dGuiL/RlpnoeqoR/IBour2yNOGgDjHRvftPdmnlZOmg/HtQoRoa?=
 =?us-ascii?Q?OT9P08a9MBC8QL61NXHJvxH4U6fYSdHJ2CwzZ1mzETal5k/8SiGlCBRxIKWU?=
 =?us-ascii?Q?jw6SDNyOv17T6gwwzYzDT49TAkSkKege1A25ruYb3HKaKKC1a9qJjhpuWmM6?=
 =?us-ascii?Q?UPz4hMEYnlC+NS/R5qvLfHY3HAsYyhK0Ctp8tjC9W0VKqr6tDAwDh3NW5pIt?=
 =?us-ascii?Q?wuYCbgBt4wzNIfL68Up+uwQzgPuVEuEOlP4DDMOQL7liL/rnp+wYmhycXa0U?=
 =?us-ascii?Q?fwpEWwEVB3s9lpJmlAF+04GRViSboSJQhP/JmuqgKAG2Svw8FCIyDBwilK4b?=
 =?us-ascii?Q?uFzF/mqjAklOicP9XSEm57xW/GlECj35TeTsS9xQxp2v1sV5U4N1lc5jqEbR?=
 =?us-ascii?Q?RHejrF8ZuGPKxNkyrZb6fCt1d3RNS8Adqpow0i/FzrYcmT92/Q7K0j7zhKSu?=
 =?us-ascii?Q?Kgh4fB7+jzjZkJkHBrvW18lyEovX9ekO3YOXGno58hT8cFVIxVhzbax7CLrX?=
 =?us-ascii?Q?XFzd5Lp/xmyvhyraX+bLrVkx2/fnjQEMWEi893qGzGIUbVheUFDMmZl3L+L1?=
 =?us-ascii?Q?X/oR//3NHNQhYK29HDC4cXpI76jcABB2uPynHoTkcmshUCxb78J663uhFA6g?=
 =?us-ascii?Q?RTg1ICKv0MoAUg4tqffcODnmpJWyRvGm72Fxwnd9wvyVNEFoCdtOSIBAMKCL?=
 =?us-ascii?Q?I2aX/l0jIrK3okXrOj6+UgZ8MyXz/TWPwDW3+OajfFEd7l6BTebaK6WgBXhJ?=
 =?us-ascii?Q?tyy35E3+k7m08k/jAuC/5XNfEDU4LI0hGJ+lvJt2Mbx9yEE7JUHKyVlQmomi?=
 =?us-ascii?Q?lw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	SMPnE8eaP+1Q0anI1hkKNJn2W+Dv/NQAsYPD6HOb5Fl1zZ49AJgFZ7WjDuvNcpFB9G4FfgppIWKCH6w0R1zm+4AEHQApEr+FPkWSexdPArGp4VFl8ZkXVEUMbnR0mpP8sKpODQSn6kVzNQiIdf4rdl38l8nbuSz2Q2M9BN72yBlCiDDVvoIclU3Q0iCo/Lrb5AZP9Foh+Cm6jS1aXvMLP5XQRGmYMTowjNHPmhnz+MQTov+eQ9wlStoQ2H2l5epz3QcMR+ZURo0vWBYSBERmJe0mxCtQp8GSh/Z7i3Z9pUtkXyiCLqm7R6NJKioOSnUfZ6cyZkFHJwnYeup9z+MX2kXruV6+sZLJP7OoQk5RxhDYCWfdEWQYYxM0hi9+nEhE0TCzT6n/8W+Jl0jEAL9rDcU0jlKfalD237YjOCPNYJYGQClKtpPzqQoB1be7Na/ab+3CUOnJJxc8CQ9pSnFGaNmURSmLkfvv0KrsusXehk5W3j2Wgz4qEM5RO+UvWnH3ptowczJCD8FfEOLwYin1mDJXe4w+NUI26e6h4OfL8lFnl9UyFtYnaRyp4pTCWO7EDfOAqMwCdjyLHwnZpCShirhYjVhgQyVmRQQ4Xdiuz5M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d5da35f-63eb-4148-2e6b-08dd03178f48
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2024 12:43:08.0980
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hhPJocLvxRANfiqKh98mKczf/U8C0tKYQAKxpjC3G8hz6IlcN4YW5Ue+udoV7peFvHwCv004zRLIaUgBfEt14A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4809
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-12_05,2024-11-08_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 suspectscore=0 phishscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411120102
X-Proofpoint-ORIG-GUID: Wjncz085CjqEPKF6vHXsuVD0cE_RaGfX
X-Proofpoint-GUID: Wjncz085CjqEPKF6vHXsuVD0cE_RaGfX

It is so far expected that the limits passed are valid.

In future atomic writes will be supported for stacked block devices, and
calculating the limits there will be complicated, so add extra sanity
checks to ensure that the values are always valid.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 block/blk-settings.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 7d6b296997c2..44e1148986b3 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -178,9 +178,26 @@ static void blk_validate_atomic_write_limits(struct queue_limits *lim)
 	if (!lim->atomic_write_hw_max)
 		goto unsupported;
 
+	if (WARN_ON_ONCE(!is_power_of_2(lim->atomic_write_hw_unit_min)))
+		goto unsupported;
+
+	if (WARN_ON_ONCE(!is_power_of_2(lim->atomic_write_hw_unit_max)))
+		goto unsupported;
+
+	if (WARN_ON_ONCE(lim->atomic_write_hw_unit_min >
+			 lim->atomic_write_hw_unit_max))
+		goto unsupported;
+
+	if (WARN_ON_ONCE(lim->atomic_write_hw_unit_max >
+			 lim->atomic_write_hw_max))
+		goto unsupported;
+
 	boundary_sectors = lim->atomic_write_hw_boundary >> SECTOR_SHIFT;
 
 	if (boundary_sectors) {
+		if (WARN_ON_ONCE(lim->atomic_write_hw_max >
+				 lim->atomic_write_hw_boundary))
+			goto unsupported;
 		/*
 		 * A feature of boundary support is that it disallows bios to
 		 * be merged which would result in a merged request which
-- 
2.31.1

