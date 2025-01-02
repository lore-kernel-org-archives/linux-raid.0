Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2558C2941C
	for <linux-raid@vger.kernel.org>; Thu,  2 Jan 2025 04:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735791265; cv=none; b=BajY1YB4fIGipIw2RdOSEWIWly/CRPt6vtd8Uy6BNuuW/Y5DWXFGKh5cv15Qwg/iMXCiFHzgGjdpB2R0QFcJqb5nthBtBWspMmgJaf9zzAXoms39+Krjq3iZ0ggeV2XL8cjrSASvTwzLZzNCFmQuaaQma4VroQZLWjieAfBLu2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735791265; c=relaxed/simple;
	bh=5Hgcp/rOQr79VmKLIg0j8jrldXJiZHkHt4iM1asDAr8=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=BroMBxIRmSVBSr0jSlGP+WIQMLHb3Hx1msVi/jSwY7xv5uwC46g6+SHgl3mCKQ6pnwfUPgP76B6cLSy1Njl5UowwUw0EM5/PmEmmj5aa1tNROe67dbyS1U7LIrdVJZpRud1CeG88IjDGmDBECYGJZoQQcm1arHb9Vj8q0L/L4VY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DsDyMYs1; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DsDyMYs1"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-6d8a1447a9aso15490346d6.0;
        Wed, 01 Jan 2025 20:14:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735791263; x=1736396063; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5Hgcp/rOQr79VmKLIg0j8jrldXJiZHkHt4iM1asDAr8=;
        b=DsDyMYs1z7F0WWhzvsX6ZYIWc+Z3XxbQZ9h3FkrJPgt0BwvCXBJJy3ofv4bS8ogNxw
         60gAcANdBf/AFbXI3wDDHBCFbsE8E10JLPlzMcB7nh2zFd6sFl6T6Ar3Kcmu9sxYUneH
         jIsZH+PVONQcwf0ifyOPSewFV3WWuUpAkZ0ObiWWejPLxn2tvFazRobdzxOAg/jqHjBK
         cu3Seri4DEYMraSl6BOh8hXgyqaqzWwhIBK5N5opTzIBgZGFtywsY61YLvxYbrkybaLl
         zWuzMJsrDUipkuDMankVdDfDmHxJhhxBM+0UKiLguBWlAfmobVMoxDS+mfsIUaLBSQQR
         ggfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735791263; x=1736396063;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5Hgcp/rOQr79VmKLIg0j8jrldXJiZHkHt4iM1asDAr8=;
        b=suSPEGeqXRWU66XQhdpH8hZyyXE0VubCoSYAkzEjvzL62Z+xDmwZFLB99Rn/7xSkQF
         w3Xmay58qtRuaDYo6toxQlKf5H6vAIKVAxURY8nydTTOqIyH3wkiWFOFlfmpLKf+LNdv
         VA3+mIaw8q3R0JKRWeGDy3p6nlq+ouJa63i2PPgBrrG3i5DXpuqHSSvGCxmRzJ2RDUcG
         06a3TIczNfz3/Jrm4iaqv8ksnpVDPXDYbqTHq7NjgEj6V13l6HxImnBeuHj74WbHxqsW
         T/Q7/fiOFm3XFMhbNqmUiKzJ8xcugX9ZD3mfdnHlsFZzWAfRNsEC2B+2snmIfDR4ORPX
         pluQ==
X-Forwarded-Encrypted: i=1; AJvYcCU6mqCezQGJALAp9wgZGS5+0ifdLxeQ/9yhCI/655FhxbNmugF9hJY4qrUJinsCTkelFifF9/yIf55S@vger.kernel.org, AJvYcCVcz8w3sI4scEjCKAXU4wsW4U1C/aOOGmC+DQN54SNmEgQLxw5AtE/q19ct7tTOexxPHaHhH9rjgmcFkqg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxCOGgk6mP7f3xNGCNzsTrhgYLzMF3pfqOR7GZmIx0991Y/rTnk
	eACn/FtIMsbV8JxeRq3f+xKSOm6eEukRjQLeRtaA7HDa1KeeoScU0KpJBiAWzFWSPzNP7f8zC47
	vza/zdvDRR8vxffZJ+3sQPHy9hw0=
X-Gm-Gg: ASbGnctnE4cRGqJbYxDd1Zpy5guJdkpYA+FaabzBoB6ow++uOHP/Y/oWaG+c8Hxw/Z/
	UYr2X9kMxAY1tAnvTGLnpNEHCJTj40oyGGh81
X-Google-Smtp-Source: AGHT+IFr7tvxbRKEbc/MhAaqub4aH+1KVgUxrzvAU5kl3LyseYHaL9kSpb1EnoTr3URARnoThLyWtFsknNlaiY8H70s=
X-Received: by 2002:a05:622a:14d3:b0:46a:312a:54d3 with SMTP id
 d75a77b69052e-46a4a8cbf47mr286083581cf.4.1735791262861; Wed, 01 Jan 2025
 20:14:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Allen Toureg <thetanix@gmail.com>
Date: Wed, 1 Jan 2025 20:14:12 -0800
Message-ID: <CABrqrA6b2y29tC2Z-9H2vYsuP_t5c6uCw9DZrjY7DmeNcczf0w@mail.gmail.com>
Subject: md-linear accidental(?) removal, removed significant(?) use case?
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>, linux-raid@vger.kernel.org, 
	regressions@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Preamble: I have extensive arrays of drives and due to their irregular
sizes, I was using md-linear as a convenient way to manually
concatenate arrays of underlying MD (raid5/etc) to manually deal with
redundancy.

I have probably a few thousand TB in total raw space, and hundreds of
TB of actual data and files attached to singular systems.

In a recent OS update, I discovered my larger volumes no longer mount
because md-linear has been removed entirely from the kernel as of 6.8.

I am trying to do rationale archaeology. I sent a note to Mr. Neil
Brown who was responsible for the earliest change I found related to
this and he suggested I email regressions and linux-raid along with
the current maintainers about it.

What I've been able to find:

In 2604b703b6b3db80e3c75ce472a54dfd0b7bf9f4 (2006) Neil Brown marked a
MODULE_ALIAS entry for md-personality-1 as deprecated but it appears
the reason was because the form of the personality was changed (not
that the underlying md-linear itself was deprecated.)

d9d166c2a9d5d01af34396793950aa695883eed4 (2006) reinforced this change
via a diff algorithm that overzealously included that line in a diff
chunk but which makes annotating prior to it a more manual process.

608f52e30aae7dc8da836e5b7b112d50a2d00e43 (2021) marked md-linear as
deprecated in Kconfig, using the rationale that md-linear was
deprecated in MODULE_ALIAS=E2=80=94but again which doesn't explain why the
*module* was deprecated and appears to me at least to accidentally
misconstrue the original reason for the deprecation comment.

849d18e27be9a1253f2318cb4549cc857219d991 (2023) eliminated md-linear
entirely, again mostly self-referencing a deprecation notice which was
there in actuality for basically multiple decades and seems to have
referenced something else entirely.

I was hoping you could help me understand why this module was removed?
I have found others who also are running into this. Functionality they
relied on has disappeared, as per the existence of the following:

https://github.com/dougvj/md-linear

https://gitlab.archlinux.org/archlinux/packaging/packages/linux/-/issues/34
https://bbs.archlinux.org/viewtopic.php?id=3D294005
(etc)

So, it looks like there are many of us who were still using mdadm to
manage sub-device concatenation, again in my case for 100s of TB of
admittedly casual data storage, and I can't currently find what the
actual actual rationale was for removing it. :(

For utility's sake, I would like to suggest that linear volumes lessen
problems like substriping. I do not think for many of us that
shuffling around a few hundred TB is easy to do at any rate. Currently
I'm manually re-compiling a fairly heavily-modified md-linear as a
user-built module and it seems to work okay. I am definitely not the
only one doing this.

Please consider resurrecting md-linear. :-)

Thank you,
Sincerely,
at
