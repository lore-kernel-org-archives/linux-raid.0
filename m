From: Mike Viau <viaum@sheridanc.on.ca>
Subject: RE: How to recreate a dmraid RAID array with mdadm
Date: Wed, 17 Nov 2010 17:36:23 -0500
Message-ID: <BAY148-w18A88E7D84CE0213B44F26EF380@phx.gbl>
References: <BAY148-w65577551281F75C185BEBEF380@phx.gbl>,<20101117141514.759d9eea@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101117141514.759d9eea@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, debian-user@lists.debian.org
List-Id: linux-raid.ids


> On Wed, 17 Nov 2010 14:15:14 +1100 <neilb@suse.de> wrote:
>
> This looks wrong. mdadm should be looking for the container as listed=
 in
> mdadm.conf and it should find a matching uuid on sda and sdb, but it =
doesn't.
>
> Can you:
>
> mdadm -E /dev/sda /dev/sdb ; cat /etc/mdadm/mdadm.conf
>
> so I can compare the uuids?
>

Sure.

# definitions of existing MD arrays ( So you don't have to scroll down =
:P )


ARRAY metadata=3Dimsm UUID=3D084b969a:0808f5b8:6c784fb7:62659383

ARRAY /dev/md/OneTB-RAID1-PV container=3D084b969a:0808f5b8:6c784fb7:626=
59383 member=3D0 UUID=3Dae4a1598:72267ed7:3b34867b:9c56497a

mdadm -E /dev/sda /dev/sdb

/dev/sda:
=A0=A0=A0=A0=A0=A0=A0=A0=A0 Magic : Intel Raid ISM Cfg Sig.
=A0=A0=A0=A0=A0=A0=A0 Version : 1.1.00
=A0=A0=A0 Orig Family : 601eee02
=A0=A0=A0=A0=A0=A0=A0=A0 Family : 601eee02
=A0=A0=A0=A0 Generation : 00001187
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 UUID : 084b969a:0808f5b8:6c784fb7:626593=
83
=A0=A0=A0=A0=A0=A0 Checksum : 2f91ce06 correct
=A0=A0=A0 MPB Sectors : 1
=A0=A0=A0=A0=A0=A0=A0=A0=A0 Disks : 2
=A0=A0 RAID Devices : 1

=A0 Disk00 Serial : STF604MH0J34LB
=A0=A0=A0=A0=A0=A0=A0=A0=A0 State : active
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Id : 00020000
=A0=A0=A0 Usable Size : 1953520654 (931.51 GiB 1000.20 GB)

[OneTB-RAID1-PV]:
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 UUID : ae4a1598:72267ed7:3b34867b:9c5649=
7a
=A0=A0=A0=A0 RAID Level : 1
=A0=A0=A0=A0=A0=A0=A0 Members : 2
=A0=A0=A0=A0=A0=A0=A0=A0=A0 Slots : [UU]
=A0=A0=A0=A0=A0 This Slot : 0
=A0=A0=A0=A0 Array Size : 1953519616 (931.51 GiB 1000.20 GB)
=A0=A0 Per Dev Size : 1953519880 (931.51 GiB 1000.20 GB)
=A0 Sector Offset : 0
=A0=A0=A0 Num Stripes : 7630936
=A0=A0=A0=A0 Chunk Size : 64 KiB
=A0=A0=A0=A0=A0=A0 Reserved : 0
=A0 Migrate State : idle
=A0=A0=A0=A0=A0 Map State : normal
=A0=A0=A0 Dirty State : clean

=A0 Disk01 Serial : STF604MH0PN2YB
=A0=A0=A0=A0=A0=A0=A0=A0=A0 State : active
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Id : 00030000
=A0=A0=A0 Usable Size : 1953520654 (931.51 GiB 1000.20 GB)
/dev/sdb:
=A0=A0=A0=A0=A0=A0=A0=A0=A0 Magic : Intel Raid ISM Cfg Sig.
=A0=A0=A0=A0=A0=A0=A0 Version : 1.1.00
=A0=A0=A0 Orig Family : 601eee02
=A0=A0=A0=A0=A0=A0=A0=A0 Family : 601eee02
=A0=A0=A0=A0 Generation : 00001187
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 UUID : 084b969a:0808f5b8:6c784fb7:626593=
83
=A0=A0=A0=A0=A0=A0 Checksum : 2f91ce06 correct
=A0=A0=A0 MPB Sectors : 1
=A0=A0=A0=A0=A0=A0=A0=A0=A0 Disks : 2
=A0=A0 RAID Devices : 1

=A0 Disk01 Serial : STF604MH0PN2YB
=A0=A0=A0=A0=A0=A0=A0=A0=A0 State : active
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Id : 00030000
=A0=A0=A0 Usable Size : 1953520654 (931.51 GiB 1000.20 GB)

[OneTB-RAID1-PV]:
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 UUID : ae4a1598:72267ed7:3b34867b:9c5649=
7a
=A0=A0=A0=A0 RAID Level : 1
=A0=A0=A0=A0=A0=A0=A0 Members : 2
=A0=A0=A0=A0=A0=A0=A0=A0=A0 Slots : [UU]
=A0=A0=A0=A0=A0 This Slot : 1
=A0=A0=A0=A0 Array Size : 1953519616 (931.51 GiB 1000.20 GB)
=A0=A0 Per Dev Size : 1953519880 (931.51 GiB 1000.20 GB)
=A0 Sector Offset : 0
=A0=A0=A0 Num Stripes : 7630936
=A0=A0=A0=A0 Chunk Size : 64 KiB
=A0=A0=A0=A0=A0=A0 Reserved : 0
=A0 Migrate State : idle
=A0=A0=A0=A0=A0 Map State : normal
=A0=A0=A0 Dirty State : clean

=A0 Disk00 Serial : STF604MH0J34LB
=A0=A0=A0=A0=A0=A0=A0=A0=A0 State : active
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Id : 00020000
=A0=A0=A0 Usable Size : 1953520654 (931.51 GiB 1000.20 GB)

----------------------------------
cat /etc/mdadm/mdadm.conf

# mdadm.conf
#
# Please refer to mdadm.conf(5) for information about this file.
#

# by default, scan all partitions (/proc/partitions) for MD superblocks=
=2E
# alternatively, specify devices to scan, using wildcards if desired.
DEVICE partitions

# auto-create devices with Debian standard permissions
CREATE owner=3Droot group=3Ddisk mode=3D0660 auto=3Dyes

# automatically tag new arrays as belonging to the local system
HOMEHOST <system>

# instruct the monitoring daemon where to send mail alerts
MAILADDR root

# definitions of existing MD arrays
ARRAY metadata=3Dimsm UUID=3D084b969a:0808f5b8:6c784fb7:62659383
ARRAY /dev/md/OneTB-RAID1-PV container=3D084b969a:0808f5b8:6c784fb7:626=
59383 member=3D0 UUID=3Dae4a1598:72267ed7:3b34867b:9c56497a

# This file was auto-generated on Fri, 05 Nov 2010 16:29:48 -0400
# by mkconf 3.1.4-1+8efb9d1


-M
 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
