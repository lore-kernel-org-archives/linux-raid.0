From: "NeilBrown" <neilb@suse.de>
Subject: Re: Need urgent help in fixing raid5 array
Date: Wed, 7 Jan 2009 11:19:00 +1100 (EST)
Message-ID: <fc845631576f344bde1cd8126acf2367.squirrel@neil.brown.name>
References: <451872.61166.qm@web30802.mail.mud.yahoo.com>
    <alpine.DEB.1.10.0901011039110.9903@p34.internal.lan>
    <467705.96388.qm@web30807.mail.mud.yahoo.com>
    <alpine.DEB.1.10.0901011328380.17888@p34.internal.lan>
    <344038.60917.qm@web30808.mail.mud.yahoo.com>
    <18786.34165.639790.37753@notabene.brown>
    <546794.45786.qm@web30802.mail.mud.yahoo.com>
    <879ae2ec7c5524fd9fa9841245772ab6.squirrel@neil.brown.name>
    <100979.40008.qm@web30803.mail.mud.yahoo.com>
    <780997576890f2ccd07a4486c2702e8d.squirrel@neil.brown.name>
    <524209.67755.qm@web30805.mail.mud.yahoo.com>
    <18787.59872.647206.934303@notabene.brown>
    <46247.99152.qm@web30807.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <46247.99152.qm@web30807.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Myers <mikesm559@yahoo.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org, john lists <john4lists@gmail.com>
List-Id: linux-raid.ids

On Wed, January 7, 2009 10:54 am, Mike Myers wrote:

>
> With 15 hotswap drives in the system, I can tell you that device name
> changing is fraught with peril.  I am unfamilar with the /dev/disk/by-uuid
> functionality.  Is that documented in a howto somewhere?  How is that
> supposed to work?
>

/dev/disk/by-id is probably the one you want.
I don't know about documentation, but if you

 ls -l /dev/disk/by-id | grep -v part

and have a look it should make sense.
I get:
lrwxrwxrwx 1 root root  9 2009-01-07 11:10 ata-ST3160812AS_4LS5YYHQ ->
../../sda
lrwxrwxrwx 1 root root  9 2009-01-07 11:10 ata-ST3160812AS_4LS5YZDG ->
../../sdf
lrwxrwxrwx 1 root root  9 2009-01-07 11:10 ata-ST3160812AS_4LS5YZJQ ->
../../sdc
lrwxrwxrwx 1 root root  9 2009-01-07 11:10 ata-ST3160812AS_4LS5Z05D ->
../../sdd
lrwxrwxrwx 1 root root  9 2009-01-07 11:10 ata-ST3160812AS_4LS5Z0B6 ->
../../sde
lrwxrwxrwx 1 root root  9 2009-01-07 11:10 ata-ST3160812AS_4LS5Z0BH ->
../../sdb
lrwxrwxrwx 1 root root 11 2009-01-07 11:10
md-uuid-8fd0af3f:4fbb94ea:12cc2127:f9855db5 -> ../../md_d6
lrwxrwxrwx 1 root root  9 2009-01-07 11:10 scsi-SATA_ST3160812AS_4LS5YYHQ
-> ../../sda
lrwxrwxrwx 1 root root  9 2009-01-07 11:10 scsi-SATA_ST3160812AS_4LS5YZDG
-> ../../sdf
lrwxrwxrwx 1 root root  9 2009-01-07 11:10 scsi-SATA_ST3160812AS_4LS5YZJQ
-> ../../sdc
lrwxrwxrwx 1 root root  9 2009-01-07 11:10 scsi-SATA_ST3160812AS_4LS5Z05D
-> ../../sdd
lrwxrwxrwx 1 root root  9 2009-01-07 11:10 scsi-SATA_ST3160812AS_4LS5Z0B6
-> ../../sde
lrwxrwxrwx 1 root root  9 2009-01-07 11:10 scsi-SATA_ST3160812AS_4LS5Z0BH
-> ../../sdb


which shows you my 6 drives (each listed twice) with their model numbers
and serial numbers.
If I move the drive around, they will get different 'sda' names, but
if you look at the lines in disk/by-id you can be sure that a given name
will always refer to the same physical device.
This is all managed by 'udev'.

NeilBrown

