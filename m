From: "Jeremy Leigh" <jeremy.leigh@gmail.com>
Subject: RE: Problem Growing Raid 5 Array - Help Needed!
Date: Fri, 6 Jun 2008 22:39:17 +1000
Message-ID: <48493000.14098e0a.337f.ffffa26f@mx.google.com>
References: <48457667.9030103@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <48457667.9030103@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'David Greaves' <david@dgreaves.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi David, you are right, thankyou!
I have now:

[root@FileServer ~]#pvresize /dev/md0

And then from system-config-lvm I have selected 'Use Remaining' space on the
logical volume.

All done. Good thing LVM keeps a lock on the device ;) 

No doubt someone thought there would be users like me :D


-----Original Message-----
From: David Greaves [mailto:david@dgreaves.com] 
Sent: Wednesday, 4 June 2008 2:51 AM
To: Jeremy Leigh
Cc: linux-raid@vger.kernel.org
Subject: Re: Problem Growing Raid 5 Array - Help Needed!

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


> Finally, I can give you output of mdadm --detail, but to be honest, I
don't
> know what else I can do... This is really frustrating.
It would be nice if something told you what was holding the lock.
I occasionally forget on the server that uses lvm.

> These commands are being run from root.
>
> [root@FileServer ~]# fsck /dev/md0
Yeah - that's a bad idea!!!
your filesystem lives on /dev/LVMRAID/LV0
  fsck /dev/LVMRAID/LV0

If you had been really unlucky, fsck could have found a superblock and
started
scribbling all over your filesystem with potentially devastating results!
Always run filesystem tools on the device holding the filesystem, rather
than
some random component ;)

and similartly
> [root@FileServer ~]# resize2fs /dev/md0
resize2fs /dev/LVMRAID/LV0

HTH

David

