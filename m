Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DB7712C478;
	Thu, 31 Oct 2024 10:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730368850; cv=fail; b=F6eUCiMkdTBBaSQPQi+6zaM0maW0qb34drJFLKEHqGQxboYL3eDxSaIOBAd0GwyG1ZjEEPhlPBthzFqJD5g5svvm88NW25HPGEP8Ei2pHeBHYTJxm1fI0LzSu6XOscqheifrziEDP8/p45VJImJpjJW56c4bnHTo1KufK4G+lQA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730368850; c=relaxed/simple;
	bh=c8jIdfcSXPK27JqrUv3aGlnqFxwBeuuS2G6M8t/UsZ0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HQIwEpr3q/A/BVVw8t0MRxUXJT777JOSs8D+wILAT+wug5zMsIx1RmnGbBOuWM+dR2fzbrLa0ieMypFJJ8iq0jFnbac0QFfkZxZgopiCbvkUa72C3Hn89GjYwFBInstlWhImao6PRJqP3y14anzhM1nJAElGpB6qdzl/WeZeymg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=flcfALMr; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jAFUDvWW; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="flcfALMr";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jAFUDvWW"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49V8uGSp018312;
	Thu, 31 Oct 2024 09:59:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=ccL7dpCz2tD4y6CvA90jIiAn1II3KkIhe5SH+XRX/Ow=; b=
	flcfALMrhBNhOoorox2WKU+KQLLtN3Kid0PY4rP5CbD98f6G3mIwIEUycWGiY7Iv
	6itW7BVYuaSHXQHC1uTqqbJ0y5C6LmiXEddfWJwMGvxplOj+YFTtf2o5sM95yXnk
	p3RBvFbilMymEnH0tXbQzxgMGN4An8ULtw1LaHz/bWb8l+gjgJJSz2t3w+LqGuY1
	XD9eJUlWPuWcpcWJSWxRbFV2LSFMuru8BJnSs7ZuIb5Phd0gRiUljnYFHT647tjt
	mNf2Hf200RbncIIQm0uG+vebd1ATFbq3bylri5EmtA74smT4P24oLdgEUE8b22Xn
	dOy5Vd9NHZhWQmwaT0cdRQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42grdp9wq7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Oct 2024 09:59:34 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49V81xtP010074;
	Thu, 31 Oct 2024 09:59:33 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2043.outbound.protection.outlook.com [104.47.70.43])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42hn90ct53-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Oct 2024 09:59:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VR8DAp5HS1Fr1szoWuMGv9Fl0h+AU50zfmLs4IOJUOI/WaOE9yEmVEpjFky66AX1Q/Sm6lk5ucGkyPHuK2RfmtlzmNlx8h4WrvpbS8HXICUCug01D8YxyCyglclxuBEgwun6HxYSkdLVWmpSR1wUJOX6f3KHGX6sAN187It+ZCau9/Bnwm1VMvyf5Ct2zTqLWueCLXO3dj5QVu+sLYPn9MaYvkLwdIeIRngkn+gEM3x5de0UFO2PpRkCkRu/M4czfS8lLkl9N75I+uMuV/27li8zA551M9thSEWFqJ3+bCfhzD/LlJKTD1Pp4FZC1fLW/ipotJH6OhAB3+59zzucAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ccL7dpCz2tD4y6CvA90jIiAn1II3KkIhe5SH+XRX/Ow=;
 b=qV3sssRySG2bWXuflOOK1H0l8mga0AME4sffJR45OSr/JAs46VXAZQp8SpEQmEzyCzr9LN1LtEceGpYNj2v1/5QdrZm26Y340Gjl7hOXJW1ZD55TVvetNfypZOBgQkAuRVhDJm6WsrZrQw8GlLt988kkQxIxdKVGrnAKWUByyK8NojFEbPvqWhlmn3IkHv3EKY5fVtPWeXBgfz2bXc2aSpmAKJ9WhyWRJwp+GLvGCU/o5EZm4pKMvcMwqouCXPJynR8ihvK/NhzNvIb7Xe5OTcB2Zk2/krq4GJPvf4BG7N9TFRJ9H716nMykhLYACHvto71U9V0tynk8CAOy3y64Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ccL7dpCz2tD4y6CvA90jIiAn1II3KkIhe5SH+XRX/Ow=;
 b=jAFUDvWW6yXZYIbQoJeOOm/aghPXPmmR+wdJxzPTJct2kEfhr4/usd8Zk+lxK3aQM1vMdV9cEqa5lalbcTZsTqaVnU7DMvb6APDfqWDVIvqiIrWo/8n4yC7giVLtawhXWLj9n/IeVLlSFhawbLqvn+FQN7ShXWKmPyZ+GaC6ipI=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CO1PR10MB4708.namprd10.prod.outlook.com (2603:10b6:303:90::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.22; Thu, 31 Oct
 2024 09:59:29 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8093.027; Thu, 31 Oct 2024
 09:59:29 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, hch@lst.de
Cc: martin.petersen@oracle.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hare@suse.de,
        Johannes.Thumshirn@wdc.com, John Garry <john.g.garry@oracle.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v3 1/6] block: Rework bio_split() return value
Date: Thu, 31 Oct 2024 09:59:13 +0000
Message-Id: <20241031095918.99964-2-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20241031095918.99964-1-john.g.garry@oracle.com>
References: <20241031095918.99964-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN0PR07CA0012.namprd07.prod.outlook.com
 (2603:10b6:408:141::34) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CO1PR10MB4708:EE_
X-MS-Office365-Filtering-Correlation-Id: 898680e4-1ecd-4b34-c622-08dcf992b5ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BS1hwqVLpIRSc540GzgGoBtD7KhzMUI0hmKKv0uvAXFmHW/xp4OMnGEZlkIN?=
 =?us-ascii?Q?3UkeCmAvRUgMlBdJ6yHgVYMWWGBaEdk+Cj3d8xtInwVtEjH8xIA9smEcxaF1?=
 =?us-ascii?Q?VF/DV+57pfxeDNxwcJsnc1+G6rXSW4DJ7/QZw9JLYB7xvvudlwo3wF9/ZlOB?=
 =?us-ascii?Q?L0hhHKLfIniO+j54I07zUJworPKL9usaxvNwLfG5iIU65hXRUvZzk4SG9E84?=
 =?us-ascii?Q?9Cz9/MxP7jQMdWx0VUuf2y33tlloZO8l0WCWn7J9qPajdGFUwSEfWKpQ54IQ?=
 =?us-ascii?Q?lhctvUfSnM7GhywipggiasVwDsoozQ0MIb5V5bZM0hgCeR6sLcHAbS25AA8K?=
 =?us-ascii?Q?Ab2MgpL62l/VhTdFxRrmDYKeBZDU6UTfrY+w7ZTAKKjgsNslzT20A+xMe783?=
 =?us-ascii?Q?Sqo7yctOtBAH+/7zLgtlQaI2yy9FOVJSBTDIaBMhxZwIHDv0hHdi1SwGc4rO?=
 =?us-ascii?Q?tPYIRVCw1UBBSW6+NYjhAhIbwCh6JxDh2bhFzAvSm/8zoiAR3JnAZpdGDlAp?=
 =?us-ascii?Q?hVj1lxmKVBreT7RDHTDFweu7cUpEWEwWyDEeHCzrWOoqt/9mTUlhLDxiy6H8?=
 =?us-ascii?Q?V95+jVhtSSuo4t3C4+L5Wu3auYDngU7PBIyDr2axZ+8n+nQzaWYJD7NUEQjl?=
 =?us-ascii?Q?9JwGwu3ehYmx35s8oHDot0OwmrU91+DftKDpai4U8qcrdAEpcjdnDp7MpPwh?=
 =?us-ascii?Q?yo3PM0DYzLf0J2iwoo0xsAB9ZV72QBxoVd1VFBe9F6L3GxgOkOiWt4+ZZZtl?=
 =?us-ascii?Q?gv8dbYjR7IjFaSLAwmT8t2f4kCJfD6d8D16Gc4eOC+qQ0CnF7U47emWADFEW?=
 =?us-ascii?Q?pOPgWEa0UYfi+OJx1POgTnOUjuF/fOHVxuSU04nT/5EHrLaBy/nvhVVQ8WxI?=
 =?us-ascii?Q?SvcOhZfrp0RN7lcfGru3VY+ArUpjJyaodWF8EEQf/bkUZ7IVC4txpyb1Ap3J?=
 =?us-ascii?Q?2rc38JXbBxb4pi4D3rB5nTfC5vVv9fhShIuuuRpiWcZFi1QGbbQNtheS0Hv7?=
 =?us-ascii?Q?ga7HOQAa2qDgaxuBF+Txg6tUNSoABjUZxVJJKHQ3sJOa1wzdBQ4/6/8lnltV?=
 =?us-ascii?Q?0OnKHi6UwQyIpnA3xTy7gCa4NsuJ2ZwcM8bPvJkcMABzZ1Dcl8DcyCBH2gCU?=
 =?us-ascii?Q?TQOHxSskkfVwI99Jko60MxAV7uBLaV16yXqazahg8o7RSh0RlJacYKkl+ctN?=
 =?us-ascii?Q?H4Ohvyx5fYIM9d7R06MDtzLk/WbTBMJgKmY6BJvJ+pI9L5Mxg6jQbYJLL/LM?=
 =?us-ascii?Q?ydO5dgttzDWYnFIwsRU+UTakEitXjRpCCSR2ybU7+O0MRkfXZlRB1qmTpyil?=
 =?us-ascii?Q?oWjgbrtBg8AEgJ7TVY0l5SWA?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?21tj0bAm+UUggVIzw35oT+2s6nft1FeooqK+gO3aVoxyhlVU5BiHxXpD31w+?=
 =?us-ascii?Q?BD7bIV2OTYwjYVmYAOrZA22CGLrtiFyxlhZnsXan+vxFQtuQs2gIh9B7XRm+?=
 =?us-ascii?Q?sL86wAGRjKIzcns2csjTV4kmvfDUCPaQRxnS0QFvIZSneX5Pe/QG4wZxfHhB?=
 =?us-ascii?Q?2lxsvulNhEtmuD4ZhZDOXUkZZPJva7wjw0nv21agphXEDMvkyNea/9tkf0OE?=
 =?us-ascii?Q?vUzuKah5Yuz2tc5zUmGXUhmz0gWbl97iP8sJ4GyZf61JGGlHVPi5JT/BS+JH?=
 =?us-ascii?Q?eOn3INYoVwhgpL0v0LgCMTYYwP6RL/m4xge/12Cs8fsXblWpWneppb6nmIcQ?=
 =?us-ascii?Q?YW6PmcD//N9pLXNZWZZYVOWM14meuPxTwevRW2gNjMq7/tOdamLxmlIo/LdJ?=
 =?us-ascii?Q?U3p0B5LfK9sWVbZLwtvQE8ZpdbCCs5l/MWN41kURtnxTheZZc7049sdbr2sf?=
 =?us-ascii?Q?p+xc9MhF3JuUUFw/UzWugPMJl7AoebaVM+p+lhyjVdhF2ZqYRvwZtS0BnJQq?=
 =?us-ascii?Q?E1Nv3etFJgFWzevmiojU85bcVn0kDMT1JB3eDFRO6+bbmdO+/gpd6XFrA7MF?=
 =?us-ascii?Q?SD/wzAkgmYyp1tjn1vD7TzVJEtkCu3GUxR0cX/mO7TBJjpmewZUCiSzJIerr?=
 =?us-ascii?Q?rPGwzHflShJ0bORlIHkzYoYT2nhwPuVBzsttqM343BILzs3EQFZ0LJMv9LmP?=
 =?us-ascii?Q?qgvj4QkVjLt2IXPEN0QYoXFyzbqjWJ3wzrHrtY/VAy1XiF+iEdyCOBzct6hS?=
 =?us-ascii?Q?lvxBmiSuzADo+QgnG3f740E2HrNyJS9yyKms8viDo13bDE17+68n59iBGaH1?=
 =?us-ascii?Q?Y59be4SuFufYegMpiWxAmVg420uOCvsa7KZ+o2Prht99W2IXiE/zvFi/GjGf?=
 =?us-ascii?Q?43L04wnIR/Bg5Ugy9LbxCf1uTm9QtJRHLX1t1OLtJ5n6EQiGkgqOOTyIIrN3?=
 =?us-ascii?Q?W2i0HFeVBvzoRI4cZzWPOEsb0DV+M89GRORsWscZ8b0qtnt5rz5gw42Af5Tp?=
 =?us-ascii?Q?WlPwJHwxsOHtsX09lesv5uIZvQ5PJYNiAt5ueq9ciDIIB08vfPDaNVoc8CX9?=
 =?us-ascii?Q?2BBwukWMP6MGlO1BUiD82/Rr1cZ7ZqgSh7yBjWxpkVWghg/2b3MPlS0kbtl2?=
 =?us-ascii?Q?MpRRUsSI933U2IyQa7w7g/j2uUUItGmJsx3kYjSf7QhBUpTID99X7JYXycmD?=
 =?us-ascii?Q?eAYbqYV9daT4XwNUm+1fdPTgPMLk2sAcw6RpE9MRTHwmyTzTl9IFAYKTp3Ol?=
 =?us-ascii?Q?fw5OInfEhhHqdTJnAj9aw2YDJxuoiR9dXVMB0YsoX6Jln3Fpji2AGsC0a3pX?=
 =?us-ascii?Q?zLc3I8an9g92HCQOe4Ia9+1Ntp9aeIktlZ/A0+etTTLCfVeEtal4iZOIZgY2?=
 =?us-ascii?Q?M3eimb6ifOZT8d/v4LHnjWRKhR2OoPK2+4doS/bWOi1qtPad6z7dPEbmuy/x?=
 =?us-ascii?Q?Ir0ZL9ix5sNkSlVHk146Q7SVb5WzLWl0z1joYcdcCSGkJhhukk4UQ+o1rSR1?=
 =?us-ascii?Q?ZWIbO0U1mzFLytv34z3pQf2ATn8sI+jgoUrxCxmKPFgqMhfUYm7cL2ncM3PW?=
 =?us-ascii?Q?0SUenFHV53lSf4QJ/+lvb0RsG8h8mNs2N41NdewqQNgOvtCUWajwdIJ6BQNT?=
 =?us-ascii?Q?Kw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ch7yR9NCEstvqRn8lKSOWLfZmFSM2urLrwCQ5uEpIiZmCm+3G3vUlKS6AeZFFUIyDaaYKoCf4kt/DeCsu2eqZti279qABweH/5liZD08Cpz0ljDYQto6dPYr3Ljn8isyJtIL4OSe9sOXEzv48N7SK8CLG8E6H3ebHrfqP0+blxjZBTtyG6rZseITb3YRw/PU7ZmO7L7EQip+KOnvcRQie86QpKVMOD3VSkTGaapWdju7UV9u0kIujPPLKe1bBFqCiHmmLCqSff2iOsGciEtwVB6rTW4L87n4VfeX87Rwf+4BnGoFsJIzFWStcV58ftfvL8EYgNZ54qRCUZ9VA3hzwrOH/u2E44efU6jCzMo/LNHocdLZ7f7IieS89Q9ucBef1h+/GW9rcAXIsZsWDch1jcmFvTfApm0U0h5gK1FJwpOCVQxB9lM2tBglGSBYfOqIRSpLQytMWBfR5sefIoSZw3vVCQa3wmE52Mv6LrWuX8heQ7MA1jT49L3lWWzgT0VDWYe3RACB9n009qYQ2QdLiEVKNCgU/Ctkwu+6qjR4RBZU1AhaZN+KV7ZVIkBlco9zCToJDnDL4J/9b0qZFXAbnHAjgnV/MYAmxjTIRlSu5UI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 898680e4-1ecd-4b34-c622-08dcf992b5ff
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2024 09:59:29.5368
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nUyX5vSNqtVv3SpUvYKppKITWr9vlNgWKnec7uQHAIJmwbmbZ/WHsB6vivmDMHDGpAw3z4RYr2tEB6d4r5C7/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4708
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-31_01,2024-10-30_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 phishscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410310075
X-Proofpoint-ORIG-GUID: RhtkHurnV6R-QSob7Qk4AL12jzbrBYlS
X-Proofpoint-GUID: RhtkHurnV6R-QSob7Qk4AL12jzbrBYlS

Instead of returning an inconclusive value of NULL for an error in calling
bio_split(), return a ERR_PTR() always.

Also remove the BUG_ON() calls, and WARN_ON_ONCE() instead. Indeed, since
almost all callers don't check the return code from bio_split(), we'll
crash anyway (for those failures).

Fix up the only user which checks bio_split() return code today (directly
or indirectly), blk_crypto_fallback_split_bio_if_needed(). The md/bcache
code does check the return code in cached_dev_cache_miss() ->
bio_next_split() -> bio_split(), but only to see if there was a split, so
there would be no change in behaviour here (when returning a ERR_PTR()).

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 block/bio.c                 | 10 ++++++----
 block/blk-crypto-fallback.c |  2 +-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 95e2ee14cea2..7a93724e4a49 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1740,16 +1740,18 @@ struct bio *bio_split(struct bio *bio, int sectors,
 {
 	struct bio *split;
 
-	BUG_ON(sectors <= 0);
-	BUG_ON(sectors >= bio_sectors(bio));
+	if (WARN_ON_ONCE(sectors <= 0))
+		return ERR_PTR(-EINVAL);
+	if (WARN_ON_ONCE(sectors >= bio_sectors(bio)))
+		return ERR_PTR(-EINVAL);
 
 	/* Zone append commands cannot be split */
 	if (WARN_ON_ONCE(bio_op(bio) == REQ_OP_ZONE_APPEND))
-		return NULL;
+		return ERR_PTR(-EINVAL);
 
 	split = bio_alloc_clone(bio->bi_bdev, bio, gfp, bs);
 	if (!split)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	split->bi_iter.bi_size = sectors << 9;
 
diff --git a/block/blk-crypto-fallback.c b/block/blk-crypto-fallback.c
index b1e7415f8439..29a205482617 100644
--- a/block/blk-crypto-fallback.c
+++ b/block/blk-crypto-fallback.c
@@ -226,7 +226,7 @@ static bool blk_crypto_fallback_split_bio_if_needed(struct bio **bio_ptr)
 
 		split_bio = bio_split(bio, num_sectors, GFP_NOIO,
 				      &crypto_bio_split);
-		if (!split_bio) {
+		if (IS_ERR(split_bio)) {
 			bio->bi_status = BLK_STS_RESOURCE;
 			return false;
 		}
-- 
2.31.1

