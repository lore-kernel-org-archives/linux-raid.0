From: Iain <iain@minihub.org>
Subject: Re: URGENT lilo problems
Date: Wed, 24 Apr 2002 20:13:42 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020424101934Z311424-22651+15811@vger.kernel.org>
References: <20020424090459Z310953-22651+15685@vger.kernel.org> <20020424115234.A30278@unthought.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20020424115234.A30278@unthought.net>
To: Jakob =?iso-8859-1?q?=D8stergaard?= <jakob@unthought.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 24 Apr 2002 07:52, Jakob =D8stergaard wrote:

> > The map file is in /boot which is on /dev/md0 the partition I want =
to
> > boot from.
>
> Can you send  /proc/mdstat and /etc/lilo.conf ?

Ok the problem seems to have changed now. After reinstalling lilo and t=
he=20
kernel I was able to use lilo. However, only the first hard drive will =
=20
boot. If I disable the first hard drive and try and boot off the second=
 I get

L 40

When I reinstalled LILO it installed a MBR on /dev/hda so now when lilo=
 boots=20
it shows

MBR

LILO 22.2

I'm not sure if this is right.

Here is my lilo.conf

lba32
boot=3D/dev/md0
root=3D/dev/md0
install=3D/boot/boot.b
delay=3D20
map=3D/boot/map
vga=3Dnormal
image=3D/vmlinuz
        label=3DLinux
        read-only

And cat /proc/mdstat

candela:~# cat /proc/mdstat
Personalities : [raid1]
read_ahead 1024 sectors
md0 : active raid1 hdc1[1] hda1[0]
      192640 blocks [2/2] [UU]

md1 : active raid1 hdc6[1] hda6[0]
      2931712 blocks [2/2] [UU]

md2 : active raid1 hdc7[1] hda7[0]
      19534912 blocks [2/2] [UU]

md3 : active raid1 hdc8[1] hda8[0]
      15430336 blocks [2/2] [UU]

unused devices: <none>

thanks, Iain.

--=20
public key available at http://www.minihub.org/~iain/iain.asc
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
