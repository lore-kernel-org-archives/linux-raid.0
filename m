From: dean gaudet <dean-list-linux-raid@arctic.org>
Subject: Re: recovery of hosed raid5 array
Date: Sun, 12 Oct 2003 11:34:21 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0310121112500.7866@twinlark.arctic.org>
References: <slrnbog9og.t0c.lunz@orr.homenet> <no.Yo.24973.N.nN.0310111457280@business.com>
 <slrnboirt8.me8.lunz@orr.homenet> <Pine.LNX.4.58.0310121034090.7866@twinlark.arctic.org>
 <20031012180419.GA23827@orr.falooley.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20031012180419.GA23827@orr.falooley.org>
To: Jason Lunz <lunz@falooley.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 12 Oct 2003, Jason Lunz wrote:

> On Sun, Oct 12, 2003 at 10:39AM -0700, dean gaudet wrote:
>
> > mdadm can do it for you ... you need to know exactly which disk was in
> > which position in the raid.  then you recreate the raid using "missing" in
> > the slot where /dev/hde belonged.  then you'll have a degraded array, so
> > md won't try rebuilding it.  then you can copy off the data.
>
> seriously? Did you read the whole thread? mdadm will do the right thing
> even though /dev/hdg was 3% into a resync when /dev/hde died? That would
> be lovely.

yeah it's not gonna be pretty no matter what you try, but you can at least
force md into thinking the remaining disks are part of a degraded raid.
you should mount any fs read-only at this point though.


> > you need to know the exact numberings, and the exact commands you used
> > to create the array in the first place.
>
> How might I go about figuring this out? I got a 120G drive yesterday
> that's large enough to capture raw images of all the raid disks, so I
> can try different combinations of commands. What I can't do is look at
> the logs, because the non-raid portion of the now-dead /dev/hde held the
> root, /usr, and /var partitions.

unfortunately if you don't have any logs or any memory of what positions
the disks were in you're kind of screwed.  it's in dmesg after a boot --
in the past i've fetched it from a backup of /var/log/dmesg on another
system.  i.e.:

raid5: device sdh1 operational as raid disk 6
raid5: device sdg1 operational as raid disk 5
raid5: spare disk sdf1
raid5: device sde1 operational as raid disk 4
raid5: device sdd1 operational as raid disk 3
raid5: device sdc1 operational as raid disk 2
raid5: device sdb1 operational as raid disk 1
raid5: device sda1 operational as raid disk 0

unfortunately md doesn't log the chunksize in dmesg... you can get the
chunksize from /proc/mdstat though (which is another place to get the
disk positions).

Personalities : [linear] [raid0] [raid1] [raid5]
read_ahead 1024 sectors
md0 : active raid5 sdh1[6] sdg1[5] sdf1[7] sde1[4] sdd1[3] sdc1[2] sdb1[1] sda1[0]
      720321792 blocks level 5, 64k chunk, algorithm 2 [7/7] [UUUUUUU]

if you've never had any faulty disk and swapped in a spare then your
raid should be in the exact order you originally created it.

if i wanted to forcefully reconstruct that array without sde1 i'd be
doing something like (you need to --stop your md0 before doing this):

	mdadm --create /dev/md0 --chunk=64 --level=5 --raid-devices=7 \
		/dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1 missing \
		/dev/sdg1 /dev/sdh1

notice the "missing".

if you specified a non-default raid5 algorithm then you need to include
that as well.

this will create brandnew raid superblocks... there's no going back
after you've done this.  to md it will be like this is a brand new
array.

cross your fingers and mount the fs read-only and see if any of your
data is intact.

as a backup you could partition copy md0 to another disk/raid using dd
and then you can fsck that copy ... you might get further than you would
mounting the original read-only.

if /dev/hdg has a surface error and md marks it as faulty again then
what you'll need to do is copy /dev/hdg to a fresh disk (use dd on the
partition) then do like above but replace hdg with the copy... you'll
get garbage wherever hdg had surface errors, but at least md won't mark
it as faulty.  (the fs probably won't be happy.)

hmm i suppose if you're clever you can find the bad sectors with dd, then
overwrite them with zeros -- if the disk has any spare blocks left this
will work and you won't have to copy to another disk...  you lose the
data either way.  i'm going to skip explaining how to use dd like this
because you really should know what you're doing if you want to try it.

trust me, if any of this isn't clear then don't do it until you understand
what i'm suggesting.  there's really no going back.

-dean
