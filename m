Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56FE0166F14
	for <linux-raid@vger.kernel.org>; Tue,  6 Aug 2024 23:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722988651; cv=none; b=j0JWfYtb18gNBCVIXI5AcpzWgoJV/m7BoXogQnd9yjgaxTGDxoFCjqpoP9awEkrkLFvfH3gF6R4y2iEsDf16HoBk3z0Y1YoGvRM3R+P0acFcwKy0NtJdJEbqRMZ+olVJRe517+d+hhlUpznZgPfhnexI4lxOxks3h4J8sIsAMkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722988651; c=relaxed/simple;
	bh=BA9eb9LK6tmpfQDJmBTFqDVU8hUEsqVTc3AimXlTuP0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jlUxqBtjJcT6xnPUjGodzPasIMqPffdjnfNqlNKeZixqXEWChf6uhgmoejDCxwsHbiJGQrV7CnIobjQE7Dl9Im7hSuMI+n1XRiuF0kzv+H5LtrRF4ExoKR1K/GUiygI6wcLA9jC43//fL6dKeSuGhRlymQkUWHjReDYDT7yguds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EsGsqx6T; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EsGsqx6T"
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-397ba4f7387so6130475ab.0
        for <linux-raid@vger.kernel.org>; Tue, 06 Aug 2024 16:57:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722988648; x=1723593448; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uqsOsueVEoiZ1a9QUT2lG+0lOMx3ZTxfN38HtogaQk4=;
        b=EsGsqx6T6fi+E5mY/HP6QSfkzgc587KCIUbGb9al7N06ZInY62G8eMs5JtZ3StI3On
         HjsRFH/D+BJhYkJ6OrhyiMUEIHT/u1eozn6uYscRzMy7cpIm23/SVV/Ppcd4mCMZDvjk
         BaVEdtD+yyfXnUmwDOvJG5pDvVTUbya8o69X0KCHhklxD0btI5Ru1rWAEu9miM61SdNC
         pfKMlnp1qSa/TdP38/XULlBCTdvpHHbRnJIAE4XaZEU40Q9yKtGZbYSrF6LH/wfKjbwp
         8u/teM194TdPd/wliiJl4ebZQsAlMmUu/3+KkqKFqr8JaNwG7nqUse9RmvO6UW3IRDd+
         54oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722988648; x=1723593448;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uqsOsueVEoiZ1a9QUT2lG+0lOMx3ZTxfN38HtogaQk4=;
        b=pD3+KzndMkYZ+xFgy+3UlXZ2988xpcC4xEbVsnob9WFn/vIaiyzFzt3Bwxp2V/YVCO
         FcR+XvGPvhZhKn5ZumYbMjMFc+RlBi0Jdt1DMWTfGT51iBX0JvTEggDoZob/R9fQSv8j
         yL6HxhLIYI8/fBUSUFf8ny6ib9dATrQR8YalF48Qdc13hevtE+Oe7e9bZ+hgXdcplTCr
         S7HHueBMsyJs5r0aHnE0Bat5DIcJMw+2Go9KLBZe8HJ+LiMvfn3RrzRlqtDiYzM+JM3j
         r7LP3D2dkZXpFitqH3rBbiJhXITR5CVV1sfP4kQqlSXsEADtXNgEpoRrvPHCDHPXn+l4
         rpuA==
X-Gm-Message-State: AOJu0YxSMAd8ijSVpvqcl1LsH4X2zLZNRGzS0zUvmwv7+PK6dbCDTSh6
	L1iaLYOr/rL+32pwCJjU1sbP0EoU7/es9xMwwzpVg2kD9S/O7+Q91/K0PS8WDO/OUjZ5JgNu3oI
	HQaNdAWDtifHOM14b2+M+X6zItGrpyUIJ
X-Google-Smtp-Source: AGHT+IFR+V1y7lgN4hpIRrQEPSJYDQ0R7rPWMmgd3PIndWiZSAaLU5OTkFK8zjyIP+NiyEpLsOqzrt/pZKoheSkF3KA=
X-Received: by 2002:a05:6e02:218f:b0:39b:2ca4:e391 with SMTP id
 e9e14a558f8ab-39b2ca4e898mr166371525ab.1.1722988648148; Tue, 06 Aug 2024
 16:57:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAEWy8SyOXqk+CYu_8HV-R_bRa8WRVYUu_DhU8=RfZevZZGMRHA@mail.gmail.com>
In-Reply-To: <CAEWy8SyOXqk+CYu_8HV-R_bRa8WRVYUu_DhU8=RfZevZZGMRHA@mail.gmail.com>
From: Roger Heflin <rogerheflin@gmail.com>
Date: Tue, 6 Aug 2024 18:57:16 -0500
Message-ID: <CAAMCDeeTZrP-VGz2sqaCS5JtETK0DHydXT0qwE=cbQ5eQDg1Dg@mail.gmail.com>
Subject: Re: RAID missing post reboot
To: Ryan England <ryan.england@lambdal.com>
Cc: linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Several of the parts are indicating that the partition has a partition
table on it.

Both the examine and the wipefs show that.   The aa55 is a GPT
partition table and that WILL overwrite parts of the mdadm headers.

What are the full steps that you are using to create the raid?

On Tue, Aug 6, 2024 at 6:20=E2=80=AFPM Ryan England <ryan.england@lambdal.c=
om> wrote:
>
> Hello everyone,
>
> I've been working on a system with a software RAID for the last couple
> of weeks. I ran through the process of creating the array as RAID5
> using /dev/nvme0n1p1, /dev/nvme1n1p1, and /dev/nvme2n1p1. I then
> create the filesystem, update mdadm.conf, and run update-initramfs -u.
>
> The array and file system are created successfully. It's created as
> /dev/md127. I mount it to the system and I can write data to it.
> /etc/fstab has also been updated.
>
> After rebooting the machine, the system enters Emergency Mode.
> Commenting out the newly created device and rebooting the machine
> brings it back to Emergency Mode. I can also skip EM by adding the
> nofail option to the mount point in /etc/fstab.
>
> Today, I walked through recreating the array. Once created, I ran
> mkfs.ext4 again. This time, I noticed that the command found an ext4
> file system. To try and repair it, I ran fsck -y against /dev/md127.
> The end of the fsck noted that a resize of the inode (re)creation
> failed: Inode checksum does not match inode. Mounting failed, so we
> made the filesystem again.
>
> It's worth noting that there's NO data on this array at this time.
> Hence why we were able to go through with making the filesystem again.
> I made sure to gather all of the info noted within the mdadm wiki and
> I've included that below. The only thing not included is mdadm
> --detail of each of the partitions because the system doesn't
> recognize them as being part of an md. Also, md0 hosts the root volume
> and isn't a part of the output below.
>
> As far as troubleshooting is concerned, I've tried the following:
> 1. mdadm --manage /dev/md127 --run
> 2. echo "clean" > /sys/block/md127/md/array_state & then run command 1
> 3. mdadm --assemble --force /dev/md127 /dev/nvme0n1p1 /dev/nvme1n1p1
> /dev/nvme2n1p1 & then run command 1
>
> I've also poured over logs. Once, I noticed that nvme2n1p1 wasn't
> being recognized as a part of the kernel logs. To rule that out as the
> issue, I created a RAID1 between nvme0n1p1 & nvme1n1p1. This still
> didn't work.
>
> Looking through journalctl -xb, I found an error noting a package that
> was missing. The package is named ibblockdev-mdraid2. Installing that
> package still didn't help.
>
> Lastly, I included the output of wipefs at the behest of a colleague.
> Any support you can provide will be greatly appreciated.
>
> Regards,
> Ryan E.
>
>
> ____________________________________________
>
> Start of the mdadm bug report log file.
>
> Date: Tue Aug  6 02:42:59 PM PDT 2024
> uname: Linux REDACTED 5.15.0-117-generic #127-Ubuntu SMP Fri Jul 5
> 20:13:28 UTC 2024 x86_64 x86_64 x86_64 GNU/Linux
> command line flags:
>
> ____________________________________________
>
> mdadm --version
>
> mdadm - v4.2 - 2021-12-30
>
> ____________________________________________
>
> cat /proc/mdstat
>
> Personalities : [raid1] [linear] [multipath] [raid0] [raid6] [raid5]
> [raid4] [raid10]
> md0 : active raid1 sdb2[1] sda2[0] 1874715648 blocks super 1.2 [2/2]
> [UU] bitmap: 8/14 pages [32KB], 65536KB chunk unused devices: <none>
>
> ____________________________________________
>
> mdadm --examine /dev/nvme0n1p1 /dev/nvme1n1p1 /dev/nvme2n1p1
>
> /dev/nvme0n1p1: MBR Magic : aa55 Partition[0] : 4294967295 sectors at
> 1 (type ee)
> /dev/nvme1n1p1: MBR Magic : aa55 Partition[0] : 4294967295 sectors at
> 1 (type ee)
> /dev/nvme2n1p1: MBR Magic : aa55 Partition[0] : 4294967295 sectors at
> 1 (type ee)
>
> ____________________________________________
>
> mdadm --detail /dev/nvme0n1p1 /dev/nvme1n1p1 /dev/nvme2n1p1
>
> mdadm: /dev/nvme0n1p1 does not appear to be an md device
> mdadm: /dev/nvme1n1p1 does not appear to be an md device
> mdadm: /dev/nvme2n1p1 does not appear to be an md device
>
> ____________________________________________
>
> smartctl --xall /dev/nvme0n1p1
>
> smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.15.0-117-generic] (local bu=
ild)
> Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmontools.o=
rg
>
> =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
> Model Number:                       SAMSUNG MZQL23T8HCLS-00A07
> Serial Number:                      S64HNS0TC05245
> Firmware Version:                   GDC5602Q
> PCI Vendor/Subsystem ID:            0x144d
> IEEE OUI Identifier:                0x002538
> Total NVM Capacity:                 3,840,755,982,336 [3.84 TB]
> Unallocated NVM Capacity:           0
> Controller ID:                      6
> NVMe Version:                       1.4
> Number of Namespaces:               32
> Namespace 1 Size/Capacity:          3,840,755,982,336 [3.84 TB]
> Namespace 1 Utilization:            71,328,116,736 [71.3 GB]
> Namespace 1 Formatted LBA Size:     512
> Local Time is:                      Tue Aug  6 15:16:08 2024 PDT
> Firmware Updates (0x17):            3 Slots, Slot 1 R/O, no Reset require=
d
> Optional Admin Commands (0x005f):   Security Format Frmw_DL NS_Mngmt
> Self_Test MI_Snd/Rec
> Optional NVM Commands (0x005f):     Comp Wr_Unc DS_Mngmt Wr_Zero
> Sav/Sel_Feat Timestmp
> Log Page Attributes (0x0e):         Cmd_Eff_Lg Ext_Get_Lg Telmtry_Lg
> Maximum Data Transfer Size:         512 Pages
> Warning  Comp. Temp. Threshold:     80 Celsius
> Critical Comp. Temp. Threshold:     83 Celsius
> Namespace 1 Features (0x1a):        NA_Fields No_ID_Reuse NP_Fields
>
> Supported Power States
> St Op     Max   Active     Idle   RL RT WL WT  Ent_Lat  Ex_Lat
>  0 +    25.00W   14.00W       -    0  0  0  0       70      70
>  1 +     8.00W    8.00W       -    1  1  1  1       70      70
>
> Supported LBA Sizes (NSID 0x1)
> Id Fmt  Data  Metadt  Rel_Perf
>  0 +     512       0         0
>  1 -    4096       0         0
>
> =3D=3D=3D START OF SMART DATA SECTION =3D=3D=3D
> SMART overall-health self-assessment test result: PASSED
>
> SMART/Health Information (NVMe Log 0x02)
> Critical Warning:                   0x00
> Temperature:                        35 Celsius
> Available Spare:                    100%
> Available Spare Threshold:          10%
> Percentage Used:                    0%
> Data Units Read:                    31,574,989 [16.1 TB]
> Data Units Written:                 304,488 [155 GB]
> Host Read Commands:                 36,420,064
> Host Write Commands:                3,472,342
> Controller Busy Time:               63
> Power Cycles:                       11
> Power On Hours:                     5,582
> Unsafe Shutdowns:                   9
> Media and Data Integrity Errors:    0
> Error Information Log Entries:      0
> Warning  Comp. Temperature Time:    0
> Critical Comp. Temperature Time:    0
> Temperature Sensor 1:               35 Celsius
> Temperature Sensor 2:               44 Celsius
>
> Error Information (NVMe Log 0x01, 16 of 64 entries)
> No Errors Logged
>
> ____________________________________________
>
> smartctl --xall /dev/nvme1n1p1
>
> smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.15.0-117-generic] (local bu=
ild)
> Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmontools.o=
rg
>
> =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
> Model Number:                       SAMSUNG MZQL23T8HCLS-00A07
> Serial Number:                      S64HNS0TC05241
> Firmware Version:                   GDC5602Q
> PCI Vendor/Subsystem ID:            0x144d
> IEEE OUI Identifier:                0x002538
> Total NVM Capacity:                 3,840,755,982,336 [3.84 TB]
> Unallocated NVM Capacity:           0
> Controller ID:                      6
> NVMe Version:                       1.4
> Number of Namespaces:               32
> Namespace 1 Size/Capacity:          3,840,755,982,336 [3.84 TB]
> Namespace 1 Utilization:            71,324,651,520 [71.3 GB]
> Namespace 1 Formatted LBA Size:     512
> Local Time is:                      Tue Aug  6 15:16:22 2024 PDT
> Firmware Updates (0x17):            3 Slots, Slot 1 R/O, no Reset require=
d
> Optional Admin Commands (0x005f):   Security Format Frmw_DL NS_Mngmt
> Self_Test MI_Snd/Rec
> Optional NVM Commands (0x005f):     Comp Wr_Unc DS_Mngmt Wr_Zero
> Sav/Sel_Feat Timestmp
> Log Page Attributes (0x0e):         Cmd_Eff_Lg Ext_Get_Lg Telmtry_Lg
> Maximum Data Transfer Size:         512 Pages
> Warning  Comp. Temp. Threshold:     80 Celsius
> Critical Comp. Temp. Threshold:     83 Celsius
> Namespace 1 Features (0x1a):        NA_Fields No_ID_Reuse NP_Fields
>
> Supported Power States
> St Op     Max   Active     Idle   RL RT WL WT  Ent_Lat  Ex_Lat
>  0 +    25.00W   14.00W       -    0  0  0  0       70      70
>  1 +     8.00W    8.00W       -    1  1  1  1       70      70
>
> Supported LBA Sizes (NSID 0x1)
> Id Fmt  Data  Metadt  Rel_Perf
>  0 +     512       0         0
>  1 -    4096       0         0
>
> =3D=3D=3D START OF SMART DATA SECTION =3D=3D=3D
> SMART overall-health self-assessment test result: PASSED
>
> SMART/Health Information (NVMe Log 0x02)
> Critical Warning:                   0x00
> Temperature:                        34 Celsius
> Available Spare:                    100%
> Available Spare Threshold:          10%
> Percentage Used:                    0%
> Data Units Read:                    24,073,787 [12.3 TB]
> Data Units Written:                 7,805,460 [3.99 TB]
> Host Read Commands:                 29,506,475
> Host Write Commands:                10,354,117
> Controller Busy Time:               64
> Power Cycles:                       11
> Power On Hours:                     5,582
> Unsafe Shutdowns:                   9
> Media and Data Integrity Errors:    0
> Error Information Log Entries:      0
> Warning  Comp. Temperature Time:    0
> Critical Comp. Temperature Time:    0
> Temperature Sensor 1:               34 Celsius
> Temperature Sensor 2:               44 Celsius
>
> Error Information (NVMe Log 0x01, 16 of 64 entries)
> No Errors Logged
>
> ____________________________________________
>
> smartctl --xall /dev/nvme2n1p1
>
> smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.15.0-117-generic] (local bu=
ild)
> Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmontools.o=
rg
>
> =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
> Model Number:                       SAMSUNG MZQL23T8HCLS-00A07
> Serial Number:                      S64HNS0TC05244
> Firmware Version:                   GDC5602Q
> PCI Vendor/Subsystem ID:            0x144d
> IEEE OUI Identifier:                0x002538
> Total NVM Capacity:                 3,840,755,982,336 [3.84 TB]
> Unallocated NVM Capacity:           0
> Controller ID:                      6
> NVMe Version:                       1.4
> Number of Namespaces:               32
> Namespace 1 Size/Capacity:          3,840,755,982,336 [3.84 TB]
> Namespace 1 Utilization:            3,840,514,523,136 [3.84 TB]
> Namespace 1 Formatted LBA Size:     512
> Local Time is:                      Tue Aug  6 15:16:33 2024 PDT
> Firmware Updates (0x17):            3 Slots, Slot 1 R/O, no Reset require=
d
> Optional Admin Commands (0x005f):   Security Format Frmw_DL NS_Mngmt
> Self_Test MI_Snd/Rec
> Optional NVM Commands (0x005f):     Comp Wr_Unc DS_Mngmt Wr_Zero
> Sav/Sel_Feat Timestmp
> Log Page Attributes (0x0e):         Cmd_Eff_Lg Ext_Get_Lg Telmtry_Lg
> Maximum Data Transfer Size:         512 Pages
> Warning  Comp. Temp. Threshold:     80 Celsius
> Critical Comp. Temp. Threshold:     83 Celsius
> Namespace 1 Features (0x1a):        NA_Fields No_ID_Reuse NP_Fields
>
> Supported Power States
> St Op     Max   Active     Idle   RL RT WL WT  Ent_Lat  Ex_Lat
>  0 +    25.00W   14.00W       -    0  0  0  0       70      70
>  1 +     8.00W    8.00W       -    1  1  1  1       70      70
>
> Supported LBA Sizes (NSID 0x1)
> Id Fmt  Data  Metadt  Rel_Perf
>  0 +     512       0         0
>  1 -    4096       0         0
>
> =3D=3D=3D START OF SMART DATA SECTION =3D=3D=3D
> SMART overall-health self-assessment test result: PASSED
>
> SMART/Health Information (NVMe Log 0x02)
> Critical Warning:                   0x00
> Temperature:                        33 Celsius
> Available Spare:                    100%
> Available Spare Threshold:          10%
> Percentage Used:                    0%
> Data Units Read:                    33,340 [17.0 GB]
> Data Units Written:                 24,215,921 [12.3 TB]
> Host Read Commands:                 812,460
> Host Write Commands:                31,463,496
> Controller Busy Time:               50
> Power Cycles:                       12
> Power On Hours:                     5,582
> Unsafe Shutdowns:                   9
> Media and Data Integrity Errors:    0
> Error Information Log Entries:      0
> Warning  Comp. Temperature Time:    0
> Critical Comp. Temperature Time:    0
> Temperature Sensor 1:               33 Celsius
> Temperature Sensor 2:               42 Celsius
>
> Error Information (NVMe Log 0x01, 16 of 64 entries)
> No Errors Logged
>
> ____________________________________________
>
> lsdrv
>
> PCI [nvme] 22:00.0 Non-Volatile memory controller: Samsung Electronics
> Co Ltd NVMe SSD Controller PM9A1/PM9A3/980PRO
> =E2=94=94nvme nvme0 SAMSUNG MZQL23T8HCLS-00A07               {S64HNS0TC05=
245}
>  =E2=94=94nvme0n1 3.49t [259:0] Partitioned (gpt)
>   =E2=94=94nvme0n1p1 3.49t [259:1] Partitioned (gpt)
> PCI [nvme] 23:00.0 Non-Volatile memory controller: Samsung Electronics
> Co Ltd NVMe SSD Controller PM9A1/PM9A3/980PRO
> =E2=94=94nvme nvme1 SAMSUNG MZQL23T8HCLS-00A07               {S64HNS0TC05=
241}
>  =E2=94=94nvme1n1 3.49t [259:2] Partitioned (gpt)
>   =E2=94=94nvme1n1p1 3.49t [259:3] Partitioned (gpt)
> PCI [nvme] 24:00.0 Non-Volatile memory controller: Samsung Electronics
> Co Ltd NVMe SSD Controller PM9A1/PM9A3/980PRO
> =E2=94=94nvme nvme2 SAMSUNG MZQL23T8HCLS-00A07               {S64HNS0TC05=
244}
>  =E2=94=94nvme2n1 3.49t [259:4] Partitioned (gpt)
>   =E2=94=94nvme2n1p1 3.49t [259:5] Partitioned (gpt)
> PCI [ahci] 64:00.0 SATA controller: ASMedia Technology Inc. ASM1062
> Serial ATA Controller (rev 02)
> =E2=94=9Cscsi 0:0:0:0 ATA      SAMSUNG MZ7L31T9 {S6ESNS0W416204}
> =E2=94=82=E2=94=94sda 1.75t [8:0] Partitioned (gpt)
> =E2=94=82 =E2=94=9Csda1 512.00m [8:1] vfat {B0FD-2869}
> =E2=94=82 =E2=94=82=E2=94=94Mounted as /dev/sda1 @ /boot/efi
> =E2=94=82 =E2=94=94sda2 1.75t [8:2] MD raid1 (0/2) (w/ sdb2) in_sync 'ubu=
ntu-server:0'
> {2bcfa20a-e221-299c-d3e6-f4cf8124e265}
> =E2=94=82  =E2=94=94md0 1.75t [9:0] MD v1.2 raid1 (2) active
> {2bcfa20a:-e221-29:9c-d3e6-:f4cf8124e265}
> =E2=94=82   =E2=94=82               Partitioned (gpt)
> =E2=94=82   =E2=94=94md0p1 1.75t [259:6] ext4 {81b5ccee-9c72-4cac-8579-3b=
9627a8c1b6}
> =E2=94=82    =E2=94=94Mounted as /dev/md0p1 @ /
> =E2=94=94scsi 1:0:0:0 ATA      SAMSUNG MZ7L31T9 {S6ESNS0W416208}
>  =E2=94=94sdb 1.75t [8:16] Partitioned (gpt)
>   =E2=94=9Csdb1 512.00m [8:17] vfat {B11F-39A7}
>   =E2=94=94sdb2 1.75t [8:18] MD raid1 (1/2) (w/ sda2) in_sync
> 'ubuntu-server:0' {2bcfa20a-e221-299c-d3e6-f4cf8124e265}
>    =E2=94=94md0 1.75t [9:0] MD v1.2 raid1 (2) active
> {2bcfa20a:-e221-29:9c-d3e6-:f4cf8124e265}
>                     Partitioned (gpt)
> PCI [ahci] 66:00.0 SATA controller: Advanced Micro Devices, Inc. [AMD]
> FCH SATA Controller [AHCI mode] (rev 91)
> =E2=94=94scsi 2:x:x:x [Empty]
> PCI [ahci] 66:00.1 SATA controller: Advanced Micro Devices, Inc. [AMD]
> FCH SATA Controller [AHCI mode] (rev 91)
> =E2=94=94scsi 10:x:x:x [Empty]
> PCI [ahci] 04:00.0 SATA controller: Advanced Micro Devices, Inc. [AMD]
> FCH SATA Controller [AHCI mode] (rev 91)
> =E2=94=94scsi 18:x:x:x [Empty]
> PCI [ahci] 04:00.1 SATA controller: Advanced Micro Devices, Inc. [AMD]
> FCH SATA Controller [AHCI mode] (rev 91)
> =E2=94=94scsi 26:x:x:x [Empty]
> Other Block Devices
> =E2=94=9Cloop0 0.00k [7:0] Empty/Unknown
> =E2=94=9Cloop1 0.00k [7:1] Empty/Unknown
> =E2=94=9Cloop2 0.00k [7:2] Empty/Unknown
> =E2=94=9Cloop3 0.00k [7:3] Empty/Unknown
> =E2=94=9Cloop4 0.00k [7:4] Empty/Unknown
> =E2=94=9Cloop5 0.00k [7:5] Empty/Unknown
> =E2=94=9Cloop6 0.00k [7:6] Empty/Unknown
> =E2=94=94loop7 0.00k [7:7] Empty/Unknown
>
> ____________________________________________
>
> wipefs /dev/nvme0n1p1
>
> DEVICE    OFFSET        TYPE UUID LABEL
> nvme0n1p1 0x200         gpt
> nvme0n1p1 0x37e38900000 gpt
> nvme0n1p1 0x1fe         PMBR
>
> ____________________________________________
>
> wipefs /dev/nvme1n1p1
>
> DEVICE    OFFSET        TYPE UUID LABEL
> nvme1n1p1 0x200         gpt
> nvme1n1p1 0x37e38900000 gpt
> nvme1n1p1 0x1fe         PMBR
>
> ____________________________________________
>
> wipefs /dev/nvme2n1p1
>
> DEVICE    OFFSET        TYPE UUID LABEL
> nvme2n1p1 0x200         gpt
> nvme2n1p1 0x37e38900000 gpt
> nvme2n1p1 0x1fe         PMBR
>
