From: danci@agenda.si
Subject: Re: Raid autodetection
Date: Fri, 6 Dec 2002 08:34:15 +0100 (CET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0212060830030.24068-100000@duplo.agenda.si>
References: <Pine.LNX.4.33.0212040849050.4409-100000@nooks.wimpunk.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.33.0212040849050.4409-100000@nooks.wimpunk.com>
To: Wim Vinckier <wim-raid@tisnix.be>
Cc: Steven Dake <sdake@mvista.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 4 Dec 2002, Wim Vinckier wrote:

> On Wed, 4 Dec 2002 danci@agenda.si wrote:
>
> > On Tue, 3 Dec 2002, Steven Dake wrote:
> >
> > > You can set a RAID to autostart by setting its partition id to 0xfd
> > > (RAID autostart) with the fdisk utility.
> >
> > I know that, it's what I do for last three years. But recently, I've
> > been trying to use modular kernels with SCSI drivers as modules.
> >
> > As the inital kernel raid autodetection happens BEFORE initrd loads the
> > SCSI drivers, it won't work.
> >
>
> You have to build your own initrd which loads the correct modules.  I
> thought SuSE has its own procedures to do it.  I thought you have to add
> the modules somewhere in /etc/rc.config and run mkinitrd.  Just check the
> documentation.

I know and I'm NOT using SuSE.

I just noted a 'new' command that SuSE had while the normal, plain
raidtools from Mingo had none. So I implemented the 'new' command
(raidautorun) in my distro and now it's all OK.

  D.


