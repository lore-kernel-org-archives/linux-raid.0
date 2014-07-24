From: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
Subject: Re: udev 215 creates inactive MD devices upon stopping them
Date: Thu, 24 Jul 2014 17:48:05 +0200
Message-ID: <53D12AB5.5090102@profitbricks.com>
References: <53D11CCA.1050602@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53D11CCA.1050602@profitbricks.com>
Sender: linux-raid-owner@vger.kernel.org
To: systemd-devel@freedesktop.org, Kay Sievers <kay@vrfy.org>
Cc: Linux RAID <linux-raid@vger.kernel.org>, artur.paszkiewicz@intel.com, Francis Moreau <francis.moro@gmail.com>
List-Id: linux-raid.ids

[resending to the correct mailing list]

Hi,

as discussed on linux-raid, please fix the bug that udev 215 creates
inactive MD devices upon stopping them.

Reference: http://www.spinics.net/lists/raid/msg46676.html
Reported-by: Francis Moreau <francis.moro@gmail.com>

An open() call to /dev/mdX after creating it with mknod is enough to
create such inactive MD device.

According to Artur the issue is caused by this change in udev:

> commit 3ebdb81ef088afd3b4c72b516beb5610f8c93a0d
> Author: Kay Sievers <kay at vrfy.org>
> Date:   Sun Apr 13 19:54:27 2014 -0700
>
>      udev: serialize/synchronize block device event handling with file locks
>
> http://cgit.freedesktop.org/systemd/systemd/commit/?id=3ebdb81ef088afd3b4c72b516beb5610f8c93a0d
>
> It seems that they have already disabled this for dm for some reason,
> but not for md:
>
> commit e918a1b5a94f270186dca59156354acd2a596494
> Author: Kay Sievers <kay@vrfy.org>
> Date:   Tue Jun 3 16:49:38 2014 +0200
>
>     udev: exclude device-mapper from block device ownership event locking
>
> http://cgit.freedesktop.org/systemd/systemd/commit/?id=e918a1b5a94f270186dca59156354acd2a596494
>

Thanks,
Sebastian


