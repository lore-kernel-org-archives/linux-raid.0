Received: from sonic317-26.consmr.mail.bf2.yahoo.com (sonic317-26.consmr.mail.bf2.yahoo.com [74.6.129.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3776461674
	for <linux-raid@vger.kernel.org>; Tue, 23 Jan 2024 16:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.6.129.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706026205; cv=none; b=CfRHLTRhqNdJZHODRo04MX8b/Bvi785bjajHW9KWvZQ5TCGO/NFjpq1zaViPGKSCHpG8kirzOqu6CJDG9+ei8kYAq1qgHBK1YbY5czD18VTFWJCVS4gSgsbRsjEHxSFD9bFGSf5PLNwwfZq7ZmjYeVgAjyHlH+RRIZg0q2N7dcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706026205; c=relaxed/simple;
	bh=VXn0OdQcpJDyXiqMc03PJE4Z7XB3PnILvWC/e9e2uW0=;
	h=Date:From:To:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=hgCMzG+HomTBtyZfLDkkHKW9goWFUGh9dzwukQGbaNBwmEnFd6sTVQpRUMqmOSoLwoFRNUKcuRaKeboCaqPYZU1Jr7KG+BG9V5ztEg6IHLyxk6je2akWvVi88lbJhMgoTkkTyC6BBBz2+4dJsfBXSYaHRdWx7WonY5Cijacej24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com; spf=pass smtp.mailfrom=yahoo.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=a5tV5Qgf; arc=none smtp.client-ip=74.6.129.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="a5tV5Qgf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1706026201; bh=VXn0OdQcpJDyXiqMc03PJE4Z7XB3PnILvWC/e9e2uW0=; h=Date:From:To:In-Reply-To:References:Subject:From:Subject:Reply-To; b=a5tV5QgfAWdb+V5ZvjXC2Ig6UIhHiCeBungmjd+LFeRv2/pDvIdTrUkOz97l2Ina9z+7ZNFgg6a+KK4fOcqqklVyTdySHD8Q4V8BIu+oB4Z0e/UsB3lZtOofRobzB6SRFYzb09DL+FfvEPDCz+XIW03VCFrvUDZy7t22v1Izs6zxWfWK7IT4xpTHgyvZisZLfbH/8XEY28JlRBICU2KZett8xUXK/bV8CWssr8Po5dyJeoSwBeCERhFYwuJ/OZR7hdHZzEakLgbfxZSNl0szHT4++7WUh9haOLZ+h00PsGjI/24yEiew82VBOgR1o/oItJHj1uA5qBWFmTMIh5CeCg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1706026201; bh=J4rZ+MxbXBBZMknuExkA3lOVz2AiBEDG0997TH8sgxR=; h=X-Sonic-MF:Date:From:To:Subject:From:Subject; b=W/fiW3u4e5VanVXLQR94I7lNW649cCIJ3wQ+wnCzrP4jfgS9aWa4sben/iX8ZnIzAAHCl8lUu9MWoO/Y02AF9d6zZ7SF40+KvP3s8ZZC25LtAGyjcG8xqQk1GgrZFewNl0C3bYd3l/Oiyp9fHG6Kd2j7Tsci6Q4pheGBmBdhuwBUzN1vF4QHjgxLFouxTBvI/XZOtC/rYc4ObWYYFkQ6PRdxA8MQ+WdEzPrHfOOswzFWp58RgFEnVSbQtKn74qQ25mDrKmQAz8Vrvbfubs0YmtII7N+kaujmu6xPC4hrnVg4JTnIsUy87KkfZtS7ERa0eGBV89N8Zs2A3At08bWNIQ==
X-YMail-OSG: Xz14f40VM1kc.7L0ti69svvpqlpVSiOpfmEoH88Vq17uPJ1iHevh6w68dsWBZKq
 W4NuCV6XaaMmLAZxWBpTBm2a8s1ex0.AaJx7RuLzoB.VWV6TlYnX0qjrqkweLk6DUFCTcc0ggSj7
 emuU949meFY7zazgemyhTpCta2SL24a1GVieXm6RtwLTUDmDbmSDrPWjc5sJmoou4txtSAEsDmtf
 b5K.WSB8EB6Kn.uNioF5hBjURLfw9pSAB7.1COBgEyWWOfM1Zu975ESJ89Kjaq5psEgoCzYG7FGJ
 UiBQSjT42UjXQ5ahQIuPEXKvjPb3gTBcZz0TyJwSqPYVdkVPs4fIVzf6KbxHi4KiIqCIqopbFVw.
 _Vdo7U7WayiOL2L1TastW1xwJI6NGw7f0s241ZakIYCS_OXVw31eo8eql0JmK_G4fbBGirpN0.Ft
 5kTuE3ClbLQYkCSMrfA9ZIrq2JcpimgQbaklVE0aXWHpPrZ0xNO.LxoLR2t4o6a70TlX7Ge9upnI
 gEkpddhF4iBvypPJl70xVLwE3ZB4NRbWpAZohLeWe86xezNdFQUfwsHX9K9onf1uoYtbvYAcTTLw
 fOfySmAcSr8q5ivc0LriYWXht3DlPCINVaHOiqJDxIrUSTzFNO.L_5gZhArdjamSYNgLIDVOP7Qj
 aGeS7vXW19NGoy5AYsNuwR_g19nREZFv7tSK.tIsF40WljjzWylM0X1kPWB_FP0h_KoD0g6pKc2X
 iFgYEds8.TMUSksCONktjSUTgTQVZ9Uh.1sGvAdmozcHMvoxYoMrzzldN4Br3h7zDhVC7RlFQf8S
 bO.b7UZro9EEjw3GZFrJ5wvYBTv7Qv9E3QPVBqZVZhw0MHnwj6H4.xPqf05kKweRDbK4ykRpRK6L
 aFghEgeSCDdx7OZbQbq3334Gz.HPwy7JxRYAYrcjoAxlvCUWkpZb6nC8PzwUXgRBW5foV8WRczRQ
 m3bCL5BonP6wsaLwARm8qzp9YarrPj6C71lY0MfDh82Y1ISuw_4qpgctz0qplbTK5qNVXjJ3Zsr3
 s4gqpgdmuR9pJ0DcvWbFK3K4pYCiTEODtSLQiWZFqkSwxLukMgkkHQ39otmR1LpOjyandTPhyhbb
 YdxF3Yizoq6PxLbgAht65F9moHFIe3KTV3hIMIE.q1GOBt1s0Csxkyrca_Ab.93W3XIKzxNlQRvu
 sVlv83x4nDT36Y1A07KUejWBgQGcZcKirYnavMUbNM0CXfElZxOKfXjLSxtBtOPJqCXrS9HvBPib
 MM9i5bMhUo2g93OBA96paxKp0k1siVY_Sv5BoifemPiCBr.sfgNPNIpkUloWmChqoxGoRTxGMcRI
 .gmgbITR1udCMU4Arrp5PM.i7LRxi55bDL_PMb1xD35DfEMi3dYkhGDlFu_NQg05RnofPleza7b7
 pIGkA30RwFjmgey2gJDOsZlysfCD3rCk.bAbohhBuU6Uomqaux8D4JXaOM8eSU6oLtW0VU2enWM7
 9lwEMcssr_wZJvNv_ToNXFQWSZ8bXnD.LOxioMUUW2m3vr5WkoTeZ60OBl3SbgglWY4.ayDkPa.Q
 49H.V4Q_qVis5VXTnnfRS8TAIggnTv3BfR_QsxJJOERk5EExlU3yi7KUJ_Ua.UjSjpfWsSVea9JG
 wMwoNJnxYHVJnfjmL76AGtA.heGITehElNEWjPox7UWdm5l.ajYfMmy.sVgHcR_48NSCKabrlgqj
 3BCvA_Gni1oHHSvTbn3BSNp4aOXWHip2PFT4ev1ZgL1XOiaK..F3faPghj_cEuMR0VpaKHXLRmxs
 F9O5Orha_Zf.NGQyoRJnYsD5pN3X_WSuPcP83XJ3mS1lj9WxoPHRXx2gN72eBTizEvIc60MfAXBz
 9gzrEKobjkpDuih325IxvrV.sm.NqG7sw5KQ7bfTM.h0f.QIDR39hl5.N5_8Y89ZCyQkKPgN8aNb
 cBV88Ic9GVT_wuAui53BQpg9kCugWmpkbTphrit6ws3Kn.liIFk77jxkdg8agCpRjM.susmowGpd
 m7.zTgswAg.7a0Cg0aJ7rEmqpX6LXUgMe0o8UOq7ge_c.8M3ltaB4F.S6JyCAkEqXpyFy6wCkSsZ
 U1OlrRfL4h70z6GdLXFFwKmimaM21GhS490kCRgKgcHhgaXlEy51M1jnI_Xi4bYth0sqxBWf5UAk
 SBXstBalgZYRCzwDdwbwpKqImu2qlRoR5uwWsQDTQIg1UB0y8JYU3K48BpOnvNhoCAwhJ1XALA5c
 k6FA-
X-Sonic-MF: <rjm1@yahoo.com>
X-Sonic-ID: 403a8f9d-ec71-4532-84be-a38815f781ad
Received: from sonic.gate.mail.ne1.yahoo.com by sonic317.consmr.mail.bf2.yahoo.com with HTTP; Tue, 23 Jan 2024 16:10:01 +0000
Date: Tue, 23 Jan 2024 16:09:56 +0000 (UTC)
From: RJ Marquette <rjm1@yahoo.com>
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, 
	David Niklas <simd@vfemail.net>
Message-ID: <1544132674.1091677.1706026196909@mail.yahoo.com>
In-Reply-To: <20240123110624.1b625180@firefly>
References: <432300551.863689.1705953121879.ref@mail.yahoo.com> <432300551.863689.1705953121879@mail.yahoo.com> <04757cef-9edf-449a-93ab-a0534a821dc6@thelounge.net> <1085291040.906901.1705961588972@mail.yahoo.com> <0f28b23e-54f2-49ed-9149-87dbe3cffb30@thelounge.net> <598555968.936049.1705968542252@mail.yahoo.com> <755754794.951974.1705974751281@mail.yahoo.com> <20240123110624.1b625180@firefly>
Subject: Re: Requesting help recovering my array
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Mailer: WebService/1.1.22027 YMailNorrin

Thanks.=C2=A0 All drives in the system are being detected (/dev/sdd is my s=
ystem drive - the rest are all of the array):

rj@jackie:~$ ls -l /dev/sd*
brw-rw---- 1 root disk 8, =C2=A00 Jan 21 19:08 /dev/sda
brw-rw---- 1 root disk 8, =C2=A01 Jan 21 19:08 /dev/sda1
brw-rw---- 1 root disk 8, 16 Jan 21 19:08 /dev/sdb
brw-rw---- 1 root disk 8, 17 Jan 21 19:08 /dev/sdb1
brw-rw---- 1 root disk 8, 32 Jan 21 19:08 /dev/sdc
brw-rw---- 1 root disk 8, 48 Jan 21 19:08 /dev/sdd
brw-rw---- 1 root disk 8, 49 Jan 21 19:08 /dev/sdd1
brw-rw---- 1 root disk 8, 50 Jan 21 19:08 /dev/sdd2
brw-rw---- 1 root disk 8, 53 Jan 21 19:08 /dev/sdd5
brw-rw---- 1 root disk 8, 54 Jan 21 19:08 /dev/sdd6
brw-rw---- 1 root disk 8, 55 Jan 21 19:08 /dev/sdd7
brw-rw---- 1 root disk 8, 56 Jan 21 19:08 /dev/sdd8
brw-rw---- 1 root disk 8, 64 Jan 21 19:08 /dev/sde
brw-rw---- 1 root disk 8, 65 Jan 21 19:08 /dev/sde1
brw-rw---- 1 root disk 8, 80 Jan 21 19:08 /dev/sdf
brw-rw---- 1 root disk 8, 81 Jan 21 19:08 /dev/sdf1
brw-rw---- 1 root disk 8, 96 Jan 21 19:08 /dev/sdg
brw-rw---- 1 root disk 8, 97 Jan 21 19:08 /dev/sdg1


The devices are not listed in the mdadm.conf, nor were they ever.=C2=A0 Her=
e's everything that's not commented out in that file:









On Tuesday, January 23, 2024 at 11:06:30 AM EST, David Niklas <simd@vfemail=
.net> wrote:=20





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
> > [raid4] [raid10] unused devices: <none>=C2=A0=20
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
> > Am 22.01.24 um 20:52 schrieb RJ Marquette:=C2=A0=20
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
> >> my desktop and moved the guts to my server).=C2=A0 I never disconnecte=
d
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
> >> 2.0 x1 4-port SATA 6 Gb/s Controller (rev 11) =E2=94=9Cscsi 6:0:0:0 AT=
A
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
> >> UUID=3D74a11272:9b233a5b:2506f763:27693cccr=C2=A0=20
>=20

