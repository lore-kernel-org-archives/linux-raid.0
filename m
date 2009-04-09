From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID halting
Date: Wed, 8 Apr 2009 23:52:48 -0500
Message-ID: <20090409045252.HFZR19179.cdptpa-omta01.mail.rr.com@Leslie>
References: <F2C688D6A021E34CB81C0E631EF4C093018652A1@34093-C4-EVS1.exchange.rackspace.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F2C688D6A021E34CB81C0E631EF4C093018652A1@34093-C4-EVS1.exchange.rackspace.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> EXACTLY -- what are the errors .(Also a halt will not create an error in
> the internal log of the disk.   Now, if you had cut power in middle of a
> huge I/O, or read block n+1 on a disk that only had n blocks, then you
> would create an error.

No, but you are implying a cause / effect the other way around: errors on
the disk are causing the halts.  None of the evidence so far supports the
notion well at all.

I had several more halts today, and these results are from right now.

Drives /dev/sda, /dev/sde, /dev/sdf/ and /dev/sdg all remain without errors.

These drive models are:

sda  WD10EACS-00D6B0
sde  WD10EACS-00D6B0
sdf  WD10EACS-00D6B1
sdg  WD10EACS-00D6B1

Not surprisingly, these are the most recently purchased of the set (early
November). 

The one odd Hitachi (sdh  HUA721010KLA330) was powered up in mid-January
2008, and the other five were all powered up in mid-December 2007.  This
places the last errors on any of the drives previous to mid-December 2008,
which is when the system was removed from the old chassis.  It's also not at
all surprising there were errors before the drives were removed from the old
chassis.  By these logs, there hasn't been an error reported by SMART on any
of these drives in over 3 months.


sdi  HDS721010KLA330

ATA Error Count: 1

Error 1 occurred at disk power-on lifetime: 8442 hours (351 days + 18 hours)
  When the command that caused the error occurred, the device was active or
idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  84 51 00 00 2b 8e 40

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  60 08 90 00 2c 8e 40 08  12d+03:47:37.400  READ FPDMA QUEUED
  60 00 78 00 2b 8e 40 08  12d+03:47:37.400  READ FPDMA QUEUED
  60 00 30 00 2a 8e 40 08  12d+03:47:37.400  READ FPDMA QUEUED
  60 d0 18 30 29 8e 40 08  12d+03:47:37.400  READ FPDMA QUEUED
  60 08 10 28 29 8e 40 08  12d+03:47:37.400  READ FPDMA QUEUED


sdh  HUA721010KLA330

ATA Error Count: 2

Error 2 occurred at disk power-on lifetime: 7051 hours (293 days + 19 hours)
  When the command that caused the error occurred, the device was active or
idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  84 51 c0 40 41 3d 4a

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  60 f8 00 08 42 3d 40 08   6d+00:00:26.900  READ FPDMA QUEUED
  60 08 08 00 42 3d 40 08   6d+00:00:26.900  READ FPDMA QUEUED
  60 00 b8 00 41 3d 40 08   6d+00:00:26.900  READ FPDMA QUEUED
  60 00 38 00 40 3d 40 08   6d+00:00:26.900  READ FPDMA QUEUED
  60 f0 d8 10 3f 3d 40 08   6d+00:00:26.900  READ FPDMA QUEUED

Error 1 occurred at disk power-on lifetime: 6874 hours (286 days + 10 hours)
  When the command that caused the error occurred, the device was active or
idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  84 51 f0 0f 44 54 45

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  61 10 88 f0 43 54 40 08   1d+13:20:47.600  WRITE FPDMA QUEUED
  61 c8 78 28 43 54 40 08   1d+13:20:47.600  WRITE FPDMA QUEUED
  61 88 68 a0 41 54 40 08   1d+13:20:47.500  WRITE FPDMA QUEUED
  61 58 60 40 41 54 40 08   1d+13:20:47.500  WRITE FPDMA QUEUED
  61 10 08 30 41 54 40 08   1d+13:20:47.500  WRITE FPDMA QUEUED


sdj  HDS721010KLA330

ATA Error Count: 3

Error 3 occurred at disk power-on lifetime: 8133 hours (338 days + 21 hours)
  When the command that caused the error occurred, the device was active or
idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  84 51 80 80 2a 8e 40

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  60 08 a0 00 2c 8e 40 08  12d+03:47:39.300  READ FPDMA QUEUED
  60 00 88 00 2b 8e 40 08  12d+03:47:39.300  READ FPDMA QUEUED
  60 00 40 00 2a 8e 40 08  12d+03:47:39.300  READ FPDMA QUEUED
  60 d0 28 30 29 8e 40 08  12d+03:47:39.300  READ FPDMA QUEUED
  60 08 00 28 29 8e 40 08  12d+03:47:39.300  READ FPDMA QUEUED

Error 2 occurred at disk power-on lifetime: 7675 hours (319 days + 19 hours)
  When the command that caused the error occurred, the device was active or
idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  84 51 c8 08 59 3e 41

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  60 d8 00 f8 58 3e 40 08   2d+03:42:43.800  READ FPDMA QUEUED
  60 08 60 f0 58 3e 40 08   2d+03:42:43.800  READ FPDMA QUEUED
  60 08 58 e8 58 3e 40 08   2d+03:42:43.800  READ FPDMA QUEUED
  60 08 50 e0 58 3e 40 08   2d+03:42:43.800  READ FPDMA QUEUED
  60 08 28 d8 58 3e 40 08   2d+03:42:43.800  READ FPDMA QUEUED

Error 1 occurred at disk power-on lifetime: 7673 hours (319 days + 17 hours)
  When the command that caused the error occurred, the device was active or
idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  84 51 28 d7 97 4e 40

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  60 68 60 98 97 4e 40 08   2d+01:26:53.900  READ FPDMA QUEUED
  61 00 58 00 81 ff 40 08   2d+01:26:53.800  WRITE FPDMA QUEUED
  61 10 10 00 80 fe 40 08   2d+01:26:53.800  WRITE FPDMA QUEUED
  61 f0 08 10 80 ff 40 08   2d+01:26:53.800  WRITE FPDMA QUEUED
  61 68 00 98 01 ff 40 08   2d+01:26:53.800  WRITE FPDMA QUEUED


sdc  HDS721010KLA330

ATA Error Count: 408 (device log contains only the most recent five errors)

Error 408 occurred at disk power-on lifetime: 8426 hours (351 days + 2
hours)
  When the command that caused the error occurred, the device was active or
idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  84 51 08 8f 87 d6 43

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  60 88 00 10 87 d6 40 08  12d+01:59:16.500  READ FPDMA QUEUED
  60 08 00 08 87 d6 40 08  12d+01:59:16.500  READ FPDMA QUEUED
  60 08 18 00 87 d6 40 08  12d+01:59:16.500  READ FPDMA QUEUED
  60 a8 10 58 86 d6 40 08  12d+01:59:16.500  READ FPDMA QUEUED
  60 58 00 00 86 d6 40 08  12d+01:59:16.500  READ FPDMA QUEUED

Error 407 occurred at disk power-on lifetime: 8426 hours (351 days + 2
hours)
  When the command that caused the error occurred, the device was active or
idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  84 51 d0 30 c3 a4 42

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  60 08 20 00 c5 a4 40 08  12d+01:47:43.600  READ FPDMA QUEUED
  60 00 18 00 c4 a4 40 08  12d+01:47:43.600  READ FPDMA QUEUED
  60 00 10 00 c3 a4 40 08  12d+01:47:43.600  READ FPDMA QUEUED
  60 b8 08 48 c2 a4 40 08  12d+01:47:43.600  READ FPDMA QUEUED
  60 48 00 00 c2 a4 40 08  12d+01:47:43.600  READ FPDMA QUEUED

Error 406 occurred at disk power-on lifetime: 8424 hours (351 days + 0
hours)
  When the command that caused the error occurred, the device was active or
idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  84 51 50 b0 8a c2 48

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  60 18 18 00 8b c2 40 08  12d+00:12:53.000  READ FPDMA QUEUED
  60 00 10 00 8a c2 40 08  12d+00:12:53.000  READ FPDMA QUEUED
  60 00 08 00 89 c2 40 08  12d+00:12:53.000  READ FPDMA QUEUED
  60 00 00 00 88 c2 40 08  12d+00:12:53.000  READ FPDMA QUEUED
  60 00 18 00 87 c2 40 08  12d+00:12:53.000  READ FPDMA QUEUED

Error 405 occurred at disk power-on lifetime: 8424 hours (351 days + 0
hours)
  When the command that caused the error occurred, the device was active or
idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  84 51 e0 1f 6a ec 46

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  60 30 10 00 6b ec 40 08  11d+23:53:47.200  READ FPDMA QUEUED
  60 00 08 00 6a ec 40 08  11d+23:53:47.200  READ FPDMA QUEUED
  60 f0 00 10 69 ec 40 08  11d+23:53:47.200  READ FPDMA QUEUED
  60 10 18 00 69 ec 40 08  11d+23:53:47.200  READ FPDMA QUEUED
  60 00 10 00 68 ec 40 08  11d+23:53:47.200  READ FPDMA QUEUED

Error 404 occurred at disk power-on lifetime: 8423 hours (350 days + 23
hours)
  When the command that caused the error occurred, the device was active or
idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  84 51 10 ef 19 e6 43

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  60 e0 00 20 19 e6 40 08  11d+23:13:38.800  READ FPDMA QUEUED
  60 20 20 00 19 e6 40 08  11d+23:13:38.800  READ FPDMA QUEUED
  60 00 18 00 18 e6 40 08  11d+23:13:38.800  READ FPDMA QUEUED
  60 e0 10 20 17 e6 40 08  11d+23:13:38.800  READ FPDMA QUEUED
  60 20 08 00 17 e6 40 08  11d+23:13:38.800  READ FPDMA QUEUED


sdd  HDS721010KLA330

ATA Error Count: 679 (device log contains only the most recent five errors)

Error 679 occurred at disk power-on lifetime: 8717 hours (363 days + 5
hours)
  When the command that caused the error occurred, the device was active or
idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  84 51 31 4f 63 87 4d

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  61 40 38 40 63 87 40 08  23d+22:03:52.500  WRITE FPDMA QUEUED
  61 c0 08 80 62 87 40 08  23d+22:03:52.500  WRITE FPDMA QUEUED
  61 f0 28 90 61 87 40 08  23d+22:03:52.500  WRITE FPDMA QUEUED
  61 88 20 00 61 87 40 08  23d+22:03:52.500  WRITE FPDMA QUEUED
  61 08 08 f8 5d 87 40 08  23d+22:03:52.500  WRITE FPDMA QUEUED

Error 678 occurred at disk power-on lifetime: 8717 hours (363 days + 5
hours)
  When the command that caused the error occurred, the device was active or
idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  84 51 40 90 48 1c 47

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  61 f0 28 90 4f 1c 40 08  23d+21:59:42.400  WRITE FPDMA QUEUED
  61 50 20 80 48 1c 40 08  23d+21:59:42.400  WRITE FPDMA QUEUED
  60 40 48 08 bb 72 40 08  23d+21:59:42.400  READ FPDMA QUEUED
  61 10 40 80 4e 1c 40 08  23d+21:59:42.400  WRITE FPDMA QUEUED
  61 78 30 08 4b 1c 40 08  23d+21:59:42.400  WRITE FPDMA QUEUED

Error 677 occurred at disk power-on lifetime: 8717 hours (363 days + 5
hours)
  When the command that caused the error occurred, the device was active or
idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  84 51 58 80 f1 8d 46

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  61 78 58 08 00 8e 40 08  23d+21:59:17.300  WRITE FPDMA QUEUED
  61 20 10 e0 f1 8d 40 08  23d+21:59:17.300  WRITE FPDMA QUEUED
  61 58 08 80 f0 8d 40 08  23d+21:59:17.300  WRITE FPDMA QUEUED
  61 08 00 60 ea 8d 40 08  23d+21:59:17.300  WRITE FPDMA QUEUED
  60 78 08 80 ed 8d 40 08  23d+21:59:17.300  READ FPDMA QUEUED

Error 676 occurred at disk power-on lifetime: 8717 hours (363 days + 5
hours)
  When the command that caused the error occurred, the device was active or
idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  84 51 70 b0 1c de 46

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  60 08 68 20 61 70 40 08  23d+21:58:42.100  READ FPDMA QUEUED
  61 08 48 f8 1e de 40 08  23d+21:58:42.100  WRITE FPDMA QUEUED
  61 d0 40 20 1d de 40 08  23d+21:58:42.100  WRITE FPDMA QUEUED
  61 a0 20 80 1c de 40 08  23d+21:58:42.100  WRITE FPDMA QUEUED
  61 80 08 00 1b de 40 08  23d+21:58:42.100  WRITE FPDMA QUEUED

Error 675 occurred at disk power-on lifetime: 8717 hours (363 days + 5
hours)
  When the command that caused the error occurred, the device was active or
idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  84 51 10 f0 03 de 46

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  61 40 88 c0 03 de 40 08  23d+21:58:41.100  WRITE FPDMA QUEUED
  61 28 80 00 e8 dd 40 08  23d+21:58:41.100  WRITE FPDMA QUEUED
  61 08 48 b8 03 de 40 08  23d+21:58:41.100  WRITE FPDMA QUEUED
  61 30 40 80 03 de 40 08  23d+21:58:41.100  WRITE FPDMA QUEUED
  61 10 38 68 03 de 40 08  23d+21:58:41.100  WRITE FPDMA QUEUED


sdb  HDS721010KLA330

ATA Error Count: 1871 (device log contains only the most recent five errors)

Error 1871 occurred at disk power-on lifetime: 8455 hours (352 days + 7
hours)
  When the command that caused the error occurred, the device was active or
idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  84 51 b1 57 f6 46 e4  Error: ICRC, ABRT 177 sectors at LBA = 0x0446f657 =
71759447

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  35 00 00 08 f3 46 e0 08  11d+11:10:29.700  WRITE DMA EXT
  35 00 08 00 f3 46 e0 08  11d+11:10:29.700  WRITE DMA EXT
  35 00 00 00 f0 46 e0 08  11d+11:10:29.600  WRITE DMA EXT
  35 00 00 00 ef 46 e0 08  11d+11:10:29.600  WRITE DMA EXT
  35 00 00 00 ee 46 e0 08  11d+11:10:29.600  WRITE DMA EXT

Error 1870 occurred at disk power-on lifetime: 8455 hours (352 days + 7
hours)
  When the command that caused the error occurred, the device was active or
idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  84 51 69 cf b6 dd e3  Error: ICRC, ABRT 105 sectors at LBA = 0x03ddb6cf =
64861903

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  35 00 d8 60 b6 dd e0 08  11d+11:04:15.600  WRITE DMA EXT
  35 00 08 58 b6 dd e0 08  11d+11:04:15.600  WRITE DMA EXT
  35 00 d0 88 b5 dd e0 08  11d+11:04:15.600  WRITE DMA EXT
  35 00 b0 d8 b3 dd e0 08  11d+11:04:15.500  WRITE DMA EXT
  35 00 50 88 b3 dd e0 08  11d+11:04:15.500  WRITE DMA EXT

Error 1869 occurred at disk power-on lifetime: 8455 hours (352 days + 7
hours)
  When the command that caused the error occurred, the device was active or
idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  84 51 71 8f d9 dc e3  Error: ICRC, ABRT 113 sectors at LBA = 0x03dcd98f =
64805263

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  35 00 00 00 d8 dc e0 08  11d+11:04:12.300  WRITE DMA EXT
  35 00 00 00 d7 dc e0 08  11d+11:04:12.300  WRITE DMA EXT
  35 00 00 00 d6 dc e0 08  11d+11:04:12.300  WRITE DMA EXT
  35 00 00 00 d4 dc e0 08  11d+11:04:12.200  WRITE DMA EXT
  35 00 00 00 d0 dc e0 08  11d+11:04:12.200  WRITE DMA EXT

Error 1868 occurred at disk power-on lifetime: 8455 hours (352 days + 7
hours)
  When the command that caused the error occurred, the device was active or
idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  84 51 09 ff 24 bc e3  Error: ICRC, ABRT 9 sectors at LBA = 0x03bc24ff =
62661887

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  35 00 08 00 24 bc e0 08  11d+11:02:16.600  WRITE DMA EXT
  35 00 00 00 20 bc e0 08  11d+11:02:16.600  WRITE DMA EXT
  35 00 f8 08 1f bc e0 08  11d+11:02:16.500  WRITE DMA EXT
  35 00 08 00 1f bc e0 08  11d+11:02:16.500  WRITE DMA EXT
  35 00 00 00 1c bc e0 08  11d+11:02:16.500  WRITE DMA EXT

Error 1867 occurred at disk power-on lifetime: 8455 hours (352 days + 7
hours)
  When the command that caused the error occurred, the device was active or
idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  84 51 10 f0 fd 94 e3  Error: ICRC, ABRT 16 sectors at LBA = 0x0394fdf0 =
60095984

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  35 00 00 00 fb 94 e0 08  11d+10:59:58.100  WRITE DMA EXT
  35 00 f8 08 fa 94 e0 08  11d+10:59:58.100  WRITE DMA EXT
  35 00 08 00 fa 94 e0 08  11d+10:59:58.100  WRITE DMA EXT
  35 00 00 00 f8 94 e0 08  11d+10:59:58.000  WRITE DMA EXT
  35 00 00 00 f4 94 e0 08  11d+10:59:58.000  WRITE DMA EXT

