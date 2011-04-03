From: Dennis Grant <reccedg@gmail.com>
Subject: Re: Mounting array at boot - works with some kernels but not others
Date: Sun, 3 Apr 2011 13:26:34 -0400
Message-ID: <BANLkTimogoGPhRCq-+aT=TobByyp4fdfAA@mail.gmail.com>
References: <BANLkTinSwLgNze-EdRB6wu1o5QYApHbLXQ@mail.gmail.com>
	<4D98AAD3.2050700@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D98AAD3.2050700@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Apr 3, 2011 at 1:13 PM, Phil Turmel <philip@turmel.org> wrote:

> On-list is fine. =A0A couple of clarifications below:

> Please do "mdadm --examine" on the component devices /dev/sda5 and /d=
ev/sdb5.

As requested:

sudo mdadm --examine /dev/sda
mdadm: No md superblock detected on /dev/sda.

sudo mdadm --examine /dev/sdb
mdadm: No md superblock detected on /dev/sdb.

> Please also share the output of "blkid" so we can interpret this fsta=
b.

sudo blkid
/dev/sda1: UUID=3D"b8f4b4ab-2e59-426e-b380-791f36ba473c" TYPE=3D"ext2"
/dev/sda2: UUID=3D"0bffc411-e143-4d25-bc59-b8b9fabb788a" TYPE=3D"ext3"
/dev/sda3: LABEL=3D"SWAP-sda3"
UUID=3D"873b1a20-cb72-4675-9cc7-fe6ac857490d" TYPE=3D"swap"
/dev/sda5: UUID=3D"e0cc58c7-6f84-1366-7a44-a46294a1d56a" TYPE=3D"linux_=
raid_member"
/dev/sdb1: UUID=3D"e9768910-bfd5-4e04-a244-db4a2da9b215" TYPE=3D"ext2"
/dev/sdb2: UUID=3D"9f3bb9ee-ee5e-48a8-bdbe-9c80561f41d0" TYPE=3D"ext3"
/dev/sdb3: LABEL=3D"SWAP-sdb3"
UUID=3D"47842e22-d4be-4738-ba2a-b13332b752e9" TYPE=3D"swap"
/dev/sdb5: UUID=3D"e0cc58c7-6f84-1366-7a44-a46294a1d56a" TYPE=3D"linux_=
raid_member"
/dev/sdc1: LABEL=3D"/boot1" UUID=3D"d0f1b0b3-81d7-416b-930d-8fc3c246302=
a"
TYPE=3D"ext3"
/dev/sdc2: UUID=3D"qJ01LE-w3nn-yV23-GFa6-mc0n-01tn-qLI4mv" TYPE=3D"LVM2=
_member"
/dev/md1: UUID=3D"cdd97ad2-e070-477b-b649-83921f70b9cf" TYPE=3D"ext3"
/dev/mapper/VolGroupHDB-LogVol00:
UUID=3D"eae940e9-e625-4769-b4ff-8929fdd73558" TYPE=3D"ext3"
/dev/mapper/VolGroupHDB-LogVol04:
UUID=3D"3b141c7e-b850-4659-a876-52c8bc592878" TYPE=3D"ext3"
/dev/mapper/VolGroupHDB-LogVol02:
UUID=3D"5cc5ecf4-0b15-410c-b8a6-7712ed35af83" TYPE=3D"ext3"
/dev/mapper/VolGroupHDB-LogVol03:
UUID=3D"787eb25b-537f-4b9a-8871-95a6118224c7" TYPE=3D"ext3"
/dev/mapper/VolGroupHDB-LogVol01: TYPE=3D"swap"

> I suspect that the new kernels are noticing your version 0.90 metadat=
a and trying to be conservative. =A00.90 metadata can be ambiguous when=
 on the last partition of a disk (same location and content as if for t=
he whole disk).

> You can remove the ambiguity by declaring in mdadm.conf that devices =
to inspect must be partitions, like so:
>
> DEVICE /dev/sd*[0-9]
>
> Or call them out explicitly:
>
> DEVICE /dev/sda5 /dev/sdb5

Here's the current version:

cat /etc/mdadm/mdadm.conf
# mdadm.conf
#
# Please refer to mdadm.conf(5) for information about this file.
#

# by default, scan all partitions (/proc/partitions) for MD superblocks=
=2E
# alternatively, specify devices to scan, using wildcards if desired.
DEVICE /dev/sda5 /dev/sdb5

# auto-create devices with Debian standard permissions
CREATE owner=3Droot group=3Ddisk mode=3D0660 auto=3Dyes

# automatically tag new arrays as belonging to the local system
HOMEHOST <system>

# instruct the monitoring daemon where to send mail alerts
MAILADDR root

# definitions of existing MD arrays
ARRAY /dev/md1 devices=3D/dev/sda5,/dev/sdb5

-------------------------
So it looks like they are already called out.

The lack of superblocks is - that maybe the issue? Can those be
created/restored without trashing the FS?

DG
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
