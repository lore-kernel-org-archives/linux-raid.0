From: Phil Turmel <philip@turmel.org>
Subject: Re: Found duplicate PV: using /dev/sda3 not /dev/md1
Date: Sun, 15 Jun 2014 22:46:40 -0400
Message-ID: <539E5A90.3080207@turmel.org>
References: <1896515726.20140614235853@oudeis.org> <1454723160.20140615203503@oudeis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1454723160.20140615203503@oudeis.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?UmFpbmVyIEbDvGdlbnN0ZWlu?= <rfu@oudeis.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Rainer,

[please don't top-post, please *do* trim your replies]

On 06/15/2014 02:35 PM, Rainer F=C3=BCgenstein wrote:

> today I replaced two old 750GB disks in a RAID1 with two new 1TB
> disks:
>=20
> /dev/md0 (sda1, sdb1) (root filesystem)
> /dev/md1 (sda3, sdb3) LVM with /var (and others)

> /dev/md1:
>         Version : 0.90
>   Creation Time : Mon Jun  6 23:12:19 2011
>      Raid Level : raid1

Your problem is that you are using version 0.90 metadata.  It and v1.0
put the superblock at the end of the member devices, and it cannot be
found if the device size changes.  Plus, the data starts at sector zero=
,
so if the MD superblock isn't found, the device content is identified
without the raid layer.

These metadata formats should only be used with boot partitions that
need to be readable without assembling the array.

> status update:
>=20
> the server is running under a slight load, some incoming mails and
> logging (messages, maillog). no data corruption so far.

Just luck. . .

> my assumption: since all writes go to /dev/sda3 via LVM, no writes go
> to the raid, therefore it doesn't sync, therefore no data corruption.

Your PV is /dev/sda3, and it is also the rebuild target of your md1
array, so writes to it are coming from two directions.  Your lack of
corruption at the moment is a lucky fluke.

You need to stop /dev/md1 as soon as possible to eliminate the chances
of further corruption.

If you must keep the server online, I recommend the following steps:

1) Create a new /dev/md1 array with v1.2 metadata, and just /dev/sdb3.
Use "missing" for the second copy.  Zero the beginning of /dev/sdb3 to
make sure it is not misidentified as the old PV.

2) Create a new PV on the new /dev/md1 and add it to your existing
volume group.

3) Use "pvmove" to migrate the LVs in your volume group from /dev/sda3
to the new /dev/md1.

4) When the /dev/sda3 PV is empty, remove it from the volume group and
pvremove its signature.

5) Add the cleared /dev/sda3 to the new /dev/md1 and let it rebuild.
The v1.2 metadata will prevent this problem from happening again.

6) Update your mdadm.conf file, lvm.conf file (if necessary) and then
update your initramfs.

HTH,

Phil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
