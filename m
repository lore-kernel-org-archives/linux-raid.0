From: Neil Brown <neilb@suse.de>
Subject: Re: raid5 recovery fails
Date: Tue, 15 Nov 2005 17:40:41 +1100
Message-ID: <17273.33513.865133.307367@cse.unsw.edu.au>
References: <5d96567b0511141127v63377f0and41f998230a38dd7@mail.gmail.com>
	<20051114205251.GA4040@jose.lug.udel.edu>
	<5d96567b0511142229u2f0d131j14bd2c4912f1b3a7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Raz Ben-Jehuda(caro) on Tuesday November 15
Sender: linux-raid-owner@vger.kernel.org
To: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Cc: Ross Vandegrift <ross@jose.lug.udel.edu>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tuesday November 15, raziebe@gmail.com wrote:
> > mdadm --add /dev/md0 /dev/sda2..
> yes , i am using raidstart for this.  it should be the same.

No, it shouldn't.
raidstart is broken by design and cannot work reliable.  It is one of
the main reasons that I wrote mdadm.

raidstart trusts the device numbers (major and minor) that are stored
in the superblock.  If you pull a drive out these numbers change and
raidstart fails miserably.

# rm -f /usr/sbin/raidstart

is probably a good idea.

> I am handling a big cluster with supermicro machines,each machine has its
> own 4 sata disks.I am using 2.6.6 kernel.
> 
> Did you ever pulled out a disk from raid5 while the machine was
> running ?

Yes, several times.


NeilBrown
