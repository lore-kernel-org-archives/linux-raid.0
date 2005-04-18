From: tmp <skrald@amossen.dk>
Subject: Re: Questions about software RAID
Date: Tue, 19 Apr 2005 01:12:16 +0200
Message-ID: <1113865936.1483.73.camel@debian>
References: <1113853825.1483.34.camel@debian>
	 <426414A5.3020706@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <426414A5.3020706@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks for your answers! They led to a couple of new questions,
however. :-)

I've read "man mdadm" and "man mdadm.conf" but I certainly doesn't have
an overview of software RAID.

> yes
> raidtab is deprecated - man mdadm

OK. The HOWTO describes mostly a raidtools context, however. Is the
following correct then?
mdadm.conf may be considered as the replacement for raidtab. When mdadm
starts it consults this file and starts the raid arrays correspondingly.
This leads to the following:


a) If mdadm starts the arrays, how can I then boot from a RAID device
(mdadm isn't started upon boot)?
I don't quite get which parts of the RAID system are controled by the
kernel and which parts are controled by mdadm.


b) Whenever I replace disks, the runtime configuration changes. I assume
that I should manually edit mdadm.conf in order to make corespond to
reality?

> >2) The new disk has to be manually partitioned before beeing used in the
> >array.
> no it doesn't. You could use the whole disk (/dev/hdb).
> In general, AFAIK, partitions are better as they allow automatic 
> assembly at boot.

Is it correct that I can use whole disks (/dev/hdb) only if I make a
partitionable array and thus creates the partitions UPON the raid
mechanism?

As far as I can see, partitionable arrays makes disk replacements easier
as you can just replace the disk and let the RAID software take care of
syncing the new disk with existing partitioning. Is that correct?

You say I can't boot from such a partitionable raid array. Is that
correctly understood?

Can I "grow" a partitionable raid array if I replace the existing disks
with larger ones later? 

Would you prefer manual partitioned disks, even though disk replacements
are a bit more difficult?

I guess that mdadm automatically writes persistent superblocks to all
disks?

> >3) Must all partition types be 0xFD? What happens if they are not?
> no
> They won't be autodetected by the _kernel_

OK, so it is generally a good idea to always set the partition types to
0xFD, I guess.

> >4) I guess the partitions itself doesn't have to be formated as the
> >filesystem is on the RAID-level. Is that correct?
> compulsory!

I meant, the /dev/mdX has to be formatted, not the individual
partitions. Still right?

> >5) Removing a disk requires that I do a "mdadm -r" on all the partitions
> >that is involved in a RAID array. I attempt to by a hot-swap capable
> >controler, so what happens if I just pull out the disk without this
> >manual removal command?
> as far as md is concerned the disk disappeared.
> I _think_ this is just like mdadm -r.

So I could actually just pull out the disk, insert a new one and do a
"mdadm -a /dev/mdX /dev/sdY"?
The RAID system won't detect the newly inserted disk itself?

> > I.e. do I have to let my swap disk be a
> >RAID-setup too if I wan't it to continue upon disk crash?
> yes - a mirror, not a stripe.

OK. Depending on your recomendations above, I could either make it a
swap partition on a partitionable array or create an array for the swap
in the conventional way (of existing partitions).

Thanks again for your help!

Are there some HOWTO out there, that is up-to-date and is based on RAID
usage with mdadm and kernel 2.6 instead of raidtools and kernel 2.2/2.4?
I can't possibly be the only one with these newbie questions. :-)



