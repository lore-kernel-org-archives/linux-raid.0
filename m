Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D1C61946CF;
	Thu, 31 Oct 2024 09:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730368796; cv=fail; b=NcMa9/2qZTpjZyEygJ3KDGTUKawuh42JVS1eFF+i6Mgs9hg/kNhpwd39VEsaVbtn3haMDl4+MMuHoCvG2kS8ELxbZYLWyIu1e3Jao3qTm7hscuymZ22iU4Kyj+fyTTBnuSmdNPVa7WgYo9bPw5ey+uN3rvvF9ycHGnW9K6XCFcc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730368796; c=relaxed/simple;
	bh=v4nOGCmFNEuWX5Uz8qhdjbrYvJXMkYK17ZhVv/feAvg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UkR8d/Hoh1p3PKJmXfV9bfjMcw2m4zl0TseoLd+yQh8pPdQH4uEuxyQjLqiThuHVVJ1CshUEs/QQpXxEkGbn6D0hW0dlgGkvM3qLvOErH4sOj2bjtZGLxr5Tx8GwotgpWmNO8ki6KZLvZFLPBZGtWtQjT8dl177z30mPqTeIuHg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WcHhHe5T; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=fFXb9r2T; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WcHhHe5T";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="fFXb9r2T"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49V8tYBr023697;
	Thu, 31 Oct 2024 09:59:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=cq2c9PaCfs12GusU7c16wxubjOv2Jyc75uiQcQrT4F4=; b=
	WcHhHe5TFtRUSkbhNhG0dIFeYyq+ETdiJEVWY6bXsXISlmcGP5P6vf99sjv5cqwb
	9nl9GN4MQs7KJsFXMau/WYJxbNAx/gXXU6lR6DyuuJck8DFU9L9/b5LoOwNvR8df
	18ZsN76r7OwQpyceg0FnNqIiav/acJxb7ifGIR7uDvajR3ZztWDQo5BhDrOa3cOf
	PS8HrfXF2P5F3Vif34Qn2m74WJwRnlzQNJnIJlIzzL6RNuOCP2ij0iak8M4E7nvn
	9l5JzxZ+FqbtwA53ZLkawcPwIXUZNjhldbwjYucw4gkvONcDvR2FDxA/M41htZSQ
	xeHnkdtxN50ClO9g28UTzQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42grgmj0t5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Oct 2024 09:59:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49V7o0c8004797;
	Thu, 31 Oct 2024 09:59:34 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42jb2wseth-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Oct 2024 09:59:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U8YmFe72m9NIezy0ghBXKNrAmI+eXHnPX2JuVz9+KrtJ76YNiReTC6adB1lJ8s74WorIdEw7ivp4KveFgqOLXiS3bQllDhR0a0Y7jBfLwYR6hx5XppaXe5RxSU63t/kQSqtqfezKFWBXRjq8CgJB/2wFOt4UtkEQhMmhg/NEnqgWl4y2QnfAMS70UMFZmIvajlaDeqijqYadJMJRIBubqWqQ/IXIwcrCdFRJs3Jm6WtWRuPw1OGfRgrfbO/5K1DcjsPUaRVWppC9WTI4dZdbqhfwGU+VLH2V5wiF9fK6wcuJfczKl/FJ9gZ7m+6mkSUupWF4csnLhmmFT7PjGxST5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cq2c9PaCfs12GusU7c16wxubjOv2Jyc75uiQcQrT4F4=;
 b=VjDI4+Yp4v2+uOw9dskuWe84akEQqjPQpsmRKMeymakOt4dsEDSdoWy4Af6rgic5iSqlzG7YYywOtUbnr+uRSMgN0hQyWZr8/GGkl0NwBKi7VNZl4ln+08ad4E6pQPy9I0L0kzlsCT32Yhff2FZbFUtAg5OY0s+j8y8HtkmxMcDFTymS/gZX+tcEI5Lerqz54BAutviXpxTwyuk6R4SXAmbV50GpDRPjFF96IpGz3Fd1iK+i/f9ulRaRgBPVDq+onMkY7MaufPsTOIFiCd0ZQVtmx/m7ZVZYyl1P98Gxls77sF90/AZovIRtV7JnUhQLTPrDKqci48lHjfC/67I06Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cq2c9PaCfs12GusU7c16wxubjOv2Jyc75uiQcQrT4F4=;
 b=fFXb9r2TVs7tYnHOf38M3IHLKI/eVcRaZfh/aC+TdDq3OD1cmOlG/AnGzMpZaJ7EZlgMijZg6ENJbVUc9b2EjgGB9UMcf/MBRYiC/Xn6s100Xlb+ZfO9fcjoBmkQel8kdJhKOmOc6eT1K/8fF70fQ01lQYJKMt7BXLu5EvsIAdM=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH7PR10MB5724.namprd10.prod.outlook.com (2603:10b6:510:125::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.32; Thu, 31 Oct
 2024 09:59:32 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8093.027; Thu, 31 Oct 2024
 09:59:32 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, hch@lst.de
Cc: martin.petersen@oracle.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hare@suse.de,
        Johannes.Thumshirn@wdc.com, John Garry <john.g.garry@oracle.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v3 3/6] block: Handle bio_split() errors in bio_submit_split()
Date: Thu, 31 Oct 2024 09:59:15 +0000
Message-Id: <20241031095918.99964-4-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20241031095918.99964-1-john.g.garry@oracle.com>
References: <20241031095918.99964-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0092.namprd03.prod.outlook.com
 (2603:10b6:408:fd::7) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH7PR10MB5724:EE_
X-MS-Office365-Filtering-Correlation-Id: 6bf9d3a5-3c0f-4c08-6178-08dcf992b781
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZevnE8ZQsKnPE7Q1PNehq5OsAZBrfeaCNlNqzkkJlbaZgFs4/cHO8l2LqJyH?=
 =?us-ascii?Q?EEsrfHBUkuwec1BdfpsAD/3gU8Bb5zrOvUBnK6PxQFzyf+uxpUqVyW0ALJjT?=
 =?us-ascii?Q?uxCjGi65uEszZiMWYlnUIjujtdSTB9nYgaQrad1nOGDDu2j6kWMsuGTUhgCP?=
 =?us-ascii?Q?0mLt/CTeM5gPaQYKpnw4mPQFENonFXYXRjq0knH28nQwI/a77mGzHtioyWMq?=
 =?us-ascii?Q?2zvr2zcuWFwDF7gp18BABwTbEWujAVY9qhiVsiuE2KEYwDb7miaBb3ij3DMb?=
 =?us-ascii?Q?5ix3VDo0CSOsNrdcm0mCG/i7ScYmMNdLGyNjj6nMx78up5kqujfbsUD+611D?=
 =?us-ascii?Q?9ATLa/dITo8fWJ8euNpj467OsrSDf9rTHuAfThjEsSdigGctxzRNQwUQgibh?=
 =?us-ascii?Q?kIaYDWKPM+BXXUDG6U1FW6fnp57bf8ebzuxsUdqM8VgQwpJ+DsY2uW72MYwc?=
 =?us-ascii?Q?9+CxbH+Q0q2j+94GjUm8qIFd90C8jz+d8xik/nSFcToMe1FQaZ4ZUvZ5c7Ar?=
 =?us-ascii?Q?bmL7BP+xXzy56UyZp1bw7wr7AOfKngPH51FB+Wtb71lSSQtLNx7JJxncU7Yy?=
 =?us-ascii?Q?c65bm27cG81lzsjcJM2VWfOIeWSXaRpFEQG8QA1WbTn1pp9wv40+VKf6DoGr?=
 =?us-ascii?Q?FfTNCJdOPl6pp+s6uDNYSg0dtGwT3GCILhD6G0eRdSYkSJSKbbMn7gBS9uDM?=
 =?us-ascii?Q?+TWP3xwlzp7CU0lUNGcQ1OCeVHycPIma3Mteh144OMsBjBuuRaOfi6VXtspw?=
 =?us-ascii?Q?0fJVyTMtfoqyZuX+7kifenPXI216l7/2VCs3xzB2sSXFqta6kfNh45gNuKSe?=
 =?us-ascii?Q?LdJJzvHwDKY4wQ5SnBWX3eoVgksMCxvht7c3NXG8hnYBENKhAH+VtN/Qw3xA?=
 =?us-ascii?Q?jcHt2El8fClQcfJm9RxGwFC3unN12FEQtJspAkQE0xmcuStATLO2F1O9WGhr?=
 =?us-ascii?Q?bBAPocc5z6QuYoROdoF2OKt8fJRvhK0rhGvlB7JJatePlwmibsmsJz1gWcWv?=
 =?us-ascii?Q?XOn7QMDpOmgAZF1jxXwFIY35jnL+7f0jmYnEdcM80jBgD0lhLdc5U/QwCiKg?=
 =?us-ascii?Q?U5BLmFyDHx0ikg+TyLxWEVL1S3GZlNPjntmWhtNU7WFLcFeN3OTCkbyGktX0?=
 =?us-ascii?Q?3SuPGEdjlVYJsiJq26APpsQb8rU16Zj/awReW7SyLbDal6lzskr1vDeMcUGQ?=
 =?us-ascii?Q?Ua9mLdY4vFMOyS9s+Qagz4bHO0kGpSZRCdesuHFrWPGl+WNKXRYIMTxyip3h?=
 =?us-ascii?Q?jAKlyzf8v2FjPSAlFWtaEXvzdbWOaTOQkA7RvF3vc0xba/AssEP/rQPRAmDa?=
 =?us-ascii?Q?mbo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?L+KIhPzmHIb/BSnqz9UAAlIo47HaY3MfeDdwmX2nV7x6z1TyFQRYDbMjtXat?=
 =?us-ascii?Q?CFcUaxUBY5cKFMHzn/b/xvSuoQ7JJfOfnyuP6jlaF+NvM2gtUSr3uxc+ODOz?=
 =?us-ascii?Q?fNKGk5VzciZCxwiileHiBlsH9QZGz0gyTuqb8yaC1FhA+YH1T8khUIqeSegB?=
 =?us-ascii?Q?9eUU2fMq4bNy7VJeBZljOdaRqHTJ2qktxBoR/p9cXhO5XfFMobbTigZUL3fL?=
 =?us-ascii?Q?rWHIEx5fSz3u81JqvrDh/Po1IBaAfHSMSY0KrgxUh0VQzjkUjfXgbErxxude?=
 =?us-ascii?Q?QuNm3IqJFTyNaYyhzYonTE7z1L2ItdJzQVq6NWTnHvTUCPwzfKdVu4JGceRT?=
 =?us-ascii?Q?QESM8l6l77bdoUy8C2q8QMaYHgCY1ST+y544Hh99x4jTGyqFMuSMEnr4xfqK?=
 =?us-ascii?Q?jQ24MUCQSXc1VC7u3U91cp8z8Oyq0Sk2OoawfgvIXJk3qkZXatK+hKwTNCI1?=
 =?us-ascii?Q?zpjjKzOj7Nq0CVcetqZi5jii8G6d0k1eEg350AC/S2muJuIq2isYARexK+ho?=
 =?us-ascii?Q?WRok00fgB3GwHKX2nk7HCr7fR/rZnKDiU4bWnE5a8yUi3KDDrEqDelYlKZN5?=
 =?us-ascii?Q?MA9YShRQ+qvnphClKMk61v6d9ZTw8Vfy/paEz5RKBQFvdRqcphEhPj8OAlS2?=
 =?us-ascii?Q?7Aa4PGzRzzbjUF3elu9gqrEnf9vQ71LRC19Bz76ERnLCX/7DwTu8PyRBNJKo?=
 =?us-ascii?Q?VLDL48BdLn29UPMMBvIMZ6cWSHoYs6/1iO921oSfb6vhYEDEwLReJEQLuitK?=
 =?us-ascii?Q?CkrH3fvh0OKVjFi3TELplQIKM5mZ6K/9F90hmrkGTYTqK0uwokIanxZQMv2B?=
 =?us-ascii?Q?fzAgJIrgsLN32RwYd1ezeTIVhWKf9aLWCmziIXoIUBxbwiLyIt39D1OTixkL?=
 =?us-ascii?Q?b5YoyiiTtDjuc0eOMxMzbus4gXPwONRvZUrXjiFqR14HQ+Fp5R3vbOX6Hqkq?=
 =?us-ascii?Q?nW8eKmgW39rHbeLrTriwT98j7Ur/MWijdOv8Tf0V+gGt4ks2B9cXMvmQSjog?=
 =?us-ascii?Q?a/v/2pca61eCRwwu7Cy38jVzTx4I+Fe8KqHDQhh5YNrMRhHp+c1jv1geRAkV?=
 =?us-ascii?Q?k8+JkDKxh7G4g8XmoQrjQ9bih6WmXMQATWvFiXbVXp78BwMVI0vA5P6129dI?=
 =?us-ascii?Q?QEBpchYygZSCkRXBEk+c/0FF4xYQBBQXyKeQe5/Vxfmc0jGCndRbvtyiIUHy?=
 =?us-ascii?Q?XKeyCT3QxO6BQPVtm6Dqfyfjuxx1PgH49MNS37p1X5ZWfynPfy9lF09eTYWB?=
 =?us-ascii?Q?MrrzWH0zLUTLJcBc/bSldyvMq7FHyusOLlEdTYowlyV03bCDOd4MAFCBSmEg?=
 =?us-ascii?Q?iDxM9/Ld2uWU8tedzNzZmGpPJMRoKIt+oaFhABwDI0e+xVALn43EXvsfnO/w?=
 =?us-ascii?Q?ubsluEoIKkH3wsF/2NEyr3IbHow8I5QhKlIvO3aDc5L1Ko7HYePHoHMUn7uv?=
 =?us-ascii?Q?h5L1L9pfFDokmx9IfCWmls+SFwPSUPstoUjxYjc+gyoLp3n6PmXfede1mJY+?=
 =?us-ascii?Q?k0F2EZ/3V5WIzwXadhTWAnyrGZCUdZjWukpT3nl98/zR92lKpAmH1OAj8ngJ?=
 =?us-ascii?Q?uPaQYj3898izCPSTuGgEvxLcoqx6tkml6R0wslCyR7pi/o6xQ91QzEo2qrYV?=
 =?us-ascii?Q?VA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sTd6bYF2XjjSUp4TBWZ2HoDLHBiRN3xRWx8JCRM2PP5FLDl413dMihl24eQpWu3uAGZxazKraVCD+ZbwCKNjwvkWz8a1K2UHbovb4uqnNbaq3U1szgbbuNoc05bopimuhiIemDEuZiaE02lPnM5iCxLdEo9ZoB8lia3RFt6pRwuleLw9tlbnBFXo5XbMZjUvpapRNvERIz2QSH8JLYhhSH9RYkHBPMScsTJqfZfPDgcswIXZxgXaWZM/EjqCHQerQd0bTASAsRcd7bW9xqyBfcH/SeN4WcOMQHxVpyy/A31HsAXE4coGnDm+Mzsm3Q+KpvZxiBi+HITbTXh8I8dnRfBei1Y5woVccmS2IygNhLxjph2oVmImrv02CgHUZY+q7mdIbWtuirlLn5Lm+h/r/f6xNjxhksyI9h6+Q8Lg6rqkCL6nXOI9i3MkT0MccAji3ln9HghswSsvOTJW3uWXjyY52aKCsVx7myw8qTM6CO34Nm/lv+bd5wwlBc23BR81lfGT2z6dqWtXXVIvH9UWyBZE65xf7UGm/qc0FOIxKwybafnbTDLHJHH7ofuK0onPn9G2SGwL7A96FZEtMJN5wa5xREmgqiaruDIlQZYlzdk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bf9d3a5-3c0f-4c08-6178-08dcf992b781
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2024 09:59:32.1084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tP+u9jvfwxhH7han7lc56RyrMNhO0IuxVY1J3ZevSeSulc6tP+XU0ODW2EagzJVDfqxKrLRjWK1uT2Cn12pLug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5724
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-31_01,2024-10-30_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 bulkscore=0
 adultscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410310075
X-Proofpoint-GUID: 4vyZIEjWYW3je6xwK7wb1YmmFyMndIH0
X-Proofpoint-ORIG-GUID: 4vyZIEjWYW3je6xwK7wb1YmmFyMndIH0

bio_split() may error, so check this.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 block/blk-merge.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index a16abf7b65dc..4d7b6bc8814c 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -107,11 +107,8 @@ static unsigned int bio_allowed_max_sectors(const struct queue_limits *lim)
 
 static struct bio *bio_submit_split(struct bio *bio, int split_sectors)
 {
-	if (unlikely(split_sectors < 0)) {
-		bio->bi_status = errno_to_blk_status(split_sectors);
-		bio_endio(bio);
-		return NULL;
-	}
+	if (unlikely(split_sectors < 0))
+		goto error;
 
 
 	if (unlikely((bio_op(bio) == REQ_OP_DISCARD)))
@@ -123,6 +120,10 @@ static struct bio *bio_submit_split(struct bio *bio, int split_sectors)
 
 		split = bio_split(bio, split_sectors, GFP_NOIO,
 				&bio->bi_bdev->bd_disk->bio_split);
+		if (IS_ERR(split)) {
+			split_sectors = PTR_ERR(split);
+			goto error;
+		}
 		split->bi_opf |= REQ_NOMERGE;
 		blkcg_bio_issue_init(split);
 		bio_chain(split, bio);
@@ -133,6 +134,10 @@ static struct bio *bio_submit_split(struct bio *bio, int split_sectors)
 	}
 
 	return bio;
+error:
+	bio->bi_status = errno_to_blk_status(split_sectors);
+	bio_endio(bio);
+	return NULL;
 }
 
 struct bio *bio_split_discard(struct bio *bio, const struct queue_limits *lim,
-- 
2.31.1

