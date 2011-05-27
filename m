From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Storage device enumeration script
Date: Fri, 27 May 2011 10:15:05 +0100
Message-ID: <4DDF6B99.20602@anonymous.org.uk>
References: <4DDDC301.7090608@turmel.org> <1306403130.9437.109.camel@torbjorn> <4DDE249C.7080004@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DDE249C.7080004@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 26/05/2011 10:59, John Robinson wrote:
[...]
> [root@beast lsdrv]# python2.6 lsdrv
> PCI [pata_marvell] 03:00.0 IDE interface: Marvell Technology Group Lt=
d.
> 88SE6121 SATA II Controller (rev b2)
> =E2=94=94=E2=94=80scsi 0:0:0:0 HL-DT-ST DVD-RAM GH22NP20
> =E2=94=94=E2=94=80sr0: Empty/Unknown 1.00g
> PCI [ahci] 00:1f.2 SATA controller: Intel Corporation 82801JI (ICH10
> Family) SATA AHCI Controller
> =E2=94=9C=E2=94=80scsi 2:0:0:0 ATA Hitachi HDS72101
> =E2=94=82 =E2=94=94=E2=94=80sda: Empty/Unknown 931.51g
> Traceback (most recent call last):
> File "lsdrv", line 387, in <module>
> show_blocks(" %s " % branch[0], [phy.block])
> File "lsdrv", line 339, in show_blocks
> show_blocks("%s %s " % (indent, branch[0]), [blockbyname[x] for x in =
subs])
> KeyError: 'sda1'
>
> Now, something's not getting picked up about sda. Looking at Mathias'
> "sweet" output, it's not coping with the (DOS) partition table. Anoth=
er
> variation on my kernel's /sys or still to old a Python or ...?

Still seeing this. I added a print command so I can see that=20
dev.partitions is being populated successfully. I'm not entirely sure=20
where dev.ID_ etc are supposed to be coming from, but if it's that=20
`blkid -p -o udev /dev/block/8:0` then I'm afraid CentOS 5's blkid=20
doesn't understand the -p or -o udev options, it doesn't produce any=20
output for whole drives with partition tables, and there isn't a=20
/dev/block directory. It's blkid 1.0.0 from e2fsprogs 1.39-23.el5_5.1.

If that knocks CentOS 5 support on the head then so be it...

Cheers,

John.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
