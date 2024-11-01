Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3EC71AB53A;
	Fri,  1 Nov 2024 14:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730472425; cv=fail; b=CvaH2zRe22wVUxVYHphW51NPUjLw46TON/HplnPENC/fdz3dp1Znv+Kl8hvZEmGVTbdAO7p6kgkuVKxGG8rIPArprPpH520txpcVxgc6XZ04aBmB2pu0kqhq6ToLzeMeQnSf0fa8VLNO1otCemEhw6JAz0kHe4Ip5WDS0ctWrz4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730472425; c=relaxed/simple;
	bh=pbMXPOXi7nRnMiqjjelv/EzqNWA9gywI2WLOtlvGj6w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tiThVAzMsFFiL//7+bq0GeNNoN+/L64FN9qD0joBzXXeaP9p6GD4iPAiUP5h7b8/b4CTWyygkuP/zbNAOp1vHW7pkkQL86sJ5TTOx+bTcgQCEuqhxnv8am+zCJWCdGljXBUxZXc1SId3EMR2I1MK57KpHBk1Ve3eP8c1OWQ1Wgo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MW6FgCK4; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jkyqzmpX; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MW6FgCK4";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jkyqzmpX"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A1EiVRi031856;
	Fri, 1 Nov 2024 14:46:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=LSDgn72u0eoeF14sBKQNt1j8FS+lvtYlccqCh3p60qc=; b=
	MW6FgCK4mgy8AeND8J5fnKjIfKvjPuV7KPypJhnRf95sTidOUt1X4AY15lrYIkB1
	quAb3fPNcA47so8U8/NEd9m7QTOM/lnmPCcGZoWi1ACdKXJV70XEE4w8w/AK0Gq7
	Q5Vpbofwt5/qLZjWS8XJrPqQpPutlD2MH22OviESEE5/c7+b0B57OuLzJKophsIp
	DfoamgmyOR5vobyDbAImr4SS5ERYcdODsBJwR6q3BCs7xeJIQ1PlnSxf8yXfEJAm
	yzpmjbMu8PgdNn7lJRuadF4wFJxJru7w5WpSnPEelsVcrXHKETypb2uOHVQ7FYXf
	/ZziQS1RcGeH40cdTfVw5Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42grgmmhsr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 01 Nov 2024 14:46:49 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A1DoEWC008495;
	Fri, 1 Nov 2024 14:46:48 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42hnedjrp7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 01 Nov 2024 14:46:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TuhhUpZgVPq66TSv+qm20CoTOVhzMJUfl3HoUxxRfURLRgrlpzEb4M4Qd2EtJRqfHE3Y+EylCA2ZKxM9JhmFtss3PLiGSliUxNo6WAdCj4ZVJk8cUHiQRpH82dClu6ISOV734zlC5KiJQfQWPt2bn2KclPXd7s6F+ex9izFryWy0oyVQw+mBDCELCBYZXjrGb26yAFxbbCvNfylBsOC7K21bJFgpbTJslrWAhO3dBzMIQn2KjgQGGgYBGq9EdG89DrSHCW+CLWuPVzkmWdaCMKUYKP+jZfb8GbDQcMK/R9olQJTqlPpoliAeI3llTmNds6jCpA/y60vuvqhIVFoSOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LSDgn72u0eoeF14sBKQNt1j8FS+lvtYlccqCh3p60qc=;
 b=E3UjuQfSOlc531YKtLl65xqgQ+ep8ikoX3RycuHbTEn3sgG1TYnMt7aFXDpFbW0tBtCYHZFYZ7loVSNXWaEFLTGuVmiMIv67xFw/t2vhLH2pBhFLLsvGQWFmM7GaBdbNFDWsUFUU+3B/47vSfp349k7mZak2NJ7ii7fBJkB70n0qgPJV8bG2D6/4wp7jBndJAki8YNr7PNMImPhEaawPLNTpOSuO2YA/LeJbLN9XjHqPNRU2TytPtCtDRVijsAT3ba3cGtmgs/sPpkCzrr1g7IBsDefZpGN5amNWPYF+B1wSNhWv+PNsq5cw4YAAKEE1N+dBghIfpMTRByuLrAc75A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LSDgn72u0eoeF14sBKQNt1j8FS+lvtYlccqCh3p60qc=;
 b=jkyqzmpXzZKJ2IPLBOFQHdKwEfMt2Ay5wk++fuO+V2S8IEUyTWpN98Du/D4TzAd3z4X8xxuibLJUrceaqjL1wJDXoYeAHm334FW5bvnb20ELhHbVpyB+1bqjKLXOt76TCLeRFJXMesxIUUTjl2UzRbHM3qmkpiJS+4w32VyunEU=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CYYPR10MB7651.namprd10.prod.outlook.com (2603:10b6:930:bc::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.32; Fri, 1 Nov
 2024 14:46:42 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8114.015; Fri, 1 Nov 2024
 14:46:41 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, hch@lst.de
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, martin.petersen@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 5/5] md/raid10: Atomic write support
Date: Fri,  1 Nov 2024 14:46:16 +0000
Message-Id: <20241101144616.497602-6-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20241101144616.497602-1-john.g.garry@oracle.com>
References: <20241101144616.497602-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR16CA0051.namprd16.prod.outlook.com
 (2603:10b6:208:234::20) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CYYPR10MB7651:EE_
X-MS-Office365-Filtering-Correlation-Id: ca92fb1b-628d-40b1-7224-08dcfa83ffb4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Zmg3BDKShMatieuvV6co7ADpZjg67yGYS3z1lEk92ib5WvSHDVnVBKxVY0sE?=
 =?us-ascii?Q?e6nHAmmBcMAUcxUVfQIfEkbmuINWQk04XaGYjDyhxt/m6McjALPZnQCx+YBc?=
 =?us-ascii?Q?rBZKS2xr8LmqUB7aLsHoFMpJm4Np+fAWDrQsyNANl+C4+i52m5eHRReENXNI?=
 =?us-ascii?Q?aG1IodTgUG6zXByZilVf/E7j2ItKVFLMQ3xPp2Q01ta+G2cGbMOWvrGOCS/E?=
 =?us-ascii?Q?gVAi5r8/Go9eqPANb/Pv2EmNnaXPwZbutPag2OqwnDSx87zvv3mK3wP+X1VJ?=
 =?us-ascii?Q?WozkeHvq+67ZxXnaaJB1hILu+XCjgi+oYDbHpIdy0+ofGM8FAojnUzik7pHv?=
 =?us-ascii?Q?yhbzQ8x7u+Qj5yY+3bo1JeW1UtXsJtG03YfpL6V5LfgTCQgK/ID7EY8zJs9p?=
 =?us-ascii?Q?cvI3Hui6231kQO1/nZncBQmtBcHPlj4Zolrt2KXoMeMY2tnEWaD0Fu/eIH5K?=
 =?us-ascii?Q?lxUbWNNmQe46M7A8WK8cQrCC1Z5WjjFuV/zRBbp9wyHIAVcDVYnkFE2SexB8?=
 =?us-ascii?Q?ukkBBpL/MROkXoldjqetPnoapY1FHRNprAxUrToLjJsOTUo6jQ23p6FIHOR6?=
 =?us-ascii?Q?ICcvpD9sZ2rpU5sczvscAHL5akCMJNaK1FGxOFK/Os8zM0fyk7BUm+0YgauC?=
 =?us-ascii?Q?ElbjP6Pk+TCC93Dgz6gP0ol2qSkoH10vNbrrUxrtP4RM1PJCRT/x/nY/tSU/?=
 =?us-ascii?Q?sMfpRMMbKnqzg1oxljkautkJAiaaqIIjn9UoaowQiTrjrqmI1eDY3qnhLRZB?=
 =?us-ascii?Q?YeROnhtE+bw8QPPtYuLbmeQvHTAyo0EOMC2aBj58d4ySI2Lntz3sb9hkr6qr?=
 =?us-ascii?Q?07NXXFm2mcxb5KJEzYXH8PIsfMvg4AOXkMdSGOH5tW2Wpz7B8lP3N1ZqQAe8?=
 =?us-ascii?Q?BwEQICa9+Xg9fXUT1pwfCvAesgt2YMHifYmMwryze6jwhQ5FPlSp/3UiiP2l?=
 =?us-ascii?Q?tuF8y9eEppBg8xPdP8LT1dsdDl0JVtqytQrXb47tWI9VcfJRQ9juwrMJ5FL8?=
 =?us-ascii?Q?pY2mbSNMC8irP5FPsuW81LoGo7ErFkdBtI08YtpZIk+nd8ZQEs0Dlie5l15Q?=
 =?us-ascii?Q?ejFc4HRlI6RroJwOM99OnKCG1hZmp3b8s9OhoemW0an4ItuMfNDwvvhqJ5n2?=
 =?us-ascii?Q?oAbg0mMxuuY5ty8zoH2gV5LVQAa+Obeb0LiLOj3N18Sm61Fj4D8iPdEVDBBe?=
 =?us-ascii?Q?pmlki+21KLBfqYV1jbgCREkAzb4hXeO9FSdoIQqhoQ4LiorvV9TUPhEj3RA2?=
 =?us-ascii?Q?lgi0i/g5vT2lNfhG1lVbR88wAtUUIHPVdxbtPw4C6j3ClzUH3AzxfeEyRWku?=
 =?us-ascii?Q?yKyyus04nev+fP3OASYQoDZ/?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Z9tmE0qvkuKD3mFYNvey7l2O60bvTPRRI/vM9QL11EgOp3oTWZHx93hI6ts4?=
 =?us-ascii?Q?fKNT6JouULN9EpnqfECi149zrjH9aMDaOi25b0vdx9Xh4fvR4C/voGU0C+VD?=
 =?us-ascii?Q?yE6+jI4wiqY3bJHGX7uo7+R0x75XQTp2x6SLxzBShrFyA63a/tkhFUla+P2X?=
 =?us-ascii?Q?bRDN6YuaIZJ1CpMKeRXftzHhh/6qFQjsDFYaSn9BEeB4OPWHGjR8ho6sXCsd?=
 =?us-ascii?Q?smJeziEum2s6YJ4QVNKXRl98p0V8IqQ5rb//J/7naz80wmjKno4v5imqNUtR?=
 =?us-ascii?Q?e6hNv6zAa7PWtH65P9sNmXjEaLXTZAZquehpoo7zTjuyYhisRcmtHLgM56tL?=
 =?us-ascii?Q?NDH/LZK/WfukfeHXY5XuidEfvbRBwAuRKv+IBtD2oGJOG97FhmnQVe6blSYa?=
 =?us-ascii?Q?GIIpO09TpIG3FLRp3HUQ7qu5OrlOl5HhaXzU1vMRZ3K2cGmUvVCIxxoPivlC?=
 =?us-ascii?Q?vndkyuV3Z9sVCYHyDTc1wct1e6IYxzUJuJsPcARBXMPUUriKIVh7xawPctHH?=
 =?us-ascii?Q?PVNoxFq1m3WCL1B28pJHi4a+LfD9f7O92Bj415IlYQGVZi5MPoiZZN24b5Pr?=
 =?us-ascii?Q?YKbtvN3rcbltYfXPaWur8e1oZvEvwH7XJRjrFF6W/PYgdFp8wgQxNkF/4Ur7?=
 =?us-ascii?Q?Fx9TJkvhRRIFyneISwAifCkc6kM27r2HRo5kh/BYMlPAiFtt/ywQBAIDYCeM?=
 =?us-ascii?Q?4z9wu3I4VcwVLWpOppX5a4ljWHcyMwtO6XCR3cz//YfsXqxpQ6cadTqhM9Q7?=
 =?us-ascii?Q?h3F8Bj1dXRMpFxYteWCLmwS6R5GF7e9idF2SFRA1pOZbjtL4LuSaBUPYnK+q?=
 =?us-ascii?Q?jvhJS5Us8WkV6ndeI3YeD1BxzUwS85bkdRRoFfZfwqLd2m8qnY+03dYl+R7M?=
 =?us-ascii?Q?O2m7djIc1KnAmsqtve+YqgSJVeG8bDHhvs7QWXc/HzzS24IU6Fe3V4akim5R?=
 =?us-ascii?Q?zLcqqNa3T/fRMuwBK3bpN27+0kKDe4tgiIANNuPemhEOSWHRt0EDJsGsrvix?=
 =?us-ascii?Q?DjLwUOy0Fhh0cJaQj+1+7exDDMLvkLvECNVtnMMkwO7R3bwc0uOTjr1RA2v1?=
 =?us-ascii?Q?5csE4JSAVohH4owPsOGrWD+aNY4RNi/07tWNg+P+qZSdTnU1sY7Cs9oWKFOh?=
 =?us-ascii?Q?vrkEog6sj25qN263cTM0SnVPDRm/R+4nbOG05CtHIodTLo7r5s0Pm349wB2u?=
 =?us-ascii?Q?yf0xMaXBpXfyLwRgh90zUHO7E8EwkrIztosqudLYejNU75eWZH7SXPyLdwgk?=
 =?us-ascii?Q?OVOA6dzfBC9tRY2A9/9rxukRRYNGNwWAiJzw6y5WOAqKsOwRPlhJmoRsXqB4?=
 =?us-ascii?Q?jxX8bwY2QKrax53CUWLKJ5Nts/kAZntp+s9gzGhnHH2cXbucSk7wg0es0Yay?=
 =?us-ascii?Q?uFroA4SUWKQAuPlizQXRFybntninIZsKpfpphkrBPyUZ3agfyGw94tDjpOYi?=
 =?us-ascii?Q?/XseZNPNawMynAwXfdI0uGC7SOd/VrO6be/ambMPfuIdbxovomrYxPOGI97h?=
 =?us-ascii?Q?TO1b1ijuqQH0ESdrUx1o1JHvuZS1PvDI+myzzKSgg61FAfHxWLTPWp+YmoDw?=
 =?us-ascii?Q?ItjmKQVLdrIiy2j8KUfO+y1X7CZAqqmYuizfferk6sDRC9sc82Hc/nBObGY1?=
 =?us-ascii?Q?XQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nKQE0KaCdwMFtUOlbQvolsZsGOIx/KDNKmtnViSOWsn5Z8crGds0GCOIYi6jRvzSgr0igDqYlY6RSYvgYi9+wQ5zkhewSorW2hyY+OkVrLU+Bm5aqi9EfE9kU7c1YPtUpeZkAOcTtAgv8MFIpgY/0fFXKBAXCdVGC7WS+Vwfytj/xEmz+ZnFaYTbdkVY2i4SI6ya/7wI0XgvwfTDtVaMqvF6E78v0bcBvJ/zI/05pb/4HcpjZZn4pLaQqTzLurm4z8FW6fBP8gD8yAHt1Jvw2VbO+iV6G6NnkrXOjm7n/4kI2sqN09jGlcYdNAnGhqbyYyS0S+55r3TxK+ymqbshJPfv0rwklKG4IhZ2SESFTLqG8kMus8N6CoYyOL/vJUrfQv3644PFRlW+UaFcXlc+4xZ+eljXuGVt+eu68edJV8Cd0LbFwjb1IEqtn+Y2n5+dYXuS6VAGBJmWfHK8uwvBLkjGIjCMg1U+/cZnoEhetg38Yot/BmMa4RKXJsCIHcR6H7GcUVbOaWr0bLCNLjgyyG9MyHliOT8BU9fUujAmoQBt4/+EtfrI+hldEN8uEZ8+6dEOM7iGDNgNkDd7vDfrShv1IPCDInb4e3rxruMCjfM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca92fb1b-628d-40b1-7224-08dcfa83ffb4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2024 14:46:41.9074
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +NJtGO+v2d5Lzvl9bR6P+HuDV+4NiNnwAPMDaTX3QO9SBIS/YplvgofOGvQqBCAGdcYrqiuTg2sQQMcqlYmt8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR10MB7651
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-01_09,2024-11-01_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411010106
X-Proofpoint-GUID: ATzUiT--DUwmxhgVyXPzOanwE1CQV_CZ
X-Proofpoint-ORIG-GUID: ATzUiT--DUwmxhgVyXPzOanwE1CQV_CZ

Set BLK_FEAT_ATOMIC_WRITES_STACKED to enable atomic writes.

For an attempt to atomic write to a region which has bad blocks, error
the write as we just cannot do this. It is unlikely to find devices which
support atomic writes and bad blocks.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/md/raid10.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index ccd95459b192..55175ad55525 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1255,6 +1255,7 @@ static void raid10_write_one_disk(struct mddev *mddev, struct r10bio *r10_bio,
 	const enum req_op op = bio_op(bio);
 	const blk_opf_t do_sync = bio->bi_opf & REQ_SYNC;
 	const blk_opf_t do_fua = bio->bi_opf & REQ_FUA;
+	const blk_opf_t do_atomic = bio->bi_opf & REQ_ATOMIC;
 	unsigned long flags;
 	struct r10conf *conf = mddev->private;
 	struct md_rdev *rdev;
@@ -1273,7 +1274,7 @@ static void raid10_write_one_disk(struct mddev *mddev, struct r10bio *r10_bio,
 	mbio->bi_iter.bi_sector	= (r10_bio->devs[n_copy].addr +
 				   choose_data_offset(r10_bio, rdev));
 	mbio->bi_end_io	= raid10_end_write_request;
-	mbio->bi_opf = op | do_sync | do_fua;
+	mbio->bi_opf = op | do_sync | do_fua | do_atomic;
 	if (!replacement && test_bit(FailFast,
 				     &conf->mirrors[devnum].rdev->flags)
 			 && enough(conf, devnum))
@@ -1472,7 +1473,15 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 				continue;
 			}
 			if (is_bad) {
-				int good_sectors = first_bad - dev_sector;
+				int good_sectors;
+
+				if (bio->bi_opf & REQ_ATOMIC) {
+					/* We just cannot atomically write this ... */
+					error = -EFAULT;
+					goto err_handle;
+				}
+
+				good_sectors = first_bad - dev_sector;
 				if (good_sectors < max_sectors)
 					max_sectors = good_sectors;
 			}
@@ -4029,6 +4038,7 @@ static int raid10_set_queue_limits(struct mddev *mddev)
 	lim.max_write_zeroes_sectors = 0;
 	lim.io_min = mddev->chunk_sectors << 9;
 	lim.io_opt = lim.io_min * raid10_nr_stripes(conf);
+	lim.features |= BLK_FEAT_ATOMIC_WRITES_STACKED;
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
 	if (err) {
 		queue_limits_cancel_update(mddev->gendisk->queue);
-- 
2.31.1

