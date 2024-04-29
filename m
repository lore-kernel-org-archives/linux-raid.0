Received: from mail.minuette.net (mail.minuette.net [198.50.230.214])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB647F
	for <linux-raid@vger.kernel.org>; Mon, 29 Apr 2024 02:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.50.230.214
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714357102; cv=none; b=F+GtspxXEH+EAyS8I33yFKlA9DgJwZC/drGHt1z0FSBJzbZ36yAPxdgN/Rl9XXFn6eSpNykn4AO7cRGeUCq+uWscsJWZbvc2mL2Kg4eu3Pgk7zaucRlLl4706u5GeVq+X8AWcp/7LA7dAKDlbnVnPUEQI7mLm6GLF/gtlUr1UEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714357102; c=relaxed/simple;
	bh=sz/nOHZeAFNi/vq0crBhDYgNuWmeJn7MD6UdmUuQVBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oK9XpEYH1x6OXgBNuPz4GFnBpdk2l3BPm4xqsjjKXok4S1w2980Pt8IHfCuElIPHwJ0BOFWVGzAOI9C+WnO47sXOsgwMLn6CQkX5+lM9Zu2A3Jjse+uwVNucZsb4jQFGlHUJyNd74K2SPo/GkAqxtOEIvRQ55tau6gViDRs/EBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=minuette.net; spf=pass smtp.mailfrom=minuette.net; dkim=pass (4096-bit key) header.d=minuette.net header.i=@minuette.net header.b=ZTddHNgh; arc=none smtp.client-ip=198.50.230.214
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=minuette.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=minuette.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=minuette.net header.i=@minuette.net header.b="ZTddHNgh"
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.minuette.net 5BA3563C8E8F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=minuette.net;
	s=default; t=1714357098;
	bh=wYWPk2mCp4n2pb3x/3qllQRbARV309x5m9A6bs6UW4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZTddHNghVqQEg9Q4OExk8+D3bD1dqwbFhB0Q/dqWGOZZlj4xO2TaVS7AZNLsGWipm
	 kY7O6pcacdyD3ojJ6D+rzuzymt3mnrF9wx7gOcqJEs51RBzTRYtSwYoRWvRrg30s3Q
	 vQ7Wkg/UhV92NeP6sqyoF9/xMoUBHQD8UrY3nVGREbjVkXg6ErfelZZFrpg/pTdNTv
	 WEUAR1kmlmUQpg5togYQNK6aCAknBb/zCNSXw4mGgav0/jpnkgPhqnRR+q46y+zv+0
	 8E5sXAj/Rb6yemgO71NDe9h3uGl6aKyuyaF/cYCXtM8+tMu+/mRbOsawoPP6FwMoPG
	 yKswg/SSbuippqRvKlBVxnp1mACO/Zv4WI9nTRFPHJRGip1bf60gvyU5wCDz5SxkDz
	 oCVg5Leb1QQf4GobZ0ALCvHE0ZggL45kPtSIb7H7XswwslWyqKcTl5Nw64f5VEbL3A
	 SpqH/0jpSej9CynVFXi92hHfO0DMlG/BHfSY5tEWX0EAM+m/azwZ2VYvyHvGO/DYpo
	 s8Xd4H0FKXas3UkR6rzFCW4+q+xMTYcsVWlZGIV/oIFTYq3bpfywpCWTBKMnQ2/1NU
	 gxm94/L2ZOMPvGsSqcNs52QMk6RB6KuQSwcWSrZ6FSajmtbt3eldN8mhVsb3hkWKNI
	 /0FpYKyazeZADPBwutr//ARM=
From: Colgate Minuette <rabbit@minuette.net>
To: linux-raid@vger.kernel.org, Yu Kuai <yukuai1@huaweicloud.com>
Cc: "yukuai (C)" <yukuai3@huawei.com>,
 "yangerkun@huawei.com" <yangerkun@huawei.com>
Subject: Re: General Protection Fault in md raid10
Date: Sun, 28 Apr 2024 19:18:16 -0700
Message-ID: <4561772.LvFx2qVVIh@sparkler>
In-Reply-To: <208eb375-4859-3b32-59d6-7243f9892f1e@huaweicloud.com>
References:
 <8365123.T7Z3S40VBb@sparkler>
 <208eb375-4859-3b32-59d6-7243f9892f1e@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"

On Sunday, April 28, 2024 6:02:30 PM PDT Yu Kuai wrote:
> Hi,
>=20
> =E5=9C=A8 2024/04/29 3:41, Colgate Minuette =E5=86=99=E9=81=93:
> > Hello all,
> >=20
> > I am trying to set up an md raid-10 array spanning 8 disks using the
> > following command
> >=20
> >> mdadm --create /dev/md64 --level=3D10 --layout=3Do2 -n 8 /dev/sd[efghi=
jkl]1
> >=20
> > The raid is created successfully, but the moment that the newly created
> > raid starts initial sync, a general protection fault is issued. This
> > fault happens on kernels 6.1.85, 6.6.26, and 6.8.5 using mdadm version
> > 4.3. The raid is then completely unusable. After the fault, if I try to
> > stop the raid using>=20
> >> mdadm --stop /dev/md64
> >=20
> > mdadm hangs indefinitely.
> >=20
> > I have tried raid levels 0 and 6, and both work as expected without any
> > errors on these same 8 drives. I also have a working md raid-10 on the
> > system already with 4 disks(not related to this 8 disk array).
> >=20
> > Other things I have tried include trying to create/sync the raid from a
> > debian live environment, and using near/far/offset layouts, but both
> > methods came back with the same protection fault. Also ran a memory test
> > on the computer, but did not have any errors after 10 passes.
> >=20
> > Below is the output from the general protection fault. Let me know of
> > anything else to try or log information that would be helpful to
> > diagnose.
> >=20
> > [   10.965542] md64: detected capacity change from 0 to 120021483520
> > [   10.965593] md: resync of RAID array md64
> > [   10.999289] general protection fault, probably for non-canonical
> > address
> > 0xd071e7fff89be: 0000 [#1] PREEMPT SMP NOPTI
> > [   11.000842] CPU: 4 PID: 912 Comm: md64_raid10 Not tainted
> > 6.1.85-1-MANJARO #1 44ae6c380f5656fa036749a28fdade8f34f2f9ce
> > [   11.001192] Hardware name: ASUS System Product Name/TUF GAMING
> > X670E-PLUS WIFI, BIOS 1618 05/18/2023
> > [   11.001482] RIP: 0010:bio_copy_data_iter+0x187/0x260
> > [   11.001756] Code: 29 f1 4c 29 f6 48 c1 f9 06 48 c1 fe 06 48 c1 e1 0c=
 48
> > c1 e6 0c 48 01 e9 48 01 ee 48 01 d9 4c 01 d6 83 fa 08 0f 82 b0 fe ff ff
> > <48> 8b 06 48 89 01 89 d0 48 8b 7c 06 f8 48 89 7c 01 f8 48 8d 79 08
> > [   11.002045] RSP: 0018:ffffa838124ffd28 EFLAGS: 00010216
> > [   11.002336] RAX: ffffca0a84195a80 RBX: 0000000000000000 RCX:
> > ffff89be8656a000 [   11.002628] RDX: 0000000000000642 RSI:
> > 000d071e7fff89be RDI: ffff89beb4039df8 [   11.002922] RBP:
> > ffff89bd80000000 R08: ffffa838124ffd74 R09: ffffa838124ffd60 [ =20
> > 11.003217] R10: 00000000000009be R11: 0000000000002000 R12:
> > ffff89be8bbff400 [   11.003522] R13: ffff89beb4039a00 R14:
> > ffffca0a80000000 R15: 0000000000001000 [   11.003825] FS:=20
> > 0000000000000000(0000) GS:ffff89c5b8700000(0000) knlGS: 0000000000000000
> > [   11.004126] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [   11.004429] CR2: 0000563308baac38 CR3: 000000012e900000 CR4:
> > 0000000000750ee0
> > [   11.004737] PKRU: 55555554
> > [   11.005040] Call Trace:
> > [   11.005342]  <TASK>
> > [   11.005645]  ? __die_body.cold+0x1a/0x1f
> > [   11.005951]  ? die_addr+0x3c/0x60
> > [   11.006256]  ? exc_general_protection+0x1c1/0x380
> > [   11.006562]  ? asm_exc_general_protection+0x26/0x30
> > [   11.006865]  ? bio_copy_data_iter+0x187/0x260
> > [   11.007169]  bio_copy_data+0x5c/0x80
> > [   11.007474]  raid10d+0xcad/0x1c00 [raid10
> > 1721e6c9d579361bf112b0ce400eec9240452da1]
>=20
> Can you try to use addr2line or gdb to locate which this code line
> is this correspond to?
>=20
> I never see problem like this before... And it'll be greate if you
> can bisect this since you can reporduce this problem easily.
>=20
> Thanks,
> Kuai
>=20

Can you provide guidance on how to do this? I haven't ever debugged kernel=
=20
code before. I'm assuming this would be in the raid10.ko module, but don't=
=20
know where to go from there.

=2DColgate=20


