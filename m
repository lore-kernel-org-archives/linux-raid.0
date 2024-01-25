Received: from sonic309-15.consmr.mail.bf2.yahoo.com (sonic309-15.consmr.mail.bf2.yahoo.com [74.6.129.125])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1227BEA9
	for <linux-raid@vger.kernel.org>; Thu, 25 Jan 2024 01:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.6.129.125
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706145203; cv=none; b=ojMDEb/SEoTy5xR9OFyUSVGX69S76E9UJHMo06oLBw+QCVIslm6ktmqXYaGRxfi+wcmB/c5rNY7iuKf6TX/trfYtsDrlJo0Q0R4XCOknVOWAQMv94GZxdV9cC1/hsYG7A4PLr3dIGFQoAiSbngZwEBue7PvS8ojuetuyt66+dTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706145203; c=relaxed/simple;
	bh=H1WZr4pGh9eNhFDKbn3aAGPOabP5WRJy+GQtY/dkrE0=;
	h=Date:From:To:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=egAVuNd0LmgUjNz6VJvCz75AomSOUqQ9BbkebNZsdCaWC/gzgJBXIoejbwHB4Rh/HUdP2WwuLWk/5uJDHuAuuYatV+fVBfpNPldq/fFHx1y56vftifce9U9mtB7XTdRsqKeH0yFMu9YmgLMnt20UCm2lGvu8sZJ1KoCRIEIX0bQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com; spf=pass smtp.mailfrom=yahoo.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=lvom/vl6; arc=none smtp.client-ip=74.6.129.125
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="lvom/vl6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1706145199; bh=H1WZr4pGh9eNhFDKbn3aAGPOabP5WRJy+GQtY/dkrE0=; h=Date:From:To:In-Reply-To:References:Subject:From:Subject:Reply-To; b=lvom/vl6MTYxA7/5pPgznfMd4PXaLzdwbSREwU5GzeBOdGiqib1Xb9DT//Fj33mxw2KQow1zskF01f4tQEekVhqQwVkjELHeTP/CfVvBvU4z1+WtUp0pw2DmFJc1kejNa0cddQ3NaE2q+tWT+O3RPIkk+1BAQqWTkDQtX9cofWmQBK8zd7rRXprXYXm3D9JCjEQ24vc2hQJfGG1N+OK1vPmBqAyKYCJMM0gySYuZbEvbTS9RBhhwWKImwaX3YpoUzi5cUp+sRGCT0/dfdXmUSV6pEjJrikUQPeD+yUpadMDESf4Ywa1cpg97FAADMLsamzSqHv6C5E1TtxzUd2fhig==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1706145199; bh=P0nhpx35hQlULv4UX5n5jtSknmd0I6zKfcxt7dlqinT=; h=X-Sonic-MF:Date:From:To:Subject:From:Subject; b=YDbQIIxteEZS/uk69PHZdoHGqWVGZn+Zpulvva6lRYbfz02T/b4rgpQMsD1hXsFHZVm2WVGVn5/yX/DdZAp9K/Xt6ayrtQJ2PXNLwfhfbKxSEkFx3QeuSXc44SfbL1jmWFyq+dY7d+tkAR3i+nn3y4QTZckJbksSvwFrfsn18H3xnU8LGfcCffUXofLR+D8Qimd7b7QKLIV6Dh/qSxB6nWWQd06I5OSQ10iPVjqW+dhtPqCrU5K3guy4UJ5oP63ODXi+DAmMTRu9XibSYh2SlyeekqUq1BnHDJ+cBN8CA5IGa77llwo1/21IKzVX+ZwDoHm9vnLxu86Jt5yYMYcRTg==
X-YMail-OSG: cvbHaf4VM1nRi3H972zhycA9FGY4uYDTFPcL5wMqwRJ_YnxZ5wKzfjVFSmtOXPC
 yRkUsDyliLTWLc5L0ieFryyi2LXdAryVgpKYcEP_3G6Ib5_5.Vba7iSTKDXJmlCgEGFyAkx5htL6
 _Tg_.DtEfVGnOQ9Pf.2zHjhErrX9FO2cl7HOBKY38t9eHI_PtKiZkqDTlQUyhMCThzzlXu1mL2um
 ZUHDg1OtBMtUydZ6GKGpHS4uJXQfqJU_789EmQt2FArrJaZ1xCNTs96apRDqNgCOoqZCOkoIztsh
 XhdrHvMXqGkXyQe356x13Kb3tb2DirxCyQpYdcLinh1N7SQxROR68lufvHtbFoV17rYEFlY9pv7q
 yUH1l3k3ppdVj0WiT.SDGypzbcV5.5UygmRNepZuwOkaCZwnVosM23OG_3pvdBF2AJSBWVt6ylE7
 KKcft.pdcube.nJoICmJOWjehikaQb.7FrBLvJhx6bbmFXJT1KUjMLy1Hff_8D37oxZ7o8GKfaZV
 PrlyyO2VK3HvK1ex1dVeFrrklvLdGnGxJzKZRI_NRPkE2X0TIMID6v2UucOSECIGLbTC_49jJlZj
 eeElkewYZvwY2JVW5ZWc6NOeWx1_UVBQIwddQioFwMV7V04OORThy_d_yjUnc3gmQL8p4v2fbjlH
 vWWSRoEI7UigXsNxEZYLumdubOe62Om3PWePEJPizrk2rN4bTiYI0364Fp9LLCy3rqbSBtATGNom
 DqFm630l8._VWitwgU3Jh_tI6hN7Gyka7K9rg6Vmqukf_jNX6dMgTJYFFFluJuNJNMZp4UNqUrAa
 Eacc._7vOwuGGxtE82iwMFg5ejXh2ThlRPxF5aaDU9WcvpRqodXetTJ97ZfG77Fqu5X065aouBVS
 0xpt3.7rMwarR0GU1PJm58l3U6kG_uDiwKvAHqesDGMmge5LrqsKhY3.ob.mzY3OqcsSS7AtI24Z
 jNw6EZOeyV_OjwniReLtOdZTUKvxkTarLL3PKKmKshEQPjj_xiXrP4BXpD1jhBg_l0JXo1GmD.Yr
 49bpbx0A7qAh91VA5wp8rzskvmGKA8eTSsub7iZB6WaIkTArsHGQdu0CqqXgg5Q0.SoEpMOtdvl3
 8JL3lXGRIsABpCXUPEcbIF5KhG5pl4cLt7_Mah6V8wtnRJIHqHFJHG.Cp_osjOlg2yXdPUwi1eLF
 QxS.zttr7wwuQ4eYzz8DzHLnOPi2HTreFfBJuvUB0AR12d8xWl3y3FkeNUFXzi.6kSfvWrW4u9EG
 2GQcBJT5DWLR2GH57l86_Z3ftdLZiBN6CqloaoeEAVnh036xBN35Dy8r4ea48TYCD2myJ_JRpKbV
 xGTZdNiM8z82SLASAy9JovNrEJJMX3x14YlEp8I2tq5XZJqFU7JzO5NVdBLR2Z_8Xsf1L61CyQ.T
 cQwewwlsUncl9ZjU5zwzYI2da7kchtYYx05qFfwLp1j1mGVo96JAYKcTZpN3lNciswk.D5O.9OBi
 1tF2CY.mhzVslIgtckaUSnQhRUKMjQmMaox2trIVpjirIwVo0LoSUdO3CBSSr7cJofccCWP9NpD3
 g1VybU.VYjDz_e39I1ptJ5E9nPM2Z26xE1DDC_4Z4.jUcmeIuxgfr7FOFNIzVHhKEE4VNOpOnoWU
 iVvYsDGrsfU.SH.IOx9P5yjJGcT2p.ouViR9ys1ncztRkmS0f3y6gUidlVUwgHpGKZTJsX.eECw_
 cS6EdAWEg0ZkkYTP6_q1pE_7uSeR9zUEUf.Ky9gsQiRNlvgd5BxkRqpCun7KdZmGZDrZE3P1wD4t
 vTopPoy6WNNXwF0TUsDDzupvpWTjfD6ks5a_rkluaPK58ygRa1.Hto04sgrgKH3DZWEQwRlGeEUq
 iyfDjwi9hZfgaZgwJIzBxCRgWBYwNtUYKE9M_jphlJun21nzn8RsTaDu4EsxQfQhdihwmnUDee48
 Da8qQK5JLqpWR2fvI5EffQkXy9L4vy28VQHt4piljAxVQnr9.z0o2lAHYnt5uo06.NXvDBFUzrsG
 sNDX6jC0iSCtMzy5pGERVf5i26WBvVudHy_ouQtplsmo8x3Sb_bNaAJFa8rZX096bM3byHpbVDfU
 S6Vqmv.NmNoyL266lhT4Gv.dn9t_ZNMPCWWtkBnkPJhZu38OnxvD6sb3bT.UJYl8cs2uHK.IeheK
 5b1f_a2D4gTLvT0hmV_8uhy4BphE74dMmTknHvzMj3P76XgNCYs1BHprfiMMaoDpXNlXeh7oCtA-
 -
X-Sonic-MF: <rjm1@yahoo.com>
X-Sonic-ID: cdfc6308-1a45-49e6-b399-4f802115f982
Received: from sonic.gate.mail.ne1.yahoo.com by sonic309.consmr.mail.bf2.yahoo.com with HTTP; Thu, 25 Jan 2024 01:13:19 +0000
Date: Thu, 25 Jan 2024 01:13:16 +0000 (UTC)
From: RJ Marquette <rjm1@yahoo.com>
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Message-ID: <5112393.323817.1706145196938@mail.yahoo.com>
In-Reply-To: <CAAMCDecCCCH9oOtx08g-yLwo_8JCHMkyUKu-f91du7O40wy+EA@mail.gmail.com>
References: <432300551.863689.1705953121879.ref@mail.yahoo.com> <432300551.863689.1705953121879@mail.yahoo.com> <04757cef-9edf-449a-93ab-a0534a821dc6@thelounge.net> <1085291040.906901.1705961588972@mail.yahoo.com> <0f28b23e-54f2-49ed-9149-87dbe3cffb30@thelounge.net> <598555968.936049.1705968542252@mail.yahoo.com> <755754794.951974.1705974751281@mail.yahoo.com> <20240123110624.1b625180@firefly> <12445908.1094378.1706026572835@mail.yahoo.com> <20240123221935.683eb1eb@firefly> <1979173383.106122.1706098632056@mail.yahoo.com> <006fe0ca-a2fb-4ccd-b4d4-c01945d72661@penguinpee.nl> <2058198167.201827.1706119581305@mail.yahoo.com> <CAAMCDef52pGpqOpOFRW8LAyiXtaJNzDderb7KLx8GR0BqP2epg@mail.gmail.com> <544664840.269616.1706131905741@mail.yahoo.com> <CAAMCDecCCCH9oOtx08g-yLwo_8JCHMkyUKu-f91du7O40wy+EA@mail.gmail.com>
Subject: Re: Requesting help recovering my array
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Mailer: WebService/1.1.22046 YMailNorrin

It looks like this is what happened after all.=C2=A0 I searched for "MBR Ma=
gic aa55" and found someone else with the same issue long ago:=C2=A0=C2=A0h=
ttps://serverfault.com/questions/580761/is-mdadm-raid-toast=C2=A0 Looks lik=
e his was caused by a RAID configuration option in BIOS.=C2=A0 I recall see=
ing that on mine; I must have activated it by accident when setting the boo=
t drive or something.=20

I swapped the old motherboard back in, no improvement, so I'm back to the n=
ew one.=C2=A0 I'm now running testdisk to see if I can repair the partition=
 table.

Thanks.
--RJ



On Wednesday, January 24, 2024 at 04:45:19 PM EST, Roger Heflin <rogerhefli=
n@gmail.com> wrote:=20





Well, if you have a /dev/sdb1 device and you think the mdadm device is
/dev/sdb (not sdb1) then SOMEONE added a partition table at some point
in time or you are confused what you mdadm device is.=C2=A0 if sdb is a
mdadm device and it has a partition table then mdadm --examine may see
the partition table and report that and STOP reporting anything else.

And note that that partition table could have been added at any point
in time since the prior reboot.=C2=A0 I have found (and fixed) ones that
were added years earlier and found on the next reboot for something
similar a year or 2 later.=C2=A0 On my own stuff before a hardware/mb
upgrade i will do a reboot to make sure that it reboots cleanly as all
sorts of stuff can happen (ie like initramfs/kernel=C2=A0 changes causing a
general failure to boot).

On Wed, Jan 24, 2024 at 3:31=E2=80=AFPM RJ Marquette <rjm1@yahoo.com> wrote=
:
>
> I didn't touch the drives.=C2=A0 I shut down the computer with everything=
 working fine, swapped motherboards, booted the new board, and discovered t=
his problem immediately when the computer failed to boot because the array =
wasn't up and running.=C2=A0 I definitely haven't run fdisk or other disk p=
artitioning programs on them.
>
> Other than the modifications to the mdadm.conf to describe the drives and=
 partitions (none of which have made any difference), I modified my fstab t=
o comment out the raid array so the computer would boot normally.=C2=A0 I'v=
e been trying to figure out what is going on ever since.=C2=A0 I've tried t=
o avoid doing anything that might write to the drives.
>
> I thought this upgrade would take an hour or two to swap hardware, not da=
ys of troubleshooting.=C2=A0 That was the advantage of software RAID, I tho=
ught.
>
> Thanks.
> --RJ
>
>
>
>
> On Wednesday, January 24, 2024 at 04:20:51 PM EST, Roger Heflin <rogerhef=
lin@gmail.com> wrote:
>
>
>
>
>
> Are you sure you did not partition devices that did not previously
> have partition tables?
>
> Partition tables will typically cause the under device (sda) to be
> ignored by all of tools since it should never having something else
> (except the partition table) on it.
>
> I have had to remove incorrectly added partition tables/blocks to make
> lvm and other tools again see the data.=C2=A0 Otherwise the tools ignore
> it.
>
> On Wed, Jan 24, 2024 at 12:06=E2=80=AFPM RJ Marquette <rjm1@yahoo.com> wr=
ote:
> >
> > Other than sdc (as you noted), the other array drives come back like th=
is:
> >
> > root@jackie:/etc/mdadm# mdadm --examine /dev/sda
> > /dev/sda:
> >=C2=A0 MBR Magic : aa55
> > Partition[0] :=C2=A0 4294967295 sectors at=C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 1 (type ee)
> >
> > root@jackie:/etc/mdadm# mdadm --examine /dev/sda1
> > mdadm: No md superblock detected on /dev/sda1.
> >
> >
> > Trying your other suggestion:
> > root@jackie:/etc/mdadm# mdadm --assemble /dev/md0 /dev/sdb1 /dev/sde1 /=
dev/sdf1 /dev/sdg1
> > mdadm: no recogniseable superblock on /dev/sdb1
> > mdadm: /dev/sdb1 has no superblock - assembly aborted
> >
> > root@jackie:/etc/mdadm# mdadm --assemble /dev/md0 /dev/sdb /dev/sde /de=
v/sdf /dev/sdg
> > mdadm: Cannot assemble mbr metadata on /dev/sdb
> > mdadm: /dev/sdb has no superblock - assembly aborted
> >
> >
> > Basically I've tried everything here:=C2=A0 https://raid.wiki.kernel.or=
g/index.php/Linux_Raid
> >
> > The impression I'm getting here is that we aren't really sure what the =
issue is.=C2=A0 I think tonight I'll play with some of the BIOS settings an=
d see if there's something in there.=C2=A0 If not I'll swap back to the old=
 motherboard and see what happens.
> >
> > Thanks.
> > --RJ
> >
> >
> >
> >
> >
> > On Wednesday, January 24, 2024 at 12:06:26 PM EST, Sandro <lists@pengui=
npee.nl> wrote:
> >
> >
> >
> >
> >
> > On 24-01-2024 13:17, RJ Marquette wrote:
> >
> > > When I try the command you suggested below, I get:
> > > root@jackie:/etc/mdadm# mdadm --assemble /dev/md0 /dev/sd{a,b,e,f,g}1
> > > mdadm: no recogniseable superblock on /dev/sda1
> > > mdadm: /dev/sda1 has no superblock - assembly aborted
> >
> >
> > Try `mdadm --examine` on every partition / drive that is giving you
> > trouble. Maybe you are remembering things wrong and the raid device is
> > /dev/sda and not /dev/sda1.
> >
> > You can also go through the entire list (/dev/sd*), you posted earlier.
> > There's no harm in running the command. It will look for the superblock
> > and tell you what has been found. This could provide the information yo=
u
> > need to assemble the array.
> >
> > Alternatively, leave sda1 out of the assembly and see if mdadm will be
> > able to partially assemble the array.
> >
> > -- Sandro
> >
>
