From: Gordon Henderson <gordon@drogon.net>
Subject: Re: now on to tuning....
Date: Wed, 9 Mar 2005 10:14:50 +0000 (GMT)
Message-ID: <Pine.LNX.4.56.0503091006510.4055@lion.drogon.net>
References: <6F9171BE257CA742BFBCFA87B8F20F8D030E4351@NZURC900PEX1.ubsgs.ubsgroup.net>
 <Pine.LNX.4.56.0503090926190.4055@lion.drogon.net> <422ECA2A.8000806@wasp.net.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
In-Reply-To: <422ECA2A.8000806@wasp.net.au>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <brad@wasp.net.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 9 Mar 2005, Brad Campbell wrote:

> Gordon Henderson wrote:
>
> > And do check your disks regularly, although I don't think current version
> > of smartmontools fully supports sata under the scsi subsystem yet...
> >
>
> Actually, if you are using a UP machine, the libata-dev tree has patches
> that make this work. I believe there may be races on SMP machines
> however.
>
> All 29 drives get a short test every morning and a long test every
> Sunday morning. Odd results are immediately E-mailed to me by smartd.
>
> storage1:/home/brad# smartctl -A -d ata /dev/sda

Ahhh... I've been waiting for the magical "-d libata" to make it work.. I
never through to just try the -d ata!

And hurrah:

Old:

  skylla:/home/gordonh# smartctl -a /dev/sda
  smartctl version 5.33 [i686-pc-linux-gnu] Copyright (C) 2002-4 Bruce Allen
  Home page is http://smartmontools.sourceforge.net/

  Device: ATA      Maxtor 6Y080M0   Version: YAR5

  SATA disks accessed via libata are not currently supported by
  smartmontools. When libata is given an ATA pass-thru ioctl() then an
  additional '-d libata' device type will be added to smartmontools.

New:

  smartctl version 5.33 [i686-pc-linux-gnu] Copyright (C) 2002-4 Bruce Allen
  Home page is http://smartmontools.sourceforge.net/

  === START OF INFORMATION SECTION ===
  Device Model:     Maxtor 6Y080M0
  Serial Number:    Y2ASRT5E
  Firmware Version: YAR51HW0
  User Capacity:    80,000,000,000 bytes
  Device is:        In smartctl database [for details use: -P show]
  ATA Version is:   7
  ATA Standard is:  ATA/ATAPI-7 T13 1532D revision 0
  Local Time is:    Wed Mar  9 11:09:12 2005 GMT
  SMART support is: Available - device has SMART capability.
  SMART support is: Enabled

Cheers,

Gordon
Ps. This is a Dell 1U poweredge FWIW - Maxtor disks )-:
