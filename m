From: Krekna Mektek <krekna@gmail.com>
Subject: Re: RAID 5 inaccessible - continued
Date: Wed, 15 Feb 2006 16:09:57 +0100
Message-ID: <8b24c8b10602150709o74b0bd4cj@mail.gmail.com>
References: <8b24c8b10602130708p3e2f9a1dh@mail.gmail.com>
	 <17393.42370.394254.464935@cse.unsw.edu.au>
	 <8b24c8b10602140235s7a4ef1fam@mail.gmail.com>
	 <200602151059.28687.suse-ml@onlinehome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200602151059.28687.suse-ml@onlinehome.de>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Burkhard Carstens <suse-ml@onlinehome.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Er,,, no :)
This was on another machine, luckily, I am not that stupid.
I was using /dev/hdb in that one, sorry to be a bit unclear about that.
Also, I usually sit on my hands for a sec when I do such powerfull commands.

Good, so I make some chances then with dd_rescue, I'll let you know
then, I have to try this tonight.

Krekna


2006/2/15, Burkhard Carstens <suse-ml@onlinehome.de>:
> Am Dienstag, 14. Februar 2006 11:35 schrieb Krekna Mektek:
> [...]
> > Actually, /dev/hdd1 partition is 390708801 blocks, the disk itself is
> > a Hitachi 400GB disk.
> > So this is 390708801 blocks of 1024 bytes. This is according to my
> > calculation 400085812224 bytes.
> > The Faulty-RAIDDisk.img is according to my ls -l 400085771264 bytes.
> >
> > So it looks like they are quite the same, and the difference between
> > the two is 40960 bytes. These are 40 blocks, so 36 are missing?
> >
> > The dd actually succeeded, and did finish the job in about one day.
> > The badblocks were found after about the first 7 Gigs.
> >
> > Is there no way like the conv=noerror for mdadm, to just continue?
> > Can I restore the superblock on the .img file somehow?
> > Is it probably save to --zero-superblock all the three disks and that
> > the RAID array will create two new superblocks (Leaving the spare
> > out, because its probably out of date).
> >
> > I can do the dd again, but I think it will do the same thing, because
> > it finished 'succesfully'.
> > The superblock is at the end of the disk I read, about the last
> > 64-128K or something.
>
> My experience is that dd conv=noerror doesn't do the job correctly!! It
> still won't write a block that it cannot read.
> Please use "dd_rescue -A /dev/hdd1 /mnt/hdb1/Faulty-RAIDDisk.img"
> instead. See "dd_rescue --help".
>
> > ADEVICE /dev/hdb1 /dev/hdc1 /dev/loop0
> > ARRAY /dev/md0 devices=/dev/hdb1,/dev/hdc1,/dev/loop0
>
> another thing: /mnt/hdb1/ is not the same hdb1, you are using in the
> raid5, is it?
>
> It might be a bad idea to mount /dev/hdb1, write to it,
> and afterwards assemble the array with hdb1 being part of it ... Extra
> bad, if loop0 points to a file on hdb1 ?? However, if you did dd to a
> file on the partition, that should be part of the degraded raid5 array,
> I guess your data is already gone ...
>
> Good luck
>  Burkhard
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
