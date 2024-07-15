Received: from mail.junaru.com (junaru.com [46.166.167.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E888825
	for <linux-raid@vger.kernel.org>; Mon, 15 Jul 2024 04:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.166.167.83
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721019582; cv=none; b=Sk0J6GyM/vkN5NS/cvr+9SIHxKbOnqy+IbDR0Yb7s+0UhOOztskOJ1vVfL33r492xSSfRHDzvqU5xgIpVhDRYQ9HuP5w1KhZHkekHJ32kxaI+J1Q5q6IiJUdAMKEq51zfzE4aXQXKJrfZYFkxSX5Zp/WEMmNywg0uBEUgQ9fCiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721019582; c=relaxed/simple;
	bh=UVNvD8WRAZ6R2zGJdxyN8DiblHqur4aeKkQfmTV/kVQ=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=CCMgsxxb6/CV7Tjb/hYCMJJbj5/HTp2wCLbEQjW+OHJ3dl7wOwCVX8DtXdlWfw74QaPEnlpCZ0hDYylzYEVmdp//Bpkl1DGD/PBlBhfbIapZr9LHzoE91EJ99E+iE+TPdaVZCfaP7d6/PxXNbsZBETMEmLBBwUOtw+yI1vSQNgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=junaru.com; spf=pass smtp.mailfrom=junaru.com; dkim=pass (1024-bit key) header.d=junaru.com header.i=@junaru.com header.b=pm8EaX/C; arc=none smtp.client-ip=46.166.167.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=junaru.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=junaru.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=junaru.com header.i=@junaru.com header.b="pm8EaX/C"
Received: from bbqfortress (bbqfortress [46.166.167.83])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by mail.junaru.com (Postfix) with ESMTPSA id E7EA331197
	for <linux-raid@vger.kernel.org>; Mon, 15 Jul 2024 07:59:36 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=junaru.com; s=mail;
	t=1721019576; bh=UVNvD8WRAZ6R2zGJdxyN8DiblHqur4aeKkQfmTV/kVQ=;
	h=Date:From:To:Subject;
	b=pm8EaX/CVvS421BLoNR2DYF2nddM8+DhRHLJMdVfzR0y3g0TBq2fYDCw0a92Rh4oP
	 VH0lzEszcDM+WHl4yiTS4GU7RusBx7i98PIaRs2LX5riugllsYJinzu0eg38WK+//1
	 ze4dU2mJEQ97h6FfKbozYshXTbVhIzIzxSS+6uXI=
Date: Mon, 15 Jul 2024 07:59:36 +0300
From: Justinas =?utf-8?B?TmFydcWhZXZpxI1pdXM=?= <contact@junaru.com>
To: linux-raid@vger.kernel.org
Subject: Possibly wrong exit status for mdadm --misc --test
Message-ID: <ZpSsuO1hhmCKrexX@bbqfortress>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hello,

After reboot raid1 array with one failed drive is reported as degraded (failed drive reported as removed):

> root@rico ~ # mdadm --detail /dev/md127
> /dev/md127:
>            Version : 1.2
>      Creation Time : Thu Feb 21 13:28:21 2019
>         Raid Level : raid1
>         Array Size : 57638912 (54.97 GiB 59.02 GB)
>      Used Dev Size : 57638912 (54.97 GiB 59.02 GB)
>       Raid Devices : 2
>      Total Devices : 1
>        Persistence : Superblock is persistent
>
>        Update Time : Mon Jul 15 07:25:12 2024
>              State : clean, degraded
>     Active Devices : 1
>    Working Devices : 1
>     Failed Devices : 0
>      Spare Devices : 0
>
> Consistency Policy : resync
>
>               Name : sabretooth:root-raid1
>               UUID : 1f1f3113:0b87a325:b9ad1414:0fe55600
>             Events : 323644
>
>     Number   Major   Minor   RaidDevice State
>        -       0        0        0      removed
>        2       8        2        1      active sync   /dev/sda2


However testing such state with mdadm --misc --test returns 0


> root@rico ~ # mdadm --misc --test /dev/md127
> root@rico ~ # echo $?
> 0
> root@rico ~ #

From man page:

> if the --test option is given, then the exit status
>               will be:
>               0      The array is functioning normally.
>               1      The array has at least one failed device.
>               2      The array has multiple failed devices such that it is unusable.
>               4      There was an error while trying to get information about the device.

From --help output:

> root@rico ~ # mdadm --misc --help| grep test
>   --test        -t   : exit status 0 if ok, 1 if degrade, 2 if dead, 4 if missing

Would expect the exit code to be 1.

Can anyone confirm this is expected behaviour?

> root@rico ~ # mdadm -V
> mdadm - v4.3 - 2024-02-15
> root@rico ~ #

--

Regards,
Justinas Naruševičius
