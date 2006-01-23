From: Shawn Usry <shawn@joebacardi.com>
Subject: Re: multiple Sata SATAII 150, TX4  - how to tell which drive is which?
	headaches galore!
Date: Mon, 23 Jan 2006 14:44:04 -0600
Message-ID: <20060123204404.41cfc6ef@ted.secure-tunnel.com>
References: <43D53AEC.7060302@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43D53AEC.7060302@xs4all.nl>
Sender: linux-raid-owner@vger.kernel.org
To: John Hendrikx <hjohn@xs4all.nl>, PFC <lists@peufeu.com>
Cc: Mitchell Laks <mlaks@verizon.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The drives physically support SMART, but apparently the roadblock is lacking support in the libata drivers.  If you can force "legacy" mode from your Bios and drive your SATA disks with drivers/ide you can get full SMART support.

The details:
http://smartmontools.sourceforge.net/#testinghelp



----- Original Message -----
From: John Hendrikx
[mailto:hjohn@xs4all.nl]
To: PFC [mailto:lists@peufeu.com]
Cc: Mitchell Laks
[mailto:mlaks@verizon.net], linux-raid@vger.kernel.org
Sent: Mon, 23 Jan
2006 14:22:04 -0600
Subject: Re: multiple Sata SATAII 150, TX4  - how to
tell which drive is which? headaches galore!


> >
> >> I wanted to ask for any experience with running raid with SATA drives 
> >> and
> >> controllers here under linux.
> >>
> >     Maxtor SATA drives series 6V (those with 16 MB cache) are 
> > incompatible with nforce 3-4 SATA controllers. Maxtor acknowledges 
> > this. Symptom is a slow death of the drive, ending with command 
> > timeouts. When reverting the drive to SATA 1.5Gbps with the jumper, it 
> > works perfectly again (for a few days...). nvidia doesn't care. This 
> > is on windows and linux. In windows, you have to use fucking PIO mode 
> > or you get corruptions. nforce4 sata also has problems with plextor 
> > sata burners, and possibly others.
> I don't have much SATA experience, although a Western Digital 
> WD2500JD-75F seems to work fine with the nforce 4 ultra chipset.
> >     The Maxtor 6L series (with 8 MB cache) work flawlessly.
> >
> >     I currently have these SATA drives, on a nforce3 MSI mobo :
> >
> > # hdparm -I /dev/sd? |grep "Model Numb"
> >
> >         Model Number:       Maxtor 6L200M0
> >         Model Number:       Maxtor 6L250S0
> >         Model Number:       ST3250823AS
> >         Model Number:       ST3250823AS
> >
> >     All work. I RMA'd the 6V250 drive and exchanged it against a good, 
> > old, IDE drive, which works perfect.
> >
> >     It took me a month, 3 maxtor drives, and nights of googling to 
> > figure this out...
> >
> >     My gut feeling is that SATA isn't that ready for prime-time after 
> > all...
> Does SMART work for your SATA drives?  Without SMART support I don't 
> really want to get any more SATA drives.  Mine reports this:
> 
> ~$ smartctl -a /dev/sda
> smartctl version 5.32 Copyright (C) 2002-4 Bruce Allen
> Home page is http://smartmontools.sourceforge.net/
> 
> Device: ATA      WDC WD2500JD-75F Version: 02.0
> Serial number: WD-WMAEH1585485
> Device type: disk
> Local Time is: Mon Jan 23 21:14:56 2006 CET
> Device does not support SMART
> Request Sense failed, [Input/output error]
> 
> Device does not support Error Counter logging
> 
> [GLTSD (Global Logging Target Save Disable) set. Enable Save with '-S on']
> Device does not support Self Test logging
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
