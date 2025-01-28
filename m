Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5101B042A
	for <linux-raid@vger.kernel.org>; Tue, 28 Jan 2025 15:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738077124; cv=none; b=RF/GSl+g/N9wWlBAAWgvLMMfVuNvDp+EJfI7zFh4yJP2cE51Z5CKkgKM4wdgh0QtRvzqWvNWok2itMCBjJ2+FfhIQhiGsMwyp5yDpgACzCP+3vqmikJiY65bLKKXFj6Vkfn/bOZuPiZefQDqW7o7XFJt+KUMpr2KOQby41zFqjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738077124; c=relaxed/simple;
	bh=hN3b0O2A8SJ9fGakWIqIyYluddFrBuurLez3+slgSI0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FnmOL8i1ErfIo6rtGOMFHoNxrbe42IwN08rrUwoyZFzrWBf8+9vUCFL+tr0Bh8k9F9p3Qjw4OPEE8jmp6TvkKZHuNM7kgV6B241zyB5Nq5Gl1d+sswTr+3z5AaUtkUlT6iLLfPea9aLxTPAT7AK6FZBGRg5oNMvTwxTLKoooJtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pkm-inc.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=pkm-inc.com header.i=@pkm-inc.com header.b=S0KfXVs9; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pkm-inc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pkm-inc.com header.i=@pkm-inc.com header.b="S0KfXVs9"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-21bb2c2a74dso13384725ad.0
        for <linux-raid@vger.kernel.org>; Tue, 28 Jan 2025 07:12:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pkm-inc.com; s=google; t=1738077121; x=1738681921; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9l0nktdejd+M4VFfwa/yIfeV8QPFdqMe+TAkCJdNTic=;
        b=S0KfXVs9hqEr+V1oKvvfegmOi8UwTqmnEcpgdDzclwc0clH120UGngkT7P4Puebnab
         BTAwLd639uCtrye+cst54oP07hED2GneCl9rdptB3hb1MAFrHZTs7rz1cFIsFsEAp9Zq
         DtLh5QOH/27ijZhsGcXOyux2qcTXABkBsikSIcJz1a3N09U+3jkoMC9YrZoG9AGzb39H
         TfydBGT7z7gOzrBmkhA1ROG9oZ6dfxTuLv1H4abLwTrbkwX77lDkniUDJCSmqP/wPgMy
         AbeSApXErFeJuqk3WMge49LJ1q54uHI7SGnvGH1UMLD7ddppd2quuQzVUA3wjU/uDFtX
         cVdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738077121; x=1738681921;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9l0nktdejd+M4VFfwa/yIfeV8QPFdqMe+TAkCJdNTic=;
        b=RQMcrH4N6QHbfPRl0eqbRYP0/AW1/Gs1uQBEgmodFD4BH4HqaTITWwP5AUuW5Ktx/N
         RuPltbOS64L67gBSdLQj48UoiUYQ5eXjX0tnptZs34asqiPSF5wciDCgu8cRNBvGHywn
         CcBTalTsYXqtXzAFMkRMq35jqGCu4NkZGRZnQthpOQUDk3IgDtpdOmEleN8xsgrJFm05
         RsWEqLBZQIK6E768n+ztGPnQW/HzIQLXySJU9UtXlu85QyzoDb4cJL4On9IDp/AeCeFL
         cmW3HKV89fbuNg2aj6708/ePj0bmnyRBJ+hiHrIfayYYBzBLhTn6xGIIuwnvzbkgBCwP
         lC2A==
X-Gm-Message-State: AOJu0YxHGHw64lF+7Du3VUPsv2ocvjj3tkhXahrw0xk9HoNg2xKM5pQi
	ZfbmvECzc1Esgz2Wd5DjqpGxfxQ3W4M95fm2GJuJycQxp/PbIRj2CA+noaM2NfPRJV/0M0tqTS6
	WgQ0nKqbkPYlP1khDSyIb3zK2KKs=
X-Gm-Gg: ASbGnct5J2FnA4x2YTMQTPan7qfZRChICFNJr7JPE60xXA7/pBInlrY8UUii7k6hWmh
	LxYKZUuPPHdKOSI24GmRGij32lVOfmA4NHwXis4SZlwiTZBsnD/prMJbWvkomGT30+et55vcpw/
	0=
X-Google-Smtp-Source: AGHT+IFH+CqWVwKGRlLFqje9L8D/stCvOOd6X7X4qHVBzJy8eLoSfHP3sxRLZqe3QXcVq88pDkEmh/taEUZ/lJbL2cA=
X-Received: by 2002:a17:902:f683:b0:215:94ef:6071 with SMTP id
 d9443c01a7336-21d79b34b2bmr144335515ad.14.1738077121318; Tue, 28 Jan 2025
 07:12:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAiJnjpbbLRsPZDUdpvG3UcR7gts7iyLb=73nRP3Ww5qpUUf7A@mail.gmail.com>
In-Reply-To: <CAAiJnjpbbLRsPZDUdpvG3UcR7gts7iyLb=73nRP3Ww5qpUUf7A@mail.gmail.com>
From: =?UTF-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>
Date: Tue, 28 Jan 2025 16:11:49 +0100
X-Gm-Features: AWEUYZlpqfQ1gfsausRd1MBurSNi7q1Jj-NDuLw5dVR9EAmhDmkDcz0BLNOuvO4
Message-ID: <CALtW_aia00Op_g3ofTbPRgvVscnEwcm6_AR6vQwc21UFopwmHg@mail.gmail.com>
Subject: Re: Add spare disk to raid50
To: Anton Gavriliuk <antosha20xx@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 28 Jan 2025 at 14:37, Anton Gavriliuk <antosha20xx@gmail.com> wrote:

> I have read manuals, but it doesn't work as described, or likely I do
> something wrong.  Do you have spare-group example ?

Your configuration looks OK and should work.
I have a similar configuration on one of my servers and if I remember
correctly it worked without issues.

Please remember to hit reply all so that others in the group can take
another look.

>
> My config is simple -
>
> [root@memverge2 anton]# cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md118 : active raid5 nvme0n1[4] nvme3n1[0](S) nvme7n1[3] nvme5n1[1]
>       3125362688 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/3] [UUU]
>       bitmap: 0/12 pages [0KB], 65536KB chunk
>
> md117 : active raid5 nvme6n1[4] nvme4n1[1] nvme2n1[0]
>       3125362688 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/3] [UUU]
>       bitmap: 0/12 pages [0KB], 65536KB chunk
>
> unused devices: <none>
> [root@memverge2 anton]#
> [root@memverge2 anton]# cat /etc/mdadm.conf
> ARRAY /dev/md/117 level=raid5 num-devices=3 metadata=1.2
> UUID=0fab82cd:36301f6c:6ec78c95:7f092d4c spare-group=group1
>    devices=/dev/nvme2n1,/dev/nvme4n1,/dev/nvme6n1
> ARRAY /dev/md/118 level=raid5 num-devices=3 metadata=1.2 spares=1
> UUID=2d7290e5:c3ccbfe9:004cb182:3e325714 spare-group=group1
>    devices=/dev/nvme0n1,/dev/nvme3n1,/dev/nvme5n1,/dev/nvme7n1
> [root@memverge2 anton]#
> [root@memverge2 anton]# systemctl restart mdmonitor
> [root@memverge2 anton]#
> [root@memverge2 anton]# mdadm /dev/md117 --fail /dev/nvme6n1
> [root@memverge2 anton]#
> [root@memverge2 anton]# mdadm -D /dev/md117
> /dev/md117:
>            Version : 1.2
>      Creation Time : Tue Jan 28 11:08:21 2025
>         Raid Level : raid5
>         Array Size : 3125362688 (2.91 TiB 3.20 TB)
>      Used Dev Size : 1562681344 (1490.29 GiB 1600.19 GB)
>       Raid Devices : 3
>      Total Devices : 3
>        Persistence : Superblock is persistent
>
>      Intent Bitmap : Internal
>
>        Update Time : Tue Jan 28 15:29:47 2025
>              State : clean, degraded
>     Active Devices : 2
>    Working Devices : 2
>     Failed Devices : 1
>      Spare Devices : 0
>
>             Layout : left-symmetric
>         Chunk Size : 512K
>
> Consistency Policy : bitmap
>
>               Name : memverge2:117  (local to host memverge2)
>               UUID : 0fab82cd:36301f6c:6ec78c95:7f092d4c
>             Events : 849
>
>     Number   Major   Minor   RaidDevice State
>        0     259        5        0      active sync   /dev/nvme2n1
>        1     259        0        1      active sync   /dev/nvme4n1
>        -       0        0        2      removed
>
>        4     259        1        -      faulty   /dev/nvme6n1
> [root@memverge2 anton]#
>
> And there is no raid117 recovering using spare from raid118.
>
> Anton
