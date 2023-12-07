Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="ALulslRz"
Received: from esa18.fujitsucc.c3s2.iphmx.com (esa18.fujitsucc.c3s2.iphmx.com [216.71.158.38])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5425A121
	for <linux-raid@vger.kernel.org>; Thu,  7 Dec 2023 01:55:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1701942933; x=1733478933;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Ax6ab+wQy3O/MiZQD96pwT5tDokF1jb/Le8MDFEe/ms=;
  b=ALulslRzewumGt2T20tWhgNUPc76Yrwyem5/VGqGFtNU2mowhTsmNUwi
   v/bXo4oe0iIGMeS1G6aiOInfymGQ7MHNr0rFWPhJpgH3sjD+k49U9VJ9c
   j1IkHKB7glQQhOgXyA7iM+dP/l+6tQ4ZN0tpCHKJeCjwcvVF5Vhe5ujb9
   +mS3T6uTfgHs7jlAFzcaiZsUGJ0No0VSWqvC0a4ssf7wnt9yjCDnyNw0u
   FBSy9KGxWmWL4zrsnyQI3xvELlz9nINRQOISY80clD9hZ18/RbW+y2bFG
   ZYvpem2qlP63SfeKq5cQ9qGW4Co+H8jH9jeJBbD0R9UGe5JbsH/NJRZjd
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10916"; a="108654426"
X-IronPort-AV: E=Sophos;i="6.04,256,1695654000"; 
   d="scan'208";a="108654426"
Received: from mail-tycjpn01lp2168.outbound.protection.outlook.com (HELO JPN01-TYC-obe.outbound.protection.outlook.com) ([104.47.23.168])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2023 18:55:28 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XsQb5H/SGp93GH3DnwhA/4daD79FSKiet9diygSDY0sIXZcpgweG0goswFkJ7sgg7eCUZ3TGrWDQdNWKldFxHIbaNaJO49TierYKHmbiZqUzk44Fr3Zb0/FWUmVBftAURfe/vy6oTocxeosP9CLRhHm0PaU99Kgjts+82SUCFeuj2UoXlY7i/FLQJ3GO7JXuxh6a3vSuJ69WnzgP7DB8p6GExqREsn5P+EPdLzOUq7x61Mv2IM7SBdwpkuovQsoQKpSCDKSPe4w0sQQDBlLeJtPMKJOdombjZCNVKS2lG/AMwwMO7Z9oqW15UGcwyvtO/Faytiy1TnPrbvTMD4cbFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HE/rSZBTj7IAaPAeQ0LnvxiDirkXz5XheMH7387zA3I=;
 b=m76X2IwJPSiQyvhbEzc5aXCxxc0ICQq309x5VtrrtpfEAWzfDXmIvvtK15QoP6HdUAQXdFHNetyTL1QvLMfc1+pyHEjzatAKQa8kAugc7csc6nP6ZB3jqK1nYfnW+QInqBWQG9Z8aVfNUEE4MQrh/tj6BIdQw7PndfJvxH0dAQaY04k4BrdMxeelb/fI98jYYzKe3G8O3J5sk10mch7HU/I58tdMYij9dkRivAWvJ0r7OAUxHeFX1EeiS65rT+g9fXnyxIcynV//xCBoD33VKP+biWxU09IszND+EWrypCb6aOBg8JK0K2+1+nBwIO9DJ0Q/nKyYFUuxvabguy0TPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from TYXPR01MB1647.jpnprd01.prod.outlook.com (2603:1096:403:11::11)
 by OSZPR01MB9500.jpnprd01.prod.outlook.com (2603:1096:604:1d0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.25; Thu, 7 Dec
 2023 09:55:24 +0000
Received: from TYXPR01MB1647.jpnprd01.prod.outlook.com
 ([fe80::effa:4982:39f9:c842]) by TYXPR01MB1647.jpnprd01.prod.outlook.com
 ([fe80::effa:4982:39f9:c842%6]) with mapi id 15.20.7046.034; Thu, 7 Dec 2023
 09:55:23 +0000
From: "Yuya Fujita (Fujitsu)" <fujita.yuya-00@fujitsu.com>
To: 'Yu Kuai' <yukuai1@huaweicloud.com>, Song Liu <song@kernel.org>
CC: "mariusz.tkaczyk@linux.intel.com" <mariusz.tkaczyk@linux.intel.com>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "yukuai (C)"
	<yukuai3@huawei.com>, "Yuya Fujita (Fujitsu)" <fujita.yuya-00@fujitsu.com>
Subject: RE: [PATCH] md: Do not unlock all_mddevs_lock in md_seq_show()
Thread-Topic: [PATCH] md: Do not unlock all_mddevs_lock in md_seq_show()
Thread-Index: AQHaKB98+LUbn4wOEk6z5CFc4zz6LrCcuDKAgABR04CAAHu2AIAACpUAgAAEFQA=
Date: Thu, 7 Dec 2023 09:55:23 +0000
Message-ID:
 <TYXPR01MB1647AE84D0CA9115FF6FF38FC58BA@TYXPR01MB1647.jpnprd01.prod.outlook.com>
References: <20231206083356.9796-1-fujita.yuya-00@fujitsu.com>
 <CAPhsuW7WE8p+ijAx3rJEeafJV8-EtJ+KOaZayUap0G6JpFpdGg@mail.gmail.com>
 <b705bae8-b0af-eaca-c0ed-7f12891cd962@huaweicloud.com>
 <TYXPR01MB16470185D0441788BE920E35C58BA@TYXPR01MB1647.jpnprd01.prod.outlook.com>
 <0d2b8c20-502c-271b-bbd5-1713777e0f9c@huaweicloud.com>
In-Reply-To: <0d2b8c20-502c-271b-bbd5-1713777e0f9c@huaweicloud.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 =?iso-2022-jp?B?TVNJUF9MYWJlbF9hNzI5NWNjMS1kMjc5LTQyYWMtYWI0ZC0zYjBmNGZl?=
 =?iso-2022-jp?B?Y2UwNTBfQWN0aW9uSWQ9NTcxNTRkMGEtM2U0ZS00OGMyLThjNWMtYTQ2?=
 =?iso-2022-jp?B?MGFhMDM4ZmY2O01TSVBfTGFiZWxfYTcyOTVjYzEtZDI3OS00MmFjLWFi?=
 =?iso-2022-jp?B?NGQtM2IwZjRmZWNlMDUwX0NvbnRlbnRCaXRzPTA7TVNJUF9MYWJlbF9h?=
 =?iso-2022-jp?B?NzI5NWNjMS1kMjc5LTQyYWMtYWI0ZC0zYjBmNGZlY2UwNTBfRW5hYmxl?=
 =?iso-2022-jp?B?ZD10cnVlO01TSVBfTGFiZWxfYTcyOTVjYzEtZDI3OS00MmFjLWFiNGQt?=
 =?iso-2022-jp?B?M2IwZjRmZWNlMDUwX01ldGhvZD1TdGFuZGFyZDtNU0lQX0xhYmVsX2E3?=
 =?iso-2022-jp?B?Mjk1Y2MxLWQyNzktNDJhYy1hYjRkLTNiMGY0ZmVjZTA1MF9OYW1lPUZV?=
 =?iso-2022-jp?B?SklUU1UtUkVTVFJJQ1RFRBskQiJMJT8lUhsoQjtNU0lQX0xhYmVsX2E3?=
 =?iso-2022-jp?B?Mjk1Y2MxLWQyNzktNDJhYy1hYjRkLTNiMGY0ZmVjZTA1MF9TZXREYXRl?=
 =?iso-2022-jp?B?PTIwMjMtMTItMDdUMDk6NDY6NThaO01TSVBfTGFiZWxfYTcyOTVjYzEt?=
 =?iso-2022-jp?B?ZDI3OS00MmFjLWFiNGQtM2IwZjRmZWNlMDUwX1NpdGVJZD1hMTlmMTIx?=
 =?iso-2022-jp?B?ZC04MWUxLTQ4NTgtYTlkOC03MzZlMjY3ZmQ0Yzc7?=
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYXPR01MB1647:EE_|OSZPR01MB9500:EE_
x-ms-office365-filtering-correlation-id: a7ba52d5-b3f0-4394-dc8d-08dbf70aa1bd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 KJUTqsB9u8ehQouhns1uZhmv78ZQUdYk29uyyf8Jl6g+ox4WXduYC2Cw5kGxwQPMmsSa7mUS6/IZiWMol6TNbUFKSsLup5I7vlLVu79YbOc9zsRS7j7rLSKYWTMLoNRK2EULWLLluwms8/l4dGSt6Tap2kaGFVPrXZXF5icHrjJuJEJu368OYN5y/9YtniYdjXoWaN4uan45iLY4mkh0nK2tAdvhsFiqd7C5lNOlYNfjffG0jJ3ar15dlgk6W/CkSI4fP4XBXoyNW+3e3sztZHnefMwa5O77DtwbB4bzTCOQXKqhHd26hRtCYvSwkfa9q64goY/6YxcnThXPWX5CXkhe5NEL1G406wVzV0TjwGAC+Vfn5B5OnwctjB/dZBxvn0k3K8RL7PoHZnPm7fHhrn8GbWaU5csk7ZutNVKug2ipN7GmJ8NnD670SkaOVPwQb5qUuo0KmSqAP3oM0KDcChnu85MUpmVO/TK0UI4Bp/qPibq5SetURVHASj58KmAg6R1hCjAIA56diklA9vEVCloh5AbDiAKKpmHbCkHSTZLWxpD4kDaaiThg3XphDkLMslJPhpsLrMFK8x347RpuE7hHX2PWrircdZ3Jbx3MsTnsY1+wbtHPSb5Afi8qx2j0XlGrz8yIzxJrkkGEsZUGRg==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYXPR01MB1647.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(366004)(136003)(346002)(396003)(230922051799003)(451199024)(64100799003)(1800799012)(186009)(1590799021)(41300700001)(1580799018)(85182001)(5660300002)(30864003)(86362001)(33656002)(2906002)(38070700009)(83380400001)(6506007)(7696005)(9686003)(82960400001)(107886003)(55016003)(26005)(71200400001)(478600001)(45080400002)(38100700002)(122000001)(110136005)(8936002)(8676002)(4326008)(66946007)(54906003)(76116006)(66476007)(316002)(64756008)(52536014)(66556008)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-2022-jp?B?czlvRUJ2TFVVNmpoU0JWR3BOQjNhSGlYdDhsdHJKSStkNnVjYU1oV3kw?=
 =?iso-2022-jp?B?ZnJEQS9sNVJuWWVTallNUXh6aEJPMmRjNEpSVzhWNWxSTXg1OUQ2ZEFJ?=
 =?iso-2022-jp?B?OWJ2c2RYeWNoNFY2WXp6dWRjQmRjRUNrUFU0UnZkNDViVEJVU09lOUt3?=
 =?iso-2022-jp?B?MlFjMHF3dnpoelFqWTF4M09yeWJhUWhCNytZQ1YrQ2ZXVWFCd1R4cVFw?=
 =?iso-2022-jp?B?MTY4dGt3elNFOXZNYVExZmhTUWw2M1NqbEZDd0UyMFFBcmxHQ2V1TVMw?=
 =?iso-2022-jp?B?aHk3aGRhUFd3cnF0WVliRndMU0JqWFY4WklyRVdka3d0Z0ErZWJMbkFD?=
 =?iso-2022-jp?B?VFhBS3ZTeFVhQmwxbWZPdjlaWk5JUEtJVDF0RVJ3TXJQZiswM3lOWnh2?=
 =?iso-2022-jp?B?Z1ltMHZLNGRBU0RQeFI5RGh0VWZRWS9sdGNsMGJ1eVlwczI1d0VNcUUw?=
 =?iso-2022-jp?B?WjZiZ3loU2p3c09tVGxJZ3orSWpuUTUzOEJnN3hJY3hBRVB0WHA3NmRK?=
 =?iso-2022-jp?B?cDYzcGVDRENIb3h6dlR6RkZHUExtY1U4ZFlCdmQrcnJwV2JBR3NobUVo?=
 =?iso-2022-jp?B?aXlpQ3VKdGx6V2ZhWkFRRVBCV2V6WERXY1o5MkZlQXVZa0JQZHJTbXVw?=
 =?iso-2022-jp?B?ZDJXU3dJd1M2eGVUZ2ZUOTdSS24xTmFTVWpETXFObXl6NlR3bnVIME1q?=
 =?iso-2022-jp?B?MUxERnZJMVo2cmhKV2htVlJ0QXJZblN2U24rSEJQam04SFRZQ2cwU1Vl?=
 =?iso-2022-jp?B?Yk1rV1dDL2dIbk9vSXN3K1U1Q2krWHcvZC84dy9oOEtLdzJYNW5qUW1S?=
 =?iso-2022-jp?B?dGFqVUZJQ3hJM2dERWNWNm0xaWhYeE0zQVNYTDN5YU1QL1o0di91OUFq?=
 =?iso-2022-jp?B?dm5PNklxOUFTUXJsaDRzcld6MlJic0VoMzVyL251bkVCODU5Y29waHU5?=
 =?iso-2022-jp?B?c0c0NXVSK2RpMkpyKzJSRGx4REhvb2ZPR0tiQ1RpTk5QcmFwVFRENHZI?=
 =?iso-2022-jp?B?dUxKR252c0x3Y1hjZDJoUVM3V1ZTdmtiZDFlV1Q5cVdwQ2pyRUthWXRU?=
 =?iso-2022-jp?B?TFpaUmZiUmZ1SUw3cDFIUzkrWVhKZEVnNlVuSDkrUStvTEVCVEI5TGlF?=
 =?iso-2022-jp?B?V01jb1NEMnNrVXRoQmRHYlYwamRCQlVoaFFRbTJpeHd5UWNZRndyZ1Jy?=
 =?iso-2022-jp?B?a0piN3NUMzBaQVpFcHpNNzVJM1RFWXJZMkNkWERwT003aGF0Ym82Y2VC?=
 =?iso-2022-jp?B?ajdtZEVpdWZXTm1xTkVEVk9wYmJ2R25NMFJzenRLRTUwV0hBaGtNb09u?=
 =?iso-2022-jp?B?N0lFVThYL25CdlVXdi9WdGtlVXJJb1hlUUpadjRsdGp1ZmJvOVFuNTFL?=
 =?iso-2022-jp?B?b3pDNE9LL1g4QnFaWEZqZG1uM3ZxRzdpWHRCd0FERVBoWFJscUdMbGpC?=
 =?iso-2022-jp?B?Vm14bzNxQ29zam5DTjJrT2VqUTlweDJvd1pTbXNzbjRDa1N0R0ZoUlZo?=
 =?iso-2022-jp?B?S3FsT2xOTnBwZi9tU2d2T29xaENPWUI5bnJnTitYQmZuRnVnakExQlhZ?=
 =?iso-2022-jp?B?eC9raVJhb1lHR2svQ0RjVDNBUm80OCs5WkFPYXlSMER5TTRVM3FzQVhF?=
 =?iso-2022-jp?B?a21WYmNYaE5TRjdRVHgrbmRFNGpxMDhIK0YvSGhUTmNRWWpXNzNTbWJk?=
 =?iso-2022-jp?B?bTNlQ2UxeGVIZzVQQk1iS3FtNml5QjdtL2Z2aG9EVUNqaFlTK2luVEVt?=
 =?iso-2022-jp?B?WTcvM2dwWkdHbUYwa3BvSEhrb20wUk9Rbm5NeERJajFpamNHV2dMSmxG?=
 =?iso-2022-jp?B?OWVZRjZFNkgvc080YmF6b2NqRzNxTHZVb3F4UDNPb2ZkQjQyVVF0L1Bs?=
 =?iso-2022-jp?B?R2I2dG5XOVkwMERUQUw0VmRqK05pQXR2THdrTlc0TmtRYmtGQVJVWGQ2?=
 =?iso-2022-jp?B?bmFKYkM4KzNHOTBSZFZ2am00cmVjN1ptZE5oMHYzYWZib2hkS0txR2M0?=
 =?iso-2022-jp?B?KzgvQ1pJRVNuZXNEV0ZBd1YxNTVwSWZ4V2JhWUJnWkkrSkZJdDFpK2s0?=
 =?iso-2022-jp?B?c0VTOWlLVm5YNTZqV3RtM0tRbHVXay81NitKOXdzWSs4M1VYZXAxSHpn?=
 =?iso-2022-jp?B?anZRYWgwSlo2VS9hQzArclBBbGJhdlRZRkNqZUJ4K3BnSk9KMDFwUzMz?=
 =?iso-2022-jp?B?V2hScVBmTTcrUXp0S0NVSGQyRGp5eWwzOGh3T2IzdXB2TVdROUNBRHBm?=
 =?iso-2022-jp?B?NnQ5eW11OGRUOTVjVkFhdm5WUTdIajVUdkVPUlNwVmNYVFB3T3RabVZE?=
 =?iso-2022-jp?B?MDB1d1g5bVYzWXg2NE9GRitOb3lCc0E0bXc9PQ==?=
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YoVk/wsw9rR3925QbfHaZk512asQpeXIAsN+JVXBIr1ZD6Cx73v0fGtwJ+XjxIxL3MoyR3juIMb4G65AyqB7eTWg0pCyoWzKJj86NnigXjpCJEwX6FOVovFi6Xtm/a11+fI/JQKAeRT2s19TIJ300tKbSAqRiz0liyhgysgshqaC6PtOw+7rkJ9PRnTIUchC76TIbL+zEUMnoHyuKxSLdOvcEDOWbPZnwfq5QSJ2iILC1SpS/uUeYq1y75qok/7w+FFMOhdtLvnZ/rRGieHtD8Cmoqqrrc+mFIFjlOOnBPBbhqx3mv+MFJaenfoe/GQgdXLFvEpH8tWQoxrRona7oIGPaDxMgLm3EJIbszW5WQAkL57L8ptaZaQ/vj37axygiGWtASZt3izfhkhK6fx0o8RapP0ATWLThAdooJET7uJE2HwRAFpZTgp71Uhc7+rvsoYdP1H82WuJHs+BfS64k+cgfjAUxveMr9JQLlc7ByeDfVs7qZoyaOBG9/gPT3cvKUI/+Pd2QonCsCpS6XURYYOMYbG8bb/GUPExF77w1gOOv15ewcYxF0tvgX7qVV7PuPlHdWOFXILq9l/poi8OKpiVaKBJsDEp3KKXzGWE6zZTax9Ru9tt23ppHDCkxpSlbhH88O8fC/tngRoMu3ZfbC4QiuvZqDdLOafy2CwzDQUCjNBtiM3Tvel5qU3A2uOybPaFqLORyZnzze8aQQV/vHFuuABfQOp392KViSny/rfvf2bLjEe5bcYjl1n0Vhs2oXOQ/lxWeKpIC45NBm2jZJuNWeYbEkwF/NE51S+2jcO17VwMUN1gk0uPj8Rov8qNIEpO4HVlS9EBlNzqExOwVb/63N/AxrJ5tOMaA1GBmededYLuPQBQSNJVYqjruiNT+17bMJh0qhJrTZzagMjf9jcaIJtK/5xKz1jOSV2TJ8I=
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYXPR01MB1647.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7ba52d5-b3f0-4394-dc8d-08dbf70aa1bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2023 09:55:23.7841
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AFIqec/lBTZLWooymr2s09NUHv/YwUDi236+8nXxQ4b3U66E2XyAtniZOCEgZCpiU9d/rUTMflKk16kKdB0elT6u/5aGUSR4ynnDyGj8KaU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSZPR01MB9500

Hello,=20

> Hi,
>=20
> =1B$B:_=1B(B 2023/12/07 16:58, Yuya Fujita (Fujitsu) =1B$B<LF;=1B(B:
> > Hello,
> >
> >> I fail to understand what is the problem here if other mddev is delete=
d
> >> from the list while all_mddevs_lock is released during md_seq_show(),
> >> can you explain more?
> >
> > If the list is deleted in md_seq_show(), it is assumed to reference an =
invalid
> > pointer when traversing the next list.
> > While all_mddevs_lock is being released, mddev->lock is being retrieved=
,
> > but I am not sure if the list will not be deleted during that time.
>=20
> No, this is not true, md_seq_show() won't delete mddev from the list,
> the next list is still valid.
>=20
> md_seq_show:
>   mddev_get
>   spin_unlock(&all_mddevs_lock)
>   // mddev won't be removed untill __mddev_put
>   spin_lock(&all_mddevs_lock)
>   if (atomic_dec_and_test(&mddev->active))
>    __mddev_put(mddev)
>    set_bit(MD_DELETED, &mddev->flags)
>    queue_work(md_misc_wq, &mddev->del_work)
> md_seq_next
> /*
>   * all_mddevs_lock is not released since last __mddev_put, it's safe
>   * to iterate the next list.
>   */
>=20
> Later from del_work:
> mddev_delayed_delete
>   kobject_put(&mddev->kobj)
>    md_kobj_release
>     del_gendisk
>      md_free_disk
>       spin_lock(&all_mddevs_lock)
>       list_del(&mddev->all_mddevs)
>       spin_unlock(&all_mddevs_lock)

You're right... Thank you for the explanation.

>=20
>=20
> >
> > The following is an example of a kernel module that deletes a list duri=
ng .show().
> > Initially, three entries are added to the test_list and the list will b=
e
> > deleted in test_seq_show().
> > ---
> > #include <linux/module.h>
> > #include <linux/kernel.h>
> > #include <linux/seq_file.h>
> > #include <linux/proc_fs.h>
> >
> > MODULE_LICENSE("GPL v2");
> > MODULE_DESCRIPTION("an example of deleting list in .show()");
> >
> > static LIST_HEAD(test_list);
> >
> > struct test_entry {
> > 	struct list_head list;
> > 	int n;
> > };
> >
> > static void test_add(int n) {
> > 	struct test_entry *e =3D kmalloc(sizeof(*e), GFP_KERNEL);
> > 	e->n =3D n;
> > 	list_add(&e->list, &test_list);
> > 	printk(KERN_INFO "add %d to test_list\n", n);
> > }
> >
> > static void *test_seq_start(struct seq_file *seq, loff_t *pos) {
> > 	printk(KERN_INFO "seq_list_start() is called.\n");
> > 	return seq_list_start(&test_list, *pos);
> > }
> >
> > static void *test_seq_next(struct seq_file *seq, void *v, loff_t *pos) =
{
> > 	struct test_entry *e =3D list_entry(v, struct test_entry, list);
> > 	printk(KERN_INFO "seq_list_next() is called on list %d\n", e->n );
> > 	return seq_list_next(v, &test_list, pos);
> > }
> >
> > static void test_seq_stop(struct seq_file *seq, void *v) {
> > }
> >
> > static int test_seq_show(struct seq_file *seq, void *v){
> > 	struct test_entry *e =3D list_entry(v, struct test_entry, list);
> > 	printk(KERN_INFO "test_seq_show() is called on list %d\n", e->n );
> > 	list_del(&e->list);
>=20
> As explained before, this list_del() will never happen in md_seq_show().
>=20
> Thanks,
> Kuai
>=20
> > 	printk(KERN_INFO "deleted list %d\n", e->n );
> > 	return 0;
> > }
> >
> > static const struct seq_operations test_seq_ops =3D {
> > 	.start  =3D test_seq_start,
> > 	.next   =3D test_seq_next,
> > 	.stop   =3D test_seq_stop,
> > 	.show   =3D test_seq_show,
> > };
> >
> > int test_seq_open(struct inode *inode, struct file *file)
> > {
> > 	struct seq_file *seq;
> > 	int error;
> >
> > 	error =3D seq_open(file, &test_seq_ops);
> > 	if (error)
> > 		return error;
> >
> > 	seq =3D file->private_data;
> > 	return error;
> > }
> >
> > static const struct proc_ops test_proc_ops =3D {
> > 	.proc_open	=3D test_seq_open,
> > 	.proc_read	=3D seq_read,
> > 	.proc_lseek	=3D seq_lseek,
> > 	.proc_release	=3D seq_release,
> > };
> >
> > static int __init test_init( void ) {
> > 	printk( KERN_INFO "insmod test\n" );
> > 	test_add(1);
> > 	test_add(2);
> > 	test_add(3);
> > 	proc_create("test", S_IRUGO, NULL, &test_proc_ops);
> > 	return 0;
> > }
> >
> > static void __exit test_exit( void ) {
> > 	printk( KERN_INFO "rmmod test\n" );
> > }
> >
> > module_init( test_init );
> > module_exit( test_exit );
> > ---
> >
> >
> > Loading the kernel module and executing "cat /proc/test" results in the=
 following message:
> > ---
> > Dec 07 16:23:42 localhost-live kernel: insmod test
> > Dec 07 16:23:42 localhost-live kernel: add 1 to test_list
> > Dec 07 16:23:42 localhost-live kernel: add 2 to test_list
> > Dec 07 16:23:42 localhost-live kernel: add 3 to test_list
> > Dec 07 16:23:43 localhost-live kernel: seq_list_start() is called.
> > Dec 07 16:23:43 localhost-live kernel: test_seq_show() is called on lis=
t 3
> > Dec 07 16:23:43 localhost-live kernel: deleted list 3
> > Dec 07 16:23:43 localhost-live kernel: seq_list_next() is called on lis=
t 3
> > Dec 07 16:23:43 localhost-live kernel: general protection fault, probab=
ly for non-canonical address
> 0xdead000000000110: 0000 [#1] PREEMPT SMP NOPTI
> > Dec 07 16:23:43 localhost-live kernel: CPU: 4 PID: 2511 Comm: cat Taint=
ed: G           OE
> 6.7.0-0.rc4.20231205gtbee0e776.335.vanilla.fc39.x86_64 #1
> > Dec 07 16:23:43 localhost-live kernel: Hardware name: QEMU Standard PC =
(Q35 + ICH9, 2009), BIOS
> 1.16.2-1.fc38 04/01/2014
> > Dec 07 16:23:43 localhost-live kernel: RIP: 0010:test_seq_show+0xd/0x70=
 [main]
> > Dec 07 16:23:43 localhost-live kernel: Code: e9 d8 2d b5 e4 0f 1f 84 00=
 00 00 00 00 90 90 90 90 90 90 90
> 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 0f 1f 44 00 00 53 48 89 f3 <8b> 76=
 10 48 c7 c7 a0 e0 96 c0 e8 d4 42 85
> e4 48 89 df e8 ec 35 ee
> > Dec 07 16:23:43 localhost-live kernel: RSP: 0018:ffffaa7b43377cf8 EFLAG=
S: 00010287
> > Dec 07 16:23:43 localhost-live kernel: RAX: ffffffffc0954060 RBX: dead0=
00000000100 RCX:
> 0000000000000027
> > Dec 07 16:23:43 localhost-live kernel: RDX: 0000000000000000 RSI: dead0=
00000000100 RDI:
> ffff9e0ac15b87f8
> > Dec 07 16:23:43 localhost-live kernel: RBP: 0000000000000000 R08: 00000=
00000000000 R09:
> ffffaa7b43377b90
> > Dec 07 16:23:43 localhost-live kernel: R10: 0000000000000003 R11: fffff=
fffa75463a8 R12:
> ffffaa7b43377d98
> > Dec 07 16:23:43 localhost-live kernel: R13: ffffaa7b43377d70 R14: dead0=
00000000100 R15:
> 0000000000000000
> > Dec 07 16:23:43 localhost-live kernel: FS:  00007fb3ac908740(0000) GS:f=
fff9e0c31d00000(0000)
> knlGS:0000000000000000
> > Dec 07 16:23:43 localhost-live kernel: CS:  0010 DS: 0000 ES: 0000 CR0:=
 0000000080050033
> > Dec 07 16:23:43 localhost-live kernel: CR2: 00007fb3ac8e6000 CR3: 00000=
00130c0c005 CR4:
> 0000000000770ef0
> > Dec 07 16:23:43 localhost-live kernel: PKRU: 55555554
> > Dec 07 16:23:43 localhost-live kernel: Call Trace:
> > Dec 07 16:23:43 localhost-live kernel:  <TASK>
> > Dec 07 16:23:43 localhost-live kernel:  ? die_addr+0x36/0x90
> > Dec 07 16:23:43 localhost-live kernel:  ? exc_general_protection+0x1c5/=
0x430
> > Dec 07 16:23:43 localhost-live kernel:  ? asm_exc_general_protection+0x=
26/0x30
> > Dec 07 16:23:43 localhost-live kernel:  ? __pfx_test_seq_show+0x10/0x10=
 [main]
> > Dec 07 16:23:43 localhost-live kernel:  ? test_seq_show+0xd/0x70 [main]
> > Dec 07 16:23:43 localhost-live kernel:  seq_read_iter+0x120/0x480
> > Dec 07 16:23:43 localhost-live kernel:  seq_read+0xd4/0x100
> > Dec 07 16:23:43 localhost-live kernel:  proc_reg_read+0x5a/0xa0
> > Dec 07 16:23:43 localhost-live kernel:  vfs_read+0xac/0x320
> > Dec 07 16:23:43 localhost-live kernel:  ksys_read+0x6f/0xf0
> > Dec 07 16:23:43 localhost-live kernel:  do_syscall_64+0x61/0xe0
> > Dec 07 16:23:43 localhost-live kernel:  ? do_user_addr_fault+0x30f/0x66=
0
> > Dec 07 16:23:43 localhost-live kernel:  ? exc_page_fault+0x7f/0x180
> > Dec 07 16:23:43 localhost-live kernel:  entry_SYSCALL_64_after_hwframe+=
0x6e/0x76
> > Dec 07 16:23:43 localhost-live kernel: RIP: 0033:0x7fb3aca13121
> > Dec 07 16:23:43 localhost-live kernel: Code: 00 48 8b 15 11 fd 0c 00 f7=
 d8 64 89 02 b8 ff ff ff ff eb bd e8
> 40 ce 01 00 f3 0f 1e fa 80 3d 45 82 0d 00 00 74 13 31 c0 0f 05 <48> 3d 00=
 f0 ff ff 77 4f c3 66 0f 1f 44 00 00
> 55 48 89 e5 48 83 ec
> > Dec 07 16:23:43 localhost-live kernel: RSP: 002b:00007ffe7d716738 EFLAG=
S: 00000246 ORIG_RAX:
> 0000000000000000
> > Dec 07 16:23:43 localhost-live kernel: RAX: ffffffffffffffda RBX: 00000=
00000020000 RCX:
> 00007fb3aca13121
> > Dec 07 16:23:43 localhost-live kernel: RDX: 0000000000020000 RSI: 00007=
fb3ac8e7000 RDI:
> 0000000000000003
> > Dec 07 16:23:43 localhost-live kernel: RBP: 00007ffe7d716760 R08: 00000=
000ffffffff R09:
> 0000000000000000
> > Dec 07 16:23:43 localhost-live kernel: R10: 0000000000000022 R11: 00000=
00000000246 R12:
> 0000000000020000
> > Dec 07 16:23:43 localhost-live kernel: R13: 00007fb3ac8e7000 R14: 00000=
00000000003 R15:
> 0000000000000000
> > Dec 07 16:23:43 localhost-live kernel:  </TASK>
> > Dec 07 16:23:43 localhost-live kernel: Modules linked in: main(OE) uinp=
ut snd_seq_dummy
> snd_hrtimer nf_conntrack_netbios_ns nf_conntrack_broadcast nft_fib_inet n=
ft_fib_ipv4 nft_fib_ipv6
> nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct n=
ft_chain_nat nf_nat nf_conntrack
> nf_defrag_ipv6 nf_defrag_ipv4 rfkill ip_set nf_tables nfnetlink qrtr sunr=
pc binfmt_misc
> snd_hda_codec_generic ledtrig_audio snd_hda_intel snd_intel_dspcfg snd_in=
tel_sdw_acpi
> snd_hda_codec intel_rapl_msr intel_rapl_common snd_hda_core snd_hwdep kvm=
_intel snd_seq
> iTCO_wdt intel_pmc_bxt iTCO_vendor_support snd_seq_device kvm raid1 snd_p=
cm irqbypass rapl
> pktcdvd snd_timer pcspkr i2c_i801 i2c_smbus snd lpc_ich soundcore virtio_=
balloon joydev loop zram
> crct10dif_pclmul crc32_pclmul crc32c_intel polyval_clmulni polyval_generi=
c ghash_clmulni_intel
> sha512_ssse3 sha256_ssse3 sha1_ssse3 virtio_scsi virtio_gpu virtio_net vi=
rtio_blk virtio_console
> virtio_dma_buf net_failover failover serio_raw ip6_tables ip_tables fuse =
qemu_fw_cfg
> > Dec 07 16:23:43 localhost-live kernel: ---[ end trace 0000000000000000 =
]---
> > Dec 07 16:23:43 localhost-live kernel: RIP: 0010:test_seq_show+0xd/0x70=
 [main]
> > Dec 07 16:23:43 localhost-live kernel: Code: e9 d8 2d b5 e4 0f 1f 84 00=
 00 00 00 00 90 90 90 90 90 90 90
> 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 0f 1f 44 00 00 53 48 89 f3 <8b> 76=
 10 48 c7 c7 a0 e0 96 c0 e8 d4 42 85
> e4 48 89 df e8 ec 35 ee
> > Dec 07 16:23:43 localhost-live kernel: RSP: 0018:ffffaa7b43377cf8 EFLAG=
S: 00010287
> > Dec 07 16:23:43 localhost-live kernel: RAX: ffffffffc0954060 RBX: dead0=
00000000100 RCX:
> 0000000000000027
> > Dec 07 16:23:43 localhost-live kernel: RDX: 0000000000000000 RSI: dead0=
00000000100 RDI:
> ffff9e0ac15b87f8
> > Dec 07 16:23:43 localhost-live kernel: RBP: 0000000000000000 R08: 00000=
00000000000 R09:
> ffffaa7b43377b90
> > Dec 07 16:23:43 localhost-live kernel: R10: 0000000000000003 R11: fffff=
fffa75463a8 R12:
> ffffaa7b43377d98
> > Dec 07 16:23:43 localhost-live kernel: R13: ffffaa7b43377d70 R14: dead0=
00000000100 R15:
> 0000000000000000
> > Dec 07 16:23:43 localhost-live kernel: FS:  00007fb3ac908740(0000) GS:f=
fff9e0c31d00000(0000)
> knlGS:0000000000000000
> > Dec 07 16:23:43 localhost-live kernel: CS:  0010 DS: 0000 ES: 0000 CR0:=
 0000000080050033
> > Dec 07 16:23:43 localhost-live kernel: CR2: 00007fb3ac8e6000 CR3: 00000=
00130c0c005 CR4:
> 0000000000770ef0
> > Dec 07 16:23:43 localhost-live kernel: PKRU: 55555554
> > ---
> >
> >
> > I think this happens in the following way.
> > ---
> > seq_read_iter()
> > ->m->op->show()
> >    ->test_seq_show()
> >      ->list_del(&e->list);
> >        //the list is deleted here
> > ->m->op->next()
> >    ->test_seq_next()
> >      ->seq_list_next()
> >        ->lh =3D ((struct list_head *)v)->next;
> >          // The list has been deleted, so ->next points to an invalid p=
ointer
> > ->m->op->show()
> >    ->test_seq_show()
> >      // .show() is called again and references the invalid pointer.
> > ---
> >
> > Therefore, I think the same problem will happen when the list is delete=
d in md_seq_show().
> >
> >
> > Best Regards,
> > Yuya Fujita
> > .
> >
