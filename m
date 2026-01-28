Received: from mail-244123.protonmail.ch (mail-244123.protonmail.ch [109.224.244.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AABDA246782
	for <linux-raid@vger.kernel.org>; Wed, 28 Jan 2026 08:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.224.244.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769588745; cv=none; b=OpiMmWgZEIoXTb1UruKR7szzt5Z6JS2xJx8Etnmnkdz0Sj8VU947Ol0nJ8GtMvTcz89wUMp0gn+VIDNW09c6RUhhxAhYm64NzCd8v9oi294gaQLZVQodOZXxtPmpXm4KmT8sZhEOjCJyguvxQLeX/QeGzWe7AX8dOyV/hgHXdK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769588745; c=relaxed/simple;
	bh=tUvK/uxeJjAJtdmXkt162y+YT38dOvmKAq3QwZ+kHzQ=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=ExUYkbHIk26bytXXYlFuQU18c3wvTfqzRmWD4twAledMP/4BCmTj1SgecSDr2DFlN/JHAia2PF3wTm95+OdEiZ3M8OOb+krT1OwNKsuhgtytYH+yh0rIhTxcopESG5gJDbIFmw/9TP+/NKaBj8TGjHyNgBhaRQtrrWdN1l3lLIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=Jt+WJ7vt; arc=none smtp.client-ip=109.224.244.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="Jt+WJ7vt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1769588731; x=1769847931;
	bh=tUvK/uxeJjAJtdmXkt162y+YT38dOvmKAq3QwZ+kHzQ=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=Jt+WJ7vt2YP/6A3DebHiPF6ceK7ys0fp+UrubtxU0xFRk6xbuyq4Am5oltUQm4Y7z
	 yYb8RdTwuGlMLg0Nussa9gy7+3XVW2mu3GICpFtDwjtKXjT0rzIUEhkPBslmEjPFm1
	 vfirhzT+WMMChG9COXOx0DXQMj6IPRvevfGQ1uee9bmmuDd1lJJFduP8MV9UfsqNEJ
	 VTMmEsWpbNjZ1AaQEAhVU9y7kxh40cptZDg1gcx8fIaNp/ldwY7Fnyy3ztvpSJRknN
	 tbHh++LfcGy5IP1YXCJVufHYE6CEP9VoxswW2bUy6PtR1vwfplOuZ3bVIVO0eiiAj0
	 My+PDCyUamlEg==
Date: Wed, 28 Jan 2026 08:25:28 +0000
To: yukuai@fnnas.com
From: Tj <tj.iam.tj@proton.me>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: md: regression: incorrect warn about updating super block failure
Message-ID: <20260128082430.96788-1-tj.iam.tj@proton.me>
Feedback-ID: 113488376:user:proton
X-Pm-Message-ID: 58be0658139b4d2de0693839171b80f80a820fe2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Commit 8c9e376b9d1a222 introduces an error message that is incorrectly repo=
rted for LVM raid volumes:

$ journalctl --dmesg --priority err
 md_update_sb: can't update sb for read-only array mdX
 md_update_sb: can't update sb for read-only array mdX
 md_update_sb: can't update sb for read-only array mdX
 md_update_sb: can't update sb for read-only array mdX
 md_update_sb: can't update sb for read-only array mdX
 md_update_sb: can't update sb for read-only array mdX
 md_update_sb: can't update sb for read-only array mdX
 md_update_sb: can't update sb for read-only array mdX
 md_update_sb: can't update sb for read-only array mdX
 md_update_sb: can't update sb for read-only array mdX
 md_update_sb: can't update sb for read-only array mdX
 md_update_sb: can't update sb for read-only array mdX
 md_update_sb: can't update sb for read-only array mdX
 md_update_sb: can't update sb for read-only array mdX
 md_update_sb: can't update sb for read-only array mdX
 md_update_sb: can't update sb for read-only array mdX

$ sudo dmsetup table --target raid
SUNNY-Documents: 0 20971520 raid raid1 3 0 region_size 4096 2 254:74 254:75=
 254:76 254:77
SUNNY-Media: 0 171966464 raid raid1 3 0 region_size 4096 2 254:69 254:70 25=
4:71 254:72
SUNNY-NAS: 0 46874624 raid raid1 3 0 region_size 4096 2 254:15 254:16 254:1=
7 254:18
SUNNY-Projects: 0 23068672 raid raid1 3 0 region_size 4096 2 254:20 254:21 =
254:22 254:23
SUNNY-SourceCode_wcorig: 0 478150656 raid raid1 3 0 region_size 4096 2 254:=
26 254:27 254:28 254:29
SUNNY-WINE: 0 16777216 raid raid1 3 0 region_size 4096 2 254:80 254:81 254:=
82 254:83
SUNNY-etc: 0 106496 raid raid1 3 0 region_size 4096 2 254:57 254:58 254:59 =
254:60
SUNNY-home_wcorig: 0 301989888 raid raid1 3 0 region_size 4096 2 254:46 254=
:47 254:48 254:49
SUNNY-l8r: 0 16777216 raid raid1 3 0 region_size 4096 2 254:37 254:38 254:3=
9 254:40
SUNNY-machines_old: 0 34185216 raid raid1 3 0 region_size 4096 2 254:32 254=
:33 254:34 254:35
SUNNY-opt: 0 41943040 raid raid1 3 0 region_size 4096 2 254:64 254:65 254:6=
6 254:67
SUNNY-rootfs: 0 67108864 raid raid1 3 0 region_size 4096 2 254:3 254:4 254:=
5 254:6
SUNNY-usr_local: 0 16777216 raid raid1 3 0 region_size 4096 2 254:52 254:53=
 254:54 254:55
SUNNY-var_wcorig: 0 25165824 raid raid1 3 0 region_size 4096 2 254:9 254:10=
 254:11 254:12

