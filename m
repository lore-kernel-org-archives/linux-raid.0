Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6016E5ED
	for <linux-raid@vger.kernel.org>; Thu, 13 Jun 2024 19:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718308481; cv=none; b=sbW66D2n8TSCVojOl9YUtP22ySgmOYLDq7ouk0Qzot3rL0w0HeIUqL3/6GI9pNV571qDmlPMvpeBrVMH9HhhErQL4ngXAGa6YeNt02mvZ7T1LOSd6G7NZHDnVQDJDA6CggQ/uPqW2z1PvVJbuEK6Fue3I4ohGOFOPbhv8LmY+YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718308481; c=relaxed/simple;
	bh=nlecU8IXWJk487/1cx0TNeMWIJTeedLYeYmuABebgiM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=h8Q/0F4hb3BoT4Pf7Eik0Ex5d6EsSlw3VC+Ive4JW7vinsVZcNJZiV7PZO9+ALgrX/PPGF0XF+M3PiqkZI7dbQWrde8uC+TwtnBTZt/mwL8pHHuEEFut1eNSJO4pRCRDms9pGLv/LjZymfUEd2ozZNd29dj0C9kG9xesP6oKM8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pkm-inc.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=pkm-inc.com header.i=@pkm-inc.com header.b=VBNthdgQ; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pkm-inc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pkm-inc.com header.i=@pkm-inc.com header.b="VBNthdgQ"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2c195eb9af3so1153611a91.0
        for <linux-raid@vger.kernel.org>; Thu, 13 Jun 2024 12:54:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pkm-inc.com; s=google; t=1718308479; x=1718913279; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WvtsEy7wQc49p92dy49TH69XrLFOb18UWlaw3yvodSo=;
        b=VBNthdgQcOkLIlfB89nGbl/gcaZ17a+X/pmaPVbLWHNQ72DJP5ZTKUOkLlIGRcsf+I
         z+cirEjCjE4DoUJ4I/JMw9gorHRNc+BdUjl3usPW1aFJ2JwSSa3mWGODXZVV7an+LT7Q
         yuQZT5+2vI8sfASalTWoaQ+BdZZC97Uzrstnp9PkhNUxRCQNd0pKew0vKgo9taS50gGr
         QYXuFmHTtxSwc2jF/pTcvHfB/SFyWXOhQUTz5lDNu6rqFSb/I+eFF54SphFTP6m8FdCN
         MaVHwGVtEMERciM/ehXrzqRk6mu5FjDHha/Hv8tQESPu3uI7+l0wBB9UD/1rw4S5St1h
         4QTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718308479; x=1718913279;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WvtsEy7wQc49p92dy49TH69XrLFOb18UWlaw3yvodSo=;
        b=xLm/YvEcmR0mr0CCjSTFvbQ83GsH8NJqeiYb4oN1bmoCvuQXo273hvMnGcMvEZQTDd
         j56U3LhtuL682IEg0x4GuE2P1RVQbpNXUk2E+fp22qdCK+4ianTO77W0ayhjfauZCcV6
         27L/gj2egngZ4dW5qcpboUB+n9NtcuLBvXS/dAOFJM61hiUgVlMpx4etchnOe9X4lAEc
         46vN4cW0NcPbTkjULVyZSCJav4qYC6UfMvSFGURR1LzL3PRLTpRKV8rVS42JgPJMbehQ
         YBGA5c+mP/4vL9ZZjGcXD8jdPXfstYs0mWHGbs3WjJZssm5Nof3OlMuhM5Q1LjOKCxU2
         jFXw==
X-Gm-Message-State: AOJu0YyDPESqYmPoT1UgMegFtcvhp60PtrYjah4udBPAvVglhyDrX5ga
	Auwhc8rcY4GutOwZ+acyr0N7NhZKd4fW4JlS2NGH205nXGndyLEPbI8WVh0AZTC93XbCVxsBN3Q
	I6SDiMku8xod2kgfV65Ztp3LRs2CEK+xxL8M=
X-Google-Smtp-Source: AGHT+IFSIQYiuCoJwWJhC0/PL8lf3KMa3eBOTW3tM/vadAaucbzGahOOpEDxfCuV+fU4pVI8ZJnXnZVkMSSFPYu7GWc=
X-Received: by 2002:a17:90a:f60d:b0:2c1:a068:ba83 with SMTP id
 98e67ed59e1d1-2c4db23bf08mr830704a91.11.1718308479036; Thu, 13 Jun 2024
 12:54:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZmiYHFiqK33Y-_91@lazy.lzy> <cd3ed227-1410-478b-b86b-973d76b587df@thelounge.net>
 <ZmnZYgerX5g8S9Cp@lazy.lzy> <8eea69b5-4abb-46b6-8c7b-05c7ea0bf591@thelounge.net>
 <CALtW_ai69FCuHCMRDMzTxiEb6Yg22yd9vr+2d5_Ya1GSPbacRA@mail.gmail.com>
 <393c09c3-605b-475a-a61c-8e0306c7e9e6@thelounge.net> <CALtW_agtMXsss_Y=A2HH+D5zTceJ0jv5eWM5OeKiRZphvVeXZw@mail.gmail.com>
 <599595a2-fa5e-45ca-b358-5fb573a8920e@thelounge.net>
In-Reply-To: <599595a2-fa5e-45ca-b358-5fb573a8920e@thelounge.net>
From: =?UTF-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>
Date: Thu, 13 Jun 2024 21:54:27 +0200
Message-ID: <CALtW_aiOGWYZicL2h+KcFRhoXb2bAZM=dwG-=zVzCcS_eVm+sg@mail.gmail.com>
Subject: Re: RAID-10 near vs. RAID-1
To: linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> the whole discussion is nonsense
>
> you won't find any difference between a !! NVME RAID !! with TWO disks
> which is worth even to open a discussion
>

Previous response got blocked, maybe because it was just a link. Let's
see if this works.
Summary:

| fio iodepth=256, numjobs=4                       |  IOPS |     BW
| lat (usec) avg |
|--------------------------------------------------|:-----:|:---------:|:--------------:|
| Sequential 4k read, single disk                  |  828k | 3233MiB/s
|           1236 |
| Sequential 4k read, 4 disk RAID0, 64k chunk      |  666k | 2602MiB/s
|           1536 |
| Sequential 512k read, single disk                | 13.6k | 6798MiB/s
|          75300 |
| Sequential 512k read, 4 disk RAID0, 64k chunk    | 47.1k |   23GiB/s
|          21745 |
| Sequential 4k read, 2 disk RAID10F2, 64k chunk   |  523k | 2044MiB/s
|           1956 |
| Sequential 512k read, 2 disk RAID10F2, 64k chunk | 27.2k | 13.3GiB/s
|          37675 |


full test log: https://pastebin.com/raw/eq2CbjY7
