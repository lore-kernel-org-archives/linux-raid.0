Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB27028F520
	for <linux-raid@vger.kernel.org>; Wed,  6 Aug 2025 15:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754494115; cv=none; b=MoC+ilexrgc0XfxFFY2plqrZ66wXxdQ1EN7lQr555e3MgYPZmDMiUCZQXFdGa27x1IIL5fXAYl/SvESDyxZk4Mv+lQTZPa4lRp56yi8yZ0LCCFu/YuVrwBiWwov52FpUckpMcIZYUeH8ZhJ/TA3ciDfEedZZEZwwQsCrCIlOH3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754494115; c=relaxed/simple;
	bh=WJ9A+YQeIQX98zrZ97HGqMsecdKh+CMJ1u117V0owKQ=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=CkuEHgw8bqxxiMOdmdLY8W13qO4ARxsvb+zPYnbX9GZv9pJaZombfFRc3epqaM2h54uGRNjQ1bvm++nsN1FhrC+klgoFFD50kU7bRHAK6Np0TE69vnDMIK1w6SDa3IVqeHKplYZyoIMXFoMD8lDnSKVZ/5seKP1vAc/0iqfLUUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Kdx0DTai; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Kdx0DTai"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754494111;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=XBo/O9BSCJQTlEmAzPHKO6yVmkLCNzvj7zwEIobfpxg=;
	b=Kdx0DTaiqTvfPsuqtgIVVk58+b3ItdO1FGLO6wlyccwpmzczSiaIgmiUUZxyMg5Eeyw7vZ
	MiahMpV64jvbf5W6OSES+juAhF9cqxKSOmV3oPodR00ry5Myhn/BVJ8PqOPkIqvTgOvb+N
	51zFFSwc5FApGq8J6C+I1D1s2sxdq1Y=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-335-S8Yy7zaaOzubaNaQl7_BSQ-1; Wed,
 06 Aug 2025 11:28:28 -0400
X-MC-Unique: S8Yy7zaaOzubaNaQl7_BSQ-1
X-Mimecast-MFC-AGG-ID: S8Yy7zaaOzubaNaQl7_BSQ_1754494107
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AA0C91955ED2;
	Wed,  6 Aug 2025 15:28:26 +0000 (UTC)
Received: from [10.22.80.50] (unknown [10.22.80.50])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 254AD1800282;
	Wed,  6 Aug 2025 15:28:23 +0000 (UTC)
Date: Wed, 6 Aug 2025 17:28:17 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Xiao Ni <xni@redhat.com>, Yu Kuai <yukuai3@huawei.com>, 
    Song Liu <song@kernel.org>
cc: linux-raid@vger.kernel.org, vkuznets@redhat.com, yuwatana@redhat.com, 
    luca.boccassi@gmail.com
Subject: md regression caused by commit
 9e59d609763f70a992a8f3808dabcce60f14eb5c
Message-ID: <f654db67-a5a5-114b-09b8-00db303daab7@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="-1463811712-460856465-1754493829=:1304811"
Content-ID: <e4e27d46-42f3-7151-caaa-a664a7b4d277@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811712-460856465-1754493829=:1304811
Content-Type: text/plain; CHARSET=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Content-ID: <3dce8777-ec15-25a4-0d8c-f522cb2f6ab0@redhat.com>

Hi

I report that the commit 9e59d609763f70a992a8f3808dabcce60f14eb5c causes 
problem with this mdadm script:

modprobe brd rd_size=1048576
mdadm --create /dev/md/mdmirror --name mdmirror --uuid aaaaaaaa:bbbbbbbb:cccccccc:00000001 /dev/ram0 /dev/ram1 -v -f --level=1 --raid-devices=2
mdadm -v --stop /dev/md/mdmirror
mdadm --assemble /dev/md/mdmirror --name mdmirror -v

Prior to this commit, the last command successfully assembles the array. 
After this commit, it reports an error "mdadm: Unable to initialize 
sysfs".

See https://bugzilla.redhat.com/show_bug.cgi?id=2385871

This is the strace of the failed mdadm --assemble command:

mknodat(AT_FDCWD, "/dev/.tmp.md.2512:9:127", S_IFBLK|0600, makedev(0x9, 0x7f)) = 0
openat(AT_FDCWD, "/dev/.tmp.md.2512:9:127", O_RDWR|O_EXCL|O_DIRECT) = 4
unlink("/dev/.tmp.md.2512:9:127")       = 0
fstat(4, {st_mode=S_IFBLK|0600, st_rdev=makedev(0x9, 0x7f), ...}) = 0
readlink("/sys/dev/block/9:127", "../../devices/virtual/block/md12"..., 199) = 33
openat(AT_FDCWD, "/proc/mdstat", O_RDONLY) = 5
fcntl(5, F_SETFD, FD_CLOEXEC)           = 0
fstat(5, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
read(5, "Personalities : [raid1] \nunused "..., 1024) = 48
read(5, "", 1024)                       = 0
close(5)                                = 0
ioctl(4, STOP_ARRAY, 0)                 = 0
openat(AT_FDCWD, "/dev/ram1", O_RDWR|O_EXCL|O_DIRECT) = 5
ioctl(5, BLKSSZGET, [512])              = 0
fstat(5, {st_mode=S_IFBLK|0660, st_rdev=makedev(0x1, 0x1), ...}) = 0
ioctl(5, BLKGETSIZE64, [1073741824])    = 0
lseek(5, 4096, SEEK_SET)                = 4096
read(5, "\374N+\251\1\0\0\0\0\0\0\0\0\0\0\0\252\252\252\252\273\273\273\273\314\314\314\314\0\0\0\1"..., 4096) = 4096
lseek(5, 0, SEEK_CUR)                   = 8192
fstat(5, {st_mode=S_IFBLK|0660, st_rdev=makedev(0x1, 0x1), ...}) = 0
close(5)                                = 0
write(2, "mdadm: /dev/ram1 is identified a"..., 72) = 72
openat(AT_FDCWD, "/dev/ram0", O_RDWR|O_EXCL|O_DIRECT) = 5
ioctl(5, BLKSSZGET, [512])              = 0
fstat(5, {st_mode=S_IFBLK|0660, st_rdev=makedev(0x1, 0), ...}) = 0
ioctl(5, BLKGETSIZE64, [1073741824])    = 0
lseek(5, 4096, SEEK_SET)                = 4096
read(5, "\374N+\251\1\0\0\0\0\0\0\0\0\0\0\0\252\252\252\252\273\273\273\273\314\314\314\314\0\0\0\1"..., 4096) = 4096
lseek(5, 0, SEEK_CUR)                   = 8192
fstat(5, {st_mode=S_IFBLK|0660, st_rdev=makedev(0x1, 0), ...}) = 0
close(5)                                = 0
write(2, "mdadm: /dev/ram0 is identified a"..., 72) = 72
openat(AT_FDCWD, "/dev/ram0", O_RDONLY|O_EXCL|O_DIRECT) = 5
ioctl(5, BLKSSZGET, [512])              = 0
fstat(5, {st_mode=S_IFBLK|0660, st_rdev=makedev(0x1, 0), ...}) = 0
ioctl(5, BLKGETSIZE64, [1073741824])    = 0
lseek(5, 4096, SEEK_SET)                = 4096
read(5, "\374N+\251\1\0\0\0\0\0\0\0\0\0\0\0\252\252\252\252\273\273\273\273\314\314\314\314\0\0\0\1"..., 4096) = 4096
lseek(5, 0, SEEK_CUR)                   = 8192
close(5)                                = 0
fstat(4, {st_mode=S_IFBLK|0600, st_rdev=makedev(0x9, 0x7f), ...}) = 0
readlink("/sys/dev/block/9:127", 0x7ffcd3ed18b0, 199) = -1 ENOENT (Adresáø nebo soubor neexistuje) !!! FAILURE !!!
newfstatat(AT_FDCWD, "/sys/block/md127/md", 0x7ffcd3ed1a30, 0) = -1 ENOENT (Adresáø nebo soubor neexistuje)
write(2, "mdadm: Unable to initialize sysf"..., 34) = 34
unlink("/run/mdadm/map.lock")           = 0
close(3)                                = 0
close(4)                                = 0
exit_group(1)                           = ?

See the line that is marked "!!! FAILURE !!!". Prior to the commit 
9e59d609763f70a992a8f3808dabcce60f14eb5c, mdadm is able to read the 
/sys/dev/block/9:127 symlink.

Mikulas
---1463811712-460856465-1754493829=:1304811--

