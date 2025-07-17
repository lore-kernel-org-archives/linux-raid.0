Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B6152F88
	for <linux-raid@vger.kernel.org>; Thu, 17 Jul 2025 21:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752786458; cv=fail; b=sLMeiAL7UKWvW3eA7/5ZslKoUICI2wBWaKo6WnSrsWN9xE5kOqAwmJ4xG313YDfikm4X6ybgZG+aR686c+CjEF03oZxuSuO6v3fLaMWyU6GSXk6vy/DxgNFUevcEhUv5tkHmW6KpZO/kwtR7l5Dywe5kO39GG8u7kJk/4gURXQ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752786458; c=relaxed/simple;
	bh=qO8ZFCT0QTazK56dovsN72zq/jXi5QOD60oB2z/rqZ4=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=eFFnNg5VsZRHgZHTJxil+LiTHSM+en7X/e9XnZY308IxJT89x7zqT7hHgZUngdRyex+TAH4tMUkszN6JObV6sFvn2lpQWJpIBiD+5V/I2JGwsKvjv0ruLKj+5SG626qhIZOSYR5S3Cy13ObuaATCzsPtYZ6TXF7pFZ++28q+0A8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MdnRiVQ6; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dvqTLUaF; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MdnRiVQ6";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dvqTLUaF"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56HKZHim013758;
	Thu, 17 Jul 2025 21:07:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=uACmGNWCQqn0tovLyf
	qGqMi2YoWLSQB7IC9dut8MICM=; b=MdnRiVQ6LoBokILNDSp3qwFI7EBCZ6bue2
	CQpU33ORcAb0dIfaNoXZTZ5QQEGD758MuEYqe/P3o4RiGdkr3A7JbfMBga6NJ/42
	zlW6klVCNIJ0op9ZDK1KZ+53To8Zh9jMWokEwRbNiovnOkkE6FrQpNtOsrSthmZL
	Dr1eLVhTBqon3Lf0SMAe/smbPRc3aNsbGneio8lGSn6mD16EdTpOiNZYCySwSNpU
	QlTswgbYDiM9gRiNMTNnalzysZWPluqBpZFY5TjHSchqxTlOosT/zBLOOd1HjMhI
	pqHc4CZvgkSuA2ko1kw3I6Pc7+m4n3IAvZJ/JQciOXNmRSINW4yQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47ujy4ux1f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Jul 2025 21:07:33 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56HK2rW5029669;
	Thu, 17 Jul 2025 21:07:32 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2073.outbound.protection.outlook.com [40.107.92.73])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ue5d76aj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Jul 2025 21:07:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SkCs1ZS6azCjfD/iWaY0qYraCmpkjshh4l3pnApJSnlcQ/1qVhak8xW7sciiIocM7tb+86UXq27RtheGmcxkFASi4khgv8f33YUyY4lAJxxfATCYR2ssKEcT6WTTQusuXg3PdUsGYKvusxD4rz6rs4JpJFTVn2wfUlzhLCPyyWGCcF36egsXsyTqBB9xhX7ILMS4yEY+l+9HYZW2EF0sojwPqaBRPZeHOMGRvSvIJrTTjSwCrNfj/hCRL1f25skJ/82fricwpsb5MFVAvK7aDy9F8M0COLCzDo+51bmsMlEYZ0IxA93P5CeC6C6Mg1eG/5IH6LWNddeA/FRIeOUobw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uACmGNWCQqn0tovLyfqGqMi2YoWLSQB7IC9dut8MICM=;
 b=dqh0CaplajPPXpdMr3r9fwL5A/p/kxD9R3EYByMli3oLBGBmqep1LkWX4+mEje11a9Snxhlmuzrsy7+XpA8CEGt4mHPMylBvJdtW/+67El3TN4ydh2F4CIDonWSwxBwrBKISMfl8H8z6UscWgZREnxYpuW24Cz5j1ZZ6yj2M+2I1x8k/psgHtVWofm4+nIcN7GZb4nylIQsO7uBmBDilNMAFDTeuX7W9/S9fmh+6B1nLcPR8DtatarzR5HLzl7trGu5rXwWD6zE5WKHkaNxBV4p9ncPqVyLoJJA6c5kFGwY16mKHjJvpBGloefNBp5Hh+uB1TzRcgD0h+M0Vyg1Ykg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uACmGNWCQqn0tovLyfqGqMi2YoWLSQB7IC9dut8MICM=;
 b=dvqTLUaFu8epE4xrErJ+dP/zY00HDc8gHKdBKArbDZXfxMOpLmoPsm0R0XZ0ZEmLe92mjXVKQfO7azMb4EIhRhy6RlLJu21EqQnAgi/8YOUN6B42bx05bpe3DuugJBapTYHK8r691vJ4dsXbpwOkIFhSDVxkDbm7opIwHjXJB98=
Received: from DS7PR10MB5344.namprd10.prod.outlook.com (2603:10b6:5:3ab::6) by
 MW5PR10MB5827.namprd10.prod.outlook.com (2603:10b6:303:19c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.25; Thu, 17 Jul
 2025 21:07:29 +0000
Received: from DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::b527:ca1f:1129:a680]) by DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::b527:ca1f:1129:a680%3]) with mapi id 15.20.8922.037; Thu, 17 Jul 2025
 21:07:29 +0000
To: Yu Kuai <yukuai@kernel.org>
Cc: Filipe Maia <filipe.c.maia@gmail.com>, linux-raid@vger.kernel.org
Subject: Re: Sector size changes creating filesystem problems
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <1cc7f8b1-cd22-40bc-8e8c-45a2cc180849@kernel.org> (Yu Kuai's
	message of "Thu, 17 Jul 2025 00:21:34 +0800")
Organization: Oracle Corporation
Message-ID: <yq11pqe1qa3.fsf@ca-mkp.ca.oracle.com>
References: <CAN5hRiUQ7vN0dqP_dNgbM9rY3PaNVPLDiWPRv9mXWfLXrHS0tQ@mail.gmail.com>
	<1cc7f8b1-cd22-40bc-8e8c-45a2cc180849@kernel.org>
Date: Thu, 17 Jul 2025 17:07:26 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH7P220CA0153.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:33b::15) To DS7PR10MB5344.namprd10.prod.outlook.com
 (2603:10b6:5:3ab::6)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5344:EE_|MW5PR10MB5827:EE_
X-MS-Office365-Filtering-Correlation-Id: 87a41e8f-0bd1-473f-ca12-08ddc575f08a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lJUolnLXr8hDEyIi1zS3fTWXLNQtTZ5Eow+UKzvtVbjaa5s/sSIeko+y1PIV?=
 =?us-ascii?Q?Y6xYtRPF8piR7I3f1TSZ7WF/fWAPixed4XflMd1XqlOPg6jvnP5kfQp79ejQ?=
 =?us-ascii?Q?vJKcGiQSNnV4Y5JLp2h0H45bQtv/PSp7nql6/4DIrzQveBB3QNMijHF0HIqk?=
 =?us-ascii?Q?rLBf8264PyKKdVnF3CPvWa8c4hb3nKnEQVsiVGnHnIQKu6lxM6VTXJpyxrJR?=
 =?us-ascii?Q?Zzp/PDC+FqqVNEEJ0ENzifiTiUC+9YnX6sFs9aWcHvhQygAMEZyQShkUcwa/?=
 =?us-ascii?Q?4hTdslVfPAxCF/stSZyhEj2Mv1WR0HRo6V1lIsyPVTtFOx06A5DBK5rJZCdO?=
 =?us-ascii?Q?q1AAkuKt3P6UHJlrTWqp0HdBU0LxoMzpIDEW3gF5ukdKyiB65qm2yUsNZmcw?=
 =?us-ascii?Q?MfN3WI+THk2FjCyCZiSmrn1R6wsDuWytE5KiFiTsU2PUvon61S2JSlgB2QY3?=
 =?us-ascii?Q?HZS47i8ttBI3hCc93IHEpgGdXE4UAGMEZkJIz9aPu4i6dkIBMV31jKTNAuj+?=
 =?us-ascii?Q?+Z7rQE6sWFML0HcLg3D/z42bRX3pLjwtJMREQgq+pRP4GLKgkG7a+nIO6IcU?=
 =?us-ascii?Q?Ll5gD+ZNR3XIQYati/Sn0pJkPtKR5lgA3nVMp1hccygNmdjDuVMhCoxc8xNc?=
 =?us-ascii?Q?LcjotQz07QozBEL+yDOwibXWt4fYQZ43D/RxQvR8mOOD5uqWcAiFgGjLm8VH?=
 =?us-ascii?Q?VOfH6lIlEzf1M/WBQDmePBXVF79kTIHJYJNpmVfgvRpocTpQMLv+gndHY96w?=
 =?us-ascii?Q?OLjqF8EoWEWVwd6l4/pIM5M7Y4/GwBtuKQVGQAUNEOqlA36eW7IEp0OdAyy1?=
 =?us-ascii?Q?8UB+ThKirBhEFFtf5upvGtJOTehF9i1CQ088jTLYsKjEV+DGEDppAbcebP3r?=
 =?us-ascii?Q?o/XHdpaw8mhsIjPWq3/OkbLkjl8x6a4aoitDfLDQUKBmU/WTYT1hmwnHj1HU?=
 =?us-ascii?Q?6OUtUslCeW+88yCeU4RDtF7sCisGyXTWXsBCp6lVVMrb41uO1uTNwxKRtr+z?=
 =?us-ascii?Q?9WNMnAF6jP41++PytahJfpR/JMJkUo7dNx5locCkyCZJ/OPkmwdPAuMbYhux?=
 =?us-ascii?Q?mg/twTdXpDqIKeHMx2T51+ZsEj7L7hxNCfGUuAipqMbYhaJ+1f0VV4Z5XlJg?=
 =?us-ascii?Q?dF6vsGrl3xL8M/oHr+obiGmcRu+QZfh8vbvSZFFMQFXzmkSsaPqcGBvIKkYm?=
 =?us-ascii?Q?MBtL4JmbCBLXlHWplc68ZItYCXfVtHcoVWe2xtAsd7MFityZZrbB0NgTKeX3?=
 =?us-ascii?Q?8gUFbDDyAyCX8rIk5gEk6Ug7NEqKkcNHDGsapiCbzeC4a+doI53OGuieKpQ2?=
 =?us-ascii?Q?oVEZRvuyL5/fgtbvgS9XFrpJCg/XesJHuu1LqroE1O1xo/iBFw4d/mupVlwt?=
 =?us-ascii?Q?hof8pFckvuP38rzQu47KTCAI8edmMsPx8oaZgw+kNxb4QGkdWcSiC7SG4Em4?=
 =?us-ascii?Q?lROK/pxETWU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5344.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7LoAQ4SYGtQmODggI7VkMiruqkvW1MJbmoaQtZm/uy7JzhNBmTHFVJDsNHcR?=
 =?us-ascii?Q?g1vBOjxfY3dl05CzzwX4/iTgkrs0/uQZJWCKb0rWB19e/okEhFevtAZbRr9R?=
 =?us-ascii?Q?lgqXOqbB1Qlb0z4CZdT0+uPGOVF7QEP1eHV62rUNJwKv2fbQU6A+HXOi8YxD?=
 =?us-ascii?Q?Ltc7srjvgcD5weWoGdev9xSuwPB++Lih0JokupHVhBuo9YYDippLyQ/6hkuH?=
 =?us-ascii?Q?xBicfoWkeYScdS+Zo5vNrTiGrDGFAzN7aRw+OaY2uR4z3rxm9KfkX7OqrOjJ?=
 =?us-ascii?Q?cuqnrlPh9etdtUwX2rGgIobdfQTYMMC0Dh7AHRCOaTacpOQGbIzvBpVXyGIH?=
 =?us-ascii?Q?kXVYONNGydrppq26XpODiIijrbVQYXUWoYOBJjlY6a5zRa8eiqhOGp2foikE?=
 =?us-ascii?Q?QHbgQjVEE2ZY5kFK2HOiBsmMzI+KQoEEH8VZs42CTO93M5b+TWYx4xkLkiax?=
 =?us-ascii?Q?3V1Vvfv9ezGm4qSE+TPCFk6FzNVaASnF3hvBEtXUuJcqEQh9wPyYPQVRzdsA?=
 =?us-ascii?Q?XD2TbJVSP1OM4O3urMv39MLBSN8TqiVG3Pr8OM1gv0wwLmncyJCOmqwN1wjq?=
 =?us-ascii?Q?YupQVItblsXrYg14WADwVp98376C4eMNM3Xd/vGwt8WhCZv+QkE0D+4nGlT4?=
 =?us-ascii?Q?uvuhr9Sg26a/tFDWc/wdlzypfFWZqYRjKWPmx1x3q+Yb5/sFaPYCp//ButOS?=
 =?us-ascii?Q?Lg1hPY6JFzv5HXQjBIgzZnz4mSM3yoEOAqi/BZVSnYOpV0tzalMHBeSkyA6v?=
 =?us-ascii?Q?C0GEFwoRZ33Eh1/6itE0Gjc73/ipcRZh5lyCSnrtOxOfS0M2q+YrbIzwSDhr?=
 =?us-ascii?Q?jQ1ckqp87e9y8rlI0j7/P4RNZ5ZM/yLzPlAS8oMqjR/+99ehZhU5dmjzrBc8?=
 =?us-ascii?Q?shxj7Z8MOiJT1ORrkHgN48wiwCu85NqBCUDNZeDnIN7B/qd/FomaLDM2+Q3g?=
 =?us-ascii?Q?kxikuZr9WCj0pYau1kC1pzjo1EQjnBuhsRu9V5XUmIV64JSFiaYBQ0k6nZOG?=
 =?us-ascii?Q?NqCvmZvpCeoq2EB0Irdu86762jOcRCos+i20mQag9mI51scrjZPm6eBztbwa?=
 =?us-ascii?Q?+XOt1XYkaE/C6xUNRHfYwyjwemBQ0DSgWaa6w6G86VaF2sXMySx0HpNg8DZr?=
 =?us-ascii?Q?FqidenaAcxDqpiGzQgOn3iE8LCTb/VpScI21yRBs4ZwoVvPsYp3MPz3GjKac?=
 =?us-ascii?Q?7WUrXpiOOwWmJrl/8ca5sDo5AA7AdXHuo24dhg6IQgkW6y1jEDr4Y0API9jL?=
 =?us-ascii?Q?gKKOa6UgmpSlIY/UtwBa3lFR66Oz4MtPYhD354Js/GEpMCw3LzrvxTRRpHMo?=
 =?us-ascii?Q?3lyUwXwrY//D15xrqpicwXbjCw7lisqTaQ8w+KMsy2hb87i0clKRq0LV4XyX?=
 =?us-ascii?Q?mOrKUXtk4HLikNgus+o7yl19RtR3w6zS3bEWeqgkXeoKJyw+7A+uD/lQ3Dh3?=
 =?us-ascii?Q?AkzQo+6/oZDvrcjTmM5uowL52GgpAaQ6OGvPBOQj4eZTPbYVlXONtQkbZMHU?=
 =?us-ascii?Q?YTWFKOh9ZdR9yToArboMt/4ntU/zJQ9wzBiDmwErGOS+h5QtcEtmjogv+yky?=
 =?us-ascii?Q?0OnlOcm6C6o4v30pnuWvu5Bx43qdO+LRXZxejX9WsCg32BaCXeMRJAoTmeWb?=
 =?us-ascii?Q?LA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YXfFXckf7Dql56I2gXvg3XRMMvWioggElBjJF/tIY/KHXEsDVMYV7HXoERLRRT3lFoLNh6LgDkBKrxa1dLolrGivEkeHzaXo2Robpc5ANJKgHAGYk0gKcTK0aBkYRR78YeScZBer2Wm/k5BGhirUzWZzIqyODpJQEbOzaifHMKMGiAZOIjvduXswKByITqYp7GBjekQmsKCo+HF7lfQUDcZl9MaEEZqlu2Bmm/9M4Bc5ytk41EYBxhkPpKFTpL4RpnOaauHKWWdh3oXRSdKKmiilZeXjZjRHubAJloH5JxCfE0rsmPmyN5OEynqmCkoXAgEDEVecQEi7Y3SnhdFjCQ3U/NsKKOubIcKCIO0ZIIER3k5W6Rvee17/ncTAEi6tt7+ZuJ9vjdNvpzT+IchMGUKH4czK73xTAj3JvKrUXxo728MLr1Cv2eZ7aD4nDZS8hvwGvuxL9P03ogDW+VSU0CUFK8B1d6xwDtImwzIFKsatI6LEfM/EVhKDj8Kobw+MUQauBR8ASHHqHZEIG7OlT1zbdVay0DF1q69okqV1Cg50LuvFRxbJg8a/jnw6aTA0Ccamoc4atD1+Mbq0/LEdBsSu6ZbW2bvVkrK2V7bUpHE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87a41e8f-0bd1-473f-ca12-08ddc575f08a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5344.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2025 21:07:29.5703
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tX0/1QTGdymWPrz+3ZRSxCnSNa08M0WyqmjTKWVn7WmBj3FhZ0K3a//NenNFw3RowUK94JgdE0jK8Xu/blo886pB7nHbNQeAje3I+WpMB/w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5827
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-17_04,2025-07-17_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 adultscore=0 spamscore=0 mlxlogscore=890
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507170186
X-Proofpoint-ORIG-GUID: 0XZNO6Jg7uxJdyq0jJbYIhSZKWPCDsz3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzE3MDE4NiBTYWx0ZWRfXyTwXOE0ZYNxx t7bFeIfmbFPkxI2DG7mcZZSfA8DpNt8EScQkaAbD+zBYelDZ9N7Y3IUosvtkx6hr252AEpuYdPY qDJByRh2/cLFl4WhJpcOJNP46rjIv+ZXig5x8fzTdOC7IUVRj6JojaWlbCfq8BohdetQtscbLNj
 1AXJw7lJRiXuFW2dWtqumrXIC3AR+fKVO/V5DoP8nY6Z2xDxM853dsRbpBjhl1HGg8sHAI1+RGo A733xZu6mY3udpm/pqFMr1fgSIGCMFlNuaMb2sXNAj25p/9f9mUayISEc8Dr9rr2Q2vBPv2Hasd Kxbm/zcfh+TOm49sPrEjPEfNwTdi044/0YEObRuaIrquFmwSVzHi3mLPMFTN+TehGs2MOt4y7AW
 gnkQA/5a0CBqw5TtBLORH6OnoU0Pskru3dcwFNQ5os17GiN3BoIoBTbVI9Yj+X+B8fRs5KR2
X-Authority-Analysis: v=2.4 cv=Xtr6OUF9 c=1 sm=1 tr=0 ts=68796615 cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=KnggccBvSmNygke4BwwA:9
X-Proofpoint-GUID: 0XZNO6Jg7uxJdyq0jJbYIhSZKWPCDsz3


>> Shouldn't the user be warned when this can happen?

> Kernel should forbid larger lbs new disk,

This is really something mdadm should validate prior to adding a new
device to an existing array.

-- 
Martin K. Petersen
