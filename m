Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A82E175B1;
	Tue, 19 Nov 2024 01:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731980265; cv=fail; b=JO8ddaYc9iNJ8Ya6zyqClsKZ4gk+co+HtjgkSJkOiGIXSrvDmkA4SBs/03rTe15OYmClWnl6d+BsiQT6x8xsy8KmDrAFLGC8m/wwUxJ0H4OqP5p/Em3X5PAW4HB5nA+sGUAhLZK/eM3UsUCVZ+CP0OR9Ds++1PFEHXbgSIkSNFY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731980265; c=relaxed/simple;
	bh=wsOo4+08yc+q8ApOt88btv7AaPRb0WAj3JaV4rYj5Ow=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=SVMVkTooR7PUWu1Jnv3mwXQrOaPl6Gk1zM0NfIGOxlIrI/JQSDZvsS8CcvffRYXvhT1c1m1aZ3uLNdCzB8e1FnJZ9R5fqvEGCs2KNHluVrO9G6YuhEistpeQx04CB2anLDSUMJ2DqbERVg7yB6t2hEuWE/s/ojF7Fgi2XVAsvjg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WzDpZsdF; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=bIMnvLKJ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WzDpZsdF";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="bIMnvLKJ"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AJ1N772002457;
	Tue, 19 Nov 2024 01:37:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=ypQRL3YyAdnO7tvxSN
	LVZFALYIV+7gw0BXoaYt+R94E=; b=WzDpZsdFGiw9reUb1l8PniEelX/fwZUYba
	kahcZe7SeuOVLgIHVID+nZVHiQE4/sJNhYVicHyzYaIK2qp70ujB5+qfEMHZtMh3
	rdwiBm21C8ESbOYK7yimIDDaX4aiFRGtdhbF/qBVkosbBr/3lEBnTa0hZl9nSz8R
	Dr6ZBRkCJYs5oL7u7u7HYLKqFU9RgHEQQjg+OrXb2znOeEG2/u6Q31nq2eE/rJ9I
	sSdwBfUHqOa0yPGQB+HQIxUYdTq8RYpckIgdJK+slFK8qwehp5jEBYU6xhPUyT8q
	j5eXgxvj368BVE6+Fev+NzA3v75gjhyyi9kWGSEZYNny0pcF3vGg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42ynyr2er0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Nov 2024 01:37:27 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4AJ1Jlbk009668;
	Tue, 19 Nov 2024 01:37:26 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42xhu83n24-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Nov 2024 01:37:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DltsR2xOKj2V93CRQWD7OE8xqK2PLlMfYKAYh48tyTfeMlXeXYu6IX9be6Ot8NwLarBnE7W410iT6Hly466ann4mAj9fWmnE260zKc8AcvYtE4HsLZ6PUkpUYFN1Mto7bssV1dLAHHd9xu0icVHFTzSvc92zOKML06hmFvEzPSpevYcK4R7LOkW24Usb7Sa3k+Cz88ocFaM+uh5nrb3Tefo1K5VLneADjiqomhMzEIQe1lpNODbyvz6JzcmB4EXnrdXIxxI0/B4yOYWogxcM8w/BZ6GQsmVPtNNXsD0LI8TY+/5tICD+Gl1DI0t4Z6Tv4qCigJ0ppbO6g3mWTlFJ5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ypQRL3YyAdnO7tvxSNLVZFALYIV+7gw0BXoaYt+R94E=;
 b=mtqiv/z9Izql0v5IpsZJtuI4EcbtZo8a5LzsKjw7uXyRY594R5QvlN1grZUkdLucp5t4L/sYRPF/uuOjZM6p+ZgZXy5KBtD/0J9vJw7KjmxdwDJcQKr0FunNE8DCjuigDcUB7UE70V2iYbGk5esnL9AOmAd9L2kHXyq+CcbfDlHnbELKAi2SdSgM7GZsFtI+CFtEGRQRqpZ0PwTKirCRVxKYbzBH15XrgGiQC45xUIN00tn8+09fNA555UDw1fUj+CU2Z6nlzEUtd/UBTXQvRVPwqVxmaXuRn1HhUbP2uf8FsnYtBKUSelGsUMKfTZft+ZoGxpPHHlu2AE7ObxwpMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ypQRL3YyAdnO7tvxSNLVZFALYIV+7gw0BXoaYt+R94E=;
 b=bIMnvLKJSbOChuPwAQu1ZxShF/4cAwuIqAsxNXn5pCBNnd6pAocxOMUsiwEMevRgx1rn/y2v/G3yb74gJBBcX4tAsztBZyBhHXo2Vdoav2BtQpuO2vcj3O9Wcs/ZUuCa9IWGSjmsFnWOUQ0s70vSHxr/2nzuIk1cKNzv6ihx9Gs=
Received: from SN6PR10MB2957.namprd10.prod.outlook.com (2603:10b6:805:cb::19)
 by SA1PR10MB5821.namprd10.prod.outlook.com (2603:10b6:806:232::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.24; Tue, 19 Nov
 2024 01:37:24 +0000
Received: from SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c]) by SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c%5]) with mapi id 15.20.8158.023; Tue, 19 Nov 2024
 01:37:24 +0000
To: John Garry <john.g.garry@oracle.com>
Cc: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, hch@lst.de,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, martin.petersen@oracle.com
Subject: Re: [PATCH v5 0/5] RAID 0/1/10 atomic write support
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241118105018.1870052-1-john.g.garry@oracle.com> (John Garry's
	message of "Mon, 18 Nov 2024 10:50:13 +0000")
Organization: Oracle Corporation
Message-ID: <yq1jzd0rolu.fsf@ca-mkp.ca.oracle.com>
References: <20241118105018.1870052-1-john.g.garry@oracle.com>
Date: Mon, 18 Nov 2024 20:37:22 -0500
Content-Type: text/plain
X-ClientProxiedBy: MN2PR12CA0013.namprd12.prod.outlook.com
 (2603:10b6:208:a8::26) To SN6PR10MB2957.namprd10.prod.outlook.com
 (2603:10b6:805:cb::19)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB2957:EE_|SA1PR10MB5821:EE_
X-MS-Office365-Filtering-Correlation-Id: a3d6a5a9-0004-49ec-1140-08dd083ab7ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JHOWUSMhLYxL12acIo9l57m3YNw4KOHj4EcbtRVeAyWP8X8PJTBPMtW9Enfb?=
 =?us-ascii?Q?kCDIEs+DgX3rSydkMM2mjcUxXDyUT8cCvX5lgWml4iRZFwKEhBkzlR1ally3?=
 =?us-ascii?Q?GnLog8RBvG0FfiH/UamZPot5/UJF6RyFO5ZBBtsUiuWOgW3dlD1N8bqmfvEJ?=
 =?us-ascii?Q?wSWp8e4w3JYZJ6kd+79GiYoX82qAmYGp9tGl+u9QO3UZiUhLqUTyPEFdJEAP?=
 =?us-ascii?Q?ezmO8JiLOZAdQ9Y1YkQFJMmjIyOiP6hBhDIVdoKLQHhUWZriZ7sRJkD08FS2?=
 =?us-ascii?Q?8kDG//SJl2sf3dmJd7KDspEfLXHZqqRCplaG3wa4w7NGw8VjypCAEuYgrvn8?=
 =?us-ascii?Q?mbVNqOIA1q8wr+ZVgvi+VR8P4be1QMJvOOO9gqEs+jsS7beUim1CqYxSewWq?=
 =?us-ascii?Q?VOD7GMTNnivG0enUwAxWkI0xSSi//AyB3oTI2S22CbDusn3Wroyzqxjeiwcj?=
 =?us-ascii?Q?wDbzZIm1R1M6N+OvUwK1xA3y4L/ajMYqHkb4S33n1O8zAmS8+Md79VDzr+Sx?=
 =?us-ascii?Q?dk1HXcG4NXgGZQd+x92DzhHfl4sLmwDD/iSDdmpEiZRBydQOvND3X8mM8GUG?=
 =?us-ascii?Q?auuYBrnGj9qnpC9IBjC4oQn/4lmbaNb8UO1Bm2ehXk92hPQd9U2YTbHlfrRt?=
 =?us-ascii?Q?0sHNxvsoAFKe43gi1PFUtpjnFIR15SCoXCQ8hgI5pQRAb2jvQ5fFWRP78RL6?=
 =?us-ascii?Q?O/ZDBmZHDis4yjm6EwWR+FjSob3gre8tg/pl4G4nkID2EInfbmrNI8syEGM4?=
 =?us-ascii?Q?ztU+MzYDN3sARoF+kMI4PNk3lwy9av+wP2bJcIpzyCzjNdqNEe4zomIIRu39?=
 =?us-ascii?Q?RpJ/OAIvAjVe+1QCDW0O681yb0H/VJaaAIahZVJ7sd2MsFEBpOndHStOph/D?=
 =?us-ascii?Q?oRvW6Z26jI+oy45Be0zMI3vs/hFKySy87dcBO18xvuBi22Rjqruhd6TTM6Sf?=
 =?us-ascii?Q?i1Pfi4m9I23ZUZYuFEpSVmBQy2I8aP7x/HgQMUzK2PybMnmmk/EykGRsj5rh?=
 =?us-ascii?Q?rOjx3lLPLZRYsnKI9mIrDzR3msMMo7BeZD09yxIDqA3uZBBIDKrcmCrzls06?=
 =?us-ascii?Q?k/IH4Pl5TREg2NBwR0ls7GT4o8eFJSpRCtLMorrQt2OsF+5Nk0Hh2w6Dv61S?=
 =?us-ascii?Q?MPv3tIsR9jIS+sFEGI5kZb5BisgkywskyAsYbcsdnxZk7OhU3gT46eqM8yig?=
 =?us-ascii?Q?QgGYXefoNOZLymI83QSVcH3lCZALc8viFNgZJg79/yJdvyNHMGcyGlcMBeH3?=
 =?us-ascii?Q?RuN9njiKTPNeYKzgPdG32byoLcXqoQISs1q8FjIKGgQw79NcsNHJsre0LmyJ?=
 =?us-ascii?Q?hvJXmIUvzA7Lbw3dcYWtAjRg?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2957.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IFtrWihPa+HMKtny1cVNzpMyUMaWaqPO6+oSPYFCMp7Xt1/cXPkaN16GPRFb?=
 =?us-ascii?Q?VbIxmgZVWsE5QPus1dCcov7Y1gOVkX1z0WqYtN5l+3bIhwL08aytmVeJoBFS?=
 =?us-ascii?Q?96zx3tHuF5+KopznCSIm9kVuYGnlihtEUJiaVBPJ3oa006wt/MuWZ+jpi80u?=
 =?us-ascii?Q?b8P3/E+uKPFKYM8XUrxvECz+GHfGmRKyldggAFXmvCjW4MPSLsYQ1C5IJFo+?=
 =?us-ascii?Q?UaFVybAfHzTVmTfQUQeQxlVkWj1ScE+/iXwLnnDiLpvx4JkMYb5Y105hu10N?=
 =?us-ascii?Q?bukyzainnLDchpIC0VkgLed6U9DYv3EDYqFCKLHyLt3UKhdlPTiKgpxVVIAR?=
 =?us-ascii?Q?lqcnEsnDhVklgdHEmfVnmPvOapXBLfg7PXQvLZP/5DsjPO4ZiIhDQepXHmM/?=
 =?us-ascii?Q?dw2hCEYq/GxrNSJPktLeZlQlc549Y23XEdu+wMWzJthd3bfOpIbvQaWnBvcT?=
 =?us-ascii?Q?JtnL0qvT9aVx4yMOM2Rr+C8E31GBsyDXB3ylNlS3OkSBMyufitj3z3+mY08u?=
 =?us-ascii?Q?Drg2BX93r3d9aS/q+ytXK3TIkWIPUmxS8XHkcoodnAS/PC/2ocCz9kDIr3i+?=
 =?us-ascii?Q?Mr3muXeWHSh1X1czMmBmLwhk5mgMhJw+wVZtsLkIMD/piipYjovUVNzV5ZIG?=
 =?us-ascii?Q?zHA+TGJ7iRpxSN+zbXfv4Ucb+d16qLgqFPORDGUagnqXXCoGj91ea4XDR9ng?=
 =?us-ascii?Q?NFiAWWw3OW0JKrUdXx2KbSDxDxJWSTzugHj9rzG0XIRoG+aGyZuaQZ8Tae30?=
 =?us-ascii?Q?uQgchw9v2A0hjL+6HV6zY8wP2qwJ2kkkAFPIoGlpJHQC3/2O8IQHxP0BZHal?=
 =?us-ascii?Q?3w7D6d/pC80VyjCghD583tCqIsCVl/lXHFBIS6O+m/g0iNhRiQke+yuH4S3I?=
 =?us-ascii?Q?Wo9TLTlejtzfABhzpEKhwmq2Y07spAbiWHbkZgaXWQOownNqPM95xVbP05nH?=
 =?us-ascii?Q?h/4tQMq0Nrc1tiuDSHMzziY6TM4CuXnyFqNLcUQNxhSu11R8Tmh3wS/pW7cN?=
 =?us-ascii?Q?cbY2wOgZI19Ev9oBASs+JmbazPLe9QUqcGIMczUeOLLeSNhRO0vg4XmwuDiw?=
 =?us-ascii?Q?fJa0v99iz+CihnMYVCdbTRsOgN5NNLfukd3TkTn79X+2SKzWDrMZOvSjie2M?=
 =?us-ascii?Q?sNPXuFb9DHqEk5cLULjxknmIFIL4LOQVGxLNOiE0Jv7oM2Hy6KtCUVguB0mH?=
 =?us-ascii?Q?hlCYtpYk2bm3ZglP4adwwMrXxEeZYuSwst43u0TW4RBQtTHd1fiu3WpzgnCV?=
 =?us-ascii?Q?+pf4NM8KOqMxxXOSXL9+tqdIr7ISU88X+fzW+ojY0q4F5qhNJfQNuY23EXqy?=
 =?us-ascii?Q?6Dd+EE3Le+hg0+ysiCFQyUFusLXEUqlEJKG6CS8JXQF6nQqI91WtIKnlQrLV?=
 =?us-ascii?Q?u8rQ2+xjgngoaA3QVmw6Ri2S+3Bb4YS32If++4DsWh2SHHm7WObi/W1sXEW+?=
 =?us-ascii?Q?xU7S9hUJ2cG0ERhEL/th2GzDCq7/s8AoqGXuIF7GupgS18YbgAjF/RqTa21i?=
 =?us-ascii?Q?Xi8BrR+eWKLahV5FKPofmcz8nwvIcgy/3lmwePBBEr2Z50PHpct5RK5TwSNB?=
 =?us-ascii?Q?Q0vOUEvTH8SEpAifixzxDBvyLqFo9ZQ6Y/56lBaK03sbxgEVdc7YGcjksut6?=
 =?us-ascii?Q?tg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	TgAEvAaM2CTAm/ZOgPF1g+guXDtnZ9M+UXRXGuR6HIeoW7jVCvNxcpefZZBYOfm74P1frlQK1QxE8gCJR5hakKETOuRhiX4dQAQTRef1587EbiMlXWOqJvV3kx5eMX7nLiSqP5luDGpwSodZRj1O2+s4j1hh8MqPnkyY1edVsrZ341R/dRJ0Q+5vqkIEO73XwxWWCiCIyNgu48C0oKdu75DGUQsu3jwVQ5tQsHOOAbZ1eRUcsKoFiJgy+IVB36srLrfKGV7JqciP/fRwbMpe/2Vp66veqZYcye26mIZd0ZXk+p9wDkG024Tbw9A/fx7mxmIzeGv8zxWOQ39GEiY/EWqgeFsv8H5yym1oDRojfMzgoIUOummnT0FFIW4yu789zzPkRsXEKX9MV7Msr/pjFP1A3w7qTW/uLHpmq8zJ+xvXPuzELttytKVwXM1JFBgQbqF10tSO6Y6M92buKVuWpYduBJ54H3VDGv9ZGmARx1P8Bzm0uMci4z2fPxOCpzEIVw/LbgtlzVE1Omw636gxJqVSlbWueFmfjRo5etRyXcAQIibyIh3paIoXBjs+mhFbrkG1EQVdJ/Kr92DvBNDcPXVdUW+PQRyS1ykNFkRdyrw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3d6a5a9-0004-49ec-1140-08dd083ab7ae
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2957.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2024 01:37:24.0083
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f9tkY43plcLvdQKB1aqdRFTW8SLm6PUTxUCiwDMqqijyX8Tp5061AFLH/Nl4zQdEcfHdjABViHIhIptW80iPkEbQL693ysEOK50Sv2/1XY8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5821
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-18_17,2024-11-18_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 adultscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411190012
X-Proofpoint-ORIG-GUID: HAoAajxFT74QE_ztN3nS452QlICow4aM
X-Proofpoint-GUID: HAoAajxFT74QE_ztN3nS452QlICow4aM


John,

> This series introduces atomic write support for software RAID 0/1/10.
>
> The main changes are to ensure that we can calculate the stacked
> device request_queue limits appropriately for atomic writes.
> Fundamentally, if some bottom does not support atomic writes, then
> atomic writes are not supported for the top device. Furthermore, the
> atomic writes limits are the lowest common supported limits from all
> bottom devices.
>
> Flag BLK_FEAT_ATOMIC_WRITES_STACKED is introduced to enable atomic
> writes for stacked devices selectively. This ensures that we can
> analyze and test atomic writes support per individual md/dm
> personality (prior to enabling).

LGTM.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
