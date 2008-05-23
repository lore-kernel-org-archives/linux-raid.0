From: "NeilBrown" <neilb@suse.de>
Subject: Re: Recreating undamaged RAID5
Date: Fri, 23 May 2008 10:26:54 +1000 (EST)
Message-ID: <35928.192.168.1.70.1211502414.squirrel@neil.brown.name>
References: <20080522215926.GA3783@bth.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080522215926.GA3783@bth.se>
Sender: linux-raid-owner@vger.kernel.org
To: Anders Johansson <ajh@bth.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, May 23, 2008 7:59 am, Anders Johansson wrote:
> Hi,
>
> I have a fully functioning raid5 array with 4 disks that will not start.
> The following has happened:
>
> 1. I created the array with 3 disks and ran it for about two years.
> 2. I recently grew the array to 4 disks, no problem.

I assume the 'grow' completed ?

> 3. I upgraded to kernel 2.6.18.6 (Debian testing) mdadm v2.6.4.
> 4. After the upgrade, the array would not start /proc/mdstat marked
>    the three original disks as removed and the recently added one as
>    active.

I don't suppose you have kernel logs (/var/log/kern*) from the first reboot
into the new kernel that show the array being assembled?

> 5. I was stupid and assumed that re-add meant add without reconstruct
>    and added the three missing disks.

It does, but only if the metadata confirms that this is safe.

> 6. The array is now still intact but will not start as the disks I
>    re-added are marked as spares.
>
> There seems to be two problems here:
> The kernel upgrade did something?
> How can I mark the spare disks as active without touching the data?
>
>
> I did test create, but did not complete it. The output is:
> mdadm --create /dev/md0 --level=5 --raid-devices=4 --layout=left-symmetric
> --chunk=64 --assume-clean /dev/sdc1 /dev/sda1 /dev/sdb1 /dev/sdd1
> mdadm: /dev/sdc1 appears to be part of a raid array:
>     level=raid5 devices=4 ctime=Fri Mar  9 12:54:19 2007
> mdadm: /dev/sda1 appears to be part of a raid array:
>     level=raid5 devices=4 ctime=Fri Mar  9 12:54:19 2007
> mdadm: /dev/sdb1 appears to be part of a raid array:
>     level=raid5 devices=4 ctime=Fri Mar  9 12:54:19 2007
> mdadm: /dev/sdd1 appears to be part of a raid array:
>     level=raid5 devices=4 ctime=Fri Mar  9 12:54:19 2007
> Continue creating array? no
> mdadm: create aborted.
>

You should complete the create.  As you are using "assume-clean"
doing this will not affect any data on the device - only the metadata.
And that is corrupt already.
I would run "fsck -n" after the create to check that the data looks right,
then mount the filesystem readonly and have a look around, but
I suspect everything will be fine.

NeilBrown

