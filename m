Received: from mail.minuette.net (mail.minuette.net [198.50.230.214])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F62A2907
	for <linux-raid@vger.kernel.org>; Mon, 29 Apr 2024 04:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.50.230.214
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714365016; cv=none; b=rVdNoft5uSyvud6OGGLY+AW1v1SbriJwebS4p3/40nYTVKwrwsIe307MItxJWpm0p8S4mlj5cAALGEbmuo7u3rM0Ktm8UIMMv5JnQy+XvyrBoYCbnD4XocHj4QUweLmX3R7KXuuIQjXICcn5v0P2CyfDEJXlMMckUilKeAnao+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714365016; c=relaxed/simple;
	bh=X0BrRYOT2GnD44fIBKNTMwYMDWswyGcuSteRty0xkQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xax8enN2uCVRrnaBtIWqGkTyn0uSSQReXvAL1Wdd3pu2TSnHFcY9ZnNj3XwjO7khygaZz+dAsP1mYip3Ssi77ZZrmlwTnv1BmBUs9d4A0zrRajKtrbI134paoCaaLcUphIZBHSzmby+wIo4DMHkLeJpmONwMC3NDYt/4ERujgwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=minuette.net; spf=pass smtp.mailfrom=minuette.net; dkim=pass (4096-bit key) header.d=minuette.net header.i=@minuette.net header.b=dH19cvqk; arc=none smtp.client-ip=198.50.230.214
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=minuette.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=minuette.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=minuette.net header.i=@minuette.net header.b="dH19cvqk"
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.minuette.net 57F8B63C8E97
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=minuette.net;
	s=default; t=1714365013;
	bh=tNZailOBeWPcvNk3CXv+6FxYkRRI4es3xjNVLU6HfTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dH19cvqkpFFZMB05tI3Yn4lBd+8mmuXKonv8faXces4CaLCzhmLTIyEi1/gwqzFcu
	 CiU/NIoIG8ve6WKoQEsv0Ua42I243NAJQI7m3iKXqSo7aHiF7MNngh/d+zD1Tp2NAL
	 wy2WOQFkdnlU4iDSash1pKXg5JYO8AyCJiwk4vLLSh2b1RaeXWWsDAxyFHNLCtTKdt
	 30GS9b/n/2ujaBl884PnDR88DC34mbL8HTTRYCjklEpvWJ87Kw0gLZ9HuMeXbe+136
	 jpSmm3Nhh04ttcwQD8ooGzSYnmE8DpxEP+CWDZvRaZrkapxWWHbA9nf8+DjSkmf3rL
	 UIl/8VVpq1aqE7QgPyhMdh4zHhDp7rIbE8GPON/3m2pp2mgYKkSJkM43BmlfkAuMD5
	 FjcZ3iD4JrnNFI0pAx6H/sndMJGzYh7pFf2zQPNZ+G6Ke9GsaQIjxamnAlQQfkOZFz
	 Z3aDyfLwYk/FlubQgBgNqXSlVs3FhFMOpU6//E0oRidgyp8ByKtpBNEhDWSf7zI63H
	 H8kLFKPj0uYP0ioSztuLoLv/vOGDaT5TyzYBD7tu9LAFfBXG5eMcmBwrSr/dbsdCk9
	 5aCmF3C1Qnsc42a88iQH5qdYzwDU1BhtjpbZr0p5NsIghJFIgKpPOdKugAqFlwOqOm
	 aJCT+zIUJ4OyP4M9T35wqRrY=
From: Colgate Minuette <rabbit@minuette.net>
To: linux-raid@vger.kernel.org, Yu Kuai <yukuai1@huaweicloud.com>,
 Yu Kuai <yukuai1@huaweicloud.com>
Cc: "yangerkun@huawei.com" <yangerkun@huawei.com>,
 "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: General Protection Fault in md raid10
Date: Sun, 28 Apr 2024 21:30:10 -0700
Message-ID: <12425258.O9o76ZdvQC@sparkler>
In-Reply-To: <8e23d023-bac2-e5a4-15a0-1636099b0cab@huaweicloud.com>
References:
 <8365123.T7Z3S40VBb@sparkler> <4561772.LvFx2qVVIh@sparkler>
 <8e23d023-bac2-e5a4-15a0-1636099b0cab@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"

On Sunday, April 28, 2024 8:12:01 PM PDT Yu Kuai wrote:
> Hi,
>=20
> =E5=9C=A8 2024/04/29 10:18, Colgate Minuette =E5=86=99=E9=81=93:
> > On Sunday, April 28, 2024 6:02:30 PM PDT Yu Kuai wrote:
> >> Hi,
> >>=20
> >> =E5=9C=A8 2024/04/29 3:41, Colgate Minuette =E5=86=99=E9=81=93:
> >>> Hello all,
> >>>=20
> >>> I am trying to set up an md raid-10 array spanning 8 disks using the
> >>> following command
> >>>=20
> >>>> mdadm --create /dev/md64 --level=3D10 --layout=3Do2 -n 8 /dev/sd[efg=
hijkl]1
> >>>=20
> >>> The raid is created successfully, but the moment that the newly creat=
ed
> >>> raid starts initial sync, a general protection fault is issued. This
> >>> fault happens on kernels 6.1.85, 6.6.26, and 6.8.5 using mdadm version
> >>> 4.3. The raid is then completely unusable. After the fault, if I try =
to
> >>> stop the raid using>
> >>>=20
> >>>> mdadm --stop /dev/md64
> >>>=20
> >>> mdadm hangs indefinitely.
> >>>=20
> >>> I have tried raid levels 0 and 6, and both work as expected without a=
ny
> >>> errors on these same 8 drives. I also have a working md raid-10 on the
> >>> system already with 4 disks(not related to this 8 disk array).
> >>>=20
> >>> Other things I have tried include trying to create/sync the raid from=
 a
> >>> debian live environment, and using near/far/offset layouts, but both
> >>> methods came back with the same protection fault. Also ran a memory t=
est
> >>> on the computer, but did not have any errors after 10 passes.
> >>>=20
> >>> Below is the output from the general protection fault. Let me know of
> >>> anything else to try or log information that would be helpful to
> >>> diagnose.
> >>>=20
> >>> [   10.965542] md64: detected capacity change from 0 to 120021483520
> >>> [   10.965593] md: resync of RAID array md64
> >>> [   10.999289] general protection fault, probably for non-canonical
> >>> address
> >>> 0xd071e7fff89be: 0000 [#1] PREEMPT SMP NOPTI
> >>> [   11.000842] CPU: 4 PID: 912 Comm: md64_raid10 Not tainted
> >>> 6.1.85-1-MANJARO #1 44ae6c380f5656fa036749a28fdade8f34f2f9ce
> >>> [   11.001192] Hardware name: ASUS System Product Name/TUF GAMING
> >>> X670E-PLUS WIFI, BIOS 1618 05/18/2023
> >>> [   11.001482] RIP: 0010:bio_copy_data_iter+0x187/0x260
> >>> [   11.001756] Code: 29 f1 4c 29 f6 48 c1 f9 06 48 c1 fe 06 48 c1 e1 =
0c
> >>> 48
> >>> c1 e6 0c 48 01 e9 48 01 ee 48 01 d9 4c 01 d6 83 fa 08 0f 82 b0 fe ff =
ff
> >>> <48> 8b 06 48 89 01 89 d0 48 8b 7c 06 f8 48 89 7c 01 f8 48 8d 79 08
> >>> [   11.002045] RSP: 0018:ffffa838124ffd28 EFLAGS: 00010216
> >>> [   11.002336] RAX: ffffca0a84195a80 RBX: 0000000000000000 RCX:
> >>> ffff89be8656a000 [   11.002628] RDX: 0000000000000642 RSI:
> >>> 000d071e7fff89be RDI: ffff89beb4039df8 [   11.002922] RBP:
> >>> ffff89bd80000000 R08: ffffa838124ffd74 R09: ffffa838124ffd60 [
> >>> 11.003217] R10: 00000000000009be R11: 0000000000002000 R12:
> >>> ffff89be8bbff400 [   11.003522] R13: ffff89beb4039a00 R14:
> >>> ffffca0a80000000 R15: 0000000000001000 [   11.003825] FS:
> >>> 0000000000000000(0000) GS:ffff89c5b8700000(0000) knlGS: 0000000000000=
000
> >>> [   11.004126] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >>> [   11.004429] CR2: 0000563308baac38 CR3: 000000012e900000 CR4:
> >>> 0000000000750ee0
> >>> [   11.004737] PKRU: 55555554
> >>> [   11.005040] Call Trace:
> >>> [   11.005342]  <TASK>
> >>> [   11.005645]  ? __die_body.cold+0x1a/0x1f
> >>> [   11.005951]  ? die_addr+0x3c/0x60
> >>> [   11.006256]  ? exc_general_protection+0x1c1/0x380
> >>> [   11.006562]  ? asm_exc_general_protection+0x26/0x30
> >>> [   11.006865]  ? bio_copy_data_iter+0x187/0x260
> >>> [   11.007169]  bio_copy_data+0x5c/0x80
> >>> [   11.007474]  raid10d+0xcad/0x1c00 [raid10
> >>> 1721e6c9d579361bf112b0ce400eec9240452da1]
> >>=20
> >> Can you try to use addr2line or gdb to locate which this code line
> >> is this correspond to?
> >>=20
> >> I never see problem like this before... And it'll be greate if you
> >> can bisect this since you can reporduce this problem easily.
> >>=20
> >> Thanks,
> >> Kuai
> >=20
> > Can you provide guidance on how to do this? I haven't ever debugged ker=
nel
> > code before. I'm assuming this would be in the raid10.ko module, but do=
n't
> > know where to go from there.
>=20
> For addr2line, you can gdb raid10.ko, then:
>=20
> list *(raid10d+0xcad)
>=20
> and gdb vmlinux:
>=20
> list *(bio_copy_data_iter+0x187)
>=20
> For git bisect, you must find a good kernel version, then:
>=20
> git bisect start
> git bisect bad v6.1
> git bisect good xxx
>=20
> Then git will show you how many steps are needed and choose a commit for
> you, after compile and test the kernel:
>=20
> git bisect good/bad
>=20
> Then git will do the bisection based on your test result, at last
> you will get a blamed commit.
>=20
> Thanks,
> Kuai
>=20

I don't know of any kernel that is working for this, every setup I've tried=
=20
has had the same issue.

(gdb) list *(raid10d+0xa52)
0x6692 is in raid10d (drivers/md/raid10.c:2480).
2475    in drivers/md/raid10.c

(gdb) list *(bio_copy_data_iter+0x187)
0xffffffff814c3a77 is in bio_copy_data_iter (block/bio.c:1357).
1352    in block/bio.c

uname -a
Linux debian 6.1.0-18-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.1.76-1=20
(2024-02-01) x86_64 GNU/Linux

=2DColgate



