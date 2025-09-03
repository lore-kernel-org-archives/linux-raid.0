Received: from mx.febas.net (mx.febas.net [168.119.129.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D642FC86A
	for <linux-raid@vger.kernel.org>; Wed,  3 Sep 2025 11:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.129.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756900513; cv=none; b=JUBRhNTqDI83Y1DCzQobxuLNWSVg5OJXXG61U0HU4mc5Vw/OF77wvIYULF0ruW+K2oESB9+ncue35Hm7JTX9OELPVoYBg2LYWeqNYAuHV0Q2R0JZQAkrLo359gNPUv/0U1rHiKD4mEIdnoity1L3Pe3JYR5O6d1RmYJJQO8YXOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756900513; c=relaxed/simple;
	bh=uBY+V4JVlu2iHTPjwFkKiOfrmX6+aJUGRaBi2ZFERo0=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Content-Type; b=TtLwH2HokbefNa1IZkGHoETOiFoaPieQJ6k52fJCjmgeynUVRYZ4ROy5YyVmJD5jku3TreIZY6R8NgR7CphrB133Y9CY/zEP1u148kRqrQB5LjX4wSJSwXkEfvRvqVV8ylbHwEhZvHDDvxQCF0E3Tb6T3wbTo4uSQNqJthYP/iM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=peter-speer.de; spf=pass smtp.mailfrom=peter-speer.de; arc=none smtp.client-ip=168.119.129.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=peter-speer.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=peter-speer.de
Received: from mx.febas.net (localhost [127.0.0.1])
	by mx.febas.net (Proxmox) with ESMTP id 8B3F16132C
	for <linux-raid@vger.kernel.org>; Wed,  3 Sep 2025 13:55:06 +0200 (CEST)
Message-ID: <5c8e3075-e45a-410e-a23a-cbf0e86bdfa6@peter-speer.de>
Date: Wed, 3 Sep 2025 13:55:05 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Stefanie Leisestreichler (Febas)"
 <stefanie.leisestreichler@peter-speer.de>
Subject: RAID 1 | Changing HDs
To: linux-raid@vger.kernel.org
Content-Language: de-DE
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 1.0.7 at mail.febas.net
X-Virus-Status: Clean

Hi.
I have the system layout shown below.

To avoid data loss, I want to change HDs which have about 46508 hours of 
up time.

I thought, instead of degrading, formatting, rebuilding and so on, I could
- shutdown the computer
- take i.e. /dev/sda and do
- dd bs=98304 conv=sync,noerror if=/dev/sda of=/dev/sdX (X standig for 
device name of new disk)

Is it save to do it this way, presuming the array is in AA-State?

Thanks,
Steffi

/dev/sda1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 68c0c9ad:82ede879:2110f427:9f31c140
            Name : speernix15:0  (local to host speernix15)
   Creation Time : Sun Nov 30 19:15:35 2014
      Raid Level : raid1
    Raid Devices : 2

  Avail Dev Size : 1953260976 (931.39 GiB 1000.07 GB)
      Array Size : 976629568 (931.39 GiB 1000.07 GB)
   Used Dev Size : 1953259136 (931.39 GiB 1000.07 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=261864 sectors, after=1840 sectors
           State : active
     Device UUID : 5871292c:7fcfbd82:b0a28f1b:df7774f9

     Update Time : Thu Aug 28 01:00:03 2025
   Bad Block Log : 512 entries available at offset 264 sectors
        Checksum : b198f5d1 - correct
          Events : 38185

    Device Role : Active device 0
    Array State : AA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdb1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 68c0c9ad:82ede879:2110f427:9f31c140
            Name : speernix15:0  (local to host speernix15)
   Creation Time : Sun Nov 30 19:15:35 2014
      Raid Level : raid1
    Raid Devices : 2

  Avail Dev Size : 1953260976 (931.39 GiB 1000.07 GB)
      Array Size : 976629568 (931.39 GiB 1000.07 GB)
   Used Dev Size : 1953259136 (931.39 GiB 1000.07 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=261864 sectors, after=1840 sectors
           State : active
     Device UUID : 4bbfbe7a:457829a5:dd9d2e3c:15818bca

     Update Time : Thu Aug 28 01:00:03 2025
   Bad Block Log : 512 entries available at offset 264 sectors
        Checksum : 144ff0ef - correct
          Events : 38185


