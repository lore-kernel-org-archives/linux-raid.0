From: danci@agenda.si
Subject: Re: Raid autodetection
Date: Wed, 4 Dec 2002 08:35:21 +0100 (CET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0212040830320.20799-100000@duplo.agenda.si>
References: <3DED0466.2020707@mvista.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3DED0466.2020707@mvista.com>
To: Steven Dake <sdake@mvista.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 3 Dec 2002, Steven Dake wrote:

> You can set a RAID to autostart by setting its partition id to 0xfd
> (RAID autostart) with the fdisk utility.

I know that, it's what I do for last three years. But recently, I've
been trying to use modular kernels with SCSI drivers as modules.

As the inital kernel raid autodetection happens BEFORE initrd loads the
SCSI drivers, it won't work.

> You could also use an initrd
> to scan the configuration file and start the RAID arrays.
>
> The second is what most distributions do such as RedHat.

Found out that SuSE has another way - they add a 'raidautorun' utility to
raidtools, which forces the kernel to re-autodetect raid stuff. It can be
used in a initrd, AFTER loading the SCSI driver.

With this, it's probably even possible to have RAID compiled as modules.

Thanks, D.

