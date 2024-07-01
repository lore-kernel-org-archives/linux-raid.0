Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1296184037
	for <linux-raid@vger.kernel.org>; Mon,  1 Jul 2024 08:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719823921; cv=none; b=KSnFblSERXsVngypx6Jnub+iN1HQK5TalDl3xxEUgFV3jYXuoFtnaqkb7bul7f6/xhJiiBfIrYK7dy1KIF6JJNuW3HDrXCrWXVmVXZuLDYpZczeUXhOEYfelLXTDKMczopCEdc0NNYL6z9rez2q7lvoe5DYol3Fkb2+iCtUBeEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719823921; c=relaxed/simple;
	bh=UKFIZFDbeWbb1Qr5xG+eBhA8u5Yjf2lR9C249M/ruRg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UcKCRy0uV5Tk+m70mP0wjPJlVM7pE+rcnkuxAZFsdjHBMpcCKIP7puby7eDB7qocf05IEGEicX++O79alKOf0woWizGuprtlQjFM8qb6ewgBbazia5+iIPxhz9JCLwZZwBME6xefTeeMKa8AE1JHk9IixOvm3GIjT69uFJoG+dA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aFAXQCVy; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aFAXQCVy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719823920; x=1751359920;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UKFIZFDbeWbb1Qr5xG+eBhA8u5Yjf2lR9C249M/ruRg=;
  b=aFAXQCVyNgKQhm/vCc0TD+pf9GxQuRjPIg0W7IRIJepXaOSAR6EPtFtV
   +TaoNLbaCY7/6CcBgYuPWNxTynWLSQyqvPYuES0B3QoBFm5Buu+4gOcfQ
   9K4KdS55oSdONsvIGOlrdq7s3fA9eLT+IWto93eqBik33M7oCe3LaT9mQ
   OnY9PRKv1D5htjgkuILzsM+J4PJ9vx4ohFeBfjZNvJGYntrc/jdzj7ZfY
   C7YmFzzmKu8G4SD9U997KNwq0tZOd3HhbpFhE4haMTi2huzktpzAidohT
   0NB0QrTz/vmah7w4pHxV7Afbp903L/8WOtAb+eVXICyU6RQWbf/nsI3p+
   A==;
X-CSE-ConnectionGUID: irCdOV3cRl6I8Elf9d06kA==
X-CSE-MsgGUID: gpKLTsgyRNaCIzOKXNeN7Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11119"; a="16757259"
X-IronPort-AV: E=Sophos;i="6.09,175,1716274800"; 
   d="scan'208";a="16757259"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2024 01:52:00 -0700
X-CSE-ConnectionGUID: j4HWSp/JRcCYfKyWOyR5tA==
X-CSE-MsgGUID: ziQPSf1ySru4ZrlMz7NrPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,175,1716274800"; 
   d="scan'208";a="45549348"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.237.142.70])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2024 01:51:58 -0700
Date: Mon, 1 Jul 2024 10:51:53 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Adam Niescierowicz <adam.niescierowicz@justnet.pl>
Cc: linux-raid@vger.kernel.org
Subject: Re: RAID6 12 device assemble force failure
Message-ID: <20240701105153.000066f3@linux.intel.com>
In-Reply-To: <56a413f1-6c94-4daf-87bc-dc85b9b87c7a@justnet.pl>
References: <56a413f1-6c94-4daf-87bc-dc85b9b87c7a@justnet.pl>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello Adam,
I hope you have backup! Citation from raid wiki linked below:

"Remember, RAID is not a backup! If you lose redundancy, you need to take a
backup!"

I'm not native raid expert but I will try to give you some clues.

On Sat, 29 Jun 2024 17:17:54 +0200
Adam Niescierowicz <adam.niescierowicz@justnet.pl> wrote:

> Hi,
>=20
> i have raid 6 array on 12 disk attached via external SAS backplane=20
> connected by 4 luns to the server. After some problems with backplane=20
> when 3 disk went offline (in one second) and array stop.
>=20

And raid is considered as failed by mdadm and it is persistent with state of
the devices in metadata.

>  =A0=A0 Device Role : spare
>  =A0=A0 Array State : AAAAA.AA.A.A ('A' =3D=3D active, '.' =3D=3D missing=
, 'R' =3D=3D=20
> replacing)

3 missing =3D failed raid 6 array.

> I think the problem is that disk are recognised as spare, but why?

Because mdadm cannot trust them because they are reported as "missing" so t=
hey
are not configured as raid devices (spare is default state).

> I tried with `mdadm --assemble --force --update=3Dforce-no-bbl=20

It remove badblocks but not revert devices from "missing" to "active".

> /dev/sd{q,p,o,n,m,z,y,z,w,t,s,r}1` and now mdam -E shows
>=20
>=20
> ---
>=20
>  =A0=A0=A0=A0=A0=A0=A0=A0=A0 Magic : a92b4efc
>  =A0=A0=A0=A0=A0=A0=A0 Version : 1.2
>  =A0=A0=A0 Feature Map : 0x1
>  =A0=A0=A0=A0 Array UUID : f8fb0d5d:5cacae2e:12bf1656:18264fb5
>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Name : backup:card1port1chassis2
>  =A0 Creation Time : Tue Jun 18 20:07:19 2024
>  =A0=A0=A0=A0 Raid Level : raid6
>  =A0=A0 Raid Devices : 12
>=20
>  =A0Avail Dev Size : 39063382016 sectors (18.19 TiB 20.00 TB)
>  =A0=A0=A0=A0 Array Size : 195316910080 KiB (181.90 TiB 200.00 TB)
>  =A0=A0=A0 Data Offset : 264192 sectors
>  =A0=A0 Super Offset : 8 sectors
>  =A0=A0 Unused Space : before=3D264104 sectors, after=3D0 sectors
>  =A0=A0=A0=A0=A0=A0=A0=A0=A0 State : clean
>  =A0=A0=A0 Device UUID : e726c6bc:11415fcc:49e8e0a5:041b69e4
>=20
> Internal Bitmap : 8 sectors from superblock
>  =A0=A0=A0 Update Time : Fri Jun 28 22:21:57 2024
>  =A0=A0=A0=A0=A0=A0 Checksum : 9ad1554c - correct
>  =A0=A0=A0=A0=A0=A0=A0=A0 Events : 48640
>=20
>  =A0=A0=A0=A0=A0=A0=A0=A0 Layout : left-symmetric
>  =A0=A0=A0=A0 Chunk Size : 512K
>=20
>  =A0=A0 Device Role : spare
>  =A0=A0 Array State : AAAAA.AA.A.A ('A' =3D=3D active, '.' =3D=3D missing=
, 'R' =3D=3D=20
> replacing)
> ---
>=20
>=20
> What can I do to start this array?

 You may try to add them manually. I know that there is
--re-add functionality but I've never used it. Maybe something like that wo=
uld
work:
#mdadm --remove /dev/md126 <failed drive>
#mdadm --re-add /dev/md126 <failed_drive>

If you will recover one drive this way, array should start but data might b=
e not
consistent, please be aware of that!

Drive should be restored to sync state in details.

I highly advice you to simulate this scenario on not infrastructure
critical setup. As i said, I'm not a native raid expert.

for more suggestions see:
https://raid.wiki.kernel.org/index.php/Replacing_a_failed_drive

Thanks,
Mariusz
