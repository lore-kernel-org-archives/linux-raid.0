Received: from ocaml.xvm.mit.edu (sipb-vm-99.mit.edu [18.25.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4796D4A2D
	for <linux-raid@vger.kernel.org>; Sun, 22 Jun 2025 02:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.25.128.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750558968; cv=none; b=ppDu9BrmKfJIgAw6pPjVyRmu5nYrPvjTMOktZxi+Do0EIC80ECOff2p2q6I1ye6KCRx0qbHzNxNwoGU18oZjmz8Ak7lsJ5ieiU0l0PoPmS05j70Ze9Uc0cO+Fhoj/C/bITtfK21nisQaGVJZFyAzHuv7olVo2ilsWm4RAgSszhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750558968; c=relaxed/simple;
	bh=XmNV2Vu9sIy8YDlDGmQ4P+gB5kFX1RIdWzWwtRKGsFg=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=Fa7Ch6UvDUUZ2QkkcxXGuf8aJe+R3t0Yfgg77kozJ4q2ufw9RcFV8MOaI6w9WWKYXYpOCwwWBgDCuymgfEhbDThDQ5PV86U3DNIDRu9a4U/WGLinavnJNvzOTqJvD8knj7ENGafiVK18+A/yYl8LvEtfeCdNqAz90yTX6bICW/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=xsdg.org; spf=pass smtp.mailfrom=xsdg.org; arc=none smtp.client-ip=18.25.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=xsdg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xsdg.org
Received: from 23-120-35-113.lightspeed.sntcca.sbcglobal.net ([23.120.35.113] helo=[192.168.1.51])
	by ocaml.xvm.mit.edu with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.97)
	(envelope-from <xsdg@xsdg.org>)
	id 1uT9gc-00000004pyH-2ACS
	for linux-raid@vger.kernel.org;
	Sat, 21 Jun 2025 21:39:58 -0400
Message-ID: <b696bee2-3c10-45be-8f5a-be3c607d0676@xsdg.org>
Date: Sun, 22 Jun 2025 01:39:56 +0000
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: linux-raid@vger.kernel.org
From: Omari Stephens <xsdg@xsdg.org>
Subject: Kernel mistakenly "starts" resync on fully-degraded, newly-created
 raid10 array
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

I tried asking on Reddit, and ended up resolving the issue myself:
https://www.reddit.com/r/linuxquestions/comments/1lh9to0/kernel_is_stuck_resyncing_a_4drive_raid10_array/

I run Debian SID, and am using kernel 6.12.32-amd64

#apt-cache policy linux-image-amd64
linux-image-amd64:
   Installed: 6.12.32-1
   Candidate: 6.12.32-1
   Version table:
  *** 6.12.32-1 500
         500 http://mirrors.kernel.org/debian unstable/main amd64 Packages
         500 http://http.us.debian.org/debian unstable/main amd64 Packages
         100 /var/lib/dpkg/status

#uname -r
6.12.32-amd64

To summarize the issue and my diagnostic steps, I ran this command to create a new raid10 array:

|#mdadm --create md13 --name=media --level=10 --layout=f2 -n 4 /dev/sdb1 missing /dev/sdf1 missing|

|At that point, /proc/mdstat showed the following, which makes no sense:|

md127 : active raid10 sdb1[2] sdc1[0]
       23382980608 blocks super 1.2 512K chunks 2 far-copies [4/2] [U_U_]
       [>....................]  resync =  0.0% (8594688/23382980608) finish=25176161501.3min speed=0K/sec
       bitmap: 175/175 pages [700KB], 65536KB chunk

With 2 drives present and 2 drives absent, the array can only start if the present drives are considered in sync.  The kernel spent most of a day in this state.  The
"8594688" count increased very slowly over time, but after 24 hours, it was only up to 0.1%.  During that time, I had mounted the array and transfered 11TB of data onto it.

Then when power-cycled, swapped SATA cables, and added the remaining drives, they were marked as spares and weren't added to the array (likely because the array was considered to be already resyncing):

#mdadm --detail /dev/md127
/dev/md127:
[...]
     Number   Major   Minor   RaidDevice State
        0       8       33        0      active sync   /dev/sdc1
        -       0        0        1      removed
        2       8       17        2      active sync   /dev/sdb1
        -       0        0        3      removed

        4       8        1        -      spare   /dev/sda1
        5       8       65        -      spare   /dev/sde1


I ended up resolving the issue by recreating the array with --assume-clean:

#mdadm --create md19 --name=media3 --assume-clean --readonly --level=10 --layout=f2 -n 4 /dev/sdc1 missing /dev/sdb1 missing
To optimalize recovery speed, it is recommended to enable write-indent bitmap, do you want to enable it now? [y/N]? y
mdadm: /dev/sdc1 appears to be part of a raid array:
        level=raid10 devices=4 ctime=Sun Jun 22 00:51:33 2025
mdadm: /dev/sdb1 appears to be part of a raid array:
        level=raid10 devices=4 ctime=Sun Jun 22 00:51:33 2025
Continue creating array [y/N]? y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md/md19 started.

#cat /proc/mdstat
Personalities : [raid1] [raid10] [raid0] [raid6] [raid5] [raid4]
md127 : active (read-only) raid10 sdb1[2] sdc1[0]
       23382980608 blocks super 1.2 512K chunks 2 far-copies [4/2] [U_U_]
       bitmap: 175/175 pages [700KB], 65536KB chunk

At which point, I was able to add the new devices and have the array (start to) resync as expected:

#mdadm --manage /dev/md127 --add /dev/sda1 --add /dev/sde1
mdadm: added /dev/sda1
mdadm: added /dev/sde1

#cat /proc/mdstat
Personalities : [raid1] [raid10] [raid0] [raid6] [raid5] [raid4]
md127 : active raid10 sde1[5] sda1[4] sdc1[0] sdb1[2]
       23382980608 blocks super 1.2 512K chunks 2 far-copies [4/2] [U_U_]
       [>....................]  recovery =  0.0% (714112/11691490304) finish=1091.3min speed=178528K/sec
       bitmap: 0/175 pages [0KB], 65536KB chunk

#mdadm --detail /dev/md127
/dev/md127:
[...]
     Number   Major   Minor   RaidDevice State
        0       8       33        0      active sync   /dev/sdc1
        5       8       65        1      spare rebuilding   /dev/sde1
        2       8       17        2      active sync   /dev/sdb1
        4       8        1        3      spare rebuilding   /dev/sda1

--xsdg

