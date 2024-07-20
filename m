Received: from mx-out.tlen.pl (mx-out.tlen.pl [193.222.135.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 216117EEE7
	for <linux-raid@vger.kernel.org>; Sat, 20 Jul 2024 14:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.222.135.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721487260; cv=none; b=r23g3HJoDHH9UDd9yeTg9+MdEFG1ZfaPJAZ9+5GtJgjCxHrRQ8WU8PCujqqlzK5HoeMHDgT98Dk9cW0Jwx06IfXYuzwL2fcdJtjSrphDgi2rj+QsTvktUi7RaULoJ5jVwyQmdSWRG8CxmCuBIQOj7PmePaKvYo5++9gfW3rAfLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721487260; c=relaxed/simple;
	bh=XgKFTPwr4HtPn+KtrrkKxdUaWtm/HHY9NC0W700cKeg=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=Epnkb5nLKQcTaIAn5RL9xSw+VPRaA0cYQ1GfibnAy98mBF9A01tvPXbplen4280FXIy4rHj8p1SWLWl31ip0WWReQevPuiidg7VdwBisxEH1NMcAK+Wy73OHx5S7M2UOpa/XByG+csxjQCMCW2HJYaOANLI0sW/Zjxu1I56TgeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=o2.pl; spf=pass smtp.mailfrom=o2.pl; dkim=pass (1024-bit key) header.d=o2.pl header.i=@o2.pl header.b=aD4CXUL+; arc=none smtp.client-ip=193.222.135.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=o2.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=o2.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=o2.pl header.i=@o2.pl header.b="aD4CXUL+"
Received: (wp-smtpd smtp.tlen.pl 18154 invoked from network); 20 Jul 2024 16:47:35 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=o2.pl; s=1024a;
          t=1721486855; bh=XgKFTPwr4HtPn+KtrrkKxdUaWtm/HHY9NC0W700cKeg=;
          h=To:Cc:From:Subject;
          b=aD4CXUL+uDUM6HQFJsL8Aqa5i8czSid++liYaGbXCNPvPlYWrL/POd/P89q4+nTfh
           0dz5LnSs30B1D4HmCSN5ylGRlk++98hsKjz+AZTXCTGYbOKtDqDOhh6VkMz/i5MpYv
           dznM8seA1RDCO3CxFapqtqTfZagyEam2qUBryvAs=
Received: from aafc224.neoplus.adsl.tpnet.pl (HELO [192.168.1.22]) (mat.jonczyk@o2.pl@[83.4.132.224])
          (envelope-sender <mat.jonczyk@o2.pl>)
          by smtp.tlen.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <yukuai3@huawei.com>; 20 Jul 2024 16:47:35 +0200
Message-ID: <9952f532-2554-44bf-b906-4880b2e88e3a@o2.pl>
Date: Sat, 20 Jul 2024 16:47:32 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-GB
To: Yu Kuai <yukuai3@huawei.com>, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: Song Liu <song@kernel.org>, Paul Luse <paul.e.luse@linux.intel.com>
From: =?UTF-8?Q?Mateusz_Jo=C5=84czyk?= <mat.jonczyk@o2.pl>
Subject: Filesystem corruption when adding a new device (delayed-resync,
 write-mostly)
Autocrypt: addr=mat.jonczyk@o2.pl; keydata=
 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
 TANkZ3QqXNX2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-WP-MailID: afd04bceba71a8a829ad292e361e989d
X-WP-AV: skaner antywirusowy Poczty o2
X-WP-SPAM: NO 0000000 [AXPU]                               

Hello,

In my laptop, I used to have two RAID1 arrays on top of NVMe and SATA SSD
drives: /dev/md0 for /boot (not partitioned), /dev/md1 for remaining data (LUKS
+ LVM + ext4). For performance, I have marked the RAID component device for
/dev/md1 on the SATA SSD drive write-mostly, which "means that the 'md' driver
will avoid reading from these devices if at all possible" (man mdadm).

Recently, the NVMe drive started having problems (PCI AER errors and the
controller disappearing), so I removed it from the arrays and wiped it.
However, I have reseated the drive in the M.2 socket and this apparently fixed
it (verified with tests).

    $ cat /proc/mdstat
    Personalities : [raid1] [linear] [multipath] [raid0] [raid6] [raid5] [raid4] [raid10]
    md1 : active raid1 sdb5[1](W)
          471727104 blocks super 1.2 [2/1] [_U]
          bitmap: 4/4 pages [16KB], 65536KB chunk

    md2 : active (auto-read-only) raid1 sdb6[3](W) sda1[2]
          3142656 blocks super 1.2 [2/2] [UU]
          bitmap: 0/1 pages [0KB], 65536KB chunk

    md0 : active raid1 sdb4[3]
          2094080 blocks super 1.2 [2/1] [_U]
         
    unused devices: <none>

(md2 was used just for testing, ignore it).

Today, I have tried to add the drive back to the arrays by using a script that
executed in quick succession:

    mdadm /dev/md0 --add --readwrite /dev/nvme0n1p2
    mdadm /dev/md1 --add --readwrite /dev/nvme0n1p3

This was on Linux 6.10.0, patched with my previous patch:

    https://lore.kernel.org/linux-raid/20240711202316.10775-1-mat.jonczyk@o2.pl/

(which fixed a regression in the kernel and allows it to start /dev/md1 with a
single drive in write-mostly mode).
In the background, I was running "rdiff-backup --compare" that was comparing
data between my array contents and a backup attached via USB.

This, however resulted in mayhem - I was unable to start any program with an
input-output error, etc. I used SysRQ + C to save a kernel log:

    [ 4940.891490] md: could not open device unknown-block(259,1).
    [ 4940.891498] md: md_import_device returned -16
    [ 4940.920440] md: could not open device unknown-block(259,1).
    [ 4940.920449] md: md_import_device returned -16
    [ 4940.934462] md: recovery of RAID array md0
    [ 4941.003041] EXT4-fs warning (device dm-4): ext4_dirblock_csum_verify:405: inode #16676515: comm rdiff-backup: No space for directory leaf checksum. Please run e2fsck -D.
    [ 4941.003053] EXT4-fs error (device dm-4): htree_dirblock_to_tree:1082: inode #16676515: comm rdiff-backup: Directory block failed checksum
    [ 4941.003061] Aborting journal on device dm-4-8.
    [ 4941.066131] md: delaying recovery of md1 until md0 has finished (they share one or more physical units)
    [ 4941.092374] EXT4-fs (dm-4): Remounting filesystem read-only
    [ 4942.301499] EXT4-fs warning (device dm-2): ext4_dirblock_csum_verify:405: inode #156120: comm gnome-terminal-: No space for directory leaf checksum. Please run e2fsck -D.
    [ 4942.301508] EXT4-fs error (device dm-2): __ext4_find_entry:1693: inode #156120: comm gnome-terminal-: checksumming directory block 0
    [ 4942.301515] Aborting journal on device dm-2-8.
    [ 4942.332393] EXT4-fs (dm-2): Remounting filesystem read-only
    [ 4942.333839] EXT4-fs warning (device dm-2): ext4_dirblock_csum_verify:405: inode #156120: comm gnome-terminal-: No space for directory leaf checksum. Please run e2fsck -D.
    [ 4942.765422] EXT4-fs warning (device dm-2): ext4_dirblock_csum_verify:405: inode #156120: comm gnome-terminal-: No space for directory leaf checksum. Please run e2fsck -D.
    [ 4942.766884] EXT4-fs warning (device dm-2): ext4_dirblock_csum_verify:405: inode #156120: comm gnome-terminal-: No space for directory leaf checksum. Please run e2fsck -D.
    [ 4947.364466] EXT4-fs warning (device dm-2): ext4_dirblock_csum_verify:405: inode #156120: comm gnome-terminal-: No space for directory leaf checksum. Please run e2fsck -D.
    [ 4947.366435] EXT4-fs warning (device dm-2): ext4_dirblock_csum_verify:405: inode #156120: comm gnome-terminal-: No space for directory leaf checksum. Please run e2fsck -D.
    [ 4947.849698] EXT4-fs warning (device dm-2): ext4_dirblock_csum_verify:405: inode #156120: comm gnome-terminal-: No space for directory leaf checksum. Please run e2fsck -D.
    [ 4947.851860] EXT4-fs warning (device dm-2): ext4_dirblock_csum_verify:405: inode #156120: comm gnome-terminal-: No space for directory leaf checksum. Please run e2fsck -D.
    [ 4949.226094] EXT4-fs warning (device dm-2): ext4_dirblock_csum_verify:405: inode #156120: comm gnome-terminal-: No space for directory leaf checksum. Please run e2fsck -D.
    [ 4949.227982] EXT4-fs warning (device dm-2): ext4_dirblock_csum_verify:405: inode #156120: comm gnome-terminal-: No space for directory leaf checksum. Please run e2fsck -D.
    [ 4949.696095] EXT4-fs warning (device dm-2): ext4_dirblock_csum_verify:405: inode #156120: comm gnome-terminal-: No space for directory leaf checksum. Please run e2fsck -D.
    [ 4949.697468] EXT4-fs warning (device dm-2): ext4_dirblock_csum_verify:405: inode #156120: comm gnome-terminal-: No space for directory leaf checksum. Please run e2fsck -D.
    [ 4950.105158] EXT4-fs warning (device dm-2): ext4_dirblock_csum_verify:405: inode #156120: comm pool-gnome-shel: No space for directory leaf checksum. Please run e2fsck -D.
    [ 4950.105645] EXT4-fs warning (device dm-2): ext4_dirblock_csum_verify:405: inode #156120: comm pool-gnome-shel: No space for directory leaf checksum. Please run e2fsck -D.
    [ 4951.559184] md: md0: recovery done.
    [ 4951.562154] md: recovery of RAID array md1
    [ 4952.636764] EXT4-fs warning: 6 callbacks suppressed

The interesting fact is that both dm-4 and dm-2 are on /dev/md1, which was
modified second, and should not have been touched (or read from) before the
resync of /dev/md0 was complete.

I have restarted the laptop on the same kernel, and this apparently
made things worse (perhaps fsck at boot corrupted my root filesystem).
All in all, other filesystems were relatively unaffected, but the root
filesystem (for / ) I had to recover from backups.

Greetings,

Mateusz
