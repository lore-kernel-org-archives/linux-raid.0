From: Danilo Godec <danci@agenda.si>
Subject: Re: recovering after a /dev/sda failure on raid1
Date: Sat, 3 Aug 2002 01:03:34 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.30.0208030058480.26520-100000@duplo.agenda.si>
References: <15690.63749.164322.929689@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <15690.63749.164322.929689@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Louis-David Mitterrand <vindex@apartia.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 3 Aug 2002, Neil Brown wrote:

> > My concern is that if I power down and replace /dev/sda the machine
> > won't be able to reboot without a rescue CD (lilo.conf has root=/dev/md0
> > and boot=/dev/md0) or will it?

A recent enough lilo knows raid partition and will install it self on both
disks. So, in theory both disk should be able to boot you system.

> > When the bios (Dell Poweredge 1500) will try /dev/sda's mbr and fail,
> > will it then automatically try /dev/sdb?

It might not even try /dev/sdb if /dev/sda exists...
But with some recent bioses you can choose which drive you want to boot,
sou you could just choose your 2nd SCSI drive and it should work.


   D.


