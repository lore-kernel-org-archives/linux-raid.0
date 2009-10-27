From: "NeilBrown" <neilb@suse.de>
Subject: Re: RAID5: *all* of my drives are now spares
Date: Tue, 27 Oct 2009 13:23:16 +1100
Message-ID: <960e25b92f434569a5833ffda52a1f25.squirrel@neil.brown.name>
References: <2c2a4e250910261845w7e62274es63b5fcebdfce034e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2c2a4e250910261845w7e62274es63b5fcebdfce034e@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: John P Poet <jppoet@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, October 27, 2009 12:45 pm, John P Poet wrote:
> After rebooting my computer, one of my RAID5 arrays would not
> assemble.  Only two of the four disks were showing as valid.  I tried
> to force the issue, but that did not work:
>
> # mdadm --assemble --metadata=1.2 --force /dev/md3 /dev/sdk /dev/sdj
> /dev/sdg /dev/sdf
> mdadm: /dev/md3 assembled from 2 drives - not enough to start the array.
>
> Then I noticed that /proc/mdstat was indicating that ALL of the drives
> where spares:
>
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> # cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md3 : inactive sdk[0](S) sdf[1](S) sdg[2](S) sdj[4](S)
>       7814056960 blocks super 1.2
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

When the array is 'inactive' everything always appears to be spare,
so that isn't very significant.

However the --examine shows that 3 of the 4 devices report a role
of 'spare'... which is odd because "--assemble --force" managed to
find 2 devices that weren't spares.
So it looks like you might have done some more things without telling
us.
Maybe the "--re-add" went in there...

Anyway, Looking at the 'Events' fields, /dev/sdf seems to have been
failed for a while, so you should only be looking at
the other 3, k, j, and g.

k is device 0, what role the others have isn't clear.  Maybe some old
kernel logs of the last time the array was successfully assembled will
help.

My guess is that 'j' is device 3 so g would be 1 or 2.

To get your data back you will need to recreate the array. So something like:

 mdadm -C /dev/md3 -e 1.2 -l 5 -n 4 -c 256 /dev/sdk /dev/sdg missing /dev/sdj

This will change the metadata but not otherwise change the content of the
devices.
Use mdadm --examine to check that the data offset is still 272.
If it is try to 'fsck -n' the device.  If all is fine you probably
have your data back.  Mount the filesystem read-only and check it.

If that doesn't work, stop the array and create again with the devices
in a different order.  e.g. /dev/sdk missing /dev/sdg /dev/sdj

One of the orders should work.

NeilBrown


