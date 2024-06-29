Received: from mail.justnet.pl (mail.justnet.pl [78.9.185.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65CD2101F7
	for <linux-raid@vger.kernel.org>; Sat, 29 Jun 2024 15:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.9.185.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719674280; cv=none; b=gBWbKGzCU6zOCIMWnIkRxPtLak+TKVHUzMTpX+JNjPDSI2H+BHgngcGMTxU21o4JPvzSzPh9PkhP1AAHyjBiq7HiNSq1KMO4l4FdSmCq0ZDb3EjO/xxBwXoqVFy6eDzUBwXEiAmVfrQNt7DNTtyuuH3mEP9dR3hhgnpm3ZdXzdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719674280; c=relaxed/simple;
	bh=br6ayP4WYeMWJ+Fciv88ts72Wt/d6yyHlynVI71NSH8=;
	h=Content-Type:Message-ID:Date:MIME-Version:From:Subject:To; b=JyNiwXPjPccyfeK0PrMSFwYQiBycn0pfUUbSZyegyU8XLtUvunzYC8hzObc/VD7brAHeWx2uInyAz+A3HF6Zzfa0RZRfX96z1WePdrvIY5Wa2KeJXYokss200d7Kpil29m0/aSKvF+fQqFD+1KwrQK9Ppx0hCGVxff3OkpVgxMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=justnet.pl; spf=pass smtp.mailfrom=justnet.pl; dkim=pass (1024-bit key) header.d=justnet.pl header.i=@justnet.pl header.b=UKZjAzll; arc=none smtp.client-ip=78.9.185.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=justnet.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justnet.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=justnet.pl header.i=@justnet.pl header.b="UKZjAzll"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=justnet.pl;
	 s=dkim; h=To:Subject:From:Reply-To:MIME-Version:Date:Message-ID:Content-Type
	:Sender:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ono6NHR1XNZqrW1sL1+WKX2sl+6XCHO3Vnv8g4RaiFU=; b=UKZjAzllWqzUJCr9v8z843tSoq
	DAdsjQmujC8BP/G7zUtjgVd7iXlHwPtfcpwqQe2gZVTPqYcNDsHVzSvLoFgDWuxTTbr803/OvpPif
	4EFLH/myGrZKY95cLtoti99bZ8BWaK7xAczggus7pv3rQwqhsqFje05nDHaU81+e6qwE=;
Received: from [78.9.185.84] (helo=[192.168.255.66])
	by mail.justnet.pl with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
	(Exim 4.92)
	(envelope-from <adam.niescierowicz@justnet.pl>)
	id 1sNZpq-000p1K-Tf; Sat, 29 Jun 2024 17:17:54 +0200
Content-Type: multipart/mixed; boundary="------------0a6SZ85wXkhF4CZO5M7gkzQD"
Message-ID: <56a413f1-6c94-4daf-87bc-dc85b9b87c7a@justnet.pl>
Date: Sat, 29 Jun 2024 17:17:54 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: adam.niescierowicz@justnet.pl
Content-Language: pl-PL
From: Adam Niescierowicz <adam.niescierowicz@justnet.pl>
Subject: RAID6 12 device assemble force failure
Organization: =?UTF-8?Q?Adam_Nie=C5=9Bcierowicz_JustNet?=
To: linux-raid@vger.kernel.org
X-Spam-Score: -1.0
X-Spam-Level: -

This is a multi-part message in MIME format.
--------------0a6SZ85wXkhF4CZO5M7gkzQD
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

i have raid 6 array on 12 disk attached via external SAS backplane 
connected by 4 luns to the server. After some problems with backplane 
when 3 disk went offline (in one second) and array stop.

When disk come online we stop array by mdadm --stop /dev/md126 
unfurtunetlny we can't  assemble
---

mdadm --assemble /dev/sd{q,p,o,n,m,z,y,z,w,t,s,r}1

mdadm: /dev/md126 assembled from 9 drives and 3 spares - not enough to 
start the array.

---

at system boot mdadm recognise array

---

#cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4] [linear] [multipath] [raid0] 
[raid1] [raid10]
md126 : inactive sdt1[8](S) sdn1[5](S) sdw1[2] sdy1[6] sdm1[9] sdp1[0] 
sdq1[7] sds1[4] sdo1[11] sdx1[1] sdz1[10](S) sdr1[3]
       234380292096 blocks super 1.2

# mdadm --detail /dev/md126
/dev/md126:
            Version : 1.2
         Raid Level : raid6
      Total Devices : 12
        Persistence : Superblock is persistent

              State : inactive
    Working Devices : 12

               Name : backup:card1port1chassis2
               UUID : f8fb0d5d:5cacae2e:12bf1656:18264fb5
             Events : 48640

     Number   Major   Minor   RaidDevice

        -      65        1        -        /dev/sdq1
        -       8      241        -        /dev/sdp1
        -       8      225        -        /dev/sdo1
        -       8      209        -        /dev/sdn1
        -       8      193        -        /dev/sdm1
        -      65      145        -        /dev/sdz1
        -      65      129        -        /dev/sdy1
        -      65      113        -        /dev/sdx1
        -      65       97        -        /dev/sdw1
        -      65       49        -        /dev/sdt1
        -      65       33        -        /dev/sds1
        -      65       17        -        /dev/sdr1
---


But it can't start, after mdadm --run

---

# mdadm --detail /dev/md126
/dev/md126:
            Version : 1.2
      Creation Time : Tue Jun 18 20:07:19 2024
         Raid Level : raid6
      Used Dev Size : 18446744073709551615
       Raid Devices : 12
      Total Devices : 12
        Persistence : Superblock is persistent

        Update Time : Fri Jun 28 22:21:57 2024
              State : active, FAILED, Not Started
     Active Devices : 9
    Working Devices : 12
     Failed Devices : 0
      Spare Devices : 3

             Layout : left-symmetric
         Chunk Size : 512K

Consistency Policy : unknown

               Name : backup:card1port1chassis2
               UUID : f8fb0d5d:5cacae2e:12bf1656:18264fb5
             Events : 48640

     Number   Major   Minor   RaidDevice State
        -       0        0        0      removed
        -       0        0        1      removed
        -       0        0        2      removed
        -       0        0        3      removed
        -       0        0        4      removed
        -       0        0        5      removed
        -       0        0        6      removed
        -       0        0        7      removed
        -       0        0        8      removed
        -       0        0        9      removed
        -       0        0       10      removed
        -       0        0       11      removed

        -      65        1        7      sync   /dev/sdq1
        -       8      241        0      sync   /dev/sdp1
        -       8      225       11      sync   /dev/sdo1
        -       8      209        -      spare   /dev/sdn1
        -       8      193        9      sync   /dev/sdm1
        -      65      145        -      spare   /dev/sdz1
        -      65      129        6      sync   /dev/sdy1
        -      65      113        1      sync   /dev/sdx1
        -      65       97        2      sync   /dev/sdw1
        -      65       49        -      spare   /dev/sdt1
        -      65       33        4      sync   /dev/sds1
        -      65       17        3      sync   /dev/sdr1

---

I think the problem is that disk are recognised as spare, but why?

After examinantion of disk all have the same event: 48640 but three that 
have
---
Bad Block Log : 512 entries available at offset 88 sectors - bad blocks 
present.
Device role: spare

---

full mdadm -E
---
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x9
      Array UUID : f8fb0d5d:5cacae2e:12bf1656:18264fb5
            Name : backup:card1port1chassis2
   Creation Time : Tue Jun 18 20:07:19 2024
      Raid Level : raid6
    Raid Devices : 12

  Avail Dev Size : 39063382016 sectors (18.19 TiB 20.00 TB)
      Array Size : 195316910080 KiB (181.90 TiB 200.00 TB)
     Data Offset : 264192 sectors
    Super Offset : 8 sectors
    Unused Space : before=264088 sectors, after=0 sectors
           State : clean
     Device UUID : e726c6bc:11415fcc:49e8e0a5:041b69e4

Internal Bitmap : 8 sectors from superblock
     Update Time : Fri Jun 28 22:21:57 2024
   Bad Block Log : 512 entries available at offset 88 sectors - bad 
blocks present.
        Checksum : 9ad955ac - correct
          Events : 48640

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : spare
    Array State : AAAAA.AA.A.A ('A' == active, '.' == missing, 'R' == 
replacing)
---


I tried with `mdadm --assemble --force --update=force-no-bbl 
/dev/sd{q,p,o,n,m,z,y,z,w,t,s,r}1` and now mdam -E shows


---

           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : f8fb0d5d:5cacae2e:12bf1656:18264fb5
            Name : backup:card1port1chassis2
   Creation Time : Tue Jun 18 20:07:19 2024
      Raid Level : raid6
    Raid Devices : 12

  Avail Dev Size : 39063382016 sectors (18.19 TiB 20.00 TB)
      Array Size : 195316910080 KiB (181.90 TiB 200.00 TB)
     Data Offset : 264192 sectors
    Super Offset : 8 sectors
    Unused Space : before=264104 sectors, after=0 sectors
           State : clean
     Device UUID : e726c6bc:11415fcc:49e8e0a5:041b69e4

Internal Bitmap : 8 sectors from superblock
     Update Time : Fri Jun 28 22:21:57 2024
        Checksum : 9ad1554c - correct
          Events : 48640

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : spare
    Array State : AAAAA.AA.A.A ('A' == active, '.' == missing, 'R' == 
replacing)
---


What can I do to start this array?


Below full mdadm -E of all disk in the array

```
# mdadm -E /dev/sd{q,p,o,n,m,z,y,z,w,t,s,r}1
/dev/sdq1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : f8fb0d5d:5cacae2e:12bf1656:18264fb5
            Name : backup:card1port1chassis2
   Creation Time : Tue Jun 18 20:07:19 2024
      Raid Level : raid6
    Raid Devices : 12

  Avail Dev Size : 39063382016 sectors (18.19 TiB 20.00 TB)
      Array Size : 195316910080 KiB (181.90 TiB 200.00 TB)
     Data Offset : 264192 sectors
    Super Offset : 8 sectors
    Unused Space : before=264104 sectors, after=0 sectors
           State : clean
     Device UUID : eef85925:fbdeb293:703eade7:04725a02

Internal Bitmap : 8 sectors from superblock
     Update Time : Fri Jun 28 22:21:57 2024
        Checksum : 2a767262 - correct
          Events : 48640

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 7
    Array State : AAAAA.AA.A.A ('A' == active, '.' == missing, 'R' == 
replacing)
/dev/sdp1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : f8fb0d5d:5cacae2e:12bf1656:18264fb5
            Name : backup:card1port1chassis2
   Creation Time : Tue Jun 18 20:07:19 2024
      Raid Level : raid6
    Raid Devices : 12

  Avail Dev Size : 39063382016 sectors (18.19 TiB 20.00 TB)
      Array Size : 195316910080 KiB (181.90 TiB 200.00 TB)
     Data Offset : 264192 sectors
    Super Offset : 8 sectors
    Unused Space : before=264104 sectors, after=0 sectors
           State : clean
     Device UUID : 892b5f88:e0233f4a:0e509ffd:c72375f6

Internal Bitmap : 8 sectors from superblock
     Update Time : Fri Jun 28 22:21:57 2024
        Checksum : 4e14ad3d - correct
          Events : 48640

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 0
    Array State : AAAAA.AA.A.A ('A' == active, '.' == missing, 'R' == 
replacing)
/dev/sdo1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : f8fb0d5d:5cacae2e:12bf1656:18264fb5
            Name : backup:card1port1chassis2
   Creation Time : Tue Jun 18 20:07:19 2024
      Raid Level : raid6
    Raid Devices : 12

  Avail Dev Size : 39063382016 sectors (18.19 TiB 20.00 TB)
      Array Size : 195316910080 KiB (181.90 TiB 200.00 TB)
     Data Offset : 264192 sectors
    Super Offset : 8 sectors
    Unused Space : before=264104 sectors, after=0 sectors
           State : clean
     Device UUID : 7765576b:6e58ad14:c1ae0b5e:90d36937

Internal Bitmap : 8 sectors from superblock
     Update Time : Fri Jun 28 22:21:57 2024
        Checksum : 9cdc2a3e - correct
          Events : 48640

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 11
    Array State : AAAAA.AA.A.A ('A' == active, '.' == missing, 'R' == 
replacing)
/dev/sdn1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : f8fb0d5d:5cacae2e:12bf1656:18264fb5
            Name : backup:card1port1chassis2
   Creation Time : Tue Jun 18 20:07:19 2024
      Raid Level : raid6
    Raid Devices : 12

  Avail Dev Size : 39063382016 sectors (18.19 TiB 20.00 TB)
      Array Size : 195316910080 KiB (181.90 TiB 200.00 TB)
     Data Offset : 264192 sectors
    Super Offset : 8 sectors
    Unused Space : before=264104 sectors, after=0 sectors
           State : clean
     Device UUID : 0c7d6e27:e4356ca7:556ba2d1:5632cbf6

Internal Bitmap : 8 sectors from superblock
     Update Time : Fri Jun 28 22:21:57 2024
        Checksum : 1eaa3a9f - correct
          Events : 48640

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : spare
    Array State : AAAAA.AA.A.A ('A' == active, '.' == missing, 'R' == 
replacing)
/dev/sdm1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : f8fb0d5d:5cacae2e:12bf1656:18264fb5
            Name : backup:card1port1chassis2
   Creation Time : Tue Jun 18 20:07:19 2024
      Raid Level : raid6
    Raid Devices : 12

  Avail Dev Size : 39063382016 sectors (18.19 TiB 20.00 TB)
      Array Size : 195316910080 KiB (181.90 TiB 200.00 TB)
     Data Offset : 264192 sectors
    Super Offset : 8 sectors
    Unused Space : before=264104 sectors, after=0 sectors
           State : clean
     Device UUID : 49b1e45d:719a504f:9450e6b8:649c1cd5

Internal Bitmap : 8 sectors from superblock
     Update Time : Fri Jun 28 22:21:57 2024
        Checksum : c29a22b9 - correct
          Events : 48640

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 9
    Array State : AAAAA.AA.A.A ('A' == active, '.' == missing, 'R' == 
replacing)
/dev/sdz1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : f8fb0d5d:5cacae2e:12bf1656:18264fb5
            Name : backup:card1port1chassis2
   Creation Time : Tue Jun 18 20:07:19 2024
      Raid Level : raid6
    Raid Devices : 12

  Avail Dev Size : 39063382016 sectors (18.19 TiB 20.00 TB)
      Array Size : 195316910080 KiB (181.90 TiB 200.00 TB)
     Data Offset : 264192 sectors
    Super Offset : 8 sectors
    Unused Space : before=264104 sectors, after=0 sectors
           State : clean
     Device UUID : a4437981:be1db310:47aaf5ab:5e325a68

Internal Bitmap : 8 sectors from superblock
     Update Time : Fri Jun 28 22:21:57 2024
        Checksum : 2dde280f - correct
          Events : 48640

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : spare
    Array State : AAAAA.AA.A.A ('A' == active, '.' == missing, 'R' == 
replacing)
/dev/sdy1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : f8fb0d5d:5cacae2e:12bf1656:18264fb5
            Name : backup:card1port1chassis2
   Creation Time : Tue Jun 18 20:07:19 2024
      Raid Level : raid6
    Raid Devices : 12

  Avail Dev Size : 39063382016 sectors (18.19 TiB 20.00 TB)
      Array Size : 195316910080 KiB (181.90 TiB 200.00 TB)
     Data Offset : 264192 sectors
    Super Offset : 8 sectors
    Unused Space : before=264104 sectors, after=0 sectors
           State : clean
     Device UUID : 2c02425e:b4e2ceb2:a83c5656:bda51c7b

Internal Bitmap : 8 sectors from superblock
     Update Time : Fri Jun 28 22:21:57 2024
        Checksum : 69e5b149 - correct
          Events : 48640

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 6
    Array State : AAAAA.AA.A.A ('A' == active, '.' == missing, 'R' == 
replacing)
/dev/sdz1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : f8fb0d5d:5cacae2e:12bf1656:18264fb5
            Name : backup:card1port1chassis2
   Creation Time : Tue Jun 18 20:07:19 2024
      Raid Level : raid6
    Raid Devices : 12

  Avail Dev Size : 39063382016 sectors (18.19 TiB 20.00 TB)
      Array Size : 195316910080 KiB (181.90 TiB 200.00 TB)
     Data Offset : 264192 sectors
    Super Offset : 8 sectors
    Unused Space : before=264104 sectors, after=0 sectors
           State : clean
     Device UUID : a4437981:be1db310:47aaf5ab:5e325a68

Internal Bitmap : 8 sectors from superblock
     Update Time : Fri Jun 28 22:21:57 2024
        Checksum : 2dde280f - correct
          Events : 48640

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : spare
    Array State : AAAAA.AA.A.A ('A' == active, '.' == missing, 'R' == 
replacing)
/dev/sdw1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : f8fb0d5d:5cacae2e:12bf1656:18264fb5
            Name : backup:card1port1chassis2
   Creation Time : Tue Jun 18 20:07:19 2024
      Raid Level : raid6
    Raid Devices : 12

  Avail Dev Size : 39063382016 sectors (18.19 TiB 20.00 TB)
      Array Size : 195316910080 KiB (181.90 TiB 200.00 TB)
     Data Offset : 264192 sectors
    Super Offset : 8 sectors
    Unused Space : before=264104 sectors, after=0 sectors
           State : clean
     Device UUID : 0ab85136:9bb9481f:97cce69a:56966f09

Internal Bitmap : 8 sectors from superblock
     Update Time : Fri Jun 28 22:21:57 2024
        Checksum : 8152be91 - correct
          Events : 48640

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 2
    Array State : AAAAA.AA.A.A ('A' == active, '.' == missing, 'R' == 
replacing)
/dev/sdt1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : f8fb0d5d:5cacae2e:12bf1656:18264fb5
            Name : backup:card1port1chassis2
   Creation Time : Tue Jun 18 20:07:19 2024
      Raid Level : raid6
    Raid Devices : 12

  Avail Dev Size : 39063382016 sectors (18.19 TiB 20.00 TB)
      Array Size : 195316910080 KiB (181.90 TiB 200.00 TB)
     Data Offset : 264192 sectors
    Super Offset : 8 sectors
    Unused Space : before=264104 sectors, after=0 sectors
           State : clean
     Device UUID : e726c6bc:11415fcc:49e8e0a5:041b69e4

Internal Bitmap : 8 sectors from superblock
     Update Time : Fri Jun 28 22:21:57 2024
        Checksum : 9ad1554c - correct
          Events : 48640

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : spare
    Array State : AAAAA.AA.A.A ('A' == active, '.' == missing, 'R' == 
replacing)
/dev/sds1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : f8fb0d5d:5cacae2e:12bf1656:18264fb5
            Name : backup:card1port1chassis2
   Creation Time : Tue Jun 18 20:07:19 2024
      Raid Level : raid6
    Raid Devices : 12

  Avail Dev Size : 39063382016 sectors (18.19 TiB 20.00 TB)
      Array Size : 195316910080 KiB (181.90 TiB 200.00 TB)
     Data Offset : 264192 sectors
    Super Offset : 8 sectors
    Unused Space : before=264104 sectors, after=0 sectors
           State : clean
     Device UUID : 6fadf5ed:db4aeaf4:5713a2df:a5e70ff5

Internal Bitmap : 8 sectors from superblock
     Update Time : Fri Jun 28 22:21:57 2024
        Checksum : 3ef3dd4a - correct
          Events : 48640

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 4
    Array State : AAAAA.AA.A.A ('A' == active, '.' == missing, 'R' == 
replacing)
/dev/sdr1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : f8fb0d5d:5cacae2e:12bf1656:18264fb5
            Name : backup:card1port1chassis2
   Creation Time : Tue Jun 18 20:07:19 2024
      Raid Level : raid6
    Raid Devices : 12

  Avail Dev Size : 39063382016 sectors (18.19 TiB 20.00 TB)
      Array Size : 195316910080 KiB (181.90 TiB 200.00 TB)
     Data Offset : 264192 sectors
    Super Offset : 8 sectors
    Unused Space : before=264104 sectors, after=0 sectors
           State : clean
     Device UUID : b923a958:3fca3a18:03f93cd3:e4ff4203

Internal Bitmap : 8 sectors from superblock
     Update Time : Fri Jun 28 22:21:57 2024
        Checksum : cec5d0df - correct
          Events : 48640

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 3
    Array State : AAAAA.AA.A.A ('A' == active, '.' == missing, 'R' == 
replacing)
```



-- 
---
Thanks
Adam Nieścierowicz

--------------0a6SZ85wXkhF4CZO5M7gkzQD
Content-Type: text/vcard; charset=UTF-8; name="adam_niescierowicz.vcf"
Content-Disposition: attachment; filename="adam_niescierowicz.vcf"
Content-Transfer-Encoding: base64

YmVnaW46dmNhcmQNCmZuO3F1b3RlZC1wcmludGFibGU6QWRhbSBOaWU9QzU9OUJjaWVyb3dp
Y3oNCm47cXVvdGVkLXByaW50YWJsZTpOaWU9QzU9OUJjaWVyb3dpY3o7QWRhbQ0KZW1haWw7
aW50ZXJuZXQ6YWRhbS5uaWVzY2llcm93aWN6QGp1c3RuZXQucGwNCngtbW96aWxsYS1odG1s
OlRSVUUNCnZlcnNpb246Mi4xDQplbmQ6dmNhcmQNCg0K

--------------0a6SZ85wXkhF4CZO5M7gkzQD--
