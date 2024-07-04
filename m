Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BD791A2C31
	for <linux-raid@vger.kernel.org>; Thu,  4 Jul 2024 11:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720091180; cv=none; b=upVhKozaVt9zvdvcqY/MkEHndb4odUXQe4cv/90QG7kEsXSFOiW1pPEMrK8Le7qvH712zbUGOVo5AogF3rhngi/VnEtBbtONrDhvE4DgA5LiUa4ruky2IFLUSChKA7PPReJ4DxMscS8A/jZIUQp+g/6EKpGlM3tCXiom4VhvgBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720091180; c=relaxed/simple;
	bh=RhJ9/QiaJBnrqiKOz99HGIYSOr5X4JS6rZG4gbzQyTU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Hl0kaOoBrByvoDHRsScaDjjwGo5mjDs5fw+YP7lN/d333gigae3wmGFRrdEq4TS/LMYG0ys4GNZjt2LM1MoFhKB7xKgRyqGgVXZ3sevaQZS6S7cU508dA34k3pf64RlS4bj485ZdqpTR6UmkppEihbm0kErWmru4o2Tgu7Bpe4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VVJGJsSd; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VVJGJsSd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720091178; x=1751627178;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RhJ9/QiaJBnrqiKOz99HGIYSOr5X4JS6rZG4gbzQyTU=;
  b=VVJGJsSdFor3JNFJsQBEwhLL9m+3CmDIOkc/xAneWQycwb1vftcwyXeH
   8ATha0QqYXZikA5mLDoEltbRxeChfQrRko8dJx8RIikuRPClTneIkT8D7
   3aZVBP2kxqz/M+4LpqiNTcR5ZyvZFU/NIKw0nXD2D5j7O4TAekLptWamW
   fwJopeUTXmx8wQbAf84FVLFWo8aT9kk4n+9yT3hlBIEWfkRp1c49kOJjr
   CMuyjwVU1X+4wmal9bfo+SXqs2WWSfULr7z/o9nCrBIGMT+Qa1kkWBWRP
   aIhyzfcDPHZvi/cZky8Sa5r3/Bhn3LSFcD9xTO1Z47YRpGIlujFhOQlwY
   A==;
X-CSE-ConnectionGUID: ceqxsSKlQlKLfAMK/5/14w==
X-CSE-MsgGUID: TG6fXdScS7+FkQCl7MdS8g==
X-IronPort-AV: E=McAfee;i="6700,10204,11122"; a="27968610"
X-IronPort-AV: E=Sophos;i="6.09,183,1716274800"; 
   d="scan'208";a="27968610"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2024 04:06:18 -0700
X-CSE-ConnectionGUID: 5IP5n5QnQaWrus5RVGaCYg==
X-CSE-MsgGUID: h0pqrz97QFSkFxxiRFRzRA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,183,1716274800"; 
   d="scan'208";a="51010579"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.246.1.223])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2024 04:06:16 -0700
Date: Thu, 4 Jul 2024 13:06:10 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Adam Niescierowicz <adam.niescierowicz@justnet.pl>
Cc: linux-raid@vger.kernel.org
Subject: Re: RAID6 12 device assemble force failure
Message-ID: <20240704130610.00007f6a@linux.intel.com>
In-Reply-To: <76d322e3-a18a-4ed7-9907-7ce77ec0842e@justnet.pl>
References: <56a413f1-6c94-4daf-87bc-dc85b9b87c7a@justnet.pl>
	<20240701105153.000066f3@linux.intel.com>
	<25cb6321-9e61-405f-abd7-2187236af62a@justnet.pl>
	<20240702104715.00007a35@linux.intel.com>
	<347003bc-28f1-41e9-b5c4-a2cba5a4475c@justnet.pl>
	<20240703094253.00007a94@linux.intel.com>
	<20240703121610.00001041@linux.intel.com>
	<76d322e3-a18a-4ed7-9907-7ce77ec0842e@justnet.pl>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Wed, 3 Jul 2024 23:10:52 +0200
Adam Niescierowicz <adam.niescierowicz@justnet.pl> wrote:

> On 3.07.2024 o=A012:16, Mariusz Tkaczyk wrote:
> > On Wed, 3 Jul 2024 09:42:53 +0200
> > Mariusz Tkaczyk<mariusz.tkaczyk@linux.intel.com>  wrote:
> >
> > I was able to achieve similar state:
> >
> > mdadm -E /dev/nvme2n1
> > /dev/nvme2n1:
> >            Magic : a92b4efc
> >          Version : 1.2
> >      Feature Map : 0x0
> >       Array UUID : 8fd2cf1a:65a58b8d:0c9a9e2e:4684fb88
> >             Name : gklab-localhost:my_r6  (local to host gklab-localhos=
t)
> >    Creation Time : Wed Jul  3 09:43:32 2024
> >       Raid Level : raid6
> >     Raid Devices : 4
> >
> >   Avail Dev Size : 1953260976 sectors (931.39 GiB 1000.07 GB)
> >       Array Size : 10485760 KiB (10.00 GiB 10.74 GB)
> >    Used Dev Size : 10485760 sectors (5.00 GiB 5.37 GB)
> >      Data Offset : 264192 sectors
> >     Super Offset : 8 sectors
> >     Unused Space : before=3D264112 sectors, after=3D1942775216 sectors
> >            State : clean
> >      Device UUID : b26bef3c:51813f3f:e0f1a194:c96c4367
> >
> >      Update Time : Wed Jul  3 11:49:34 2024
> >    Bad Block Log : 512 entries available at offset 16 sectors
> >         Checksum : a96eaa64 - correct
> >           Events : 6
> >
> >           Layout : left-symmetric
> >       Chunk Size : 512K
> >
> >     Device Role : Active device 2
> >     Array State : ..A. ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=
=3D replacing)
> >
> >
> > In my case, events value was different and /dev/nvme3n1 had different A=
rray
> > State:
> >   Device Role : Active device 3
> >     Array State : ..AA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=
=3D replacing) =20
>=20
> This kind of array behavior is like it should be?
>=20
> Why I'm asking, in theory.
>=20
> We have bitmap so when third drive disconnect from the array we should=20
> have time to stop the array in foulty state before bitmap space is over,=
=20
> yes?.
> Next array send notification to FS(filesystem) that there is a problem=20
> and will discard all write operation.

At the moment when failure of 3th disk is recorded then array is moved to
BROKEN state which means that every new write is automatically failed. Only
reads are allowed.
Thus makes no possibility for bitmap to be fully occupied (no bitmap update=
 on
read path), we aborting earlier than bitmap is updated for new write if arr=
ay
is broken.

No notification to filesystem is sent but filesystem may discover it after
receiving error on every write.

>=20
> Data that can't be store on the foulty device should be keep in the bitma=
p.
> Next when we reatach missing third drive when we write missing data from=
=20
> bitmap to disk everything should be good, yes?
>=20
> I'm thinking correctly?
>=20

Bitmap doesn't record writes. Please read:
https://man7.org/linux/man-pages/man4/md.4.html
bitmap is used to optimize resync and recovery in case of re-add (but we
know that it won't work in your case).=20

>=20
> > And I failed to start it, sorry. It is possible but it requires to work=
 with
> > sysfs and ioctls directly so much safer is to recreate an array with
> > --assume-clean, especially that it is fresh array. =20
>=20
> I recreated the array, LVM detected PV and works fine but XFS above the=20
> LVM is missing data from recreate array.
>=20

Well, it looks like you did it right because LVM is up. Please compare if d=
isks
are ordered same way in new array (indexes of the drives in mdadm -D output=
).
Just do be double sure.

For the filesystem issues- I cannot help on that, I hope you can recover at
least part of data :(

Thanks,
Mariusz
