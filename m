Received: from smtp161.vfemail.net (smtp161.vfemail.net [146.59.185.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E95AE63511
	for <linux-raid@vger.kernel.org>; Tue, 23 Jan 2024 16:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=146.59.185.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706026393; cv=none; b=F9lCqCS6rMAbD5jYCu3pqkpyIq7hFB6Akc7l4qoipZY0BkWbcGHe0Lhxr8Q7eWL9R22xEi3mlgMdwnm/Gs+I8Oaz4FR+GsjJmzg7ep+LsDRZUjMsQt0wokx2ZfvJlN9/pskRIb9KKtcD+uMq6/UkJz3homs9bZOYuRE50mYI9zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706026393; c=relaxed/simple;
	bh=60El9+RU5dX8FjK6NOXbv9gI2bYpt7/szVQ/4i0orpM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ra31oBzKTTnJ2rivyCo6ikc2Y8PefhfGQ6lxShxcaF8CO+U8Ch7zwNDlMcdy3aHFvucsS0+dPmUj5ZFBlE2N32h4I7HTKvbEF4APrYQ7XUjAATn9lRlGVceGGYdj97UlsC3neloiXJFEl+8o3d2cWug7J4VIFrxntI7qT3/3pIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vfemail.net; spf=pass smtp.mailfrom=vfemail.net; dkim=pass (1024-bit key) header.d=vfemail.net header.i=@vfemail.net header.b=lawYhBqW; arc=none smtp.client-ip=146.59.185.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vfemail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vfemail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vfemail.net header.i=@vfemail.net header.b="lawYhBqW"
Received: (qmail 26467 invoked from network); 23 Jan 2024 16:06:28 +0000
Received: from localhost (HELO nl101-3.vfemail.net) ()
  by smtpout.vfemail.net with ESMTPS (ECDHE-RSA-AES256-GCM-SHA384 encrypted); 23 Jan 2024 16:06:28 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=vfemail.net; h=date:from
	:to:cc:subject:message-id:in-reply-to:references:mime-version
	:content-type:content-transfer-encoding; s=2018; bh=60El9+RU5dX8
	FjK6NOXbv9gI2bYpt7/szVQ/4i0orpM=; b=lawYhBqW6hkTNbvy3PsaVdttPfMv
	+jO6neP/lS5RoGymM9l/iOiWH+6sg93hhWNPz5bPh4vN5LqotynfzfW39IinWGs2
	7JppoCC4pLzqOyORPC+wVeUH2fw6P7I55Lj9sn/nZ+nK2YPqy23RoKzYm+85HmaQ
	528KwnfNE7tqLQI=
Received: (qmail 14609 invoked from network); 23 Jan 2024 16:06:27 -0000
Received: by simscan 1.4.0 ppid: 14581, pid: 14602, t: 0.3907s
         scanners:none
Received: from unknown (HELO bmwxMDEudmZlbWFpbC5uZXQ=) (aGdudGt3aXNAdmZlbWFpbC5uZXQ=@MTkyLjE2OC4xLjE5Mg==)
  by nl101.vfemail.net with ESMTPA; 23 Jan 2024 16:06:27 -0000
Date: Tue, 23 Jan 2024 11:06:24 -0500
From: David Niklas <simd@vfemail.net>
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Cc: RJ Marquette <rjm1@yahoo.com>
Subject: Re: Requesting help recovering my array
Message-ID: <20240123110624.1b625180@firefly>
In-Reply-To: <755754794.951974.1705974751281@mail.yahoo.com>
References: <432300551.863689.1705953121879.ref@mail.yahoo.com>
	<432300551.863689.1705953121879@mail.yahoo.com>
	<04757cef-9edf-449a-93ab-a0534a821dc6@thelounge.net>
	<1085291040.906901.1705961588972@mail.yahoo.com>
	<0f28b23e-54f2-49ed-9149-87dbe3cffb30@thelounge.net>
	<598555968.936049.1705968542252@mail.yahoo.com>
	<755754794.951974.1705974751281@mail.yahoo.com>
X-Mailer: Claws Mail 3.13.2 (GTK+ 2.24.30; aarch64-unknown-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hello,

As someone who's a bit more experienced in RAID array failures, I'd like
to suggest the following:

# Check that all drives are being detected.
ls /dev/sd*

# Verify what exactly is being scanned.
grep DEVICE /etc/mdadm/mdadm.conf

Assuming both of these give satisfactory results*, your next step would
be to try assembling them out of order and see what happens. For example:

-> mdadm --assemble /dev/md0 /dev/sda /dev/sdb
Mdadm: Error Not part of array /dev/sdb
-> mdadm --assemble /dev/md0 /dev/sda /dev/sdc
Mdadm: Error too few drives to start array /dev/md0

Please note that I made up what mdadm is saying there. But it still tells
you what's going on.
* for the ls command you should see all the drives you have. For the grep
command you should get a listing like "/dev/sda /dev/sdb"... Obviously,
all the drives that might have a RAID array on them should be listed.


Sincerely,
David





On Tue, 23 Jan 2024 01:52:31 +0000 (UTC)
RJ Marquette <rjm1@yahoo.com> wrote:
> I meant to add that my /proc/mdstat looked much more like yours on the
> old system.=C2=A0 But nothing is showing on this one.=20
>=20
> I may try swapping back to the old motherboard.=C2=A0 Another possibility
> that might be factor - UEFI vs Legacy BIOS.
>=20
> Thanks.
> --RJ
>=20
>=20
> On Monday, January 22, 2024 at 07:45:29 PM EST, RJ Marquette
> <rjm1@yahoo.com> wrote:=20
>=20
>=20
>=20
>=20
>=20
> That's all.=C2=A0=20
>=20
> If I run:
>=20
> root@jackie:~# mdadm --assemble --scan
> mdadm: /dev/md0 assembled from 0 drives and 1 spare - not enough to
> start the array.
>=20
> root@jackie:~# cat /proc/mdstat =C2=A0
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> [raid4] [raid10] unused devices: <none>
>=20
> root@jackie:~# ls -l /dev/md*
> ls: cannot access '/dev/md*': No such file or directory
>=20
> It seems to be recognizing the spare drive, but not the 5 that actually
> have data, for some reason.
>=20
> Thanks.
> --RJ
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
> On Monday, January 22, 2024 at 06:49:50 PM EST, Reindl Harald
> <h.reindl@thelounge.net> wrote:=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
> Am 22.01.24 um 23:13 schrieb RJ Marquette:
> > Sorry!
> >=20
> > rj@jackie:~$ cat /proc/mdstat
> > Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> > [raid4] [raid10] unused devices: <none> =20
>=20
> that's all and where is the ton of raid-types coming from with no
> single array shown?
>=20
> [root@srv-rhsoft:~]$ cat /proc/mdstat
> Personalities : [raid1]
> md0 : active raid1 sdb2[2] sda2[0]
> =C2=A0 =C2=A0 =C2=A0 30740480 blocks super 1.2 [2/2] [UU]
> =C2=A0 =C2=A0 =C2=A0 bitmap: 0/1 pages [0KB], 65536KB chunk
>=20
> md1 : active raid1 sda3[0] sdb3[2]
> =C2=A0 =C2=A0 =C2=A0 3875717120 blocks super 1.2 [2/2] [UU]
> =C2=A0 =C2=A0 =C2=A0 bitmap: 5/29 pages [20KB], 65536KB chunk
>=20
>=20
> unused devices: <none>
>=20
> > On Monday, January 22, 2024 at 04:55:50 PM EST, Reindl Harald
> > <h.reindl@thelounge.net> wrote:
> >=20
> > a ton of "mdadm --examine" outputs but i can't see a
> > "cat /proc/mdstat"
> >=20
> > /dev/sdX is completly irrelevant when it comes to raid - you can even
> > connect a random disk via USB adapter without a change from the view
> > of the array
> >=20
> > Am 22.01.24 um 20:52 schrieb RJ Marquette: =20
> >> Hi, all.=C2=A0 I have a Raid5 array with 5 disks in use and a 6th in
> >> reserve that I built using 3TB drives in 2019.=C2=A0 It has been runni=
ng
> >> fine since, not even a single drive failure.=C2=A0 The system also has=
 a
> >> 7th hard drive for OS, home directory, etc.=C2=A0 The motherboard had
> >> four SATA ports, so I added an adapter card that has 4 more ports,
> >> with three drives connected to it.=C2=A0 The server runs Debian that I
> >> keep relatively current.
> >>
> >> Yesterday, I swapped a newer motherboard into the computer (upgraded
> >> my desktop and moved the guts to my server).=C2=A0 I never disconnected
> >> the cables from the adapter card (whew, I think), so I know which
> >> four drives were connected to the motherboard.=C2=A0 Unfortunately I
> >> didn't really note how they were hooked to the motherboard (SATA1-4
> >> ports).=C2=A0 Didn't even think it would be an issue.=C2=A0 I'm reason=
ably
> >> confident the array drives on the motherboard were sda-sdc, but I'm
> >> not certain.
> >>
> >> Now I can't get the array to come up.=C2=A0 I'm reasonably certain I
> >> haven't done anything to write to the drives - but mdadm will not
> >> assemble the drives (I have not tried to force it).=C2=A0 I'm not
> >> entirely sure what's up and would really appreciate any help.
> >>
> >> I've tried various incantations of mdadm --assemble --scan, with no
> >> luck.=C2=A0 I've seen the posts about certain motherboards that can me=
ss
> >> up the drives, and I'm hoping I'm not in that boat.=C2=A0 The "new"
> >> motherboard is a Asus Z96-K/CSM.
> >>
> >> I assume using --force is in my future...I see various pages that
> >> say use --force then check it, but will that damage it if I'm
> >> wrong?=C2=A0 If not, how will I know it's correct?=C2=A0 Is the order =
of
> >> drives important with --force?=C2=A0 I see conflicting info on that.
> >>
> >> I'm no expert but it looks like each drive has the mdadm
> >> superblock...so I'm not sure why it won't assemble.=C2=A0 Please help!
> >>
> >> Thanks in advance.
> >> --RJ
> >>
> >> root@jackie:~# uname -a
> >> Linux jackie 5.10.0-27-amd64 #1 SMP Debian 5.10.205-2 (2023-12-31)
> >> x86_64 GNU/Linux
> >>
> >> root@jackie:~# mdadm --version
> >> mdadm - v4.1 - 2018-10-01
> >>
> >> root@jackie:~# mdadm --examine /dev/sda
> >> /dev/sda: =C2=A0=C2=A0MBR Magic : aa55
> >> Partition[0] : =C2=A0=C2=A04294967295 sectors at =C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A01 (type ee)
> >>
> >> root@jackie:~# mdadm --examine /dev/sda1
> >> mdadm: No md superblock detected on /dev/sda1.
> >>
> >> root@jackie:~# mdadm --examine /dev/sdb
> >> /dev/sdb: =C2=A0=C2=A0MBR Magic : aa55
> >> Partition[0] : =C2=A0=C2=A04294967295 sectors at =C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A01 (type ee)
> >>
> >> root@jackie:~# mdadm --examine /dev/sdb1
> >> mdadm: No md superblock detected on /dev/sdb1.
> >>
> >> root@jackie:~# mdadm --examine /dev/sdc
> >> /dev/sdc: =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Magic =
: a92b4efc =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Version : 1.2
> >> Feature Map : 0x0
> >> Array UUID : 74a11272:9b233a5b:2506f763:27693ccc
> >> Name : jackie:0 =C2=A0(local to host jackie)
> >> Creation Time : Sat Dec =C2=A08 19:32:07 2018
> >> Raid Level : raid5
> >> Raid Devices : 5 Avail
> >> Dev Size : 5860271024 (2794.39 GiB 3000.46 GB)
> >> Array Size : 11720540160 (11177.58 GiB 12001.83 GB)
> >> Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
> >> Data Offset : 262144 sectors
> >> Super Offset : 8 sectors
> >> Unused Space : before=3D261864 sectors, after=3D944 sectors
> >> State : clean
> >> Device UUID : a2b677bb:4004d8fb:a298a923:bab4df8a
> >> Update Time : Fri Jan 19 15:25:37 2024
> >> Bad Block Log : 512 entries available at offset 264 sectors
> >> Checksum : 2487f053 - correct
> >> Events : 5958
> >> Layout : left-symmetric
> >> Chunk Size : 512K
> >> Device Role : spare
> >> Array State : AAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)
> >>
> >> root@jackie:~# mdadm --examine /dev/sdc1
> >> mdadm: cannot open /dev/sdc1: No such file or directory
> >>
> >> root@jackie:~# mdadm --examine /dev/sde
> >> /dev/sde: =C2=A0=C2=A0MBR Magic : aa55
> >> Partition[0] : =C2=A0=C2=A04294967295 sectors at =C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A01 (type ee)
> >>
> >> root@jackie:~# mdadm --examine /dev/sde1
> >> mdadm: No md superblock detected on /dev/sde1.
> >>
> >> root@jackie:~# mdadm --examine /dev/sdf
> >> /dev/sdf: =C2=A0=C2=A0MBR Magic : aa55
> >> Partition[0] : =C2=A0=C2=A04294967295 sectors at =C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A01 (type ee)
> >>
> >> root@jackie:~# mdadm --examine /dev/sdf1
> >> mdadm: No md superblock detected on /dev/sdf1.
> >>
> >> root@jackie:~# mdadm --examine /dev/sdg
> >> /dev/sdg: =C2=A0=C2=A0MBR Magic : aa55
> >> Partition[0] : =C2=A0=C2=A04294967295 sectors at =C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A01 (type ee)
> >>
> >> root@jackie:~# mdadm --examine /dev/sdg1
> >> mdadm: No md superblock detected on /dev/sdg1.
> >>
> >> root@jackie:~# lsdrv
> >> PCI [ahci] 00:1f.2 SATA controller: Intel Corporation 9 Series
> >> Chipset Family SATA Controller [AHCI Mode] =E2=94=9Cscsi 0:0:0:0 ATA
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ST3000VN007-2E41 {Z7317D1A} =E2=94=82=E2=
=94=94sda 2.73t [8:0] Partitioned (gpt)
> >> =E2=94=82 =E2=94=94sda1 2.73t [8:1] Empty/Unknown
> >> =E2=94=9Cscsi 1:0:0:0 ATA =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Hitachi HUS724=
03 {P8GSA1WR}
> >> =E2=94=82=E2=94=94sdb 2.73t [8:16] Partitioned (gpt)
> >> =E2=94=82 =E2=94=94sdb1 2.73t [8:17] Empty/Unknown
> >> =E2=94=9Cscsi 2:0:0:0 ATA =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Hitachi HUA723=
03 {MK0371YVGSZ9RA}
> >> =E2=94=82=E2=94=94sdc 2.73t [8:32] MD raid5 (5) inactive
> >> 'jackie:0' {74a11272-9b23-3a5b-2506-f76327693ccc} =E2=94=94scsi 3:0:0:=
0 ATA
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ST32000542AS =C2=A0=C2=A0=C2=A0=C2=A0{5X=
W110LY} =E2=94=94sdd 1.82t [8:48] Partitioned (dos)
> >> =E2=94=9Csdd1 23.28g [8:49] Partitioned (dos)
> >> {d94cc2c8-037a-49c5-8a1e-01bb47d78624} =E2=94=82=E2=94=94Mounted as /d=
ev/sdd1 @ /
> >> =E2=94=9Csdd2 1.00k [8:50] Partitioned (dos)
> >> =E2=94=9Csdd5 9.31g [8:53] ext4 {6eb3b4d0-8c7f-4b06-a431-4c292d5bda86}
> >> =E2=94=82=E2=94=94Mounted as /dev/sdd5 @ /var
> >> =E2=94=9Csdd6 3.96g [8:54] swap {901cd56d-ef11-4866-824b-d9ec4ae6fe6e}
> >> =E2=94=9Csdd7 1.86g [8:55] ext4 {69ba0889-322b-4fc8-b9d3-a2d133c97e5e}
> >> =E2=94=82=E2=94=94Mounted as /dev/sdd7 @ /tmp
> >> =E2=94=94sdd8 1.78t [8:56] ext4 {4ed408d4-6b22-46e0-baed-2e0589ff41fb}
> >> =E2=94=94Mounted as /dev/sdd8 @ /home PCI [ahci]
> >>
> >> 06:00.0 SATA controller: Marvell Technology Group Ltd. 88SE9215 PCIe
> >> 2.0 x1 4-port SATA 6 Gb/s Controller (rev 11) =E2=94=9Cscsi 6:0:0:0 ATA
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Hitachi HUS72403 {P8G84LEP} =E2=94=82=E2=
=94=94sde 2.73t [8:64] Partitioned (gpt)
> >> =E2=94=82 =E2=94=94sde1 2.73t [8:65] Empty/Unknown
> >> =E2=94=9Cscsi 7:0:0:0 ATA =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ST3000VN007-2E=
41 {Z7317D46}
> >> =E2=94=82=E2=94=94sdf 2.73t [8:80] Partitioned (gpt)
> >> =E2=94=82 =E2=94=94sdf1 2.73t [8:81] Empty/Unknown
> >> =E2=94=94scsi 8:0:0:0 ATA =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ST3000VN007-2E=
41 {Z7317JTX}
> >> =E2=94=94sdg 2.73t [8:96] Partitioned (gpt)
> >> =E2=94=94sdg1 2.73t [8:97] Empty/Unknown
> >>
> >> root@jackie:~# cat /etc/mdadm/mdadm.conf
> >>=C2=A0 =C2=A0 =C2=A0# This configuration was auto-generated on Wed, 27 =
Nov 2019
> >>15:53:23 -0500 by mkconf
> >> ARRAY /dev/md0 metadata=3D1.2 spares=3D1 name=3Djackie:0
> >> UUID=3D74a11272:9b233a5b:2506f763:27693cccr =20
>=20

