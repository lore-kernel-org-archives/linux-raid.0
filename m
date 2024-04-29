Received: from mail.minuette.net (mail.minuette.net [198.50.230.214])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8EF833F6
	for <linux-raid@vger.kernel.org>; Mon, 29 Apr 2024 06:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.50.230.214
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714372766; cv=none; b=ozErpxJQBfBQxPeADy63y78p6SRI1DAfizSxtAxFrQIARl5Gan1zRVipDw+qO7Pimx7l7FVvb8ukjR0dM4bxqoSCX0+kzJ7q+9OQs7dP2wL8KVD+/tSk7c8g50dSbFCRWtE4oasghpnIfvzbHP4NOuHFSayfbSUw45/ctYal2Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714372766; c=relaxed/simple;
	bh=q0se6dDlBp31OUIAXuKYQTe5rM2LiClFelNRM4+gbY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UkQ17Adyzx6G7jDzewnSmdGESOwxyzS4ll+PjLrRhGZCxdu332n3FevMLadZ8Utx959tRn10gXTp0sVCj3HIEsOPsUIWmXBKW7F1CyVj6gQvo+CK05lcxZcuNwbP77l5VFp2aPJ2EximsTE2tc37BVjXiPsiIISDw6rprZ6JgY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=minuette.net; spf=pass smtp.mailfrom=minuette.net; dkim=pass (4096-bit key) header.d=minuette.net header.i=@minuette.net header.b=FfcWH9X+; arc=none smtp.client-ip=198.50.230.214
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=minuette.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=minuette.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=minuette.net header.i=@minuette.net header.b="FfcWH9X+"
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.minuette.net 291A763C8E98
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=minuette.net;
	s=default; t=1714372763;
	bh=FAPpsZRiTRezSrzJ65psvbxFhbDBGrOaR8YKInT6Suk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FfcWH9X+kwk8tjQL6O54TiWCPFaLx+TyPjkiOcfgQ9ZVcZB6RxoOC6y1IP7WRptfh
	 pvVggEGsNNQqULtoQD6dZY+Wm5VIRQj+LYvxKxMDYl/j7r6KaG5XNGy45MMBNvvy5P
	 YDefsDnaP8QeOc0uQlyFRIl/OLPG2dMIHCV67XqYT6TiXmVGDuiE9y61XZpKZlzHj4
	 0jgtCPPbCvTGKirdBvY0O+7S8aJkPM0MetU72i4TCu5UuByi0dTl7i1rl8tYie5cnb
	 WJy8yuvobt+rpTh0JKywPgxfn8Ko0Gg+77uP8UvgOeT3e9///9Yc1cVJc2Ql7yn6MO
	 qnmh7MwI28uFAYt2EUHIvzHbZl2+b89IbiZhMWv/5XsyVsSTldHn5Cj29W3M1t4b4E
	 JZlhEmps4mQGt2zCxc8PKwL2IIBth4x8JaOsQcfzMsP35R4rp9vt2jWnpMkBh7wOFP
	 VXWAAmaAOgBHP7/TLW7HHvy10elROksuPGqoo308fv5kqCpgpAqlVnHx7D1MtoJRpT
	 4zeKrQd8phtw7lvhesAurz1+xoz3VAKLTnAc8jFRWdQ8cmW+TxKX5+2eaSatKYJh1d
	 hN1SCP3aX12wQlNb4yKso9Di4Dk4re47Sk3PV4k6d5V05JmD3SoPlX1A6x/jnvCJMS
	 JgoX3U2GLigah/f7g99g8GE0=
From: Colgate Minuette <rabbit@minuette.net>
To: linux-raid@vger.kernel.org, Yu Kuai <yukuai1@huaweicloud.com>,
 Yu Kuai <yukuai3@huawei.com>
Cc: "yangerkun@huawei.com" <yangerkun@huawei.com>
Subject: Re: General Protection Fault in md raid10
Date: Sun, 28 Apr 2024 23:39:21 -0700
Message-ID: <2932875.e9J7NaK4W3@sparkler>
In-Reply-To: <90f685e1-9c55-d9c5-79d4-9ef354b3b703@huawei.com>
References:
 <8365123.T7Z3S40VBb@sparkler> <12425258.O9o76ZdvQC@sparkler>
 <90f685e1-9c55-d9c5-79d4-9ef354b3b703@huawei.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"

On Sunday, April 28, 2024 11:06:51 PM PDT Yu Kuai wrote:
> Hi,
>=20
> =E5=9C=A8 2024/04/29 12:30, Colgate Minuette =E5=86=99=E9=81=93:
> > On Sunday, April 28, 2024 8:12:01 PM PDT Yu Kuai wrote:
> >> Hi,
> >>=20
> >> =E5=9C=A8 2024/04/29 10:18, Colgate Minuette =E5=86=99=E9=81=93:
> >>> On Sunday, April 28, 2024 6:02:30 PM PDT Yu Kuai wrote:
> >>>> Hi,
> >>>>=20
> >>>> =E5=9C=A8 2024/04/29 3:41, Colgate Minuette =E5=86=99=E9=81=93:
> >>>>> Hello all,
> >>>>>=20
> >>>>> I am trying to set up an md raid-10 array spanning 8 disks using the
> >>>>> following command
> >>>>>=20
> >>>>>> mdadm --create /dev/md64 --level=3D10 --layout=3Do2 -n 8
> >>>>>> /dev/sd[efghijkl]1
> >>>>>=20
> >>>>> The raid is created successfully, but the moment that the newly
> >>>>> created
> >>>>> raid starts initial sync, a general protection fault is issued. This
> >>>>> fault happens on kernels 6.1.85, 6.6.26, and 6.8.5 using mdadm vers=
ion
> >>>>> 4.3. The raid is then completely unusable. After the fault, if I try
> >>>>> to
> >>>>> stop the raid using>
> >>>>>=20
> >>>>>> mdadm --stop /dev/md64
> >>>>>=20
> >>>>> mdadm hangs indefinitely.
> >>>>>=20
> >>>>> I have tried raid levels 0 and 6, and both work as expected without
> >>>>> any
> >>>>> errors on these same 8 drives. I also have a working md raid-10 on =
the
> >>>>> system already with 4 disks(not related to this 8 disk array).
> >>>>>=20
> >>>>> Other things I have tried include trying to create/sync the raid fr=
om
> >>>>> a
> >>>>> debian live environment, and using near/far/offset layouts, but both
> >>>>> methods came back with the same protection fault. Also ran a memory
> >>>>> test
> >>>>> on the computer, but did not have any errors after 10 passes.
> >>>>>=20
> >>>>> Below is the output from the general protection fault. Let me know =
of
> >>>>> anything else to try or log information that would be helpful to
> >>>>> diagnose.
> >>>>>=20
> >>>>> [   10.965542] md64: detected capacity change from 0 to 120021483520
> >>>>> [   10.965593] md: resync of RAID array md64
> >>>>> [   10.999289] general protection fault, probably for non-canonical
> >>>>> address
> >>>>> 0xd071e7fff89be: 0000 [#1] PREEMPT SMP NOPTI
> >>>>> [   11.000842] CPU: 4 PID: 912 Comm: md64_raid10 Not tainted
> >>>>> 6.1.85-1-MANJARO #1 44ae6c380f5656fa036749a28fdade8f34f2f9ce
> >>>>> [   11.001192] Hardware name: ASUS System Product Name/TUF GAMING
> >>>>> X670E-PLUS WIFI, BIOS 1618 05/18/2023
> >>>>> [   11.001482] RIP: 0010:bio_copy_data_iter+0x187/0x260
> >>>>> [   11.001756] Code: 29 f1 4c 29 f6 48 c1 f9 06 48 c1 fe 06 48 c1 e1
> >>>>> 0c
> >>>>> 48
> >>>>> c1 e6 0c 48 01 e9 48 01 ee 48 01 d9 4c 01 d6 83 fa 08 0f 82 b0 fe ff
> >>>>> ff
> >>>>> <48> 8b 06 48 89 01 89 d0 48 8b 7c 06 f8 48 89 7c 01 f8 48 8d 79 08
> >>>>> [   11.002045] RSP: 0018:ffffa838124ffd28 EFLAGS: 00010216
> >>>>> [   11.002336] RAX: ffffca0a84195a80 RBX: 0000000000000000 RCX:
> >>>>> ffff89be8656a000 [   11.002628] RDX: 0000000000000642 RSI:
> >>>>> 000d071e7fff89be RDI: ffff89beb4039df8 [   11.002922] RBP:
> >>>>> ffff89bd80000000 R08: ffffa838124ffd74 R09: ffffa838124ffd60 [
> >>>>> 11.003217] R10: 00000000000009be R11: 0000000000002000 R12:
> >>>>> ffff89be8bbff400 [   11.003522] R13: ffff89beb4039a00 R14:
> >>>>> ffffca0a80000000 R15: 0000000000001000 [   11.003825] FS:
> >>>>> 0000000000000000(0000) GS:ffff89c5b8700000(0000) knlGS:
> >>>>> 0000000000000000
> >>>>> [   11.004126] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >>>>> [   11.004429] CR2: 0000563308baac38 CR3: 000000012e900000 CR4:
> >>>>> 0000000000750ee0
> >>>>> [   11.004737] PKRU: 55555554
> >>>>> [   11.005040] Call Trace:
> >>>>> [   11.005342]  <TASK>
> >>>>> [   11.005645]  ? __die_body.cold+0x1a/0x1f
> >>>>> [   11.005951]  ? die_addr+0x3c/0x60
> >>>>> [   11.006256]  ? exc_general_protection+0x1c1/0x380
> >>>>> [   11.006562]  ? asm_exc_general_protection+0x26/0x30
> >>>>> [   11.006865]  ? bio_copy_data_iter+0x187/0x260
> >>>>> [   11.007169]  bio_copy_data+0x5c/0x80
> >>>>> [   11.007474]  raid10d+0xcad/0x1c00 [raid10
> >>>>> 1721e6c9d579361bf112b0ce400eec9240452da1]
> >>>>=20
> >>>> Can you try to use addr2line or gdb to locate which this code line
> >>>> is this correspond to?
> >>>>=20
> >>>> I never see problem like this before... And it'll be greate if you
> >>>> can bisect this since you can reporduce this problem easily.
> >>>>=20
> >>>> Thanks,
> >>>> Kuai
> >>>=20
> >>> Can you provide guidance on how to do this? I haven't ever debugged
> >>> kernel
> >>> code before. I'm assuming this would be in the raid10.ko module, but
> >>> don't
> >>> know where to go from there.
> >>=20
> >> For addr2line, you can gdb raid10.ko, then:
> >>=20
> >> list *(raid10d+0xcad)
> >>=20
> >> and gdb vmlinux:
> >>=20
> >> list *(bio_copy_data_iter+0x187)
> >>=20
> >> For git bisect, you must find a good kernel version, then:
> >>=20
> >> git bisect start
> >> git bisect bad v6.1
> >> git bisect good xxx
> >>=20
> >> Then git will show you how many steps are needed and choose a commit f=
or
> >> you, after compile and test the kernel:
> >>=20
> >> git bisect good/bad
> >>=20
> >> Then git will do the bisection based on your test result, at last
> >> you will get a blamed commit.
> >>=20
> >> Thanks,
> >> Kuai
> >=20
> > I don't know of any kernel that is working for this, every setup I've
> > tried
> > has had the same issue.
>=20
> This's really wried, is this the first time you ever using raid10? Did
> you try some older kernel like v5.10 or v4.19?
>=20

I have been using md raid10 on this system for about 10 years with a differ=
ent=20
set of disks with no issues. The other raid10 that is in place is SATA driv=
es,=20
but I have created and tested a raid10 with different SAS drives on this=20
system, and had no issues with that test.

These Samsung SSDs are a new addition to the system. I'll try the raid10 on=
=20
4.19.307 and 5.10.211 as well, since those are in my distro's repos.

=2DColgate

> > (gdb) list *(raid10d+0xa52)
> > 0x6692 is in raid10d (drivers/md/raid10.c:2480).
> > 2475    in drivers/md/raid10.c
> >=20
> > (gdb) list *(bio_copy_data_iter+0x187)
> > 0xffffffff814c3a77 is in bio_copy_data_iter (block/bio.c:1357).
> > 1352    in block/bio.c
>=20
> Thanks for this, I'll try to take a look at related code.
>=20
> Kuai
>=20
> > uname -a
> > Linux debian 6.1.0-18-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.1.76-1
> > (2024-02-01) x86_64 GNU/Linux
> >=20
> > -Colgate
> >=20





