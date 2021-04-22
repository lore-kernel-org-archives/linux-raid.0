Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78333C433ED
	for <linux-raid@archiver.kernel.org>; Thu, 22 Apr 2021 18:05:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 307FB60FE8
	for <linux-raid@archiver.kernel.org>; Thu, 22 Apr 2021 18:05:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236667AbhDVSGD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 22 Apr 2021 14:06:03 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.48]:51214 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236287AbhDVSGC (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Thu, 22 Apr 2021 14:06:02 -0400
X-Greylist: delayed 503 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Apr 2021 14:06:02 EDT
Received: from dispatch1-us1.ppe-hosted.com (localhost.localdomain [127.0.0.1])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 19F3C2284F4
        for <linux-raid@vger.kernel.org>; Thu, 22 Apr 2021 17:57:04 +0000 (UTC)
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.67.77])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id BF64660067;
        Thu, 22 Apr 2021 17:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sigmalabsinc.com;
 h=cc:cc:content-transfer-encoding:content-transfer-encoding:content-type:content-type:date:date:from:from:in-reply-to:in-reply-to:message-id:message-id:mime-version:mime-version:references:references:subject:subject:to:to;
 s=selector-1613748670; bh=e1doRUKvufFwQJdnmE4Ir3AqiuzqZBCyLj/aL1PWKe0=;
 b=hM96MLCIvpv7EJVJ3+7W6H6bdCusIx/WEBMpZjx0rzUMe6wENzdI1o1r6UzNyfRz/eHNkPvQySVu61wOSVfHh0iWAfAkA5IlXqbepxukbx0b6h+7OqhM3R1cEkmF02UbG9hjDuiHBSqNko9O+5hBD0ciIjRgTYKg7L9gXIFNG9tmMbVw83UNU8kAahtESeG6sODzBRUKtdnj/sXxxjjIx3mWl3gObegYeK6BByhUiBmlnuGT3XpnqO3cseR1q/uo2dq3EQHUXqmBlDf9j9x9C8vAqBafgN6vTUCvFweyYpApQoWphDAdEtnoM+rpDyj8bEBF6YzyRRWajDlb1rXJsg==
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.67.131])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id A87301C006B;
        Thu, 22 Apr 2021 17:57:02 +0000 (UTC)
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (mail-co1nam04lp2059.outbound.protection.outlook.com [104.47.45.59])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id EB353980074;
        Thu, 22 Apr 2021 17:56:57 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UnKp75Uvu412PihswGw+lY30A7VkMvEH7RCPOW9y4+00mMX9sBAwK57Q2xGdRgz3EdGTlqkG2zl6hWmWAw82xO3W6gEXwFlS7fcN7cp6GO0Jl+ffgqDYy3vKw0bA5ENOvs0iUAv1xfyvRpgMZGmZdx1/sHQohzepitCeXTHsac54I4JkTlMyLics5s+nnD7fhxgvkR/4BAVxivBMnJVDs3n7Y8ZY6fZUIWPPznG89GXl7m8VOiJdXOeXBqdbHf3z1RUgeukF8MFf4ZRz97CQpm1jHSK1vM12+6cgHV7dPckP1R6QuAc9QaHWDQ4biV3C/GGNMH3I883XqghqFMiQcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e1doRUKvufFwQJdnmE4Ir3AqiuzqZBCyLj/aL1PWKe0=;
 b=XRcaheAwAduFbJj/7IFP9CFJVhc8Cd0tYMx1qZkmNuUZTj7X0sxfhLvuSm3vY1rHv1vJw3UACrKHhjEYqr//jyNw9gwIO2FhOQZnmxTYLOOwgi8AiZRXccOvIntCEXlI3V9PgY9SsMVtiHhZB1ZabEfX/33wxskwV2LBl2XNHaj+VLg4w6N+zH0+6PyOo0uT6kh6Yi8CqCvwc8YsSebWcVGi7g/UAb6bJJGH/YfWeYCflhGphFBKKWAGGEnqJf8C3eFACAOMgCUKKQAJYJmwlF2mFDaBJSq+LWNOK2WO0X9MYTic48s+Xwy7e3yCNaG1IGmyIMh7HQPTydbe8Y7ozw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sigmalabsinc.com; dmarc=pass action=none
 header.from=sigmalabsinc.com; dkim=pass header.d=sigmalabsinc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=SigmaLabsInc.onmicrosoft.com; s=selector2-SigmaLabsInc-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e1doRUKvufFwQJdnmE4Ir3AqiuzqZBCyLj/aL1PWKe0=;
 b=h3rAT+OA0oGyp0t7IuNwzYhLseiWlXiZB+NKZ5vUUMjZ5OXeXp8hETGJyDR9Rc+Luj6uiRUOKMZO3fKDzj1p/4r20g0uPHm5gWjCKaNWHhvx/yp6WcSNW7FyW8Ec95tnciHhvKFXYlimcAWFCYQdP4Y4+RHtEDiw7BSW0TTQay8=
Received: from CY4PR1301MB2152.namprd13.prod.outlook.com
 (2603:10b6:910:41::13) by CY4PR13MB1016.namprd13.prod.outlook.com
 (2603:10b6:903:37::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.7; Thu, 22 Apr
 2021 17:56:56 +0000
Received: from CY4PR1301MB2152.namprd13.prod.outlook.com
 ([fe80::4115:d5c4:e2c9:a334]) by CY4PR1301MB2152.namprd13.prod.outlook.com
 ([fe80::4115:d5c4:e2c9:a334%6]) with mapi id 15.20.4065.023; Thu, 22 Apr 2021
 17:56:55 +0000
From:   Devon Beets <devon@sigmalabsinc.com>
To:     Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
CC:     Glenn Wikle <gwikle@sigmalabsinc.com>
Subject: Re: Cannot add replacement hard drive to mdadm RAID5 array
Thread-Topic: Cannot add replacement hard drive to mdadm RAID5 array
Thread-Index: AQHXF5KX6KP0YjSKk0CRteOWIC8wiKqFIoYAgAEnRYCAIcX6A4AA8cMAgBgKVb4=
Date:   Thu, 22 Apr 2021 17:56:55 +0000
Message-ID: <CY4PR1301MB2152C29CB86A1512996B422ECA469@CY4PR1301MB2152.namprd13.prod.outlook.com>
References: <CY4PR1301MB215210F6808E6C0BA5D751ABCA6F9@CY4PR1301MB2152.namprd13.prod.outlook.com>
 <027a7faa-8858-2488-2771-0d412ef73866@intel.com>
 <45914472-b918-8a34-e531-fa145ec670fc@linux.intel.com>
 <CY4PR1301MB215250DF9BB395E3D2233CF0CA769@CY4PR1301MB2152.namprd13.prod.outlook.com>,<2c14c3cd-d171-88fc-f770-8ab27fd8c0d0@intel.com>
In-Reply-To: <2c14c3cd-d171-88fc-f770-8ab27fd8c0d0@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=sigmalabsinc.com;
x-originating-ip: [50.193.235.20]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e4648dcb-b401-4bed-b5cb-08d905b8049a
x-ms-traffictypediagnostic: CY4PR13MB1016:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR13MB1016BA05A8B5D40AEF25FA4DCA469@CY4PR13MB1016.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: K1z4VCGPrEHOQ+iaX7jTsN7ICJ2Ii6p4Pi1Cr22cFEi+8cN491Lm+g6aQ14CibhMOiia2JLqTuQVgjIKxLsnQd37pwfZg4a3Yara1F9KLQliQpLoQUuG3F6MgmhEGMX3Azi0e+irQl6NZK81jCgt2rXMZvu8MP6G5kKPFTbi6gp7dsQN9NgedNlYOLsMcQ21tF2T0Qx3XArnY9YlYyuQlF12akO/oWfS5SGzW06ImsF14iMquMcIjhLWvpgLuxn29EyRfImpZkYKFjeQXriWtxcAspXLY8T8dpjK+nNykbWB++K7T4JaoCRV6UznCEbuMHd0umYB0Mq1/dvDYRY/3MPC184qSUlFcUDiLfBVf7vc1pna2IaE8iWv+QH/FG7SfQEPnQ9gMEtMlVcZ9ZSbGVLkSFkAnQ2p8DgwWIpe0NjvsX0lM1Niyg8rqD2Mm9hnr7uxhzpo/kp6kHLljNXwnk3gIdCOR6KuDTuT2C/YPnzCDF0SrRCNxKDgNDm6bF7gxZ1QuOgk3Xsz1N7UzHkKt7hFCRT+sxBaL6fWVlK/Jmb0v3tq916xYo5rz662+iNhwptP29oYjXXoHUa8fAR7P7h7iWLor1DEjTDAdmX0hQY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1301MB2152.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(376002)(346002)(396003)(39830400003)(71200400001)(52536014)(2906002)(478600001)(9686003)(6506007)(64756008)(186003)(53546011)(107886003)(66556008)(316002)(7696005)(5660300002)(55016002)(110136005)(66446008)(66946007)(66476007)(76116006)(26005)(8936002)(38100700002)(122000001)(4326008)(83380400001)(33656002)(8676002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?x4exk+OTnSe6Wv3vpMk4Fwm2ZgtF2orubDGXeCTTe02C6sCoLJFKLTKmh2?=
 =?iso-8859-1?Q?KpzsaaJ9HuNiPLZWtSf8JarVi0VmwkD70n6ckh9VmucJAwaCYsjwc+H/a3?=
 =?iso-8859-1?Q?oV95gwtpYQqBQnknBGmnifOaBirZQhXR9ND/Iswemj3LCqz+J8vI0Nfd53?=
 =?iso-8859-1?Q?XziXAM8A5wTyLSwI0LpkoJJAemFJ11ZeipTOl1Ur+/iVcWcf1dAJCP5OKz?=
 =?iso-8859-1?Q?HTqBgu8BEStqwdI/FqZw6XbfX332Eg6b1XY2LB3fJlmcWWqyzMfCfk3/Lm?=
 =?iso-8859-1?Q?Gtj12gyi1SwbQM1OFciT13s1KrTPUYKc0f3IuRL0L9iBcGR03ouKaMwQmT?=
 =?iso-8859-1?Q?VOkefo6MoRiVF7swpppx/YN5W2ZLZoeQZ0Zxj1Pzg4RhZB4IKxY8i2PsEV?=
 =?iso-8859-1?Q?2tMFku1LuEi3a7k5VYAxyHfcAfpYFOoFJmYqqC3Uqfh4IUA6LmE8z6i0TN?=
 =?iso-8859-1?Q?O65CxxvwyodeYil0+AnPsyc4IcMIl+qfHSoCoclqBymBJLxDAETIA4WRGG?=
 =?iso-8859-1?Q?fPDLcjZzeFkGHXFQUONK3Y9Gd8GpVhRD0mYKTm93gTFYf70A1IoIac7nY9?=
 =?iso-8859-1?Q?6c91SMP5IN7QhKX8nGzgFzWldzYRoMenhb1EG2IknBcbCEuvNaL+9zFeXU?=
 =?iso-8859-1?Q?1BfiVxk7x1+YBbJ7vuPCfD9kYDScfWNn05KebQdiM9eST+LywGT+EiaiyQ?=
 =?iso-8859-1?Q?S+PdotNN7M/FdHQbZVCJouxU9773WMxg2JVyc4QfZMSQqfdzeckkd6PDqe?=
 =?iso-8859-1?Q?KHM39ua9QJ7XON+Ob6yxujP6nQD7jx4llS48T5vdHlu28fwbQ3E4LGv0X9?=
 =?iso-8859-1?Q?DkeYTspAPXvD6bqhADma1Fdk5hOGwgPWR9eFIJ7EyEqWOPUg5N7DkoRqSr?=
 =?iso-8859-1?Q?S7mcII/Owk/268TnhZXBVktX5RVMoFNpvVkV+WHqq5X1waAH3q4tzQG/34?=
 =?iso-8859-1?Q?CJeNSf8owRseKQkX3GgrFDv1LS5ZfFC2v5sGA2GtEeTACIQxNXDbEsUsMi?=
 =?iso-8859-1?Q?Ev8mE4xiD/TI/31iHvAPNf6u3XhNzrvEG7XAGLFckWPLDuHeCsE50KJIdu?=
 =?iso-8859-1?Q?Zz1hnZ0+iZW2y6cYHuJ1pB4kqvKz7jPsGoxPPUl8yD+l19UxL6zFIjeiM7?=
 =?iso-8859-1?Q?8O5YQzayMYP4B3dd3uv0HVM2EFsp/PLJ6uaD3B7ANXq36vmjl5Nx3GvjYm?=
 =?iso-8859-1?Q?FQhcFTwB9J5iSL5T+TJKEpW198HdEmUBA8Xhyg3PtSoN1abXVP+PIUzxXY?=
 =?iso-8859-1?Q?xzROpzMAravpSvKuh+WsejUieh8g3e/rATTq4Wj+in//mWuzsfn2tmTZrK?=
 =?iso-8859-1?Q?FpTJ1u+aRjW1e+veAiut7A93TNzFBT+0CvjXBo0+E1zKJME=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sigmalabsinc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1301MB2152.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4648dcb-b401-4bed-b5cb-08d905b8049a
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2021 17:56:55.7605
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e9f66b05-a3b6-442b-87aa-e65ebd76d5c3
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JbcfYZ7zosz4FUUs6/HyNhmGVWByc002vL383g/bdYV5bETow2z/JPSErG2uVjeeMGeS3kGrWhVCG8jvmR/RFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR13MB1016
X-MDID: 1619114223-yFuO28ErBaXg
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello Artur,=0A=
=0A=
Your answer worked! I just wanted to follow up, so anyone else who has a si=
milar issue can arrive at the solution. Also, I am reporting what I did sin=
ce it is not exactly as you suggested.=0A=
=0A=
I tried to follow your extra step, but it returned as an invalid number.=0A=
=0A=
I ran with sudo since my user is not root in this case:=0A=
=0A=
printf "%llu\n" -1 > sudo /sys/block/md126/md/resync_start=0A=
-bash: printf: /sys/block/md126/md/resync_start: invalid number=0A=
=0A=
So, we assumed that you simply wanted us to edit the resync_start file valu=
e to the number=A018446744073709551615. I did it by hand using a text edito=
r. After doing so, the value of the file changed to none.=0A=
=0A=
sudo cat=A0/sys/block/md126/md/resync_start=0A=
none=0A=
=0A=
After that, I proceeded to reconstruct the array. But I changed the order o=
f the commands. Not sure if that mattered.=0A=
=0A=
sudo mdadm -S /dev/md125=0A=
mdadm: stopped /dev/md125=0A=
=0A=
sudo mdadm -a /dev/md127 /dev/sdb=0A=
mdadm: added /dev/sdb=0A=
=0A=
sudo mdadm -R --force /dev/md126=0A=
mdadm: Started /dev/md/Data with 3 devices (0 new)=0A=
=0A=
Even though it only reported 3 devices (0 new) during the last command's ou=
tput, it successfully added the new /dev/sdb drive as a spare, started the =
array resync, and is recovering now as reported by cat /proc/mdstat.=0A=
=0A=
Thank you=A0so=A0much for the assistance!=0A=
=0A=
Devon Beets=0A=
=0A=
=0A=
From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>=0A=
Sent: Wednesday, April 7, 2021 4:25 AM=0A=
To: Devon Beets <devon@sigmalabsinc.com>; Tkaczyk, Mariusz <mariusz.tkaczyk=
@linux.intel.com>; linux-raid@vger.kernel.org <linux-raid@vger.kernel.org>=
=0A=
Cc: Glenn Wikle <gwikle@sigmalabsinc.com>=0A=
Subject: Re: Cannot add replacement hard drive to mdadm RAID5 array =0A=
=A0=0A=
On 06.04.2021 22:05, Devon Beets wrote:=0A=
> Output of the recommended commands for adding the new disk to the RAID5 a=
rray:=0A=
> =0A=
> sudo mdadm -R --force /dev/md126=0A=
> mdadm: array /dev/md/Data now has 3 devices (0 new)=0A=
> =0A=
> sudo mdadm -S /dev/md125=0A=
> mdadm: stopped /dev/md125=0A=
> =0A=
> sudo mdadm -a /dev/md127 /dev/sdb=0A=
> mdadm: added /dev/sdb=0A=
> =0A=
> Output of mdstat after running the commands. Shows that both md126 and md=
127 are inactive, and there is no RAID resync happening.=0A=
> =0A=
> cat /proc/mdstat=0A=
> Personalities : [raid6] [raid5] [raid4] [linear] [multipath] [raid0] [rai=
d1] [raid10]=0A=
> md126 : inactive sda[2] sdc[1] sdd[0]=0A=
> =A0 =A0 =A0 5567507712 blocks super external:/md127/0=0A=
> =0A=
> md127 : inactive sdb[3](S) sdc[2](S) sdd[1](S) sda[0](S)=0A=
> =A0 =A0 =A0 10564 blocks super external:imsm=0A=
> =0A=
> unused devices: <none>=0A=
=0A=
It looks like mdadm still does not handle this case correctly. Please do th=
is=0A=
before the "mdadm -R --force /dev/md126":=0A=
=0A=
printf "%llu\n" -1 > /sys/block/md126/md/resync_start=0A=
=0A=
Regards,=0A=
Artur=
