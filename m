From: Krekna Mektek <krekna@gmail.com>
Subject: Re: RAID 5 inaccessible - continued
Date: Tue, 14 Feb 2006 18:18:02 +0100
Message-ID: <8b24c8b10602140918s136b5075s@mail.gmail.com>
References: <8b24c8b10602130708p3e2f9a1dh@mail.gmail.com>
	 <8b24c8b10602140035t5ca2e41cv@mail.gmail.com>
	 <17393.42370.394254.464935@cse.unsw.edu.au>
	 <8b24c8b10602140235s7a4ef1fam@mail.gmail.com>
	 <43F1FFE1.2010107@h3c.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43F1FFE1.2010107@h3c.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Mike Hardy <mhardy@h3c.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2006/2/14, Mike Hardy <mhardy@h3c.com>:
>
>
> Krekna Mektek wrote:
>
> > The dd actually succeeded, and did finish the job in about one day.
> > The badblocks were found after about the first 7 Gigs.
>
> Is this a 3-disk raid5 array? With two healthy disks and one bad disk?

Hi Mike!
It is a 3 disk array, that is one spare (which was set as spare by
Linux, previously marked as faulty I guess. This disk is probably out
of date, because I don't know when this did happen, and I don't have
the logs anymore).
One disk is okay, and the faulty is probably also okay, except for the
76 bad sectors.
I want to rebuilt from the good one and the faulty one. That's why I
wanted to dd the disk to an image file, but it complains it has no
boot sector.

In this case, I actually *can* try the 2.6.15+ kernel then? Because
the rebuilt *IS* working, except for the fact that it stops at 1,7%,
which happens to be at the bad block area indeed.

So, there actually IS a possibility now I was requesting for: mdadm to
skip over the bad blocks area? That mean I can try again, but now with
2.6.15?

And if not. I still don't understand why this did not work:

<quote>
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
</quote>


Thanks for your help!

Krekna
>
> If so, then what you really want is a new kernel (2.6.15+? 2.6.14+?)
> that has raid5 read-error-handling code in it. Neil just coded that up.
>
> If it's missing a disk and has a disk with bad sectors, then you've
> already lost data, but you could use a combination of smart tests and dd
> to zero out those specific sectors (and only those sectors...) then sync
> a new disk up with the array...
>
> -Mike
>
