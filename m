From: David Greaves <david@dgreaves.com>
Subject: Re: Problem Growing Raid 5 Array - Help Needed!
Date: Tue, 03 Jun 2008 17:50:47 +0100
Message-ID: <48457667.9030103@dgreaves.com>
References: <48455d39.16078e0a.20d2.14eb@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <48455d39.16078e0a.20d2.14eb@mx.google.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jeremy Leigh <jeremy.leigh@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jeremy Leigh wrote:
> Hi David,
> Mount works fine for the LVM volume sitting on /dev/md0
> [root@FileServer ~]# mount /dev/LVMRAID/LV0 /home

Ah...

lvm is holding /dev/md0 open.

lvm is layered on top of, and uses, md - just like md uses your hard disks.

Try:
  /etc/init.d/lvm2 stop

That should do it.


> Finally, I can give you output of mdadm --detail, but to be honest, I don't
> know what else I can do... This is really frustrating.
It would be nice if something told you what was holding the lock.
I occasionally forget on the server that uses lvm.

> These commands are being run from root.
>
> [root@FileServer ~]# fsck /dev/md0
Yeah - that's a bad idea!!!
your filesystem lives on /dev/LVMRAID/LV0
  fsck /dev/LVMRAID/LV0

If you had been really unlucky, fsck could have found a superblock and started
scribbling all over your filesystem with potentially devastating results!
Always run filesystem tools on the device holding the filesystem, rather than
some random component ;)

and similartly
> [root@FileServer ~]# resize2fs /dev/md0
resize2fs /dev/LVMRAID/LV0

HTH

David
