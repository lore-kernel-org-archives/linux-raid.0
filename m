From: Eurijk <eurijk@zefga.net>
Subject: Re: Raid 5 on 2.5.50/2.5.51, dirty array, kernel panic
Date: Fri, 13 Dec 2002 12:22:39 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20021213122239.4241c4df.eurijk@zefga.net>
References: <20021210233443.48053fe3.eurijk@zefga.net>
	<3DF7847D.1050606@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3DF7847D.1050606@mvista.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>I set up an IDE raid array as such:
>  /dev/md1 hda1 hdc1 hde1 hdg1 RAID 1 (ext2)
>  /dev/md0 hda2 hdc2 hde2 hdg2 RAID 5 (reiserfs)
>... and physically remove a drive (hda) ...
> <0>Kernel panic: Attempted to kill init!

^^^ The above also applies if you put hda back in after
it has been marked bad by it not being there after the
goto abort (see below) has been removed.

This appears to be stemming from a 3.5.33/34? patch that included:

   if (mddev->degraded == 1 &&
	    !(mddev->state & (1<<MD_SB_CLEAN))) {
      printk(KERN_ERR "raid5: cannot start dirty degraded array for md%d\n", mdidx(mddev));
      goto abort;
   }

If you remove the goto abort; there this fixes the problem.

I imagine this needs to check to see if only one device is bad,
and if so, continue.

I would have expected an "unable to mount root" error rather then a kernel
panic so there must be something wrong (probably not very critical) elsewhere.

Can someone more familiar with linux-2.5.51/drivers/md/raid5.c and kernel
modules take a look at this please? Thanks!

-eurijk!
