From: Wim Vinckier <wim-raid@tisnix.be>
Subject: Re: Raid autodetection
Date: Wed, 4 Dec 2002 08:50:22 +0100 (CET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33.0212040849050.4409-100000@nooks.wimpunk.com>
References: <Pine.LNX.4.44.0212040830320.20799-100000@duplo.agenda.si>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0212040830320.20799-100000@duplo.agenda.si>
To: danci@agenda.si
Cc: Steven Dake <sdake@mvista.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 4 Dec 2002 danci@agenda.si wrote:

> On Tue, 3 Dec 2002, Steven Dake wrote:
>
> > You can set a RAID to autostart by setting its partition id to 0xfd
> > (RAID autostart) with the fdisk utility.
>
> I know that, it's what I do for last three years. But recently, I've
> been trying to use modular kernels with SCSI drivers as modules.
>
> As the inital kernel raid autodetection happens BEFORE initrd loads the
> SCSI drivers, it won't work.
>

You have to build your own initrd which loads the correct modules.  I
thought SuSE has its own procedures to do it.  I thought you have to add
the modules somewhere in /etc/rc.config and run mkinitrd.  Just check the
documentation.

> > You could also use an initrd
> > to scan the configuration file and start the RAID arrays.
> >
> > The second is what most distributions do such as RedHat.
>
> Found out that SuSE has another way - they add a 'raidautorun' utility to
> raidtools, which forces the kernel to re-autodetect raid stuff. It can be
> used in a initrd, AFTER loading the SCSI driver.
>
> With this, it's probably even possible to have RAID compiled as modules.
>
> Thanks, D.
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

------------------------------------------------------------------------
Wim VINCKIER
Wasstraat 38                                          Wim-Raid@tisnix.be
B-9000  Gent                                               ICQ 100545109
------------------------------------------------------------------------
'Windows 98 or better required' said the box... so I installed linux

