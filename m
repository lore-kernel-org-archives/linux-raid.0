Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2427145B10
	for <linux-raid@vger.kernel.org>; Tue, 27 Aug 2024 07:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724744350; cv=none; b=TfKu5gJa3QTxLOjCbvqzXsh7uNVqCRrJED+yewRTj6+ZQHAbnmy8pKmfa4mZwIR2OO/gLhTyCIP91l8Flkx+HFA2qwxeOnUtOQrswyBME3ww8t6itkCiS+Vmp57ZS1mDxP74qh8/5b4rXK5SjgxK2vJusMgcv+7rdKb6COfBx+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724744350; c=relaxed/simple;
	bh=rfE2UxGP5rGEaCF0h2OWsBiAnXh7ENGk8X4YQkvLD9U=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gD8jPx/xC9TycNOmAMfMJgm6NGc37zZHkZPNu+biz5WKFfWa85/d7GLovqw1JRx7d4SiaikaC8YJ61mwnrS+BqY6aAqQcMiL4CzN5UPDk4gEW52YVe1omX19EqMJUlz8URaTnIkYF09uUrX3g4wZDqxmbtWi6kO6+ZD1+vIMoVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=igTT/yf4; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="igTT/yf4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724744348; x=1756280348;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rfE2UxGP5rGEaCF0h2OWsBiAnXh7ENGk8X4YQkvLD9U=;
  b=igTT/yf4bql3aYBLgxXTp4VrHQ+zlWmeQrYW4IXLomsrDtZXnOhFqwme
   8dUYsK58v7PmDNqF0Cg2to1FBQk1AjP3wKmEK3dZuU5W2Y5t1/2wURIX9
   gI2ag8ZagvF8lSKZjtfJkBTXZ8PRha4slkkudAUHaeZW/TMwdyvINdnwG
   cUi+V+qrrrJaMIFLDPgQqSGwedOF+wdBO2IbgxAP34jtV5PDNDmzZiOMe
   AmUyNAyOlSDGpoeCW1jAGhW/Qd5UOS5lfFQWe6RxVP19rmi9B6t9RXInD
   FzTw9b4OiKEjLWddCkX2hbNjTyj/YM/8fMFNBvQkS3z1ggXqLfF0tRbM9
   Q==;
X-CSE-ConnectionGUID: JKzKsp8pRtqNHD2ilRY1/A==
X-CSE-MsgGUID: af+i1H22TzeenxbNlDBfqg==
X-IronPort-AV: E=McAfee;i="6700,10204,11176"; a="40675129"
X-IronPort-AV: E=Sophos;i="6.10,179,1719903600"; 
   d="scan'208";a="40675129"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2024 00:39:07 -0700
X-CSE-ConnectionGUID: uCHfYLHySziT8DqFO5u5ew==
X-CSE-MsgGUID: ir180llFQciJKlCGzR03aw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,179,1719903600"; 
   d="scan'208";a="67653135"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.246.29.120])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2024 00:39:07 -0700
Date: Tue, 27 Aug 2024 09:38:56 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Miroslav =?UTF-8?Q?=C5=A0ulc?= <miroslav.sulc@fordfrog.com>
Cc: linux-raid@vger.kernel.org
Subject: Re: problem with synology external raid
Message-ID: <20240827093856.00001bc3@linux.intel.com>
In-Reply-To: <7586a690b53ca45fafc6fd0d6700315f@fordfrog.com>
References: <d963fc43f8a7afee7f77d8ece450105f@fordfrog.com>
	<20240823135041.00003e05@linux.intel.com>
	<7586a690b53ca45fafc6fd0d6700315f@fordfrog.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 23 Aug 2024 17:54:58 +0200
Miroslav =C5=A0ulc <miroslav.sulc@fordfrog.com> wrote:

> hi Mariusz, thanks for your reply. please find my comments below.
>=20
> Dne 2024-08-23 13:56, Mariusz Tkaczyk napsal:
> > On Thu, 22 Aug 2024 17:02:52 +0200
> > Miroslav =C5=A0ulc <miroslav.sulc@fordfrog.com> wrote:
> >  =20
> >> hello,
> >>=20
> >> a broken synology raid5 ended up on my desk. the raid was broken for
> >> quite some time, but i got it from the client just a few days back.
> >>=20
> >> the raid consisted of 5 disks (no spares, all used):
> >> disk 1 (sdca): according to my understanding, it was removed from the
> >> raid, then re-added, but the synchronization was interrupted, so it
> >> cannot be used to restore the raid =20
> >=20
> > Hi Miroslav,
> > (If I send something earlier - sorry missclick)
> >=20
> >    Array State : AAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=
=3D=20
> > replacing)
> >    Events : 60223
> >=20
> > There is no info about interrupted rebuild in the metadata. This drive
> > looks like removed from array, it has old Events number. If it was
> > rebuilt, it finished correctly. =20
>=20
> there is this line in the metadata from which i supposed the rebuild=20
> didn't finish:
>=20
> Recovery Offset : 4910216 sectors
>=20
> i also tried to recreate the raid from disks 1, 2, 4, and 5, using=20
> --assume-clean. the raid was set up, i was able to read lvm from the=20
> raid, but when i checked the btrfs filesystem on it or tried to mount=20
> it, i faced a serious corruption of the filesystem. btrfs recovery=20
> recovered nothing.

disk 1 is outdated so I'm not surprised here. You have better targets
(2-5). See below. "Events" is a counter of metadata updates that happened t=
o the
array. metadata is updated for dirty clean transition or reconfiguration.
Simply bigger difference means that the device was detached earlier so the
data on this removed drive is older and less reliable for filesystem to
recover.

>=20
> > The metadata on the drive is frozen on the last state of the device in=
=20
> > array,
> > other members were updated that this device is gone.
> >  =20
> >> disk 2 (sdcb): is ok and up to date
> >> disk 3 (sdcc): seems to be up to date, still spinning, but there are
> >> many issues with bad sectors =20
> >=20
> >            Events : 60283
> >=20
> >            Layout : left-symmetric
> >        Chunk Size : 64K
> >=20
> >      Device Role : Active device 2
> >      Array State : .AAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =
=3D=3D=20
> > replacing)
> >=20
> > It is outdated, Events number is smaller than on "ok" members. Sadly,=20
> > probably
> > mdadm will refuse to start this array because you have 2 outdated=20
> > drives. =20
>=20
> i was able to start the array from disks 2-4 in degraded mode. i even=20
> tried to add disk 1 to the array and rebuild it, but that failed. my=20
> guess is it was because of disk 3.

You don't need to recover this array. Try read data back, you can copy data=
 to
other media if you have any.
Disk 3 looks like damaged so I cannot guarantee it all will be successful.

Recovery process copies the data from existing disks to rebuilt disk, if
original data is not reliable, recovered one won't be reliable too. You don=
't
need to make it worse.

Just assemble what you can and copy what you can. Degraded state means that=
 you
can still access all data.

Thanks,
Mariusz

>=20
> >=20
> > On "ok" disks, it is:
> >  Events : 60286
> > Array State : .AAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D =
replacing)
> >=20
> > Second failure is not recorded in metadata and I don't know why events=
=20
> > number is
> > higher. I would expect kernel to stop updating metadata after device=20
> > failure.
> >=20
> > I will stop here and give a chance more native experienced users to=20
> > elaborate.
> >=20
> > Looks like raid recreation with --assume-clean is a simplest solution=20
> > but it
> > is general advice I can give you (and I propose it too often). You have=
=20
> > copies,
> > you did right first step!
> >=20
> > Mariusz
> >  =20
> >> disk 4 (sdcd): is ok and up to date
> >> disk 5 (sdce): is ok and up to date
> >>=20
> >> the raid ran in degraded mode for over two months, client trying to=20
> >> make
> >> a copy of the data from it.
> >>=20
> >> i made copies of the disk images from disks 1, 2, 4, and 5, at the=20
> >> state
> >> shown below. i didn't attempt to make a copy of disk 3 so far. since
> >> then i re-assembled the raid from disk 2-5 so the number of events on
> >> the disk 3 is now a bit higher then on the copies of the disk images.
> >>=20
> >> according to my understanding, as the disk 1 never finished the sync,=
=20
> >> i
> >> cannot use it to recover the data, so the only way to recover the data
> >> is to assemble the raid in degraded mode using disk 2-5, if i ever
> >> succeed to make a copy of the disk 3. i'd just like to verify that my
> >> understanding is correct and there is no other way to attempt to=20
> >> recover
> >> the data. of course any hints are welcome.
> >>=20
> >> here is the info from the partitions of the raid:
> >>=20
> >> /dev/sdca5:
> >>            Magic : a92b4efc
> >>          Version : 1.2
> >>      Feature Map : 0x2
> >>       Array UUID : f697911c:bc85b162:13eaba4e:d1152a4f
> >>             Name : DS_KLIENT:4
> >>    Creation Time : Tue Mar 31 11:40:19 2020
> >>       Raid Level : raid5
> >>     Raid Devices : 5
> >>=20
> >>   Avail Dev Size : 15618390912 (7447.43 GiB 7996.62 GB)
> >>       Array Size : 31236781824 (29789.72 GiB 31986.46 GB)
> >>      Data Offset : 2048 sectors
> >>     Super Offset : 8 sectors
> >> Recovery Offset : 4910216 sectors
> >>     Unused Space : before=3D1968 sectors, after=3D0 sectors
> >>            State : clean
> >>      Device UUID : 681c6c33:49df0163:bb4271d4:26c0c76d
> >>=20
> >>      Update Time : Tue Jun  4 18:35:54 2024
> >>         Checksum : cf45a6c1 - correct
> >>           Events : 60223
> >>=20
> >>           Layout : left-symmetric
> >>       Chunk Size : 64K
> >>=20
> >>     Device Role : Active device 0
> >>     Array State : AAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =
=3D=3D=20
> >> replacing)
> >> /dev/sdcb5:
> >>            Magic : a92b4efc
> >>          Version : 1.2
> >>      Feature Map : 0x0
> >>       Array UUID : f697911c:bc85b162:13eaba4e:d1152a4f
> >>             Name : DS_KLIENT:4
> >>    Creation Time : Tue Mar 31 11:40:19 2020
> >>       Raid Level : raid5
> >>     Raid Devices : 5
> >>=20
> >>   Avail Dev Size : 15618390912 (7447.43 GiB 7996.62 GB)
> >>       Array Size : 31236781824 (29789.72 GiB 31986.46 GB)
> >>      Data Offset : 2048 sectors
> >>     Super Offset : 8 sectors
> >>     Unused Space : before=3D1968 sectors, after=3D0 sectors
> >>            State : clean
> >>      Device UUID : 0f23d7cd:b93301a9:5289553e:286ab6f0
> >>=20
> >>      Update Time : Wed Aug 14 15:09:24 2024
> >>         Checksum : 9c93703e - correct
> >>           Events : 60286
> >>=20
> >>           Layout : left-symmetric
> >>       Chunk Size : 64K
> >>=20
> >>     Device Role : Active device 1
> >>     Array State : .AAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =
=3D=3D=20
> >> replacing)
> >> /dev/sdcc5:
> >>            Magic : a92b4efc
> >>          Version : 1.2
> >>      Feature Map : 0x0
> >>       Array UUID : f697911c:bc85b162:13eaba4e:d1152a4f
> >>             Name : DS_KLIENT:4
> >>    Creation Time : Tue Mar 31 11:40:19 2020
> >>       Raid Level : raid5
> >>     Raid Devices : 5
> >>=20
> >>   Avail Dev Size : 15618390912 (7447.43 GiB 7996.62 GB)
> >>       Array Size : 31236781824 (29789.72 GiB 31986.46 GB)
> >>      Data Offset : 2048 sectors
> >>     Super Offset : 8 sectors
> >>     Unused Space : before=3D1968 sectors, after=3D0 sectors
> >>            State : clean
> >>      Device UUID : 1d1c04b4:24dabd8d:235afb7d:1494b8eb
> >>=20
> >>      Update Time : Wed Aug 14 12:42:26 2024
> >>         Checksum : a224ec08 - correct
> >>           Events : 60283
> >>=20
> >>           Layout : left-symmetric
> >>       Chunk Size : 64K
> >>=20
> >>     Device Role : Active device 2
> >>     Array State : .AAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =
=3D=3D=20
> >> replacing)
> >> /dev/sdcd5:
> >>            Magic : a92b4efc
> >>          Version : 1.2
> >>      Feature Map : 0x0
> >>       Array UUID : f697911c:bc85b162:13eaba4e:d1152a4f
> >>             Name : DS_KLIENT:4
> >>    Creation Time : Tue Mar 31 11:40:19 2020
> >>       Raid Level : raid5
> >>     Raid Devices : 5
> >>=20
> >>   Avail Dev Size : 15618390912 (7447.43 GiB 7996.62 GB)
> >>       Array Size : 31236781824 (29789.72 GiB 31986.46 GB)
> >>      Data Offset : 2048 sectors
> >>     Super Offset : 8 sectors
> >>     Unused Space : before=3D1968 sectors, after=3D0 sectors
> >>            State : clean
> >>      Device UUID : 76698d3f:e9c5a397:05ef7553:9fd0af16
> >>=20
> >>      Update Time : Wed Aug 14 15:09:24 2024
> >>         Checksum : 38061500 - correct
> >>           Events : 60286
> >>=20
> >>           Layout : left-symmetric
> >>       Chunk Size : 64K
> >>=20
> >>     Device Role : Active device 4
> >>     Array State : .AAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =
=3D=3D=20
> >> replacing)
> >> /dev/sdce5:
> >>            Magic : a92b4efc
> >>          Version : 1.2
> >>      Feature Map : 0x0
> >>       Array UUID : f697911c:bc85b162:13eaba4e:d1152a4f
> >>             Name : DS_KLIENT:4
> >>    Creation Time : Tue Mar 31 11:40:19 2020
> >>       Raid Level : raid5
> >>     Raid Devices : 5
> >>=20
> >>   Avail Dev Size : 15618390912 (7447.43 GiB 7996.62 GB)
> >>       Array Size : 31236781824 (29789.72 GiB 31986.46 GB)
> >>      Data Offset : 2048 sectors
> >>     Super Offset : 8 sectors
> >>     Unused Space : before=3D1968 sectors, after=3D0 sectors
> >>            State : clean
> >>      Device UUID : 9c7077f8:3120195a:1af11955:6bcebd99
> >>=20
> >>      Update Time : Wed Aug 14 15:09:24 2024
> >>         Checksum : 38177651 - correct
> >>           Events : 60286
> >>=20
> >>           Layout : left-symmetric
> >>       Chunk Size : 64K
> >>=20
> >>     Device Role : Active device 3
> >>     Array State : .AAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =
=3D=3D=20
> >> replacing)
> >>=20
> >>=20
> >> thank you for your help.
> >>=20
> >> miroslav
> >>  =20
>=20

