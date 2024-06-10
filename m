Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278D27E767
	for <linux-raid@vger.kernel.org>; Mon, 10 Jun 2024 14:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718028937; cv=none; b=oV1deX9D5hw7Wh1sT+14CmRT/VBw3p72oo80Q4/2zhqvc0sv+ZCvH/pX1lCROpiWZmaQOeurb4QTj25M2rtynAgDcLz7LA7yq+/jhSu1v7IvmC/pxmJMRHTibyjpk/eqf08fKTpoec1nK68nd2EPtjQCY/y/wksP1WbxvBN5s8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718028937; c=relaxed/simple;
	bh=oXDWZrddWYaWQcgt6m+JPRYQBlhrfdQPsiInv+m/HXc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=W4jc/2iDUspezZiROAyQWSPzQlf1d8ichy8JIAJ/uVUyuBQD3nIvxpAY3ZFKU7U0QQi1axK6lJa5Dl05eTpBwb1WMLovaWFEksjl1mC15oh7sN7gS5+QK1FZBzKNbrKn3htbtPvPKQoSSlmGDlNHMA0aqmUqyVaBRIBu9ECfvO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=G9vnmsQ8; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="G9vnmsQ8"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-6e3741519d7so1899508a12.2
        for <linux-raid@vger.kernel.org>; Mon, 10 Jun 2024 07:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1718028935; x=1718633735; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oXDWZrddWYaWQcgt6m+JPRYQBlhrfdQPsiInv+m/HXc=;
        b=G9vnmsQ8j4wmg12G1Q6VstXPzt00KepRPmBdWXTMtYb4dnYdVEdjkox+a9+eH3Auq6
         yzcRLMtMeckTM2nOheTEPC3ZCNWT+4O0L2VfX2eIOMuoi8ueM5KaL7EjF9uWErGHqb2d
         lAhfZAHJmPd11zy5Dsa+czFePiEAek4jRHbnrLN8RHTT6HO76rHbNuXLnuT0Xg3C0IZU
         QAN5YceRzpzRpLnrKJJji0UffeaKMOj+WSOGzDzoU1b8h4LtuCt8HrAgb6BL/NL7zfum
         HWv6Kk86Hkp9cBCAFwV+NE3zv8J+VrQRspuKwax10FXf+szY6elFpt9rblGLLVC/piTq
         FsKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718028935; x=1718633735;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oXDWZrddWYaWQcgt6m+JPRYQBlhrfdQPsiInv+m/HXc=;
        b=Fc3TasDwkTCQ8cLCmNIVvDTBJ/ohsFex99/W2l89CHxlKiHolvR9E1rVD+ra5uD88R
         UqOLjeTe++JULabxmAYT+RvoalZAyX1TvFBPpARCQJIhtMGBAr1UZOLzLcK0uWzjMMcq
         cvH2bj6wY8AhUI9NTZjUT+Zr2VMKPL2o0xQSXt4p7Qrr0zDE3nihOqkh/i++fqxKoeFY
         WqTHQGD+SCjuHkStb90d7JttMeOLX3FG+NIE1tcYjki52Rx1YtO9jlrBNUxynqYZnUOj
         kJ+/11v7P/skondh3NVeL0m42guKZqey+CMmKNqAGko6aJxu1li/7lHJYxS9XTg0A18G
         nT6Q==
X-Gm-Message-State: AOJu0YxSF1KY0qhw8lvhsZVsZ9KPyi7qwgYMwbC9jZ7f6WwmneOLujMh
	Qj5JnBiVNtgaVa31Q1tZQ9TVuDVK5/uTyRmP09eD0+xszaK0puCdxpifkWPddyRUR5WtJ/jshgf
	MjOGwAUWAi0MNBRfwmlDvsV1bziY3ghSX5l+cpE59JGFQ5Cxz
X-Google-Smtp-Source: AGHT+IHGfI/ffbpLU0vfaODWQtD5iPie6G88GpmvHICjsbAnFQTEVZdnaNuRHSYle6w7IshcGIR+7aVBdj2rxdPdn4A=
X-Received: by 2002:a17:90a:8c81:b0:2ae:7f27:82cd with SMTP id
 98e67ed59e1d1-2c2bc9bdb6bmr8097195a91.7.1718028934882; Mon, 10 Jun 2024
 07:15:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAFe+wq0JfKxmomPNPhKbvXaNjEQXb_==xNRhjvGEJBEjeKU_Sg@mail.gmail.com>
In-Reply-To: <CAFe+wq0JfKxmomPNPhKbvXaNjEQXb_==xNRhjvGEJBEjeKU_Sg@mail.gmail.com>
From: Lakshmi Narasimhan Sundararajan <lsundararajan@purestorage.com>
Date: Mon, 10 Jun 2024 19:45:22 +0530
Message-ID: <CAFe+wq3QUB3m6TaspxtGD94YLtwX9i8fKrxMyQaacbHdw0Dg0A@mail.gmail.com>
Subject: Re: Recovering mdraid after node reboot
To: linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Bumping my email here for your attention.
Can anyone confirm that the below recovery in the case highlighted is
reliable and correct.

On Wed, Jun 5, 2024 at 4:33=E2=80=AFPM Lakshmi Narasimhan Sundararajan
<lsundararajan@purestorage.com> wrote:
>
> Hi Team,
> A very good day to you all.
>
> I have a below scenario wherein mdraid array (raid0 originally) is
> failing to assemble after a node reboot, while array was expanding
> capacity (hence raid4).
> Can you please confirm that the forced recovery in this below scenario
> is correct and reliable always.
>
> 1/ create md array (raid0)
> example cmd:
> mdadm -C /dev/md/vol0 -n 2 --metadata 1.2 -c 1024 -l 0 /dev/sda /dev/sdb
>
> 2/ array goes full, so need to expand capacity
> Since this is a virtual environment, I am able to resize /dev/sda and
> /dev/sdb disks outside that are attached to my server node.
>
> After increasing the disk capacity backing disks /dev/sda and
> /dev/sdb, I am attempting to grow the array to the max capacity.
>
> 3/ Convert md array to raid 4
> mdadm -G /dev/md/vol0 -l 4
>
> 4/ grow array to max capacity
> mdadm -G /de/vmd/vol0 --size max
>
> 5/ put it back to raid 0
> mdadm -G /de/vmd/vol0 -l 0
>
> In the above sequence, I only expand capacity by resizing the array
> elements and not by adding new disk to the array. While in the above
> sequence, I hit a power fail and node got rebooted.
>
> After node reboot, since array was in raid4 it failed to come online.
> ```
> Jun 03 23:08:35 kernel: md/raid:md126: not clean -- starting
> background reconstruction
> Jun 03 23:08:35 kernel: md/raid:md126: device sda operational as raid dis=
k 0
> Jun 03 23:08:35 kernel: md/raid:md126: device sdb operational as raid dis=
k 1
> Jun 03 23:08:35 kernel: md/raid:md126: cannot start dirty degraded array.
> Jun 03 23:08:35 md/raid:md126: failed to run raid set.
> Jun 03 23:08:35 kernel: md: pers->run() failed ...
> ```
>
> I recovered the array using the below sequence, given the array
> expansion was only through disk capacity resize.
>
> mdadm -S /dev/md126 /// which mapped to /dev/md/vol0 above
> mdadm -C /dev/md/vol0 -n 2 --metadata 1.2 -c 1024 -l 0 --assume-clean
> --force /dev/sda /dev/sdb
>
> This brought up the array back online and contents were okay too.
>
> So in the above sequence of actions, I want to understand the following:
> -- is the above method a reliable way to recover array incase there
> was a node reboot while in raid4 state?
>
> -- Please let me know your thoughts on recovery and data reliability
> on the array while recovering through the above sequence.
>
> Many thanks and kind regards for your help and insights.
> LN
