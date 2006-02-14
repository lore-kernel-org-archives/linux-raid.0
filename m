From: Krekna Mektek <krekna@gmail.com>
Subject: Re: RAID 5 inaccessible - continued
Date: Tue, 14 Feb 2006 11:35:28 +0100
Message-ID: <8b24c8b10602140235s7a4ef1fam@mail.gmail.com>
References: <8b24c8b10602130708p3e2f9a1dh@mail.gmail.com>
	 <8b24c8b10602140035t5ca2e41cv@mail.gmail.com>
	 <17393.42370.394254.464935@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17393.42370.394254.464935@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2006/2/14, Neil Brown <neilb@suse.de>:
> On Tuesday February 14, krekna@gmail.com wrote:
> > Krekna is crying out loud in the empty wilderness....
> > No one there to help me?
>
> Nope :-)
>
> > > I did the folowing:
> > >
> > > dd conv=noerror if=dev/hdd1 of=/mnt/hdb1/Faulty-RAIDDisk.img
> > > losetup /dev/loop0 /mnt/hdb1/Faulty-RAIDDisk.img
> ..
> > >
> > > But it did not work out (yet).
> > >
> > > madm -E /dev/loop0
> > > mdadm: No super block found on /dev/loop0 (Expected magic a92b4efc,
> > > got 00000000)
> ...
> > >
> > > - can I restore the superblock from the hdd1 disk (which is still alive)
> > >
>
> If mdadm -E /dev/hdd1 shows a valid superblock, and mdadm -E
> /dev/loop0 doesn't, then your 'dd' wasn't very successful.

Hi,

Actually, /dev/hdd1 partition is 390708801 blocks, the disk itself is
a Hitachi 400GB disk.
So this is 390708801 blocks of 1024 bytes. This is according to my
calculation 400085812224 bytes.
The Faulty-RAIDDisk.img is according to my ls -l 400085771264 bytes.

So it looks like they are quite the same, and the difference between
the two is 40960 bytes. These are 40 blocks, so 36 are missing?

The dd actually succeeded, and did finish the job in about one day.
The badblocks were found after about the first 7 Gigs.

Is there no way like the conv=noerror for mdadm, to just continue?
Can I restore the superblock on the .img file somehow?
Is it probably save to --zero-superblock all the three disks and that
the RAID array will create two new superblocks (Leaving the spare out,
because its probably out of date).

I can do the dd again, but I think it will do the same thing, because
it finished 'succesfully'.
The superblock is at the end of the disk I read, about the last
64-128K or something.

Krekna


>
> What is the size of /mnt/hdb1/Faulty-RAIDDisk.img ?? What is the size
> of /dev/hdd1?
>
> BTW, you don't need to edit mdadm.conf to try things out.  Just
>
>   mdadm -A /dev/md0 /dev/hdb1 /dev/hdc1 /dev/loop0
>
> NeilBrown
>
