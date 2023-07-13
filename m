Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DF05C001B0
	for <linux-raid@archiver.kernel.org>; Thu, 13 Jul 2023 20:58:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbjGMU6a (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 13 Jul 2023 16:58:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjGMU62 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 13 Jul 2023 16:58:28 -0400
Received: from sonic310-24.consmr.mail.gq1.yahoo.com (sonic310-24.consmr.mail.gq1.yahoo.com [98.137.69.150])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52612271F
        for <linux-raid@vger.kernel.org>; Thu, 13 Jul 2023 13:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=att.net; s=s1024; t=1689281907; bh=bP7ktHJ4ek6GPZlS2awlB1QTT+SGxlVE5DtctI8DAao=; h=Date:To:From:Subject:References:From:Subject:Reply-To; b=LWnm9pgU3SR8V1oDA6AhaKQnJ4LnmY1jmkHXgQ225CiK4ccCulGBAKfs1DT2494dz5XIwyQewgL/vm9/G3T6Tqv6As9zK7JRv68FcUgGaXaFr8O4+jwPryaiMRetQp1wpjPIuIoiSLsTrMLQID6lTiVls/CkSczSE2hYQlE1vNc=
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1689281907; bh=P52hIkgbktC4GXHnb9oksKwuNbXTB/+J9f7FqBjqaZn=; h=X-Sonic-MF:Date:To:From:Subject:From:Subject; b=c2Z+Q6lRqNjJG2hxCrB40b4IrHJpSdh9Wbds5fkMDIe4yEMdZUA+F9FjmDxPxlWba7oJPMeba5rTezW3GZY2KzBVAjuJLkGcgh0vim+UJR/ww2in6fHvO5Cw+m1eTRi/0nZy5OEAkDePOMAFeninfykqSFqugk6fixUqBbgvx91WZBANT4d1DE7iDWIKCl7QJR8ca7gQ1nHN7+F/UQoVRnDJGjUYfQKp/WPDMISiY6HxD0FKXOW6lUvrInc/NoEYtB9yL86HzgWM8nlT2QVkNx1xKXy6Z6Mx1wdKWz/2Be/pED4YD7fs251PX6LmNtERfCY9C0x0/wmSrVkn1OvfyQ==
X-YMail-OSG: 0_eCnhMVM1mnPVkM4e9YnEwGvF1fZj6x.Nt6Dzhojm_0Grp80iU_Pm76G33hINF
 4BzrWwAyjGGEYx8sMbraO3wpD2fTGCFJZwjqrJkb1ogZlsvqcsZK4UZQYprf5z7WsWA4o.VPlNh6
 xEp1p8UI8dSeCrmRZU4quaeoRylJ53JN7pl8FAcLxlsy0N9PasGLu0XJVEsPNq6yQ6ePct4KqllD
 vBE8KjywNJj7ItTFCXBP.O80jNnFVbo5E9tt0nfEMPkgME9KvEpGHeHpuHVzIxQy.CmNMtSMPR.G
 NJv_EbrKQLO7ESPBp3pCu9ubcJKmwifjVigpZYId.zrTRwVSxzpxNK_wwiNbqCYi5cdS6ArlIYh_
 YfVF_5UL3wyA7jnDMwNH.pCqt0iJEJvRNOt1QZcI1aUrCSoDxvkkKIfYjhXOU71vYj9v6vJ6ueNY
 facgt27H8OA9QJOHsde2zD4OZ7BYc.JtDIGyLVZMdNTK1WXlLyCBMalGQFvu5NVIYsYUHJe_gose
 O01AdIc10VppVBdsU3Pk.1dmfdsDlCRDzOletStAnMUXmO2S1eRVMIxpntkRedTAN0wRDgEw84CK
 7zzpfMzc897OC.g6EuALvnsK0lBMz.xVXzMtAjcKDLus66N38KWIBL1gfc.QVmQq84Fibk11H1zo
 IQxDlB7T_td_Nw6YihwtPwbtOJ4Zw2eJ2eInmHQowZVrnuJ528VhYu89SypFI3CRJjIE5eAeDZ0F
 bLMq1l9H97njxG2QzTMghlTgvdMshogRXPK5jbZ8mByCRUeWPlXTT9YxeGgN7WJfyjWABeuK_Kgr
 RUTpbOMXv74oCv1gkjSQd2nPg7xYCf4eEdBdIGvxMt6eXJubYXD75cyRcHopq8CanLH.s0ViZLYM
 sfG7UnWYdImgHdcQR8pTmeu6JL1R7n0oEhOHO1S.yVnpsktqiexLvwSLz5Gwq7NUU8ySfYVK.Nrs
 jd7UdZDbdQ_NNK8QmEMdBWSlPjBRUyKQhRisvdstgpvxJKbuZHyuBXG.XXn75THFW_URiiE7P7Ft
 AKFnX10ykLLTN.bn_LGYqjh9LJZT8rFAWtk6TnnExdXRKvWfX1UDbR3pAqxegV8wlVCEN8oIiAyF
 x8vkLOMk7bf1Dx1hsP8wr3jdYd86K0imD3VJ1dX96GTrHIwW1FU6w4NYEwBMChyxZ9yyzZnUPcyD
 SGlr4PmROBi8HQrAMkE046vf9nV.kYhl223Lmp0TvSAq64EiGnz2UAaHCgmld3t77Ofn.H05VPBY
 7GbfO4ucWqYBPgL9eqdhQNFdMzWs9p8l5ZNMyAQSSJHJwPkfGGeWX1fhk2P5xP9HIhy5IPTSOo7_
 0nFpRAXOzOlhCMh2l_BUkFD2aME4N1yhTf.kj8oF3MfVKXFcWO4zbkfgcfuNZdO_.GYGvUcgbQtE
 Lij5018CV_WDSLraSIUNERoTIf9rZCz0_XOs36EenHO6JUig0xDJ_MTxhr8EQaEM2hPKUHZbMzbE
 cXSdFarhUXERXpyRN9aOAnV_D1IoyQU3dByFEdUaofsVpoPl_NVk0vMyuTLq9Ew4WyHEuKwnmbWq
 k0XLuMZF1mUeBYa6RM.Unu.baYW_HZHaX5qC.aMbguQ5CRxUN5E754ujiPztUe.gdpAAxY3w_TmS
 x8wqOuvbSTe6dQsArjzeSAojmQ6YXvjfFldO37FLZ3feK.j_fuwclDy41mNQJssSFMSk2X4XTz9T
 QvZKFOGAOClIHOOP1oDztTrAC_IN6KAhRPtMdSynLoSC838tQ.hcdk6Z07SPsijbw3TjS1NPocAm
 3m53zrxnzrP.vYS6VMWhCo_pU5wGCsVbwPaDCMczha_cvyk9.fKc1O2CZIpGH6dR3GcH_t78kDe6
 wyPz_qggQGpk0G6v9gzt0Im0zgVut0POchf_5YbqHmtorHRumiBxR6F0dbo5h_fScG9AI9MbudXV
 ZV6QxrgyrHkxj_jFC2cqLeZIkYPMqqRVTEeodN.HHZ9gQRW9MktgAUkqwNYmSay4x7n3MJ_AX1At
 25ZHurTO6KBSvWFp75PA5D5eY2Vf1LnCIytnoyhqDsQ3WbesXD9TR8dc7xiQtlA6TGjr6GLVnExs
 qzMaUk9XFdbqZkBfT5EJO8EozL1SYyPIBkYsDGCC1IQ2_LQRsPj2900wZV0rogzl6nBF3pq.X6Fq
 ..lWM5BpuqmpdvRcoezCKxN_oEQPWKWDf1SgmJyCIFovpx8Hh4xrn63D82_RIsOYxk31ZduEp2mu
 UkgXJ2P5xAEmJ30yhDhFBpQ--
X-Sonic-MF: <lesrhorer@att.net>
X-Sonic-ID: e6bf6fd8-32f1-49e2-8c6e-fcb7120fb94f
Received: from sonic.gate.mail.ne1.yahoo.com by sonic310.consmr.mail.gq1.yahoo.com with HTTP; Thu, 13 Jul 2023 20:58:27 +0000
Received: by hermes--production-bf1-5d96b4b9f-wmng2 (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 763c20a6660cc825da2289433636de5b;
          Thu, 13 Jul 2023 20:58:22 +0000 (UTC)
Message-ID: <d44dd435-46e8-f40c-e8cf-24e6c6e93687@att.net>
Date:   Thu, 13 Jul 2023 15:58:13 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Content-Language: en-US
To:     Linux RAID <linux-raid@vger.kernel.org>
From:   Leslie Rhorer <lesrhorer@att.net>
Subject: Corrupted RAID 1
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
References: <d44dd435-46e8-f40c-e8cf-24e6c6e93687.ref@att.net>
X-Mailer: WebService/1.1.21638 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

	I have a corrupted bootable RAID 1 array on a pair of SDD drives, and I 
fear I need some assistance.  Actually, there are four partitions on 
each drive, and two RAID 1 arrays were assembled from each drive.  When 
working properly, the second pair of partitions were mounted as / and 
the first pair were mounted as /boot.  The OS is Debian Buster.  When I 
attempt to boot the system, it goes directly to the GRUB prompt.

	I pulled the drives and attached them to an active system.  Mdadm 
reports both partition tables to be intact with partition labels of fd, 
83, ef, and 82, respectively and MBR magic of aa55.  When I try to 
assemble any array says the partitions exist but are not md arrays.

	Fdisk reports the partition types as Linux raid autodetect, Linux, EFI, 
and Linux swap / Solaris.  The EFI partitions are marked bootable and 
contain the following:

total 3472
-rwxr-xr-x 1 root root     108 May 28  2022 BOOTX64.CSV
-rwxr-xr-x 1 root root   84648 May 28  2022 fbx64.efi
-rwxr-xr-x 1 root root     152 May 28  2022 grub.cfg
-rwxr-xr-x 1 root root 1672576 May 28  2022 grubx64.efi
-rwxr-xr-x 1 root root  845480 May 28  2022 mmx64.efi
-rwxr-xr-x 1 root root  934240 May 28  2022 shimx64.efi

	Any suggestions?  I should say that the running system
(Bullseye) is not the same version as the failed one (Buster).  Of 
course the failed system does need to be upgraded, but there are 
specific reasons why this is quite undesirable at this point.
