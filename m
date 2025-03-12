Received: from mail-10630.protonmail.ch (mail-10630.protonmail.ch [79.135.106.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19D0C1EB1B3
	for <linux-raid@vger.kernel.org>; Wed, 12 Mar 2025 21:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=79.135.106.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741813802; cv=none; b=ViDZOtmnZ8rcI2kijOeOlFroU4HoCh/IpxZLsQJp/nbKVJ7353QN4hrfqlRzrOK3MDKBtADgu3NrPUvWAHjg/dwhnYVlZWhG8F5h/Tqhljg1PdCruCYmdPyAxG0Rji+4DZxjeJ71SAVgWabheSpDnN/wnskHUrbTLpySsShGSMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741813802; c=relaxed/simple;
	bh=ewmW6icuDpjiPH6Dwc9GAioOw81E0vEUdKmeqNUFZeQ=;
	h=Date:To:From:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I/rBbK91LgvZh7SqRL7V+M0mBq+1XN6CUhsOcHe5ty379IN5vCXN6kCz/cyvQbl2EJlDrliOv56/JaQ7We8XBV6hy01HN+KGmIBsGP77/wbJjPobM/IeWiaUf+k+/d8jNFF1wzTD2IapuYtwpjVVeu9bhu9ttI8m+r3xmqXiMoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pm.me; spf=pass smtp.mailfrom=pm.me; dkim=pass (2048-bit key) header.d=pm.me header.i=@pm.me header.b=XWHuIkn9; arc=none smtp.client-ip=79.135.106.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pm.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pm.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pm.me header.i=@pm.me header.b="XWHuIkn9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1741813798; x=1742072998;
	bh=QocaxipQcu1r0/y6vOf36t38bcHC5aGKjny2aPM/L0g=;
	h=Date:To:From:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector:List-Unsubscribe:List-Unsubscribe-Post;
	b=XWHuIkn9xYy7eateZvmIoWvG3eyA32lKD3WDDGCCic/QKBT8VmxpR0dKuqawwCOV2
	 1XPbuXbp2LP4/gztct/cfjk8Xt/MJl8UzFap3rt5ZhOaVtvADCMHLuK2cSQNWN+n3J
	 Y376aKHCNb1Bi3aXvVX9wYJBGUNw+3Q17GEstTE9rM3JQ8MUuTJkc6MtbUXv2BBLmN
	 pb6kQq5dbe6qpmQFBDoA2l2fkyeMVI6h8ho/2Kh86veheF45WpthbqPe+zycwHlnx4
	 M/xAKsQRUs/h9n8ON8ywXt1YfvvSJeRdtaslGnZ3iwgwmhvSpdpzsqaafGD/UKBeKp
	 Id00DCibIsRXg==
Date: Wed, 12 Mar 2025 21:09:55 +0000
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
From: David Hajes <d.hajes29a@pm.me>
Subject: Re: RAID 5, 10 modern post 2020 drives, slow speeds
Message-ID: <iySSc1AqmRY1KRcyTemssyoFl73YGVEj-la5iuqHKYLfGZ5T03ftnvuIct26v30dD6y4w1SRWo9x67ZQUki88MQTXBBmKf6vL5eEOXJig8c=@pm.me>
In-Reply-To: <6Ir6YNRb1H1U2Oo4RAL72oDA3NHeUrwres6F4LBIh0GPJywynko0jERT_t7JPtLBHvy8LwzAK6AqwhZFjGH7gGstzEaLWoYkXBoQlU2B5To=@pm.me>
References: <lMRgP8wc-P3iUlmbrsOKyuXM834ndQZZUThbeEUIO0WoNKKMQLd-T5P6QrFMEYiYAoQUAWkFGaggDTMSzZFw9KzBagunLy1mRNDk2TljKUM=@pm.me> <20250307234753.473dc4b5@nvm> <wbKuA1vBv5kD_KeuudRU95HVHtIXiMs9hvH40_jlVcKTvwOR_4vszdQADWASxjhfBXFS2JkNpQnCnrdaoiombOE6Tof66ktqnXyRnwQXw7o=@pm.me> <CAAMCDefMK6PD7+BpfQ9e2WGjdsk_hQaoGOAYmQ2_Rtn5o7nGrQ@mail.gmail.com> <20250308014718.24418feb@nvm> <6Ir6YNRb1H1U2Oo4RAL72oDA3NHeUrwres6F4LBIh0GPJywynko0jERT_t7JPtLBHvy8LwzAK6AqwhZFjGH7gGstzEaLWoYkXBoQlU2B5To=@pm.me>
Feedback-ID: 111191645:user:proton
X-Pm-Message-ID: 9e875bf693abfb3f2d20b8ece9cf05f4b7b3e3df
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Update on issue. I came across the "mismatch_cnt" stat after init resync or=
 just common check/scrub.

mismatch_cnt suppose to be 0. I had counter reaching millions. I haven't fo=
und definitive answer whether "mismatch_cnt" bad, and should be ignored.

Allegedly high mismatch_cnt count suggest HW  or SW issues. I run SMART, no=
 system corruption.

I have tried to run "repair". Repair 400-500MBs, and mismatch_cnt is now 0.

Initial resync started at 500MBs, 20 min later dropped to 200 MBs. 3 days l=
ater speed was at 120MBs.

I will try some real tests to see if array is still fast in real life as we=
ll.

Hajes


-------- Original Message --------
On 08/03/2025 18:59, David Hajes <d.hajes29a@pm.me> wrote:

> =20
>  In case someone wonders in future why SW RAID5 or 10 is slow.
> =20
>  Unless, two or more process do not write in parallel - ARRAY SPEED WILL =
ALWAYS BE SINGLE DRIVE LIMIT.
> =20
>  Basically, any single user operations of storing data on the array will =
became as writing to single drive.
> =20
>  In case of modern SATA HDDs, it would be 120-220MBs
> =20
>  Only the HW RAID controllers are allegedly capable to write on more than=
 one drive parallel thus achiving the logical/envisioned/intuitive speed.
> =20
>  based on theory where at least two chunks are written at once to the two=
 different drives thus doubling the writing speed as confussingly written i=
n all RAID wikis.
> =20
> =20
>  -------- Original Message --------
>  On 07/03/2025 21:47, Roman Mamedov <rm@romanrm.net> wrote:
> =20
>  >  On Fri, 7 Mar 2025 14:42:24 -0600
>  >  Roger Heflin <rogerheflin@gmail.com> wrote:
>  > =20
>  >  > I put an external bitmap on a raid1 SSD and that seemed to speed up=
 my
>  >  > writes.  I am not sure if external bitmaps will continue to be
>  >  > supported as I have seen notes that I don't exactly understand for
>  >  > external bitmaps, and I have to reapply the external bitmap on each
>  >  > reboot for my arrays which has some data loss risks in a crash case
>  >  > with a dirty bitmap.
>  >  >
>  >  > This is the command I used to set it up.
>  >  > mdadm --grow --force --bitmap=3D/mdraid-bitmaps/md15-bitmap.img /de=
v/md15
>  > =20
>  >  In this case the result cited seems to have shown the bitmap is not t=
he issue.
>  > =20
>  >  I remember seeing patches or talks to remove external bitmap support,=
 too.
>  > =20
>  >  In my experience the internal bitmap with a large enough chunk size d=
oes not
>  >  slow down the write speed that much. Try a chunk size of 256M. Not su=
re how
>  >  high it's worth going before the benefits diminish.
>  > =20
>  >  --
>  >  With respect,
>  >  Roman
>  >  
