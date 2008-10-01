From: "David Lethe" <david@santools.com>
Subject: RE: SATA errors?
Date: Wed, 1 Oct 2008 06:48:12 -0500
Message-ID: <A20315AE59B5C34585629E258D76A97C02180F8B@34093-C3-EVS3.exchange.rackspace.com>
References: <48E34221.1000008@agenda.si> <20081001100833.3253724847@gemini.denx.de> <48E353D5.1060908@agenda.si>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <48E353D5.1060908@agenda.si>
Sender: linux-raid-owner@vger.kernel.org
To: Danilo Godec <danilo.godec@agenda.si>, Wolfgang Denk <wd@denx.de>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Danilo Godec
> Sent: Wednesday, October 01, 2008 5:41 AM
> To: Wolfgang Denk
> Cc: Linux RAID Mailing List
> Subject: Re: SATA errors?
> 
> Wolfgang Denk pravi:
> > In my experience, problems like this are often casued by
> > broken/unreliable cables / connectors / backplanes.
> >
> > As a first measure, try replugging the SATA cables.
> >
> > If this doesn't help, try swapping arount the disks and cables to
see
> > if the problem is with the cable (sticks with the disk) or  with
the
> > backplance (sticks with a physical port).
> >
> That has been one of my ideas too and I have already checked and
> swapped cables - but no success. I couldn't change the backplane as I
> don't have a spare one.
> 
> But there is one thing though that crossed my mind just seconds after
> I've hit the 'send' button!
> 
> I periodically check (every minute)  the drive temperature using
> 'smartctl -a' and I only query one drive - '/dev/sda'! So I re-checked
> my log files and indeed - the SATA error ALWAYS happens within one
> second of the 'smartctl' command (but not every time).
> 
> So now I changed the scripts to query a different drive ('/dev/sdb').
> In a couple of hours I should know if that was it...
> 
>   Thanks for the help, Danilo
> 
> PS: Oh, one more thing - the 'sda' drive is a WDC, while all the
others
> are Seagate.
> 
> 
> > Then replace the faulty components.
> >
> > Best regards,
> >
> > Wolfgang Denk
> >
> >
> 
> 
> --
> Danilo Godec, sistemska podpora
> 
> Predlog! Obiscite prenovljeno spletno stran http://www.agenda.si
> 
> ODPRTA KODA IN LINUX
> STORITVE : POSLOVNE RESITVE : UPRAVLJANJE IT : INFRASTRUKTURA IT :
> IZOBRAZEVANJE : PROGRAMSKA OPREMA
> 
> Visit our updated web page at http://www.agenda.si
> 
> OPEN SOURCE AND LINUX
> SERVICES : BUSINESS SOLUTIONS : IT MANAGEMENT : IT INFRASTRUCTURE :
> TRAINING : SOFTWARE
------------------------------------------------------------------------
----------

There is no cause of concern. The 0x25 command translates to
READ_CAPACITY10.  (i.e., how many blocks does the disk hold).  This
command is emulated because the disk doesn't natively speak SCSI
commands, which is how your specific hardware/driver/controller
combination configures such things.

Ignore the error.  There is a long story behind encapsulating SATA
commands in SCSI frames, why it is reasonable for this to happen, and
how the controller resolves obtaining the number of usable blocks.

It is not a cable or controller as other people suggested.  It isn't
even an "error".  It is a case of an application issuing a command to
see if it is supported. The disk returned appropriate data indicating
the command isn't supported, and all is right with the world. There are
other ways to obtain the drive capacity, which are clearly successful,
as you are putting data on the disk now.

David @ santools.com
-----------------------------------------------------------


