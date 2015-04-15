From: Azat Khuzhin <a3at.mail@gmail.com>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at
 sysfs_do_create_link_sd (after mdadm)
Date: Wed, 15 Apr 2015 11:47:19 +0300
Message-ID: <20150415084719.GM25394@azat>
References: <20150414171537.GH25394@azat>
 <552DD097.9010504@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <552DD097.9010504@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <GQJiang@suse.com>
Cc: "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>, neilb@suse.de
List-Id: linux-raid.ids

On Wed, Apr 15, 2015 at 10:44:39AM +0800, Guoqing Jiang wrote:
> Azat Khuzhin wrote:
> > $ git describe
> > v4.0-2620-gb79013b
> >
> > During setting up partitions with mdadm, mdadm hung, after attaching to mdadm with strace I got next:
> >
> > # pgrep mdadm | xargs strace -fp
> > Process 27389 attached - interrupt to quit
> > unlink("/dev/.tmp.md.27389:9:127")      = 0
> > mknod("/tmp/.tmp.md.27389:9:127", S_IFBLK|0600, makedev(9, 127)) = 0
> > open("/tmp/.tmp.md.27389:9:127", O_RDWR|O_EXCL|O_DIRECT) <-- *hung*
> >
> > After, I looked into dmesg, and found this:
> > [ 9627.630018] ------------[ cut here ]------------
> > [ 9627.630029] WARNING: CPU: 18 PID: 3330 at fs/sysfs/dir.c:31 sysfs_warn_dup+0x5a/0x70()
> > [ 9627.630032] sysfs: cannot create duplicate filename '/devices/virtual/bdi/9:127'
> >   
> sysfs complains about duplicate filename, maybe you tried to create the
> array with same node.

Yes, my steps was close to this:
$ mdadm --create /dev/md/foo --raid-devices=2 /dev/sda /dev/sdb
$ mdadm --stop --scan
$ mdadm --create /dev/md/foo --raid-devices=2 /dev/sda /dev/sdb

But it is not always reproduces.

Anyway the most important is not WARNING but BUG (also after that BUG
you can't umount all file systems normally -- i.e. on reboot).
