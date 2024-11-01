Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C351A4F19;
	Fri,  1 Nov 2024 14:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730472423; cv=fail; b=Ji2FhQcqXMSicmxkNQrnCKtI7PjUWDrDiXsSVn5mTZF2rPmIBeKAyXlMLTP99+274v2ZBHgeXTqwtYv09k5ZEevIKBZToOgk40UutQXz27EgXMs20eYPcGMsJV9AOnTJdAdMbjpuZ3qs/Sj3F71Lns2Noj1yM9yGScc8tarPmUg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730472423; c=relaxed/simple;
	bh=6rqAlZNfFZu3qwtF93jqtwZGNc8LOauF1Mcd4wzRASg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DTH4Jupq77bf4P5TN0Sd/ifvSyC8/alx3UCdMVE7ugLthlb2MzkvtyyVxtrXopcp0EvYU30W92Kmy2WMgdDmQbIJznwSyrBZGq+HU1o23MB6HRrXLpnqlk/MggNHCILLiOsdmHjjvZZj6KASCC+Ke+cMAdZxFfXPf1T1KzT492M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IvN5mnb8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=crkZWXZZ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IvN5mnb8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="crkZWXZZ"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A1Eik6s026630;
	Fri, 1 Nov 2024 14:46:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=hfR7HLmV4EHvDbqfmGBzg3KCs7rXKTa/060jOjb6rAE=; b=
	IvN5mnb8WchJAlt6ARfRmnM3DeUk4C1jxdSoj1J+G+/bw2M0iBqQCDOqybV8v+gx
	9bJQ1gR5dAqJ4frjo7Go3j6r+S21ow9wuI1ouL3Wz+2Nv+AywypJqLxBHIQzqrfB
	7FlWSt/V/yvQfFomouzo3DkrX5WEb2+bxxMZhSbc90Yun8oEIKAC077JqY56p6w4
	BJdVCQRwHqorOV5S4mBNByzM0FiX6Jk3lbhxzDg+gAPoGxTGruVI21dHXr2MCUqf
	UZQ6xMlTZyxRyzMF8r+13bTdBOShfbCQObNkUGy/Xviq+PM5lc2/KBFhOtRVjl+1
	D/aC7ECrVOZdWfWz9vG33A==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42grc94drn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 01 Nov 2024 14:46:43 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A1E15f4040458;
	Fri, 1 Nov 2024 14:46:42 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42hnat0pgm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 01 Nov 2024 14:46:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qYPsjLzIqAfWOlJRffgo60fznLynxosf2YtVj+yCo8kYwx+F9B+2tOyPoxV3QIfXTGhWYLGA4WYwCmPwUG88qlTKPHzIo2ekNzgcBae8XCY2VlkXve2JUC9hGdiRQgDp2rMVlqMui9eBKjHqz2M7uITpaxDspHWc6rivp43FghYHJpsei2DQLWpy1oXPyDB7+651TiQ4IpDD60AXRvBRjvOFF9d2OOnWm5aUSSIkK0VxjB8Vcklhj3IR02EXZamWOFjw7lcxFaoHe4UETxCNaWn6tXXk4UB7u+z05sY89iuTqsROUwNbeMt2p/VtAE5HQ4dELpeFs6hIJnDDsg91eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hfR7HLmV4EHvDbqfmGBzg3KCs7rXKTa/060jOjb6rAE=;
 b=KaloYh0ex2PTI4NmbmKc1vDOHks5VIY83nZFontSrXU1nGOlL14kbewwO0hm17sRC45POjgy1sr6TBy9SwcgT49R0V8mRzjyMxVtZjrt95e2uM8cN/86nb97GO2k2fnULCMrYQpPbd1R2Dnq+5hSbqFupI39sttESl8fU9DC5NjyilKnOWs15bSLpKfFJjT1b0Dhm5YN68JmmzYDm5qJ3ODdphwfTCmH/qnAVIOrjPkrWgoSBE5Qpx9R9LefvexKbAs+4zeYzxtAd7N82oyrYlUn+I2GAcQG2ka6KBrM7LujqNvzrh3tytTOoJNQDleJml3gLcd4e/JrOlXs2KkYPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hfR7HLmV4EHvDbqfmGBzg3KCs7rXKTa/060jOjb6rAE=;
 b=crkZWXZZIODXfMhC4F68OR9IQN/HChmp/Cb0UKKeMD/P4fxLx61oWMJEovHJXh2fabRnaciHNaKCmAtyK/3XJsxEY/kANg4fiBDC2wmw13n8VX7k8ca0OTobgZOgXj9Rtq95ad7EYUmRDZsMywZcbWy24Oq/xPeMEr9P/5xFHNY=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CYYPR10MB7651.namprd10.prod.outlook.com (2603:10b6:930:bc::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.32; Fri, 1 Nov
 2024 14:46:35 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8114.015; Fri, 1 Nov 2024
 14:46:35 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, hch@lst.de
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, martin.petersen@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 1/5] block: Add extra checks in blk_validate_atomic_write_limits()
Date: Fri,  1 Nov 2024 14:46:12 +0000
Message-Id: <20241101144616.497602-2-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20241101144616.497602-1-john.g.garry@oracle.com>
References: <20241101144616.497602-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0408.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:f::36) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CYYPR10MB7651:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a490841-3956-40db-06ce-08dcfa83fc12
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?f5XfmNcRp1uyZ+qDmfz7YF99sUSwX1z3zefZ5SM5d8dAJs2pnMJkKqAWsJ/1?=
 =?us-ascii?Q?aneae2kaYgIazatIf/a5Fz1DYXlPtycwtwWTzv500iCZF1uqCkOb6Z3C7CXB?=
 =?us-ascii?Q?5AcdZCFUK3h2WhQyyPxelnzzv0QwZJcMFeKfDb/PtIQyzajBlQ92APgvvp4J?=
 =?us-ascii?Q?ssc8Yr24gg39zCNGoGwITtrQWmBlbTPfjys8pJeOAXd4j0qc/xcp9emJYKLT?=
 =?us-ascii?Q?X2fsIvX6RgKPSr5YY7/QKmLvS+x7iWt/us+A8f4z/krohVN0zOYG+F0RUrSS?=
 =?us-ascii?Q?0tIwQzziHnyXbr9fOHkGLJ1EORfGewZL1gcf5Ha81aDciDc4b5oGcFDq2mpg?=
 =?us-ascii?Q?DoaZKAvwDTbIOl12sKd4PPPJUOSJegbeXPOuplNk0alphC/6tlEWgc5HvoXT?=
 =?us-ascii?Q?xSQBjtmOQ071Rb2zyUrpp3u3ia+X2qEqUmCAT4zX1Cnmq3uX/1PUz3AgFGdw?=
 =?us-ascii?Q?VQivxjeSjUdJERFJ0dcU9KUmsVwc++HfB6UOkn4bExex2r8Z+/LMj2H+Bj8z?=
 =?us-ascii?Q?ndq9VAb0NlrgfoWSCK0GXeAyFT25elVnLxU6e4KCmu3wtz3QV9kTJ7zzLaoy?=
 =?us-ascii?Q?kdRD3SA0OVIAjK3P5NTfnt+bUVy0AFNgW1YN1pyivdQy+VexRbmuH7ZR3gX2?=
 =?us-ascii?Q?F0XE2n3f0VS+DhTYtQJvNR5Jr5gRVmzyU2GElVEfDIzzUuV8D78QKYeU6WtX?=
 =?us-ascii?Q?+raJDiqA7ed2s1mjQ/HEYpfeQuaE+xX3RvhpwklPOvCA/mGooYT8VU8ZQZLz?=
 =?us-ascii?Q?FQApln2XRXJHjUVYGyvBP3I/Mh1yVHItb3LGyawE2mBCXNwA346PWynsW7L7?=
 =?us-ascii?Q?Hv3dtpVxoosfImdewIdbp5R1lv2furcsJYpFTgc9IH6pk+VJTTYPig/CctgL?=
 =?us-ascii?Q?JlrTSU6CoOb9QbzPVPcFqYgb37dxtVnYwXJKH/5qy5tEaQLZync//Yk6kjHV?=
 =?us-ascii?Q?T9aOHIyZ/CsBKk4DwriDopErScfR7uACceVlD/e8EgH8ri0hOQ4Aguj15jg2?=
 =?us-ascii?Q?0SYr9/x5ooXZxmQ4l5rYElMl/hUoGJLlIT54mtyuxIfHQK0rbMDZS2l2mbTu?=
 =?us-ascii?Q?HVrivl7Z5ui6+VmMCii67BLWwQ4D3jkitmPtQ3fW0FlzCIS6jnspc6pzPqaq?=
 =?us-ascii?Q?0nPuz78jEysqPdawByOJlONY/L2N8oDk1/dYhDwoQ1se/YYGp0bKrpGgj6xp?=
 =?us-ascii?Q?+8T3kqCntEZDcA6gsMHDk+zi4H53SpTwHvmHYnhgbPRAiy6n/5yqpsCGGzlQ?=
 =?us-ascii?Q?yW3/pKTZfNwMzuWCNn64olpOlYwTuBOqiBh7DXhLhkvGp3Jhpp2TAcj1x1VL?=
 =?us-ascii?Q?kjy8I6uH+SBJD95Q1iqz3BZA?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?O48zQzI6aUf9i41WIeh2oH62IBguvUmReGwdeHv3LnQAq+KlkvJksNplgjur?=
 =?us-ascii?Q?G88DHXL4Es0Rvjym7Lm4kVlVm/w0XjJAuk4S+MFEN70ir0GQsMetsw21JF99?=
 =?us-ascii?Q?/OuQoux5AEsAO/Q1xTEwbqOnDwu5vXkpmAkccYuZC+cFs1yS/XLsraLtod1i?=
 =?us-ascii?Q?bgHIhBaPO9OImN5RrW/qXNrv3AL+33lpeYgvQYBd2HrD1eblqBAqVXnp+WLc?=
 =?us-ascii?Q?grCnHYK3fv/Zev3L0SCUUMsk/CjZz/XMNcXjY9NhRxTeEi0fcYcIS2aj2qx9?=
 =?us-ascii?Q?ADnLeA1+uwwb7qOVTGkX04QHaLvoJPhQz27ZLaRPQTKchO5TgDMzqTaAGqhz?=
 =?us-ascii?Q?6IhgZS5Y7uXL+0fvfFqEC5Iz/j3oDmKGCuL0l6k0XNy7FsJmRfay4aw29OFy?=
 =?us-ascii?Q?4waRiHpgWWVEgUaWHx/yY7nObtGIL6eOCQTn1vRYSw8alOU2BpZAXGbc/r7j?=
 =?us-ascii?Q?WP+9t5A/PMWVoCF6BbMMxMy1cNFjHWByWsqUboJ+BY1lbORP//i0fkVAbedf?=
 =?us-ascii?Q?1IO6dm+uozqRY5kp8RIO6ECYczoKEoHQwT1wNzejGKBB/tubXNavPLYk2fmV?=
 =?us-ascii?Q?FmE2Edp/128vKF0DDjbZlLrZJZ6xsgeh/D2klB07NsX8GFBfQZiUG5O27fKi?=
 =?us-ascii?Q?e7UgDFo6Mf8NMPKyBV78f/Ggfbv3l0FXkJM9ASg/KXsioA8PykFfW4MAmN2s?=
 =?us-ascii?Q?KG1WUp70hBkUqkZfECpLDhjzT0BhskMll4yQRqpudSGSO/6+B/YzCaQ8ajS+?=
 =?us-ascii?Q?zL0puha21vG3xQISfusAqprNrkxTVF8Sm5xd+IWwavfbrKujVPnrG7/NxU3A?=
 =?us-ascii?Q?P5EggGb1BlhudzRgc5DjB2Eks8ksfsW7LCcHrrL1oPYUkNc4CAXLkXmGMzNM?=
 =?us-ascii?Q?Ozom7s+A0cHJytkNJ/osP5rSIpU/4WgyqwjqICtaCZ/4YcU431Fa+y3oZXJR?=
 =?us-ascii?Q?eFCgl7RbY0sdpSNqIzhYDYCvrg84N6KSPeHBws6refK9UF+seBtHT13EY3If?=
 =?us-ascii?Q?7S1ZjgAT/LckG6L8wWKgRyf4NZJZL77XgcOt8vyz5nh15YJBsxgVgZ8oE8to?=
 =?us-ascii?Q?pRG6eC91be6KUpUV40PVIpC5WUuP4qCVcIS9LHYD4GVv5OzUK/CmzaafnDlu?=
 =?us-ascii?Q?MUF2AyKmieMpa7MBsC4kJtFz1BkHBCkSWujOzsyLBYKnbCG0kCT31pifvxu2?=
 =?us-ascii?Q?vijclqanQTPYb63YpLvHUzhmanFsNV6hfrnYJbG1FnORK9RLU/ofh+OnNUrP?=
 =?us-ascii?Q?WNZxhckVSNMgcRgOuDrP5BNriRD0JQL+JoyClUJRJSdeEpOHr6JslbS8D5Aj?=
 =?us-ascii?Q?s8DYQKXOilephJh5JLd4i5p+oQpuyBvtYNboAISBHCgmoVVPxd1UnKK1mian?=
 =?us-ascii?Q?ul7r1Ymqsrunq5xVxl1R/cGSDObI0iDFMGGTIPryS/Mf4IWgakA/NSG3txU0?=
 =?us-ascii?Q?lLYMO5zSj1rtYxivOLoZ9GkT6c0ghmGK1kyn1P02hL5Df7HC8ruBKYXTRBLr?=
 =?us-ascii?Q?egl93xC/xUkVC98Zm8YAz/niO0eBY9Aw4I6yr4upqHEBOLsMo0E2aZG7y/ht?=
 =?us-ascii?Q?TsCjNmV5KPn2T39xCtCIdpnrZ8eCzRT/1vPCriDPx/hTZKgp1Fq5f4QsPsaS?=
 =?us-ascii?Q?7w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	CZjfOXxm4zRpkgs1r6GN81RydOgLcTdpwMqSCQZOo0NQvYqUwMulOUMa1OFmEufGm8wzAkS5ZRtO7K9RxRF12K3ippgfF7JDxxJHvvMPC4tyHi7xsjUVIerhNlfihBrvj+k9xv8929Pj7JLU5m9VXhcK5FQFQMVzY12ey8PZYuKWt8OWBb3AJ1oaJ7fQUeIZSdUBd3k2jTp6bWntR4aYHAR7Zr/zmf/aZF3pvUjqnIehit40i97Pu6JEQUMuSLZgPWDec4g1tzZxrCpU8AxuYjOALY4cHqbnPWu/Cbk8PPtnHlc8dekKZ4nc0IJyGq2/t0cKV8xJHpVY8OLIBPSOCMGMlN/PJ1mOnvTYhifezVQ7MiDB0hCNfLczNSpU74ABW0cNbobo0Qg87BCofCSrUca7o4DPIIqqqqPKU4aU2RsIm7BDSrJy9OVeu1yvI2KTZtv0DbTKo5jABGLQzXP1ipNK63gGY5AZWveI4bgzGKJH444jBMyKA5axL/CCNWtV/kNSSEwRc5T+MNvUfKu+IihRVE4duHqjDcYodZlO6gLB5TVXN2xJX/Us93aSWPhMmzesBcCImUnOQmWCcj7hRr+0VRUObtlChV4DemZX1+A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a490841-3956-40db-06ce-08dcfa83fc12
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2024 14:46:35.8540
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LYK1RAPV5MpFV5s+DIeR5iRGqJwbE9GIr/Z8dh+Ur5AHVowWEvWbnfh3SlW/XeCO8AyB+MoX1XKYgKm6iDWGdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR10MB7651
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-01_09,2024-11-01_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411010106
X-Proofpoint-GUID: CjkoruEekzmrQQxG6pqju2gmlT36X24M
X-Proofpoint-ORIG-GUID: CjkoruEekzmrQQxG6pqju2gmlT36X24M

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
index 95fc39d09872..c5a753f980bf 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -179,9 +179,26 @@ static void blk_validate_atomic_write_limits(struct queue_limits *lim)
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

