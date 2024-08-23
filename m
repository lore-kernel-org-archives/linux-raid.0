Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9216A143C5F
	for <linux-raid@vger.kernel.org>; Fri, 23 Aug 2024 11:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724414199; cv=none; b=UH6JMXw6lVWqG2BdYFARBlfTlcN1NWKq5mNH+oQA4lglWh7B5CdClOpVh/Ds6qq3miUdHTLsEDhqUY+D2LCJZvTF9y7lL2nX0MWHTYZnnmBMtG4/BVUYnahWPpj7usq6WkSMsH+XFWgZXdAW1xx+3taaYAdWbV6UPL9bZDa8M48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724414199; c=relaxed/simple;
	bh=Ue4f9KFsQ2oWONv7DhAaQZ96gECx58MWS1n8hpoRyCk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BwH184+eobANJQJ8t9HvB9AmplmJ3/aLWJ83Cf7PnP4a/2dzsDC8giJu8fkKkt0wA5rn/Ig/+GK1BKsqKgmzN5mJ6UZhRNemvaz93l9Ee6pxbyIaStxL0sAs08y8BUwXzq6t4SXbmsRcL5IeBmr4zRWqW0J+Iz2FnADPk+0uN60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FWoWk1Mu; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FWoWk1Mu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724414198; x=1755950198;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ue4f9KFsQ2oWONv7DhAaQZ96gECx58MWS1n8hpoRyCk=;
  b=FWoWk1Mu+vQ29XVNAdOUcE20M5OE6Qn9C02NPbRm5CtnSfLZnZi5nxOE
   BJytN06yT7gKdS1R2HCM3fEnMdUnWkjdDe8qM+RUJEBTXhet5OSGL3tkb
   EQmi0yfRTTUv9drjB5favC4CEXrzQVr20mhGHowYR3aCyqKrHNENoaBCO
   +1+alKSyyGsc+kYXlaN6Iu3M31wj3yzWyahDI7ErQ+kvMwzap9Tj+fpfY
   E+46HX4SE23Tv1HEIclSHXC2dvxC/cTS+J5NMiAyhwXXviYDh0f+M/Ffy
   U9ObQJbxDml0cM6OiKsgBlveyT39QgE8AO7BKsdxNPyzlKC4JcpGWD89b
   Q==;
X-CSE-ConnectionGUID: D8zCNK7QRIqdYJs02V+bxA==
X-CSE-MsgGUID: 29Cl4eokQDCmqJNazjB+Rw==
X-IronPort-AV: E=McAfee;i="6700,10204,11172"; a="22844104"
X-IronPort-AV: E=Sophos;i="6.10,170,1719903600"; 
   d="scan'208";a="22844104"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2024 04:56:37 -0700
X-CSE-ConnectionGUID: Kqua3kaiQzS0Mecn+VZqBg==
X-CSE-MsgGUID: erY6JcJyQS2USZRZ3vzUrw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,170,1719903600"; 
   d="scan'208";a="65986314"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.99.208])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2024 04:56:36 -0700
Date: Fri, 23 Aug 2024 13:56:30 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Miroslav =?UTF-8?Q?=C5=A0ulc?= <miroslav.sulc@fordfrog.com>
Cc: linux-raid@vger.kernel.org
Subject: Re: problem with synology external raid
Message-ID: <20240823135041.00003e05@linux.intel.com>
In-Reply-To: <d963fc43f8a7afee7f77d8ece450105f@fordfrog.com>
References: <d963fc43f8a7afee7f77d8ece450105f@fordfrog.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 22 Aug 2024 17:02:52 +0200
Miroslav =C5=A0ulc <miroslav.sulc@fordfrog.com> wrote:

> hello,
>=20
> a broken synology raid5 ended up on my desk. the raid was broken for=20
> quite some time, but i got it from the client just a few days back.
>=20
> the raid consisted of 5 disks (no spares, all used):
> disk 1 (sdca): according to my understanding, it was removed from the=20
> raid, then re-added, but the synchronization was interrupted, so it=20
> cannot be used to restore the raid

Hi Miroslav,
(If I send something earlier - sorry missclick)

   Array State : AAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D r=
eplacing)
   Events : 60223

There is no info about interrupted rebuild in the metadata. This drive
looks like removed from array, it has old Events number. If it was
rebuilt, it finished correctly.

The metadata on the drive is frozen on the last state of the device in arra=
y,
other members were updated that this device is gone.=20

> disk 2 (sdcb): is ok and up to date
> disk 3 (sdcc): seems to be up to date, still spinning, but there are=20
> many issues with bad sectors

           Events : 60283
=20
           Layout : left-symmetric
       Chunk Size : 64K
=20
     Device Role : Active device 2
     Array State : .AAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)

It is outdated, Events number is smaller than on "ok" members. Sadly, proba=
bly
mdadm will refuse to start this array because you have 2 outdated drives.

On "ok" disks, it is:
 Events : 60286
Array State : .AAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D repl=
acing)

Second failure is not recorded in metadata and I don't know why events numb=
er is
higher. I would expect kernel to stop updating metadata after device failur=
e.

I will stop here and give a chance more native experienced users to elabora=
te.

Looks like raid recreation with --assume-clean is a simplest solution but it
is general advice I can give you (and I propose it too often). You have cop=
ies,
you did right first step!

Mariusz

> disk 4 (sdcd): is ok and up to date
> disk 5 (sdce): is ok and up to date
>=20
> the raid ran in degraded mode for over two months, client trying to make=
=20
> a copy of the data from it.
>=20
> i made copies of the disk images from disks 1, 2, 4, and 5, at the state=
=20
> shown below. i didn't attempt to make a copy of disk 3 so far. since=20
> then i re-assembled the raid from disk 2-5 so the number of events on=20
> the disk 3 is now a bit higher then on the copies of the disk images.
>=20
> according to my understanding, as the disk 1 never finished the sync, i=20
> cannot use it to recover the data, so the only way to recover the data=20
> is to assemble the raid in degraded mode using disk 2-5, if i ever=20
> succeed to make a copy of the disk 3. i'd just like to verify that my=20
> understanding is correct and there is no other way to attempt to recover=
=20
> the data. of course any hints are welcome.
>=20
> here is the info from the partitions of the raid:
>=20
> /dev/sdca5:
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x2
>       Array UUID : f697911c:bc85b162:13eaba4e:d1152a4f
>             Name : DS_KLIENT:4
>    Creation Time : Tue Mar 31 11:40:19 2020
>       Raid Level : raid5
>     Raid Devices : 5
>=20
>   Avail Dev Size : 15618390912 (7447.43 GiB 7996.62 GB)
>       Array Size : 31236781824 (29789.72 GiB 31986.46 GB)
>      Data Offset : 2048 sectors
>     Super Offset : 8 sectors
> Recovery Offset : 4910216 sectors
>     Unused Space : before=3D1968 sectors, after=3D0 sectors
>            State : clean
>      Device UUID : 681c6c33:49df0163:bb4271d4:26c0c76d
>=20
>      Update Time : Tue Jun  4 18:35:54 2024
>         Checksum : cf45a6c1 - correct
>           Events : 60223
>=20
>           Layout : left-symmetric
>       Chunk Size : 64K
>=20
>     Device Role : Active device 0
>     Array State : AAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=
=3D replacing)
> /dev/sdcb5:
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x0
>       Array UUID : f697911c:bc85b162:13eaba4e:d1152a4f
>             Name : DS_KLIENT:4
>    Creation Time : Tue Mar 31 11:40:19 2020
>       Raid Level : raid5
>     Raid Devices : 5
>=20
>   Avail Dev Size : 15618390912 (7447.43 GiB 7996.62 GB)
>       Array Size : 31236781824 (29789.72 GiB 31986.46 GB)
>      Data Offset : 2048 sectors
>     Super Offset : 8 sectors
>     Unused Space : before=3D1968 sectors, after=3D0 sectors
>            State : clean
>      Device UUID : 0f23d7cd:b93301a9:5289553e:286ab6f0
>=20
>      Update Time : Wed Aug 14 15:09:24 2024
>         Checksum : 9c93703e - correct
>           Events : 60286
>=20
>           Layout : left-symmetric
>       Chunk Size : 64K
>=20
>     Device Role : Active device 1
>     Array State : .AAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=
=3D replacing)
> /dev/sdcc5:
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x0
>       Array UUID : f697911c:bc85b162:13eaba4e:d1152a4f
>             Name : DS_KLIENT:4
>    Creation Time : Tue Mar 31 11:40:19 2020
>       Raid Level : raid5
>     Raid Devices : 5
>=20
>   Avail Dev Size : 15618390912 (7447.43 GiB 7996.62 GB)
>       Array Size : 31236781824 (29789.72 GiB 31986.46 GB)
>      Data Offset : 2048 sectors
>     Super Offset : 8 sectors
>     Unused Space : before=3D1968 sectors, after=3D0 sectors
>            State : clean
>      Device UUID : 1d1c04b4:24dabd8d:235afb7d:1494b8eb
>=20
>      Update Time : Wed Aug 14 12:42:26 2024
>         Checksum : a224ec08 - correct
>           Events : 60283
>=20
>           Layout : left-symmetric
>       Chunk Size : 64K
>=20
>     Device Role : Active device 2
>     Array State : .AAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=
=3D replacing)
> /dev/sdcd5:
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x0
>       Array UUID : f697911c:bc85b162:13eaba4e:d1152a4f
>             Name : DS_KLIENT:4
>    Creation Time : Tue Mar 31 11:40:19 2020
>       Raid Level : raid5
>     Raid Devices : 5
>=20
>   Avail Dev Size : 15618390912 (7447.43 GiB 7996.62 GB)
>       Array Size : 31236781824 (29789.72 GiB 31986.46 GB)
>      Data Offset : 2048 sectors
>     Super Offset : 8 sectors
>     Unused Space : before=3D1968 sectors, after=3D0 sectors
>            State : clean
>      Device UUID : 76698d3f:e9c5a397:05ef7553:9fd0af16
>=20
>      Update Time : Wed Aug 14 15:09:24 2024
>         Checksum : 38061500 - correct
>           Events : 60286
>=20
>           Layout : left-symmetric
>       Chunk Size : 64K
>=20
>     Device Role : Active device 4
>     Array State : .AAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=
=3D replacing)
> /dev/sdce5:
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x0
>       Array UUID : f697911c:bc85b162:13eaba4e:d1152a4f
>             Name : DS_KLIENT:4
>    Creation Time : Tue Mar 31 11:40:19 2020
>       Raid Level : raid5
>     Raid Devices : 5
>=20
>   Avail Dev Size : 15618390912 (7447.43 GiB 7996.62 GB)
>       Array Size : 31236781824 (29789.72 GiB 31986.46 GB)
>      Data Offset : 2048 sectors
>     Super Offset : 8 sectors
>     Unused Space : before=3D1968 sectors, after=3D0 sectors
>            State : clean
>      Device UUID : 9c7077f8:3120195a:1af11955:6bcebd99
>=20
>      Update Time : Wed Aug 14 15:09:24 2024
>         Checksum : 38177651 - correct
>           Events : 60286
>=20
>           Layout : left-symmetric
>       Chunk Size : 64K
>=20
>     Device Role : Active device 3
>     Array State : .AAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=
=3D replacing)
>=20
>=20
> thank you for your help.
>=20
> miroslav
>=20

