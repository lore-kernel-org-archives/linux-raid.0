Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E912B2F2;
	Mon, 18 Nov 2024 10:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731927051; cv=fail; b=iqUfjM+HfwbnHKQGIQfTcQNj2v6h2sW/9X9l2Us693QePWWjF5PNzPh6/5+y0AnNspM/xezDT6+tfd3t2oq+Fy7G+2NuezcqeqN0Mj9JuEsGv5ARh0AuoWXmYyfPtLBHzug4YUUJgNVCGMBHf6fNNBD2jk8j42qdk/XUupspdqg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731927051; c=relaxed/simple;
	bh=f2ZqqeXBXBGTM9CGaIoBX1OhX0kz5YQhekx1Zonx1kc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=c21HI8wHTRcAkep80HPW2cXf2bCeb+kkI+3jWJ135UJ9bYdVxmikENJNSPtINk0/mEuVQYoveAAhxhDeaCSZgqq4EaT5CrdTLbvfOFVnZdvt7WxExwB+IUTjgRZ1LCgZ9PpiyY7+5kfh8trlxoaJafEoXJ+pmffkAXtHEtaBnVo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=EIdt3ZvQ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=XhlO/9UW; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EIdt3ZvQ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="XhlO/9UW"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AI8QX8T029728;
	Mon, 18 Nov 2024 10:50:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=pweaZNMe/5ZhhebwxA3K3X0/q+Ydlk9QOV6YOECUxBs=; b=
	EIdt3ZvQsoV/OYrBL2KDXzKclOGsb8mSca1ZwwAXsJwyV+4KNFEXkEKyFswIYCXR
	Jtnj+wzuByyVuA+sAXOr7SXOIJKmRw8PHDhQU012xDqyt69Lf3J6tPOEgbKt/eXz
	HUzd53YHUaypZd0xrGu+x7qY2Z8Me8N6GRLO1U+sXJwCW6SW31cKeeU7rSq1BN8n
	frS6z6IPc9t9CmxgrZhwjBBaXRY5D/7hzYQah6eJj26RLxDDRIyQoJUVu6+YQCN1
	q93CLsK7ZAf7Y6QK5xDFrxkgLJotb06BA7ZipcDFfwgGc8P4HfYwg2DQtiAiR1E5
	6zJto5AwtB30NHhu0i88jw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42xkxstabc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 18 Nov 2024 10:50:38 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4AIAmrbF036497;
	Mon, 18 Nov 2024 10:50:37 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2044.outbound.protection.outlook.com [104.47.73.44])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42xhu6xtsw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 18 Nov 2024 10:50:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dzeixHsLe780TD2mkWktfU638FbD721fxK2462e0bHsbVOp0GO/KPe9ORYiwt1omhfYA7k0OO0lb2D+MuRdqv9T4o7QoPvsXrUH2wn8HdtggnYJxbtSyO7LObd3HzuZ67Go28YIDNs/qPu6PeBbceDwlOZGh/E8xC7oZjTkScP/0X8PupKot+8FquahYyrqEe7JXoFB8bpWN/fZGafa0xN3VwtKA+iSrRd85cLjwt6E49uOrr3e04F2sGEzNUpdEfzIHa+bVtPjdcNNMsED4x4GBfAHHCZAPz1P1wUtO19tcIUxZr77Yl4Dh1R3qvD8+bQuuw5U/+/z88lzVdmfIvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pweaZNMe/5ZhhebwxA3K3X0/q+Ydlk9QOV6YOECUxBs=;
 b=x3bw9cPw2mnuNGyOwUeseuaRoDlrFl8ryh0gMCBpBOelClq5sVF8BWEWk949m1aCU9EQWHhPU6XfzR9Rjqpa6YtRD8R8mTQFiXUdmIJHI7xT4un1xg2Kyp9I5RFO6+UMbMO9ZuB0JD5MyHVQzJ/cmusRHjsXDeiDxBsh0f+/zU6v7eLbsXpNRyDo5gvtBkmJqPcHd0Ded4O64ZNsVOP4WNzGu5brvrqe4+wVkP4FZxjKQ1K7ictoxE+qyfN1IhIw6oRIwLsdCLZkzUlPOqsIWJ/3cKas2HmEJMlXVMeBVjntIo2QlUv6O5/GuKeceMCdgZt22FNr7OcP/fWljFdWwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pweaZNMe/5ZhhebwxA3K3X0/q+Ydlk9QOV6YOECUxBs=;
 b=XhlO/9UWLabevVv0dTDufeE4h8t+AsBfLCu30stT7q5e1np+x2EZWOLhfJvTwbwUU6rPWFyIYqECj5ddaFt2YkcREV8M9i+6NgqEBxWYxbm66q8C55BotcjYxVz+lxQF8nfkRY57ny7RiRzAc9mQg7eHO7LbD8RL77Yy+Rs8Fb0=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH3PR10MB6812.namprd10.prod.outlook.com (2603:10b6:610:14b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.22; Mon, 18 Nov
 2024 10:50:35 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8158.019; Mon, 18 Nov 2024
 10:50:34 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, hch@lst.de
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, martin.petersen@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v5 2/5] block: Support atomic writes limits for stacked devices
Date: Mon, 18 Nov 2024 10:50:15 +0000
Message-Id: <20241118105018.1870052-3-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20241118105018.1870052-1-john.g.garry@oracle.com>
References: <20241118105018.1870052-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0048.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::23) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH3PR10MB6812:EE_
X-MS-Office365-Filtering-Correlation-Id: b854acf0-b705-4d5f-c50a-08dd07bed47f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?y9zCasS2jzONU4mh+zHcX9aOsI/ng46bahn0eQdZNMgvdk5PZMHc5PTkaO5O?=
 =?us-ascii?Q?QcDbTauzHYmHTMNu3iS/J10tyi1W+jLqGVt/s7DgoKSdbQ8noQcX/yJb5Krk?=
 =?us-ascii?Q?dDVcKwUIzLfPvzu4uaLlgmUlwuVrJGsDJ1r3ooshcjekPTsD2/gieXhwQ/x/?=
 =?us-ascii?Q?1ugZR6OFuE6SeqjqlIg2wnk6XrS3r749ocH+PlCS0k73F6wmDD8fL8sALUWe?=
 =?us-ascii?Q?2okOY6klx9qaVBehmUMbjYFT3Y35Iu0kRYQkZyn3k4oSp2IP2TRLphKvdRAG?=
 =?us-ascii?Q?IUoNK1jPT0OctVbC2mFFLEKf07UyKOTH8gdhTDBIOnoaJn7tX/GZHLkK8eTv?=
 =?us-ascii?Q?ptvHCHIP1Ic3vDzle0VrRg8ebwOeJkrYTU6a69gCoX3D+nP9xPx1scyOUkyC?=
 =?us-ascii?Q?W9azhY3eDEk/iK/FO753QQri/3bd/9KfeOEcgFf6ITveAhCXlcRRRwVUGYY5?=
 =?us-ascii?Q?2GgUWTnehhEkMQuMDuadYzKeoEIMYCZu/HgrJBo+tSBBc371iMru+u1Keix0?=
 =?us-ascii?Q?gta2S0qyDL//xjUG8gbV9zZZ5qETfuWI/8OmmQhPm7+VVTEAyTqjHvRhTmRg?=
 =?us-ascii?Q?+jzTR7BR9531iwkwWbdBlgirtufcT7/IoC1HhAr5kg/QwTa0GGgeQBMHfuKd?=
 =?us-ascii?Q?zqwMcFg/3UdOeUZZ0ocksT83jg8hBeX9zdsOsG4HjhT/1U2hXiP5xS0EVrgW?=
 =?us-ascii?Q?UCMH5/oDEUCXwcpGiMalB1gAvEtP/zME1AtQC2N2xxgLN3vaL3KXHJF0Im0C?=
 =?us-ascii?Q?jQteHklJB3kr2UZ+rEOjWLvMTbRgfqh/dXI+0KcA9xRlcjYen68qv6mZmI5H?=
 =?us-ascii?Q?RqbWWrOS48xleSIIPxkbRhZVmnfbiXNCTQ/NPqAMGaCkM5SpmDl5MuUL1hhA?=
 =?us-ascii?Q?vQgePaZg7VCI4DlJ+TAlI86vIJPT4iIBCDiO1RoPMaLkG0pzLWrFwsXRLnsr?=
 =?us-ascii?Q?J/xnpnqrnxkv+Zp+SpRROKCSaIc942NtDvLEjpAMBAaqH7zL9PtoqNSd6rSK?=
 =?us-ascii?Q?CRgu1qjGAqp0ugPpOabuwghz8MnJ0UwvRx96agyOABTl+BFAh64eYc9iRu1p?=
 =?us-ascii?Q?3rWbH24PveDTApUo0wwFBdfA6v4xKb/vtUhUniZBThFkeqybv4aHWmRJwex+?=
 =?us-ascii?Q?83CTye45Rz/LLlMyfJ20zmtB4oLGx0ZUW0jLyC68xUur6uKKYDGF9psI6Jc3?=
 =?us-ascii?Q?+P3mnHu8v/TgDWogFpxfSET/rovzlgi02GAxgXlBswh8heBXkV6yq3Su3VHG?=
 =?us-ascii?Q?ij8fb/cMFNRPjiEw2s//yfezJ1jmf2t0eEzdRJ58yIRVfjxwaiHH9cr6NO8b?=
 =?us-ascii?Q?M8TKVX1mBN5UsV8XBzv+7W13?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ob5vPel1H1kS/pnof+9t4Y79X+X85LLLMpOE8Cww63+rAeeRLz44xvh3k1f+?=
 =?us-ascii?Q?Q+QivK57aOwkaSBK88HcYtY0FLImzjuleBujXzMYYf/3RKad4XbI5Yin1pZW?=
 =?us-ascii?Q?7si+s8t1upooWqDRhuA831c5kfCI29G/4+83HI4vBF60P+JB1FJDENKlnDu5?=
 =?us-ascii?Q?UDF+0HcLx6Ca+zzvlj26gl40pYVl48bQQb+MjLrVYrThFnGgEiZSsi5H+/by?=
 =?us-ascii?Q?BwlpsmIOd/AtlAapPx6ao4u7cTw3rq/Wn2DAbO76+guYnEtDn0KoMLn4BFch?=
 =?us-ascii?Q?e5UOg7oP3Z9s1gq4q0I1eGd5vCoufIw1lElkHqkvxdxHlIBQO4KKD3f+S4Kl?=
 =?us-ascii?Q?p42sg4Exgu0epjDGYP2uZykRi8Kw83vg2Mx/QwiUmACWnh6yJjjAhfOw1AGm?=
 =?us-ascii?Q?cZZoSLN/1njrpJvWBPw4h0l8ShhooPgIkPv/rwoNMv57mylBiBIzbaWATgO7?=
 =?us-ascii?Q?p/2obHjwgs57LXqjsE/Nl5/0BAom61I3ZO1cYK8MlyqH5SfOL+G3BBPObbvu?=
 =?us-ascii?Q?egVjR0krW+mzzaCERWi4Oj1ugVgbfbzQ4urO9oJkiF6/sEK7DntSm4KfeaLk?=
 =?us-ascii?Q?qWmV97s8/eQk9U96enARqStB/Dmpof/Ky9LmaV6+LhHmfXzlVcYm0lAxmKJO?=
 =?us-ascii?Q?px7XfugkWpzQC9VTe0fhwbYOIlJD3c7lPw4b+X8FbJtLQmBf/hpDUWmR4hRG?=
 =?us-ascii?Q?Jt0kyZQi/Au27MK425LeqI+uF8vyvlcW04B/k0/HAtLcQGF6hmqL7Gw33ySQ?=
 =?us-ascii?Q?iO50ZLam0sZDpjLmp4I2QYcP4eaPoQCWU0aYzjHX3QXzvPCciBPXV1CPfi4O?=
 =?us-ascii?Q?NZjVj3nwh+wB08hGyklifUYe4cIeMxYHhWfxw03LxLce4YHbn1r+Bme4aji+?=
 =?us-ascii?Q?q8//De+LbaRYHVwaQRFS9aS+BZ1blTACll/+lay+OzZLGQ4RJ5pxb22ixE8v?=
 =?us-ascii?Q?3YbQpprR3Rrh7WmKxiIBvvb8V9s8nW4paBBKPDw2BSN9RMrFwVZErIZ1F414?=
 =?us-ascii?Q?K3LaSZiCneTzRmWcgxDhv/ny68t+QW7ppFrJmKwUVdoC2/LzamgjTYwGdjrk?=
 =?us-ascii?Q?F+Pg+XPCZVc152Hf4NVGfnMtlmcuOZYq/KwIaHbgDSObhIWwwzT4CvQTtzUK?=
 =?us-ascii?Q?9dNmR2Fk+vLsapPer/k2cT2Ei4bzY5dVuVCdwoSKs2LxotQRUCM0Wr9wcap+?=
 =?us-ascii?Q?ZlCBrzg3lw3PQkUFDvogsgzpm+WooUm5HnKAF0XSdB5uNHNxTZuxhwmssiFs?=
 =?us-ascii?Q?FwtR8EnbJU9oXRZRHc8sxugDKMDlfntkqIFsVgH6ALBsxNJsYOFSN5DKr3yz?=
 =?us-ascii?Q?rBbP2Sg+L3eMwJYVYion0NOXjfuPD9UxjvMBTigsOTgzuMcLTTuzoZQ+fw3L?=
 =?us-ascii?Q?WoLujmiQ48UUmtxTg4j5BN8X8oJrC0U25WiYakg/DToa24zCZR32b14oR2tD?=
 =?us-ascii?Q?JdFv2WhCyCWAX7PW8wr911FqycbYn4uurrVoeFrjcCVEUgA0c04OklUj6AtJ?=
 =?us-ascii?Q?BVni32oIampD6UGmByvP0LbKqCfKaHWg4uPw8u0sicfCICWOi8EDDrFxtWbV?=
 =?us-ascii?Q?sQzlNyRSrj7H+b/QFJsXyvQmJTJ+jZGM8gPMuEAWdEPWW1VNseE/ckPUFjHb?=
 =?us-ascii?Q?Iw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YPBqIZdGAzEBu7/kHZNUyCai3VilM1SpbKCU7weSWh0l/ozyblfBWYb/aMIYfntpnM/qoxrg+6Zi47QEmB1FBOVAesBwr2YdoavgJQOd+jkDkYucl+7a82kO8Oxtov8TJ0DueBWXrl0bcYLTStnOylL9wU5S/0sue6EMPfMiqZtUW7dfoB4E8VgGav+OD+4XmRr2zLeBD3P3P9fKXpzrfhgjGnNGxnzn6rcFz+zc4hqVdZumsC1rx8Oa+qCMR0Iq9Y4OvEyVEZW3OlDN29fTyZ3HDqcBZwx8QdrHQRhAAOIwrVL7Um5YpxbOf9C7+AJZfSAoZhE6VhQSMlMBD4pPzzQdLFXILsqGscSBMZ7/xnnw0NgZIvt0cq6+wqQpfKg7mEeIlkoYYmS3Hsz1qWKptL7eGcN/lfPpJ4JL15ISpkBJwoOI+7r4oQzkhbhFLnwsbGzcpQkicPHqH55yWKi5bkiWIJSbmc7OMA1KT0ZtFcxJdGi7qbjXU/eEKfJOFGPQbT9PlUKswxtF/1rHPunax2tUilwJ9RlZJNFETslIH+vIMhpAkV7anPYlaHP1gFiwnCpiM1BirxMSUw3bWKh/POS1GXHvG2Xo8HH8qpfHOtE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b854acf0-b705-4d5f-c50a-08dd07bed47f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2024 10:50:34.8602
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B+krvSGliTNodTbBQpLYBlaSZezHuWIEpGtByMvrmrkRXBkiGifHXte+HdsxPQ3pSezZLvLM39ABlRGe2ZWnJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6812
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-18_07,2024-11-14_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 mlxlogscore=999
 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411180089
X-Proofpoint-GUID: 2C0LVAPW8chhQpaRcV0wBuMo1kcQiGHw
X-Proofpoint-ORIG-GUID: 2C0LVAPW8chhQpaRcV0wBuMo1kcQiGHw

Allow stacked devices to support atomic writes by aggregating the minimum
capability of all bottom devices.

Flag BLK_FEAT_ATOMIC_WRITES_STACKED is set for stacked devices which
have been enabled to support atomic writes.

Some things to note on the implementation:
- For simplicity, all bottom devices must have same atomic write boundary
  value (if any)
- The atomic write boundary must be a power-of-2 already, but this
  restriction could be relaxed. Furthermore, it is now required that the
  chunk sectors for a top device must be aligned with this boundary.
- If a bottom device atomic write unit min/max are not aligned with the
  top device chunk sectors, the top device atomic write unit min/max are
  reduced to a value which works for the chunk sectors.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 block/blk-settings.c   | 115 +++++++++++++++++++++++++++++++++++++++++
 include/linux/blkdev.h |   4 ++
 2 files changed, 119 insertions(+)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index cdfebbd5f571..f7368c29424c 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -496,6 +496,119 @@ static unsigned int blk_round_down_sectors(unsigned int sectors, unsigned int lb
 	return sectors;
 }
 
+/* Check if second and later bottom devices are compliant */
+static bool blk_stack_atomic_writes_tail(struct queue_limits *t,
+				struct queue_limits *b)
+{
+	/* We're not going to support different boundary sizes.. yet */
+	if (t->atomic_write_hw_boundary != b->atomic_write_hw_boundary)
+		return false;
+
+	/* Can't support this */
+	if (t->atomic_write_hw_unit_min > b->atomic_write_hw_unit_max)
+		return false;
+
+	/* Or this */
+	if (t->atomic_write_hw_unit_max < b->atomic_write_hw_unit_min)
+		return false;
+
+	t->atomic_write_hw_max = min(t->atomic_write_hw_max,
+				b->atomic_write_hw_max);
+	t->atomic_write_hw_unit_min = max(t->atomic_write_hw_unit_min,
+				b->atomic_write_hw_unit_min);
+	t->atomic_write_hw_unit_max = min(t->atomic_write_hw_unit_max,
+				b->atomic_write_hw_unit_max);
+	return true;
+}
+
+/* Check for valid boundary of first bottom device */
+static bool blk_stack_atomic_writes_boundary_head(struct queue_limits *t,
+				struct queue_limits *b)
+{
+	/*
+	 * Ensure atomic write boundary is aligned with chunk sectors. Stacked
+	 * devices store chunk sectors in t->io_min.
+	 */
+	if (b->atomic_write_hw_boundary > t->io_min &&
+	    b->atomic_write_hw_boundary % t->io_min)
+		return false;
+	if (t->io_min > b->atomic_write_hw_boundary &&
+	    t->io_min % b->atomic_write_hw_boundary)
+		return false;
+
+	t->atomic_write_hw_boundary = b->atomic_write_hw_boundary;
+	return true;
+}
+
+
+/* Check stacking of first bottom device */
+static bool blk_stack_atomic_writes_head(struct queue_limits *t,
+				struct queue_limits *b)
+{
+	if (b->atomic_write_hw_boundary &&
+	    !blk_stack_atomic_writes_boundary_head(t, b))
+		return false;
+
+	if (t->io_min <= SECTOR_SIZE) {
+		/* No chunk sectors, so use bottom device values directly */
+		t->atomic_write_hw_unit_max = b->atomic_write_hw_unit_max;
+		t->atomic_write_hw_unit_min = b->atomic_write_hw_unit_min;
+		t->atomic_write_hw_max = b->atomic_write_hw_max;
+		return true;
+	}
+
+	/*
+	 * Find values for limits which work for chunk size.
+	 * b->atomic_write_hw_unit_{min, max} may not be aligned with chunk
+	 * size (t->io_min), as chunk size is not restricted to a power-of-2.
+	 * So we need to find highest power-of-2 which works for the chunk
+	 * size.
+	 * As an example scenario, we could have b->unit_max = 16K and
+	 * t->io_min = 24K. For this case, reduce t->unit_max to a value
+	 * aligned with both limits, i.e. 8K in this example.
+	 */
+	t->atomic_write_hw_unit_max = b->atomic_write_hw_unit_max;
+	while (t->io_min % t->atomic_write_hw_unit_max)
+		t->atomic_write_hw_unit_max /= 2;
+
+	t->atomic_write_hw_unit_min = min(b->atomic_write_hw_unit_min,
+					  t->atomic_write_hw_unit_max);
+	t->atomic_write_hw_max = min(b->atomic_write_hw_max, t->io_min);
+
+	return true;
+}
+
+static void blk_stack_atomic_writes_limits(struct queue_limits *t,
+				struct queue_limits *b)
+{
+	if (!(t->features & BLK_FEAT_ATOMIC_WRITES_STACKED))
+		goto unsupported;
+
+	if (!b->atomic_write_unit_min)
+		goto unsupported;
+
+	/*
+	 * If atomic_write_hw_max is set, we have already stacked 1x bottom
+	 * device, so check for compliance.
+	 */
+	if (t->atomic_write_hw_max) {
+		if (!blk_stack_atomic_writes_tail(t, b))
+			goto unsupported;
+		return;
+	}
+
+	if (!blk_stack_atomic_writes_head(t, b))
+		goto unsupported;
+	return;
+
+unsupported:
+	t->atomic_write_hw_max = 0;
+	t->atomic_write_hw_unit_max = 0;
+	t->atomic_write_hw_unit_min = 0;
+	t->atomic_write_hw_boundary = 0;
+	t->features &= ~BLK_FEAT_ATOMIC_WRITES_STACKED;
+}
+
 /**
  * blk_stack_limits - adjust queue_limits for stacked devices
  * @t:	the stacking driver limits (top device)
@@ -656,6 +769,8 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 		t->zone_write_granularity = 0;
 		t->max_zone_append_sectors = 0;
 	}
+	blk_stack_atomic_writes_limits(t, b);
+
 	return ret;
 }
 EXPORT_SYMBOL(blk_stack_limits);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index a1fd0ddce5cf..f4587355bd45 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -333,6 +333,10 @@ typedef unsigned int __bitwise blk_features_t;
 #define BLK_FEAT_RAID_PARTIAL_STRIPES_EXPENSIVE \
 	((__force blk_features_t)(1u << 15))
 
+/* stacked device can/does support atomic writes */
+#define BLK_FEAT_ATOMIC_WRITES_STACKED \
+	((__force blk_features_t)(1u << 16))
+
 /*
  * Flags automatically inherited when stacking limits.
  */
-- 
2.31.1

