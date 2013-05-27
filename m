From: Vincent Pelletier <plr.vincent@gmail.com>
Subject: Re: Spinning down idle disks?
Date: Mon, 27 May 2013 08:46:17 +0200
Message-ID: <201305270846.18198.plr.vincent@gmail.com>
References: <20231564.0.1369565394879.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20231564.0.1369565394879.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Le dimanche 26 mai 2013 12:49:54, Roy Sigurd Karlsbakk a =C3=A9crit :
> Is it possible somehow to have linux spin down idle disks in an MD ra=
id as
> to use MD for a MAID (massive array of idle disks)? I tried to monito=
r an
> idle raid with blktrace, and it seems the array (and its members) is
> accessed every two seconds for some reason. The array used with for t=
he
> testing is a idle, degraded raid-5.

=46WIW, there is a small daemon to spin disks down in a - to me - cleve=
r way:=20
only reads from device reset spindown timeout. Writes are kept in cache=
 until=20
an explicit flush happens.

http://noflushd.sourceforge.net/

This allows skipping superblock refreshes (FS- and MD-level).
It has a large drawback when using it for MD (and other composite devic=
es): it=20
doesn't look for slave devices, so if you tell it to control sda and sd=
b and=20
you have md0 on top of both, it will eventually spin down sda and sdb, =
only to=20
manually flush md0, spinning both up again.

I've implemented a quick-hack workaround for this:

https://github.com/vpelletier/pynoflushd

Both implementation have the drawback of increasing the frequency of wr=
ites to=20
the actual disk: as the daemon take over dirty_writeback_centisecs's jo=
b using=20
userspace-available flush methods (mine using BLKFLSBUF ioctl, the orig=
inal=20
using fsync on block device), something gets flushed which is usually n=
ot (I=20
wandered a bit in kernel code without finding how writeback code handle=
s this=20
timeout).

I think it would be nice to have an equivalent of dirty_writeback_centi=
secs at=20
device granularity, so that one doesn't have to delegate flushing to a=20
userspace daemon.

Regards,
--=20
Vincent Pelletier
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
