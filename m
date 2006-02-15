From: Krekna Mektek <krekna@gmail.com>
Subject: Re: RAID 5 inaccessible - continued
Date: Wed, 15 Feb 2006 10:36:45 +0100
Message-ID: <8b24c8b10602150136r73ac887eh@mail.gmail.com>
References: <8b24c8b10602130708p3e2f9a1dh@mail.gmail.com>
	 <8b24c8b10602140035t5ca2e41cv@mail.gmail.com>
	 <17393.42370.394254.464935@cse.unsw.edu.au>
	 <8b24c8b10602140235s7a4ef1fam@mail.gmail.com>
	 <43F1FFE1.2010107@h3c.com>
	 <8b24c8b10602140918s136b5075s@mail.gmail.com>
	 <43F2163A.6030302@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43F2163A.6030302@dgreaves.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: Mike Hardy <mhardy@h3c.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi David,
Thank you.
I will give ddrescue a shot then. But what is it different than a dd
with the noerror conversion?

Krekna

2006/2/14, David Greaves <david@dgreaves.com>:
> Krekna Mektek wrote:
>
> >I want to rebuilt from the good one and the faulty one. That's why I
> >wanted to dd the disk to an image file, but it complains it has no
> >boot sector.
> >
> >
> >
> >>>>I did the folowing:
> >>>>
> >>>>dd conv=noerror if=dev/hdd1 of=/mnt/hdb1/Faulty-RAIDDisk.img
> >>>>losetup /dev/loop0 /mnt/hdb1/Faulty-RAIDDisk.img
> >>>>
> >>>>
> You could try doing this again using ddrescue (google if you need to
> install it):
>
>    ddrescue dev/hdd1 /mnt/hdb1/Faulty-RAIDDisk.img  /mnt/hdb1/Faulty-RAIDDisk.log
>
> Then do it again using -r10 (to increase the retries on the faulty sectors)
>
>    ddrescue -r10 dev/hdd1 /mnt/hdb1/Faulty-RAIDDisk.img  /mnt/hdb1/Faulty-RAIDDisk.log
>
> This will be much quicker because the log file contains details of the
> faulty sectors.
> With luck (mucho luck) you may not even lose data.
>
> David
>
> --
>
>
