From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: RAID extremely slow
Date: Fri, 17 Aug 2012 23:55:20 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1208172353260.3927@frira.zrqbmnf.qr>
References: <501078B2.8070707@familyross.net> <501096C3.5060700@turmel.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <501096C3.5060700@turmel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Kevin Ross <kevin@familyross.net>, linux-kernel@vger.kernel.org, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Thursday 2012-07-26 03:00, Phil Turmel wrote:
>> I used atop to show the transfer speeds to each drive. Here's a
>> screenshot:
>> http://img402.imageshack.us/img402/6484/screenshotfrom201207251.png
>
>[ The output of "lsdrv" [1] might be useful here, along with
>"mdadm -D /dev/md0" and "mdadm -E /dev/[b-j]" ]
>[1] http://github.com/pturmel/lsdrv

lsdrv? Shows a bunch, but for this, using standard tools
like lsscsi & lsblk seems sufficient :)
