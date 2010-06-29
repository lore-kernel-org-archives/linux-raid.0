From: Neil Brown <neilb@suse.de>
Subject: Re: How do I determine which drive should be in which slot?
Date: Tue, 29 Jun 2010 17:02:09 +1000
Message-ID: <20100629170209.126e6336@notabene.brown>
References: <loom.20100626T070913-497@post.gmane.org>
	<loom.20100629T082214-677@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20100629T082214-677@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Dave W <dave+gmane@wuertele.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 29 Jun 2010 06:26:17 +0000 (UTC)
Dave W <dave+gmane@wuertele.com> wrote:

> Previously, I wrote:
> 
> > After making some changes in the bios to my boot order, my 5-drive RAID6
> > stopped assembling.  Three of the five known-good drives suddenly stopped
> > getting added to the right slots.  There are no disk errors in the logs and
> > I can read from the drives with no problems.
> 
> Any help with this one?  My disks are fine but mdadm seems confused about which
> slots they're supposed to be in.  How can I tell mdadm to put them in the right
> slots?

This is very odd.... that should not happen.  I think I've seen a few reports
of something like that happening and I'm beginning to wonder if I broke
something subtle....
What kernel/mdadm version are you using.

You should use "mdadm --examine" to see the configuration of the array, and
make sure that configuration is copied exactly when you creat a new array -
same chunk size, same layout, same metadata version etc.

You need to list the 5 drives in the correct order, from slot 0 to slot 4.
Clearly d1 is2 and e1 is 3.
Presumably b1 is 0, c1 is 1, f1 is 4.

So a command like:
 mdadm --create /dev/md0 --assume-clean --metadata=XX --chunk=XX --level=6
 --raid-devices=5 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1

is likely to work (if you get all the 'xx' right).
Keep a copy of the "mdadm --examine" output and compare it with the output
after runing the --create and make sure everything is still the same (e.g.
Data Offset could be changed - that would be awkward).

Then try "fsck -n -f /dev/md0" to see if fsck thinks it is OK.
If it is, try mounting "-o ro" and check that the data looks OK.

If it passed all that you should be fine - you might like to 
   echo repair > /sys/block/md0/md/sync_action
to make sure all the parity blocks are correct.

If 'fsck' fails, you might like to try again, re-arranging the devices that
you aren't sure of.

Good luck.

NeilBrown


> 
> Thanks,
> Dave
> 
> # mdadm --stop /dev/md0
> mdadm: stopped /dev/md0
> # mdadm -v -Af /dev/md0 /dev/sd[bcdef]1
> mdadm: looking for devices for /dev/md0
> mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 7.
> mdadm: /dev/sdc1 is identified as a member of /dev/md0, slot 6.
> mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 2.
> mdadm: /dev/sde1 is identified as a member of /dev/md0, slot 3.
> mdadm: /dev/sdf1 is identified as a member of /dev/md0, slot 5.
> mdadm: no uptodate device for slot 0 of /dev/md0
> mdadm: no uptodate device for slot 1 of /dev/md0
> mdadm: added /dev/sde1 to /dev/md0 as 3
> mdadm: no uptodate device for slot 4 of /dev/md0
> mdadm: added /dev/sdf1 to /dev/md0 as 5
> mdadm: added /dev/sdc1 to /dev/md0 as 6
> mdadm: added /dev/sdb1 to /dev/md0 as 7
> mdadm: added /dev/sdd1 to /dev/md0 as 2
> mdadm: /dev/md0 assembled from 2 drives and 3 spares - not enough to start the
> array.
> #
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

