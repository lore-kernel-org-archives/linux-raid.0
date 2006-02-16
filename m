From: Krekna Mektek <krekna@gmail.com>
Subject: Re: RAID 5 inaccessible - continued
Date: Thu, 16 Feb 2006 17:42:49 +0100
Message-ID: <8b24c8b10602160842w5896390ap@mail.gmail.com>
References: <8b24c8b10602130708p3e2f9a1dh@mail.gmail.com>
	 <17393.42370.394254.464935@cse.unsw.edu.au>
	 <8b24c8b10602140235s7a4ef1fam@mail.gmail.com>
	 <43F1FFE1.2010107@h3c.com>
	 <8b24c8b10602140918s136b5075s@mail.gmail.com>
	 <43F2163A.6030302@dgreaves.com>
	 <8b24c8b10602151218i43886b75h@mail.gmail.com>
	 <43F3B119.1000800@dgreaves.com>
	 <8b24c8b10602160632h59111c54u@mail.gmail.com>
	 <8b24c8b10602160708j248c1752u@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8b24c8b10602160708j248c1752u@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Oh man!
I've never been so happy! Wow. My array is back, with the dd_rescue
which indeed came to the rescue. Since I've configured my LVM again,
the raid Array is accessible again.
Guys, many thanks for your help!

dd_rescue is indeed something different then a dd conv=noerror, though
I tried that one only once.

I need to buy another 500GB disk now to _FIRST_ backup the whole thing.

Krekna

2006/2/16, Krekna Mektek <krekna@gmail.com>:
> Whoops, sorry, I remember something about LVM... I've setup the system
> with LVM, I'm sure of that. In that case I can't mount /dev/md0 of
> course..
>
> I need to find out how this stuff works again..
>
> Krekna
>
> 2006/2/16, Krekna Mektek <krekna@gmail.com>:
> > Hi,
> >
> > Well, the dd_rescue did it's work, the array is now rebuilding, but
> > it's doing its thing very slowly.
> >
> > But now the following, while the array is rebuilding and with the good
> > image on my new disk (The FaultyRAIDDisk.img), I am trying to mount
> > /dev/md0 already, but it now says :
> >
> > root@1[~]# fdisk -l /dev/md0
> >
> > Disk /dev/md0: 800.1 GB, 800171491328 bytes
> > 2 heads, 4 sectors/track, 195354368 cylinders
> > Units = cylinders of 8 * 512 = 4096 bytes
> >
> > Disk /dev/md0 doesn't contain a valid partition table
> >
> > How can some individual disks which crash destroy my partition table!? Help!
> > Is there some way to get my data back from here??
> >
> >
> >
> > 2006/2/15, David Greaves <david@dgreaves.com>:
> > > man ddrescue:
> > >       -r, --max-retries=<n>
> > >               exit after given retries (-1=infinity) [0]
> > >
> > >
> > > So the -r10 basically tries to re-read each dodgy sector 10 times.
> > >
> > > Is it working?
> > >
> > > David
> > >
> > > Krekna Mektek wrote:
> > >
> > > >Hi,
> > > >
> > > >I am busy with it now, but what does the 10 mean in -r10 ? I
> > > >understand from the --help that one can use the -r option, but without
> > > >something behind it?
> > > >
> > > >Krekna
> > > >
> > > >2006/2/14, David Greaves <david@dgreaves.com>:
> > > >
> > > >
> > > >>Krekna Mektek wrote:
> > > >>
> > > >>
> > > >>
> > > >>>I want to rebuilt from the good one and the faulty one. That's why I
> > > >>>wanted to dd the disk to an image file, but it complains it has no
> > > >>>boot sector.
> > > >>>
> > > >>>
> > > >>>
> > > >>>
> > > >>>
> > > >>>>>>I did the folowing:
> > > >>>>>>
> > > >>>>>>dd conv=noerror if=dev/hdd1 of=/mnt/hdb1/Faulty-RAIDDisk.img
> > > >>>>>>losetup /dev/loop0 /mnt/hdb1/Faulty-RAIDDisk.img
> > > >>>>>>
> > > >>>>>>
> > > >>>>>>
> > > >>>>>>
> > > >>You could try doing this again using ddrescue (google if you need to
> > > >>install it):
> > > >>
> > > >>   ddrescue dev/hdd1 /mnt/hdb1/Faulty-RAIDDisk.img
> > > >>/mnt/hdb1/Faulty-RAIDDisk.log
> > > >>
> > > >>Then do it again using -r10 (to increase the retries on the faulty sectors)
> > > >>
> > > >>   ddrescue -r10 dev/hdd1 /mnt/hdb1/Faulty-RAIDDisk.img
> > > >>/mnt/hdb1/Faulty-RAIDDisk.log
> > > >>
> > > >>This will be much quicker because the log file contains details of the
> > > >>faulty sectors.
> > > >>With luck (mucho luck) you may not even lose data.
> > > >>
> > > >>David
> > > >>
> > > >>--
> > > >>
> > > >>
> > > >>
> > > >>
> > > >
> > > >
> > > >
> > >
> > >
> > > --
> > >
> > >
> >
>
