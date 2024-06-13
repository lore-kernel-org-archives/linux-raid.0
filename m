Received: from mail.aixigo.de (mail.aixigo.de [5.145.142.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66FBC13C3D6
	for <linux-raid@vger.kernel.org>; Thu, 13 Jun 2024 07:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.145.142.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718264151; cv=none; b=K+mqG/Aet51c/NPhkQmQ7TqcUzhDgNKxvkwuDKSfsKauVaX8iBkWMD7fDwVDkwI71dCHLMmEBBuLuMTQ/WnnUmhh4rO9nedmOEzbxvwikOo9tf/x4+MRRYo9wqhZhIpyMGRolgsNz8rFbBmpwM9xgIsWhIRDZWhaB+zzQxdyHig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718264151; c=relaxed/simple;
	bh=CQTtDlW/OQo3N1vyhUzqY7KEjEG+XnrP5EIoUvFeJIk=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Content-Type; b=tVsF2vGktAr8gG/sJq+qS+ldn8+ZJGgIHZf8BBXA27ja+jyhh0SvVF57s2PBoD+vcHPPmNAKbJSxt36dX8sBsBXLEc2DUTPwZhLJO4Pp7HVwJjjEfsZbVs4hVIMD2gms1BzC7eweNfJCrTnu3eevQhZ2B3LakEmEjdTlJssw/cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=aixigo.com; spf=pass smtp.mailfrom=aixigo.com; dkim=pass (1024-bit key) header.d=aixigo.com header.i=@aixigo.com header.b=mK4uMUE0; arc=none smtp.client-ip=5.145.142.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=aixigo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aixigo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=aixigo.com header.i=@aixigo.com header.b="mK4uMUE0"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; s=default; bh=CQTtDlW/OQo3
	N1vyhUzqY7KEjEG+XnrP5EIoUvFeJIk=; h=to:subject:from:date;
	d=aixigo.com; b=mK4uMUE08DErkR3+0+/JUyoPFKJ+cesqgckDSCl0+ZcBpudPr2FihS
	9mqrRn/rlVuz+2QNYYC3KIUU61wd2BcaN4rTgxzUslaHRN8K1AIBZV9+yT8wEx12kQcxra
	h9OHlnXJVcPDQkAdYpYKZa33FET4KR2f+dLNoLnPqABVl+U=
Received: from mailhost.ac.aixigo.de (mailhost.ac.aixigo.de [172.19.96.11])
	by mail.aixigo.de (OpenSMTPD) with ESMTPS id 5b9a11ce (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
	for <linux-raid@vger.kernel.org>;
	Thu, 13 Jun 2024 09:35:45 +0200 (CEST)
Received: from [172.19.97.128] (dpcl082.ac.aixigo.de [172.19.97.128])
	by mailhost.ac.aixigo.de (8.17.1.9/8.17.1.9/Debian-2) with ESMTPS id 45D7ZivI3467881
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Thu, 13 Jun 2024 09:35:44 +0200
Message-ID: <4afec18d-a3ea-4fc2-8aaa-36319c6369a1@aixigo.com>
Date: Thu, 13 Jun 2024 09:35:44 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Betterbird (Linux)
From: Harald Dunkel <harald.dunkel@aixigo.com>
Content-Language: en-US
Subject: DMAR: DRHD: handling fault status reg 3
To: linux-raid@vger.kernel.org
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 1.0.3 at srvvm01.ac.aixigo.de
X-Virus-Status: Clean

Hi folks,

I got quite a number of weird messages in kernel log on the host
(Dell Poweredge R750) with a JBOSS and a MegaRAID controller card

:
[Mon Jun 10 00:14:04 2024] dmar_fault: 2930 callbacks suppressed
[Mon Jun 10 00:14:04 2024] DMAR: DRHD: handling fault status reg 3
[Mon Jun 10 00:14:04 2024] DMAR: [DMA Write NO_PASID] Request device [05:00.0] fault addr 0xeb61a000 [fault reason 0x05] PTE Write access is not set
[Mon Jun 10 00:14:04 2024] DMAR: DRHD: handling fault status reg 3
[Mon Jun 10 00:14:04 2024] DMAR: [DMA Write NO_PASID] Request device [05:00.0] fault addr 0xe5bd9000 [fault reason 0x05] PTE Write access is not set
[Mon Jun 10 00:14:04 2024] DMAR: DRHD: handling fault status reg 3
[Mon Jun 10 00:14:04 2024] DMAR: [DMA Write NO_PASID] Request device [05:00.0] fault addr 0xee7c3000 [fault reason 0x05] PTE Write access is not set
[Mon Jun 10 00:14:04 2024] DMAR: DRHD: handling fault status reg 3
:

Device 05:00:0 is the JBOSS RAID controller hosting 2 SSDs in RAID1:

root@node16:~# lspci | grep -i raid
05:00.0 SATA controller: Marvell Technology Group Ltd. 88SE9230 PCIe 2.0 x2 4-port SATA 6 Gb/s RAID Controller (rev 11)
17:00.0 RAID bus controller: Broadcom / LSI MegaRAID 12GSAS/PCIe Secure SAS39xx

Is this something to worry about?

Kernel is 6.1.90 (included in Debian 12), firmware is provided by
Debian as well. This is a production system, so I hesitate to
install a more recent kernel and firmware without further infor-
mation.


Every helpful comment is highly appreciated

Regards
Harri
