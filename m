From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: Driver for BIOS-based software RAIDs
Date: Mon, 13 Oct 2003 21:03:23 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031013190323.GD23916@marowsky-bree.de>
References: <200310131921.45824.thomas@horsten.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200310131921.45824.thomas@horsten.com>
To: Thomas Horsten <thomas@horsten.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2003-10-13T19:21:45,
   Thomas Horsten <thomas@horsten.com> said:

> Now, the problem is that these BIOS based software RAID's all use who=
le disks=20
> as opposed to individual partitions like the Linux MD driver.

Why is that a problem? You can assemble a MD using whole disks instead
of partition. A block device is a block device is a block device.

> Another way of doing it would be to create a separate native MD RAID =
for each=20
> partition on the BIOS RAID, but this has the major drawback that the =
user=20
> wouldn't be able to repartition the device.

Use a volume manager (LVM1, LVM2, EVMS2 ...) on top of the md. Works
just fine.

> 1) User selects CONFIG_MD_FOREIGN_SUPERBLOCKS and CONFIG_MD_WHOLEDISK=
_RAID,=20
> along with one oif the BIOS specific drivers like CONFIG_MD_FOREIGN_M=
EDLEY.=20
> Each BIOS driver has its own superblock type.

Autodiscovery is a problem, but I'd prefer to do that in the initrd fro=
m
within userspace. That's much cleaner.

Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering		ever tried. ever failed. no matter.
SuSE Labs				try again. fail again. fail better.
Research & Development, SUSE LINUX AG		-- Samuel Beckett

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
