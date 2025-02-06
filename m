Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com [209.85.219.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D060224896
	for <linux-raid@vger.kernel.org>; Thu,  6 Feb 2025 05:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738820529; cv=none; b=Ls15O6jVXhpx6BQcH8Kqq8uVvS+RhaY7UKEm/PEh2Q+b/Y7QNYpUk+jqcFQE4c+n64QPkkZrVoFe8nZqDr7Tu47ixtbJeYkRZ5NEyqPsU8KGHWM1rVnE8WdTqjn8rQlnfZ3b5O+NXK7Fw7cxTzwoV2+2HdmnCtkKwkc3Fwc6ffY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738820529; c=relaxed/simple;
	bh=QfRq5UE8hhWGm6ZKkoK9QBtzBd7Z7xz4Orkfxk+bKBc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=Bpg6b2CxO8/ZN7MJMAgKrnKa+M67hPNL0RgfI7J9h/gf1rtGZSCZzjDFbrguk0Q2uEDh9GHdVUAgq0Ibjhuh1d9r+1KIPhVv+yM3HshkbT8gl1oDzby0WRiHv4gjJyY/2ytpH7Vd6sVLltGbQX3YGRo8SAcovyYSrMVPcbGd00Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LcvbiJPl; arc=none smtp.client-ip=209.85.219.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LcvbiJPl"
Received: by mail-yb1-f175.google.com with SMTP id 3f1490d57ef6-e5b29779d74so452930276.2
        for <linux-raid@vger.kernel.org>; Wed, 05 Feb 2025 21:42:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738820526; x=1739425326; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QrD0Xu8E0MbNZsCFN+NddDHbkw3no8jd8DJ0v6qP7ck=;
        b=LcvbiJPlJT3oqVZDTx0aQhWOHJkxG2a/F9DS8vkgi1TqUchy/jpZudsCxyhKxv4Xw6
         Xf9OaXP2LXj/qb6+0EaYS9kcX7Zq7lWk7UYvC19ETspEz3D7TqTcTdgmnPIevQ70UJxI
         geofQombeLqsnkJ2z+f6vKHwPueGMykNNYUdh4c/QJz45IgWXkd7V22O7Uqv55CIaFBg
         7h1evGiR/uOTpfVG00fcwP3BgytSnEI6jPlkzKmB9TFPiet4YLwJuJ1o89h4cpaiGZ8V
         mnSc1bQQP3DWjpfqyuBPK/xcFTwWVHYvpz9u49o/sjc41U2eWCH2Tstjjdjx78B7qsBI
         KJlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738820526; x=1739425326;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QrD0Xu8E0MbNZsCFN+NddDHbkw3no8jd8DJ0v6qP7ck=;
        b=j5dV9Shr7aGv1Nlpzx2RxPpjqh/Gx234ZV/HOl74ERX6OALUBLL7agVkB/x6uSFBYR
         XsuCZJZr0XK31Rid9ZtKOI3sIbyDoynNHlFd1Cho9hG12B/vpKS7nEYLLI6xoQLOzEar
         +GzCN0vtYetrRnhE5k7qP8K/NOX1d0aWlrNhdFU8AF8jOxIovjI4Foyz27yDWPw/Tr/U
         6jfD1cRjYDybZfV/P5LZtqZ9M35AyOgv/Va7lk9RLlSskDpZMRjNnj+ondMJlnCXotkx
         PIh3M5FJBHoTapg6Hs+VwmF4snvP6UbjvItYtZrgywoWnFvKU9X5K2pDtk/8YlyAWyV2
         TlJA==
X-Gm-Message-State: AOJu0Yzsw4nQNbDm/QD0fwvc7mMdXzEmtZyMy3aX/Q+0UQ+erfN0Ntth
	oQR7aeEZRD9rYci6Ap3BXwVggOsISpep98cFGomezpz8t0As69k1X1AQvxtrPQqfGzWleldSM1F
	HdDT4eAb0m8QG5iO6VOa+03pRRikc837+
X-Gm-Gg: ASbGncsTAUQsZwY2hu+swOCkPysvVsfovRna//clHDUvLbqLqVqbiRbAMCHCEFIYXer
	nqIwKnj5NU628nRmjbQdCPKkEJXQxXmMlVJec4vZ2WHZueDowc0Nq/4eN+3mR4MCn0odgMy3M0w
	==
X-Google-Smtp-Source: AGHT+IF82b8h28ZXtJeaM9ceWlph4PrKGrP4uro0QoJLopQhjJMSaRPrwP89O/naku2qpsxTUiEvHuNFq5lMXYOpe5I=
X-Received: by 2002:a05:6902:2484:b0:e5a:e6eb:d44f with SMTP id
 3f1490d57ef6-e5b259cd477mr5069356276.6.1738820526108; Wed, 05 Feb 2025
 21:42:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAD4guxO5uyTZWuOxzMAj1WqAY1UHnfAqGgia1QZiqiaOQv=89Q@mail.gmail.com>
 <1826ee0e-ac29-4b45-bd3e-54ea81be684a@plouf.fr.eu.org>
In-Reply-To: <1826ee0e-ac29-4b45-bd3e-54ea81be684a@plouf.fr.eu.org>
From: Raffaele Morelli <raffaele.morelli@gmail.com>
Date: Thu, 6 Feb 2025 06:41:40 +0100
X-Gm-Features: AWEUYZmai1nbMEwzM9H05TOwou4jG2Orz4DXNx_jVOSGRrTHI1budNNqyVF1ZSk
Message-ID: <CAD4guxMmgJ+wCiHFqsgW-OKSVqvmxtra+ng0FRqfjRPK4LGS0w@mail.gmail.com>
Subject: Re: Problem with RAID1 - unable to read superblock
To: linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Il giorno mer 5 feb 2025 alle ore 21:42 Pascal Hambourg
<pascal@plouf.fr.eu.org> ha scritto:
>
> On 05/02/2025 at 13:03, Raffaele Morelli wrote:
> >
> > Last week we found it was in read only mode, I've stopped and tried to
> > reassemble it with no success.
> > dmesg recorded this error
> >
> > [7013959.352607] buffer_io_error: 7 callbacks suppressed
> > [7013959.352612] Buffer I/O error on dev md126, logical block
> > 927915504, async page read
> > [7013959.352945] EXT4-fs (md126): unable to read superblock
>
> No error messages from the underlying drives ?

I have logs to scan for details

> > We've found one of the drive with various damaged sectors so we
> > removed both and created two images first ( using ddrescue -d -M -r 10
> > ).
>
> Is either image complete or do both have missing blocks ?

There are no errors, pct rescued is 100%, everything seems fine.

> > We've set up two loopback devices (using losetup --partscan --find
> > --show) and would like to recover as much as possible.
> >
> > Should I try to reassemble the raid with something like
> > mdadm --assemble --verbose /dev/md0 --level=1 --raid-devices=2
> > /dev/loop18 /dev/loop19
>
> If the RAID members were partitions you must use the partitions
> /dev/loopXpY, not the whole loop devices.
>
> If either ddrescue image is complete, you can assemble the array in
> degraded mode from a single complete image.
> If both images are incomplete and the array has a valid bad block list,
> you can try to assemble the array from both images.
>
> In either case, assemble the array read-only.

Actually we're here

/dev/md0:
           Version : 1.2
     Creation Time : Wed Feb  5 11:12:32 2025
        Raid Level : raid1
        Array Size : 3906885440 (3.64 TiB 4.00 TB)
     Used Dev Size : 3906885440 (3.64 TiB 4.00 TB)
      Raid Devices : 2
     Total Devices : 2
       Persistence : Superblock is persistent

     Intent Bitmap : Internal

       Update Time : Wed Feb  5 22:27:49 2025
             State : clean
    Active Devices : 2
   Working Devices : 2
    Failed Devices : 0
     Spare Devices : 0

Consistency Policy : bitmap

              Name : aria-pcpl:0  (local to host aria-pcpl)
              UUID : 3b27a574:b12fa078:28872721:15bf710c
            Events : 7984

    Number   Major   Minor   RaidDevice State
       0       7       22        0      active sync   /dev/loop22
       1       7       23        1      active sync   /dev/loop23
