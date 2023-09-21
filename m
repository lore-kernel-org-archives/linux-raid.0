Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A230FCD4942
	for <linux-raid@archiver.kernel.org>; Thu, 21 Sep 2023 03:20:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbjIUDU0 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 20 Sep 2023 23:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjIUDUX (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 20 Sep 2023 23:20:23 -0400
Received: from twmgb.supermicro.com.tw (211-75-19-8.hinet-ip.hinet.net [211.75.19.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B996F5
        for <linux-raid@vger.kernel.org>; Wed, 20 Sep 2023 20:20:15 -0700 (PDT)
Received: from pps.filterd (twmgb.supermicro.com.tw [127.0.0.1])
        by twmgb.supermicro.com.tw (8.17.1.19/8.17.1.19) with ESMTP id 38L0VKmD019938
        for <linux-raid@vger.kernel.org>; Thu, 21 Sep 2023 11:20:11 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=supermicro.com; h=from : to :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=dkim; bh=yOVwStWwh3GAOZERefv7gGPH5o4dT9CbPmPIoexpYM4=;
 b=nvrPUZ8n38yWGKzpPhrqd3E8hSc4Ldq01MpNHLiuFTUQodzSPnpfU3agav/49cZ56MS4
 Z8xoZoklonszSeemtR4mx0lJIoOAYQrYpMx2Hd3+2qVuKjQ6tIMaOFT0vyoqTRFLB563
 iiRVo0H19pmmFspBjbtChC43Yj8Hw37ssnIR1N+IadnJ9csl7USv3uVwMhxUmaWhJf13
 tqk4YUlOPCmMh7yAn0O8J0VrbYuW8nRzE/B8ovX2yTlLWOHqFw16lFzbUVg7JTEMDeb3
 dqTu7XKnqMHCdvd33EWipksD22o8GGvG9He5INu/J+QRNmEP23dmb92Pnx0TBmF0WOQF SA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=supermicro.com.tw; h=from : to :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=dkim; bh=yOVwStWwh3GAOZERefv7gGPH5o4dT9CbPmPIoexpYM4=;
 b=o5GN8zYMZWUuw/Kzg6sTTNbP0yT2CHW0NgJa8aStwWBEN2CF77MHlN6TuT0mFk+HO4TM
 XwE31rCLlX8mzGKI60wXSglVWiVeJlsaWZychZV7W6gllYIe4vWMqg4phli9llh3W5Nz
 gS833sWzxAf1xWGby1+rQhLUSMZGKpt+8FDwaBE+aOBhIfnFdd7ZU70w91S7Nn9ZJ5IX
 o8l9DbP06KdNuQHzUjwfAEHp6G45+MYqy+FASUr/3UlKGGR2Hu7ArTcODZGs0lUtwfvv
 Q0Rpq40++4Hq3UofHq/o2jevKn7v2c1Z37fU+FhcZuVpEXuz4LiTd9i44XAeRht/NLL3 +w== 
Received: from tw-ex2013-mbx1.supermicro.com (TW-EX2013-MBX1.supermicro.com [10.128.8.63])
        by twmgb.supermicro.com.tw (PPS) with ESMTPS id 3t4vhasbw5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-raid@vger.kernel.org>; Thu, 21 Sep 2023 11:20:11 +0800
Received: from TW-EX2013-MBX1.supermicro.com (10.128.8.63) by
 TW-EX2013-MBX1.supermicro.com (10.128.8.63) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Thu, 21 Sep 2023 11:20:11 +0800
Received: from TW-EX2013-MBX1.supermicro.com ([fe80::8c8f:732c:cad9:8f60]) by
 TW-EX2013-MBX1.supermicro.com ([fe80::8c8f:732c:cad9:8f60%12]) with mapi id
 15.00.1497.044; Thu, 21 Sep 2023 11:20:11 +0800
From:   Stan Liao <StanL@supermicro.com>
To:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: bblog overlap internal bitmap?
Thread-Topic: bblog overlap internal bitmap?
Thread-Index: AdnsOgH6BuJ0WC2oRcuxKQcs7w0lnQ==
Date:   Thu, 21 Sep 2023 03:20:10 +0000
Message-ID: <9b21efef0bc1457c89250761b2b6cf2c@TW-EX2013-MBX1.supermicro.com>
Accept-Language: en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.181.92.67]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-20_14,2023-09-20_01,2023-05-22_02
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,
A md-raid (level 1) is created with 5 nvme drives and the metadata version =
is specified as 1.2. The following command is used.
sudo mdadm --create /dev/md0 --level=3D1 --raid-devices=3D5 /dev/nvme{1,2,3=
,4}n1 /dev/nvme4n2 --metadata=3D1.2
The capacities of nvme{1,2,3,4}n1 and nvme4n2 are 3.2TB, 1.92TB, 3.2TB, 512=
GB, and 512GB.
OS: 20.04.1-Ubuntu
mdadm version: v4.1 - 2018-10-01
After creation, we found that the size of the bitmap_super_t and internal b=
itmap is 16KB (this is concluded by observing FF value is filled from aroun=
d byte offset 0x100 of LBA 0x10 to byte offset 0x1FF of LBA 0x1F), but the =
mdp_superblock_1.bblog_offset value is 0x10. As a result, the mdp_superbloc=
k_1 occupies LBA 0x08 ~ 0x0F; bitmap_super_t and internal bitmap occupy LBA=
 0x10 ~ 0x20; bblog occupies LBA 0x18 ~ 0x20.
If bblog and bitmap do overlap, I would like to know the size value used to=
 calculate bitmap size and bblog_offset. The size value used to calculate b=
itmap size and bblog_offset is mdp_superblock_1.size or mdp_superblock_1.da=
ta_size? Thanks a lot.
