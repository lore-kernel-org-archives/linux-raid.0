From: Samuel Tardieu <tardieu@gmail.com>
Subject: Re: Debian/raid1/mdadm/devices not created at boot time
Date: Wed, 15 Dec 2004 13:54:01 +0100
Message-ID: <e626068b04121504545fbb93cf@mail.gmail.com>
References: <87r7lrnbpf.fsf@beeblebrox.rfc1149.net>
	 <41C031FD.1020809@chemie.uni-erlangen.de>
Reply-To: sam@rfc1149.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41C031FD.1020809@chemie.uni-erlangen.de>
Sender: linux-raid-owner@vger.kernel.org
To: schmidt@naa.net
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I just overflew the link you gave. There the partition type "fd"
> approach is used, which needs either compiled-in raid functionality o=
r
> raid as a module in the initial ramdisk (which is both at least fo Wo=
ody
> not the standard case; I built a bootable cd with a kernel with
> compiled-in raid support so that I could install directly onto a raid=
).

I have raid as a module in the initrd.
=20
> If you want the disks to be started by the mdadm call in that script,
> then the devices shouldn=B4t be assembled (or even tried to) by
> autodetection before. Try changing the type back to 83/82 or whatever=
 fs
> you use.

It won't change anything (I had 83 before I noticed I forgot this
part), but I understand what you're saying.

> What exactly does lead you to the thought that /dev/md0 and /dev/md1 =
do
> not exist? Are the actual entries in /dev issing? If so, why are they
> missing again after you made them wit MAKEDEV?

When I get the maintenance root prompt, I see that /dev/md0 and
/dev/md1 are missing from /dev. When I reboot, they have disappeared
again.

Although nothing appears in mnttab, I suspect my system may be using de=
vfs:

willow# df -k /dev
=46ilesystem           1K-blocks      Used Available Use% Mounted on
none                      5120      2944      2176  58% /dev

At boot time, no entries are created in this devfs for /dev/md0 and
/dev/md1. How can I create them? I thought loading the md module from
initrd would be enough but it looks like it isn't.

  Sam
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
