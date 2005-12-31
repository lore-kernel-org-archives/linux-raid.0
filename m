From: Daniel Pittman <daniel@rimspace.net>
Subject: Re: hard drives with "variable"  device names - mdadm raid assembly options setup
Date: Sat, 31 Dec 2005 11:44:32 +1100
Message-ID: <87d5jep027.fsf@rimspace.net>
References: <200512300908.19390.mlaks@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mitchell Laks <mlaks@verizon.net> writes:

G'day Mitchell.

> I notice on my system that the hard drives "device names" can change.
>
> The hard drives are connected to the motherboard SATA connectors or to
> PCI SATA cards. They get different "names" /dev/sda or /dev/sdc
> depending how many of the cards are "active".
>
> For instance the hard drives on the motherboard itself are called
> /dev/sde and /dev/sdf if there are hard drives on the 2 PCI cards and
> are called /dev/sda and /dev/sdb if there are none.

Well, one solution is udev, but since you prefer to avoid that...

[...]

> Now I am confused:  unfortunately this does not seem to help me: 
> if it relys on the configuration file /etc/mdadm/mdadm.conf 
> this config file - i create with the aid of mdadm --detail --scan 
> seems to still have the (problematic) "variable" device names in it. 

...you can simply remove the 'device names' variable, and list the
theoretically possible devices for MD stuff in the configuration:

DEVICE /dev/hd*
DEVICE /dev/sd*

That will include all the IDE and SCSI disks (including SATA), so they
will be scanned at an appropriate time.

Then, list your arrays:

ARRAY /dev/md2 level=raid1 num-devices=2 UUID=529d70fa:e5fe992b:ceb05593:bfcc6c25

That will cause mdadm to scan all those device entries (all the disks
and partitions) looking for an array with the right UUID, and assemble
it from all the components it finds.

Regards,
        Daniel

