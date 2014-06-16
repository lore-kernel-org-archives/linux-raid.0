From: Phil Turmel <philip@turmel.org>
Subject: Re: Found duplicate PV: using /dev/sda3 not /dev/md1
Date: Mon, 16 Jun 2014 10:35:26 -0400
Message-ID: <539F00AE.9090504@turmel.org>
References: <1896515726.20140614235853@oudeis.org> <1454723160.20140615203503@oudeis.org> <539E5A90.3080207@turmel.org> <19411862.20140616155327@oudeis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <19411862.20140616155327@oudeis.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?UmFpbmVyIEbDvGdlbnN0ZWlu?= <rfu@oudeis.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Rainer,

[CC to list added back.  Use reply-to-all on kernel.org lists]

On 06/16/2014 09:53 AM, Rainer F=C3=BCgenstein wrote:
>=20
> PT> Your problem is that you are using version 0.90 metadata.  It and=
 v1.0
> PT> put the superblock at the end of the member devices, and it canno=
t be
> PT> found if the device size changes.  Plus, the data starts at secto=
r zero,
> PT> so if the MD superblock isn't found, the device content is identi=
fied
> PT> without the raid layer.
>=20
> If I understand it correctly, the error happened (apart from the
> superblock version) because of the reboot(s) before a) md1 was grown
> and/or/maybe b) sync was finished.

Probably, but v0.9 arrays are vulnerable to whole-disk vs. partition
misidentification, and should never be used on a partition that
encompasses the end of a disk.

> PT> These metadata formats should only be used with boot partitions t=
hat
> PT> need to be readable without assembling the array.
> this was how the centos installer created the raid (with 0.90). will
> keep it that way on md0 (which holds /boot and root).
>=20
> PT> You need to stop /dev/md1 as soon as possible to eliminate the ch=
ances
> PT> of further corruption.
>=20
> [root@gateway home]# mdadm --manage --stop /dev/md1
> mdadm: fail to stop array /dev/md1: Device or resource busy
> Perhaps a running process, mounted filesystem or active volume group?
>=20
> [root@gateway home]# lsof | grep md1
> md1_raid1   461      root  cwd       DIR                9,0     4096 =
         2 /
> md1_raid1   461      root  rtd       DIR                9,0     4096 =
         2 /
> md1_raid1   461      root  txt   unknown                             =
           /proc/461/exe
>=20
> since nothing else than md1_raid1 is accessing /dev/md1, I assume it
> is safe to --force --stop?

What is running as process ID 461?  That needs to be killed off, and an=
y
mount involving /dev/md1 stopped.

> PT> If you must keep the server online, I recommend the following ste=
ps:
>=20
> big thanks, your strategy is much better than the one I had planned
> (and fills some knowledge gaps).

Your situation is the primary reason I recommend LVM.

Phil

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
