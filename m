From: piergiorgio.sartor@nexgo.de
Subject: Re: Another RAID-5 problem
Date: Wed, 9 May 2012 14:17:33 +0200 (CEST)
Message-ID: <1931403540.986928.1336565853409.JavaMail.ngmail@webmail08.arcor-online.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, piergiorgio.sartor@nexgo.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

thanks a lot for the quick answer, please see the
text embedded below for further details.

----- Original Nachricht ----
Von:     NeilBrown <neilb@suse.de>
An:      piergiorgio.sartor@nexgo.de
Datum:   09.05.2012 13:03
Betreff: Re: Another RAID-5 problem

> On Wed, 9 May 2012 11:10:58 +0200 (CEST) piergiorgio.sartor@nexgo.de wrote:
> 
> > Hi all,
> > 
> > we're hit by a RAID-5 issue, it seems Ubuntu 12.04 is shipping
> > some bugged kernel/mdadm combination.
> 
> Buggy kernel.  My fault.  I think they know and an update should follow.
> 
> However I suspect that Ubuntu must be doing something else to cause the
> problem to trigger so often.  The circumstance that makes it happen should
> be
> extremely rare.  It is as though the md array is half-stopped just before
> shutdown.  If it were completely stopped or not stopped at all, this
> wouldn't
> happen.
> 
> > 
> > Following the other thread about a similar issue, I understood
> > it is possible to fix the array without losing data.
> 
> Correct.
> 
> > 
> > Problems are:
> > 
> > 1) We do not know the HDD order and it is a 5 disks RAID-5
> 
> If you have kernel logs from the last successful boot they would contain
> a "RAID conf printout" which would give you the order, but maybe that it on
> the RAID-5 array?

Unfortunately, the kernel logs are on the PC itself, so
we cannot get them.

> If it is you will have to try different permutations until you find one
> that
> works.

I've some questions about this topic.

We have other, identical, PCs, which were built more or less
same time as this one.
One of this have a similar history, this means 4 drives RAID-5,
later extended to 5 (BTW, Ubuntu 10.10 delivered mdadm 2.6.7.1,
we extended the array later, with some 3.1 or 3.2, that can explain
the data offset difference).

This identical PC shows the following (mdadm -D /dev/md1):

...
    Number   Major   Minor   RaidDevice State
       0       8       34        0      active sync   /dev/sdc2
       1       8       18        1      active sync   /dev/sdb2
       2       8        2        2      active sync   /dev/sda2
       5       8       50        3      active sync   /dev/sdd2
       4       8       66        4      active sync   /dev/sde2

In this case I assume the "RaidDevice" indicates the order.
Is this correct? We could try with this one, at first.
What about "Number"? Why 3 is missing?
BTW, the broken RAID has /dev/sdd2 still valid, and "mdadm -E"
shows:

...
  Device Role : Active device 3
...

Which seem consistent with the working one.

Nevertheless, there is something fishy.
If I try the "dd" command, you suggested below, the drive
which seems to show some consistent LVM data is /dev/sde2,
not /dev/sdc2.

Specifically (dd with proper skip, i.e. 1048 for /dev/sde2):

VolGroup {
id = "eK5Sde-ENzo-0iBO-dJIB-buBt-BnoX-NEmZ1v"
seqno = 1759
status = ["RESIZEABLE", "READ", "WRITE"]
...

The others (with skip 264) either have zeros or some
LVM text, but not something looking properly aligned.

Question would be if the growth changed, somehow, the
order, in which case how will "Create" behave? Considering
that one drive will be missing.

> > 2) 4 of 5 disks have a data offset of 264 sectors, while the
> > fourth one, added later, has 1048 sectors.
> 
> Ouch.
> It would be easiest to just make a degraded array with the 4 devices with
> the
> same data offset, then add the 5th later.
> To get the correct data offset you could  either use the same mdadm that
> the
> array was originally built with, or you could get the 'r10-reshape'
> branch from git://neil.brown.name/mdadm/ and build that.
> Then create the array with --data-offset=132K as well as all the other
> flags.
> However that hasn't been tested extensively so it would be best to test it
> elsewhere first.  Check that it created the array with correct data-offset
> and correct size.
> 
> > 3) There is a LVM setup on the array, not a plain filesystem.
> 
> That does make it a little more complex but not much.
> You would need to activate the LVM, then "fsck -n" the filesystems to check
> if
> you have the devices in the right order.
> However this could help you identify the first device quickly.
> If you
>   dd if=/dev/sdXX skip=264 count=1 
> then for the first device in the array it will show you the textual
> description of the LVM setup.  For the other devices it will probably be
> binary or something unrelated.
> 
> > 
> > Any idea on how can we get the array back without losing any
> > data?
> 
> Do you know what the chunk size was?  Probably 64K if it was an old array.
> Maybe 512K though.

Chunk size we know. As mentioned above, we have other PCs,
all the same, chunk is 512K.
Metadata is 1.1.

Bitmap was activated, but this, I understand, is not problem.
Furthermore "mdadm -X" on each HDD shows 0 dirty bits,
which looks good to me.

> I would:
>  1/ look at old logs if possible to find out the device order
>  2/ try to remember what the chunk size could be.  If you have the exact
>     used-device size (mdadm -E should give that) you can get an upper limit
>     for the chunk size by finding the larger power-of-2 which divides it.
>  3/ Try to identify the first device by looking for LVM metadata.
>  4/ Make a list of the possible arrangements of devices and possible chunk
>     sizes based on the info you collected.
>  5/ Check that you can create an array with a data-offset for 264 sectors
>     using one of the approaches listed above.
>  6/ write a script which iterated though the possibilities and re-created
> the
>     array then tries to turn on LVM and the fsck.  Or maybe iterate by
> hand.
>     The command to create an array would be something like
>       mdadm -C /dev/md0 -l5 -n5 --assume-clean --chunk=64 \
>       --data-offset=132K   /dev/sdX missing /dev/sdY /dev/sdZ /dev/sdW
>  7/ Find out which arrangement produces least fsck errors, and use that.

I do have another question.

How about starting the RAID in read-only mode?
This will avoid LVM or mount to write something, risking
damages to the different superblocks.
What would be the best way to do this?
After "Create", just "mdadm --read-only /dev/md1"?

One more, how about dumping, with "dd", the firsts
few MB of each drive as backup? Make sense?

Thanks again for the support,

bye,

pg

> > 
> > At the moment, it seems quite difficult to provide dump of
> > "mdadm -E" or similar, since the PC does not boot at all.
> > In any case, if necessary we could try to take a picture of
> > the screen and send it here or directly per email, if appropriate.
> 
> You probably need to boot from a DVD-ROM or similar.
> Certainly feel free to post the data you collect and the conclusions you
> draw
> and even the script you write if you would like them reviewed and
> confirmed.
> 
> NeilBrown
> 
> 
> 

-- 

piergiorgio
