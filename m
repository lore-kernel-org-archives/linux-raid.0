Received: from meesny.iki.fi (meesny.iki.fi [195.140.195.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9081A70AE5
	for <linux-raid@vger.kernel.org>; Fri,  1 Mar 2024 15:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=195.140.195.201
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709307936; cv=pass; b=L3rxulzZ5WPsQS3TW5sfows5TThr+NmxvrFK+/DDjOcK13SmfHFDfe3HUX9q6alOHV2MGh/w/SnQt6mIOjclaxXrm7xk71A9KINHqoqM5l55JsvEwa2dsiBs++VUeX15AIEn6b1EXFWTRaKCvn4wjAvFBrQnasWo8dyfZLVI4OE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709307936; c=relaxed/simple;
	bh=5q0U7CXL04U5A1tClltcvqZ8Bnp4meLvYac0WkJUyMw=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=MgtXVh7NepqE/+IFEWtrGl8krNLuCMWGEwXRd38zTXkfo53Jtopx6ryeH+8UizLAu9pqOHGSV8pYCCLIfqeAPAX18aoPtAJS5hyTv+5gXzY3Mbn5LzH1OkJNR0xpLtBvaoAsHCoYhRidEn/ftM2gOtXz9BTnQkJLJgv8nuH6Ys0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi; spf=pass smtp.mailfrom=iki.fi; dkim=pass (1024-bit key) header.d=iki.fi header.i=@iki.fi header.b=yrwrGQ/B; arc=pass smtp.client-ip=195.140.195.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iki.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=iki.fi header.i=@iki.fi header.b="yrwrGQ/B"
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: tovi)
	by meesny.iki.fi (Postfix) with ESMTPSA id 4TmXVM0bbYzyTK
	for <linux-raid@vger.kernel.org>; Fri,  1 Mar 2024 17:45:31 +0200 (EET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=meesny;
	t=1709307932;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=5q0U7CXL04U5A1tClltcvqZ8Bnp4meLvYac0WkJUyMw=;
	b=yrwrGQ/BP3PU9CZlxin+SL1Rvj05eVA+dBAz7+n8bALZCzrNZ9qBmcwaw1CVKnhbWy6jSF
	doVQroTdvm6whI9kPqhFWceOc+uUQZg8cCx1GO+vdeMzskpDXcHJ2YIRqhqSBx9yfP7lKL
	YkfnWGkLVCh74X8PWMGgTIttTExuauQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
	s=meesny; t=1709307932;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=5q0U7CXL04U5A1tClltcvqZ8Bnp4meLvYac0WkJUyMw=;
	b=EDVGLGAJbdLTanmBFo2irxlESVcQDLNzfI0qFMP7qwlGtXWOSbSB+zrMyBprSCDgoMDgR9
	FVY7uvnXzmqb2XKtxwRi+E2hv+oeedwTC4PVQAK1KcPIKtgwca6+H2xoubMaUGga3TQ/Yx
	LV9mtP0DnXQhoIdgzpK24TTayqmCEWg=
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=tovi smtp.mailfrom=tovi@iki.fi
ARC-Seal: i=1; s=meesny; d=iki.fi; t=1709307932; a=rsa-sha256; cv=none;
	b=xtebb8XaEykBBrOJz8kHwUkyh5mNZ6t2z1zTmfzfFcpqUIBNS7Rxq+ReTjcPrIKc4RfCoc
	1D9uNUx3wAGqSN2ZdPyuzFPBkARM+IJkmingf6qPn78KNk/T3Qxfwvn18+qKDGXdACuN2u
	UA+yKd2OhnoFBG9lJMjT5ycJP6UrGrU=
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-299566373d4so1668616a91.1
        for <linux-raid@vger.kernel.org>; Fri, 01 Mar 2024 07:45:30 -0800 (PST)
X-Gm-Message-State: AOJu0Yxb8Swm4kDovMnI6sLZE2ZR6mlaGkYm5S/+w+C51fF2SC4cETUH
	Pj5mV6onb52tBu3KP2FA4rhd1lGgwdye0QCil8JdlLyBkre2wszOljKm9NGvh0iC5O1h5vLE4vJ
	ZathDZpj3uzFPSvIdy80OKp9zV04=
X-Google-Smtp-Source: AGHT+IFoXJYiGitQauoZZydTnAYnbaaOHmiP0FNTpCe0VlyE7mJ54e8NkCbAm/h/IQxT44406Wqkq4blqqj4ICyuvqs=
X-Received: by 2002:a17:90a:c901:b0:29a:9b11:b24b with SMTP id
 v1-20020a17090ac90100b0029a9b11b24bmr1846209pjt.13.1709307928785; Fri, 01 Mar
 2024 07:45:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Topi Viljanen <tovi@iki.fi>
Date: Fri, 1 Mar 2024 17:45:17 +0200
X-Gmail-Original-Message-ID: <CADC_b1dj8AodZxYF0tLPnfv0S3xHGnCBVOmvWgyCZt4LqHze=w@mail.gmail.com>
Message-ID: <CADC_b1dj8AodZxYF0tLPnfv0S3xHGnCBVOmvWgyCZt4LqHze=w@mail.gmail.com>
Subject: Requesting help with raid6 that stays inactive
To: linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,

I have an RAID 6 array that is not having its 6 disks activated. Now
after reading more instructions it's clear that using webmin to create
RAID devices is a bad thing. You end up using the whole disk instead
of partitions of them.

All 6 disks should be ok and data should be clean. The array broke
after I moved the server to another location (sata cables might be in
different order etc). The original reason for the changes was an USB
drive that broke up... yep, there were the backups. That broken disk
was in fstab and therefore ubuntu went to recovery mode (since disk
was not available). So backups are now kind of broken too.


Autodiscovery does find the array:
RAID level - RAID6 (Dual Distributed Parity)
Filesystem status - Inactive and not mounted


Here's report from mdadm examine:

$ sudo mdadm --examine /dev/sd[c,b,d,e,f,g]
/dev/sdc:
Magic : a92b4efc
Version : 1.2
Feature Map : 0x1
Array UUID : 2bf6381b:fe19bdd4:9cc53ae7:5dce1630
Name : NAS-ubuntu:0
Creation Time : Thu May 18 22:56:47 2017
Raid Level : raid6
Raid Devices : 6

Avail Dev Size : 7813782192 sectors (3.64 TiB 4.00 TB)
Array Size : 15627548672 KiB (14.55 TiB 16.00 TB)
Used Dev Size : 7813774336 sectors (3.64 TiB 4.00 TB)
Data Offset : 254976 sectors
Super Offset : 8 sectors
Unused Space : before=254896 sectors, after=7856 sectors
State : clean
Device UUID : b944e546:6c1c3cf9:b3c6294a:effa679a

Internal Bitmap : 8 sectors from superblock
Update Time : Wed Feb 28 19:10:03 2024
Bad Block Log : 512 entries available at offset 24 sectors
Checksum : 4a9db132 - correct
Events : 477468

Layout : left-symmetric
Chunk Size : 512K

Device Role : Active device 5
Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdb:
MBR Magic : aa55
Partition[0] : 4294967295 sectors at 1 (type ee)
/dev/sdd:
MBR Magic : aa55
Partition[0] : 4294967295 sectors at 1 (type ee)
/dev/sde:
MBR Magic : aa55
Partition[0] : 4294967295 sectors at 1 (type ee)
/dev/sdf:
MBR Magic : aa55
Partition[0] : 4294967295 sectors at 1 (type ee)
/dev/sdg:
MBR Magic : aa55
Partition[0] : 4294967295 sectors at 1 (type ee)




Since the disks have been used instead of partitions I'm now getting
an error when trying to assemble:

$ sudo mdadm --assemble /dev/md0 /dev/sdc /dev/sdb /dev/sdd /dev/sde
/dev/sdf /dev/sdg
mdadm: No super block found on /dev/sdb (Expected magic a92b4efc, got 00000000)
mdadm: no RAID superblock on /dev/sdb
mdadm: /dev/sdb has no superblock - assembly aborted

$ sudo mdadm --assemble --force /dev/md0 /dev/sdb /dev/sdc /dev/sdd
/dev/sde /dev/sdf /dev/sdg
mdadm: Cannot assemble mbr metadata on /dev/sdb
mdadm: /dev/sdb has no superblock - assembly aborted


Should I try to re-create that array again or how can I activate it
properly? It seems that only 1 disk reports the array information
correctly.


ls /dev/sd*
/dev/sda /dev/sda1 /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf
/dev/sdg /dev/sdh /dev/sdh1

All disks should be fine. I have setup a warning if any device fails
in the array and there have been no warnings. Also SMART data shows ok
for all disks.


Basic info:

$uname -a
Linux NAS-server 5.15.0-97-generic #107-Ubuntu SMP Wed Feb 7 13:26:48
UTC 2024 x86_64 x86_64 x86_64 GNU/Linux

$mdadm --version
mdadm - v4.2 - 2021-12-30

$ sudo mdadm --detail /dev/md0
/dev/md0:
Version : 1.2
Raid Level : raid6
Total Devices : 1
Persistence : Superblock is persistent

State : inactive
Working Devices : 1

Name : NAS-ubuntu:0
UUID : 2bf6381b:fe19bdd4:9cc53ae7:5dce1630
Events : 477468

Number Major Minor RaidDevice
- 8 32 - /dev/sdc


So what should I do next?
I have not run the --create --assume-clean yet but could that help in this case?

Thanks for any help.

Best regards,
Topi Viljanen
