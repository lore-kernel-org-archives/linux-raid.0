Received: from sonic306-2.consmr.mail.bf2.yahoo.com (sonic306-2.consmr.mail.bf2.yahoo.com [74.6.132.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F27A63513
	for <linux-raid@vger.kernel.org>; Tue, 23 Jan 2024 16:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.6.132.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706026578; cv=none; b=fBPC4NwHQt5xzbZAj9VLdOVAZIHsBn02FLljC63F5Q7XqXh/R4Oo2XoZGFk6mmUZqmeAE2JPOPJLP/a8hKc8gVZFULocBzfGbbm/EPzf8xCNPfMillJtk1b3U72/qsWUmibR3o4MVYLjtR6FqFLeez9ky/u6P3XW0Z8XQePWHqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706026578; c=relaxed/simple;
	bh=M8Xd9Jg/bVvdf8GKswGem1cnbh0xsH6WdUG4FNu/dc8=;
	h=Date:From:To:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=HmlR6gCDas0eSe4ddqTS9nhNvm39F1W8gPogaKeCbZyrnqGuIHYsfyat12MUIhiiZ1Ki/RGiU46kSrBlcQuzpirzjuSDUFhl8PtRyfMmAxNJAvtJy1qb6RH6Dxa2jTb50qaa8TRqsRLQtAeTVTgpPUcbKWDch5pDWdAnPyr1Iww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com; spf=pass smtp.mailfrom=yahoo.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=cYI7IASr; arc=none smtp.client-ip=74.6.132.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="cYI7IASr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1706026575; bh=M8Xd9Jg/bVvdf8GKswGem1cnbh0xsH6WdUG4FNu/dc8=; h=Date:From:To:In-Reply-To:References:Subject:From:Subject:Reply-To; b=cYI7IASrmJ/zy7EJOOoZ7MtJsB/7gfX7/tmbflUaOYmCVX2BtIqObILXMdA+pONShmyce2H8cQWPRzIdil3SrKstjITAgjw9DQrTXq1h7zeWc0LUTNmnCacXbA8K4MuQlt4z5frdELBXeMM/rJ3wZxQNQrLDHkWs80ahsQCe9/3BGna7v5PyqDOInKIaqGQGaBgVxdzFRyU5gKM7fLv3j+2DEw43cFMvngcYOwhMb0OR/JyNtrlNJ3v5hBG/fjUBnSXZAy2y1r+03LYEgTXsl2/iZdu+Kq/U3npOf+hzvhChpWyyn6N5G0OohV08KhH8+BBnuNtVn1qC3iR21HmaGA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1706026575; bh=iqiPMjelbkygSQxD2B3thx7Fq+rzGytcCXGv3hPk15H=; h=X-Sonic-MF:Date:From:To:Subject:From:Subject; b=UM6UdEviO7stSaLBzCYZ+CSSlB6MSIYIjQrdf/0HqlsniXXGejT0huMDNUKdM1UtWfhrdSC/5I3sYsqkG9fQaIKSRtEITnmgSvAYzQkHKXUM1pmW69y7XzfAi0rBnDz+cvoaohoOGUdP9U65/rOT+db2EUrTc+CBZMZ+oLFd7W9Y+i9eevsqQ27BCKxajniIUebvnbQOZCpEXnGDVRCUykWJXmPAKizO2BYTM46DSgOyaFrhHj+yxwkwB1jTcdNOvNH2V8SLDqJySlFuZwg1/5KO0SvmE8X3dwxvlJxScT8YOlYI5K9SzGXwmAJXHZlPwOFkH14rZAXhagVHRMsp0w==
X-YMail-OSG: 2Y_3.Z0VM1mGTjlhzGCDZinhIv2wh.Pr6.BGR67E78eoOYALAeCNUEjyqyyO25F
 TGnoVii4X0ly23fLoG5hMYeREdCJce9o0lrQtdf93GueNLfN1WRrfdQjxpxqblMwcP3A.jKfOON0
 cbRrBjgBFK9q46.BeIBrvQaRPxUXucT6XPXrCi.bFcLTwoQzS1RQbNJdz9lhwP25uNo9JVlG2Phh
 Nn4.MhWwzNxOBBuKHOYRm82eWS2rVvjTJxQh3PCISzEWMUvRejMA6YnMuYTvcAAZSfp0atOXao_D
 qY.XC10LOT809fbz._pJp1I9JTE8gvLsJ2c54bssASVq9aEEDsdnbvQQQfl8ZuAM4too.aLPlEBy
 J8Cji3XXM255K3ACzooKHGWoc0PiHOlN6aqEIxnE_Xx0lYI2dOaCoYfTA18OFquGqNoJKTYxNj1K
 J.sAoSWhOYtHrIlR0WAXFSIDOWLt5UzRg_5ma7plNVr5HLoEAhiQfvCJ9krChGLmIHwnM_hfVdSw
 RGLWkpo1mkSnuEa8N0O56dUVvV7B1mEefNNewbLekPjgqQa_VaHQRoQA4YC_SOKr_leWMHYsy7Dg
 9.69oXiZKMZkr.jKdkHXokBhPrGFmSdnc5bBM7Vfq6kqoDwiORbBIoenJ_T5bfqpzxBPIH5g2P2e
 .syKsoYGEaFnzH4dONcaRs60lwBnnQDIcMPkKtZor5X5XB2wm_iDX8RC9_Yd2e0cL7ZUP1TkDbpQ
 bvhGW6SjTTrt7WAFyGWKk0kFQek.Wp8oUjwq3QR3m5cOERPnMZLRAVrBcumBZ9n6cgdWpgStBVSy
 MOTC8vY8U38rDRHUASKSLYr8cEpuRRwDzyTkPmOc.WB2soDRQ4lIExwMDILPBfUw0V7lSR_OY5mn
 XqnWuvnkCl1u45y2ifiug6xnsS5O2bC5fI.wSXR1q0oEOISUCAc_Td2su0Sc5ZmEmSe.da62ksI9
 z0Vu4b92YuDy25N1fI.DLt0FNw6B4N1TRgldgcBxNQQAKf7aYyuU1VhQElMzxd.cJSSDWSNNa7cv
 SJ.g3IKjBgS.m9pLwt2y4.Llv9O2oi1ADbSUXWKGRoX1GBOOnfw6pLfZkBFJEQTdGTCohmkpWQqv
 N8Ha9IMPhQenGJ4Ehvo6gZolSEFtstTK4lyEK0qXKI2R5vXjUrCqzLpCC39qiZgQigDtgbCz8DFo
 an3nlgz2dib.GUo1hjKcW.rSOeIpVp_vN8i2taTEmMaYpACsqXIQLpK6_9JvoJqTsy_J_VsfqvIm
 .86UZtFgE0tDdfArcSAKhoebYu.hrgv84fJ261mNHcTRFnk5pu9LiwiZIQ0Em9Vs_oO3W_XKjorV
 9kCrLK_EJLQj4ns2AZss722M6iC3CKIpp40hVif5ffmHE574IjKpFld.0LOHC6O0Us9aoCptFTzs
 VF8Z_6PMkBeuXmGZUMKYNDgs4VoHLfwrproP4hGPMoYMUP_BFbT0EOhwZ8gvvYM2mdyQKCeyzcJ5
 i5xgAL9e6uqC.M3bqnQ9aIReSCzbQebdO0V6wy80HSOIhiIGXoe34wXu3qgLZip_nb11g5a0XJiN
 VOBU9ZekJg_njxsNYnZGH7t.PvhSaK6T86jY8ujRjmtyyL1z6df5s0WKFfc5x32FzJr9WdakYHtX
 jhIJk5.XK0bwWucFWTHHnXwElAwjChCVZab4IbksNhetaNZymhzLdd3_pZReIos9wdRn2V5uSB0v
 _TjMZ7WY3gsS_9uNnDqj7ZlyI76hgVKIeKb8TbyPDNdyp8Y1ytuQb.W1E0L5DswK6DDSSdiZko5s
 GWw6GjjZ_ydKokex7_fBvpX5lPyMO98pR_q0f1guhjzRrpqVSnnmKQG8kFoaIcaRZBsY8ySL9DSa
 q78yWsiiuoxiiJTyeC5IzftHuIAjrdDPFGVxEHmkkKLDfVlttAqoW4HEk0EVjVpopX3HeIk2chGO
 Hpsg1AejA3mflu6OcKbQhzpyKtDYMyHv17G0MeWJWuFNxqi2zrQJcaISwY9sbVT1OVrZIeaFIowH
 zHE_s4C9u4c2i14nuxi4nDA2NyDKvphUrGrKHij7VOcsuJtaIFySPK3zRGTsTO.dgnngZP9RqYTJ
 .oZryp301LxqAg5d3Yq2JjJvyjvhMhYxGVnpFHraqk8cJmPz1YXPAexMnIAiOE.aivxQENvuDPvP
 KmddveGNJJN4BPX05yqwKmjvtpPj_OIK5u6iP7xeHoQC4
X-Sonic-MF: <rjm1@yahoo.com>
X-Sonic-ID: 878695c7-5a26-4734-be4b-b4c01995f879
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.bf2.yahoo.com with HTTP; Tue, 23 Jan 2024 16:16:15 +0000
Date: Tue, 23 Jan 2024 16:16:12 +0000 (UTC)
From: RJ Marquette <rjm1@yahoo.com>
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, 
	David Niklas <simd@vfemail.net>
Message-ID: <12445908.1094378.1706026572835@mail.yahoo.com>
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

(Sorry if this came through twice without the mdadm.conf contents, somehow =
I accidentally hit send when I was trying to paste in.)

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
e's everything (except the initial header comments about updating initramfs=
 and all) from that file:

# by default (built-in), scan all partitions (/proc/partitions) and all
# containers for MD superblocks. alternatively, specify devices to scan, us=
ing
# wildcards if desired.
#DEVICE partitions containers

# automatically tag new arrays as belonging to the local system
HOMEHOST <system>

# instruct the monitoring daemon where to send mail alerts
MAILADDR rj

# definitions of existing MD arrays
#ARRAY /dev/md/0=C2=A0 metadata=3D1.2 UUID=3D74a11272:9b233a5b:2506f763:276=
93ccc name=3Djackie:0

# This configuration was auto-generated on Wed, 27 Nov 2019 15:53:23 -0500 =
by mkconf
ARRAY /dev/md0 metadata=3D1.2 spares=3D1 name=3Djackie:0 UUID=3D74a11272:9b=
233a5b:2506f763:27693ccc


I assume that last line was added when I added the spare drive.=C2=A0 Shoul=
d I add the drives to the mdadm.conf then run the assemble command you sugg=
ested?

It's like mdadm was assembling them automatically upon bootup, but that sto=
pped working with the new motherboard for some reason.

Thanks.
--RJ






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
