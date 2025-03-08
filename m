Received: from mail-10629.protonmail.ch (mail-10629.protonmail.ch [79.135.106.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 611E315442C
	for <linux-raid@vger.kernel.org>; Sat,  8 Mar 2025 17:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=79.135.106.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741456754; cv=none; b=n1mRg6+XzIw6NtfjOLODgB+StH6OEqZ1oIUtNRH9LF2dAli5JU/ejzal7Uj1pO8C9a0oa69UlnxgRizD0ARj8NmnOW5X3daYYDrBARRMmLbCRZsNHOgjSxWUjFplpost4B6ZQ0JHK/Q2C8a0TiAHk2YKYRM/X88iS+EQ4oJRx6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741456754; c=relaxed/simple;
	bh=uq0UGtx4Jahbx/G/6qmgfAgVNYFDaqGnARJ1AmN68Dw=;
	h=Date:To:From:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BN6p2H2hhZS947p6g9yqCPW4mLyILKdcZ7eiAefnVMFZg3aqnhx7FBf79AWrptrIKzcbaZgPFz/5iGittXoUCuTtzDECQPSpIACu4cjyaKqqh2JqO6zV01qdpeGHrCsdeZztgFoOaYra9U8dCmV89s14Nb1Q2b5kKStICuVJ0bA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pm.me; spf=pass smtp.mailfrom=pm.me; dkim=pass (2048-bit key) header.d=pm.me header.i=@pm.me header.b=F/KKeuXo; arc=none smtp.client-ip=79.135.106.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pm.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pm.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pm.me header.i=@pm.me header.b="F/KKeuXo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1741456750; x=1741715950;
	bh=HLnrYRx6E5kd3Bz5D1gmF6ZOHDInoamm0BYJaELcD2E=;
	h=Date:To:From:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector:List-Unsubscribe:List-Unsubscribe-Post;
	b=F/KKeuXoE9bXrTz8o6M7mli6kc5LG32uks09X4TWQdcZ2Fe80Qh72Mq7BN085gfYg
	 v77VixgrUGvZuyZvqbPawdwZeRM6skDZjLEA6e20QTPmkU1+Nq+N76/kcAQlLwqo9W
	 UElfyaALDADRreV8O3iEYcGcSDxr2T8jOkZhqK1aGbJEmN6p7/xrTHX9Tq2xxITxa0
	 Ee66xZ+lSssueyCz8EXNJ5zrwRtehLcKDAbiOZSWXnTbWJhmYX37xkryNVXHlOd9F1
	 H9IvW9z45CuRqssnXGtZ7NbQctp49vJP82WsWPja4zWyhWza0QLhKVcjRomcs2nIec
	 SzFmaUiSEFqVQ==
Date: Sat, 08 Mar 2025 17:59:06 +0000
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
From: David Hajes <d.hajes29a@pm.me>
Subject: Re: RAID 5, 10 modern post 2020 drives, slow speeds
Message-ID: <6Ir6YNRb1H1U2Oo4RAL72oDA3NHeUrwres6F4LBIh0GPJywynko0jERT_t7JPtLBHvy8LwzAK6AqwhZFjGH7gGstzEaLWoYkXBoQlU2B5To=@pm.me>
In-Reply-To: <20250308014718.24418feb@nvm>
References: <lMRgP8wc-P3iUlmbrsOKyuXM834ndQZZUThbeEUIO0WoNKKMQLd-T5P6QrFMEYiYAoQUAWkFGaggDTMSzZFw9KzBagunLy1mRNDk2TljKUM=@pm.me> <20250307234753.473dc4b5@nvm> <wbKuA1vBv5kD_KeuudRU95HVHtIXiMs9hvH40_jlVcKTvwOR_4vszdQADWASxjhfBXFS2JkNpQnCnrdaoiombOE6Tof66ktqnXyRnwQXw7o=@pm.me> <CAAMCDefMK6PD7+BpfQ9e2WGjdsk_hQaoGOAYmQ2_Rtn5o7nGrQ@mail.gmail.com> <20250308014718.24418feb@nvm>
Feedback-ID: 111191645:user:proton
X-Pm-Message-ID: 262720604853c1e27188b7ee93a2b09222d4e310
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


In case someone wonders in future why SW RAID5 or 10 is slow.

Unless, two or more process do not write in parallel - ARRAY SPEED WILL ALW=
AYS BE SINGLE DRIVE LIMIT.

Basically, any single user operations of storing data on the array will bec=
ame as writing to single drive.

In case of modern SATA HDDs, it would be 120-220MBs

Only the HW RAID controllers are allegedly capable to write on more than on=
e drive parallel thus achiving the logical/envisioned/intuitive speed.

based on theory where at least two chunks are written at once to the two di=
fferent drives thus doubling the writing speed as confussingly written in a=
ll RAID wikis.


-------- Original Message --------
On 07/03/2025 21:47, Roman Mamedov <rm@romanrm.net> wrote:

>  On Fri, 7 Mar 2025 14:42:24 -0600
>  Roger Heflin <rogerheflin@gmail.com> wrote:
> =20
>  > I put an external bitmap on a raid1 SSD and that seemed to speed up my
>  > writes.  I am not sure if external bitmaps will continue to be
>  > supported as I have seen notes that I don't exactly understand for
>  > external bitmaps, and I have to reapply the external bitmap on each
>  > reboot for my arrays which has some data loss risks in a crash case
>  > with a dirty bitmap.
>  >
>  > This is the command I used to set it up.
>  > mdadm --grow --force --bitmap=3D/mdraid-bitmaps/md15-bitmap.img /dev/m=
d15
> =20
>  In this case the result cited seems to have shown the bitmap is not the =
issue.
> =20
>  I remember seeing patches or talks to remove external bitmap support, to=
o.
> =20
>  In my experience the internal bitmap with a large enough chunk size does=
 not
>  slow down the write speed that much. Try a chunk size of 256M. Not sure =
how
>  high it's worth going before the benefits diminish.
> =20
>  --
>  With respect,
>  Roman
>  
