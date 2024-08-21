Received: from anvil.nuitari.net (mail.nuitari.net [192.99.15.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0E0A1CA81
	for <linux-raid@vger.kernel.org>; Wed, 21 Aug 2024 02:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.99.15.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724208873; cv=none; b=gPs8cfSiSLyAhLcAjA/wEF6kJp7BpH9T8K2dsH2vrqVIZvBsJNEsIFnni7cXZsV6CsduBoFBwPf42m8rPT0o8OhG5yUyLh9hlHUgpVf5L1dQtutBPInqBlqSE/espc+8VUxoM7RH50vJUddcEs0sz0XYjV7+fl32g0I1Gb5lDM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724208873; c=relaxed/simple;
	bh=gDwXcJgt8xA4BLI9OgfPC+DS77PT3ZfVEaTmtlCVYkQ=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=T9uStf2OSIlT1WID1Th89ridOQZSK4g3aVRKtH9d9GoL/EIqRmH2Ix8iRELRulw7eXpsYl4SyNCisKRnw6fXcs4vfTy/MYAW/A8//zdqVsjv997b+qWKOEnSw4fe+f6Cuzs3QgD1JJIuugV4+nlfU+0eBkFwsFjcj/WOV7T/gKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nuitari.net; spf=pass smtp.mailfrom=nuitari.net; dkim=pass (2048-bit key) header.d=nuitari.net header.i=@nuitari.net header.b=iUwV6qj0; arc=none smtp.client-ip=192.99.15.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nuitari.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nuitari.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nuitari.net header.i=@nuitari.net header.b="iUwV6qj0"
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=nuitari.net; h=date:from
	:to:subject:message-id:mime-version:content-type; s=anvil; bh=gD
	wXcJgt8xA4BLI9OgfPC+DS77PT3ZfVEaTmtlCVYkQ=; b=iUwV6qj0KbjgsyrClI
	SK5IlCsPfhMioStw3HdbPD8EhPC/wmVjhmfYdOLT12TY7g71jCJ5HiXzWfvTgcJT
	yCqIO0AORkUQp3KoByE4NbYGiYImx2D2Bg0ZM4w1cNrv8H12+6aU39JvnltducpP
	dC0CNCaxgtKKkGrrxAnkVGYHWK++18FbhocYeKfu5KtGss/AURHrrmK/9bjhAgFR
	IfGWW56VXqjawQAKXf7uuTz530sGy7v9et8EiS2RyxQqD4m6Rj96JDozw1xosaX8
	zpPRDfMkYimISBu0YNhXdxh4gvldHatw9nNviqVL30YsAY2yjOlv2H6BV30/8lLA
	ungA==
Received: (qmail 13950 invoked by uid 210); 21 Aug 2024 02:54:27 -0000
Received: from 127.0.0.1 by mail (envelope-from <nuitari-vger@nuitari.net>, uid 201) with qmail-scanner-2.08st 
 (clamdscan: 1.3.1/27372. spamassassin: 4.0.1. perlscan: 2.08st.  
 Clear:RC:1(127.0.0.1):. 
 Processed in 0.055601 secs); 21 Aug 2024 02:54:27 -0000
Received: from unknown (HELO localhost) (127.0.0.1)
  by localhost with ESMTPS (TLS_AES_256_GCM_SHA384 encrypted); 21 Aug 2024 02:54:27 -0000
Date: Wed, 21 Aug 2024 02:54:27 +0000 ()
From: nuitari-vger@nuitari.net
To: linux-raid@vger.kernel.org
Subject: Issue with MDADM Raid10
Message-ID: <8ad53e0d-724a-fc01-ee60-b31228160aa3@nuitari.net>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII

This scenario is happenning while I was testing a potential migration in a 
VM, thankfully no data is actually at risk. However the testing points 
towards a potential bug when multiple device are failed in a raid10.

This is on Ubuntu 24.04 with a handcompiled vanilla kernel version 6.10.6.

It was also tried on Ubuntu 22.04 (some version of 5.15) and stock Ubuntu 
24.04 (Some version of 6.8).

The dmesg output: https://nuitari.net/dmesg
The config: https://nuitari.net/config-kernel

The setup is 10 drives, 2 of which are 4.1x bigger than the rest. The 
partition used in the raid is #3.

mdadm --create /dev/md0 -l 10 -n 10 /dev/vd?3

# cat /proc/mdstat
Personalities : [raid10]
md0 : active raid10 vdj3[9] vdi3[8] vdh3[7] vdg3[6] vdf3[5] vde3[4] 
vdd3[3] vdc3[2] vdb3[1] vda3[0]
       78597120 blocks super 1.2 512K chunks 2 near-copies [10/10] 
[UUUUUUUUUU]


# mdadm --detail /dev/md0
/dev/md0:
            Version : 1.2
      Creation Time : Tue Aug 20 16:56:34 2024
         Raid Level : raid10
         Array Size : 78597120 (74.96 GiB 80.48 GB)
      Used Dev Size : 15719424 (14.99 GiB 16.10 GB)
       Raid Devices : 10
      Total Devices : 10
        Persistence : Superblock is persistent

        Update Time : Tue Aug 20 16:57:39 2024
              State : clean
     Active Devices : 10
    Working Devices : 10
     Failed Devices : 0
      Spare Devices : 0

             Layout : near=2
         Chunk Size : 512K

Consistency Policy : resync

               Name : 0
               UUID : 8f69074e:137439a1:c307426c:4cd10069
             Events : 17

     Number   Major   Minor   RaidDevice State
        0     253        3        0      active sync set-A   /dev/vda3
        1     253       19        1      active sync set-B   /dev/vdb3
        2     253       35        2      active sync set-A   /dev/vdc3
        3     253       51        3      active sync set-B   /dev/vdd3
        4     253       67        4      active sync set-A   /dev/vde3
        5     253       83        5      active sync set-B   /dev/vdf3
        6     253       99        6      active sync set-A   /dev/vdg3
        7     253      115        7      active sync set-B   /dev/vdh3
        8     253      131        8      active sync set-A   /dev/vdi3
        9     253      147        9      active sync set-B   /dev/vdj3


for i in 1 2 3; do dd if=/dev/urandom of=garbage$1 bs=1G count=20; done ; 
sha1sum gar* > sums

# cat sums
034e10a97244ef762c0ce0389057829df1086d1e  garbage1
28359e08488bbd94ce434f37fdeb71a6ddceabcb  garbage2
afca3bc256deb149cb46adb85c22fb4716fe7656  garbage3

At this point I have a clean ext4 formatted array at /dev/md0 with some 
randomly generated test data.

For the test, I fail all of set-A drives, which in theory should still 
allow for a near=2 layout to continue operating:
# sync

# mdadm --fail /dev/md0 /dev/vd[acegi]3
mdadm: set /dev/vda3 faulty in /dev/md0
mdadm: set /dev/vdc3 faulty in /dev/md0
mdadm: set /dev/vde3 faulty in /dev/md0
mdadm: set /dev/vdg3 faulty in /dev/md0
mdadm: set /dev/vdi3 faulty in /dev/md0

# cat /proc/mdstat
Personalities : [raid10]
md0 : active raid10 vdj3[9] vdi3[8](F) vdh3[7] vdg3[6](F) vdf3[5] 
vde3[4](F) vdd3[3] vdc3[2](F) vdb3[1] vda3[0](F)
       78597120 blocks super 1.2 512K chunks 2 near-copies [10/5] 
[_U_U_U_U_U]

sysctl -w vm.drop_caches=3

# sha1sum garbage*
5ed07afa38dae9686ff7e4301a9c48da5215cc5c  garbage1
28359e08488bbd94ce434f37fdeb71a6ddceabcb  garbage2
afca3bc256deb149cb46adb85c22fb4716fe7656  garbage3

For some reason garbage1 is read back differently, this one time only.
Rerunning the sha1sum produces the expected checksum.


I can re-add the failed drives no problem. But sometimes, if I fail things 
more brutally:
#for i in /dev/vd?3; do mdadm --fail /dev/md0 $i; done

I might get EXT4 complaining, even though the raid is still
However in that case, a random selection of drives end up in the failed 
state:

     Number   Major   Minor   RaidDevice State
       14     253      131        0      active sync set-A   /dev/vdi3
        1     253       19        1      faulty   /dev/vdb3
       13     253       99        2      active sync set-A   /dev/vdg3
        3     253       51        3      faulty   /dev/vdd3
       12     253       67        4      faulty   /dev/vde3
        5     253       83        5      active sync set-B   /dev/vdf3
       11     253       35        6      faulty   /dev/vdc3
        7     253      115        7      active sync set-B   /dev/vdh3
       10     253        3        8      faulty   /dev/vda3
        9     253      147        9      active sync set-B   /dev/vdj3

# cat /proc/mdstat
Personalities : [raid10]
md0 : active raid10 vdi3[14] vdg3[13] vde3[12](F) vdc3[11](F) vda3[10](F) 
vdj3[9] vdh3[7] vdf3[5] vdd3[3](F) vdb3[1](F)
       78597120 blocks super 1.2 512K chunks 2 near-copies [10/5] 
[U_U__U_U_U]

Then I tried to unmount /dev/md0 and got the following dmesg entries
[19056.984999] Buffer I/O error on dev md0, logical block 9469952, lost 
sync page write
[19056.985009] JBD2: I/O error when updating journal superblock for md0-8.
[19056.985014] Aborting journal on device md0-8.
[19056.985019] Buffer I/O error on dev md0, logical block 9469952, lost 
sync page write
[19056.985025] JBD2: I/O error when updating journal superblock for md0-8.
[19056.985037] EXT4-fs error (device md0): ext4_put_super:1310: comm 
umount: Couldn't clean up the journal
[19056.985048] Buffer I/O error on dev md0, logical block 0, lost sync 
page write
[19056.985054] EXT4-fs (md0): I/O error while writing superblock
[19056.985059] EXT4-fs (md0): Remounting filesystem read-only



Even after readding the failed devices, mounting the filesystem fails:

[21146.796366] md: recovery of RAID array md0
[21215.559109] md: md0: recovery done.
[21225.310156] Buffer I/O error on dev md0, logical block 0, lost sync 
page write
[21225.310168] EXT4-fs (md0): I/O error while writing superblock
[21225.310176] EXT4-fs (md0): mount failed
[21225.310230] Aborting journal on device md0-8.
[21225.310238] Buffer I/O error on dev md0, logical block 9469952, lost 
sync page write
[21225.310244] JBD2: I/O error when updating journal superblock for md0-8.


But stopping /dev/md0 and re-assembling it works

# mdadm --stop /dev/md0
# mdadm --assemble /dev/md0 /dev/vd?3
mdadm: /dev/md0 has been started with 10 drives.
# cat /proc/mdstat
Personalities : [raid10]
md0 : active raid10 vdi3[14] vdj3[9] vda3[10] vdh3[7] vdb3[11] vdf3[5] 
vdc3[12] vdd3[15] vdg3[13] vde3[16]
       78597120 blocks super 1.2 512K chunks 2 near-copies [10/10] 
[UUUUUUUUUU]

Rechecksum the test data yields the correct results.

mdadm version 4.3 is used here.

If this isn't the right venue for this, please point me towards the 
correct place.

As this is in a test environment, I can perform dangerous tests.
