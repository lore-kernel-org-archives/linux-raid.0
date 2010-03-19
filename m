From: Joachim Otahal <Jou@gmx.net>
Subject: Re: BUG:write data to degrade raid5
Date: Fri, 19 Mar 2010 19:37:21 +0100
Message-ID: <4BA3C461.5060209@gmx.net>
References: <de04351e1003190329l2f33447bhe37b963bd4b48c70@mail.gmail.com> 	<4BA3C07A.8030204@gmx.net> <73e903671003191123h1b7e1196v336265842f1b29e5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <73e903671003191123h1b7e1196v336265842f1b29e5@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>
Cc: jin zhencheng <zhenchengjin@gmail.com>, neilb@suse.de, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Kristleifur Da=F0ason schrieb:
> On Fri, Mar 19, 2010 at 6:20 PM, Joachim Otahal <Jou@gmx.net=20
> <mailto:Jou@gmx.net>> wrote:
>
>     jin zhencheng schrieb:
>
>         hi;
>
>         i use kernel is 2.6.26.2
>
>         what i do as follow:
>
>         1, I create a raid5:
>         mdadm -C /dev/md5 -l 5 -n 4 /dev/sda /dev/sdb /dev/sdc  /dev/=
sdd
>         --metadata=3D1.0 --assume-clean
>
>         2, dd if=3D/dev/zero of=3D/dev/md5 bs=3D1M&
>
>         write data to this raid5
>
>         3, mdadm --manage /dev/md5 -f /dev/sda
>
>         4 mdadm --manage  /dev/md5 -f /dev/sdb
>
>         if i faild 2 disks ,then the OS kernel display OOP error and
>         kernel down
>
>         do somebody know why ?
>
>         Is MD/RAID5 bug ?
>
>
>     RAID5 can only tolerate ONE drive to fail of ALL members. If you
>     want to be able to fail two drives you will have to use RAID6 or
>     RAID5 with one hot-spare (and give it time to rebuild before
>     failing the second drive).
>     PLEASE read the documentation on raid levels, like on wikipedia.
>
>
> That is true,
>
> but should we get a kernel oops and crash if two RAID5 drives are=20
> failed? (THAT part looks like a bug!)
>
> Jin, can you try a newer kernel, and a newer mdadm?
>
> -- Kristleifur
You are probably right.
My kernel version is "Debian 2.6.26-21lenny4", and I had no oopses=20
during my hot-plug testing one the hardware I use md on. I think it may=
=20
be the driver for his chips.

Jin:

Did you really use the whole drives for testing or loopback files or=20
partitions on the drives? I never did my hot-plug testings with whole=20
drives being in an array, only with partitions.

Joachim Otahal
