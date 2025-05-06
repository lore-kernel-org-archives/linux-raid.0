Received: from devloop.de (devloop.de [178.63.88.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D38661E3775
	for <linux-raid@vger.kernel.org>; Tue,  6 May 2025 10:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.63.88.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746527118; cv=none; b=HSIcruVssl84onTaAksHQA6nNZx+47mJwGViN2gZvmLT2QQU32DOocJbjjoMnL1/cSSWKqyYlmqIR/peGuV1JvDPV/IlXohIH5mgUCZyLKB9dOXJbXW8UPjZVJq9FdlXURSvsQTNc+vk7Ugu7pcpsWARMd9r0rvMe4B78AEih8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746527118; c=relaxed/simple;
	bh=bwS3Z/VFoEAowrPTEFmSJag7/0z8AHlMCgyhNVmSzn0=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=b+V40xDc42zBkqaevHMP1q43SrQzQDc+tVAW2GsdR+jvTpauGf311ym4S7lo25wxmQQl5aA1QKYXh1uyezw0YqDiYvQaZ8YpVYBP9YbbrRi+yF4P3bjB2bFu0hK18KZRgL+tU55MES3+GRFeiJcfqbxk1gZB6zIQ/S/4mhyFlLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=devloop.de; spf=pass smtp.mailfrom=devloop.de; arc=none smtp.client-ip=178.63.88.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=devloop.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=devloop.de
Received: from [IPV6:2003:ed:ff2b:a310::11cd] ([2003:ed:ff2b:a310::11cd])
  (AUTH: PLAIN damage@devloop.de, TLS: TLSv1.3,128bits,TLS_AES_128_GCM_SHA256)
  by devloop.de with ESMTPSA
  id 0000000002300A2D.000000006819E389.0000140C; Tue, 06 May 2025 10:25:13 +0000
Message-ID: <5e5df22d-ecd4-40fc-84dc-9508e28a6aae@devloop.de>
Date: Tue, 6 May 2025 12:25:13 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: linux-raid@vger.kernel.org
Content-Language: en-US, de-DE
From: Daniel Buschke <damage@devloop.de>
Subject: add fails: nvme1n1p2 does not have a valid v1.2 superblock, not
 importing
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,
before I start: I am a bit unsure if this is the correct place for this 
issue. If not, please be kind and tell me :)

I created an RAID1 array which was running fine. This array is currently 
in "degraded" state because one device failed. The device which failed 
just vanished and couldn't be removed from the array before being 
replaced with a new device. After rebooting I tried to add the new 
device by:

# mdadm --manage /dev/md1 --add /dev/nvme1n1p2

which fails with "mdadm: add new device failed for /dev/nvme1n1p2 as 2: 
Invalid argument". Output of dmesg is:

md: nvme1n1p2 does not have a valid v1.2 superblock, not importing!
md: md_import_device returned -22

I am a bit confused by this message as I assumed that the raid subsystem 
should create the suberblock on the new device. After searching WWW I 
found that a lot of people have the same problem and come up with ... 
interesting ... solutions which I am currently not willed to test 
because I didn't understood the problem yet. So, maybe someone can 
direct me to understand what is going on:

1. What exactly does this error message mean? I think replacing a failed 
drive with a new one is what RAID is for? So this shouldn't be an issue 
at all?

2. During my search I got the feeling that the problem is that the 
failed drive is somehow still "present" in the raid. Thus the add is 
handled as a "re add" which fails because there is no md superblock on 
the new device. Is my conclusion correct?

3. If 2. is correct how do I remove the failed but not really present 
device? Commands like "mdadm ... --remove failed" did not help.

4. I already replaced old devices in this RAID successfully before. What 
may have changed that this issue happens?


regards
Daniel


Some technical details which might be useful:


-------------------- 8< --------------------
# mdadm --detail /dev/md1
/dev/md1:
            Version : 1.2
      Creation Time : Tue Apr 29 16:38:51 2025
         Raid Level : raid1
         Array Size : 997973312 (951.74 GiB 1021.92 GB)
      Used Dev Size : 997973312 (951.74 GiB 1021.92 GB)
       Raid Devices : 2
      Total Devices : 1
        Persistence : Superblock is persistent

      Intent Bitmap : Internal

        Update Time : Tue May  6 11:47:38 2025
              State : clean, degraded
     Active Devices : 1
    Working Devices : 1
     Failed Devices : 0
      Spare Devices : 0

Consistency Policy : bitmap

               Name : rescue:1
               UUID : 7b7a8b41:e9cfa3ad:f1224061:1d0e7936
             Events : 28548

     Number   Major   Minor   RaidDevice State
        -       0        0        0      removed
        3     259        3        1      active sync   /dev/nvme0n1p2

-------------------- 8< --------------------
# cat /proc/mdstat
Personalities : [raid1]
md1 : active raid1 nvme0n1p2[3]
       997973312 blocks super 1.2 [2/1] [_U]
       bitmap: 7/8 pages [28KB], 65536KB chunk

unused devices: <none>

-------------------- 8< --------------------
# uname -a
Linux example.org 6.14.4-1-default #1 SMP PREEMPT_DYNAMIC Fri Apr 25 
09:13:41 UTC 2025 (584fafa) x86_64 x86_64 x86_64 GNU/Linux
