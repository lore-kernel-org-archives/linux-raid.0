Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BED51A4F2D
	for <linux-raid@vger.kernel.org>; Fri,  4 Apr 2025 21:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743803758; cv=fail; b=YFBoKKgbZ4u2ydQp9j/r7qbYHC+jQ7BiWGn11rBxnRfXvAcbdDgFM8MgTbmreZEs/3zCNXt6+OCygB79AuA79E+W/n29SNUW/I64lYjZX+U8WqqCFNUdU+OGogkNry+IjnkBQOZlSyf25I7VRMcCc/yRn8iZw3rMlTpG44jpJcY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743803758; c=relaxed/simple;
	bh=6+FF7HqJMcQnMxbp6geHwR/Dv97GSshDnwd+eL2bfTY=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=YcnVhz/Og3m1+ATbNPxtr7GvdaPvi21JGqvo4eDCW1j770GRQDXr5pOnCsfrEZ37/5wQXSZp8nK3dCnG+51K3Ft75M1i8pG7vNmNCEfM7zilDZhvHd8RP8WARiqQnZRd04Yd4TJBlrS3MG1ZNKpuIA2V7N2s+nSek5Wqfa+9GRI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TFl9Xhts; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=XhRbg00k; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TFl9Xhts";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="XhRbg00k"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 534L4HGr022750
	for <linux-raid@vger.kernel.org>; Fri, 4 Apr 2025 21:55:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2023-11-20; bh=6+FF7HqJMcQnMxbp
	6geHwR/Dv97GSshDnwd+eL2bfTY=; b=TFl9XhtslDNw406p0f8zIte/hVPGNdfN
	yL+Z9qUn11rCJi1AAgCzcvvQIdlFz8hMppiRc4JXoZIYXSKUuan4CpA8eQFP1pbk
	/gzjdn9n4FPm5bFmkAv5BwKkG/NexG28hPc2gPC5GyHyH6V3obdJIJVZ1+otg5Av
	2IfVTUC9QdOKnjJH73g8phLzEaWHCQPrd8XEFadabR62eZlYGB1HBYK+Ih+MMvTx
	unFp86uCwU7J1UAFlsQ7DJUaF9XbQ84ssfEy+7uWKxgkYgAKnvypP/T0H+H3uvhF
	uuAQjp1kJaKFi6NDnVNstRED/aPY/k/od3dVFHcOxGyRDAiAoafV/Q==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45p8r9qrpu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-raid@vger.kernel.org>; Fri, 04 Apr 2025 21:55:55 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 534KJ3WK017552
	for <linux-raid@vger.kernel.org>; Fri, 4 Apr 2025 21:55:54 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2048.outbound.protection.outlook.com [104.47.55.48])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45t2ptv84d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-raid@vger.kernel.org>; Fri, 04 Apr 2025 21:55:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sQYgovM/BOp6ngFyLqg0r3dq1omRIyguMU0mXX7y5xusSgca07mKZ+FWkGnMghZ4p2OvP5dcYLaOlanK8DXpYLi/B5BkNAlLSrKtyRWIQVDIwSVXtpR9qFHmT2M94pnEGtpeN/Ro8PGUgBWo7jiwQzgDXYru+DEn3n2u4AHTkxXgXxRXxfnzwJMC9HaefirOr1lZmJyYkws8uxE5lOPZvkz/LPIizOB3xa1ewF97ZbZPlodALvVc/wNvZBlnX6zBkQUER1yobq+FCBNPgjh2SLXO6QiJ+IJOJhY6zdnFmPgjAxxai82MZX1v3JchOOTre/hdUu755cvknApmif7tTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6+FF7HqJMcQnMxbp6geHwR/Dv97GSshDnwd+eL2bfTY=;
 b=IIm3efBRJYjE8cm2nZ/17NRcf/psOgOr5UQ3NNKIyCJMlB+5IeWdwl2rKArzninKnt5RxBeSGUjWbwAhXym30FlPGcw4dqzINqtseHxRgIlOPrVAKLVfku03NalHPWb/1bm2VZ1AJwe+8vkzQhExXGXnObQ6vQCyEK3scxht3ixAKF0S5igvSx00fiNurTpHM3gJYjmefbTQZbcBAZYGSRdDZggDBcj7v7kYTBgjUYDJbYPOa+mQvVnxNvGmqG2k6yyvFvSv4XhGKA8tYLVAHFrkr+06fhQOffT5u4+1zwuDoZdkIPGazlGgS/O9a25NH6muAT3Kal4r/7wPV1TAxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6+FF7HqJMcQnMxbp6geHwR/Dv97GSshDnwd+eL2bfTY=;
 b=XhRbg00kC/6uHFnZGyag2dzQhONmTwkhJb6CLKVYIrrFNXnmkcL0GlDeT+rqyfkSS6G3qSo1wglNllLX9UY5xCT2rj+iKuzsEpyBoPljTo5dh4Dwor0g+DShFOcQfcq6hhTgenmy8v6RDH26QsVyVa/p+fOFwE6nXmxvd1daeCs=
Received: from PH7PR10MB6036.namprd10.prod.outlook.com (2603:10b6:510:1fc::8)
 by MW6PR10MB7638.namprd10.prod.outlook.com (2603:10b6:303:248::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.27; Fri, 4 Apr
 2025 21:55:51 +0000
Received: from PH7PR10MB6036.namprd10.prod.outlook.com
 ([fe80::47c9:9b93:78f6:17c1]) by PH7PR10MB6036.namprd10.prod.outlook.com
 ([fe80::47c9:9b93:78f6:17c1%3]) with mapi id 15.20.8583.043; Fri, 4 Apr 2025
 21:55:51 +0000
From: Richard Li <tianqi.li@oracle.com>
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Issue with IMSM RAID Not Reconstructing When Disks Reconnected in
 Specific Order
Thread-Topic: Issue with IMSM RAID Not Reconstructing When Disks Reconnected
 in Specific Order
Thread-Index: AQHbpawghoLi6RfsXkaj9nytl/39MA==
Date: Fri, 4 Apr 2025 21:55:51 +0000
Message-ID:
 <PH7PR10MB6036F9B61364E9FD9EC7E16C82A92@PH7PR10MB6036.namprd10.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR10MB6036:EE_|MW6PR10MB7638:EE_
x-ms-office365-filtering-correlation-id: 1e75f817-8395-43bb-cbb6-08dd73c3774d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?Windows-1252?Q?agE1cr+HZU6wiJ/vBcqfpgi3hpqPLmj7A0ek3QOreCawqNuTWHiKma9d?=
 =?Windows-1252?Q?sfeRUC/LeBn7dbpYi6oKZXbO8mo3V3mYvSPE2bVbjW04hIbcCv63FPJg?=
 =?Windows-1252?Q?ldCaGbiuD1Ag542QuOlS3Ofy2rDgJjw2hkMhfPy8Y7YsJ9rrhSJT+rU1?=
 =?Windows-1252?Q?WJvNMVH/5ype3NDJ9IMdvxXCaOAzsW/vwXCVDWg3JgfjA49fNuvSR8LH?=
 =?Windows-1252?Q?SAbLAmcHmsqb811pojZvlE7nBtQ6kZZAc+xdpktfUeDwdUKYVJk05ptK?=
 =?Windows-1252?Q?011OnMVIbWKbh+13S1nTFZOcNXbp9tbb2AcSvM02Vuo3WHXAqX8QekYV?=
 =?Windows-1252?Q?jkC9TKA5BlBo/9++UXAmge3qd5iUhSDg0l/8/EM8tQ59FYjrDqCeDyfi?=
 =?Windows-1252?Q?2IijaDMvuT5sD4/BvJ4XJYHr7cN6dXJBZ6KJxnb5ozyW5Wff9N9XRBOu?=
 =?Windows-1252?Q?MvWly0En7wNOAU/d1iXLBabVXsnqnZkHsJ3knirGQyVkkV4P1yry1eGb?=
 =?Windows-1252?Q?V8dt68hWl4eInNWOGkDstgFRlWak9pC4Jvf+vFQfQwUubAwza4K4Lbt+?=
 =?Windows-1252?Q?+ocmzOwE7DrBvSKpvGwgxBLGi/LXyDbVFv2kucj3uD07N/dR5VBgLS18?=
 =?Windows-1252?Q?bXXd8ZA2RVB2VNNYFGdr16zQ63XxDiE1qg7wkQDD2qXvzJyhBIO7hiJV?=
 =?Windows-1252?Q?DLDLvb5O6AgrMlKk33UQ99wLL+LX4grTermZOhLWRaJGDUMElycV9dzO?=
 =?Windows-1252?Q?rsHvkdvmXHDh4m1LaQh699KjQe/wgx9N445Oz8mLRYr4NtKgC9vd7dn1?=
 =?Windows-1252?Q?qmJjZUYeZCnVen5bgDwQnWsTHiEqMNFS8Zh78Wl0XSL8k7Cmn4ahlNId?=
 =?Windows-1252?Q?bl+MMChWKp1GQY3vBBnTH2RYeCHA4dx+vatxHU7Rl1TRfr+hchCCH/Dl?=
 =?Windows-1252?Q?wyvIrxC0E6TaLfpj3bbMs3tbPq+bQSeaMflYIjKjwZ5OkfXL+/p1No3o?=
 =?Windows-1252?Q?tMGZmJPdWnC0ZQfSoZon4oG9flZ6P8GNwLZzAU0hRbRsfz3UFmi2KQnu?=
 =?Windows-1252?Q?uwPnbRKdiZ1VAWueNFVg58nEwa7wlSDKzbztvkkMteaGlIaTkVUecw2x?=
 =?Windows-1252?Q?JXTa6kIupMUDC+Vx4vKXJYR9+3Cu3VNQWaxrYEjOy6gof/2LVHLR6m1O?=
 =?Windows-1252?Q?IGpPfVf2xGKr1MXTbdJTljOvNu0DaYbB1eDAvJnzi3qcYfEC5w5C/VKV?=
 =?Windows-1252?Q?pYpSxG+rn1/2pdbpKFzrETl2Y2ahIczpmchsLzrP1dbPkPiJJ6trLNtB?=
 =?Windows-1252?Q?Azs3ZAbZ1ropFiCG1VO9hdMB43NanPmgaetKaVN/WfFxYApaJdMbtyYY?=
 =?Windows-1252?Q?4tWUkRqT1cRQiK2q9ZJONB1fIrnfKX6YpoKihefjxo2QfYPsWBNWoYMi?=
 =?Windows-1252?Q?rtq75czAJVBa3/VDeGzkQk1UDyDbwVdEHeVsFqiAzdllF8HM7US/LqJ5?=
 =?Windows-1252?Q?Q48NinJuv3wemkObl3YmxyQKj4lbroD6agB8Ma/NOszi7TgxSegookud?=
 =?Windows-1252?Q?W82RDZfkpAb2YZ8i?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR10MB6036.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?Windows-1252?Q?+hyjH1My5VXqW5B3lLogaA5XLExNyJ1uqnr3hlO/u7jHflN+3jsG7KDl?=
 =?Windows-1252?Q?B/6DaAb8ATqz+A6C8bNfWzDGuAi3rBBWlDNa88BKIRjcymbSjADUiDfb?=
 =?Windows-1252?Q?7ErCLwXEyxJ1yeLk2LIC1ql11YhDhGHyowUI+725kNKB5sAL+oyU7/Lj?=
 =?Windows-1252?Q?VCxABK3UV/VIwP0NxF8qcmGgCEb0uWE6XHmvNYvWcr6pQF6dTGpDJ8bG?=
 =?Windows-1252?Q?UF6irPveL18Y5F7Ce03u4BsMNsuw++SZLpgi5ud8siU5CNPReR6qFcZy?=
 =?Windows-1252?Q?UhQqqKXF1IQ13xKn7EEMrlo/DMwpiu8NVe1UXeBNZZWF8/0u4epx2g9S?=
 =?Windows-1252?Q?33tjO392H6+bShs+Qptgc2G40n0SxG0UKenCIsvFa6KpuEwrOSH8G0Ir?=
 =?Windows-1252?Q?KfYaDD5/t1aZKfQ5fcgTEySttLA4puNzCP/uOGoDTmbwT/0IJeWghEkV?=
 =?Windows-1252?Q?OUBKqsyTgYEcoc8YlKBNOQDUZ/B6Utc4aG23PyB8vuxXc+PhTYTrFHgX?=
 =?Windows-1252?Q?U831dDcFwebHh3kH9ek7e58DJ4/F+Kh3EwOqVvFBgy6CvFu9RRkHkWxY?=
 =?Windows-1252?Q?O7/r1goPk4hc9yNsrjpBCBEyv8Th8QfDNjpDG5VOLq/euQDFi0vxKU+8?=
 =?Windows-1252?Q?3Y5rp8TNq1ZTUswIv4KzWk5lBe4X7lLajNUljFnEhaD1XJL5/L1j6goB?=
 =?Windows-1252?Q?DNlwx87DLoF7c+FaTOwJUIU5bJd0aVfHPLRb121tlwnP72D7dH/7Vqkz?=
 =?Windows-1252?Q?JN+4z6w+mWr6Zx/bY03cjm1fCiZUZ9PijaRyDhmPFu43nQu1EBIlay+r?=
 =?Windows-1252?Q?/Yuo5sDDfb+bRYmmYcEC7PeqraSTA8AQFRMnavqo1RNCamuT0mjjDNNF?=
 =?Windows-1252?Q?rEQbjmZzN0Sp/LWuZuehjlnG2EZqALDleb/5ieSM295TI5FI+EHNnXZs?=
 =?Windows-1252?Q?CzXfo7X/e8CUBN/p/yOSpl9SzoSFGIi50Bld7zZW9HgkeODxXsgzCKzG?=
 =?Windows-1252?Q?MckAnvBmJxzI4mxtu6vMzltlvpuAYgSmWLHMOKP5UFgrqGTt4djsosaf?=
 =?Windows-1252?Q?jxTPDqLmC8exuxCeB/RI6CytzcIGoIEqY8TqlGJhhco0v8N7ZM+8GX1M?=
 =?Windows-1252?Q?56S74igZZ6ciUZz+JjMq40jLhP/BqxDFKFIdBLv2ZX2AeGwgwdcm/H7K?=
 =?Windows-1252?Q?r5Y5cygT/KYoggQocSohYaVP4hlsotFr/jcq/9O/dlDr3hKVnGeaCjzt?=
 =?Windows-1252?Q?yZHsI3X9+AWxjO1+AVG1osxGutiz4YjlvWr1aLtIZS8x9VnaX5F1QWHn?=
 =?Windows-1252?Q?mAVuociY4vgXlzyM1/6Ski1eup6dZZv6LJCKiAvm04dry6EOXaHuYjhZ?=
 =?Windows-1252?Q?JAR9zuVMWyQIMIgX13vQfuGa0Jf4Fy6svZg856xVxmTsMxvKPGUjitQC?=
 =?Windows-1252?Q?b/M7w3McdOTwwufjtXt0ikLvoh6F0fOKy/1UJN/49QINc2JhpQplBugA?=
 =?Windows-1252?Q?TJNfnw/Oqh576aCYj9T5HWvEJwIxKvL2totFGAXni2UlDO7nZVwU4tQZ?=
 =?Windows-1252?Q?LFvFfb6rHLjP0OuekTjbweFjW7LcxnMkIAEooGjb/HDjKC04ACCEw26s?=
 =?Windows-1252?Q?lzyWwBLwIUwGXzpRx3y6Si1t7636zgZSVaaGHwEm6NpQVb1a5dLNxcVo?=
 =?Windows-1252?Q?hbiOADPT9/M=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	G4/vUMNY0rlOwkNCMzak3Wu/OVx4SjLKKJLamkGJTNzxVH8+P7KGh2olp2v6Xir7azFMF82y2Ja0NZinAXJvqLsEhnPLNCYqrv+ve774bLUZ0v19TyIUSXOhPuxTc/hsokVWh0lNHzW9OVZkfcKM8d5eVZYQbcOBcxJaIuFRqPmPX2Aoz5s/2q9A0Jowge26RZ2ByxtUfC7pWWW+0X0xk9Ze90iwtTZpiP1p9TpDproVfL47/7m9Nx41QFzOpY8+IxqnlXoG7NKGcJH+D3A9EmVKirQQca9RzV02iWdwC7zDYP8JlIPtIcUxcNMS5zMABQyhNPlRbTXxbQWwJEJKCAynrEcOh6BvZCU5+5lJunV+RKVn7EPl+UqF/GehlTVGga8cbwl5QsiUP68oEmSNsjWEbVsEw5pqs9OliF623wupnEmJH3eDpIwYMCDmkoajAjorK6aV0Vtg2yzyj0apcPPICvR7NPmNSTcSy7OlZtvKE8EuFlmEkJ1k37RBmkDF+p30jUb1FE10j86OX3lub5v5+fNjALjnn2g5tCtZckB0OTiQArJ1cOG7LfjbQFXWdMifA1nAE/eZTyOt2vWVanAXc4Sd+d5DXFV0nwz9qXE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR10MB6036.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e75f817-8395-43bb-cbb6-08dd73c3774d
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Apr 2025 21:55:51.3835
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2XA8qR/QQOSSk7NsiW33GblEZVXN4EA8hryYwBY7ZxBTsx01FMejK/rkl6YZfxy3UyX1PlfynaTwb3WfYBPOsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR10MB7638
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-04_09,2025-04-03_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2504040151
X-Proofpoint-GUID: Yq_oNqQrAfoIVipiK-Q0i9QBIQy6Dpyp
X-Proofpoint-ORIG-GUID: Yq_oNqQrAfoIVipiK-Q0i9QBIQy6Dpyp

Dear Linux RAID team,=0A=
 =0A=
I=92m encountering an issue with an IMSM-managed RAID configuration using t=
he lastest mdadm version from upstream, and I=92d appreciate any insight or=
 guidance you might have.=0A=
 =0A=
System Setup:=0A=
=0A=
Raid: IMSM=0A=
Raid level: raid1=0A=
Super container: imsm0 (/dev/md127)=0A=
Subarrays: /dev/md125 and /dev/md126=0A=
Underlying Disks: /dev/sda and /dev/sdb=0A=
 =0A=
Scenario:=0A=
=0A=
1. I unplugged both sda and sdb (in that order).=0A=
2. When I plugged sdb back first, followed by sda, the RAID container and i=
ts subarrays (md125, md126) were successfully reconstructed and showed corr=
ectly in /proc/mdstat.=0A=
3. However, if I plug sda back first, then sdb, the subarrays are not recon=
structed successfully and sda is missing from the subarrays, by checking /p=
roc/mdstat.=0A=
 =0A=
Could this behavior be related to how mdadm prioritizes metadata from the f=
irst available disk during IMSM assembly (in this case, the disk got unplug=
ged first had stale metadata and when it got plugged back first, it didn=92=
t pass certain checks so never got added back)? Is this a known issue or ex=
pected behavior with IMSM RAID?=0A=
 =0A=
I=92d be happy to provide logs or more detailed dumps if needed.=0A=
=0A=
Thank you for your time and for all the work on Linux RAID support.=0A=
 =0A=
Best,=0A=
Richard=
