Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F851537CE
	for <linux-raid@vger.kernel.org>; Sun,  6 Oct 2024 06:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728194424; cv=none; b=MtsLOIFCOm7/2QsHgI4+q4pAKNEAKlpWSrgA5JQ0mVLCpavZEq0+cFQk8dbfiz7YKepaKSr9iFSCUwH3fhpICIGNxT+ja7d+ARORCjzVcUXmu0lfFcfsNK1znTWfNHkvnh0NfA+POnZU1eaAhTGUW1JG2lT8gjbSYS7Wfc4aesg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728194424; c=relaxed/simple;
	bh=3K8/i9+MgeGdAsQrHigR5dYnv82L9Q0PHz861UepuAM=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=nXIcCYH1nK/ItbR+wnaT59/0YoBcMx0j6soqr5EpM63K+C8ApP3d6IdmSD43z3P5kM3YK0LLhQu8Mge8t3pVoDB4Q/ODgMYH3zWa9I3p0eSaLFXYnfUSABu0x9LcGceHvUes47l6HQWYtlj7T7LPmuYH7zPffYmfTx4TXeep6ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ecqll5i+; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ecqll5i+"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-42cbe624c59so28123025e9.3
        for <linux-raid@vger.kernel.org>; Sat, 05 Oct 2024 23:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728194421; x=1728799221; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:user-agent
         :subject:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wjxFD/AEmaSHhoWFPoOtwzzd3EjtRnKnsIeJPJZf4L8=;
        b=Ecqll5i+9ZVKFqGIWaG/rxWc5ho/nesH8S4Jdz25/gTEeLEGantsGh2c+WkG43d3lA
         gsx42/VPiQD1DJy/RFzXl/3W1YeXwzzURmN6U+v1OqCoQZfnxpttbKGzBP4GG9JMyE0T
         DC8dOEtvTHH2RE3/G/9CiRcQXRmqMseubgzZ8VmW0mcJ/ZcxwQKx1H3QRQ66KCWpLnzW
         rcvNJsN1WLol4Exn/8FsjJEmjyhG+sMQQF7xInuo9nh6BnlVBN4WjKTa3tN7ABWaJkLK
         6K0bnSPbDOtZyJKSVnJgI5NvoIorp86PGzr8sQ38fFfYEydyfp+RSteLzw3Ue1X8aZ9P
         W0hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728194421; x=1728799221;
        h=content-transfer-encoding:mime-version:message-id:user-agent
         :subject:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wjxFD/AEmaSHhoWFPoOtwzzd3EjtRnKnsIeJPJZf4L8=;
        b=FL5NU3OHXutHEXHjrfCI75ibcE77BqDCE1u9lapqTFWA+YXXR4Kzntzm4/XAl9XBHT
         m2kWKU59ofB/BiJW8wEZWV1hG1xqD0pR2PgA1gJ/eSbHivgeChNsLetkS/ERfnDSONHh
         UE8SUKoi4GMUxMx6DMRX1K0dWoeLZkr3eY5Y2n7wh14CCBhhlD9/WhWFreSgqkJ+2Wfj
         6VAk2a/l6BQ5sEfJdKe+OFvu9zC+AETbRpbWcvbAZ8NrTrRpx0CRzznJQHK3Bt8xYA8L
         2ek866E7529NH/3E7F+XC0RP7T47IpPoBfXp1oRqJZ4u2So4jUNTmn/VAqCrzwPmp1Kg
         Qd0w==
X-Gm-Message-State: AOJu0Yx3q3S+Mgpp1Af+eAs8rdQKumZBgMEIvwq6zENmw4g0HadQx8HP
	CDwde01AnHUaBau10nOFuFa027nqU63UYLMasf3Vj+F3SfTzkskqQFcTbg==
X-Google-Smtp-Source: AGHT+IEwYEDyaZk5ACPltjCwV4S4RY17rCWhm26CtUbyLKCNNU4xBOeOyFRAi6GgC2KXEAhpfOAu5Q==
X-Received: by 2002:a05:600c:1ca5:b0:42c:cd88:d0f7 with SMTP id 5b1f17b1804b1-42f85ab4830mr53536605e9.10.1728194420415;
        Sat, 05 Oct 2024 23:00:20 -0700 (PDT)
Received: from [127.0.0.1] (cpc92300-haye23-2-0-cust581.17-4.cable.virginm.net. [86.22.42.70])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37d1691a411sm3024529f8f.33.2024.10.05.23.00.19
        for <linux-raid@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Oct 2024 23:00:19 -0700 (PDT)
Date: Sun, 06 Oct 2024 07:00:18 +0100
From: 19 Devices <19devices@gmail.com>
To: linux-raid@vger.kernel.org
Subject: Can't replace drive in imsm RAID 5 array, spare not shown
User-Agent: K-9 Mail for Android
Message-ID: <E656D988-48EF-4428-AEB6-2F6D8677612B@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi, I have a 4 drive imsm RAID 5 array which is working fine=2E  I want to =
remove one of the drives, sda, and replace it with a spare, sdc=2E  From ma=
n mdadm I understand that add - fail - remove is the way to go but this doe=
s not work=2E

Before:
$ cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md124 : active raid5 sdd[3] sdb[2] sda[1] sde[0]
      2831155200 blocks super external:/md126/0 level 5,
 128k chunk, algorithm 0 [4/4] [UUUU]

md125 : active raid5 sdd[3] sdb[2] sda[1] sde[0]
      99116032 blocks super external:/md126/1 level 5, 1
28k chunk, algorithm 0 [4/4] [UUUU]

md126 : inactive sda[3](S) sdb[2](S) sdd[1](S) sde[0](S)
      14681 blocks super external:imsm

unused devices: <none>


I can add (or add-spare) which increases the size of the container and tho=
ugh I can't see any spare drives listed by mdadm, it appears as SPARE DISK =
in the Intel option ROM after a reboot=2E

$ sudo mdadm --zero-superblock /dev/sdc

$ sudo mdadm /dev/md/imsm1 --add-spare /de
v/sdc
mdadm: added /dev/sdc

$ cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md124 : active raid5 sdd[3] sdb[2] sda[1] sde[0]
      2831155200 blocks super external:/md126/0 level 5,
 128k chunk, algorithm 0 [4/4] [UUUU]

md125 : active raid5 sdd[3] sdb[2] sda[1] sde[0]
      99116032 blocks super external:/md126/1 level 5, 1
28k chunk, algorithm 0 [4/4] [UUUU]

md126 : inactive sdc[4](S) sda[3](S) sdb[2](S) sdd[1](S) sde[0](S)
      15786 blocks super external:imsm

unused devices: <none>
$


No spare devices listed here:

$ sudo mdadm -D /dev/md/imsm1
/dev/md/imsm1:
           Version : imsm
        Raid Level : container
     Total Devices : 5

   Working Devices : 5


              UUID : bdb7f495:21b8c189:e496c216:6f2d6c4c
     Member Arrays : /dev/md/md1_0 /dev/md/md0_0

    Number   Major   Minor   RaidDevice

       -       8       64        -        /dev/sde
       -       8       32        -        /dev/sdc
       -       8        0        -        /dev/sda
       -       8       48        -        /dev/sdd
       -       8       16        -        /dev/sdb
$


Trying to remove sda fails=2E

$ sudo mdadm --fail /dev/md126 /dev/sda
mdadm: Cannot remove /dev/sda from /dev/md126, array will be failed=2E

sda is 2TB, the others are 1TB - is that a problem?

smartctl shows 2 drives don't support  SCT and it's disabled on the other =
3=2E

There's a very similar question here from Edwin in 2017:
https://unix=2Estackexchange=2Ecom/questions/372908/add-hot-spare-drive-to=
-intel-rst-onboard-raid#372920

The only reply points to an Intel doc which uses the standard command to a=
dd a drive but doesn't show the result=2E

$ uname -a
Linux Intel 6=2E9=2E2-arch1-1 #1 SMP PREEMPT_DYNAMIC Sun, 26
 May 2024 01:30:29 +0000 x86_64 GNU/Linux

$ mdadm --version
mdadm - v4=2E3 - 2024-02-15
