Received: from meesny.iki.fi (meesny.iki.fi [195.140.195.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABF951798F
	for <linux-raid@vger.kernel.org>; Fri,  1 Mar 2024 17:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=195.140.195.201
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709315721; cv=pass; b=oRB4QkJrDpOeEJh3SaIqOxr/73rlo8OZBxh3y9oQ2X26EOcyJqJeOxCUzhqnnkptZT8aq9Rc/s1oTfhVnOjkQ20TSwByJgy1nyO8NPC6SnysxG8SbOFeTuaU4Y2QtRnVWZ4Qm6+vTurBpgNThkV3lBsAw8gJdnnoFl3QPJc64wQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709315721; c=relaxed/simple;
	bh=lHKLMUdopk8oRLJZWJPnmjBpSCXxBwa/FBE6bdKVy/Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=luxs6O36dDCrFk1/o8tu3JrewGvEu/xbFPxijTuIJ008GokZDTLwolvSXE5zFsOIjnWAohH8fyzOQYIvnAQbgByMnlpOXS/tuEyG664tlmWI22oYpZ+JMFLSwO9rPlUn45skxqCrSKwb+PYR6+MLuZQL0NWsX/OjNJ7efu7W3ho=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi; spf=pass smtp.mailfrom=iki.fi; dkim=pass (1024-bit key) header.d=iki.fi header.i=@iki.fi header.b=HRXR3sly; arc=pass smtp.client-ip=195.140.195.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iki.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=iki.fi header.i=@iki.fi header.b="HRXR3sly"
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: tovi)
	by meesny.iki.fi (Postfix) with ESMTPSA id 4TmbN41ZWczyVk
	for <linux-raid@vger.kernel.org>; Fri,  1 Mar 2024 19:55:16 +0200 (EET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=meesny;
	t=1709315716;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YR0Rm7av62AFAVfaWJl7HfP5LbaJzLsfGjSRI09T1Q4=;
	b=HRXR3slyL6suiXB9VZTlZKma9SStQWTYCVDGtllGG8wr2Dnb0lMQyMPZ17CjXk1Ot9fdBq
	+LcQiSuN+8gSsZb7BV3CGnzRgE1MSSkgICfg2wwyTUnV3CGULbUANIuORhLzsx2tAFD0yb
	Uj09gmWiJp+FZPpnPg6LrjViXqNdOk8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
	s=meesny; t=1709315716;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YR0Rm7av62AFAVfaWJl7HfP5LbaJzLsfGjSRI09T1Q4=;
	b=XVaq1+p61Ja/03XL8HHrfkFM2Bfthm/qFMDbIRkA9o8RitroM7v05LjzkgxLEM/So2EVwz
	CpKLKmnqg2unb/6C/+BTZpH29keGE0sZ7qY7ST13ThQqZ2n4ltsSqyJiX1TzaE3z1vGT0h
	1FmWDGfrh04re15p1PiylTk6LWVkudc=
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=tovi smtp.mailfrom=tovi@iki.fi
ARC-Seal: i=1; s=meesny; d=iki.fi; t=1709315716; a=rsa-sha256; cv=none;
	b=DAC64ulsAADFUjirsjAROf4BC1yBQj1e62CfgVEO7KUjuoNnxzI9Z8QO2wXSOvwHoeU+Hw
	z2uh6ha7tBS3mDRuH7Xo6LzcWftd0Nt+ZOhG8v8vA9OVBQwgeajZezzl4syrFRYjbufWes
	mGtn+6wG5GZTeOsQRHFG6Y+y4kkAqhA=
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-29954bb87b4so1779247a91.2
        for <linux-raid@vger.kernel.org>; Fri, 01 Mar 2024 09:55:15 -0800 (PST)
X-Gm-Message-State: AOJu0YyVz1x5JRhHhHWe4i1CTlXBVyFQEsIhhonDFD/Q0DWjlgwwNN5l
	YpgSHzdsKa5fJeUr+vexRk+jKGPvr7x+Ths/3Ut7D0xk6phndLDkkYZDwbKqSOrSmGFW45C3KeE
	V+EtkzzAYCOPb+FQgwjE7hv0WIlw=
X-Google-Smtp-Source: AGHT+IHokmErWDNLFGoTolntrpB3BDPNCxOOaQH1R9d9riaNqYr6Hphdk6xVZ712ZdDCIaXfcbKVAe62aC7dlnjEeWU=
X-Received: by 2002:a17:90b:b04:b0:29a:c89a:bcdb with SMTP id
 bf4-20020a17090b0b0400b0029ac89abcdbmr2016729pjb.46.1709315714290; Fri, 01
 Mar 2024 09:55:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CADC_b1dj8AodZxYF0tLPnfv0S3xHGnCBVOmvWgyCZt4LqHze=w@mail.gmail.com>
 <CAAMCDecAJ4QP29v_Qgv4xi8vNL-RWEB+v_HMkAtY2Z3rk9zKZw@mail.gmail.com>
In-Reply-To: <CAAMCDecAJ4QP29v_Qgv4xi8vNL-RWEB+v_HMkAtY2Z3rk9zKZw@mail.gmail.com>
From: Topi Viljanen <tovi@iki.fi>
Date: Fri, 1 Mar 2024 19:55:02 +0200
X-Gmail-Original-Message-ID: <CADC_b1d-w5Hu0jfrLXz80OD+gK9b7JEps-UHE8TputL2QGHBqg@mail.gmail.com>
Message-ID: <CADC_b1d-w5Hu0jfrLXz80OD+gK9b7JEps-UHE8TputL2QGHBqg@mail.gmail.com>
Subject: Re: Requesting help with raid6 that stays inactive
To: Roger Heflin <rogerheflin@gmail.com>
Cc: linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Roger,

Thank you for the support. I did try those disks on a different system
and I believe I used live Ubuntu. Well, all but one. The one that has
the partition table untouched. That explains why this setup broke.

I have now created overlays with this guide:
https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID#Ma=
king_the_harddisks_read-only_using_an_overlay_file

Did I understand correctly that now I can try to create the raid with
that --create --assume-clean and using those /dev/mapper/sd* files?
So testing different disk orders until I get them right and data back?
After fail #1,#2,#3... I just revert the files back to beginning and
try the next combination?

When I created the raid originally I took a note:

RAID device options
Device file /dev/md0
UUID 2bf6381b:fe19bdd4:9cc53ae7:5dce1630
RAID level RAID6 (Dual Distributed Parity)
Filesystem status Mounted on /mnt/raid6
Usable size 15627548672 blocks (14.55 TiB)
Persistent superblock? Yes
Layout left-symmetric
Chunk size 512 kB
RAID status clean
Partitions in RAID
SATA device B
SATA device C
SATA device D
SATA device E
SATA device F
SATA device G

From that I can get Chunk size, Layout and Persistent superblock
values correctly. The only thing I need to guess is that device order,
right?


Assemble does not work:
root@NAS-server:~# dmsetup status
sdb: 0 7814037168 snapshot 16/8388608000 16
sdc: 0 7814037168 snapshot 16/8388608000 16
sdd: 0 7814037168 snapshot 16/8388608000 16
sde: 0 7814037168 snapshot 16/8388608000 16
sdf: 0 7814037168 snapshot 16/8388608000 16
sdg: 0 7814037168 snapshot 16/8388608000 16

root@NAS-server:~# mdadm --assemble --force /dev/md1 $OVERLAYS
mdadm: Cannot assemble mbr metadata on /dev/mapper/sdb
mdadm: /dev/mapper/sdb has no superblock - assembly aborted


And fdisk -l outputs:

root@NAS-server:~# fdisk -l /dev/mapper/sdb
Disk /dev/mapper/sdb: 3,64 TiB, 4000787030016 bytes, 7814037168 sectors
Units: sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: gpt
Disk identifier: B109E97B-5003-4FEF-A5E7-F64D33A3433D

root@NAS-server:~# fdisk -l /dev/mapper/sdc
Disk /dev/mapper/sdc: 3,64 TiB, 4000787030016 bytes, 7814037168 sectors
Units: sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: gpt
Disk identifier: E2D462E1-FBED-4A9C-8E8E-10A6737F2C92

root@NAS-server:~# fdisk -l /dev/mapper/sdd
Disk /dev/mapper/sdd: 3,64 TiB, 4000787030016 bytes, 7814037168 sectors
Units: sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: gpt
Disk identifier: D97186ED-CDFB-43FA-AF17-E5D172C4DAF5

root@NAS-server:~# fdisk -l /dev/mapper/sde
Disk /dev/mapper/sde: 3,64 TiB, 4000787030016 bytes, 7814037168 sectors
Units: sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: gpt
Disk identifier: 12092A2F-FAF7-4A1D-B979-8E5023D44572

root@NAS-server:~# fdisk -l /dev/mapper/sdf
Disk /dev/mapper/sdf: 3,64 TiB, 4000787030016 bytes, 7814037168 sectors
Units: sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: gpt
Disk identifier: 6E5AE89B-1BA3-4261-A5CC-7AB4004E5477

root@NAS-server:~# fdisk -l /dev/mapper/sdg
GPT PMBR size mismatch (976754645 !=3D 7814037167) will be corrected by wri=
te.
Disk /dev/mapper/sdg: 3,64 TiB, 4000787030016 bytes, 7814037168 sectors
Units: sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: dos
Disk identifier: 0x07ffeeb1

Device                Boot Start        End    Sectors Size Id Type
/dev/mapper/sdg-part1          1 4294967295 4294967295   2T ee GPT

Partition 1 does not start on physical sector boundary.


Thanks,
Topi Viljanen

On Fri, 1 Mar 2024 at 18:27, Roger Heflin <rogerheflin@gmail.com> wrote:
>
> If you are using /dev/sd[a-h] directly without partitions then you
> should not have partition tables on the devices.  Your results
> indicate that there are partitions tables (the existence of the
> sd[a-h]1 devices and the MBR magic.
>
> Do "fdisk -l /dev/sd[a-h]", given 4tb devices they are probably GPT parti=
tions.
>
> If they are GPT partitions more data gets overwritten and can cause
> limited data loss.   Given these are 4tb disks I am going to suspect
> these are GPT partitions.
>
> Do not recreate the array, to do that you must have the correct device
> order and all other parameters for the raid correct.
>
> You will also need to determine how/what created the partitions.
> There are reports that some motherboards will "fix" disks without a
> partition table.  if you dual boot into windows I believe it also
> wants to "fix" it.
>
> Read this doc that is written about how to recover, it has
> instructions of how to create overlays and those overlays allow you to
> test the different possible order/parameters without writing to the
> array until you figure out the right combination.
> https://raid.wiki.kernel.org/index.php/RAID_Recovery
>
> Because of these issues and other issues it is always best to use
> partition tables on the disks.
>
> On Fri, Mar 1, 2024 at 9:46=E2=80=AFAM Topi Viljanen <tovi@iki.fi> wrote:
> >
> > Hi,
> >
> > I have an RAID 6 array that is not having its 6 disks activated. Now
> > after reading more instructions it's clear that using webmin to create
> > RAID devices is a bad thing. You end up using the whole disk instead
> > of partitions of them.
> >
> > All 6 disks should be ok and data should be clean. The array broke
> > after I moved the server to another location (sata cables might be in
> > different order etc). The original reason for the changes was an USB
> > drive that broke up... yep, there were the backups. That broken disk
> > was in fstab and therefore ubuntu went to recovery mode (since disk
> > was not available). So backups are now kind of broken too.
> >
> >
> > Autodiscovery does find the array:
> > RAID level - RAID6 (Dual Distributed Parity)
> > Filesystem status - Inactive and not mounted
> >
> >
> > Here's report from mdadm examine:
> >
> > $ sudo mdadm --examine /dev/sd[c,b,d,e,f,g]
> > /dev/sdc:
> > Magic : a92b4efc
> > Version : 1.2
> > Feature Map : 0x1
> > Array UUID : 2bf6381b:fe19bdd4:9cc53ae7:5dce1630
> > Name : NAS-ubuntu:0
> > Creation Time : Thu May 18 22:56:47 2017
> > Raid Level : raid6
> > Raid Devices : 6
> >
> > Avail Dev Size : 7813782192 sectors (3.64 TiB 4.00 TB)
> > Array Size : 15627548672 KiB (14.55 TiB 16.00 TB)
> > Used Dev Size : 7813774336 sectors (3.64 TiB 4.00 TB)
> > Data Offset : 254976 sectors
> > Super Offset : 8 sectors
> > Unused Space : before=3D254896 sectors, after=3D7856 sectors
> > State : clean
> > Device UUID : b944e546:6c1c3cf9:b3c6294a:effa679a
> >
> > Internal Bitmap : 8 sectors from superblock
> > Update Time : Wed Feb 28 19:10:03 2024
> > Bad Block Log : 512 entries available at offset 24 sectors
> > Checksum : 4a9db132 - correct
> > Events : 477468
> >
> > Layout : left-symmetric
> > Chunk Size : 512K
> >
> > Device Role : Active device 5
> > Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)
> > /dev/sdb:
> > MBR Magic : aa55
> > Partition[0] : 4294967295 sectors at 1 (type ee)
> > /dev/sdd:
> > MBR Magic : aa55
> > Partition[0] : 4294967295 sectors at 1 (type ee)
> > /dev/sde:
> > MBR Magic : aa55
> > Partition[0] : 4294967295 sectors at 1 (type ee)
> > /dev/sdf:
> > MBR Magic : aa55
> > Partition[0] : 4294967295 sectors at 1 (type ee)
> > /dev/sdg:
> > MBR Magic : aa55
> > Partition[0] : 4294967295 sectors at 1 (type ee)
> >
> >
> >
> >
> > Since the disks have been used instead of partitions I'm now getting
> > an error when trying to assemble:
> >
> > $ sudo mdadm --assemble /dev/md0 /dev/sdc /dev/sdb /dev/sdd /dev/sde
> > /dev/sdf /dev/sdg
> > mdadm: No super block found on /dev/sdb (Expected magic a92b4efc, got 0=
0000000)
> > mdadm: no RAID superblock on /dev/sdb
> > mdadm: /dev/sdb has no superblock - assembly aborted
> >
> > $ sudo mdadm --assemble --force /dev/md0 /dev/sdb /dev/sdc /dev/sdd
> > /dev/sde /dev/sdf /dev/sdg
> > mdadm: Cannot assemble mbr metadata on /dev/sdb
> > mdadm: /dev/sdb has no superblock - assembly aborted
> >
> >
> > Should I try to re-create that array again or how can I activate it
> > properly? It seems that only 1 disk reports the array information
> > correctly.
> >
> >
> > ls /dev/sd*
> > /dev/sda /dev/sda1 /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf
> > /dev/sdg /dev/sdh /dev/sdh1
> >
> > All disks should be fine. I have setup a warning if any device fails
> > in the array and there have been no warnings. Also SMART data shows ok
> > for all disks.
> >
> >
> > Basic info:
> >
> > $uname -a
> > Linux NAS-server 5.15.0-97-generic #107-Ubuntu SMP Wed Feb 7 13:26:48
> > UTC 2024 x86_64 x86_64 x86_64 GNU/Linux
> >
> > $mdadm --version
> > mdadm - v4.2 - 2021-12-30
> >
> > $ sudo mdadm --detail /dev/md0
> > /dev/md0:
> > Version : 1.2
> > Raid Level : raid6
> > Total Devices : 1
> > Persistence : Superblock is persistent
> >
> > State : inactive
> > Working Devices : 1
> >
> > Name : NAS-ubuntu:0
> > UUID : 2bf6381b:fe19bdd4:9cc53ae7:5dce1630
> > Events : 477468
> >
> > Number Major Minor RaidDevice
> > - 8 32 - /dev/sdc
> >
> >
> > So what should I do next?
> > I have not run the --create --assume-clean yet but could that help in t=
his case?
> >
> > Thanks for any help.
> >
> > Best regards,
> > Topi Viljanen
> >
