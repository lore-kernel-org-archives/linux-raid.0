From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Broken harddisk
Date: Sat, 29 Jan 2005 12:46:27 +0000 (GMT)
Message-ID: <Pine.LNX.4.56.0501291218200.25299@lion.drogon.net>
References: <41FAD73F.1070504@gmx.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41FAD73F.1070504@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: "T. Ermlich" <pelegrine@gmx.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 29 Jan 2005, T. Ermlich wrote:

> Hello there,
>
> I just got here from http://cgi.cse.unsw.edu.au/~neilb/Contact ...
> Hopefully I'm more/less right here.
>
> Several month ago I set-up an raid1 using mdadm.
> Two drives (/dev/sda & /dev/sdb, each one is an 160GB Samsung SATA
> disks) are used, and provide now /dev/md0, /dev/md1, /dev/md2 &
> /dev/md3. In november 2004 I upgraded to mdadm 1.8.1.

Drop 1.8.1 and get 1.8.0. I understand 1.8.1 has some experimental code
and not designed to be used for real.

> This afternoon, about 9 hours ago, /dev/sda broke down ... no chnace to
> get it working again .. :(
>
> My question now is: what does I have to do now?

Well, go through the procedure to remove the disk and put a new one back
in...

> The system is up and running, so I'd do an actual backup of the most
> important data ... but how to 'replace' the broken drive, and 'restore'
> the data content there (sorry, as english is not my native language I
> have no idea how to explain it correctly).
> Is there a way to do so, or does I have to create an raid1 from scratch,
> and copy all data from /dev/md0-3 there manually?

You should not have to copy it - thats the whole point of it all, however,
RAID is not a substitute for proper backups, so make sure you do those
backups now and regularly in the future.

OK - here are the basic steps - you may have to modify them as you haven't
posted enough detail for me to work it out to your exact system.

I'm assuing that you have partitioned each disk with 4 partitions and both
disks are partitioned identically and you are combining the same partition
of each device into the md devices. (eg. /dev/md0 is made from /dev/sda1
and /dev/sdb1) This is reasonably "sane" and I'm sure lots of people do it
this way (I do, but I'm a small sample :) If you aren't doing it this way,
then this won't work for you, but you may be able to adapt it for your
needs.

Firstly, get mdadm 1.8.0 as I mentioned above.

Look at /proc/mdstat.

See if all 4 md devices have a failed device in it. If the disk is really
dead, this is likely to be the case, if it's not, then you'll need to fail
each partition in each md device:

So make make sure that each md device has the failed disk really failed,
you can do:

  mdadm --fail /dev/md0 /dev/sda1
  mdadm --fail /dev/md1 /dev/sda2
  mdadm --fail /dev/md2 /dev/sda3
  mdadm --fail /dev/md3 /dev/sda4

Next, you need to remove the failed disk from each array

  mdadm --remove /dev/md0 /dev/sda1
  mdadm --remove /dev/md1 /dev/sda2
  mdadm --remove /dev/md2 /dev/sda3
  mdadm --remove /dev/md3 /dev/sda4

Strictly speaking, you don't have to do this - you can just power down and
put a new disk in, but I feel this is "cleaner" and hopefully leaves the
system in a stable and known state when you do power down.

At this point you can power down the machine and physically remove the
drive and replace it with a new, identical unit.

Reboot your PC. If it would normally boot off sda, you have to persuade it
to boot off sdb. You might need to alter the bios to do this, ot maybe
not... All BIOSes and controllers have their own little ideas about how
this is done.

If it boots off another drive (eg. an IDE drive) then you should be fine.
If it does boot off sda, then I hope you used the raid-extra-boot command
in lilo.conf (and tested it...) If you are using grub, I can't be of any
assistance there as I don't use it.

You should now have the system running with the data intact on sdb and all
the md devices working and mounted as normal.

Now you have to re-partition the new sda identical to sdb. If they are the
same make and size, you can use this:

  sfdisk -d /dev/sdb | sfdisk /dev/sda


Now, tell the raid code to re-mirror the drives:

  mdadm --add /dev/md0 /dev/sda1
  mdadm --add /dev/md1 /dev/sda2
  mdadm --add /dev/md2 /dev/sda3
  mdadm --add /dev/md3 /dev/sda4


then run:

   watch -n1 cat /proc/mdstat

and wait for it to finish, however the system is fully usable all during
this process.

If you can't power the machine down, and have hot-swappable drives in
proper caddys, then there is a way to tell the kernel that you are
removing the drive and adding a new one in, however it's probably safer if
you can do it while powered down.

If this doesn't make sense, post back the output of /proc/mdstat and
fdisk -l

Goos luck!

Gordon
