From: "NeilBrown" <neilb@suse.de>
Subject: Re: reshape raid5 to raid6
Date: Wed, 24 Jun 2009 21:20:41 +1000 (EST)
Message-ID: <972c997a386db1106868b3dc6b29ee21.squirrel@neil.brown.name>
References: <20090624102729.GY2828@rlogin.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090624102729.GY2828@rlogin.dk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, June 24, 2009 8:27 pm, Michael Ole Olsen wrote:
> Is it possible to reshape my /dev/md0 raid5 into raid6?

If you are are using Linux 2.6.30, then you can

  echo raid6 > /sys/block/md0/md/level

and it will instantly be sort-of-raid6.
It is exactly like raid6 except that the Q blocks are all one
the one drive, and drive that previously didn't exist.
If you have a spare, it will start building the Q blocks
on that drive and when it finishes you will have true raid6
redundancy, though possibly a little less than raid6 performance,
as a real raid6 has the Q block distributed.

When mdadm-3.1 is released, you will be able to tell the raid6
to re-stripe with a more traditional layout.  This will take quite
a while, but you can continue to use the array (though a bit more
slowly) will it progresses.
Of course you don't need to do that step if you don't want to.



>
> I found the following recipe in the docs:
> mdadm --create /dev/md0 -l6 -n4 /dev/sdb1 /dev/sdc1 /dev/sdd1 missing
>
> I have 9 disks in my raid5, would i then do:
> [1] mdadm --create /dev/md0 -l6 -n10 /dev/sda /dev/sdb ... missing

If you did this, an the drives contained raid5 data, then that data
would not be available on /dev/md0.

NeilBrown


>
> i.e. only the first 9 drives and then hot add a new device to get it to
> reshape and add the extra parity to all drives?
>
> mdadm --add /dev/md0 /dev/sdk ?
>
> I would guess  command [1] would give problems as md0 is an active array
> will it work if i --stop the array first so that i can reshape to raid6?
>
> I couldn't really find much information on this, some say it is impossible
> without recreating the array? (So i ask here first before i try, as I dont
> want to risk my data, even though I have backups of the important
> data)
>
> Any advice would be nice
>
> /Michael Ole Olsen
>

