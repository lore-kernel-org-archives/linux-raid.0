From: Sujit K M <sjt.kar@gmail.com>
Subject: Re: Help - Urgent!!!
Date: Fri, 13 Nov 2009 15:14:19 +0530
Message-ID: <921ca19c0911130144t57be3affk9f6e1fd9b8ca0b2a@mail.gmail.com>
References: <200911122253.01626.lrhorer@satx.rr.com>
	 <19196.60011.858158.550391@notabene.brown>
	 <19196.60094.69339.36550@notabene.brown>
	 <200911122314.13426.lrhorer@satx.rr.com>
	 <19196.63471.532066.743149@notabene.brown>
	 <20091113100638.02c174fe@atak.bl.pg.gda.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091113100638.02c174fe@atak.bl.pg.gda.pl>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

This seems to be an reported bug that neil seems to be following. Not
much helpfull
because(Kindly Read the entire mail chain) responder had not updated
on the mail.
But seems to have the solution/seems to be closed.

http://lists.alioth.debian.org/pipermail/pkg-mdadm-devel/2009-June/0029=
45.html

Thanks,
Sujit


On Fri, Nov 13, 2009 at 2:36 PM, Janek Kozicki <janek_listy@wp.pl> wrot=
e:
> Neil Brown said: =A0 =A0 (by the date of Fri, 13 Nov 2009 17:08:47 +1=
100)
>
>> Where do those "'"s come from???
>
> I also have those "'" on one (out of 3) md's. Maybe it's debian
> specific? Or only debian etch specific? Or only debian /dev/md0
> specific.... It's only on /dev/md0, like this:
>
> backup:~# mdadm -D /dev/md0
> /dev/md0:
> =A0 =A0 =A0 =A0Version : 01.00.03
> =A0Creation Time : Wed Oct 31 09:13:41 2007
> =A0 =A0 Raid Level : raid1
> =A0 =A0 Array Size : 979924 (957.12 MiB 1003.44 MB)
> =A0 =A0Device Size : 979924 (957.12 MiB 1003.44 MB)
> =A0 Raid Devices : 5
> =A0Total Devices : 5
> Preferred Minor : 0
> =A0 =A0Persistence : Superblock is persistent
>
> =A0Intent Bitmap : Internal
>
> =A0 =A0Update Time : Fri Nov 13 10:04:02 2009
> =A0 =A0 =A0 =A0 =A0State : active
> =A0Active Devices : 5
> Working Devices : 5
> =A0Failed Devices : 0
> =A0Spare Devices : 0
>
> =A0 =A0 =A0 =A0 =A0 Name : 'backup':0
> =A0 =A0 =A0 =A0 =A0 UUID : 75b0f878:79539d6c:eef22092:f47a6e6f
> =A0 =A0 =A0 =A0 Events : 482808
>
> =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
> =A0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 =A01 =A0 =A0 =A0 =A00 =A0 =A0=
 =A0active sync =A0 /dev/sda1
> =A0 =A0 =A0 5 =A0 =A0 =A022 =A0 =A0 =A0 =A01 =A0 =A0 =A0 =A01 =A0 =A0=
 =A0active sync =A0 /dev/hdc1
> =A0 =A0 =A0 2 =A0 =A0 =A0 3 =A0 =A0 =A0 =A01 =A0 =A0 =A0 =A02 =A0 =A0=
 =A0active sync =A0 /dev/hda1
> =A0 =A0 =A0 4 =A0 =A0 =A0 8 =A0 =A0 =A0 33 =A0 =A0 =A0 =A03 =A0 =A0 =A0=
active sync =A0 /dev/sdc1
> =A0 =A0 =A0 6 =A0 =A0 =A0 8 =A0 =A0 =A0 17 =A0 =A0 =A0 =A04 =A0 =A0 =A0=
active sync =A0 /dev/sdb1
>
>
>>
>> What exactly is listed in mdadm.conf for /dev/md0??
>
> nothing.
>
> backup:~# cat /etc/mdadm/mdadm.conf
> # mdadm.conf
> #
> # Please refer to mdadm.conf(5) for information about this file.
> #
>
> # by default, scan all partitions (/proc/partitions) for MD superbloc=
ks.
> # alternatively, specify devices to scan, using wildcards if desired.
> DEVICE partitions
>
> # auto-create devices with Debian standard permissions
> CREATE owner=3Droot group=3Ddisk mode=3D0660 auto=3Dyes
>
> # automatically tag new arrays as belonging to the local system
> HOMEHOST <system>
>
> # instruct the monitoring daemon where to send mail alerts
> MAILADDR root
>
> # definitions of existing MD arrays
>
> # This file was auto-generated on Tue, 23 Oct 2007 22:18:08 +0200
> # by mkconf $Id: mkconf 261 2006-11-09 13:32:35Z madduck $
>
>
>
> --
> Janek Kozicki =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 |
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
-- Sujit K M

blog(http://kmsujit.blogspot.com/)
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
