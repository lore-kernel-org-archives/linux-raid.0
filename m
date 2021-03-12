Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A5A8C433E0
	for <linux-raid@archiver.kernel.org>; Fri, 12 Mar 2021 23:01:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C781364F4D
	for <linux-raid@archiver.kernel.org>; Fri, 12 Mar 2021 23:01:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235667AbhCLXB0 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 12 Mar 2021 18:01:26 -0500
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:56466 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235664AbhCLXBV (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Fri, 12 Mar 2021 18:01:21 -0500
X-Greylist: delayed 360 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Mar 2021 18:01:21 EST
Received: from dispatch1-us1.ppe-hosted.com (localhost.localdomain [127.0.0.1])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 7A826227846
        for <linux-raid@vger.kernel.org>; Fri, 12 Mar 2021 22:55:21 +0000 (UTC)
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.193])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 2A4E860067
        for <linux-raid@vger.kernel.org>; Fri, 12 Mar 2021 22:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sigmalabsinc.com;
 h=cc:cc:content-transfer-encoding:content-transfer-encoding:content-type:content-type:date:date:from:from:message-id:message-id:mime-version:mime-version:subject:subject:to:to;
 s=selector-1613748670; bh=ZGbHCrIxaQ873yOb3dUA4Zi94BwJ+kB29rIB8esQPQY=;
 b=fJKaoDECvDp3+OSpVDJx9pMgU3wMqunEtKbrusTBCSFbyMh5Oos3QbeAsV/vBItFbSOwxtNEcxmniJPio7UFgFT/e1U2MEUrS9pNOdxVP1NGgMwxoxosC+8LfacHqlBoxdjwZkwYh+mVO1bJjNoIVOReQ1u1vC53nNsFFqVVoYQgDHdDAhMrSKuEJyuvzn4wL1eLNk4Ga8q5W7iZ/a7ULoAAKuWfW8Q7d7DkuLByeNz+m/NE8c/mbsdHdsubQWvJg79Y3MUPekUWVaEAkCFkXgXSbCmv2vKdCz1qq1Mr4w+uSmcruDqdRTDFVi1LLQl8MQRd8P0BISvbYutPRqSrgw==
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.41])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 09EEF1E0072
        for <linux-raid@vger.kernel.org>; Fri, 12 Mar 2021 22:55:18 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id AA57E4C0059
        for <linux-raid@vger.kernel.org>; Fri, 12 Mar 2021 22:55:17 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J0Ta+cMUFf44IppdRoK9d1gGL47tz4fze+f1kIirJEsa3SL1CY5WjtnqiZP0noBs4L+aEZ4yU0NvzeQBid8psFRUbqMrCWxNuTskcTCj9RxsSXg3XQ4mFYGeZSbhQMfmGWtc4YVnfg8XtpiGrGumeQmvsSh0Y1wVtaXEQYAlMZJmv67WBbczK3J/KR5hyUQiZVKj9xcCNvuAIHGJpRnrHc/lAPoi9V812GelkR4SnZZasid9kVkjNT4drB2RANYLtq4OxC7jGEuSnI7tPqAM9V7g82O5bt6VBoIzqD3wNt6opkdmIe3jlRn3HTwtXlQ3RQrs9NXOLSBHXCFJQ3hgag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZGbHCrIxaQ873yOb3dUA4Zi94BwJ+kB29rIB8esQPQY=;
 b=XsPG/pQGNUgI/CGhkiB6YSyFG5nWBmuv/UYPycpLbfe0iAidxxOTg4Y+Aen+KWLveRbEFCAnoaRrwoJ303rOIXyc4nJ/nv/K03JXfY1vsUqzF7ZBQrGevpjGyt41uC0HP58o1Gu6C/usAJquD0rB5+K/rJKpltF9fTKqcpPCsWBZSoLIiQCzq2eFvtH7NtroFVlJS5gdfWBCZcRHzlcFRdxZz3x/POsAVL1zCc3auLf7ur1oQZv6wR/z6CZlaxXw14C9g/CNRCZdYj7oP3/HJeMXr00Qh9s7hplk5XxwDIlF5y4c7UPD+ntO4evvkTImug2B8N2lCRtIjDiimIWWzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sigmalabsinc.com; dmarc=pass action=none
 header.from=sigmalabsinc.com; dkim=pass header.d=sigmalabsinc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=SigmaLabsInc.onmicrosoft.com; s=selector2-SigmaLabsInc-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZGbHCrIxaQ873yOb3dUA4Zi94BwJ+kB29rIB8esQPQY=;
 b=OfSDsyvAH7zhlxRNbBdqtY3SocPIP0fHsp/35oUlJiH9EDvd5m4gJ6c+gXXUaPtO+WAxQ+zQNGz5boQ8+NxQcadkFt/VE/ONMVNtcsVdOBjgC47UbP/xZO+I4UPS+p5c0Wa8W5DF3A6I+hBYrPA4Y7G8386AHhkxZXhz/Ha2uAM=
Received: from CY4PR1301MB2152.namprd13.prod.outlook.com
 (2603:10b6:910:41::13) by CY4PR13MB1093.namprd13.prod.outlook.com
 (2603:10b6:903:a2::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.10; Fri, 12 Mar
 2021 22:55:13 +0000
Received: from CY4PR1301MB2152.namprd13.prod.outlook.com
 ([fe80::1c73:3689:bab0:ce96]) by CY4PR1301MB2152.namprd13.prod.outlook.com
 ([fe80::1c73:3689:bab0:ce96%6]) with mapi id 15.20.3912.030; Fri, 12 Mar 2021
 22:55:13 +0000
From:   Devon Beets <devon@sigmalabsinc.com>
To:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
CC:     Glenn Wikle <gwikle@sigmalabsinc.com>
Subject: Cannot add replacement hard drive to mdadm RAID5 array
Thread-Topic: Cannot add replacement hard drive to mdadm RAID5 array
Thread-Index: AQHXF5KX6KP0YjSKk0CRteOWIC8wiA==
Date:   Fri, 12 Mar 2021 22:55:13 +0000
Message-ID: <CY4PR1301MB215210F6808E6C0BA5D751ABCA6F9@CY4PR1301MB2152.namprd13.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=sigmalabsinc.com;
x-originating-ip: [75.161.70.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8ec3a21e-cc0c-4ef7-da2a-08d8e5a9e551
x-ms-traffictypediagnostic: CY4PR13MB1093:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR13MB10939F80DBD9AF47E0AB5016CA6F9@CY4PR13MB1093.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:820;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XJ/x3vCWTfUdZiuH/7JaVMsK6atrUjEkWqVbazfKQoW7Z2Uk8RLHD7h5rUBZ0CJrEZ1zxwQfth4xqAuRG/a5XdZF68xbkd7fLdE1pbSAVa1ETPhoB5zar1c4KbF7eO0Gkw2QJjP4XfFWG1C8yRpW7qS24QvbczdBYuORTuuoMFAqV3Ki4cqwfIQJcqjEmNj/BhfOe/MDr+nZy6NH4dHb9te2xZkunzBLNjhXuNok1BHNDw8CxP5/IRap90eGdUvs7BefI+l5bOfjxYrmxI3v+oVfGsravl9nyGNBell4rEXI0bUYaieVbBgjLVG/NW+Q3gCk7AxvhmS2lYFOr5YGYj4DvY+Jyd8hb78Nu3tMc2qsO/EjBz7QehA67OFDBN5Q2N1HOxHD2rmOucONE8uhDTfYSpGf90mZuF3hk7i3129V31370MnNLcYWxym+q2Iz2CY+JqFhBqIdaf/vsGZpngGZztCbS5CIbZ1j1SI1AF97FsTwg2dIHfQpaexSREYLW1YlcOEUaIsAIi18cC+RqpcS0XnNsqdXG7BxS369UfHwNn1VSF5OIh239zSb5xtiADPg0+uGGgqZcXYx+7Vopc9IqWd3r6UX+H/qX60hB8K4Yv9b4oeC4TtLburgZB6nbLzP18UESRGuDOG/GzIbiw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1301MB2152.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(39830400003)(346002)(396003)(366004)(478600001)(8676002)(6506007)(86362001)(4326008)(7696005)(6916009)(8936002)(71200400001)(316002)(2906002)(15974865002)(55016002)(107886003)(33656002)(26005)(9686003)(186003)(66476007)(66446008)(66946007)(76116006)(64756008)(52536014)(5660300002)(66556008)(83380400001)(30864003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?koi8-r?Q?6+85jnTCSPhds6jWvi8BOo1Epfpi9yT22fta2oByv5Lzy0lnsKS6YYx8QVFb4z?=
 =?koi8-r?Q?Kycums08GaVfqgcxOb9O91ftzggPkKMU/W9DUcWQiN23pQmQUq8QBMq3XdiJMl?=
 =?koi8-r?Q?oNnwPMHJI03aWJkKCFqK46M3gNdh1DKfPXEuKNGdS3uY76BhfY7MnlCF6oNxca?=
 =?koi8-r?Q?py9PlSFL87a1Iu/iUy8MXvO2KcwIutrpX/8DfXm/HTlOFwWnKcZtCZX/28wwXH?=
 =?koi8-r?Q?9icT9gY347nSdoFWrIDnNCIz9oh93679p+njnUaQKBVgn52zIDD2zI6cWr0/j4?=
 =?koi8-r?Q?GWXNAW6md+BvgXnBsQkmBW0Fdk/VZ7SltCtgVihKmDOLlIGlVKLyT541RStKj5?=
 =?koi8-r?Q?7+XBl4jottrkYzIXijItZIBFIjHz2ir4pbKHi5GBByojGi7FI5rId/KyMXF8IJ?=
 =?koi8-r?Q?CvzkJuRzyyEBwo4NssojEM1n7hUJfyBe/82kZeqbBY2ldJZ7G61vcxhL3xd6rt?=
 =?koi8-r?Q?sMSPxtb3ysgdAKxOSHO5OILv9Ro712woizdYg2RgZdyNetCkzgmTnL/pkhvVSk?=
 =?koi8-r?Q?/mDjGCJQEE8k7/d8mzih9gtXkDXm/i8IVMfK7BudNSOIdsvVl3dVQ/6nD4DY1H?=
 =?koi8-r?Q?t3C2H93z9uyyOZZf4yKNZPgIR69Yisn7LvIwHhpu9YB0b8MHCzglZ2Qu5/j0S/?=
 =?koi8-r?Q?F0IO4f4kng0TkPDyNdZfw1em8yIrgOhhT2XCCMKMuM/cvavdHwXpPKYdJmRx2p?=
 =?koi8-r?Q?x1GIcOmHZMFbd9LueXyBJCDsqh6JMMi/gtHa2whZuquUpzOth0uUHKLoB1zwVR?=
 =?koi8-r?Q?VpAvSXJUv3QsTieGDbCg4nc8Miu6H+Jht++8dCrzw+5fHsdxrjj5U86Lu5xffz?=
 =?koi8-r?Q?osMPZRa+SFcsycZB1u1Ej6MaVPWerFOhZau7M0B97locZgg1Fr2kUhX+fONgya?=
 =?koi8-r?Q?wSpFiMaqv7z/2BTqZ+R8vfJtKI/A4rZAyVU7oqhcDRRMMMcGBVH360jVEEendY?=
 =?koi8-r?Q?S+jXPcXxazY6xtlyGwm3VWRND5V/CWJk1b4qlWsnwniTHo98gHakox0+ceIBaI?=
 =?koi8-r?Q?e+rhEBltOV9GZrVu+jct6DEIxk8IIUefWu2PqBAy+iaYOdwKzt2/fw9RRTi/Ol?=
 =?koi8-r?Q?sw78wIxyOHMdKpK8Lt1urWDKDTzZKGRC7+MIsn6dsMJLllWDFYgPcbzbNW+HnZ?=
 =?koi8-r?Q?/ZxH3HRvKTCkbUwpbztSsSUn5Zo8ixcapoCzX8ZRECLGOY2eYOvTw7WqnP2HKk?=
 =?koi8-r?Q?KmKgkSRV/xRJwziwkTgSFQtTvXtmElOJXr5er1F/piZ+4ov4sxK3rwPKImGCN5?=
 =?koi8-r?Q?knOsATYImM45fwFJSykS0=3D?=
Content-Type: text/plain; charset="koi8-r"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sigmalabsinc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1301MB2152.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ec3a21e-cc0c-4ef7-da2a-08d8e5a9e551
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2021 22:55:13.1606
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e9f66b05-a3b6-442b-87aa-e65ebd76d5c3
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Uk6YopANWJY0PsIj15+HWyDF9xZCzwkEpXEWDv1QRdc5CZEl29hR5NbD/oc9L+/BuFPlNLTujjlmovevde0K+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR13MB1093
X-MDID: 1615589718-DJlWngcmlWDA
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello,=0A=
=0A=
My colleague and I have been trying to replace a failed hard drive in a fou=
r-drive RAID5 array (/dev/sda to /dev/sdd). The failed drive is sdb. We hav=
e physically removed the hard drive and replaced it with a new drive that h=
as identical specifications. We did not first use mdadm to set the failed h=
ard drive with --fail.=0A=
=0A=
Upon booting the system with the new /dev/sdb drive installed, we see that =
instead of the usual two md entries (/dev/md127 which is an IMSM container =
and /dev/md126 which is the actual array) there are now three entries: md12=
5 to md127. md127 is the IMSM container for sda, sdc, and sdd. md125 is a n=
ew container for sdb that we do not want. md126 is the actual array and onl=
y contains sda, sdc, and sdd. We tried to use --stop and --remove to get ri=
d of md125, then add sdb to md127, and assemble to see if it adds to md126.=
 It does not.=0A=
=0A=
Below is the output of some commands for additional diagnostic information.=
 Please let me know if you need more. =0A=
=0A=
Note: The output of these commands is after a fresh reboot, without/before =
all the other commands we tried to fix it. It gets reset to this state afte=
r every reboot we tried so far.=0A=
=0A=
uname -a=0A=
Linux aerospace-pr3d-app 4.4.0-194-generic #226-Ubuntu SMP Wed Oct 21 10:19=
:36 UTC 2020 x86_64 x86_64 x86_64 GNU/Linux=0A=
=0A=
sudo mdadm --version=0A=
mdadm - v4.1-126-gbdbe7f8 - 2021-03-09=0A=
=0A=
sudo smartctl -H -i -l scterc /dev/sda=0A=
smartctl 6.5 2016-01-24 r4214 [x86_64-linux-4.4.0-194-generic] (local build=
)=0A=
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org=
=0A=
=0A=
=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D=0A=
Device Model:     ST2000NX0253=0A=
Serial Number:    W461SCHM=0A=
LU WWN Device Id: 5 000c50 0b426d2d0=0A=
Firmware Version: SN05=0A=
User Capacity:    2,000,398,934,016 bytes [2.00 TB]=0A=
Sector Sizes:     512 bytes logical, 4096 bytes physical=0A=
Rotation Rate:    7200 rpm=0A=
Form Factor:      2.5 inches=0A=
Device is:        Not in smartctl database [for details use: -P showall]=0A=
ATA Version is:   ACS-3 (minor revision not indicated)=0A=
SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s)=0A=
Local Time is:    Thu Mar 11 15:07:30 2021 MST=0A=
SMART support is: Available - device has SMART capability.=0A=
SMART support is: Enabled=0A=
=0A=
=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D=0A=
SMART overall-health self-assessment test result: PASSED=0A=
=0A=
SCT Error Recovery Control:=0A=
           Read:    100 (10.0 seconds)=0A=
          Write:    100 (10.0 seconds)=0A=
 =0A=
=0A=
sudo smartctl -H -i -l scterc /dev/sdb=0A=
smartctl 6.5 2016-01-24 r4214 [x86_64-linux-4.4.0-194-generic] (local build=
)=0A=
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org=
=0A=
=0A=
=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D=0A=
Device Model:     ST2000NX0253=0A=
Serial Number:    W462MZ0R=0A=
LU WWN Device Id: 5 000c50 0c569b51c=0A=
Firmware Version: SN05=0A=
User Capacity:    2,000,398,934,016 bytes [2.00 TB]=0A=
Sector Sizes:     512 bytes logical, 4096 bytes physical=0A=
Rotation Rate:    7200 rpm=0A=
Form Factor:      2.5 inches=0A=
Device is:        Not in smartctl database [for details use: -P showall]=0A=
ATA Version is:   ACS-3 (minor revision not indicated)=0A=
SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s)=0A=
Local Time is:    Thu Mar 11 15:09:34 2021 MST=0A=
SMART support is: Available - device has SMART capability.=0A=
SMART support is: Enabled=0A=
=0A=
=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D=0A=
SMART overall-health self-assessment test result: PASSED=0A=
=0A=
SCT Error Recovery Control:=0A=
           Read:    100 (10.0 seconds)=0A=
          Write:    100 (10.0 seconds)=0A=
 =0A=
sudo smartctl -H -i -l scterc /dev/sdc=0A=
smartctl 6.5 2016-01-24 r4214 [x86_64-linux-4.4.0-194-generic] (local build=
)=0A=
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org=
=0A=
=0A=
=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D=0A=
Device Model:     ST2000NX0253=0A=
Serial Number:    W461NLPM=0A=
LU WWN Device Id: 5 000c50 0b426f335=0A=
Firmware Version: SN05=0A=
User Capacity:    2,000,398,934,016 bytes [2.00 TB]=0A=
Sector Sizes:     512 bytes logical, 4096 bytes physical=0A=
Rotation Rate:    7200 rpm=0A=
Form Factor:      2.5 inches=0A=
Device is:        Not in smartctl database [for details use: -P showall]=0A=
ATA Version is:   ACS-3 (minor revision not indicated)=0A=
SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s)=0A=
Local Time is:    Thu Mar 11 15:14:38 2021 MST=0A=
SMART support is: Available - device has SMART capability.=0A=
SMART support is: Enabled=0A=
=0A=
=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D=0A=
SMART overall-health self-assessment test result: PASSED=0A=
=0A=
SCT Error Recovery Control:=0A=
           Read:    100 (10.0 seconds)=0A=
          Write:    100 (10.0 seconds)=0A=
=0A=
sudo smartctl -H -i -l scterc /dev/sdd=0A=
smartctl 6.5 2016-01-24 r4214 [x86_64-linux-4.4.0-194-generic] (local build=
)=0A=
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org=
=0A=
=0A=
=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D=0A=
Device Model:     ST2000NX0253=0A=
Serial Number:    W461NHAB=0A=
LU WWN Device Id: 5 000c50 0b426f8a4=0A=
Firmware Version: SN05=0A=
User Capacity:    2,000,398,934,016 bytes [2.00 TB]=0A=
Sector Sizes:     512 bytes logical, 4096 bytes physical=0A=
Rotation Rate:    7200 rpm=0A=
Form Factor:      2.5 inches=0A=
Device is:        Not in smartctl database [for details use: -P showall]=0A=
ATA Version is:   ACS-3 (minor revision not indicated)=0A=
SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s)=0A=
Local Time is:    Thu Mar 11 15:16:24 2021 MST=0A=
SMART support is: Available - device has SMART capability.=0A=
SMART support is: Enabled=0A=
=0A=
=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D=0A=
SMART overall-health self-assessment test result: PASSED=0A=
=0A=
SCT Error Recovery Control:=0A=
           Read:    100 (10.0 seconds)=0A=
          Write:    100 (10.0 seconds)=0A=
 =0A=
sudo mdadm --examine /dev/sda=0A=
/dev/sda:=0A=
          Magic : Intel Raid ISM Cfg Sig.=0A=
        Version : 1.3.00=0A=
    Orig Family : 154b243e=0A=
         Family : 154b243e=0A=
     Generation : 000003aa=0A=
  Creation Time : Unknown=0A=
     Attributes : All supported=0A=
           UUID : 72360627:bb745f4c:aedafaab:e25d3123=0A=
       Checksum : 21ae5a2a correct=0A=
    MPB Sectors : 2=0A=
          Disks : 4=0A=
   RAID Devices : 1=0A=
=0A=
  Disk00 Serial : W461SCHM=0A=
          State : active=0A=
             Id : 00000000=0A=
    Usable Size : 3907018766 (1863.01 GiB 2000.39 GB)=0A=
=0A=
[Data]:=0A=
       Subarray : 0=0A=
           UUID : 764aa814:831953a1:06cf2a07:1ca42b2e=0A=
     RAID Level : 5 <-- 5=0A=
        Members : 4 <-- 4=0A=
          Slots : [U_UU] <-- [U_UU]=0A=
    Failed disk : 1=0A=
      This Slot : 0=0A=
    Sector Size : 512=0A=
     Array Size : 11135008768 (5.19 TiB 5.70 TB)=0A=
   Per Dev Size : 3711671808 (1769.86 GiB 1900.38 GB)=0A=
  Sector Offset : 0=0A=
    Num Stripes : 28997420=0A=
     Chunk Size : 64 KiB <-- 64 KiB=0A=
       Reserved : 0=0A=
  Migrate State : repair=0A=
      Map State : degraded <-- degraded=0A=
     Checkpoint : 462393 (512)=0A=
    Dirty State : dirty=0A=
     RWH Policy : off=0A=
      Volume ID : 1=0A=
=0A=
  Disk01 Serial : W461S13X:0=0A=
          State : active=0A=
             Id : ffffffff=0A=
    Usable Size : 3907018766 (1863.01 GiB 2000.39 GB)=0A=
=0A=
  Disk02 Serial : W461NLPM=0A=
          State : active=0A=
             Id : 00000002=0A=
    Usable Size : 3907018766 (1863.01 GiB 2000.39 GB)=0A=
=0A=
  Disk03 Serial : W461NHAB=0A=
          State : active=0A=
             Id : 00000003=0A=
    Usable Size : 3907018766 (1863.01 GiB 2000.39 GB)=0A=
=0A=
sudo mdadm --examine /dev/sdb=0A=
/dev/sdb:=0A=
          Magic : Intel Raid ISM Cfg Sig.=0A=
        Version : 1.0.00=0A=
    Orig Family : 00000000=0A=
         Family : e5cd8601=0A=
     Generation : 00000001=0A=
  Creation Time : Unknown=0A=
     Attributes : All supported=0A=
           UUID : 00000000:00000000:00000000:00000000=0A=
       Checksum : cb9b0c02 correct=0A=
    MPB Sectors : 1=0A=
          Disks : 1=0A=
   RAID Devices : 0=0A=
=0A=
  Disk00 Serial : W462MZ0R=0A=
          State : spare=0A=
             Id : 04000000=0A=
    Usable Size : 3907026958 (1863.02 GiB 2000.40 GB)=0A=
=0A=
    Disk Serial : W462MZ0R=0A=
          State : spare=0A=
             Id : 04000000=0A=
    Usable Size : 3907026958 (1863.02 GiB 2000.40 GB)=0A=
=0A=
sudo mdadm --examine /dev/sdc=0A=
/dev/sdc:=0A=
          Magic : Intel Raid ISM Cfg Sig.=0A=
        Version : 1.3.00=0A=
    Orig Family : 154b243e=0A=
         Family : 154b243e=0A=
     Generation : 000003aa=0A=
  Creation Time : Unknown=0A=
     Attributes : All supported=0A=
           UUID : 72360627:bb745f4c:aedafaab:e25d3123=0A=
       Checksum : 21ae5a2a correct=0A=
    MPB Sectors : 2=0A=
          Disks : 4=0A=
   RAID Devices : 1=0A=
=0A=
  Disk02 Serial : W461NLPM=0A=
          State : active=0A=
             Id : 00000002=0A=
    Usable Size : 3907018766 (1863.01 GiB 2000.39 GB)=0A=
=0A=
[Data]:=0A=
       Subarray : 0=0A=
           UUID : 764aa814:831953a1:06cf2a07:1ca42b2e=0A=
     RAID Level : 5 <-- 5=0A=
        Members : 4 <-- 4=0A=
          Slots : [U_UU] <-- [U_UU]=0A=
    Failed disk : 1=0A=
      This Slot : 2=0A=
    Sector Size : 512=0A=
     Array Size : 11135008768 (5.19 TiB 5.70 TB)=0A=
   Per Dev Size : 3711671808 (1769.86 GiB 1900.38 GB)=0A=
  Sector Offset : 0=0A=
    Num Stripes : 28997420=0A=
     Chunk Size : 64 KiB <-- 64 KiB=0A=
       Reserved : 0=0A=
  Migrate State : repair=0A=
      Map State : degraded <-- degraded=0A=
     Checkpoint : 462393 (512)=0A=
    Dirty State : dirty=0A=
     RWH Policy : off=0A=
      Volume ID : 1=0A=
=0A=
  Disk00 Serial : W461SCHM=0A=
          State : active=0A=
             Id : 00000000=0A=
    Usable Size : 3907018766 (1863.01 GiB 2000.39 GB)=0A=
=0A=
  Disk01 Serial : W461S13X:0=0A=
          State : active=0A=
             Id : ffffffff=0A=
    Usable Size : 3907018766 (1863.01 GiB 2000.39 GB)=0A=
=0A=
  Disk03 Serial : W461NHAB=0A=
          State : active=0A=
             Id : 00000003=0A=
    Usable Size : 3907018766 (1863.01 GiB 2000.39 GB)=0A=
=0A=
sudo mdadm --examine /dev/sdd=0A=
/dev/sdd:=0A=
          Magic : Intel Raid ISM Cfg Sig.=0A=
        Version : 1.3.00=0A=
    Orig Family : 154b243e=0A=
         Family : 154b243e=0A=
     Generation : 000003aa=0A=
  Creation Time : Unknown=0A=
     Attributes : All supported=0A=
           UUID : 72360627:bb745f4c:aedafaab:e25d3123=0A=
       Checksum : 21ae5a2a correct=0A=
    MPB Sectors : 2=0A=
          Disks : 4=0A=
   RAID Devices : 1=0A=
=0A=
  Disk03 Serial : W461NHAB=0A=
          State : active=0A=
             Id : 00000003=0A=
    Usable Size : 3907018766 (1863.01 GiB 2000.39 GB)=0A=
=0A=
[Data]:=0A=
       Subarray : 0=0A=
           UUID : 764aa814:831953a1:06cf2a07:1ca42b2e=0A=
     RAID Level : 5 <-- 5=0A=
        Members : 4 <-- 4=0A=
          Slots : [U_UU] <-- [U_UU]=0A=
    Failed disk : 1=0A=
      This Slot : 3=0A=
    Sector Size : 512=0A=
     Array Size : 11135008768 (5.19 TiB 5.70 TB)=0A=
   Per Dev Size : 3711671808 (1769.86 GiB 1900.38 GB)=0A=
  Sector Offset : 0=0A=
    Num Stripes : 28997420=0A=
     Chunk Size : 64 KiB <-- 64 KiB=0A=
       Reserved : 0=0A=
  Migrate State : repair=0A=
      Map State : degraded <-- degraded=0A=
     Checkpoint : 462393 (512)=0A=
    Dirty State : dirty=0A=
     RWH Policy : off=0A=
      Volume ID : 1=0A=
=0A=
  Disk00 Serial : W461SCHM=0A=
          State : active=0A=
             Id : 00000000=0A=
    Usable Size : 3907018766 (1863.01 GiB 2000.39 GB)=0A=
=0A=
  Disk01 Serial : W461S13X:0=0A=
          State : active=0A=
             Id : ffffffff=0A=
    Usable Size : 3907018766 (1863.01 GiB 2000.39 GB)=0A=
=0A=
  Disk02 Serial : W461NLPM=0A=
          State : active=0A=
             Id : 00000002=0A=
    Usable Size : 3907018766 (1863.01 GiB 2000.39 GB)=0A=
sudo mdadm --detail /dev/md125=0A=
/dev/md125:=0A=
           Version : imsm=0A=
        Raid Level : container=0A=
     Total Devices : 1=0A=
=0A=
   Working Devices : 1=0A=
=0A=
     Member Arrays :=0A=
=0A=
    Number   Major   Minor   RaidDevice=0A=
=0A=
       -       8       16        -        /dev/sdb=0A=
=0A=
sudo mdadm --detail /dev/md126=0A=
/dev/md126:=0A=
         Container : /dev/md/imsm0, member 0=0A=
        Raid Level : raid5=0A=
     Used Dev Size : 1855835904 (1769.86 GiB 1900.38 GB)=0A=
      Raid Devices : 4=0A=
     Total Devices : 3=0A=
=0A=
             State : active, FAILED, Not Started=0A=
    Active Devices : 3=0A=
   Working Devices : 3=0A=
    Failed Devices : 0=0A=
     Spare Devices : 0=0A=
=0A=
            Layout : left-asymmetric=0A=
        Chunk Size : 64K=0A=
=0A=
Consistency Policy : unknown=0A=
=0A=
=0A=
              UUID : 764aa814:831953a1:06cf2a07:1ca42b2e=0A=
    Number   Major   Minor   RaidDevice State=0A=
       -       0        0        0      removed=0A=
       -       0        0        1      removed=0A=
       -       0        0        2      removed=0A=
       -       0        0        3      removed=0A=
=0A=
       -       8        0        0      sync   /dev/sda=0A=
       -       8       32        2      sync   /dev/sdc=0A=
       -       8       48        3      sync   /dev/sdd=0A=
=0A=
sudo mdadm --detail /dev/md127=0A=
/dev/md127:=0A=
           Version : imsm=0A=
        Raid Level : container=0A=
     Total Devices : 3=0A=
=0A=
   Working Devices : 3=0A=
=0A=
=0A=
              UUID : 72360627:bb745f4c:aedafaab:e25d3123=0A=
     Member Arrays : /dev/md126=0A=
=0A=
    Number   Major   Minor   RaidDevice=0A=
=0A=
       -       8        0        -        /dev/sda=0A=
       -       8       32        -        /dev/sdc=0A=
       -       8       48        -        /dev/sdd=0A=
 =0A=
lsdrv=0A=
**Warning** The following utility(ies) failed to execute:=0A=
  sginfo=0A=
Some information may be missing.=0A=
=0A=
PCI [nvme] 04:00.0 Non-Volatile memory controller: Samsung Electronics Co L=
td NVMe SSD Controller SM981/PM981=0A=
=84nvme nvme0 Samsung SSD 970 EVO Plus 500GB           {S4P2NF0M501223D}=0A=
 =84nvme0n1 465.76g [259:0] Empty/Unknown=0A=
  =86nvme0n1p1 512.00m [259:1] Empty/Unknown=0A=
  =81=84Mounted as /dev/nvme0n1p1 @ /boot/efi=0A=
  =86nvme0n1p2 732.00m [259:2] Empty/Unknown=0A=
  =81=84Mounted as /dev/nvme0n1p2 @ /boot=0A=
  =84nvme0n1p3 464.54g [259:3] Empty/Unknown=0A=
   =86dm-0 463.59g [252:0] Empty/Unknown=0A=
   =81=84Mounted as /dev/mapper/customer--pr3d--app--vg-root @ /=0A=
   =84dm-1 980.00m [252:1] Empty/Unknown=0A=
PCI [ahci] 00:11.5 SATA controller: Intel Corporation C620 Series Chipset F=
amily SSATA Controller [AHCI mode] (rev 09)=0A=
=84scsi 0:x:x:x [Empty]=0A=
PCI [ahci] 00:17.0 RAID bus controller: Intel Corporation C600/X79 series c=
hipset SATA RAID Controller (rev 09)=0A=
=86scsi 2:0:0:0 ATA      ST2000NX0253=0A=
=81=84sda 1.82t [8:0] Empty/Unknown=0A=
=81 =86md126 0.00k [9:126] MD vexternal:/md127/0 raid5 (4) inactive, 64k Ch=
unk, None (None) None {None}=0A=
=81 =81                    Empty/Unknown=0A=
=81 =84md127 0.00k [9:127] MD vexternal:imsm  () inactive, None (None) None=
 {None}=0A=
=81                      Empty/Unknown=0A=
=86scsi 3:0:0:0 ATA      ST2000NX0253=0A=
=81=84sdb 1.82t [8:16] Empty/Unknown=0A=
=81 =84md125 0.00k [9:125] MD vexternal:imsm  () inactive, None (None) None=
 {None}=0A=
=81                      Empty/Unknown=0A=
=86scsi 4:0:0:0 ATA      ST2000NX0253=0A=
=81=84sdc 1.82t [8:32] Empty/Unknown=0A=
=81 =86md126 0.00k [9:126] MD vexternal:/md127/0 raid5 (4) inactive, 64k Ch=
unk, None (None) None {None}=0A=
=81 =81                    Empty/Unknown=0A=
=86scsi 5:0:0:0 ATA      ST2000NX0253=0A=
=81=84sdd 1.82t [8:48] Empty/Unknown=0A=
=81 =86md126 0.00k [9:126] MD vexternal:/md127/0 raid5 (4) inactive, 64k Ch=
unk, None (None) None {None}=0A=
=81 =81                    Empty/Unknown=0A=
=84scsi 6:0:0:0 Slimtype DVD A  DS8ACSH=0A=
 =84sr0 1.00g [11:0] Empty/Unknown=0A=
Other Block Devices=0A=
=86loop0 0.00k [7:0] Empty/Unknown=0A=
=86loop1 0.00k [7:1] Empty/Unknown=0A=
=86loop2 0.00k [7:2] Empty/Unknown=0A=
=86loop3 0.00k [7:3] Empty/Unknown=0A=
=86loop4 0.00k [7:4] Empty/Unknown=0A=
=86loop5 0.00k [7:5] Empty/Unknown=0A=
=86loop6 0.00k [7:6] Empty/Unknown=0A=
=84loop7 0.00k [7:7] Empty/Unknown=0A=
=0A=
cat /proc/mdstat=0A=
Personalities : [raid6] [raid5] [raid4] [linear] [multipath] [raid0] [raid1=
] [raid10]=0A=
md125 : inactive sdb[0](S)=0A=
      1105 blocks super external:imsm=0A=
=0A=
md126 : inactive sda[2] sdc[1] sdd[0]=0A=
      5567507712 blocks super external:/md127/0=0A=
=0A=
md127 : inactive sdc[2](S) sdd[1](S) sda[0](S)=0A=
      9459 blocks super external:imsm=0A=
=0A=
unused devices: <none>=0A=
=0A=
=0A=
Thanks for the help!=0A=
Devon Beets=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
