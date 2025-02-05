Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com [209.85.219.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2548821516B
	for <linux-raid@vger.kernel.org>; Wed,  5 Feb 2025 12:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738757054; cv=none; b=OKSqW5gz9+iTHi97rvM/CzhD9bwrWfIIhHE3QTDRz/YxFrbIWlv3II2OgBy4kP1o4qWn5aaBIqZh234JXZ7i8LmABqdWIZjiFfK7ql7fe3lEaTddoVnurYgt4q+zioGNXbgm25+uyjLJHqEEASx7c2mi6jb9HX2vjihKAMwa9C4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738757054; c=relaxed/simple;
	bh=bIRlPpuXafUJI0OLotQ0s2d7pvGW8okeNQubkA3J5rc=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=Yqz7Gx30IK5lmGDi5Fj898iGNjk5TL1ztLAshZWZoY6u7s06GAQ3/Rg1eWIKtFa13J/2QEw2+NIKWO/Cs2z/Qj++JUuc75K0aKs29q2kvwhuCpFs43pSYfX5XvgcEBMwSngcTtfTamTia7r/doOf4SlHLugrpbSmsYCiySesn+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VhEr2Apq; arc=none smtp.client-ip=209.85.219.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VhEr2Apq"
Received: by mail-yb1-f176.google.com with SMTP id 3f1490d57ef6-e53a5ff2233so6805275276.3
        for <linux-raid@vger.kernel.org>; Wed, 05 Feb 2025 04:04:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738757052; x=1739361852; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bIRlPpuXafUJI0OLotQ0s2d7pvGW8okeNQubkA3J5rc=;
        b=VhEr2ApqKiFJk0OSmyECWl5dZ10+WzV4o5TwN59Jhn8+ISlxLr0u0T+kRhU91o5TMc
         e92BmnUxDl2BMIOVnALGqML/Fhm3djTh5RM/f4YwxiCnlMPFwg5/ZKaVj0Omefe3ShZz
         9cEQN4qnNyK0Q9WXqjJ4+TUO7lVe304q19QtWTzaC/m/ze6c6bIiZ7U+yS/y6bcY+3OH
         u9PrLJxHElg9OE8QWprxGwskarpx9xrkvYaBf7DhdouNZsZafGDfPtT6ax1bUletz7De
         daM99p6YZXWvuuWXzHU9A+T5xpWbu5wpkJYdZW95CnuEq0IVwvRuUKcs5PhIn6K7rV7i
         MSIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738757052; x=1739361852;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bIRlPpuXafUJI0OLotQ0s2d7pvGW8okeNQubkA3J5rc=;
        b=ucRaGyzXLmE7yxVmruGF3mU4fM0xk5FWSdlZCzHNEMR9ADPlHkBKfSyqugZ1Kl0x/o
         hsQLsT2bbdYwcuC0+cu5/M/jNePKncQXeZ9d2iSB0pIlyF4e61cJhXOA0mHw0FOFktYT
         Lr/yPss8xqG7f73ByIb7wKAd3c+RTnK7nTyoStigr1Se7vdqwGJvs+lpzJC4hwpogYJl
         nLycrydUr18KoSc242KnZGzP8Zu/Sq2ozIxUMFXIOHNlM0hZdBlFwcgeAsZ6PR6nsaKM
         z4DFTy5G0HJTiiksqTRwz9h002JL2Wn66D4uLwZCsy4ZyjgllI5s4ygDDj5NR/Aw/6mB
         E1VA==
X-Gm-Message-State: AOJu0YzcpPmURJvenw6TWcsu4T20DdSCfAuhipGtG37UPyflEuBCdoeJ
	hWJ2Yn0Uhq4PJnhJ/np6WzUOia64aAVIPF5BxA0JidGEN3VUawJeX2IQZLwkvRIMpJAhN1XJTfN
	wPzq7XY5835TBSb5IelwYWpj2SpYpjA==
X-Gm-Gg: ASbGnct+rC09vGHPrmkbZuw3TQc8qOaWSGAd/EOCxsoo8K2wBflfBE+oiLxB48757+p
	hTb6yQXhOJWAWMqIE7X54J9Bj5d1gAkYo4FLlz6oN8SQJeAbeVNgeJ3cejNgI7ju+uWxegcgJSQ
	==
X-Google-Smtp-Source: AGHT+IE5plXkY+HDckThrr41f2eoXLOjn1nvFMyF4L7sikqA+UDe0fVxKG+35SphPhgh7cYFqV8BmqDasSGqpfNVUfQ=
X-Received: by 2002:a05:6902:1a48:b0:e57:8b0d:27e0 with SMTP id
 3f1490d57ef6-e5b25be80fdmr2115532276.31.1738757051757; Wed, 05 Feb 2025
 04:04:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Raffaele Morelli <raffaele.morelli@gmail.com>
Date: Wed, 5 Feb 2025 13:03:46 +0100
X-Gm-Features: AWEUYZmMcXcypBYQTcPhoQzDQWLy5ZR17-Va8FhaEMUGlcTRM8TMcMPYypSaVaA
Message-ID: <CAD4guxO5uyTZWuOxzMAj1WqAY1UHnfAqGgia1QZiqiaOQv=89Q@mail.gmail.com>
Subject: Problem with RAID1 - unable to read superblock
To: linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,

I am in serious trouble with RAID1 device.

Last week we found it was in read only mode, I've stopped and tried to
reassemble it with no success.
dmesg recorded this error

[7013959.352607] buffer_io_error: 7 callbacks suppressed
[7013959.352612] Buffer I/O error on dev md126, logical block
927915504, async page read
[7013959.352945] EXT4-fs (md126): unable to read superblock

We've found one of the drive with various damaged sectors so we
removed both and created two images first ( using ddrescue -d -M -r 10
).

We've set up two loopback devices (using losetup --partscan --find
--show) and would like to recover as much as possible.

Should I try to reassemble the raid with something like
mdadm --assemble --verbose /dev/md0 --level=1 --raid-devices=2
/dev/loop18 /dev/loop19

Any other hints?

Thanks in advance
/raffaele
