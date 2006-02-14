From: Neil Brown <neilb@suse.de>
Subject: Re: RAID 5 inaccessible - continued
Date: Tue, 14 Feb 2006 20:40:18 +1100
Message-ID: <17393.42370.394254.464935@cse.unsw.edu.au>
References: <8b24c8b10602130708p3e2f9a1dh@mail.gmail.com>
	<8b24c8b10602140035t5ca2e41cv@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Krekna Mektek on Tuesday February 14
Sender: linux-raid-owner@vger.kernel.org
To: Krekna Mektek <krekna@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday February 14, krekna@gmail.com wrote:
> Krekna is crying out loud in the empty wilderness....
> No one there to help me?

Nope :-)

> > I did the folowing:
> >
> > dd conv=noerror if=dev/hdd1 of=/mnt/hdb1/Faulty-RAIDDisk.img
> > losetup /dev/loop0 /mnt/hdb1/Faulty-RAIDDisk.img
..
> >
> > But it did not work out (yet).
> >
> > madm -E /dev/loop0
> > mdadm: No super block found on /dev/loop0 (Expected magic a92b4efc,
> > got 00000000)
...
> >
> > - can I restore the superblock from the hdd1 disk (which is still alive)
> >

If mdadm -E /dev/hdd1 shows a valid superblock, and mdadm -E
/dev/loop0 doesn't, then your 'dd' wasn't very successful.

What is the size of /mnt/hdb1/Faulty-RAIDDisk.img ?? What is the size
of /dev/hdd1?

BTW, you don't need to edit mdadm.conf to try things out.  Just

  mdadm -A /dev/md0 /dev/hdb1 /dev/hdc1 /dev/loop0

NeilBrown
