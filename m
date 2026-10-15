Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11022120.outbound.protection.outlook.com [40.107.209.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E3F74E5337
	for <linux-raid@vger.kernel.org>; Thu, 15 Oct 2026 13:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.120
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792069450; cv=fail; b=pqOK+qs1iIkvLIiWQEMRUacyOGaIhG/MVTvf2Qy/6AmzFvMwGMjiwJvneoBx5E5DVwg2gc3NQj+Aboe/p7Bz5NK1YgCTHr9ccmwBt9ZF7YY3gLjiAxYYgEk7pwZMNU/c5jYEAwrrOouepdXzG2x2+4fIyNiI4DEO2vhOvRoNV+4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792069450; c=relaxed/simple;
	bh=PEFe1uOVESsiDqqWX+p2OTmIjyvtlFHlI9K3FLNEL1w=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=IE1k47xGG6uEaFGffmNzEUM51jYQ9rMr+WOyJQWUMdKL31LFuHUmqXW2VUHoJ8hSXdcfl8RV4P8nJQjDCymCnHFUWQXzo+tBPhVUZkVKhdNbx11zIfhN31eSEubarOyb05/N2JGQL571F33ng6INV64EndiYeK2PGl0KkyIzJI8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gatech.edu; spf=pass smtp.mailfrom=gatech.edu; dkim=pass (2048-bit key) header.d=gatech.edu header.i=@gatech.edu header.b=gvEqqZvU; arc=fail smtp.client-ip=40.107.209.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gatech.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gatech.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gatech.edu header.i=@gatech.edu header.b="gvEqqZvU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gBHb1YZeeCe+30iJedUb7eCLlVorQeXuodn3bSDE/qVo6VgLyR78G8hV5c5D63nWZNQhTyLD+cfYWhmhTuu/iZF1Fl0pQHJBlHPiO8O6uKfPEzfadgh2HRFqRnMixOsdDvL92dy2MELwfumNQH+qEdBPGz5k/dDev9PZCeiE94paGsUcCxsXwfaGr6jHiFNa5Fpmtj1aJF23R4hqDK7Qu6j3GcmcK/rDTQ7440Vs65/F0dCzTZXhaKnhZtR4PgiIQADq4/WBDanebuiwJKwypx334le7DpqqitDgdlyPdRD9YlJL7iQtTf6EPf8eteQk/O5kyvpHP92eEQXunASXFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+lKcoFhxIEthGwZs67K/4uNWPT9Lek5MN/JtxwNi8oc=;
 b=Focc2ZAtDf0H+RUy7yL7eXBeKM0b7ZKOozc+aeVpOhFyuHv6x03GBDnkbcS17qsKD0TSiat2Swezbn0Kg3rS7epR5BRf4vl7VHKUYHQEH5pi1WZ1JM+FYdiLxIzaB3WeCM8aTztDQbuAHhbv9VTHd4a8a6Djq1BqaX+ogZhyKkhmZGmRJOSc0mzrOehkHpO0cP+pWx6L/LGYW0zEi9p2pEjSSHvoubonWntxFBnlkrfKcP/btt6USVaALJag5g7P8pqpIuDI/0cqpqNDW8i+okN2P2L9Vc+lHZg5nJjR+R/DFDvYvD4THLfeyleH39vKKOuYhHxOlFcQ4A8xTFf/bQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=gatech.edu; dmarc=pass action=none header.from=gatech.edu;
 dkim=pass header.d=gatech.edu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gatech.edu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+lKcoFhxIEthGwZs67K/4uNWPT9Lek5MN/JtxwNi8oc=;
 b=gvEqqZvU1pTSHppVf0vIaYNkrUEXG6rCEoQCTqh7AFEb6BGqFJmRPoLH0hy/skDoSJsgq+M5WyS4M17oOnJy5zNttQrjQhivhTdeu6aiDmnweqeXkoCAAaqfyccL6qEjSkFcbGu5dboyuo0DhExszLoyZYdo7Bg6/kEQbcO+g424nCWcvSgO1dxgx1bQDJfj/ch5yxlaPl63aBkp7ncHhm6XJbFLCF6jRMNX1wqXWCN9W6VY32eGH96hM9KC18txt1Ahku2D6IvQ1tObrCI0ESSrC9XgVMMjuYoqFMQAC35fLMxPvnMATgnTlvyX7q3huMLazADNJTISIagNBne31Q==
Received: from CH3PR07MB9958.namprd07.prod.outlook.com (2603:10b6:610:1ae::19)
 by SA0PR07MB7611.namprd07.prod.outlook.com (2603:10b6:806:bd::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.14; Thu, 15 Oct
 2026 13:04:04 +0000
Received: from CH3PR07MB9958.namprd07.prod.outlook.com
 ([fe80::d6b8:e067:4377:97da]) by CH3PR07MB9958.namprd07.prod.outlook.com
 ([fe80::d6b8:e067:4377:97da%4]) with mapi id 15.21.0522.013; Thu, 15 Oct 2026
 13:03:59 +0000
From: "Masalkhi, Abd Alrhman" <abd.masalkhi@gatech.edu>
To: "blazej.kucman@graidtech.com" <blazej.kucman@graidtech.com>,
	"mtkaczyk@kernel.org" <mtkaczyk@kernel.org>, "ncroxon@redhat.com"
	<ncroxon@redhat.com>, "xni@redhat.com" <xni@redhat.com>, "song@kernel.org"
	<song@kernel.org>, "yukuai@kernel.org" <yukuai@kernel.org>
CC: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Masalkhi, Abd
 Alrhman" <abd.masalkhi@gatech.edu>
Subject: [PATCH] mdadm: Deprecate the obsolete --auto-detect option
Thread-Topic: [PATCH] mdadm: Deprecate the obsolete --auto-detect option
Thread-Index: AQHdXKWk/Eu9yn3gWkG8xQmEoOcxmQ==
Date: Thu, 15 Oct 2026 13:03:59 +0000
Message-ID: <20261015130326.442915-1-abd.masalkhi@gatech.edu>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=gatech.edu;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR07MB9958:EE_|SA0PR07MB7611:EE_
x-ms-office365-filtering-correlation-id: 7f296d48-2d76-468e-00b7-08df2abcc770
x-gt-tenant: 042d12d7-75fe-4547-b5b6-0573f80f829d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|786006|1800799024|376014|366016|10067099003|18002099003|38070700021|11063799006|56012099006;
x-microsoft-antispam-message-info:
 cKqtGdeynAuozzn9TduAk65xMnLa97AHxSLiUqVxGVTJQjB7AzR1FqlM+Kwx6UdI9aunEquNwIAZfKm8xmOuLBnUyH8ukuAaov0Q/DUEwohuevPeDSD9r+9GU6JL1TBjdi6zLxQMSXrBrVIgezurj80pCiClvukf4ht6d4G9pFAvq/JjH6k5j8h0dv9GnZpfQyAkWpdiB9imQcTUoHWa3AWxREuUKQTdS+yzhKBoPX/ne6Ky7S9rEYC3xlF/Tu4sz/tPwoEJIAyz5PRW0CiySAR/YlVCNkWg+i9/2SnnnQpx3RsOX+14aHdHzTFqpC4Iqd4T8WA6W2Z+U7FlVG4Z7i+XhFwPSXI4fzA95sa9iQOSI9oHEVN3m07flG+WbK8KYop44V7nhFf3LY9ei6P5VOYRIJzO3lF3veDaU2JfgPGbIHURfRNtSKSaTpg+SDUsYEV6uEs5uPQnUqqQtdYhXcf6mLndR/ZTQfYQ8dtPe4gIUCtA5tc3G/bdQcgqBsCb7cTZy22S4KiwcEk4fluRlumcl1Vcnn3VdYb3MQ9MskZMNjrqSR4ZUW03viwwMVToNEcvUBP/KqrM4gJ3aCQfidltvzBWtEUuQ4n1/wddWcKkxmzFxmuykVokSwTMpvIILm/LwSbFT136jlpt7h/gocU78iE9erHB12emEzjD1MkHYIBtqnwD8bqTDjq4jHIjDk+pnJ7SFdJXrLeFHmiCtHRjKpvfE+x8ga4Elrq6QM4=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR07MB9958.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(786006)(1800799024)(376014)(366016)(10067099003)(18002099003)(38070700021)(11063799006)(56012099006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?b2RLrOVvHOTv2rD80PAonKA3cHAsl3NaUu8BgUgkxxI743wdhGICMGEtoW?=
 =?iso-8859-1?Q?sCmkdGulvPWUxekgNjcFv7+J0c2CgPpyrhs10yCLYY1dgDQoQNhjznDbWi?=
 =?iso-8859-1?Q?pjBEdTzkxop/YABUbviQ7DM9UuLwTZlPeGBCBkHGWb0EAyTUJKCpEu6OV3?=
 =?iso-8859-1?Q?Sr2oYaQBX4sSnK/sZbzSlKc7kEWeZbtCpiGRlOlUN11NOakzKKJxEbiYlG?=
 =?iso-8859-1?Q?JTiTEiwO1AnMAabH2B+LcYgxl9wLxPIo+sCwpjtGZzu2SOJcNRh5eHWcGw?=
 =?iso-8859-1?Q?haWmrFGHNH512ZTdXYWqT8nJpsrTiLiYuTojETeue/AGdj5Al9gl0qzcyn?=
 =?iso-8859-1?Q?lA6/q4U2DEGYXuoTBacnpkQwYFdHOhB+ZanTGxP0f9KJrAj78c1otTQCUf?=
 =?iso-8859-1?Q?dd9IUoxsk3ZoFr6MViojtBHx6mwG44nDQSecR3LfsgQgAD2noxTAMRWPOe?=
 =?iso-8859-1?Q?eQ0CTPiEYLXAb1io4T0nWf8wYwfu+PWMtuqQu56Zlal/1VG0x19cJFBBsM?=
 =?iso-8859-1?Q?4buWtS/3MqjsIUJe4z0okPWShK1BSXrYsFaO4Z1zXfKOdGBmuy+SWMS2PW?=
 =?iso-8859-1?Q?Fs748CDh0wfLyr7luvUXY+mXHi1l214PcclbzCwmjw/25rKioOduaNEoF2?=
 =?iso-8859-1?Q?LxWF+YK7M34k0aaEYUiRRMWl1W7K2mXpOn/MYXl/pkUpsyJz3RZBusmXK1?=
 =?iso-8859-1?Q?qGDMLfo+x8Ol6ZVp+X2hkVIozrCW0eUFJKZpR/yrwuznQ7tX5DLFAi09R/?=
 =?iso-8859-1?Q?/hM2qcRhAHEH1lORtJdisf0iSGYHVSO5w+ol8Xz924wir7Tvt4qAVBK0r7?=
 =?iso-8859-1?Q?82KGeRiOMW/V69TWLS1u/J0WDkUs3S6DrNXWaKWQi5cNpyuNqY3RRS0vfo?=
 =?iso-8859-1?Q?oIQ0An50XAflp/rtEe6IiFutAt0Ofd8E5Blx5DHo/w9MUI3HatMz3/pAD/?=
 =?iso-8859-1?Q?9PApVvYrlFG1P9u0lGr21qOpKpDJvNz0iZ5vVX8LnlIC0inaWGUUclsfTk?=
 =?iso-8859-1?Q?qHgxD+qlQaFS6JLsWwamPMTV2ISkeBr6MCrUmVFcOreAbcI4PxzstoUsFe?=
 =?iso-8859-1?Q?Tts3n4fsMssIM+vseyKo0lsPaoPIWcjBnOxka6kl1E6FioGCambXjIwIyt?=
 =?iso-8859-1?Q?4rmsP/JBxeioqdAAGRzaVCjKnqICKDCEOy92f7e9x7q1MHiDxBlDuC2OVr?=
 =?iso-8859-1?Q?u2dBW7UEuO1iNxWQz8j22dUCYjVtu8FOgU3JsYtQafCYrp7wmt9UZ+4tpn?=
 =?iso-8859-1?Q?d4hphBWE41reSczov3l+8OJYxA7vW3uo0MUgNVIDuuSMFnYGHOarbZusvk?=
 =?iso-8859-1?Q?Q9t8Vc7u26yGf+NV3snntIbrb/FOvNQkUj+XB9Frz20dlTJZJxeXlf0u/h?=
 =?iso-8859-1?Q?TyqipJOE9cagQfuP65giD52nIN/t6NIMCT6Y2yz5EfV8yq5iDkqrTOHxr5?=
 =?iso-8859-1?Q?+yOsKZeA2SSUnoUHsOYP73nUOz88hE7qGAsmtvm659hSFW7YozZjQ55bHR?=
 =?iso-8859-1?Q?OqWffKMwPhjNEHW3gJjU4htYNofb7Z0R46/pYxOQDmBEOD9vvSGzGqP7Ix?=
 =?iso-8859-1?Q?yT6yT8uUuvFVeBz/fUsxeIJOQzVQ7oTDkBQ6SHe50NBcdusRLqXUJjZDin?=
 =?iso-8859-1?Q?RVr5wBUrvwx+9rT2ny/LQRnqxU9gjw5QguJfMu0ibjxuWEXQNeqrySQ90Q?=
 =?iso-8859-1?Q?7DtvpcBPmVew+nyUVWO8NUvFr1N+onj6eLinXcWAuUx12BsGQABqYp/2sb?=
 =?iso-8859-1?Q?5OIeWPivn8nYVcpvSrW1Y+8zTq020Iidl4BoWqCH9AvjFb?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: gatech.edu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH3PR07MB9958.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f296d48-2d76-468e-00b7-08df2abcc770
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2026 13:03:59.7880
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 482198bb-ae7b-4b25-8b7a-6d7f32faa083
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sEiXO4Td3flyJdgGxy3At5DpqtrwTCCDxXKhuZWl71ClSZ7JOUoRhRbj+5Ukqx7RfLxmiEIbghkiZliAtBwkrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR07MB7611

From: Abd-Alrhman Masalkhi <abd.masalkhi@gatech.edu>=0A=
=0A=
--auto-detect opened md0 (9:0) and issued the RAID_AUTORUN ioctl to ask=0A=
the kernel to start the arrays it had auto-detected. The kernel removed=0A=
this ioctl in commit d82fa81c2364 ("md: replace the RAID_AUTORUN ioctl=0A=
with a direct function call"). Before that, it worked only when md was=0A=
built into the kernel. Since then, md_ioctl() has rejected it with=0A=
ENOTTY, making --auto-detect ineffective on current kernels.=0A=
=0A=
Remove autodetect(). Keep the option for now to avoid breaking existing=0A=
scripts, and print a warning message when it is used.=0A=
=0A=
Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gatech.edu>=0A=
---=0A=
 Manage.c | 13 -------------=0A=
 mdadm.c  |  2 +-=0A=
 mdadm.h  |  1 -=0A=
 3 files changed, 1 insertion(+), 15 deletions(-)=0A=
=0A=
diff --git a/Manage.c b/Manage.c=0A=
index 40d52cfc..d38336a0 100644=0A=
--- a/Manage.c=0A=
+++ b/Manage.c=0A=
@@ -1738,19 +1738,6 @@ abort:=0A=
 	return !test && busy ? 2 : 1;=0A=
 }=0A=
 =0A=
-int autodetect(void)=0A=
-{=0A=
-	/* Open any md device, and issue the RAID_AUTORUN ioctl */=0A=
-	int rv =3D 1;=0A=
-	int fd =3D dev_open("9:0", O_RDONLY);=0A=
-	if (fd >=3D 0) {=0A=
-		if (ioctl(fd, RAID_AUTORUN, 0) =3D=3D 0)=0A=
-			rv =3D 0;=0A=
-		close_fd(&fd);=0A=
-	}=0A=
-	return rv;=0A=
-}=0A=
-=0A=
 int Update_subarray(char *dev, char *subarray, enum update_opt update,=0A=
 		    struct mddev_ident *ident, int verbose)=0A=
 {=0A=
diff --git a/mdadm.c b/mdadm.c=0A=
index 2517b037..c4e234e3 100644=0A=
--- a/mdadm.c=0A=
+++ b/mdadm.c=0A=
@@ -1744,7 +1744,7 @@ int main(int argc, char *argv[])=0A=
 			rv =3D Incremental(devlist, &c, ss);=0A=
 		break;=0A=
 	case AUTODETECT:=0A=
-		autodetect();=0A=
+		pr_err("--auto-detect has no effect. It is deprecated and will be remove=
d in future releases.\n");=0A=
 		break;=0A=
 	}=0A=
 	if (ss) {=0A=
diff --git a/mdadm.h b/mdadm.h=0A=
index deac7a56..985951d3 100644=0A=
--- a/mdadm.h=0A=
+++ b/mdadm.h=0A=
@@ -1434,7 +1434,6 @@ extern int Manage_stop(char *devname, int fd, int qui=
et,=0A=
 extern int Manage_subdevs(char *devname, int fd,=0A=
 			  struct mddev_dev *devlist, int verbose, int test,=0A=
 			  enum update_opt update, int force);=0A=
-extern int autodetect(void);=0A=
 extern int Grow_Add_device(char *devname, int fd, char *newdev);=0A=
 extern int Grow_addbitmap(char *devname, int fd,=0A=
 			  struct context *c, struct shape *s);=0A=
-- =0A=
2.43.0=0A=
=0A=
