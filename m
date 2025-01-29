Received: from fhigh-a8-smtp.messagingengine.com (fhigh-a8-smtp.messagingengine.com [103.168.172.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489D41DE8BE
	for <linux-raid@vger.kernel.org>; Wed, 29 Jan 2025 16:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738167148; cv=none; b=Uo9YZm+JWrYtm8c4vwXTV28WkCvbJTqQWpdAG8dP1aZEFvOIWOJks0aQ48rAypsBqMxNIA3geaBiwH52M1kY+iYBM7aOBfDWOmUTQ9k271FX+fbVlwVfgTo3wX/Us71b6Ui93/1u4J/gaL36QW2hzRrZvK7rc14Mm9Pj61nkRPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738167148; c=relaxed/simple;
	bh=dnKAo2FAvMntPIhNJNY8GSh5WJMwq5GgPlN20i59xj4=;
	h=Message-ID:Date:MIME-Version:From:To:Subject:Content-Type; b=t19munvWGXMCJ2/oYU3C5BzRN1yz3kWAnqDeJdw7Qf0HWHTtjcnCkEo1yVXxFdiIFg8c1q4cEcwRb8IQqHIN3iFdMWx9yB399xNPE5NPKBtKljQiLT0IZzQFCVwXOPnnDtsp5HUK1XQh/xdhZrE1j2R8L/DTr230gNVtUS7LBDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dev-mail.net; spf=pass smtp.mailfrom=dev-mail.net; dkim=pass (2048-bit key) header.d=dev-mail.net header.i=@dev-mail.net header.b=U/f4A297; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=f6lFXG2P; arc=none smtp.client-ip=103.168.172.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dev-mail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dev-mail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dev-mail.net header.i=@dev-mail.net header.b="U/f4A297";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="f6lFXG2P"
Received: from phl-compute-09.internal (phl-compute-09.phl.internal [10.202.2.49])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 2A05811400CC
	for <linux-raid@vger.kernel.org>; Wed, 29 Jan 2025 11:12:25 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-09.internal (MEProxy); Wed, 29 Jan 2025 11:12:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dev-mail.net; h=
	cc:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:message-id:mime-version:reply-to:reply-to
	:subject:subject:to:to; s=fm2; t=1738167145; x=1738253545; bh=yN
	2XoecuhrNe18m2Dj22aUSSKDhzCwpjL+QC9VhX4iI=; b=U/f4A297SaZs/QwWTc
	Yg//MpuVJQgnqQmIWoSyWeaBgI/Z9mR8P8jq+1vpxYyKJdZ18xqla1cLQ7PxXfS1
	OI8mNEH+01Rm3cT115INa2Ije5nOx51A96MdjWsDBUkjf39n6lZNhsusBdw4dX4+
	WzjiAoHFjPbDT9frZavLQv4liCoIjEZYWCZP1AkaPf/c/PAkbc7z+RCJ8UHD4DdC
	mMxhbiR85jKwKqj/DX8XtCeIsmHoG27DSBesWJ+mZqmp0tPF5toBcxN9Hda3//Za
	tbZG8gK+dndtCBPyiRpllj8Zy5lxrBbmCdUsKCfcK0gkzgF/AUtVcv8t+92PdjYH
	AydQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm3; t=1738167145; x=1738253545; bh=yN2XoecuhrNe18m2Dj22aUSSKDhz
	CwpjL+QC9VhX4iI=; b=f6lFXG2PLcNM+IxOyxRoKaBIifylb7S7Mle03RnlkxE8
	RSWOUfLQULOl7+yUWsqGN/SqSGsYFdwYAlSRokx1HVoOqpVLxijoJpx6fiddvVmh
	7uMnKwkVTLBGGT3sXb2qAtrlmJEma3CCSC8Yt587fdEJP8owUoWumX593bqu5LuM
	qRG6c0F+QiahWHXncYeDacYR3if1cGqLUIea0e9RE2/cLa2iv0EwbhsHudQAAzom
	wNYaItMTIpbbT5BfOgdbXH5IyZwh8OXOs68QrTqSCgssV4ZN3EqK34u7R7cX3774
	CgmU6J3VrzDY9DtdhQmSYX2Rc+v/jjpElAQ3nnuHNQ==
X-ME-Sender: <xms:aFOaZ4tDfE1mxHmRtSwUpJ9mu-DGkRhoQw7MH5otjFORT1L8BDteAg>
    <xme:aFOaZ1fAsbgcDErK57Qh6F6vpvUU0a48wF1oYOJrJoiMYDrJPwlv5yyeR-6paNLlJ
    UuvMChbU7omUiHK>
X-ME-Received: <xmr:aFOaZzxnERCb_Ljd6k33-xkWxgJAmf0RCgUT46v2H1taggY9q6bV_-vK3683pob12Tf50R5NHqwP8Q0JA7n8siwJkLhUg3kJYO_nW5v0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgdefgeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucenucfjughrpefkffggfg
    hrhffvufgtgfesthejredttddvjeenucfhrhhomhepphhgnhguuceophhgnhguseguvghv
    qdhmrghilhdrnhgvtheqnecuggftrfgrthhtvghrnhephfdtjeelveevudegieejhfejle
    ehhfeltdeuhefhieekjeekieffteejgfdvueevnecuvehluhhsthgvrhfuihiivgeptden
    ucfrrghrrghmpehmrghilhhfrhhomhepphhgnhguseguvghvqdhmrghilhdrnhgvthdpnh
    gspghrtghpthhtohepuddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheplhhinhhu
    gidqrhgrihgusehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:aFOaZ7NIXPLFxPRTBeSnwPPgeZw_3MXiDJNALYWA58bGvoAUeozWbA>
    <xmx:aVOaZ4-K45XTs2MkaN31E904zD1uYVQFSuX25uyx2EZtRVOcv8ew0w>
    <xmx:aVOaZzUVGX8CrG_3k8QxEN_mCUf9FyTBrKpQNToPzOUb9NbENBAIlA>
    <xmx:aVOaZxc3NZxPf-mx7IWl21JdUU-0B5tBep3Ez95hCNtNIxAz2D9Q1g>
    <xmx:aVOaZ8bxV8SvyxMNvVz8P4PeuUzDh81s2HP2wymIi4EmPQu1Z_YwcqMx>
Feedback-ID: if6e94526:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA for
 <linux-raid@vger.kernel.org>; Wed, 29 Jan 2025 11:12:24 -0500 (EST)
Message-ID: <b57aabc1-cb65-411c-b79c-ee8aa3fb849f@dev-mail.net>
Date: Wed, 29 Jan 2025 11:12:24 -0500
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: pgnd@dev-mail.net
From: pgnd <pgnd@dev-mail.net>
Content-Language: en-US
To: linux-raid@vger.kernel.org
Subject: replaced all drives in RAID-10 array with larger drives -> failing to
 correctly extend array to use new/add'l space.
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

i've replaced a working RAID-10 array's 4x3TB drives with new 4x4TB drives.

i run

	uname -rm
		6.12.10-200.fc41.x86_64 x86_64
	mdadm --version
		mdadm - v4.3 - 2024-02-15

the array's been rebuilt -- replacing one drive at a time -- & is up

	cat /proc/mdstat
		Personalities : [raid1] [raid10]
		md2 : active raid10 sdl1[4] sdk1[7] sdn1[5] sdm1[6]
		      5860268032 blocks super 1.2 512K chunks 2 far-copies [4/4] [UUUU]
		      bitmap: 0/44 pages [0KB], 65536KB chunk
	
	mdadm --detail /dev/md2
		/dev/md2:
		           Version : 1.2
		     Creation Time : Tue Oct 31 22:29:24 2017
		        Raid Level : raid10
		        Array Size : 5860268032 (5.46 TiB 6.00 TB)
		     Used Dev Size : 2930134016 (2.73 TiB 3.00 TB)
		      Raid Devices : 4
		     Total Devices : 4
		       Persistence : Superblock is persistent

		     Intent Bitmap : Internal

		       Update Time : Wed Jan 29 10:43:38 2025
		             State : clean
		    Active Devices : 4
		   Working Devices : 4
		    Failed Devices : 0
		     Spare Devices : 0

		            Layout : far=2
		        Chunk Size : 512K

		Consistency Policy : bitmap

		              Name : nas:2
		              UUID : c...
		            Events : 14122

		    Number   Major   Minor   RaidDevice State
		       4       8      177        0      active sync   /dev/sdl1
		       6       8      193        1      active sync   /dev/sdm1
		       5       8      209        2      active sync   /dev/sdn1
		       7       8      161        3      active sync   /dev/sdk1

i'm now attempting to resize the array to use the new/full space.

i have

	pvs
	  PV         VG         Fmt  Attr PSize  PFree
	  /dev/md2   VG_N1      lvm2 a--  <5.46t     0
	  /dev/md3   VG_N1      lvm2 a--  <5.46t     0
   
	vgs
	  VG         #PV #LV #SN Attr   VSize   VFree
	  VG_N1        2   1   0 wz--n- <10.92t     0

	lvs
	  LV             VG         Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
	  LV_N1          VG_N1      -wi-a----- <10.92t

after resizing the drive partitions

	fdisk -l /dev/sdk
		Disk /dev/sdk: 3.64 TiB, 4000787030016 bytes, 7814037168 sectors
		Disk model: WDC WD40EFPX-68C
		Units: sectors of 1 * 512 = 512 bytes
		Sector size (logical/physical): 512 bytes / 4096 bytes
		I/O size (minimum/optimal): 4096 bytes / 16773120 bytes
		Disklabel type: gpt
		Disk identifier: 3...

		Device     Start        End    Sectors  Size Type
		/dev/sdk1   2048 7814037134 7814035087  3.6T Linux RAID


	fdisk -l /dev/sd[lmn] | grep "Linux RAID"
		/dev/sdl1   2048 7814037134 7814035087  3.6T Linux RAID
		/dev/sdm1   2048 7814037134 7814035087  3.6T Linux RAID
		/dev/sdn1   2048 7814037134 7814035087  3.6T Linux RAID

then

	pvresize -v /dev/md2
		Resizing volume "/dev/md2" to 11720536064 sectors.
		No change to size of physical volume /dev/md2.
		Updating physical volume "/dev/md2"
		Archiving volume group "VG_N1" metadata (seqno 12).
		Physical volume "/dev/md2" changed
		Creating volume group backup "/etc/lvm/backup/VG_N1" (seqno 13).
		1 physical volume(s) resized or updated / 0 physical volume(s) not resized

pvs STILL returns

	pvs
		PV         VG         Fmt  Attr PSize  PFree
		/dev/md2   VG_N1      lvm2 a--  <5.46t     0  <--------- NOT expanded
		/dev/md3   VG_N1      lvm2 a--  <5.46t     0

attempt to `--grow` the array doesn't succeed

	umount /dev/VG_N1/LV_N1
	mdadm --stop /dev/md2
	mdadm --assemble --force /dev/md2 /dev/sdk1 /dev/sdl1 /dev/sdm1 /dev/sdn1
	lvchange -an /dev/VG_N1/LV_N1
	vgchange -an /dev/VG_N1

	mdadm --grow /dev/md2 --raid-devices=4 --size=max --force

		mdadm: cannot change component size at the same time as other changes.
			Change size first, then check data is intact before making other changes.

what's incorrect/missing in that procedure?  how do i get the full partitions to be used by the array?
