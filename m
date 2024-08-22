Received: from beast.visionsuite.biz (beast.visionsuite.biz [85.163.23.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB4B18EAB
	for <linux-raid@vger.kernel.org>; Thu, 22 Aug 2024 15:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.163.23.103
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724338977; cv=none; b=LxqXWn9pmu/sdjZveaC/W9+5EWBal8TU56WZ5OLOGazCdenIKrEX7F+/r1qplw28XFb//aX59GJVd3LbmOJc4mOi5YzvACKWq7VCkXdN9zgIkrE6/y2Mr+f6XoOQUGnsaY9Ekp+9W68KyCtwSlpMspwwbNcyjXAx9x//YW3MXcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724338977; c=relaxed/simple;
	bh=9lXFa6MDvXhze8uIaCQIGyjclphfFF4t4rDdshTsASo=;
	h=MIME-Version:Date:From:To:Subject:Message-ID:Content-Type; b=SQqHTDII5d67azYdCxBLl28lTJOHzmyBh9mERSF9xL+yTRsw70KIDvoueXXlWoscnxzC4YuqreuezfNlu4zcY1WyZRXtjLn+uxZhkRalInTHkTZByquoHIcTMbOqfiSaY8FfKKR/C8NjtWe2lkgPpZ5WQK4fjwcC7a8YAiM+gwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fordfrog.com; spf=pass smtp.mailfrom=fordfrog.com; dkim=pass (1024-bit key) header.d=fordfrog.com header.i=@fordfrog.com header.b=qRbbNKu2; arc=none smtp.client-ip=85.163.23.103
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fordfrog.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fordfrog.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=fordfrog.com header.i=@fordfrog.com header.b="qRbbNKu2"
Received: from localhost (beast.visionsuite.biz [127.0.0.1])
	by beast.visionsuite.biz (Postfix) with ESMTP id E059A4DF7BEB
	for <linux-raid@vger.kernel.org>; Thu, 22 Aug 2024 17:02:52 +0200 (CEST)
X-Virus-Scanned: amavisd-new at visionsuite.biz
Received: from beast.visionsuite.biz ([127.0.0.1])
	by localhost (beast.visionsuite.biz [127.0.0.1]) (amavisd-new, port 10026)
	with LMTP id HdMWV7avfba4 for <linux-raid@vger.kernel.org>;
	Thu, 22 Aug 2024 17:02:52 +0200 (CEST)
Received: from roundcube.visionsuite.biz (beast.visionsuite.biz [127.0.0.1])
	by beast.visionsuite.biz (Postfix) with ESMTPA id 1500E4DF7BDB
	for <linux-raid@vger.kernel.org>; Thu, 22 Aug 2024 17:02:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fordfrog.com;
	s=beast; t=1724338972;
	bh=X77hjnwqoTh/DmyM8zxiM29e7D6HuEULlX3cDO/WIuI=;
	h=Date:From:To:Subject;
	b=qRbbNKu2S6olNWfrFF9bXbGX+rFkKU8Y4mazCASrRUkqhR4aTc/evJenBgLHjycKF
	 VmCJ/V6AWD/YH+U0AZVH2PQQN2VNFVlcKROI6BJ0LJNAPyqSI3do4Fp8Tk1ijaah/b
	 33g4i/vjEpHKBLkg35QJcnSTi8xwd7tlK2ESr/pE=
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 22 Aug 2024 17:02:52 +0200
From: =?UTF-8?Q?Miroslav_=C5=A0ulc?= <miroslav.sulc@fordfrog.com>
To: linux-raid@vger.kernel.org
Subject: problem with synology external raid
Message-ID: <d963fc43f8a7afee7f77d8ece450105f@fordfrog.com>
X-Sender: miroslav.sulc@fordfrog.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit

hello,

a broken synology raid5 ended up on my desk. the raid was broken for 
quite some time, but i got it from the client just a few days back.

the raid consisted of 5 disks (no spares, all used):
disk 1 (sdca): according to my understanding, it was removed from the 
raid, then re-added, but the synchronization was interrupted, so it 
cannot be used to restore the raid
disk 2 (sdcb): is ok and up to date
disk 3 (sdcc): seems to be up to date, still spinning, but there are 
many issues with bad sectors
disk 4 (sdcd): is ok and up to date
disk 5 (sdce): is ok and up to date

the raid ran in degraded mode for over two months, client trying to make 
a copy of the data from it.

i made copies of the disk images from disks 1, 2, 4, and 5, at the state 
shown below. i didn't attempt to make a copy of disk 3 so far. since 
then i re-assembled the raid from disk 2-5 so the number of events on 
the disk 3 is now a bit higher then on the copies of the disk images.

according to my understanding, as the disk 1 never finished the sync, i 
cannot use it to recover the data, so the only way to recover the data 
is to assemble the raid in degraded mode using disk 2-5, if i ever 
succeed to make a copy of the disk 3. i'd just like to verify that my 
understanding is correct and there is no other way to attempt to recover 
the data. of course any hints are welcome.

here is the info from the partitions of the raid:

/dev/sdca5:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x2
      Array UUID : f697911c:bc85b162:13eaba4e:d1152a4f
            Name : DS_KLIENT:4
   Creation Time : Tue Mar 31 11:40:19 2020
      Raid Level : raid5
    Raid Devices : 5

  Avail Dev Size : 15618390912 (7447.43 GiB 7996.62 GB)
      Array Size : 31236781824 (29789.72 GiB 31986.46 GB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
Recovery Offset : 4910216 sectors
    Unused Space : before=1968 sectors, after=0 sectors
           State : clean
     Device UUID : 681c6c33:49df0163:bb4271d4:26c0c76d

     Update Time : Tue Jun  4 18:35:54 2024
        Checksum : cf45a6c1 - correct
          Events : 60223

          Layout : left-symmetric
      Chunk Size : 64K

    Device Role : Active device 0
    Array State : AAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdcb5:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : f697911c:bc85b162:13eaba4e:d1152a4f
            Name : DS_KLIENT:4
   Creation Time : Tue Mar 31 11:40:19 2020
      Raid Level : raid5
    Raid Devices : 5

  Avail Dev Size : 15618390912 (7447.43 GiB 7996.62 GB)
      Array Size : 31236781824 (29789.72 GiB 31986.46 GB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
    Unused Space : before=1968 sectors, after=0 sectors
           State : clean
     Device UUID : 0f23d7cd:b93301a9:5289553e:286ab6f0

     Update Time : Wed Aug 14 15:09:24 2024
        Checksum : 9c93703e - correct
          Events : 60286

          Layout : left-symmetric
      Chunk Size : 64K

    Device Role : Active device 1
    Array State : .AAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdcc5:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : f697911c:bc85b162:13eaba4e:d1152a4f
            Name : DS_KLIENT:4
   Creation Time : Tue Mar 31 11:40:19 2020
      Raid Level : raid5
    Raid Devices : 5

  Avail Dev Size : 15618390912 (7447.43 GiB 7996.62 GB)
      Array Size : 31236781824 (29789.72 GiB 31986.46 GB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
    Unused Space : before=1968 sectors, after=0 sectors
           State : clean
     Device UUID : 1d1c04b4:24dabd8d:235afb7d:1494b8eb

     Update Time : Wed Aug 14 12:42:26 2024
        Checksum : a224ec08 - correct
          Events : 60283

          Layout : left-symmetric
      Chunk Size : 64K

    Device Role : Active device 2
    Array State : .AAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdcd5:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : f697911c:bc85b162:13eaba4e:d1152a4f
            Name : DS_KLIENT:4
   Creation Time : Tue Mar 31 11:40:19 2020
      Raid Level : raid5
    Raid Devices : 5

  Avail Dev Size : 15618390912 (7447.43 GiB 7996.62 GB)
      Array Size : 31236781824 (29789.72 GiB 31986.46 GB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
    Unused Space : before=1968 sectors, after=0 sectors
           State : clean
     Device UUID : 76698d3f:e9c5a397:05ef7553:9fd0af16

     Update Time : Wed Aug 14 15:09:24 2024
        Checksum : 38061500 - correct
          Events : 60286

          Layout : left-symmetric
      Chunk Size : 64K

    Device Role : Active device 4
    Array State : .AAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdce5:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : f697911c:bc85b162:13eaba4e:d1152a4f
            Name : DS_KLIENT:4
   Creation Time : Tue Mar 31 11:40:19 2020
      Raid Level : raid5
    Raid Devices : 5

  Avail Dev Size : 15618390912 (7447.43 GiB 7996.62 GB)
      Array Size : 31236781824 (29789.72 GiB 31986.46 GB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
    Unused Space : before=1968 sectors, after=0 sectors
           State : clean
     Device UUID : 9c7077f8:3120195a:1af11955:6bcebd99

     Update Time : Wed Aug 14 15:09:24 2024
        Checksum : 38177651 - correct
          Events : 60286

          Layout : left-symmetric
      Chunk Size : 64K

    Device Role : Active device 3
    Array State : .AAAA ('A' == active, '.' == missing, 'R' == replacing)


thank you for your help.

miroslav
