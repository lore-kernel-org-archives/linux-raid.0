Received: from shin.romanrm.net (shin.romanrm.net [146.185.199.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0776224DA
	for <linux-raid@vger.kernel.org>; Fri,  8 Mar 2024 00:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=146.185.199.61
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709859367; cv=none; b=MQRcrxFsYokvmplIBvWv0ZKV7m16m9+CV5bfYjdBPXtGYBaR/eMRmsQZVleZMr510WtdJRIIT/shKLcfRO9EHgLiZvp6oq5ulcwKAeGI61aXGSOsAsZJ6kHHib1miY+4OXbtOgRVsk3Co3Wo7gbh7uPzL46ggbGvcws/x7Wgq4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709859367; c=relaxed/simple;
	bh=p+G2s7yMA+PYs5BDPPmFurV9aSeZ9vnV0OIMuD5ea1E=;
	h=Date:From:To:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e9kpymhnSRbYjxNg3Z7zMyrmjGgel0DeMWQdDXk8wDVmQN3vCUSUM3YtpL+6BoGxuiQqlW+e+VijrF2XoFOi2xKRLUWuH7UwlPFohz25XyhdLXP9dzNY7I18J7e4xPKTu6EgYApEGZ8uORlX7iIYtvN1nQKK4NqGMzGpGG+al0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=romanrm.net; spf=pass smtp.mailfrom=romanrm.net; arc=none smtp.client-ip=146.185.199.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=romanrm.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=romanrm.net
Received: from nvm (nvm2.home.romanrm.net [IPv6:fd39::4a:3cff:fe57:d6b5])
	by shin.romanrm.net (Postfix) with SMTP id 38D063F849;
	Fri,  8 Mar 2024 00:55:59 +0000 (UTC)
Date: Fri, 8 Mar 2024 05:55:58 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Stewart Andreason <sandreas41@gmail.com>, linux-raid@vger.kernel.org
Subject: Re: raid1 show clean but md0 will not assemble
Message-ID: <20240308055558.5689ce94@nvm>
In-Reply-To: <ac42e2cf-b8a0-4072-949e-fe3d0d969f7c@gmail.com>
References: <f2737b90-fb63-4909-b2d9-496390d2c199@gmail.com>
	<20240308035813.22ffb052@nvm>
	<ac42e2cf-b8a0-4072-949e-fe3d0d969f7c@gmail.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 7 Mar 2024 16:45:49 -0800
Stewart Andreason <sandreas41@gmail.com> wrote:

> Hi Roman,
>=20
> Does this board have rules about replying to everyone, or not?

Hello,

Yes it was better to reply to everyone, to let people know it is now solved
and nobody else needs to spend time analyzing the original report.

> I'll go with not until advised otherwise.
>=20
>=20
> >> $ sudo mdadm --assemble --verbose /dev/md0 /dev/sdc1 /dev/sdd1
> >> mdadm: looking for devices for /dev/md0
> >> mdadm: /dev/sdc1 is identified as a member of /dev/md0, slot 0.
> >> mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 1.
> >> mdadm: added /dev/sdc1 to /dev/md0 as 0 (possibly out of date)
> >> mdadm: added /dev/sdd1 to /dev/md0 as 1
> >> mdadm: /dev/md0 has been started with 1 drive (out of 2).
> > Please include "dmesg" output that's printed after running this command.
>=20
>=20
> Certainly.
>=20
> http://seahorsecorral.org/bugreport/Roxy10-dmesg-20240307-clip.txt.gz
>=20
>=20
>=20
> > See the "Event" counters, one drive indeed has less than the other.
>=20
>=20
> When I first opened these in January, they went into a different=20
> enclosure, Acasis EC-7352
>=20
> All or 99% of the errors are from that month, both the events and the 3=20
> serious errors in the smart log. It was first configured for hardware=20
> raid, but proved to have several issues, including not turning on the=20
> fan after waking up. Crashed a few times, even in JBOD mode. So I=20
> started over in new individual enclosures.
>=20
> Hard to tell who was responsible for those crashes, since the most=20
> recent ones froze up the whole OS, so no dmesg could be retrieved. That=20
> was Jan.29 and was the end of Acasis in my rating.
>=20
>=20
> > As for the actual steps, when you are in this state as in your report, =
I'd try:
> >
> >    mdadm --re-add /dev/md0 /dev/sdc1
>=20
> I powered up 0, expect sdc, Device Role : Active device 0 , ok.
>=20
> I powered up 1, expect sdd, Active device 1
>=20
> $ sudo mdadm --detail /dev/md0
> /dev/md0:
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Version : 1=
.2
>  =C2=A0=C2=A0=C2=A0=C2=A0 Creation Time : Sat Jan 27 12:07:27 2024
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Raid Level : raid1
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Array Size : 5860388864 (5588=
.90 GiB 6001.04 GB)
>  =C2=A0=C2=A0=C2=A0=C2=A0 Used Dev Size : 5860388864 (5588.90 GiB 6001.04=
 GB)
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Raid Devices : 2
>  =C2=A0=C2=A0=C2=A0=C2=A0 Total Devices : 1
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Persistence : Superblock is persist=
ent
>=20
>  =C2=A0=C2=A0=C2=A0=C2=A0 Intent Bitmap : Internal
>=20
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Update Time : Sat Mar=C2=A0 2 18:50=
:02 2024
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 State : clean, degraded
>  =C2=A0=C2=A0=C2=A0 Active Devices : 1
>  =C2=A0=C2=A0 Working Devices : 1
>  =C2=A0=C2=A0=C2=A0 Failed Devices : 0
>=20
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 Name : roxy10-debian11-x64:0=C2=A0 (local to host=20
> roxy10-debian11-x64)
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 UUID : 1e3f7f7e:23a5b75f:6f76abf5:88f5e704
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Event=
s : 21691
>=20
>  =C2=A0=C2=A0=C2=A0 Number=C2=A0=C2=A0 Major=C2=A0=C2=A0 Minor=C2=A0=C2=
=A0 RaidDevice State
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 8=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 33=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 active sync=C2=A0=C2=A0 /dev/s=
dc1
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 removed
>=20
> Why is sdc the active one this time?
>=20
> $ lsblk
>=20
> sdc=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 8:32=C2=A0=C2=A0 0=C2=A0=C2=A0 5.=
5T=C2=A0 0 disk
> =E2=94=94=E2=94=80sdc1=C2=A0=C2=A0=C2=A0 8:33=C2=A0=C2=A0 0=C2=A0=C2=A0 5=
.5T=C2=A0 0 part
>  =C2=A0 =E2=94=94=E2=94=80md0=C2=A0=C2=A0 9:0=C2=A0=C2=A0=C2=A0 0=C2=A0=
=C2=A0 5.5T=C2=A0 0 raid1
> sdd=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 8:48=C2=A0=C2=A0 0=C2=A0=C2=A0 5.=
5T=C2=A0 0 disk
> =E2=94=94=E2=94=80sdd1=C2=A0=C2=A0=C2=A0 8:49=C2=A0=C2=A0 0=C2=A0=C2=A0 5=
.5T=C2=A0 0 part
>=20
> I keep getting confused which drive is the bad one, and repeated my=20
> steps before posting my question. Now maybe I was not imagining it.
>=20
> I only got the slot numbers verified by reassembling it. so I'll do that=
=20
> step again.
>=20
> $ sudo mdadm --stop /dev/md0
> mdadm: stopped /dev/md0
> $ sudo mdadm --assemble --verbose /dev/md0 /dev/sdc1 /dev/sdd1
> mdadm: looking for devices for /dev/md0
> mdadm: /dev/sdc1 is identified as a member of /dev/md0, slot 0.
> mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 1.
> mdadm: added /dev/sdc1 to /dev/md0 as 0 (possibly out of date)
> mdadm: added /dev/sdd1 to /dev/md0 as 1
> mdadm: /dev/md0 has been started with 1 drive (out of 2).
>=20
> Huh. Well, onward then. I'll just include what changed:
>=20
> $ sudo mdadm --detail /dev/md0
>  =C2=A0=C2=A0=C2=A0 Number=C2=A0=C2=A0 Major=C2=A0=C2=A0 Minor=C2=A0=C2=
=A0 RaidDevice State
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 removed
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 8=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 49=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 active sync=C2=A0=C2=A0 /dev/s=
dd1
>=20
> $ sudo mdadm --re-add /dev/md0 /dev/sdc1
> mdadm: re-added /dev/sdc1
>=20
> $ cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]=20
> [raid4] [raid10]
> md0 : active raid1 sdc1[0] sdd1[1]
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 5860388864 blocks super 1.2 [2/2] [UU]
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bitmap: 1/44 pages [4KB], 65536KB chunk
>=20
> $ sudo mdadm --detail /dev/md0
>=20
>  =C2=A0=C2=A0=C2=A0 Number=C2=A0=C2=A0 Major=C2=A0=C2=A0 Minor=C2=A0=C2=
=A0 RaidDevice State
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 8=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 33=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 active sync=C2=A0=C2=A0 /dev/s=
dc1
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 8=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 49=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 active sync=C2=A0=C2=A0 /dev/s=
dd1
>=20
> $ dmesg
>=20
> [37737.530811] md: kicking non-fresh sdc1 from array!
> [37737.556503] md/raid1:md0: active with 1 out of 2 mirrors
> [37737.561908] md0: detected capacity change from 0 to 6001038196736
> [37818.049342] md: recovery of RAID array md0
> [37818.319780] md: md0: recovery done.
>=20
> Fixed. I'm so glad I asked the right forum. Thank you!
>=20
>=20
> > But to me it is puzzling why it got removed to begin with.
> >
> I=C2=A0 had the intent of making a backup of my primary OS when it was=20
> unmounted, and after researching the safe commands to reassemble the=20
> raid in a different linux OS, I rebooted to System-Rescue-10, copied the=
=20
> mdadm.conf to /etc over the existing template. and attempted to mount=20
> /dev/md0
>=20
> I got only one drive up. Ensue the mild panic, because when doesn't=20
> doing research first ever go perfectly?
>=20
> Now with a few more days experience, I get to try again.
>=20
> Thanks again,
>=20
> Stewart
>=20


--=20
With respect,
Roman
