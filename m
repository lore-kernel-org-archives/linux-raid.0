Received: from fout-a4-smtp.messagingengine.com (fout-a4-smtp.messagingengine.com [103.168.172.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B2029A9
	for <linux-raid@vger.kernel.org>; Mon, 31 Mar 2025 16:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743439018; cv=none; b=Xl5z8lUyOg6mu2l/9CcluL/GuCCZ4gZ1UdBBSKCZWIlrZV/39muYVvTkev8EZ3YhXzyGB+VlcGidwm5pLJsE5ausxfUmv6YiqDnSZbA0Gfqjv6JfVIzHrvlxjqEtRJQZ1hgMHIxyGZo9LWdtKv3yKAWmY/MV5osoea/Rw1LoWDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743439018; c=relaxed/simple;
	bh=TN9upDtXIsdiHK6sfEB5A70fx8UePn9qCBwT/zoNC+8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sFmjPijvjcSGLEwSPXevRv4WgfxNDtuovAod3/dzGjoh1iowFoI5JmAjEepnZH8brbgJwC25oS8/4dSTc8gvYnECH6WBdK4AUpSfpa7n0qbWu+sxvMNpC+RWJxeyvQ57OJO8UlBk7TUsxkyybCkd2kqJqFZQ+FCbkMtPVtKay9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dev-mail.net; spf=pass smtp.mailfrom=dev-mail.net; dkim=pass (2048-bit key) header.d=dev-mail.net header.i=@dev-mail.net header.b=NS2JHx9P; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=kIDaUQR6; arc=none smtp.client-ip=103.168.172.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dev-mail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dev-mail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dev-mail.net header.i=@dev-mail.net header.b="NS2JHx9P";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="kIDaUQR6"
Received: from phl-compute-05.internal (phl-compute-05.phl.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id E406B138458D;
	Mon, 31 Mar 2025 12:36:53 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Mon, 31 Mar 2025 12:36:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dev-mail.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to; s=fm1; t=
	1743439013; x=1743525413; bh=xbASriGxy7lbY8XAarBT3puZxKFH6IZbRVx
	Ss/LqNEw=; b=NS2JHx9PIwFHC5DuIz+6C2/jfWakgZR9oMvMr68UOLs8np22P/v
	28PrCBV+isTrvNm+JiFncuT6+6cBlERd1nAQ+n1SRnsbI1V0NdhrbDRZ9dj0d012
	Rq3qfIZzxuGWmofftMudx++xacEBCIKy92fndXRQYi9AUYu9/HSceiJUy1u4xsfH
	V8CeVTjvUqSRQJ49Hb0UDz/qG040h7Io6MU8IdmjoeLJnm166uItAjgc5TxRoIJR
	zbUy9zcK5mTu66O18e95RvamgIcRwhListbQDcT6m8oTJU5tcrh6DNC60wzv/XE4
	hHuwjQiic8YWTtx1qL4CirKUrtXKBMlY8ew==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1743439013; x=
	1743525413; bh=xbASriGxy7lbY8XAarBT3puZxKFH6IZbRVxSs/LqNEw=; b=k
	IDaUQR691uD6T1BTzYUnfn+m6eayogzJXSMMFNcOg/f5uVIHyOqlHc/lwIlJLTrm
	Jq9UEuI/c/Rf3DkMWAfz40IbFCY9DVwyharIo+RL217Vyo1SIIrwg7d+TlpmrAV2
	+OhAppZKL+9YtFoW2O812txkTnDxM3TXlxI4mueFK4FdsZ4vkGSjDH5/tUZRfB6C
	+WlMdDwHU+YN8liIMBLgFFNKbNRgFJf8RYTLL3wbMOnXInqwC0nzvJ/21FWLJX7K
	Za7gv76vQbEocgj4ZiAIGSLepQMjvFrcoJXb8/yrUrahTxtUwWJDWkeu+EsZVfH6
	7yo0z1ozEGCaIzecNweyw==
X-ME-Sender: <xms:pcTqZ02c_6DxXwgA8EbOcyAeY1IUOu7ZRuENSRGmbqnxNDd0je9h6A>
    <xme:pcTqZ_HWNFhIHJ1RKB7NcWU6KA7aSoPHT9LzNdXBMNpGmQknVUOPtVsa9CK9FJKGm
    KTzhjM5kcxDTWI9>
X-ME-Received: <xmr:pcTqZ85iKCOqd6lfqSyn8txhaossU3Q_J94hnky-wsNReUZaiOy7c84BlEmd4KnOHumbpanxIMZjXbf0NUUIMOdw_A5FjhMOvHZH2rA5>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgddukedtgedvucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggv
    pdfurfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucenucfjughrpefkff
    ggfghruffvvehfhfgjtgfgsehtkeertddtvdejnecuhfhrohhmpehpghhnugcuoehpghhn
    ugesuggvvhdqmhgrihhlrdhnvghtqeenucggtffrrghtthgvrhhnpeduudejgeeuvdffff
    eufeehgffgtdfhkeekvefggfetkeegvedvveethfduieffleenucevlhhushhtvghrufhi
    iigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehpghhnugesuggvvhdqmhgrihhlrd
    hnvghtpdhnsggprhgtphhtthhopedvpdhmohguvgepshhmthhpohhuthdprhgtphhtthho
    peignhhisehrvgguhhgrthdrtghomhdprhgtphhtthhopehlihhnuhigqdhrrghiugesvh
    hgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:pcTqZ92Rwj8uaJwTTD59lOpjG5RhnhWlLYyKBKnNtXpyKi6egiYFmg>
    <xmx:pcTqZ3Ft5E5z7nltKC9daoR8-mWZTmbRbN3Ab6cUsN7fywPX0Br0LQ>
    <xmx:pcTqZ2-7qDRi5bzziN6ke3uqAtTvERO3FzKemQhdiPIEW_rgdyIzdQ>
    <xmx:pcTqZ8kZL4P68XhfIpgwRfoSH5V5FOWHleimf9MDZBdydG7LUypkJg>
    <xmx:pcTqZ4PssIQczq13wNnhiz-bln-piPkMgBGdVqZycq8MUyl1pM22pKsR>
Feedback-ID: if6e94526:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 31 Mar 2025 12:36:53 -0400 (EDT)
Message-ID: <0d9732b1-84c5-4875-ad22-25e546584fbf@dev-mail.net>
Date: Mon, 31 Mar 2025 12:36:52 -0400
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: pgnd@dev-mail.net
Subject: Re: extreme RAID10 rebuild times reported, but rebuild's progressing
 ?
Content-Language: en-US
To: xni@redhat.com
Cc: linux-raid@vger.kernel.org
References: <5fc88c9b-83a7-414c-82da-7cccb1f876f3@dev-mail.net>
 <CALTww2-=QABMBKatYQVJ+VSAVTXvvhn1jJFUqf8ZZZb3+nx0Mw@mail.gmail.com>
From: pgnd <pgnd@dev-mail.net>
In-Reply-To: <CALTww2-=QABMBKatYQVJ+VSAVTXvvhn1jJFUqf8ZZZb3+nx0Mw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

hi.

> Are there some D state progress?

no, there were none.

the rebuild 'completed' in ~ 1hr 15mins ...
atm, the array's up, passing all tests, and seemingly fully functional

> And how about `ps auxf | grep md`?

ps auxf | grep md
	root          97  0.0  0.0      0     0 ?        SN   09:10   0:00  \_ [ksmd]
	root         107  0.0  0.0      0     0 ?        I<   09:10   0:00  \_ [kworker/R-md]
	root         108  0.0  0.0      0     0 ?        I<   09:10   0:00  \_ [kworker/R-md_bitmap]
	root        1049  0.0  0.0      0     0 ?        S    09:10   0:00  \_ [md124_raid10]
	root        1052  0.0  0.0      0     0 ?        S    09:10   0:00  \_ [md123_raid10]
	root        1677  0.0  0.0      0     0 ?        S    09:10   0:00  \_ [jbd2/md126-8]
	root           1  0.0  0.0  24820 15536 ?        Ss   09:10   0:03 /usr/lib/systemd/systemd --switched-root --system --deserialize=49 domdadm dolvm showopts noquiet
	root        1308  0.0  0.0  32924  8340 ?        Ss   09:10   0:00 /usr/lib/systemd/systemd-journald
	root        1368  0.0  0.0  36620 11596 ?        Ss   09:10   0:00 /usr/lib/systemd/systemd-udevd
	systemd+    1400  0.0  0.0  17564  9160 ?        Ss   09:10   0:00 /usr/lib/systemd/systemd-networkd
	systemd+    2010  0.0  0.0  15932  7112 ?        Ss   09:11   0:02 /usr/lib/systemd/systemd-oomd
	root        2029  0.0  0.0   4176  2128 ?        Ss   09:11   0:00 /sbin/mdadm --monitor --scan --syslog -f --pid-file=/run/mdadm/mdadm.pid
	root        2055  0.0  0.0  16648  8012 ?        Ss   09:11   0:00 /usr/lib/systemd/systemd-logind
	root        2121  0.0  0.0  21176 12288 ?        Ss   09:11   0:00 /usr/lib/systemd/systemd --user
	root        4105  0.0  0.0 230344  2244 pts/0    S+   12:21   0:00              \_ grep --color=auto md
	root        2247  0.0  0.0 113000  6236 ?        Ssl  09:11   0:00 /usr/sbin/automount --systemd-service --dont-check-daemon

> there a filesystem on it? If so, can you still read/write data from it?

yes, and yes.

pvs
   PV         VG         Fmt  Attr PSize  PFree
   /dev/md123 VG_D1    lvm2 a--   5.45t     0
   /dev/md124 VG_D1    lvm2 a--   7.27t     0
vgs
   VG       #PV #LV #SN Attr   VSize  VFree
   VG_D1      2   1   0 wz--n- 12.72t     0
lvs
   LV             VG         Attr       LSize  Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
   LV_D1          VG_D1      -wi-ao---- 12.72t

cat /proc/mdstat
	Personalities : [raid1] [raid10]
	md123 : active (auto-read-only) raid10 sdg1[3] sdh1[4] sdj1[2] sdi1[1]
	      5860265984 blocks super 1.2 512K chunks 2 near-copies [4/4] [UUUU]
	      bitmap: 0/44 pages [0KB], 65536KB chunk

	md124 : active raid10 sdl1[0] sdm1[1] sdn1[2] sdk1[4]
	      7813770240 blocks super 1.2 512K chunks 2 near-copies [4/4] [UUUU]
	      bitmap: 0/59 pages [0KB], 65536KB chunk

lsblk /dev/sdn
	NAME                  MAJ:MIN RM  SIZE RO TYPE   MOUNTPOINTS
	sdn                     8:208  0  3.6T  0 disk
	└─sdn1                  8:209  0  3.6T  0 part
	  └─md124               9:124  0  7.3T  0 raid10
	    └─VG_D1-LV_D1     253:8    0 12.7T  0 lvm    /NAS/D1

fdisk -l /dev/sdn
	Disk /dev/sdn: 3.64 TiB, 4000787030016 bytes, 7814037168 sectors
	Disk model: WDC WD40EFPX-68C
	Units: sectors of 1 * 512 = 512 bytes
	Sector size (logical/physical): 512 bytes / 4096 bytes
	I/O size (minimum/optimal): 4096 bytes / 131072 bytes
	Disklabel type: gpt
	Disk identifier: ...

	Device     Start        End    Sectors  Size Type
	/dev/sdn1   2048 7814037134 7814035087  3.6T Linux RAID

fdisk -l /dev/sdn1
	Disk /dev/sdn1: 3.64 TiB, 4000785964544 bytes, 7814035087 sectors
	Units: sectors of 1 * 512 = 512 bytes
	Sector size (logical/physical): 512 bytes / 4096 bytes
	I/O size (minimum/optimal): 4096 bytes / 131072 bytes

cat /proc/mounts  | grep D1
	/dev/mapper/VG_D1-LV_D1 /NAS/D1 ext4 rw,relatime,stripe=128 0 0


touch /NAS/D1/test.file
stat /NAS/D1/test.file
	  File: /NAS/D1/test.file
	  Size: 0               Blocks: 0          IO Block: 4096   regular empty file
	Device: 253,8   Inode: 11          Links: 1
	Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
	Access: 2025-03-31 12:33:48.110052013 -0400
	Modify: 2025-03-31 12:33:48.110052013 -0400
	Change: 2025-03-31 12:33:48.110052013 -0400
	 Birth: 2025-03-31 12:33:07.272309441 -0400
