Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A974C63D
	for <linux-raid@vger.kernel.org>; Mon, 29 Jan 2024 19:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706557044; cv=none; b=tWvwL65Qyqq3WiCB8j+MpPHRghpmAyoR5oi4nmaf2s+dUvAoqqOJmHatN9N87MyzJOtGRwhtesA2pG4j8cNydvWkSSSXza4ReCnOeeSjwz2EfkAZz2rOShkZgF5rQUtLPzzvci3MvdyFrASon7yP4fXEp+aTS1PBnnQSS5Dd0lE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706557044; c=relaxed/simple;
	bh=1X9c1O25LMDTHZdloGx2xCStbV0MXzNr0Y30K8pINMw=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=RVHp35zHBZVgADcbI+pQUYjdSNI+6gpaSbVOBYEwpn+pm6/s2L1sQu/8BbBcZ1d14XpyG6H1bvzFpc/9dxilK2NcuEHy1RF2vk98qMIb1AAFT1THkZXZum4cyyCKF9A48GiE8FId/XPj/+KFDNsoWhliX7t2rN1eARtvH1Uz/oI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f56yfunB; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f56yfunB"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a35e65df2d8so117143966b.0
        for <linux-raid@vger.kernel.org>; Mon, 29 Jan 2024 11:37:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706557041; x=1707161841; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=nZbkNI8caMqsz8fYqhf+IxCV+Y43yxnQWf1QcEH5TSM=;
        b=f56yfunBT8V4GRDtVrYP6PzuNCDlVa/KoMnKErUYvsGLcS0uY4p3OG1QAKPv/aMZW4
         CxEL6gc+UoAcZx2yuJO+7WU2gwfLuD3rQHtmzXtdNMaPBvmF1zIJrOCmdTttG2V5gvrD
         y0GN1Fw5g6fdbFoLW4VNVHK+2eSRGtRGAsFgUXHMXxUNUjXknaCht8eI6LpWulkWBFMl
         KARxG6rHkFpxVKTadN3zjFaPSzwXMvnXIIxzuZiy6VOwue0hn7LHmqZPRlsD5LiW+WLi
         GsJVjKy1QvQfnmyucJGCq1iZgGhUdQPRcpGF/6cr3ZUKxcdrkiaB031c0b0ZVKEZXvaz
         GdyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706557041; x=1707161841;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nZbkNI8caMqsz8fYqhf+IxCV+Y43yxnQWf1QcEH5TSM=;
        b=dcMdsrgnmFgS7f5feUbEpKGqe3XKNDKgWlS4mSP9rWBC4ehVASlVJNKMZ7Z+lHSyBg
         G+HdMQE+S5qvrJs8Qnoj0qsh4xtWzRD45aGN+v3bfiS3cWw/yrt+THZF8LFAoOIElnVN
         L5a9ilqkmNea3IesMkTsm+3pojC1lUgN2CG0SvsAam46cbbA0AXVYZ7NvqBFNTk1p6tw
         uwoqQqU76MtYPEha9/RAxgH6iAVJIZfMixR0Kgxc3pHru1r1uxX7XSzDHOK1muQi2zsk
         nPRtUhUdiUVvt62f59mvGhV5GZhd7emFAD++AVPPj02f+FXO0OwDc4vcqN3txjghrtsp
         Ug7Q==
X-Gm-Message-State: AOJu0YzCJ2Lg4ojStM65xQCLUuqmEPGc4oN7BGrxy8OAk0zsQGnbXS/8
	Am7ae/1c/11KMf0fatRGQTsq4aXP9jcJPLBDlfPwr05xBHa5SULziB6QtYFmDvGv+ets1GE/24W
	pnEdWYp6RB/Hm6IrP4r+z5U4Ehek6u6G4JmI=
X-Google-Smtp-Source: AGHT+IHHGjnrJNIlYNqyPVXf+tgbpIaxskbTuEVvcAFoNKzYPOt4F2ZqUx8DKPeTf0ftsLQ8EkqHp0MJKtpo0Uid5LA=
X-Received: by 2002:a17:906:f9c3:b0:a31:f7e:8a53 with SMTP id
 lj3-20020a170906f9c300b00a310f7e8a53mr5289474ejb.26.1706557040809; Mon, 29
 Jan 2024 11:37:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Stephen Haran <steveharan@gmail.com>
Date: Mon, 29 Jan 2024 14:37:09 -0500
Message-ID: <CAKcp_7a7tw-oheF8E_KtYjv6kmFTG3AMkX=UEQWuFGFV4SkaAA@mail.gmail.com>
Subject: Help compiling mdadm 4.2 for static binary
To: linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,
Compiling mdadm 4.2 from source by just running the "make" command
works fine on Ubuntu 18.04.6.

But I want a static binary so I run "make everything" but it fails.
Any idea where I'm going wrong? Thank you!

root@r-regular:~/mdadm-4.2# uname -a
Linux r-regular 5.4.0-150-generic #167~18.04.1-Ubuntu SMP Wed May 24
00:51:42 UTC 2023 x86_64 x86_64 x86_64 GNU/Linux

root@r-regular:~/mdadm-4.2# make everything
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
-Wimplicit-fallthrough=0 -O2 -DSendmail=\""/usr/sbin/sendmail -t"\"
-DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\"
-DMAP_DIR=\"/run/mdadm\" -DMAP_FILE=\"map\" -DMDMON_DIR=\"/run/mdadm\"
-DFAILED_SLOTS_DIR=\"/run/mdadm/failed-slots\" -DNO_COROSYNC -DNO_DLM
  -DUSE_PTHREADS  -static -o mdadm.static mdadm.o config.o policy.o
mdstat.o  ReadMe.o uuid.o util.o maps.o lib.o Manage.o Assemble.o
Build.o Create.o Detail.o Examine.o Grow.o Monitor.o dlink.o Kill.o
Query.o Incremental.o Dump.o mdopen.o super0.o super1.o super-ddf.o
super-intel.o bitmap.o super-mbr.o super-gpt.o restripe.o sysfs.o
sha1.o mapfile.o crc32.o sg_io.o msg.o xmalloc.o platform-intel.o
probe_roms.o crc32c.o pwgr.o -ldl -ludev
util.o: In function `set_cmap_hooks':
util.c:(.text+0x4942): warning: Using 'dlopen' in statically linked
applications requires at runtime the shared libraries from the glibc
version used for linking
/usr/bin/ld: cannot find -ludev
collect2: error: ld returned 1 exit status
Makefile:199: recipe for target 'mdadm.static' failed
make: *** [mdadm.static] Error 1
