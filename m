From: "Duncan Laurie" <duncan@sunbalt.net>
Subject: Re: ServerWorks chipset
Date: Tue, 27 Aug 2002 12:09:51 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <pan.2002.08.27.19.09.48.254585@sunbalt.net>
References: <Pine.LNX.4.30.0208261440170.10850-100000@duplo.agenda.si>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org, Danilo Godec <danci@agenda.si>
List-Id: linux-raid.ids

On Mon, 26 Aug 2002 14:45:27 +0200, Danilo Godec wrote:
>
> I'm using several Intel server boards with ServerWorks CSB5 chipset for
> IDE. Even though this chipset is supposed to support ATA100 and it is
> supposed to be supported in Linux and I do have CONFIG_BLK_DEV_SVWKS=y
> in my .config, I can't set speeds higher than 'hdparm -X66 /dev/hda'!
> 

This is because the Serverworks CSB5 does not provide any way to detect
80-conductor cable presence.  (see my notes at the top of
drivers/ide/serverworks.c)  Some vendors have worked around this problem
by having the BIOS encode it in the top 2 bits of the subsystem device ID.
This includes Sun Cobalt and Dell boxes with the CSB5.

You should be able to override the cable detection by passing parameters:

   ide0=ata66 ide1=ata66

It is also possible the Intel BIOS is encoding it somewhere already, in
which case it could be worked around in the driver.  Try examining the
subsystem device ID with various combinations of drives plugged in and see
if there is any discernable pattern.

-duncan

