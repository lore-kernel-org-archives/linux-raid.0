Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E8A34DA02
	for <linux-raid@vger.kernel.org>; Fri,  1 Mar 2024 16:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709310459; cv=none; b=qFdfw3aKQYRrzkeolAxrH00TctQDYRWDAjCDu3Gr7kYOCREwKb/mZDng/JL+WRkqzfDFYhro5UBWxaE9TUk7RsSlPjwM9sqLkSfnZ0oU9xn1B0R1FgRVj+Rl8CaoX7USMh0lSamT0UbYxOWCJfvpdIishmLGRGvsggD2z7LElGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709310459; c=relaxed/simple;
	bh=wMz/FtYd5aSkJG/5yRHAIM7wrkFgLUm6We7GTDoi2xk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=k6mEDH8Jr614z95V5tdxvP6Av6mmRnOPHzbr5ybiBdfBJAktQez413pmAR7PZnJdnXOt8nmjiHklWT3rjjIDVLD6griOZ9QS8aPKNAGssmDilgzSpt6ge3VQitAdL7ujti47pVFNoypxp5bhT+mPbALULDwED1wJGAAXNIarxYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cDfAXWH2; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cDfAXWH2"
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-7c7b9b25ba6so106467939f.1
        for <linux-raid@vger.kernel.org>; Fri, 01 Mar 2024 08:27:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709310456; x=1709915256; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+Oxv0Y4zLrWN+WfHqEIuarcc2lrG4s2auBg0otZxmXw=;
        b=cDfAXWH2CjZV07J+RxCSJ9pUMzM6TtRlUSSaLfsZqhdN4i423y2LVqGji3/W5fngSE
         I9402nOE3HSGjGLhV+gluoRxEcEfiTJO/02yoXoNXFPTgswOrH2tOQ3RzQF1iN1hnOty
         ujKUw5bXGREzfJrqcZL0YvbLN7kZ+IZPs3ywaEenWE8Dsa0O0KcVWWDu1ufMPEBHdnhb
         kUPQeCaYZlC230V1l4+x/49Naj5sukLJKsq5bTZkwclA93Az3nduvniq9WPQ7dkJVXJu
         WsVo3mN7dX08FTyLDdSthsI6r00GOTJ29qCjfuolbrm/j6dJXnHqx1BCofnRLehgZHYq
         eD1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709310456; x=1709915256;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+Oxv0Y4zLrWN+WfHqEIuarcc2lrG4s2auBg0otZxmXw=;
        b=dwz6OIspFaze7P66zqD5AUwYVPGzRV24rQpjcZ7L4BUBX+Ecw187Zw2QUPSnG7yVTl
         CL08MwqG8ed1O5s1UV9sYYFcvpKSu48tvBNG3WgkN5lZ2Rw4bSVKSm0yOz6WFh7Pk6Xo
         eE/vj097oADp2UDxjwLx7+punY6gFaPMfjaEZB+4mYUq6gBoW5wSWu8P8rOUuYPrNMtp
         YVdCA9zb9pNew0yxcr5xptRi9/7agsNY25WwHBGa//tjFyznqbCzIR+zlQ+1OXqJLh1N
         12KKKPQDc9sz5HedeNotuPYd81CvMf29LUiOCGzDcLY+KExynmrX1PM6slo8c+wHs5gM
         TZcg==
X-Gm-Message-State: AOJu0Yx+tByhqzo7sAf7wW9vcSS1EGeRO+0Af/v3wZBk6sRfHn0RoJs8
	JJ07xJnWgjG70vJ74xpm0bYVdAW2vHwzqA7G6sLy6TcaLI+6LfRJEAgFTL3dvqWvAavNKoEr5TE
	3yuTZEdl5xNEdirZ/HpSDcF0VJVS4xih62Uw=
X-Google-Smtp-Source: AGHT+IGSwZi62raOUK0r2eV9VDLgd6zkrB5nL/6wP+C5jrLlXXmTS0q2xSe5NoRRt3SEcchB4+10W2PNbXIWFUFeeYI=
X-Received: by 2002:a05:6602:19d9:b0:7c7:b1e4:50b with SMTP id
 ba25-20020a05660219d900b007c7b1e4050bmr2273173iob.13.1709310456450; Fri, 01
 Mar 2024 08:27:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CADC_b1dj8AodZxYF0tLPnfv0S3xHGnCBVOmvWgyCZt4LqHze=w@mail.gmail.com>
In-Reply-To: <CADC_b1dj8AodZxYF0tLPnfv0S3xHGnCBVOmvWgyCZt4LqHze=w@mail.gmail.com>
From: Roger Heflin <rogerheflin@gmail.com>
Date: Fri, 1 Mar 2024 10:27:25 -0600
Message-ID: <CAAMCDecAJ4QP29v_Qgv4xi8vNL-RWEB+v_HMkAtY2Z3rk9zKZw@mail.gmail.com>
Subject: Re: Requesting help with raid6 that stays inactive
To: Topi Viljanen <tovi@iki.fi>
Cc: linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

If you are using /dev/sd[a-h] directly without partitions then you
should not have partition tables on the devices.  Your results
indicate that there are partitions tables (the existence of the
sd[a-h]1 devices and the MBR magic.

Do "fdisk -l /dev/sd[a-h]", given 4tb devices they are probably GPT partiti=
ons.

If they are GPT partitions more data gets overwritten and can cause
limited data loss.   Given these are 4tb disks I am going to suspect
these are GPT partitions.

Do not recreate the array, to do that you must have the correct device
order and all other parameters for the raid correct.

You will also need to determine how/what created the partitions.
There are reports that some motherboards will "fix" disks without a
partition table.  if you dual boot into windows I believe it also
wants to "fix" it.

Read this doc that is written about how to recover, it has
instructions of how to create overlays and those overlays allow you to
test the different possible order/parameters without writing to the
array until you figure out the right combination.
https://raid.wiki.kernel.org/index.php/RAID_Recovery

Because of these issues and other issues it is always best to use
partition tables on the disks.

On Fri, Mar 1, 2024 at 9:46=E2=80=AFAM Topi Viljanen <tovi@iki.fi> wrote:
>
> Hi,
>
> I have an RAID 6 array that is not having its 6 disks activated. Now
> after reading more instructions it's clear that using webmin to create
> RAID devices is a bad thing. You end up using the whole disk instead
> of partitions of them.
>
> All 6 disks should be ok and data should be clean. The array broke
> after I moved the server to another location (sata cables might be in
> different order etc). The original reason for the changes was an USB
> drive that broke up... yep, there were the backups. That broken disk
> was in fstab and therefore ubuntu went to recovery mode (since disk
> was not available). So backups are now kind of broken too.
>
>
> Autodiscovery does find the array:
> RAID level - RAID6 (Dual Distributed Parity)
> Filesystem status - Inactive and not mounted
>
>
> Here's report from mdadm examine:
>
> $ sudo mdadm --examine /dev/sd[c,b,d,e,f,g]
> /dev/sdc:
> Magic : a92b4efc
> Version : 1.2
> Feature Map : 0x1
> Array UUID : 2bf6381b:fe19bdd4:9cc53ae7:5dce1630
> Name : NAS-ubuntu:0
> Creation Time : Thu May 18 22:56:47 2017
> Raid Level : raid6
> Raid Devices : 6
>
> Avail Dev Size : 7813782192 sectors (3.64 TiB 4.00 TB)
> Array Size : 15627548672 KiB (14.55 TiB 16.00 TB)
> Used Dev Size : 7813774336 sectors (3.64 TiB 4.00 TB)
> Data Offset : 254976 sectors
> Super Offset : 8 sectors
> Unused Space : before=3D254896 sectors, after=3D7856 sectors
> State : clean
> Device UUID : b944e546:6c1c3cf9:b3c6294a:effa679a
>
> Internal Bitmap : 8 sectors from superblock
> Update Time : Wed Feb 28 19:10:03 2024
> Bad Block Log : 512 entries available at offset 24 sectors
> Checksum : 4a9db132 - correct
> Events : 477468
>
> Layout : left-symmetric
> Chunk Size : 512K
>
> Device Role : Active device 5
> Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D r=
eplacing)
> /dev/sdb:
> MBR Magic : aa55
> Partition[0] : 4294967295 sectors at 1 (type ee)
> /dev/sdd:
> MBR Magic : aa55
> Partition[0] : 4294967295 sectors at 1 (type ee)
> /dev/sde:
> MBR Magic : aa55
> Partition[0] : 4294967295 sectors at 1 (type ee)
> /dev/sdf:
> MBR Magic : aa55
> Partition[0] : 4294967295 sectors at 1 (type ee)
> /dev/sdg:
> MBR Magic : aa55
> Partition[0] : 4294967295 sectors at 1 (type ee)
>
>
>
>
> Since the disks have been used instead of partitions I'm now getting
> an error when trying to assemble:
>
> $ sudo mdadm --assemble /dev/md0 /dev/sdc /dev/sdb /dev/sdd /dev/sde
> /dev/sdf /dev/sdg
> mdadm: No super block found on /dev/sdb (Expected magic a92b4efc, got 000=
00000)
> mdadm: no RAID superblock on /dev/sdb
> mdadm: /dev/sdb has no superblock - assembly aborted
>
> $ sudo mdadm --assemble --force /dev/md0 /dev/sdb /dev/sdc /dev/sdd
> /dev/sde /dev/sdf /dev/sdg
> mdadm: Cannot assemble mbr metadata on /dev/sdb
> mdadm: /dev/sdb has no superblock - assembly aborted
>
>
> Should I try to re-create that array again or how can I activate it
> properly? It seems that only 1 disk reports the array information
> correctly.
>
>
> ls /dev/sd*
> /dev/sda /dev/sda1 /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf
> /dev/sdg /dev/sdh /dev/sdh1
>
> All disks should be fine. I have setup a warning if any device fails
> in the array and there have been no warnings. Also SMART data shows ok
> for all disks.
>
>
> Basic info:
>
> $uname -a
> Linux NAS-server 5.15.0-97-generic #107-Ubuntu SMP Wed Feb 7 13:26:48
> UTC 2024 x86_64 x86_64 x86_64 GNU/Linux
>
> $mdadm --version
> mdadm - v4.2 - 2021-12-30
>
> $ sudo mdadm --detail /dev/md0
> /dev/md0:
> Version : 1.2
> Raid Level : raid6
> Total Devices : 1
> Persistence : Superblock is persistent
>
> State : inactive
> Working Devices : 1
>
> Name : NAS-ubuntu:0
> UUID : 2bf6381b:fe19bdd4:9cc53ae7:5dce1630
> Events : 477468
>
> Number Major Minor RaidDevice
> - 8 32 - /dev/sdc
>
>
> So what should I do next?
> I have not run the --create --assume-clean yet but could that help in thi=
s case?
>
> Thanks for any help.
>
> Best regards,
> Topi Viljanen
>
