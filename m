Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E9B1991CB;
	Mon, 11 Nov 2024 11:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731324154; cv=fail; b=X3RfZtY/575nS9DeHmRdi8hrXlK3NfYhB1GMZ1Wq0jeTduS95shJEGfwZZbB76daYvPCf1SXKFipyoVDzEpGWEr+4p29chj0FSYrS7afPHkWmVEuIUKgHwWSqGgL19rRZEHkZ5oMhsQtKbDGiebugH1h+iSn8B+dg3bRjswBR9c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731324154; c=relaxed/simple;
	bh=O3v4Lh0FMLcYn2uY58xLZMnq8LdsAaXA33qajPMvJas=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MoIEgHAKvWh8QaMSCTmkPKPma86k2RUgW8Z/i8naxeR6vTOQeZ41UPIzEp9jJy7lxSj3GCAQVQsNzDMYCaxgI7gBa3hPYEltBWRr65gJQamw0ZHcGr9WBZw7BEockHLFmHDXOABQODVptO95EuYtiKEmDDrflivgY8szXlis4yU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AsEFN2GD; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=fom5Cgwj; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AsEFN2GD";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="fom5Cgwj"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AB9so2G016875;
	Mon, 11 Nov 2024 11:22:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=IaGBlRkaNVlDb+VuOsFayU1qabt3CslcEd2H7HvvlzA=; b=
	AsEFN2GDBkFAoZg6joZzB25sshsga2h12A7ePFbk+f3hX3P0TAxIjJeUWXGblpc4
	c5FleTKEx51siwkNC1/jxDhR98xSA60RYWDKTY5W9wcvefB9QleeOYdLc42pxYlX
	Odb1HmyrspuSxhv0tmuj6ZYfsM4ufoTxo3fJzPorrgd/VoKIW5z2NehlAAnMrOZE
	ciX6mbJIzmSFtvfqWWd87RXEWZtx2+UI/qM/hX3yGCJ8R3NOV2B1EX9KYCV3xL+n
	+/Uygvy2N6c6TI7mPiDZIsW1sls5SvpKIouxVJNetBlGhymfaToNbsYHaMaQDZv3
	D43B6Xp7J+xGenMYRkR+cw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0hna7bd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Nov 2024 11:22:18 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4ABBINoQ021562;
	Mon, 11 Nov 2024 11:22:17 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2044.outbound.protection.outlook.com [104.47.58.44])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42sx66p8te-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Nov 2024 11:22:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eiAItwgoXYyPkTclIqXWk7Kt7m1mL3JQns26q7+D1eB8oOuRgJZfZYAm3gnwkhR7GT4fdcdUTl3AO5AWgw5cKtyCZGGyRYlLYJS1RpWRKt02OOZfN2ksgwtBvySKTBPSI/U8Fa2zLIWETnF/a38UFjbQbyPAFzqjlvWjX0hPKZJz3LuEyl9VGmgPLxnDKGKuGldR6Xs+kcnhvZ90NH9MJYzGF6+kFTS1ey9zw76IXIwt4aabdJyfEvOYdu3ywH2MdDHvp6omEJdW4nwxusakGSTGJcV91T1i5WtIbzglPZooHvw9RNisOasqTBK+UHUkE2tA0NzgfXiTOcsiTFmOTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IaGBlRkaNVlDb+VuOsFayU1qabt3CslcEd2H7HvvlzA=;
 b=QgcXgy7TIJGFOhCkjCW8itOjm6at2FQqyRzOKT4o0kryV5JgA1Hn1JErKUZCu7PT4CwlqaYT1kbSdYiB96DOUGg60G37zSKhmLUWekwwkSkf7DBripnFBf59GrqXyzsvmuASdjDuLqkB2H+NRpq4jQoHXcvmj0+eDFtOL5C6APA7TWh2XYulHclp6aBAZD3qyUsPPRPHvaKRI3rZ77TOWpNyHSYy6gSrT2y2MfjK0EQUPgYTpnfneBwKHA6hCENaD6YTih+eNte+YpS5SXUJ4JW8ulscp8C68pmZSn5+EzNZfh8rMPcw+OuOHv7/XdLFS89Bge435E1lmhNS/rdGcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IaGBlRkaNVlDb+VuOsFayU1qabt3CslcEd2H7HvvlzA=;
 b=fom5CgwjMN5VaB/QxWH6onGtkgJtUXuJP2XYFjQNrEfC0FsQbXJVDCrWxb1p8r4HpzJ4q8u8gsFoF6hyCFAomhDgag+jqw63tsRG8t893/uBm25MfEeD7S5DnhWhQUVfbIyxNF1iznVr4hSo3APE1YJd5k0C1DI61ueaMvvwdWY=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH0PR10MB5194.namprd10.prod.outlook.com (2603:10b6:610:d9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.29; Mon, 11 Nov
 2024 11:22:15 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8137.027; Mon, 11 Nov 2024
 11:22:15 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, hch@lst.de
Cc: martin.petersen@oracle.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hare@suse.de,
        Johannes.Thumshirn@wdc.com, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v4 5/6] md/raid1: Handle bio_split() errors
Date: Mon, 11 Nov 2024 11:21:49 +0000
Message-Id: <20241111112150.3756529-6-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20241111112150.3756529-1-john.g.garry@oracle.com>
References: <20241111112150.3756529-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0460.namprd03.prod.outlook.com
 (2603:10b6:408:139::15) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH0PR10MB5194:EE_
X-MS-Office365-Filtering-Correlation-Id: 423fc276-2d64-4e48-f236-08dd0243185f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5AF7vbeC7b2+1zkOe81FQvVy0tpq7VlAlK6RX9cTdl6W8/2a6BQ3WBPaHY/M?=
 =?us-ascii?Q?T62Y2GfnnsbYW4ed3pKNKu2mH40Kw5ZgtV6M4Bup0tcakbuzgUq80JRWeply?=
 =?us-ascii?Q?BnRyJJ+nHLmmFokq0tGZ6BLVypjA68pSVr0sHmNjzI2tgpSrNPXbCnicIldI?=
 =?us-ascii?Q?38L9f5epkJm4SA4Bp7VB+Qnzrvo2yKnWE+xFbaE1+27/ezkZjlxIVRToNs3T?=
 =?us-ascii?Q?mMBU6E88g7WfQ4Y/7dpvpCIdlYoDnKgy+fO1cXXnWTrxuCktfuVKOPcV9N7v?=
 =?us-ascii?Q?ayB1ScFwSAArRDVFphkMe8QCHZgLrjQxzf8yToJ1OpksMxjPHdP6JorSHnIt?=
 =?us-ascii?Q?1fpjMxQQjHgrFA4y/TUhNcSj7aMb+4IX8h4IwI0Yjsx2RVg6jH7SftFMFvpf?=
 =?us-ascii?Q?SAm8ixz6Vgk8crb9pF+C4jE6YHxjD/0HUvztUDUcQt+0QTwQ/wAwgoZOO/cz?=
 =?us-ascii?Q?QEF5/9u3OhDLjU7Hdol4YVC6b39MgEhxDFK7MaAfL7qyS61uGg25DSp1Z1CD?=
 =?us-ascii?Q?SaZBfmnjw3BGiN8Zk5oRNGUCD0b+z+z8FypylhO2gqTo245x9RBWSV2G+6Yb?=
 =?us-ascii?Q?Vo0jEV8a2OImJ6OnRnpK4JJtNpIGN8mwnI8jp2OGdpvlI/dxBhQ/St+/1Rji?=
 =?us-ascii?Q?d7mvvSaNiER+MNfIH3q+sQLiKHu/nfuAVm3NqdotOmgox50/t0ESTrQkjDCe?=
 =?us-ascii?Q?QF81v53tWjx9EHIOw/3NmxlMd7tuIusroR5h+3SrYt6q+VF/vbuArygSYW8X?=
 =?us-ascii?Q?ryabooNQoRetKsji/19FkWKZNyXcQhd/vizR7b8qEWjiUkz+yyIjxomA/k2e?=
 =?us-ascii?Q?FjGadQ59IxFup3H09/+KCs6blYyw+Km97HVLwwyeFZHywlXIVt9g4OdxGWWv?=
 =?us-ascii?Q?UAo+CIQj5V18iMDvZ6wf8wFuZG8yjON7IyvP2cDmeFtO47yrgOZVr4+3reyi?=
 =?us-ascii?Q?+z2xQ53iRCIamqOE75hdmJQDYxhHqRW/Kq0jDelmqdDmTT7X571U7vgCXMLr?=
 =?us-ascii?Q?etciQx+O+cXFLUe+3unnK+IS5f/HNS8mbb+dAlGvrSh9+vZobPVfKQVs8p/l?=
 =?us-ascii?Q?amCLfW725u7XY/uXO0KWL9JaGWcC2E89QPaw+S3BtppTCU/L41q/gS+4vxAl?=
 =?us-ascii?Q?oSsEcQU8JtMaAy6IAIFKEcsmgNjEIArxpdnXnAuADsmdr1XpxkHmNT+LZawa?=
 =?us-ascii?Q?DR0x8ztgTpEKKbnTju4BUv9oeGOl94zcDV0hhShWNngZIyKd/XLGA8x8EU+4?=
 =?us-ascii?Q?a2BfewPLviKRdCYskG++Su7x53MQXKv+NsGUSOSP6Hxu5dbZPZYJWc58z6NI?=
 =?us-ascii?Q?Jm3ckwWoIJRB0X2j55c38EaR?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7bRY0OONuFdxsnsU9EqXWTFAHYICFK+yD16VEol91SbW9Bm0GKzLZ0da4Rhf?=
 =?us-ascii?Q?ygF+HGSSgmzFWgqN4b4B+HUZsIgBKVOIK/k4DSpFjXlO2x8sX8Yzl63hC1w2?=
 =?us-ascii?Q?PKHXaKhz8kAXAUm0fRe/wqU3DcuK8Cj2ryEextDbutKkMrXajTDq5aOP1QW1?=
 =?us-ascii?Q?tIB5QBfhRzNEEHbyOnHlga8598CAWSo2oZAvn04t4mFQB74fLiDSWfbGdu30?=
 =?us-ascii?Q?BjuxIYuj/PavLRcIZGlYccop4syXagaXAw25x1desnpL0WW7u+zlyONyI1i5?=
 =?us-ascii?Q?wVvktTc7FLx51dDBb1o3i+eVpZJKeKFl2Pr2719n7F/9SujJs669SjRqkNWD?=
 =?us-ascii?Q?GItPhh2plRIdFefxMorOKqnuBD/6t1IqLuH1gjNNi+ZNCHe9NrFCYqjXZiF9?=
 =?us-ascii?Q?V/9AFcck7D5j1gdri9Gmybc7hP6YE60+vOKkMkN9EJmxAYCEhZrLrYsApv/I?=
 =?us-ascii?Q?Ogb6XRjQvKqqfRgpyb/nXCiStEera7Uft7hheT2uvy3WC3oTkHCGTAaTAOnk?=
 =?us-ascii?Q?74uq4Zif5EZDG7re1mqhJ5U3CBw+2k+oyQO4GN6JDcTP1kLTckQUmUt5XAuP?=
 =?us-ascii?Q?ENjrBaGLaV4M7yuCD+H4l4yTpkGQAisz+dvpCbNKRnkCxPeNQ3tdShwDYz89?=
 =?us-ascii?Q?3Ry4fYKt9dK2iXiCALy9HcX4pxACR68doQ9ZAQiAceezZ4+aN0UphEt8t8xi?=
 =?us-ascii?Q?DLlP7LFgE9NVICetg6shZ3qXqIcXeeKtPAfVPx0QFnWNtVcL9uDScanXeqzq?=
 =?us-ascii?Q?STDMj5ufJMloRL5RrAVN86P6IpFFACV11taLRtwMgUUQPpRAAueAskxBkpfS?=
 =?us-ascii?Q?aV00xBnxZ68PHlNYMzg75z0fuDkXe7xEEEr3eStTyC2GcLsU7tOBElUiEFhg?=
 =?us-ascii?Q?TOd8JOsDccIzkrIk1XJ8fKc3MUims8Zdj45rWfLSrsnSZpiChkE/YmFMdc1/?=
 =?us-ascii?Q?h3g3aDofn36mbPCR0z3OXfVtIckiXr+1qAi5fHTMxVNG6w2j1AdIS9rdueef?=
 =?us-ascii?Q?LwH99vDIFCPYujZk+DF7lQA2VYTDZbtqKYxgip33Il8QCzW2pJMTEeVPaTg4?=
 =?us-ascii?Q?wqgsqoLqX0VKSKKSksOeXUT9Uyg/OXnAosgmOlJSbf0SUCBhKto5WEJvcwiS?=
 =?us-ascii?Q?FgF3NWRlpvisd3V9t/480tsxEQE2XCbwUQaxwOCGkrq0aJ0yLxZqZFX3QTDS?=
 =?us-ascii?Q?0VF4g5egLzCNGov/bWQFMK1Qt570zAeOWuxssh+6HmV4KKTQnBRIKZqi47rr?=
 =?us-ascii?Q?mFGwI+0XeF/bAUervmGx1rGjFlrGTbDDTN0zM0kw1DCr9+aMOQsGAjTckZN6?=
 =?us-ascii?Q?Mp+Am2/pF0dLJ6US2FN9HGppeq2QmHdd3XAHUpLZevFDtbqTb8MEexZsAzGZ?=
 =?us-ascii?Q?jNmpysm8zJtzaToRO2qaJ9jHDyiOAJj45ouyCxvkTBLozMqMR38sVzuzpyBb?=
 =?us-ascii?Q?sVOo1o94zKcVe4dNQ56JW0J0cd+FInpa1YA75V/BNr+JFeGMiK8EKpTH4G4b?=
 =?us-ascii?Q?tMJqSmCly+iLcpFepUuQgz4mM/bRPDCOMMw/LO75gNPI93CwgL6QkgTLV5WB?=
 =?us-ascii?Q?9iF8SxplXIvSabh8OsPZb6qxKRR5bMMGzWnfw3S0wWc9W36b8DxTrrOoFQ1G?=
 =?us-ascii?Q?bw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HBmzIA29tE5L2DaLqYyRimu1vh0zlDECFWCLkjPR9X9ennA9w64eHudcesObN3IThKHOPFPsCiazdvP2BBuKrWtTBmXa74ZtEeYkhfRLz6BiDoYp6kqSh44ACqK/eBR75/xzgD3HFHx4b1TRjViniuhHfuYOg3RD5W9FRQpm+7vWg5P3R5D1FW3MgcEM1xBQPlwZzMQGLogstA4WRp6jnQ4fDcbPO0ENDwzjvAm/+HMUaidq+m5IinEsQH64wQ/KBcMiM1KhdfGvyqbnBZG1vYjN8x/HSoYduuIdh5svnDdoSsKVfQLLxpHTJAWnafxf1avaSEi6uBdDprIIMPQPFr0sIbrKdBkinVkdWNbI5pLT663mkimvqVKKMWcvp3VKGuXKiuqSZk0IZ4Q7sAOv92aOim7Ao4prsmNXSO1JFwQtrKyGH4hK8lHgfVW4wwes3k7IvExCouGOl6VpKy7GqVUCwph1DUJ5zO/RDh4w8kzkrN2CeoUun4NC3BE2MZyz75Bie12X3/SxrN2H1htYAwELkr0FCYpGSHwu7ejneAI4Zr09wu1dT6QqkMYArMidGIW3KQdBZSR42kWpV76gQx/ULlgdTTKiCfMltRUz7XA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 423fc276-2d64-4e48-f236-08dd0243185f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2024 11:22:15.2688
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Eyd7QaZBdTMjzDV+ZvzRIKVp47jzVlnF8xAmsJoxErfZ0XoZ8owQKyKaNJVA37UKHYHmch4xb5ReDEGpnSRizw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5194
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-11_08,2024-11-08_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 spamscore=0 bulkscore=0 phishscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411110095
X-Proofpoint-GUID: pMskVLsYYjv4_qkj2VBxVZQKOVNn4b5J
X-Proofpoint-ORIG-GUID: pMskVLsYYjv4_qkj2VBxVZQKOVNn4b5J

Add proper bio_split() error handling. For any error, call
raid_end_bio_io() and return.

For the case of an in the write path, we need to undo the increment in
the rdev pending count and NULLify the r1_bio->bios[] pointers.

For read path failure, we need to undo rdev pending count increment from
the earlier read_balance() call.

Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/md/raid1.c | 33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index cd3e94dceabc..a5adf08ee174 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1322,7 +1322,7 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 	const enum req_op op = bio_op(bio);
 	const blk_opf_t do_sync = bio->bi_opf & REQ_SYNC;
 	int max_sectors;
-	int rdisk;
+	int rdisk, error;
 	bool r1bio_existed = !!r1_bio;
 
 	/*
@@ -1383,6 +1383,11 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 	if (max_sectors < bio_sectors(bio)) {
 		struct bio *split = bio_split(bio, max_sectors,
 					      gfp, &conf->bio_split);
+
+		if (IS_ERR(split)) {
+			error = PTR_ERR(split);
+			goto err_handle;
+		}
 		bio_chain(split, bio);
 		submit_bio_noacct(bio);
 		bio = split;
@@ -1410,6 +1415,13 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 	read_bio->bi_private = r1_bio;
 	mddev_trace_remap(mddev, read_bio, r1_bio->sector);
 	submit_bio_noacct(read_bio);
+	return;
+
+err_handle:
+	atomic_dec(&mirror->rdev->nr_pending);
+	bio->bi_status = errno_to_blk_status(error);
+	set_bit(R1BIO_Uptodate, &r1_bio->state);
+	raid_end_bio_io(r1_bio);
 }
 
 static bool wait_blocked_rdev(struct mddev *mddev, struct bio *bio)
@@ -1451,7 +1463,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 {
 	struct r1conf *conf = mddev->private;
 	struct r1bio *r1_bio;
-	int i, disks;
+	int i, disks, k, error;
 	unsigned long flags;
 	int first_clone;
 	int max_sectors;
@@ -1579,6 +1591,11 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 	if (max_sectors < bio_sectors(bio)) {
 		struct bio *split = bio_split(bio, max_sectors,
 					      GFP_NOIO, &conf->bio_split);
+
+		if (IS_ERR(split)) {
+			error = PTR_ERR(split);
+			goto err_handle;
+		}
 		bio_chain(split, bio);
 		submit_bio_noacct(bio);
 		bio = split;
@@ -1663,6 +1680,18 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 
 	/* In case raid1d snuck in to freeze_array */
 	wake_up_barrier(conf);
+	return;
+err_handle:
+	for (k = 0; k < i; k++) {
+		if (r1_bio->bios[k]) {
+			rdev_dec_pending(conf->mirrors[k].rdev, mddev);
+			r1_bio->bios[k] = NULL;
+		}
+	}
+
+	bio->bi_status = errno_to_blk_status(error);
+	set_bit(R1BIO_Uptodate, &r1_bio->state);
+	raid_end_bio_io(r1_bio);
 }
 
 static bool raid1_make_request(struct mddev *mddev, struct bio *bio)
-- 
2.31.1

