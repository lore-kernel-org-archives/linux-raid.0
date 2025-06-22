Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 106CAA937
	for <linux-raid@vger.kernel.org>; Sun, 22 Jun 2025 10:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.233.160.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750588964; cv=none; b=XgBY6Lau4Ini7B6Yb8cN0O2wRsWhuRQw+3qyI1VHg3SWdE6V9ZynDNSwHostiM4l782MhpWO/Cyoanr0qRmyL0yp9JHiNukb8IyQcLxYW1HlltkXu3+8uqqNljnofV6eRE7GTPneDwobOlBSHtBX57JH9YHHR/FnWjoKPN3hIaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750588964; c=relaxed/simple;
	bh=bxyle3/oGDo7L+oQnfpdtnAwKOQtWs42afijk6pJgBw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=NH+EUQZ7IMcG0amA2e8rQAHfiOGL7gL4WFLAA3cLppsHePHgFzlcKd3/pi5Bhf2XcsQEXTgHmnIDCj4PI6c5Y7GTbyvUxxLl+pkff0cnbEzeTHsUkxKn27yiQQdAgRI4AaStxL+S6rkZiJqiJqEAdsdXX0RXQDX2iNZ5UNbQHfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=youngman.org.uk; spf=pass smtp.mailfrom=youngman.org.uk; arc=none smtp.client-ip=85.233.160.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=youngman.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=youngman.org.uk
Received: from host86-158-182-88.range86-158.btcentralplus.com ([86.158.182.88] helo=[192.168.1.65])
	by smtp.hosts.co.uk with esmtpa (Exim)
	(envelope-from <antlists@youngman.org.uk>)
	id 1uTH1s-0000000052c-80yd;
	Sun, 22 Jun 2025 10:30:25 +0100
Message-ID: <7bccda92-7b27-44ed-a240-b124c99a3b53@youngman.org.uk>
Date: Sun, 22 Jun 2025 10:30:24 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Kernel mistakenly "starts" resync on fully-degraded,
 newly-created raid10 array
To: Omari Stephens <xsdg@xsdg.org>, linux-raid@vger.kernel.org
References: <b696bee2-3c10-45be-8f5a-be3c607d0676@xsdg.org>
Content-Language: en-GB
From: Wol <antlists@youngman.org.uk>
In-Reply-To: <b696bee2-3c10-45be-8f5a-be3c607d0676@xsdg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 22/06/2025 02:39, Omari Stephens wrote:
> I tried asking on Reddit, and ended up resolving the issue myself:
> https://www.reddit.com/r/linuxquestions/comments/1lh9to0/ 
> kernel_is_stuck_resyncing_a_4drive_raid10_array/
> 
> I run Debian SID, and am using kernel 6.12.32-amd64
> 
> #apt-cache policy linux-image-amd64
> linux-image-amd64:
>    Installed: 6.12.32-1
>    Candidate: 6.12.32-1
>    Version table:
>   *** 6.12.32-1 500
>          500 http://mirrors.kernel.org/debian unstable/main amd64 Packages
>          500 http://http.us.debian.org/debian unstable/main amd64 Packages
>          100 /var/lib/dpkg/status
> 
> #uname -r
> 6.12.32-amd64
> 
> To summarize the issue and my diagnostic steps, I ran this command to 
> create a new raid10 array:
> 
> |#mdadm --create md13 --name=media --level=10 --layout=f2 -n 4 /dev/sdb1 
> missing /dev/sdf1 missing|
> 
> |At that point, /proc/mdstat showed the following, which makes no sense:|
> 
Why doesn't it make any sense?

Don't forget a raid-10 in linux is NOT a two raid-0s in a raid-1, it's 
its own thing entirely.

> md127 : active raid10 sdb1[2] sdc1[0]
>        23382980608 blocks super 1.2 512K chunks 2 far-copies [4/2] [U_U_]
>        [>....................]  resync =  0.0% (8594688/23382980608) 
> finish=25176161501.3min speed=0K/sec
>        bitmap: 175/175 pages [700KB], 65536KB chunk
> 
> With 2 drives present and 2 drives absent, the array can only start if 
> the present drives are considered in sync.  The kernel spent most of a 
> day in this state.  The
> "8594688" count increased very slowly over time, but after 24 hours, it 
> was only up to 0.1%.  During that time, I had mounted the array and 
> transfered 11TB of data onto it.

I can't see any mention of drive size, so your % complete is 
meaningless, but I would say my raid with about 12TB of disk takes a a 
couple of days to sort itself out ...
> 
> Then when power-cycled, swapped SATA cables, and added the remaining 
> drives, they were marked as spares and weren't added to the array 
> (likely because the array was considered to be already resyncing):
> 
I think you're right - if the array is already rebuilding, it can't 
start a new, different rebuild half way through the old one ...

> #mdadm --detail /dev/md127
> /dev/md127:
> [...]
>      Number   Major   Minor   RaidDevice State
>         0       8       33        0      active sync   /dev/sdc1
>         -       0        0        1      removed
>         2       8       17        2      active sync   /dev/sdb1
>         -       0        0        3      removed
> 
>         4       8        1        -      spare   /dev/sda1
>         5       8       65        -      spare   /dev/sde1
> 
> 
> I ended up resolving the issue by recreating the array with --assume-clean:
> 
Bad idea !!! It's okay, especially with new drives and a new array, but 
it will leave the array in a random state. Not good ...

> #mdadm --create md19 --name=media3 --assume-clean --readonly --level=10 
> --layout=f2 -n 4 /dev/sdc1 missing /dev/sdb1 missing
> To optimalize recovery speed, it is recommended to enable write-indent 
> bitmap, do you want to enable it now? [y/N]? y
> mdadm: /dev/sdc1 appears to be part of a raid array:
>         level=raid10 devices=4 ctime=Sun Jun 22 00:51:33 2025
> mdadm: /dev/sdb1 appears to be part of a raid array:
>         level=raid10 devices=4 ctime=Sun Jun 22 00:51:33 2025
> Continue creating array [y/N]? y
> mdadm: Defaulting to version 1.2 metadata
> mdadm: array /dev/md/md19 started.
> 
> #cat /proc/mdstat
> Personalities : [raid1] [raid10] [raid0] [raid6] [raid5] [raid4]
> md127 : active (read-only) raid10 sdb1[2] sdc1[0]
>        23382980608 blocks super 1.2 512K chunks 2 far-copies [4/2] [U_U_]
>        bitmap: 175/175 pages [700KB], 65536KB chunk
> 
> At which point, I was able to add the new devices and have the array 
> (start to) resync as expected:
> 
Yup. Now the two-drive array is not resyncing, the new drives can be 
added and will resync.

> #mdadm --manage /dev/md127 --add /dev/sda1 --add /dev/sde1
> mdadm: added /dev/sda1
> mdadm: added /dev/sde1
> 
> #cat /proc/mdstat
> Personalities : [raid1] [raid10] [raid0] [raid6] [raid5] [raid4]
> md127 : active raid10 sde1[5] sda1[4] sdc1[0] sdb1[2]
>        23382980608 blocks super 1.2 512K chunks 2 far-copies [4/2] [U_U_]
>        [>....................]  recovery =  0.0% (714112/11691490304) 
> finish=1091.3min speed=178528K/sec
>        bitmap: 0/175 pages [0KB], 65536KB chunk
> 
> #mdadm --detail /dev/md127
> /dev/md127:
> [...]
>      Number   Major   Minor   RaidDevice State
>         0       8       33        0      active sync   /dev/sdc1
>         5       8       65        1      spare rebuilding   /dev/sde1
>         2       8       17        2      active sync   /dev/sdb1
>         4       8        1        3      spare rebuilding   /dev/sda1
> 
> --xsdg
> 
> 
Now you have an array where anything you have written will be okay 
(which I guess is what you care about), but the rest of the disk is 
uninitialised garbage that will instantly trigger a read fault if you 
try to read it.

You need to set off a scrub, which will do those reads and get the array 
itself (not just your data) into a sane state.

https://archive.kernel.org/oldwiki/raid.wiki.kernel.org/

Ignore the obsolete content crap. Somebody clearly thinks that replacing 
USER documentation by double-dutch programmer documentation (aimed at a 
completely different audience) is a good idea ...

Cheers,
Wol
