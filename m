From: Neil Brown <neilb@suse.de>
Subject: Re: Linux RAID autodetect partitions go missing from /dev, but fdisk
 can see them
Date: Tue, 16 Dec 2008 14:27:50 +1100
Message-ID: <18759.8246.568849.244513@notabene.brown>
References: <49402CFE.3080708@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Tor Arne Vestbo on Wednesday December 10
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Tor_Arne_Vestb=F8?= <torarnv@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday December 10, torarnv@gmail.com wrote:
> Hi all,
>=20
> I have a very strange problem that I've been trying to debug for days
> now. I'm hoping someone on this list may have ran into this before, o=
r
> have any tips on how I can continue debugging this, because I have to
> admit I'm a little lost...

Yes, it does sound rather weird.
Can you:

  mdadm -Esv

and
  mdadm --stop /dev/md0
  strace -o /tmp/str -s 200 mdadm --assemble --scan --verbose /dev/md0

and send me the output and /tmp/str.
Also the contents of /etc/mdadm.conf might help.

Thanks,
NeilBrown


>=20
> I had a RAID5 with four drives and one spare, /dev/sd[bcde]1 +
> /dev/sdf1, and everything was working fine, until one day one of the
> drives in the array (sdb) no longer had a partition (sdb1). Letting t=
he
> spare take over I ignored this for a few days, but then it happened
> again, this time with sdc. Kernel is 2.6.22.17, and I've compiled all
> raid support in. The symptoms are:
>=20
>   - The kernel seems to detect the partitions (lines 396 and 407 in t=
he
> dmesg [1])
>=20
>   - But once the boot process finishes and the RAID is started, there=
 is
> no longer any sdc1 or sdb1, so the RAID fails to start (lines 550-576=
 in
> dmesg [1])
>=20
>   - Running fdisk -l shows that the drives in question (sdb and sdc) =
do
> have similar partitions as the other working drives, namely one Linux
> RAID autodetect partition each (see command output [2])
>=20
>   - But, the partitions are missing from /proc/partitions (see [3])
>=20
>   - Manually adding device nodes using mknod works, but doing file -s=
L
> on the device gives "writable, no read permission", even though
> permissions are the same as the other sd* nodes in /dev
>=20
>   - Running 'partprobe -s' successfully finds the two missing partiti=
ons
> and adds device nodes, and the nodes can be 'file -sL'ed, but when
> trying to assemble the array again with these new nodes in the system=
,
> I'm told that sdc1 is not found, and after the --assemble is done, th=
e
> device nodes are once again missing (!) see [4]
>=20
>   - I've tried using the 'dmraid' command to look for fakeraid
> partitions or meta data on the drives, which I was told could mess up
> the auto-detection of Linux software ride partitions, but could not f=
ind
> any issues.
>=20
>=20
> As you can tell I've exhausted all my current options, so any help on
> what I could try next would be very much appreciated. I am especially
> curious as to why I lose the partitions when mdadm tries to assemble =
the
> array?
>=20
> Thanks!
>=20
> Tor Arne Vestb=F8
>=20
> [1] http://pastebin.com/m15b9c275   dmesg
> [2] http://pastebin.com/f50fb323a   fdisk -l
> [3] http://pastebin.com/f4547c2ca   cat /proc/partitions
> [4] http://pastebin.com/m4475c9ae   partprobe + mdadm --assemble
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
