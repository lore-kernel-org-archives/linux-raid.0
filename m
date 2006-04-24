From: gelma <dislessico@gmail.com>
Subject: Re: to be or not to be...
Date: Mon, 24 Apr 2006 16:34:24 +0200
Message-ID: <20060424143424.GB11616@gelma.net>
References: <20060423125836.GB6081@gelma.net> <17483.62839.125510.962278@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17483.62839.125510.962278@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Apr 24, 2006 at 07:45:27AM +1000, Neil Brown wrote:
> your array isn't degraded.  In this case it is (I think) very unusual
> and may not be the cause of your corruption, but you should avoid
> using the flag anyway.
thanks a lot for your time and your attention, Neil. Your support it's fast
and valuable, as usual.
well, I wasted lot of hours, after my post, trying to find the reason of
the corruptions I've got.
Well, the problem is funny... I mean... I can cp hundred of giga, in ext2,
without complain in dmesg/log, but if I umount the fs and run fsck I've got
a lot of incredible problem (duplicated blocks, and so on). with ext3 it
can works for hours, seldom I've got ext3-journal corruption.
anyway, after fsck, the checksum of files is always good, and lost+found
full of monster (some files need debugs to be eliminated (lsattr/chattr
failed working with them)).
after checking hardware, changing controllers, now I have changed even
hd cables. at home I will re-run all the tests.
I don't think it's a problem of raid software, of course.

> 
> 
> > 	b) dm-encrypt /dev/md1
> > 	
> > 	c) create fs with:
> > 	   mkfs.ext3 -O dir_index -L 'tritone' -i 256000 /dev/mapper/raidone
> > 	
> > 	d) export it via nfs (mounting /dev/mapper/raidone as ext2)
>                                                               ^^^^
> 
> Why not ext3?
Well, because I had to clone 1,5 TB of data, spread over a lot of disks,
in one shot, and to avoid journal seeks I've done so.

> 
> > 
> > 	e) start to cp-ing files
> > 
> > 	f) after 1 TB of written data, with no problem/warning, one of the
> > 	not-in-raid-array HD freeze
> 
> This could signal a bad controller.  If it does, then you cannot trust
> any drives.

well, it was my fault... I mean, I've got a Dell server, without enough
internal room for all the disks. The source disk was out of the server, and
I move it... it wasn't happy...
anyway, I'm using HPT ATA PCI controller (well tested, I mean, I used the ones
in the server since 2000). btw, 5 disks Maxtor, 500Giga each one.

The problem isn't MD related, but it's the first time I've got so much
problems finding the culprit of data corruption. Usually it's RAM/CPU
fault, few times I've got problem with controller... but this time I'm
going slightly mad... also, why meta and not data (file are checked with a
stupid python script I wrote)... is there an ATA command triggered only
with metadata? uhm... maybe mounting the array in synchronous mode I could
gather more info, uhm...

at the end, Neil, thanks a lot for your work. If you'll be in Italy, some
day, I'll be happy to be your host.

ciao,
gelma
