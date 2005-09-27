From: Neil Brown <neilb@suse.de>
Subject: Re: did I just destroy my data?
Date: Tue, 27 Sep 2005 11:51:36 +0200
Message-ID: <17209.5672.702546.529979@cse.unsw.edu.au>
References: <7f55de7205092700022e1650aa@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Sebastian Kuzminsky on Tuesday September 27
Sender: linux-raid-owner@vger.kernel.org
To: Sebastian Kuzminsky <seb.kuzminsky@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday September 27, seb.kuzminsky@gmail.com wrote:
> 
> Please, cluebat me.  How do I unhork my raid now?  Is it even possible?
> 

You keep swapping between referring to the devices by number (1,2,3,4)
and named (sda,sdb) and I get confused....

Your best bet it to take the three drives that are mostly like to be
mostly correct, which also certainly excludes the one that resync was
happening on, and recreate the array.
e.g.
   mdadm -C /dev/md0 -l5 -n4 -c ?? /dev/sda /dev/sdb missing /dev/sdd

but make sure you specify the chunksize as a number, and make sure you
get the device order and positioning right.

Then mount the filesystem read-only.
Then - when you have your new drives - copy the data off.

Don't trigger a resync.  Don't do a fsck.  These are likely to hit a
bad block and hurt you.

Good luck.

NeilBrown
