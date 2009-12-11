From: "Cat'Killer" <catkiller@gmail.com>
Subject: RAID 5 build time optimization question and experiments.
Date: Fri, 11 Dec 2009 14:55:31 +0000
Message-ID: <ad15b8920912110655k62c8b6ber8b366731cf1e85f3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi All,

I am currently needing to build a RAID 5 on ten large 1TB Disks in
several different systems, that will come over time.

The systems are all running exactly the same linux version and mdadm
tools, as well as being exactly the same hardware, and are populated
with exactly the same drives (same capacity, manufacturer model and
batch).

Creating a RAID 5 array on each of these devices will take approx
15Hours+, which led me to think of the following procedure/experiment
to create them faster.

I found a way using Doug Gilbert's great sg3utils to zero all these
disks in a very efficient manner, using sgp_dd, at near drive
bandwidth, and proceeded to zero all the disks fully in about 4 hours!

Once done, I then created a RAID 5 on 10 disks, waited for the rebuild
to complete, stopped the array using mdadm, and dumped each of the
RAID's components superblocks to files.

The command used for the RAID 5 creation was the following:

mdadm --create -vvv --force --run --metadata=1.2 /dev/md/d0 --level=5
--size=35879936 --chunk=64 --name=0125465 -n10 --bitmap=internal
--bitmap-chunk=4096 --layout=ls /dev/sde2 /dev/sdj2 /dev/sdf2
/dev/sdg2 /dev/sdb2 /dev/sdc2 /dev/sdh2 /dev/sdi2 /dev/sdd2 /dev/sda2

The create worked fine and I waited for the rebuild to be complete
before stopping the array and dumping the SBs.

I then proceeded to write these same superblocks to 10 new similar
disks in a different system, and used the following command to
assemble the array:

bin/mdadm/mdadm --assemble -vvv --force /dev/md/d0 --run
--name=0125465 /dev/sde2 /dev/sdj2 /dev/sdf2 /dev/sdg2 /dev/sdb2
/dev/sdc2 /dev/sdh2 /dev/sdi2 /dev/sdd2 /dev/sda2

This subsequently led to my new array to be instantly online with no
rebuild required.

I figured this whole procedure would work since the disks are
completely zeroed, the parity information should be zero anyways on
the drives.  Since zeroing all these drives took me 4 hours, I would
save nearly 10 hours for any
subsequent array I would need to build in the future, just by zeroing
their components and dd-ing the SBs onto them.

Do you think this method has its flaws? Do you think the data on it
should be safe? How about the bitmap, would that be safe as long as
the superblock has been copied, or should I copy this over too?

Thanks in advance.

Ben.
