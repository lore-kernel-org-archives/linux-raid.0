From: Chris Murphy <lists@colorremedies.com>
Subject: Re: How do I tell which disk failed?
Date: Tue, 8 Jan 2013 02:10:58 -0700
Message-ID: <3D8A55DE-C4A8-4639-A662-CD3FF228230F@colorremedies.com>
References: <1357610701.16366.13.camel@corn.betterworld.us> <50EBAC5D.8080000@hardwarefreak.com> <1357628351.16366.86.camel@corn.betterworld.us> <02B6762C-3755-4CE3-9AB1-A48D3384CACB@colorremedies.com> <1357631996.16366.139.camel@corn.betterworld.us>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1357631996.16366.139.camel@corn.betterworld.us>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Jan 8, 2013, at 12:59 AM, Ross Boylan <ross@biostat.ucsf.edu> wrote:
>=20
> Using /dev/sdb
> Model: ATA WDC WD2003FYYS-0 (scsi)
> Disk /dev/sdb: 3907029168s
> Sector size (logical/physical): 512B/512B
> Partition Table: gpt
>=20
> Number  Start     End          Size         File system  Name        =
           Flags
> 1      34s       999999s      999966s                   extended boot=
 loaders
> 2      1000000s  2929687s     1929688s     ext3         /boot        =
          boot
> 3      2929688s  6835937s     3906250s                  swap
> 4      6835938s  3907029134s  3900193197s               main
>=20
> Using /dev/sdc
> Model: ATA WDC WD2003FYYS-0 (scsi)
> Disk /dev/sdc: 3907029168s
> Sector size (logical/physical): 512B/512B
> Partition Table: gpt
>=20
> Number  Start     End          Size         File system  Name        =
           Flags
> 1      34s       999999s      999966s                   extended boot=
 loaders
> 2      1000000s  2929687s     1929688s     ext3         boot         =
          boot
> 3      2929688s  6835937s     3906250s                  swap
> 4      6835938s  3907029134s  3900193197s               main
>=20
> BTW the spec sheet for the WDC "red" drives says they use advanced
> formatting (I may not have the buzzword quite right) with physical
> sectors of 4k.  So the reported sector size is a fib.

Yeah you're using an old version of parted for it to not recognize that=
 the physical sectors are 4096 bytes. The thing is, that it's a 512e di=
sk, so the LBA's are still 512 bytes. And by the looks of it, your part=
itions are not aligned on those 4K physical sectors because the start v=
alue is 34s. In any recent fdisk or parted or gdisk, the start sector i=
s 2048 (1MiB), and each partition is aligned on 8-sector boundaries. So=
 your disks aren't properly partitioned, and you're getting a performan=
ce hit because of it.

What I'm not getting is why your md0, comprised of sda1 at 192717s, and=
 sd[bc]2 are 1929688s. What am I missing here? Because those values are=
n't at all the same. It's a 10x difference.

And then with md1, comprised of sda3 at 1461047490s, and sd[bc]4 are 39=
00193197s. A 2.66x difference. What is this? sda1 is 696GiB, while sd[b=
c]4 are 1.8TiB each? Ummm=85




Chris Murphy--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
