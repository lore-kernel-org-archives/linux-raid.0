From: Thomas -Balu- Walter <tw@itreff.de>
Subject: Re: Woody, initrd, raid1, boot
Date: Tue, 18 Jun 2002 19:19:09 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020618191909.D16630@itreff.de>
References: <20020617171511.B12084@itreff.de> <20020617185019.GB7974@unthought.net> <20020618112549.C14962@itreff.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020618112549.C14962@itreff.de>; from tw@itreff.de on Tue, Jun 18, 2002 at 11:25:49AM +0200
To: Thomas -Balu- Walter <tw@itreff.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

+ Thomas -Balu- Walter <tw@itreff.de> [18.06.02 11:25]:
[root=/dev/md1 not working]

Update - I am getting closer :)


One reason why it did not work here was that I had to create
the initrd in chroot (the mounted md-devices the original system got
copied to), this was it got /dev/md*, raidmodules and
other things needed to get raid running into the initrd.

I did not even have to change the partition type to autodetect, since
raidstart and such are available and get started in the created initrd.

(master = first ide controller, secondary = second IDE controller, no
master/slave hdd)

But now I am stuck and booting while simulating a broken secondary IDE
controller.

If I take off the master cable (powered off of course) I can boot into
the raid - and get the following messages:

md: could not lock [dev 03:03] sero-size? Marking faulty
md: could not import [dev 03:03], trying to mount raid nevertheless
md: autorun
...
former device [dev 03:03] is unavailable, removing from array
...

So it just ignores hda and boots into the remaining mirrored hdc.

But after rebuilding the raidset and removing the cable to the secondary
controller i get:

ide0 on 0x1f0-0x1f7, 0x 3f6 on IRQ14
md: could not lock [dev 16:03] sero-size? Marking faulty
md: could not import [dev 16:03]
md: autostart [dev 16:03] failed
/dev/md1: invalid argument
...
Kernel panic, because of missing root.

To fix I've tried to make the partitions raid-autodetect, created a new
initrd (because the old one still had "failed-disk" in it) and finally
added "
        disk=/dev/hda
        bios=0x80
        disk=/dev/hdc
        bios=0x80
" to lilo.conf.

with no luck - Why does it not "try to mount raid nevertheless" this
way?

     Balu
