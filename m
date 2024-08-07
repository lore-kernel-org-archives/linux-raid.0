Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E6FC383
	for <linux-raid@vger.kernel.org>; Wed,  7 Aug 2024 01:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722993232; cv=none; b=THvDmOvuf3IqmKNYl4pUll4l2b93yRUF5vYVihkanCb/fEstGR1DiKeyFUvF1UFj7yImLXTYRLYsLvEPgjUN3PIFFpuUmrTYV8DLB0rj65vQnru1NcVi/QMJl5dXgvhiP5zvyg1m06AsGFcEis5UlpcpSwPeXQOdyGYqH2I2XxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722993232; c=relaxed/simple;
	bh=IVK3SCjplJwpLTfoszTs0Vs215plILsfL/XMSFq0/kw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fwT/WEcH07hMsbwa11fuLn+28p9LNVxAWkHWlhHvfH3HJ7wYczO10sfdmiYHhhuwc3Pc5jrnGBNmfHTuSC4c2JILzvq6fRqM27JeOiQ1g3iBxEyOPqbwz+mmHk1LuS/s6Wclaae3l7DrUmDyGnxlyi/JtJOCOkvKbUK8rGA7k1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZJQsx5bO; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZJQsx5bO"
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-81f83b14d65so51831139f.1
        for <linux-raid@vger.kernel.org>; Tue, 06 Aug 2024 18:13:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722993229; x=1723598029; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SncexguTXxhTIz/tzcyB2li2hTXxyS0Ef5wbPXgVJAo=;
        b=ZJQsx5bOM+gOOEwCx9CH1KmmKPcFCM4t/aW9mrwduFrV/5hf0ERnpRzo/UE5PbBw5i
         QedK6opSSQ/2VoYCMtLwmWE+bedRLCCNYyIoWf/DLa1mHcitp7HuzCCOymbrQ1gW/L5l
         w7LuOf8P0tWgRoGxCvbLHCpGKjsp5hTTAKSMIyUL+yvhyMR5H8jMC1+hgF7HSa5cpodD
         D+9y/VRLEs1CsG4CUvXti7Cj9DKIUW6HzWZGwhlUpHxeJUBjsByZ47+YVJ31RYpd1Ehf
         arFMrQLfINEcmSI9G6saZtolQcoN+ftXeN3bfEr4XINfFX+iJ406kDa8Fcd84EdQzpMp
         uifw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722993229; x=1723598029;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SncexguTXxhTIz/tzcyB2li2hTXxyS0Ef5wbPXgVJAo=;
        b=ldzar4uPnMMJ3bu/dvly5TdaEBMmztcrUFFtiS7Wi1OO4tOf7jozA11Kt1GU8AgfJB
         /BmJfUYTz5inW0X8QB1aN8Nnl3WqRb56nBzOAc321Nu8Gr+GetGpLvUxvOzYnqYiyPl5
         YJwiAoPhXpzHnQitMeVKQ4ygzGwTCZ2byvML6Y9iZBYFcy9pQE52BTSPcDcntaun1POn
         ohKyqhRdsGj2v9dsRbYfd9+2N6wcWLca1mAJcvEnf223soMt9/ND6ox20AabP9HaGc49
         2497APX0SdzCzvh2IEd00BYj1/sXTdjs6HhiiQp0hX2T6G8Em6lnT6Hd5hH6KK+/Inse
         Be8A==
X-Gm-Message-State: AOJu0YwE3m1xTb1wgzE3LIzR8pEbxYehZTkrPJ+3dy6Aud76CNl+aLm6
	s1SHTxLITDdxdjRb0R9Baw7acTfpvcqpKxMeZfMb5uxh+UZYwVwskw/yz17qGjKXwtZjIcfVRyN
	5HOUvmLa3GsxvLOnrctKdssbZmNc=
X-Google-Smtp-Source: AGHT+IEaP8OXIhAEJboV8EmWHCRsCz13HsV01F2wNBvjcKYH25InmJnLL4Auc4jYRrtljXKj1PaXI2rIiEJl86dvbAM=
X-Received: by 2002:a05:6602:27cc:b0:803:83c0:6422 with SMTP id
 ca18e2360f4ac-81fd435a75bmr2312050939f.9.1722993228795; Tue, 06 Aug 2024
 18:13:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAEWy8SyOXqk+CYu_8HV-R_bRa8WRVYUu_DhU8=RfZevZZGMRHA@mail.gmail.com>
 <CAAMCDeeTZrP-VGz2sqaCS5JtETK0DHydXT0qwE=cbQ5eQDg1Dg@mail.gmail.com> <CAEWy8SwvaTd3WvD3rKn9dGkLozAOnZEjpMF09nhESd4KpYCbvQ@mail.gmail.com>
In-Reply-To: <CAEWy8SwvaTd3WvD3rKn9dGkLozAOnZEjpMF09nhESd4KpYCbvQ@mail.gmail.com>
From: Roger Heflin <rogerheflin@gmail.com>
Date: Tue, 6 Aug 2024 20:13:36 -0500
Message-ID: <CAAMCDec8F0CjT9Sz77uE7uVjN87YTbUPte5fY67_244gOfKTwA@mail.gmail.com>
Subject: Re: RAID missing post reboot
To: Ryan England <ryan.england@lambdal.com>
Cc: linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Those steps are generic and a suggestion, and some of those commands
if misused would produce this behavior.

You aren't doing any parted commands against /dev/nvme2n1p1 are you?
You are just running parted against /dev/nvme[01]n1 right?

You likely need to run history and dump the exact commands, when it
goes wrong showing someone the theoretical work instruction is not
that useful because if you are asking what went wrong then something
in that work instruction was not quite done right and/or
misunderstood.

On Tue, Aug 6, 2024 at 7:28=E2=80=AFPM Ryan England <ryan.england@lambdal.c=
om> wrote:
>
> Hello Roger,
>
> Thanks for the update. The process is almost exactly as follows. The only=
 difference is the command to create the array. I used mdadm --create /dev/=
md127 --level=3D5 --raid-devices=3D3 /dev/nvme0n1p1 /dev/nvme1n1p1 /dev/nvm=
e2n1p1.
>
> Regards,
> Ryan E.
>
>
> This would all be run as root or with sudo.
>
> IMPORTANT: (to confirm which drive is which)
>
>   lsblk
>
>     1. New drives will not be partitioned
>
>     2. Sizes can also be used to determine which drive
>
>        (we can use 'sudo smartctl -x /dev/nvme#' to see models, etc).
>
> NOTE: If using XFS, you need to install xfsprogs
>
>       sudo apt-get update && sudo apt-get install xfsprogs
>
>       You can use the more common ext4 also, it all depends on inode usag=
e concerns
>
>       performance is similar.
>
> To create raid 1 in live linux system
>
>   $ sudo parted -a optimal /dev/nvme1
>
>   $ sudo parted -a optimal /dev/nvme2
>
>   etc ...
>
>   And this will have options in the tool:
>
>   # Place a flag gpt or mbr
>
>   (parted) mklabel gpt
>
>   # Create partitions
>
>   (parted) mkpart primary ext4 0% 100%
>
>   # Mark partition as software raid partition
>
>   (parted) set 1 raid on
>
>   # Verify its alligned
>
>   (parted) align-check
>
>      optimal
>
>   # Show results
>
>   print
>
> then repeat for each drive...
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> RAID setup examples:
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> Raid 0 array
>
> mdadm --create /dev/md0 --level=3D0 --raid-devices=3D2 /dev/nvme1n1p1 /de=
v/nvme2n1p1
>
> Or for Raid 1 array (only 2+ drives but all mirrors)
>
> mdadm --create /dev/md0 --level=3D1 --raid-devices=3D2 --spare=3D0 /dev/n=
vme1n1p1 /dev/nvme2n1p1
>
> Check results
>
> cat /proc/mdstat
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> Format the filesystem: (performance about the same just # of files)
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> # Format array - similar performance but depending on usage of millions o=
f small files
>
> #             - you may hit inode issues
>
> $ sudo mkfs.ext4 /dev/md0
>
> or
>
> # Format for XFS: - handles larger numbers of files better (millions) no =
inode issues
>
> $ sudo mkfs.xfs /dev/md0
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
>
> Finish/check the Raid config
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
>
> # Write raid to a mdadm.conf
>
> $ sudo mdadm --detail --scan >> /etc/mdadm/mdadm.conf
>
> # Update initramfs
>
> $ sudo update-initramfs -u
>
> # Check the raid:
>
>  $ sudo mdadm -D /dev/md0
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> Mount and write to fstab
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> For example for a mount point of /data:
>
> $ sudo mkdir /data
>
> $ sudo chmod 1777 /data
>
> $ sudo mount /dev/md0 /data
>
> (And setup the /etc/fstab).
>
> # Find the UUID for the /dev/md0
>
> $ blkid /dev/md0
>
> # Add the md0's UUID to the /etc/fstab
>
> $ blkid /dev/md0
>
> /dev/md0: UUID=3D"a6d39b9b-d4e4-4fa1-b98c-4a73e7ba0f83" TYPE=3D"xfs"  (or=
 ext4)
>
> echo "# Add RAID md0 to mount on /data" | sudo tee -a /etc/fstab
>
> echo "UUID=3Da6d39b9b-d4e4-4fa1-b98c-4a73e7ba0f83 /data ext4 defaults,rel=
atime,rw 0 2" | sudo tee -a /etc/fstab
>
> or if you choose xfs:
>
> echo "# Add RAID md0 to mount on /data" >> /etc/fstab
>
> echo "UUID=3Da6d39b9b-d4e4-4fa1-b98c-4a73e7ba0f83 /data xfs defaults,disc=
ard,relatime,rw 0 2" | sudo tee -a /etc/fstab
>
> mount -a
>
>
>
> On Tue, Aug 6, 2024, 7:57=E2=80=AFPM Roger Heflin <rogerheflin@gmail.com>=
 wrote:
>>
>> Several of the parts are indicating that the partition has a partition
>> table on it.
>>
>> Both the examine and the wipefs show that.   The aa55 is a GPT
>> partition table and that WILL overwrite parts of the mdadm headers.
>>
>> What are the full steps that you are using to create the raid?
>>
>> On Tue, Aug 6, 2024 at 6:20=E2=80=AFPM Ryan England <ryan.england@lambda=
l.com> wrote:
>> >
>> > Hello everyone,
>> >
>> > I've been working on a system with a software RAID for the last couple
>> > of weeks. I ran through the process of creating the array as RAID5
>> > using /dev/nvme0n1p1, /dev/nvme1n1p1, and /dev/nvme2n1p1. I then
>> > create the filesystem, update mdadm.conf, and run update-initramfs -u.
>> >
>> > The array and file system are created successfully. It's created as
>> > /dev/md127. I mount it to the system and I can write data to it.
>> > /etc/fstab has also been updated.
>> >
>> > After rebooting the machine, the system enters Emergency Mode.
>> > Commenting out the newly created device and rebooting the machine
>> > brings it back to Emergency Mode. I can also skip EM by adding the
>> > nofail option to the mount point in /etc/fstab.
>> >
>> > Today, I walked through recreating the array. Once created, I ran
>> > mkfs.ext4 again. This time, I noticed that the command found an ext4
>> > file system. To try and repair it, I ran fsck -y against /dev/md127.
>> > The end of the fsck noted that a resize of the inode (re)creation
>> > failed: Inode checksum does not match inode. Mounting failed, so we
>> > made the filesystem again.
>> >
>> > It's worth noting that there's NO data on this array at this time.
>> > Hence why we were able to go through with making the filesystem again.
>> > I made sure to gather all of the info noted within the mdadm wiki and
>> > I've included that below. The only thing not included is mdadm
>> > --detail of each of the partitions because the system doesn't
>> > recognize them as being part of an md. Also, md0 hosts the root volume
>> > and isn't a part of the output below.
>> >
>> > As far as troubleshooting is concerned, I've tried the following:
>> > 1. mdadm --manage /dev/md127 --run
>> > 2. echo "clean" > /sys/block/md127/md/array_state & then run command 1
>> > 3. mdadm --assemble --force /dev/md127 /dev/nvme0n1p1 /dev/nvme1n1p1
>> > /dev/nvme2n1p1 & then run command 1
>> >
>> > I've also poured over logs. Once, I noticed that nvme2n1p1 wasn't
>> > being recognized as a part of the kernel logs. To rule that out as the
>> > issue, I created a RAID1 between nvme0n1p1 & nvme1n1p1. This still
>> > didn't work.
>> >
>> > Looking through journalctl -xb, I found an error noting a package that
>> > was missing. The package is named ibblockdev-mdraid2. Installing that
>> > package still didn't help.
>> >
>> > Lastly, I included the output of wipefs at the behest of a colleague.
>> > Any support you can provide will be greatly appreciated.
>> >
>> > Regards,
>> > Ryan E.
>> >
>> >
>> > ____________________________________________
>> >
>> > Start of the mdadm bug report log file.
>> >
>> > Date: Tue Aug  6 02:42:59 PM PDT 2024
>> > uname: Linux REDACTED 5.15.0-117-generic #127-Ubuntu SMP Fri Jul 5
>> > 20:13:28 UTC 2024 x86_64 x86_64 x86_64 GNU/Linux
>> > command line flags:
>> >
>> > ____________________________________________
>> >
>> > mdadm --version
>> >
>> > mdadm - v4.2 - 2021-12-30
>> >
>> > ____________________________________________
>> >
>> > cat /proc/mdstat
>> >
>> > Personalities : [raid1] [linear] [multipath] [raid0] [raid6] [raid5]
>> > [raid4] [raid10]
>> > md0 : active raid1 sdb2[1] sda2[0] 1874715648 blocks super 1.2 [2/2]
>> > [UU] bitmap: 8/14 pages [32KB], 65536KB chunk unused devices: <none>
>> >
>> > ____________________________________________
>> >
>> > mdadm --examine /dev/nvme0n1p1 /dev/nvme1n1p1 /dev/nvme2n1p1
>> >
>> > /dev/nvme0n1p1: MBR Magic : aa55 Partition[0] : 4294967295 sectors at
>> > 1 (type ee)
>> > /dev/nvme1n1p1: MBR Magic : aa55 Partition[0] : 4294967295 sectors at
>> > 1 (type ee)
>> > /dev/nvme2n1p1: MBR Magic : aa55 Partition[0] : 4294967295 sectors at
>> > 1 (type ee)
>> >
>> > ____________________________________________
>> >
>> > mdadm --detail /dev/nvme0n1p1 /dev/nvme1n1p1 /dev/nvme2n1p1
>> >
>> > mdadm: /dev/nvme0n1p1 does not appear to be an md device
>> > mdadm: /dev/nvme1n1p1 does not appear to be an md device
>> > mdadm: /dev/nvme2n1p1 does not appear to be an md device
>> >
>> > ____________________________________________
>> >
>> > smartctl --xall /dev/nvme0n1p1
>> >
>> > smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.15.0-117-generic] (local=
 build)
>> > Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmontool=
s.org
>> >
>> > =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
>> > Model Number:                       SAMSUNG MZQL23T8HCLS-00A07
>> > Serial Number:                      S64HNS0TC05245
>> > Firmware Version:                   GDC5602Q
>> > PCI Vendor/Subsystem ID:            0x144d
>> > IEEE OUI Identifier:                0x002538
>> > Total NVM Capacity:                 3,840,755,982,336 [3.84 TB]
>> > Unallocated NVM Capacity:           0
>> > Controller ID:                      6
>> > NVMe Version:                       1.4
>> > Number of Namespaces:               32
>> > Namespace 1 Size/Capacity:          3,840,755,982,336 [3.84 TB]
>> > Namespace 1 Utilization:            71,328,116,736 [71.3 GB]
>> > Namespace 1 Formatted LBA Size:     512
>> > Local Time is:                      Tue Aug  6 15:16:08 2024 PDT
>> > Firmware Updates (0x17):            3 Slots, Slot 1 R/O, no Reset requ=
ired
>> > Optional Admin Commands (0x005f):   Security Format Frmw_DL NS_Mngmt
>> > Self_Test MI_Snd/Rec
>> > Optional NVM Commands (0x005f):     Comp Wr_Unc DS_Mngmt Wr_Zero
>> > Sav/Sel_Feat Timestmp
>> > Log Page Attributes (0x0e):         Cmd_Eff_Lg Ext_Get_Lg Telmtry_Lg
>> > Maximum Data Transfer Size:         512 Pages
>> > Warning  Comp. Temp. Threshold:     80 Celsius
>> > Critical Comp. Temp. Threshold:     83 Celsius
>> > Namespace 1 Features (0x1a):        NA_Fields No_ID_Reuse NP_Fields
>> >
>> > Supported Power States
>> > St Op     Max   Active     Idle   RL RT WL WT  Ent_Lat  Ex_Lat
>> >  0 +    25.00W   14.00W       -    0  0  0  0       70      70
>> >  1 +     8.00W    8.00W       -    1  1  1  1       70      70
>> >
>> > Supported LBA Sizes (NSID 0x1)
>> > Id Fmt  Data  Metadt  Rel_Perf
>> >  0 +     512       0         0
>> >  1 -    4096       0         0
>> >
>> > =3D=3D=3D START OF SMART DATA SECTION =3D=3D=3D
>> > SMART overall-health self-assessment test result: PASSED
>> >
>> > SMART/Health Information (NVMe Log 0x02)
>> > Critical Warning:                   0x00
>> > Temperature:                        35 Celsius
>> > Available Spare:                    100%
>> > Available Spare Threshold:          10%
>> > Percentage Used:                    0%
>> > Data Units Read:                    31,574,989 [16.1 TB]
>> > Data Units Written:                 304,488 [155 GB]
>> > Host Read Commands:                 36,420,064
>> > Host Write Commands:                3,472,342
>> > Controller Busy Time:               63
>> > Power Cycles:                       11
>> > Power On Hours:                     5,582
>> > Unsafe Shutdowns:                   9
>> > Media and Data Integrity Errors:    0
>> > Error Information Log Entries:      0
>> > Warning  Comp. Temperature Time:    0
>> > Critical Comp. Temperature Time:    0
>> > Temperature Sensor 1:               35 Celsius
>> > Temperature Sensor 2:               44 Celsius
>> >
>> > Error Information (NVMe Log 0x01, 16 of 64 entries)
>> > No Errors Logged
>> >
>> > ____________________________________________
>> >
>> > smartctl --xall /dev/nvme1n1p1
>> >
>> > smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.15.0-117-generic] (local=
 build)
>> > Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmontool=
s.org
>> >
>> > =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
>> > Model Number:                       SAMSUNG MZQL23T8HCLS-00A07
>> > Serial Number:                      S64HNS0TC05241
>> > Firmware Version:                   GDC5602Q
>> > PCI Vendor/Subsystem ID:            0x144d
>> > IEEE OUI Identifier:                0x002538
>> > Total NVM Capacity:                 3,840,755,982,336 [3.84 TB]
>> > Unallocated NVM Capacity:           0
>> > Controller ID:                      6
>> > NVMe Version:                       1.4
>> > Number of Namespaces:               32
>> > Namespace 1 Size/Capacity:          3,840,755,982,336 [3.84 TB]
>> > Namespace 1 Utilization:            71,324,651,520 [71.3 GB]
>> > Namespace 1 Formatted LBA Size:     512
>> > Local Time is:                      Tue Aug  6 15:16:22 2024 PDT
>> > Firmware Updates (0x17):            3 Slots, Slot 1 R/O, no Reset requ=
ired
>> > Optional Admin Commands (0x005f):   Security Format Frmw_DL NS_Mngmt
>> > Self_Test MI_Snd/Rec
>> > Optional NVM Commands (0x005f):     Comp Wr_Unc DS_Mngmt Wr_Zero
>> > Sav/Sel_Feat Timestmp
>> > Log Page Attributes (0x0e):         Cmd_Eff_Lg Ext_Get_Lg Telmtry_Lg
>> > Maximum Data Transfer Size:         512 Pages
>> > Warning  Comp. Temp. Threshold:     80 Celsius
>> > Critical Comp. Temp. Threshold:     83 Celsius
>> > Namespace 1 Features (0x1a):        NA_Fields No_ID_Reuse NP_Fields
>> >
>> > Supported Power States
>> > St Op     Max   Active     Idle   RL RT WL WT  Ent_Lat  Ex_Lat
>> >  0 +    25.00W   14.00W       -    0  0  0  0       70      70
>> >  1 +     8.00W    8.00W       -    1  1  1  1       70      70
>> >
>> > Supported LBA Sizes (NSID 0x1)
>> > Id Fmt  Data  Metadt  Rel_Perf
>> >  0 +     512       0         0
>> >  1 -    4096       0         0
>> >
>> > =3D=3D=3D START OF SMART DATA SECTION =3D=3D=3D
>> > SMART overall-health self-assessment test result: PASSED
>> >
>> > SMART/Health Information (NVMe Log 0x02)
>> > Critical Warning:                   0x00
>> > Temperature:                        34 Celsius
>> > Available Spare:                    100%
>> > Available Spare Threshold:          10%
>> > Percentage Used:                    0%
>> > Data Units Read:                    24,073,787 [12.3 TB]
>> > Data Units Written:                 7,805,460 [3.99 TB]
>> > Host Read Commands:                 29,506,475
>> > Host Write Commands:                10,354,117
>> > Controller Busy Time:               64
>> > Power Cycles:                       11
>> > Power On Hours:                     5,582
>> > Unsafe Shutdowns:                   9
>> > Media and Data Integrity Errors:    0
>> > Error Information Log Entries:      0
>> > Warning  Comp. Temperature Time:    0
>> > Critical Comp. Temperature Time:    0
>> > Temperature Sensor 1:               34 Celsius
>> > Temperature Sensor 2:               44 Celsius
>> >
>> > Error Information (NVMe Log 0x01, 16 of 64 entries)
>> > No Errors Logged
>> >
>> > ____________________________________________
>> >
>> > smartctl --xall /dev/nvme2n1p1
>> >
>> > smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.15.0-117-generic] (local=
 build)
>> > Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmontool=
s.org
>> >
>> > =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
>> > Model Number:                       SAMSUNG MZQL23T8HCLS-00A07
>> > Serial Number:                      S64HNS0TC05244
>> > Firmware Version:                   GDC5602Q
>> > PCI Vendor/Subsystem ID:            0x144d
>> > IEEE OUI Identifier:                0x002538
>> > Total NVM Capacity:                 3,840,755,982,336 [3.84 TB]
>> > Unallocated NVM Capacity:           0
>> > Controller ID:                      6
>> > NVMe Version:                       1.4
>> > Number of Namespaces:               32
>> > Namespace 1 Size/Capacity:          3,840,755,982,336 [3.84 TB]
>> > Namespace 1 Utilization:            3,840,514,523,136 [3.84 TB]
>> > Namespace 1 Formatted LBA Size:     512
>> > Local Time is:                      Tue Aug  6 15:16:33 2024 PDT
>> > Firmware Updates (0x17):            3 Slots, Slot 1 R/O, no Reset requ=
ired
>> > Optional Admin Commands (0x005f):   Security Format Frmw_DL NS_Mngmt
>> > Self_Test MI_Snd/Rec
>> > Optional NVM Commands (0x005f):     Comp Wr_Unc DS_Mngmt Wr_Zero
>> > Sav/Sel_Feat Timestmp
>> > Log Page Attributes (0x0e):         Cmd_Eff_Lg Ext_Get_Lg Telmtry_Lg
>> > Maximum Data Transfer Size:         512 Pages
>> > Warning  Comp. Temp. Threshold:     80 Celsius
>> > Critical Comp. Temp. Threshold:     83 Celsius
>> > Namespace 1 Features (0x1a):        NA_Fields No_ID_Reuse NP_Fields
>> >
>> > Supported Power States
>> > St Op     Max   Active     Idle   RL RT WL WT  Ent_Lat  Ex_Lat
>> >  0 +    25.00W   14.00W       -    0  0  0  0       70      70
>> >  1 +     8.00W    8.00W       -    1  1  1  1       70      70
>> >
>> > Supported LBA Sizes (NSID 0x1)
>> > Id Fmt  Data  Metadt  Rel_Perf
>> >  0 +     512       0         0
>> >  1 -    4096       0         0
>> >
>> > =3D=3D=3D START OF SMART DATA SECTION =3D=3D=3D
>> > SMART overall-health self-assessment test result: PASSED
>> >
>> > SMART/Health Information (NVMe Log 0x02)
>> > Critical Warning:                   0x00
>> > Temperature:                        33 Celsius
>> > Available Spare:                    100%
>> > Available Spare Threshold:          10%
>> > Percentage Used:                    0%
>> > Data Units Read:                    33,340 [17.0 GB]
>> > Data Units Written:                 24,215,921 [12.3 TB]
>> > Host Read Commands:                 812,460
>> > Host Write Commands:                31,463,496
>> > Controller Busy Time:               50
>> > Power Cycles:                       12
>> > Power On Hours:                     5,582
>> > Unsafe Shutdowns:                   9
>> > Media and Data Integrity Errors:    0
>> > Error Information Log Entries:      0
>> > Warning  Comp. Temperature Time:    0
>> > Critical Comp. Temperature Time:    0
>> > Temperature Sensor 1:               33 Celsius
>> > Temperature Sensor 2:               42 Celsius
>> >
>> > Error Information (NVMe Log 0x01, 16 of 64 entries)
>> > No Errors Logged
>> >
>> > ____________________________________________
>> >
>> > lsdrv
>> >
>> > PCI [nvme] 22:00.0 Non-Volatile memory controller: Samsung Electronics
>> > Co Ltd NVMe SSD Controller PM9A1/PM9A3/980PRO
>> > =E2=94=94nvme nvme0 SAMSUNG MZQL23T8HCLS-00A07               {S64HNS0T=
C05245}
>> >  =E2=94=94nvme0n1 3.49t [259:0] Partitioned (gpt)
>> >   =E2=94=94nvme0n1p1 3.49t [259:1] Partitioned (gpt)
>> > PCI [nvme] 23:00.0 Non-Volatile memory controller: Samsung Electronics
>> > Co Ltd NVMe SSD Controller PM9A1/PM9A3/980PRO
>> > =E2=94=94nvme nvme1 SAMSUNG MZQL23T8HCLS-00A07               {S64HNS0T=
C05241}
>> >  =E2=94=94nvme1n1 3.49t [259:2] Partitioned (gpt)
>> >   =E2=94=94nvme1n1p1 3.49t [259:3] Partitioned (gpt)
>> > PCI [nvme] 24:00.0 Non-Volatile memory controller: Samsung Electronics
>> > Co Ltd NVMe SSD Controller PM9A1/PM9A3/980PRO
>> > =E2=94=94nvme nvme2 SAMSUNG MZQL23T8HCLS-00A07               {S64HNS0T=
C05244}
>> >  =E2=94=94nvme2n1 3.49t [259:4] Partitioned (gpt)
>> >   =E2=94=94nvme2n1p1 3.49t [259:5] Partitioned (gpt)
>> > PCI [ahci] 64:00.0 SATA controller: ASMedia Technology Inc. ASM1062
>> > Serial ATA Controller (rev 02)
>> > =E2=94=9Cscsi 0:0:0:0 ATA      SAMSUNG MZ7L31T9 {S6ESNS0W416204}
>> > =E2=94=82=E2=94=94sda 1.75t [8:0] Partitioned (gpt)
>> > =E2=94=82 =E2=94=9Csda1 512.00m [8:1] vfat {B0FD-2869}
>> > =E2=94=82 =E2=94=82=E2=94=94Mounted as /dev/sda1 @ /boot/efi
>> > =E2=94=82 =E2=94=94sda2 1.75t [8:2] MD raid1 (0/2) (w/ sdb2) in_sync '=
ubuntu-server:0'
>> > {2bcfa20a-e221-299c-d3e6-f4cf8124e265}
>> > =E2=94=82  =E2=94=94md0 1.75t [9:0] MD v1.2 raid1 (2) active
>> > {2bcfa20a:-e221-29:9c-d3e6-:f4cf8124e265}
>> > =E2=94=82   =E2=94=82               Partitioned (gpt)
>> > =E2=94=82   =E2=94=94md0p1 1.75t [259:6] ext4 {81b5ccee-9c72-4cac-8579=
-3b9627a8c1b6}
>> > =E2=94=82    =E2=94=94Mounted as /dev/md0p1 @ /
>> > =E2=94=94scsi 1:0:0:0 ATA      SAMSUNG MZ7L31T9 {S6ESNS0W416208}
>> >  =E2=94=94sdb 1.75t [8:16] Partitioned (gpt)
>> >   =E2=94=9Csdb1 512.00m [8:17] vfat {B11F-39A7}
>> >   =E2=94=94sdb2 1.75t [8:18] MD raid1 (1/2) (w/ sda2) in_sync
>> > 'ubuntu-server:0' {2bcfa20a-e221-299c-d3e6-f4cf8124e265}
>> >    =E2=94=94md0 1.75t [9:0] MD v1.2 raid1 (2) active
>> > {2bcfa20a:-e221-29:9c-d3e6-:f4cf8124e265}
>> >                     Partitioned (gpt)
>> > PCI [ahci] 66:00.0 SATA controller: Advanced Micro Devices, Inc. [AMD]
>> > FCH SATA Controller [AHCI mode] (rev 91)
>> > =E2=94=94scsi 2:x:x:x [Empty]
>> > PCI [ahci] 66:00.1 SATA controller: Advanced Micro Devices, Inc. [AMD]
>> > FCH SATA Controller [AHCI mode] (rev 91)
>> > =E2=94=94scsi 10:x:x:x [Empty]
>> > PCI [ahci] 04:00.0 SATA controller: Advanced Micro Devices, Inc. [AMD]
>> > FCH SATA Controller [AHCI mode] (rev 91)
>> > =E2=94=94scsi 18:x:x:x [Empty]
>> > PCI [ahci] 04:00.1 SATA controller: Advanced Micro Devices, Inc. [AMD]
>> > FCH SATA Controller [AHCI mode] (rev 91)
>> > =E2=94=94scsi 26:x:x:x [Empty]
>> > Other Block Devices
>> > =E2=94=9Cloop0 0.00k [7:0] Empty/Unknown
>> > =E2=94=9Cloop1 0.00k [7:1] Empty/Unknown
>> > =E2=94=9Cloop2 0.00k [7:2] Empty/Unknown
>> > =E2=94=9Cloop3 0.00k [7:3] Empty/Unknown
>> > =E2=94=9Cloop4 0.00k [7:4] Empty/Unknown
>> > =E2=94=9Cloop5 0.00k [7:5] Empty/Unknown
>> > =E2=94=9Cloop6 0.00k [7:6] Empty/Unknown
>> > =E2=94=94loop7 0.00k [7:7] Empty/Unknown
>> >
>> > ____________________________________________
>> >
>> > wipefs /dev/nvme0n1p1
>> >
>> > DEVICE    OFFSET        TYPE UUID LABEL
>> > nvme0n1p1 0x200         gpt
>> > nvme0n1p1 0x37e38900000 gpt
>> > nvme0n1p1 0x1fe         PMBR
>> >
>> > ____________________________________________
>> >
>> > wipefs /dev/nvme1n1p1
>> >
>> > DEVICE    OFFSET        TYPE UUID LABEL
>> > nvme1n1p1 0x200         gpt
>> > nvme1n1p1 0x37e38900000 gpt
>> > nvme1n1p1 0x1fe         PMBR
>> >
>> > ____________________________________________
>> >
>> > wipefs /dev/nvme2n1p1
>> >
>> > DEVICE    OFFSET        TYPE UUID LABEL
>> > nvme2n1p1 0x200         gpt
>> > nvme2n1p1 0x37e38900000 gpt
>> > nvme2n1p1 0x1fe         PMBR
>> >
