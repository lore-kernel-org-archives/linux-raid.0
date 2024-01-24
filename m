Received: from smtp161.vfemail.net (smtp161.vfemail.net [146.59.185.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFDDBBE45
	for <linux-raid@vger.kernel.org>; Wed, 24 Jan 2024 03:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=146.59.185.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706066383; cv=none; b=naDfUZIIWHqW1fDiAEgAO4wKHf81hXPQrQNQinahSjGSoFYMDcbuhIaXhIN/LpqHlAu/TntTpE55d60iXu+G5i6R76L2rrhsjCWZjGPPEBwq+viEa3tjcY8pCjdNLsH/8k8xYjRcNKr3s2DlEyYVtOzTVa5TaSEYf6nS6BeM4DY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706066383; c=relaxed/simple;
	bh=lD8nCzvR73xsxF2hlxYVVyrn2CwWLq/jctipM/0G8os=;
	h=Date:From:To:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M08Z6J+iD/6j8ZOUzsiIHXj4x54sU6EVE1+vgZup0/IZCoJhsjnH+t+QCRfX8tJP7/9krEf1bZJdXKvHzrj+Nhm5vFxAsUN3y8DeVdGdatIpnwYUd19hugL4lwB73gcpheZgSBf7Dx9zNoHr1SS9LT3wS0O8f59ynSWN7mDkWqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vfemail.net; spf=pass smtp.mailfrom=vfemail.net; dkim=pass (1024-bit key) header.d=vfemail.net header.i=@vfemail.net header.b=in2rsSxv; arc=none smtp.client-ip=146.59.185.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vfemail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vfemail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vfemail.net header.i=@vfemail.net header.b="in2rsSxv"
Received: (qmail 7894 invoked from network); 24 Jan 2024 03:19:38 +0000
Received: from localhost (HELO nl101-3.vfemail.net) ()
  by smtpout.vfemail.net with ESMTPS (ECDHE-RSA-AES256-GCM-SHA384 encrypted); 24 Jan 2024 03:19:38 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=vfemail.net; h=date:from
	:to:subject:message-id:in-reply-to:references:mime-version
	:content-type:content-transfer-encoding; s=2018; bh=lD8nCzvR73xs
	xF2hlxYVVyrn2CwWLq/jctipM/0G8os=; b=in2rsSxvq6Qxdzjncsa2HBav9ig1
	GR5tTsAMUXdDSRrVjZBqUiGa1GXdBJSCqzqLIB9jpEWCPADnkNsH8SkOkC3un6DS
	76pknWJhrlPs8JlriKdNoO53aQKbqTOnFNVGrmyZbuwPpZBEbO7lLbb8qLwiXhOF
	ly+nf/8gRVBlooI=
Received: (qmail 68478 invoked from network); 24 Jan 2024 03:19:38 -0000
Received: by simscan 1.4.0 ppid: 68463, pid: 68466, t: 0.4640s
         scanners:none
Received: from unknown (HELO bmwxMDEudmZlbWFpbC5uZXQ=) (aGdudGt3aXNAdmZlbWFpbC5uZXQ=@MTkyLjE2OC4xLjE5Mg==)
  by nl101.vfemail.net with ESMTPA; 24 Jan 2024 03:19:37 -0000
Date: Tue, 23 Jan 2024 22:19:35 -0500
From: David Niklas <simd@vfemail.net>
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Re: Requesting help recovering my array
Message-ID: <20240123221935.683eb1eb@firefly>
In-Reply-To: <12445908.1094378.1706026572835@mail.yahoo.com>
References: <432300551.863689.1705953121879.ref@mail.yahoo.com>
	<432300551.863689.1705953121879@mail.yahoo.com>
	<04757cef-9edf-449a-93ab-a0534a821dc6@thelounge.net>
	<1085291040.906901.1705961588972@mail.yahoo.com>
	<0f28b23e-54f2-49ed-9149-87dbe3cffb30@thelounge.net>
	<598555968.936049.1705968542252@mail.yahoo.com>
	<755754794.951974.1705974751281@mail.yahoo.com>
	<20240123110624.1b625180@firefly>
	<12445908.1094378.1706026572835@mail.yahoo.com>
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
I, personally, just use the device and array lines. You're welcome to keep
tracking down why UUID detection doesn't work for you if you so chose.

Example:
DEVICE /dev/sda1 /dev/sdb1 ...
ARRAY /dev/md0 metadata=3D1.2 spares=3D1 name=3Djackie:0 /dev/sda1 /dev/sdb=
1 ...

If you just want the array to work (for now), then:
mdadm --assemble /dev/md0 /dev/sd{a,b,e,f,g}1
should do the trick.

One question though, why does sdc not have a partition table? I mean, it
doesn't really matter if you use a RAID array without one, but it stands
out from the rest of the info as erroneous. Sort of like either you
goofed (hopefully), or the drive isn't being detected/working properly.

Sincerely,
David


PS: I'm subscribed to the list. No need to CC me.




On Tue, 23 Jan 2024 16:16:12 +0000 (UTC)
RJ Marquette <rjm1@yahoo.com> wrote:
> (Sorry if this came through twice without the mdadm.conf contents,
> somehow I accidentally hit send when I was trying to paste in.)
>=20
> Thanks.=C2=A0 All drives in the system are being detected (/dev/sdd is my
> system drive - the rest are all of the array):
>=20
> rj@jackie:~$ ls -l /dev/sd*
> brw-rw---- 1 root disk 8, =C2=A00 Jan 21 19:08 /dev/sda
> brw-rw---- 1 root disk 8, =C2=A01 Jan 21 19:08 /dev/sda1
> brw-rw---- 1 root disk 8, 16 Jan 21 19:08 /dev/sdb
> brw-rw---- 1 root disk 8, 17 Jan 21 19:08 /dev/sdb1
> brw-rw---- 1 root disk 8, 32 Jan 21 19:08 /dev/sdc
> brw-rw---- 1 root disk 8, 48 Jan 21 19:08 /dev/sdd
> brw-rw---- 1 root disk 8, 49 Jan 21 19:08 /dev/sdd1
> brw-rw---- 1 root disk 8, 50 Jan 21 19:08 /dev/sdd2
> brw-rw---- 1 root disk 8, 53 Jan 21 19:08 /dev/sdd5
> brw-rw---- 1 root disk 8, 54 Jan 21 19:08 /dev/sdd6
> brw-rw---- 1 root disk 8, 55 Jan 21 19:08 /dev/sdd7
> brw-rw---- 1 root disk 8, 56 Jan 21 19:08 /dev/sdd8
> brw-rw---- 1 root disk 8, 64 Jan 21 19:08 /dev/sde
> brw-rw---- 1 root disk 8, 65 Jan 21 19:08 /dev/sde1
> brw-rw---- 1 root disk 8, 80 Jan 21 19:08 /dev/sdf
> brw-rw---- 1 root disk 8, 81 Jan 21 19:08 /dev/sdf1
> brw-rw---- 1 root disk 8, 96 Jan 21 19:08 /dev/sdg
> brw-rw---- 1 root disk 8, 97 Jan 21 19:08 /dev/sdg1
>=20
>=20
> The devices are not listed in the mdadm.conf, nor were they ever.
> Here's everything (except the initial header comments about updating
> initramfs and all) from that file:
>=20
> # by default (built-in), scan all partitions (/proc/partitions) and all
> # containers for MD superblocks. alternatively, specify devices to
> scan, using # wildcards if desired.
> #DEVICE partitions containers
>=20
> # automatically tag new arrays as belonging to the local system
> HOMEHOST <system>
>=20
> # instruct the monitoring daemon where to send mail alerts
> MAILADDR rj
>=20
> # definitions of existing MD arrays
> #ARRAY /dev/md/0=C2=A0 metadata=3D1.2 UUID=3D74a11272:9b233a5b:2506f763:2=
7693ccc
> name=3Djackie:0
>=20
> # This configuration was auto-generated on Wed, 27 Nov 2019 15:53:23
> -0500 by mkconf=20
> UUID=3D74a11272:9b233a5b:2506f763:27693ccc
>=20
>=20
> I assume that last line was added when I added the spare drive.=C2=A0 Sho=
uld
> I add the drives to the mdadm.conf then run the assemble command you
> suggested?
>=20
> It's like mdadm was assembling them automatically upon bootup, but that
> stopped working with the new motherboard for some reason.
>=20
> Thanks.
> --RJ
>=20
>=20
>=20
>=20
>=20
>=20
> On Tuesday, January 23, 2024 at 11:06:30 AM EST, David Niklas
> <simd@vfemail.net> wrote:=20
>=20
>=20
>=20
>=20
>=20
> Hello,
>=20
> As someone who's a bit more experienced in RAID array failures, I'd like
> to suggest the following:
>=20
> # Check that all drives are being detected.
> ls /dev/sd*
>=20
> # Verify what exactly is being scanned.
> grep DEVICE /etc/mdadm/mdadm.conf
>=20
> Assuming both of these give satisfactory results*, your next step would
> be to try assembling them out of order and see what happens. For
> example:
>=20
> -> mdadm --assemble /dev/md0 /dev/sda /dev/sdb =20
> Mdadm: Error Not part of array /dev/sdb
> -> mdadm --assemble /dev/md0 /dev/sda /dev/sdc =20
> Mdadm: Error too few drives to start array /dev/md0
>=20
> Please note that I made up what mdadm is saying there. But it still
> tells you what's going on.
> * for the ls command you should see all the drives you have. For the
> grep command you should get a listing like "/dev/sda /dev/sdb"...
> Obviously, all the drives that might have a RAID array on them should
> be listed.
>=20
>=20
> Sincerely,
> David
>=20
>=20
>=20
>=20
>=20
> On Tue, 23 Jan 2024 01:52:31 +0000 (UTC)
> RJ Marquette <rjm1@yahoo.com> wrote:
> > I meant to add that my /proc/mdstat looked much more like yours on the
> > old system.=C2=A0 But nothing is showing on this one.=20
> >=20
> > I may try swapping back to the old motherboard.=C2=A0 Another possibili=
ty
> > that might be factor - UEFI vs Legacy BIOS.
> >=20
> > Thanks.
> > --RJ
> >=20
> >=20
> > On Monday, January 22, 2024 at 07:45:29 PM EST, RJ Marquette
> > <rjm1@yahoo.com> wrote:=20
> >=20
> >=20
> >=20
> >=20
> >=20
> > That's all.=C2=A0=20
> >=20
> > If I run:
> >=20
> > root@jackie:~# mdadm --assemble --scan
> > mdadm: /dev/md0 assembled from 0 drives and 1 spare - not enough to
> > start the array.
> >=20
> > root@jackie:~# cat /proc/mdstat =C2=A0
> > Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> > [raid4] [raid10] unused devices: <none>
> >=20
> > root@jackie:~# ls -l /dev/md*
> > ls: cannot access '/dev/md*': No such file or directory
> >=20
> > It seems to be recognizing the spare drive, but not the 5 that
> > actually have data, for some reason.
> >=20
> > Thanks.
> > --RJ
> >=20
> >=20
> >=20
> >=20
> >=20
> >=20
> >=20
> >=20
> > On Monday, January 22, 2024 at 06:49:50 PM EST, Reindl Harald
> > <h.reindl@thelounge.net> wrote:=20
> >=20
> >=20
> >=20
> >=20
> >=20
> >=20
> >=20
> > Am 22.01.24 um 23:13 schrieb RJ Marquette: =20
> > > Sorry!
> > >=20
> > > rj@jackie:~$ cat /proc/mdstat
> > > Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> > > [raid4] [raid10] unused devices: <none>=C2=A0  =20
> >=20
> > that's all and where is the ton of raid-types coming from with no
> > single array shown?
> >=20
> > [root@srv-rhsoft:~]$ cat /proc/mdstat
> > Personalities : [raid1]
> > md0 : active raid1 sdb2[2] sda2[0]
> > =C2=A0 =C2=A0 =C2=A0 30740480 blocks super 1.2 [2/2] [UU]
> > =C2=A0 =C2=A0 =C2=A0 bitmap: 0/1 pages [0KB], 65536KB chunk
> >=20
> > md1 : active raid1 sda3[0] sdb3[2]
> > =C2=A0 =C2=A0 =C2=A0 3875717120 blocks super 1.2 [2/2] [UU]
> > =C2=A0 =C2=A0 =C2=A0 bitmap: 5/29 pages [20KB], 65536KB chunk
> >=20
> >=20
> > unused devices: <none>
> >  =20
> > > On Monday, January 22, 2024 at 04:55:50 PM EST, Reindl Harald
> > > <h.reindl@thelounge.net> wrote:
> > >=20
> > > a ton of "mdadm --examine" outputs but i can't see a
> > > "cat /proc/mdstat"
> > >=20
> > > /dev/sdX is completly irrelevant when it comes to raid - you can
> > > even connect a random disk via USB adapter without a change from
> > > the view of the array
> > >=20
> > > Am 22.01.24 um 20:52 schrieb RJ Marquette:=C2=A0  =20
> > >> Hi, all.=C2=A0 I have a Raid5 array with 5 disks in use and a 6th in
> > >> reserve that I built using 3TB drives in 2019.=C2=A0 It has been run=
ning
> > >> fine since, not even a single drive failure.=C2=A0 The system also h=
as a
> > >> 7th hard drive for OS, home directory, etc.=C2=A0 The motherboard had
> > >> four SATA ports, so I added an adapter card that has 4 more ports,
> > >> with three drives connected to it.=C2=A0 The server runs Debian that=
 I
> > >> keep relatively current.
> > >>
> > >> Yesterday, I swapped a newer motherboard into the computer
> > >> (upgraded my desktop and moved the guts to my server).=C2=A0 I never
> > >> disconnected the cables from the adapter card (whew, I think), so
> > >> I know which four drives were connected to the motherboard.
> > >> Unfortunately I didn't really note how they were hooked to the
> > >> motherboard (SATA1-4 ports).=C2=A0 Didn't even think it would be an
> > >> issue.=C2=A0 I'm reasonably confident the array drives on the
> > >> motherboard were sda-sdc, but I'm not certain.
> > >>
> > >> Now I can't get the array to come up.=C2=A0 I'm reasonably certain I
> > >> haven't done anything to write to the drives - but mdadm will not
> > >> assemble the drives (I have not tried to force it).=C2=A0 I'm not
> > >> entirely sure what's up and would really appreciate any help.
> > >>
> > >> I've tried various incantations of mdadm --assemble --scan, with no
> > >> luck.=C2=A0 I've seen the posts about certain motherboards that can =
mess
> > >> up the drives, and I'm hoping I'm not in that boat.=C2=A0 The "new"
> > >> motherboard is a Asus Z96-K/CSM.
> > >>
> > >> I assume using --force is in my future...I see various pages that
> > >> say use --force then check it, but will that damage it if I'm
> > >> wrong?=C2=A0 If not, how will I know it's correct?=C2=A0 Is the orde=
r of
> > >> drives important with --force?=C2=A0 I see conflicting info on that.
> > >>
> > >> I'm no expert but it looks like each drive has the mdadm
> > >> superblock...so I'm not sure why it won't assemble.=C2=A0 Please hel=
p!
> > >>
> > >> Thanks in advance.
> > >> --RJ
> > >>
> > >> root@jackie:~# uname -a
> > >> Linux jackie 5.10.0-27-amd64 #1 SMP Debian 5.10.205-2 (2023-12-31)
> > >> x86_64 GNU/Linux
> > >>
> > >> root@jackie:~# mdadm --version
> > >> mdadm - v4.1 - 2018-10-01
> > >>
> > >> root@jackie:~# mdadm --examine /dev/sda
> > >> /dev/sda: =C2=A0=C2=A0MBR Magic : aa55
> > >> Partition[0] : =C2=A0=C2=A04294967295 sectors at =C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A01 (type ee)
> > >>
> > >> root@jackie:~# mdadm --examine /dev/sda1
> > >> mdadm: No md superblock detected on /dev/sda1.
> > >>
> > >> root@jackie:~# mdadm --examine /dev/sdb
> > >> /dev/sdb: =C2=A0=C2=A0MBR Magic : aa55
> > >> Partition[0] : =C2=A0=C2=A04294967295 sectors at =C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A01 (type ee)
> > >>
> > >> root@jackie:~# mdadm --examine /dev/sdb1
> > >> mdadm: No md superblock detected on /dev/sdb1.
> > >>
> > >> root@jackie:~# mdadm --examine /dev/sdc
> > >> /dev/sdc: =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Magi=
c : a92b4efc =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Version : 1.2
> > >> Feature Map : 0x0
> > >> Array UUID : 74a11272:9b233a5b:2506f763:27693ccc
> > >> Name : jackie:0 =C2=A0(local to host jackie)
> > >> Creation Time : Sat Dec =C2=A08 19:32:07 2018
> > >> Raid Level : raid5
> > >> Raid Devices : 5 Avail
> > >> Dev Size : 5860271024 (2794.39 GiB 3000.46 GB)
> > >> Array Size : 11720540160 (11177.58 GiB 12001.83 GB)
> > >> Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
> > >> Data Offset : 262144 sectors
> > >> Super Offset : 8 sectors
> > >> Unused Space : before=3D261864 sectors, after=3D944 sectors
> > >> State : clean
> > >> Device UUID : a2b677bb:4004d8fb:a298a923:bab4df8a
> > >> Update Time : Fri Jan 19 15:25:37 2024
> > >> Bad Block Log : 512 entries available at offset 264 sectors
> > >> Checksum : 2487f053 - correct
> > >> Events : 5958
> > >> Layout : left-symmetric
> > >> Chunk Size : 512K
> > >> Device Role : spare
> > >> Array State : AAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=
=3D
> > >> replacing)
> > >>
> > >> root@jackie:~# mdadm --examine /dev/sdc1
> > >> mdadm: cannot open /dev/sdc1: No such file or directory
> > >>
> > >> root@jackie:~# mdadm --examine /dev/sde
> > >> /dev/sde: =C2=A0=C2=A0MBR Magic : aa55
> > >> Partition[0] : =C2=A0=C2=A04294967295 sectors at =C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A01 (type ee)
> > >>
> > >> root@jackie:~# mdadm --examine /dev/sde1
> > >> mdadm: No md superblock detected on /dev/sde1.
> > >>
> > >> root@jackie:~# mdadm --examine /dev/sdf
> > >> /dev/sdf: =C2=A0=C2=A0MBR Magic : aa55
> > >> Partition[0] : =C2=A0=C2=A04294967295 sectors at =C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A01 (type ee)
> > >>
> > >> root@jackie:~# mdadm --examine /dev/sdf1
> > >> mdadm: No md superblock detected on /dev/sdf1.
> > >>
> > >> root@jackie:~# mdadm --examine /dev/sdg
> > >> /dev/sdg: =C2=A0=C2=A0MBR Magic : aa55
> > >> Partition[0] : =C2=A0=C2=A04294967295 sectors at =C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A01 (type ee)
> > >>
> > >> root@jackie:~# mdadm --examine /dev/sdg1
> > >> mdadm: No md superblock detected on /dev/sdg1.
> > >>
> > >> root@jackie:~# lsdrv
> > >> PCI [ahci] 00:1f.2 SATA controller: Intel Corporation 9 Series
> > >> Chipset Family SATA Controller [AHCI Mode] =E2=94=9Cscsi 0:0:0:0 ATA
> > >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ST3000VN007-2E41 {Z7317D1A} =E2=94=82=
=E2=94=94sda 2.73t [8:0] Partitioned
> > >> (gpt) =E2=94=82 =E2=94=94sda1 2.73t [8:1] Empty/Unknown
> > >> =E2=94=9Cscsi 1:0:0:0 ATA =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Hitachi HUS7=
2403 {P8GSA1WR}
> > >> =E2=94=82=E2=94=94sdb 2.73t [8:16] Partitioned (gpt)
> > >> =E2=94=82 =E2=94=94sdb1 2.73t [8:17] Empty/Unknown
> > >> =E2=94=9Cscsi 2:0:0:0 ATA =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Hitachi HUA7=
2303 {MK0371YVGSZ9RA}
> > >> =E2=94=82=E2=94=94sdc 2.73t [8:32] MD raid5 (5) inactive
> > >> 'jackie:0' {74a11272-9b23-3a5b-2506-f76327693ccc} =E2=94=94scsi 3:0:=
0:0 ATA
> > >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ST32000542AS =C2=A0=C2=A0=C2=A0=C2=A0{=
5XW110LY} =E2=94=94sdd 1.82t [8:48] Partitioned
> > >> (dos) =E2=94=9Csdd1 23.28g [8:49] Partitioned (dos)
> > >> {d94cc2c8-037a-49c5-8a1e-01bb47d78624} =E2=94=82=E2=94=94Mounted as =
/dev/sdd1 @ /
> > >> =E2=94=9Csdd2 1.00k [8:50] Partitioned (dos)
> > >> =E2=94=9Csdd5 9.31g [8:53] ext4 {6eb3b4d0-8c7f-4b06-a431-4c292d5bda8=
6}
> > >> =E2=94=82=E2=94=94Mounted as /dev/sdd5 @ /var
> > >> =E2=94=9Csdd6 3.96g [8:54] swap {901cd56d-ef11-4866-824b-d9ec4ae6fe6=
e}
> > >> =E2=94=9Csdd7 1.86g [8:55] ext4 {69ba0889-322b-4fc8-b9d3-a2d133c97e5=
e}
> > >> =E2=94=82=E2=94=94Mounted as /dev/sdd7 @ /tmp
> > >> =E2=94=94sdd8 1.78t [8:56] ext4 {4ed408d4-6b22-46e0-baed-2e0589ff41f=
b}
> > >> =E2=94=94Mounted as /dev/sdd8 @ /home PCI [ahci]
> > >>
> > >> 06:00.0 SATA controller: Marvell Technology Group Ltd. 88SE9215
> > >> PCIe 2.0 x1 4-port SATA 6 Gb/s Controller (rev 11) =E2=94=9Cscsi 6:0=
:0:0
> > >> ATA Hitachi HUS72403 {P8G84LEP} =E2=94=82=E2=94=94sde 2.73t [8:64] P=
artitioned
> > >> (gpt) =E2=94=82 =E2=94=94sde1 2.73t [8:65] Empty/Unknown
> > >> =E2=94=9Cscsi 7:0:0:0 ATA =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ST3000VN007-=
2E41 {Z7317D46}
> > >> =E2=94=82=E2=94=94sdf 2.73t [8:80] Partitioned (gpt)
> > >> =E2=94=82 =E2=94=94sdf1 2.73t [8:81] Empty/Unknown
> > >> =E2=94=94scsi 8:0:0:0 ATA =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ST3000VN007-=
2E41 {Z7317JTX}
> > >> =E2=94=94sdg 2.73t [8:96] Partitioned (gpt)
> > >> =E2=94=94sdg1 2.73t [8:97] Empty/Unknown
> > >>
> > >> root@jackie:~# cat /etc/mdadm/mdadm.conf
> > >>=C2=A0 =C2=A0 =C2=A0# This configuration was auto-generated on Wed, 2=
7 Nov 2019
> > >>15:53:23 -0500 by mkconf
> > >> ARRAY /dev/md0 metadata=3D1.2 spares=3D1 name=3Djackie:0
> > >> UUID=3D74a11272:9b233a5b:2506f763:27693cccr=C2=A0  =20
> >  =20
>=20

