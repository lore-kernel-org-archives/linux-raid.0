From: Gregory Seidman <gsslist+linuxraid@anthropohedron.net>
Subject: Re: hard drives with "variable"  device names - mdadm raid assembly options setup
Date: Sat, 31 Dec 2005 08:09:45 -0500
Message-ID: <20051231130945.GA10745@anthropohedron.net>
References: <200512300908.19390.mlaks@verizon.net> <87d5jep027.fsf@rimspace.net>
Reply-To: gsslist+linuxraid@anthropohedron.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87d5jep027.fsf@rimspace.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Dec 31, 2005 at 11:44:32AM +1100, Daniel Pittman wrote:
} Mitchell Laks <mlaks@verizon.net> writes:
} 
} G'day Mitchell.
} 
} > I notice on my system that the hard drives "device names" can change.
} >
} > The hard drives are connected to the motherboard SATA connectors or to
} > PCI SATA cards. They get different "names" /dev/sda or /dev/sdc
} > depending how many of the cards are "active".
} >
} > For instance the hard drives on the motherboard itself are called
} > /dev/sde and /dev/sdf if there are hard drives on the 2 PCI cards and
} > are called /dev/sda and /dev/sdb if there are none.
} 
} Well, one solution is udev, but since you prefer to avoid that...
[...]

I have an 8-tray SCSI hotswap rack, and I had a similar problem. I use
scsidev, from the scsitools package (under Debian, at least), to create
appropriately named block devices at boot before mdadm starts any md
devices. My /etc/scsi.alias:

id=0, hostname="Adaptec AIC7XXX", devtype=disk, alias=rack0
id=1, hostname="Adaptec AIC7XXX", devtype=disk, alias=rack1
id=2, hostname="Adaptec AIC7XXX", devtype=disk, alias=rack2
id=3, hostname="Adaptec AIC7XXX", devtype=disk, alias=rack3
id=8, hostname="Adaptec AIC7XXX", devtype=disk, alias=rack4
id=9, hostname="Adaptec AIC7XXX", devtype=disk, alias=rack5
id=10, hostname="Adaptec AIC7XXX", devtype=disk, alias=rack6
id=11, hostname="Adaptec AIC7XXX", devtype=disk, alias=rack7

Now, this is just matching by SCSI id (and SCSI host) since I don't want to
have to reconfigure on hotswap and the tray position controls the SCSI id,
but it can match by any combination of manufacturer, serial_number, model,
rev, wwid, lun, chan, hostname, hostid, and hostnum. Running scsidev -f
will create block devices in /dev/scsi; I have /dev/scsi/rack[0-7]. Then my
/etc/mdadm/mdadm.conf looks like this:

DEVICE /dev/scsi/rack[01234567]
ARRAY /dev/md0 devices=/dev/scsi/rack0,/dev/scsi/rack1,/dev/scsi/rack2,/dev/scsi/rack3,/dev/scsi/rack4,/dev/scsi/rack5,/dev/scsi/rack6,/dev/scsi/rack7

Very simple, very easy. The scsitools package includes scsiinfo, which
should work on SATA (or ieee1394, or USB) drives to retrieve serial
numbers. 

} Regards,
}         Daniel
--Greg

