From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: How to recover this RAID5?
Date: Mon, 9 Jun 2003 07:38:18 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16099.44234.715573.577139@gargle.gargle.HOWL>
References: <5.1.1.6.2.20030608061637.03bb34e0@mail.harddata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Maurice Hilarius on Sunday June 8
To: Maurice Hilarius <maurice@harddata.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday June 8, maurice@harddata.com wrote:
> Hi there.
> 
> I am a bit stumped on this one, and hope somebody can suggest a way to 
> recover it.
> The user has no backup, and hopes to recover data from this array.
> 
> Assistance would be deeply appreciated.

Based on "Events", sda1, sdc1, sdd1 are most recent. sdb1 is much
older.
So assuming they were in order, I would:
  mdadm -C /dev/md0 -l 5 -n 4 /dev/sda1 missing /dev/sdc1 /dev/sdd1

and then see what the filesystem looks like.
Doing this will not corrupt any data except the superblocks (which are
already close to useless), so if it doesn't look right, you can stop
the array and assemble difference devices in a difference order.

> 
> System has 4 IDE disks on a 3Ware 4 port.
> RAID5.
> 
> One of the disks  apparently went offline without the user noticing.
> Now the array is in a read-only state.
> Probable cause is that these are WD 1800GB drives, and they have not had 
> the WD patch applied, so probably drives started going to "sleep".
> 
> I provide some (hopefully) useful information:
> 
> In mdadm --examine I see that somehow the devices 1,2,3, have now been 
> renamed to devices 4,5,6
> 
> And that 2 devices have become designated as spares.
> 
> This really puzzles me.

The simplest explanation would be that someone did:
   mdadm -r /dev/md0 /dev/sda1 ; mdadm -a /dev/md0 /dev/sda1
or something like that.

Good luck,
NeilBrown
