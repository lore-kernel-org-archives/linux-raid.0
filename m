Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1BF31DDA1B;
	Mon, 28 Oct 2024 15:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730129285; cv=fail; b=Qdmb2pYsy2gq/E12rq82T0jrhBOzQKVn0RKfFAIhaYVmkMBviHyi9s9JOX61zCsLA/oLL2qBLoar36W7XafJoLFwqZNzKhmIyrofofHCXmK5EYK7CfWIfb/lmPueQbOfhbgOhqDMMtk5XhdBd3UNju9QM5F0B7mNW0g2xhCDlX0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730129285; c=relaxed/simple;
	bh=AboCSbDj81va4V0uGz2nPLf8Kg+k+uwjVXq/ZJCFxKk=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=bLY5Msprivfu3kmyEQ7Pv54PgopIfkZo7CChJgeof/S++khXQfKD+XwzJQ4seiae1VtU0af0O/ns9tjFT6iS6804VKsgzOKOMqmlWy19e8p8IWDceAZXnEkQVJemmhW71EPu14D12ui1Y0JP+miF6CEzojWVtnjI8d1w3re2wwY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YboRh6Cl; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=QmpzuKXY; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YboRh6Cl";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="QmpzuKXY"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49SEtdIK016733;
	Mon, 28 Oct 2024 15:27:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2023-11-20; bh=M8D96QJf6Ikjbhe/
	A4+r1434ZGXvGUHDV51tY+zCk9k=; b=YboRh6ClXBnzmwNMWxtH910nfTnd9rEF
	CzyZVn1PMtlgBPuixJmdoIb/94zgu/fbLz6IQ36q1uIiIM+iumTINQAdmL2KjJUL
	HPuVuDhxzYTcjD1unUZGhPk9pTB0J9LMTTkqKr3uLnWAwv8o+0XGMVKJfUphAold
	I2m+egNBCoRa+LLU4DwMwNAC1nZPypDHxJ+w0P6Xz75nmi7qFP4mKU/ItvVKZdiA
	Frygp17OojdZEWOTn9orYRNO4tzkfJrl4faCVYqSpX0Et9tIIugfFJNxW5EWpbkK
	9InQqPN6jGyRsvcrh7DvK2Uy8wY/j1RxKmZfcNedTNdF2CBaCHymeA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42grc8u5r3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Oct 2024 15:27:45 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49SEEpN2004866;
	Mon, 28 Oct 2024 15:27:45 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42jb2spn0n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Oct 2024 15:27:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hlqJDXTYg8hN1Dj05G+yaZ9zx52FsrumiTfhpkX9nu6Z6egNr5lkIVcpEmajwbKhYYwnX3mLHEsfh2EXBSvd/DXG7Vgd27+L90T9z0uM4y5/1mQ0BnEjLCN5FKVNZbNSEfDKlz1Ob9vyECvXT2q93uK3dmX6iHpUMzZ1w8zSZW5EE4nhConZV0fraT7W1+8xhMTlrlrJW+elLCg14HbS+h0JLg/6yL7eZmu/arBz5IlTEVCbXyuQyf0+uwAepRh5Wird2qOl5J4qahj1yjUEeYoBZLZ3Cf2xGQbzJnkfBX1tGB7g9aGq+b/bTIDs6VgHx/HklNYVfpPLwQeDSjDBSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M8D96QJf6Ikjbhe/A4+r1434ZGXvGUHDV51tY+zCk9k=;
 b=CLbFCrz9tANRY1xkT92p6rV5WkojDzg7AiJuJi/GK+J9ZrkmshNNgDXWqAFF0rHcfabqgl4VrVNsC0mQ2wAOYGD8InRqN8419gAzX/gWbG5hhkd4fmvvuud/iCJEdLM4CMgIeS8ZmJ7dLongR4xi/GvSPnzbsRWXIyXFz1fox+XwtytaHQYBMJiDqrwYi4V/FgfXcCQxTFPDJijgR4tz7XO7IMpGLosccpuKloRY+9THN+0vDl/8FYnKZbaso5Z08rj6BtJyXESeTkUOq6ou/7tfAZ4US3EWf4Wzk9BCsVXCN6Dx/wqTfaVc+67rkOq90cmKyM56rIdvpce0Sw9KIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M8D96QJf6Ikjbhe/A4+r1434ZGXvGUHDV51tY+zCk9k=;
 b=QmpzuKXYn2UFvluaVRyRvFLFq8RFe6nRBSgcZB099eeiI++9PDIsL+xYe4xZ1R+7IpjR1Zpy714nn5GXKkVNslFJ7vYYKRdQLdXZOMkOa7KbydjuzmHHZCXNpyxusAXsB1D60AahOCDnKBsgb6L8/WPrCymilE4Frf4ssMb/a5I=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DM6PR10MB4170.namprd10.prod.outlook.com (2603:10b6:5:213::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.27; Mon, 28 Oct
 2024 15:27:43 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8093.024; Mon, 28 Oct 2024
 15:27:43 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, hch@lst.de
Cc: martin.petersen@oracle.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hare@suse.de,
        Johannes.Thumshirn@wdc.com, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 0/7] bio_split() error handling rework
Date: Mon, 28 Oct 2024 15:27:23 +0000
Message-Id: <20241028152730.3377030-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0124.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::9) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DM6PR10MB4170:EE_
X-MS-Office365-Filtering-Correlation-Id: 87a5cebb-1e74-4e0a-a271-08dcf76510f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?x5Yr9VeAtzzTf/oZD/ZV3iPK1BKaV5SFsaY/ZFYIu65L/Xz8BCBSwAk0b4fs?=
 =?us-ascii?Q?vc4Vc0GF57FN0BWltAmNyrsZAhdkAGOjbkX2vK6Kt4B+6wRbfX9gqj3Kw/vk?=
 =?us-ascii?Q?94Kp/PBPff/NsPQnpCN6Oal79DYsB84zElekRkA1qq5V7WJ+a3lZFVYmlChE?=
 =?us-ascii?Q?zu36JuEZWwfulFqDpBLBu79aDFW8MG5LmbIEJJAtsQ6UR1xf8s8cMEVmwHfT?=
 =?us-ascii?Q?GNIheq1pqFfpUB/n0TY7PNnKU8FZIKMSidE/zzW7GnJmDmTXw3xwl0pqXkcC?=
 =?us-ascii?Q?TQpnNimv3+IVO19VNLfQc5xAVtd4g14TNfFHUsg8oLPKjjXLSsaLBaNF76Vb?=
 =?us-ascii?Q?Ypli21Qh7tGOvVtJ9pzfsnbg+Qpttqg2roSn8ux7gQKQMucc2anMakiWPhPI?=
 =?us-ascii?Q?4zgCFJplxz9p3exzm+s634qh8Fk5gioKJ4wQWjjr2e8SpFjzTH89COJOayDo?=
 =?us-ascii?Q?HZymkyM089ZRNhxKHsH6gGnO8SOlkpDtNh9zbCyIH2zKMNzRQRqu4ar6JpXh?=
 =?us-ascii?Q?pG6nUzfcbdXJgWQQuaXiJrDBFtTJBGuXs7Rd7YYqedrd9kyUaEk6BZuO0UuM?=
 =?us-ascii?Q?ehu6WfqYUNnu2CI0tPreI/Rr49gGYPnazpkTg+JykwXyNbm2p4GuyEtTfcL/?=
 =?us-ascii?Q?ZRCKsNvKjzHmbW9cUqO4jat8v87+Hpl+ORvI0Pm0BVvCU3UD4cSqXh5DwmeQ?=
 =?us-ascii?Q?x2V8ZUqmIXRzsjJnwNM/7dGh2i83eDF54FFhcgnizY63V/pplE++9/k550mY?=
 =?us-ascii?Q?l5xfC/OoVGjgZ5QT6b2MO9pQswJAv9z82swc8uDFA3ZNGqjB9Xa7qScL5bqV?=
 =?us-ascii?Q?RQtjmMskfh5PpTkvkM38zTjm6bcHpCR+sB/zNx+cXQU7HqPqSRyg6MqFK8G7?=
 =?us-ascii?Q?LM2HGbQoGhjwVbYvoa7hwI80XHgh4KYrjPlOv1TEVztR2jSQGcdtKar9kzh2?=
 =?us-ascii?Q?xfGzqFWivOBF629pfbgzvDOErDNqXruQ7bfXE1PGWgp969kK3t8nciAp0SAy?=
 =?us-ascii?Q?zKWhcnVYeFeA6glkFmCeTdfkEL6ZHfvJ+uvVTI9VwiW3lBqwDpTfYLS1nzf6?=
 =?us-ascii?Q?n3TfTazyUrTeKKCEOjmZnVfquHVN/Q6PCKjCYWPW9cA+PrCe3Yd3QT6qrx+O?=
 =?us-ascii?Q?7vmCrAjjkgsznmNSLXqW9yz+MWFrhH9wqDj8g3Jfa6AoZIfA+a8XiU2D8muq?=
 =?us-ascii?Q?VzlJ6UekBgOhIH4rpXZK+gw7KXq0E9oyFIYhJ8+fnxn6OIRXVDZYmen3ZHSZ?=
 =?us-ascii?Q?S3MRRCNl5ioy+rgSygm9T/vLetUmm4ayxywFVjokbXdIUWn/9zDf2QQpRWIR?=
 =?us-ascii?Q?i+RvBwhcstc/U45alVEiQ6zu?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hVO361Aa4mZ6Eo4WHMHDqi2qGH1vwAaEVirUl8mG11+XWyfzhkxo+cXMlF8g?=
 =?us-ascii?Q?NyW45E8lCHAYTjcpPTZ1pXxY4dDVvnffkw5ndr0o273a+JcV8/uspby//N0P?=
 =?us-ascii?Q?y7wXMRf7bStamXZi0q0sgZMOFUSUnUHtQ4oPkIIGnGovOjjPdfkL4GTtYG2T?=
 =?us-ascii?Q?MgQ6M4B4zjIHSX84ijdCtPn+OjgUcn4kLwKk9TeUGMwX97N9DbFx/p6NGXyL?=
 =?us-ascii?Q?98Vdvhj/8tqvPFVgoCoVUFNjXQLW9e61Fj6p79BD9L2UDlKmkXSw/GUP3MWa?=
 =?us-ascii?Q?NIzn4r1umHO7ZW+Z70gnv4tcuh1hCfsCXudwRoQZ/ojfNgq1+uaVSkPt2lVJ?=
 =?us-ascii?Q?uPvJfCsSJij8sQS8+miEBwak+gtOCYDrB6BvkV+3He6OnJfOQcn8XvSW5O9C?=
 =?us-ascii?Q?j0fE/ThJjYh0/TdgK83OX+Xl3e6RcSZcmZl7Y5ufD7dQDqup46rPTjf8IfpK?=
 =?us-ascii?Q?JoVD2wPzz+bt0sYMzkVSmQ2QqL8iwlh/aMTe5pXybOzZh8pp840eTc04Fto6?=
 =?us-ascii?Q?GP7WbrZRz32FSHsEMTHCJUEOtbVz+w/IlnsD96yAkaph/0XZqv7le0ogL2JU?=
 =?us-ascii?Q?gmhmJZmOzygr/yGryUNzJ6VQe0W4tnJlTV4wkx+zBWEiM6n+AkDYLqpLHkyL?=
 =?us-ascii?Q?vUrbCUpkzvRK1BjsqRgbbKOjBNUhmRv3xLBgdy0WXYygqDoijQHqUM844rPp?=
 =?us-ascii?Q?DY2RzqBgfQkZSL5dsGzcgHk7Mq7qg0VY5dDZW4xKJ84Uq0oyOQYAqnczwJ/o?=
 =?us-ascii?Q?d7AUKr6F/1K5C5bb5ttSCYmpcFRjRaBWIOM5HDo5GgRJvslF5b+zCDK9372O?=
 =?us-ascii?Q?pa0lP+tg49CxNWabijcDTwcQkwB1eBa+xAebWRQLTjfqfdAzr1jg2pGa3az/?=
 =?us-ascii?Q?tig+kvtY8QDN/WcAjk7BKJQ37ezIRuwyU0Erb1h3ptmeitushV0gu1lW6bYk?=
 =?us-ascii?Q?TWYiu6Jo9eU1T8uyYozBm5YC4IXM5Xbdnm8yk2ric0tPa8Wp+HK6+O4R0h2X?=
 =?us-ascii?Q?acMRwLqI0COJb45ximPPasdKrbTsO1MeknL4S83v1DxJfwXARUms7hM8e54k?=
 =?us-ascii?Q?XCQWLr/typV8Euv/WCD4LCwWrzjChEEAFbpv59A008j9qf78bSgXFUZderSA?=
 =?us-ascii?Q?RzJKonIdC/B0O2ASxiT0YtH2bAiQN+uuxHmJoKVL6oplA6rcOGgBSZjBmec0?=
 =?us-ascii?Q?wKEC6Kmkc9TNMNDY7KBRSoY896Kfb3ro/hUspuoMABjtaEJGeOGcBiWfgyCp?=
 =?us-ascii?Q?kCXnPjQmKpfZGORoH6FyBczpgKEF+VntQLQI0uwLEZogpEadY491k+nlRwtz?=
 =?us-ascii?Q?KsTjsZpF8IIMTrMcOE3zPz5i8yyB9H4AaQGageTMgqDxgnsI3lehWE4XCfz4?=
 =?us-ascii?Q?brffijE4EE4twVSXy87jmFzGWaW5456txkQNTaZw69pnjzzHcxxR+/0xobRp?=
 =?us-ascii?Q?rR0AkPHR3QSgQS4VZRfkH21DMkyZU537J1i/UQ4FL9sKAUl7pYdmn77HqN57?=
 =?us-ascii?Q?UfDDzq+z5Wz1DuVAX4kdAAcdzSJ6FsK1wB1N540oNfhYsK9qrplbkHNRuW1e?=
 =?us-ascii?Q?CoWPVjRaIHPsLG5FxFdv8t23fuypdHO7LFDcfCM1eEEu8KQpP6XFiAerR2lw?=
 =?us-ascii?Q?Dg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	yhf3MAvFQJOxrqkqOIp9B0F+7t/ewhXA/2/pBwtcOtFQ53myrOb3hBDawoxyMdTIxjBh4NvP8f7Y+PJAgiL6hXDbEQgctQ2z87g7cy8VOZV2wJMqZufEOrkZruaomTnvtC5FyJx+x1yc2tZZRwTZVdinzxl8cvDSYv1VHm7iun9F/gT1BVfEGoJHLBFwOUOC5Y0Z6HKTsiV4m+6fwC2A+vckLcXAIDaanqbdMPyvUl7/HavoiRtDgmKA3Mg5SUtL9n/D6F6xZx8T8M0ri4t3wWkPg3P+uhj6re0ETX2GxoEaApcVHET1oKgfYxu/VVnovcY25gb6yYm8RqoMHhdr3uVsy6Zk6TRTMPoMgy26Zm+mXO2r7H1zN43WiqKl7mqNlbciU/eFO0fQ6gN4Vm5cgTod0fx+PQyhb0X9gJOz3ZWwAMywvjBhBiKhU+z8I7kSe6cnD7nAhf8S5hPMaASfzbwL8xePz6qU6EDtD9UmHqlVG0s72PjYjqm5HGmWK1jykb7gtqkiMKIyiUVXCg06HLeaKUMh25VBgXHFr7SHEJW87MOX7/n5SxzmKiB31D8ocHCT/ZFpiGcKByiA3eWv4T7fOOqdXFD/fZADVmQvxvY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87a5cebb-1e74-4e0a-a271-08dcf76510f9
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2024 15:27:42.9663
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dIpo/UnmcvE28W7GQ5I2jTI62L0JNNr3NNnJPhXgahfO5/hxgLvI9CuBLdhs8WowfbQ+qlS1af6zDB6YKu2IdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4170
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-28_04,2024-10-28_02,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 bulkscore=0
 adultscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410280123
X-Proofpoint-GUID: LiodT0djtVeOmBzPYw7Q7vUoSoQHjGwT
X-Proofpoint-ORIG-GUID: LiodT0djtVeOmBzPYw7Q7vUoSoQHjGwT



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

The motivator for this series was initial md RAID atomic write support in
https://lore.kernel.org/linux-block/21f19b4b-4b83-4ca2-a93b-0a433741fd26@oracle.com/

There I wanted to ensure that we don't split an atomic write bio, and it
made more sense to handle this in bio_split() (instead of the bio_split()
caller).

Based on f1be1788a32e (block/for-6.13/block) block: model freeze & enter
queue as lock for supporting lockdep

Changes since RFC:
- proper handling to end the raid bio in all cases, and also pass back
  proper error code (Kuai)
- Add WARN_ON_ERROR in bio_split() (Johannes, Christoph)
- Add small patch to use BLK_STS_OK in bio_init()
- Change bio_submit_split() error path (Christoph)

John Garry (7):
  block: Use BLK_STS_OK in bio_init()
  block: Rework bio_split() return value
  block: Error an attempt to split an atomic write in bio_split()
  block: Handle bio_split() errors in bio_submit_split()
  md/raid0: Handle bio_split() errors
  md/raid1: Handle bio_split() errors
  md/raid10: Handle bio_split() errors

 block/bio.c                 | 16 +++++++++----
 block/blk-crypto-fallback.c |  2 +-
 block/blk-merge.c           | 15 ++++++++----
 drivers/md/raid0.c          | 12 ++++++++++
 drivers/md/raid1.c          | 32 +++++++++++++++++++++++--
 drivers/md/raid10.c         | 47 ++++++++++++++++++++++++++++++++++++-
 6 files changed, 110 insertions(+), 14 deletions(-)

-- 
2.31.1

