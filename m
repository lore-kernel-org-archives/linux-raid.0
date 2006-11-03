From: dean gaudet <dean@arctic.org>
Subject: Re: RAID5/10 chunk size and ext2/3 stride parameter
Date: Fri, 3 Nov 2006 11:19:10 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0611031103520.26057@twinlark.arctic.org>
References: <20061024160306.GA15393@lapse.madduck.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20061024160306.GA15393@lapse.madduck.net>
Sender: linux-raid-owner@vger.kernel.org
To: martin f krafft <madduck@madduck.net>
Cc: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 24 Oct 2006, martin f krafft wrote:

> Hi,
> 
> I cannot find authoritative information about the relation between
> the RAID chunk size and the correct stride parameter to use when
> creating an ext2/3 filesystem.

you know, it's interesting -- mkfs.xfs somehow gets the right sunit/swidth 
automatically from the underlying md device.

for example, on a box i'm testing:

# mdadm --create --level=5 --raid-devices=4 --assume-clean --auto=yes /dev/md0 /dev/sd[abcd]1
mdadm: array /dev/md0 started.
# mkfs.xfs /dev/md0
meta-data=/dev/md0               isize=256    agcount=32, agsize=9157232 
blks
         =                       sectsz=4096  attr=0
data     =                       bsize=4096   blocks=293031424, imaxpct=25
         =                       sunit=16     swidth=48 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal log           bsize=4096   blocks=32768, version=2
         =                       sectsz=4096  sunit=1 blks
realtime =none                   extsz=196608 blocks=0, rtextents=0

# mdadm --stop /dev/md0
mdadm: stopped /dev/md0
# mdadm --zero-superblock /dev/sd[abcd]1
# mdadm --create --level=10 --layout=f2 --raid-devices=4 --assume-clean --auto=yes /dev/md0 /dev/sd[abcd]1
mdadm: array /dev/md0 started.
# mkfs.xfs -f /dev/md0
meta-data=/dev/md0               isize=256    agcount=32, agsize=6104816 blks
         =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=195354112, imaxpct=25
         =                       sunit=16     swidth=64 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal log           bsize=4096   blocks=32768, version=1
         =                       sectsz=512   sunit=0 blks
realtime =none                   extsz=262144 blocks=0, rtextents=0


i wonder if the code could be copied into mkfs.ext3?

although hmm, i don't think it gets raid10 "n2" correct:

# mdadm --stop /dev/md0
mdadm: stopped /dev/md0
# mdadm --zero-superblock /dev/sd[abcd]1
# mdadm --create --level=10 --layout=n2 --raid-devices=4 --assume-clean --auto=yes /dev/md0 /dev/sd[abcd]1
mdadm: array /dev/md0 started.
# mkfs.xfs -f /dev/md0
meta-data=/dev/md0               isize=256    agcount=32, agsize=6104816 blks
         =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=195354112, imaxpct=25
         =                       sunit=16     swidth=64 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal log           bsize=4096   blocks=32768, version=1
         =                       sectsz=512   sunit=0 blks
realtime =none                   extsz=262144 blocks=0, rtextents=0


in a "near 2" layout i would expect sunit=16, swidth=32 ...  but swidth=64
probably doesn't hurt.


> My understanding is that (block * stride) == (chunk). So if I create
> a default RAID5/10 with 64k chunks, and create a filesystem with 4k
> blocks on it, I should choose stride 64k/4k = 16.

that's how i think it works -- i don't think ext[23] have a concept of "stripe
width" like xfs does.  they just want to know how to avoid putting all the
critical data on one disk (which needs only the chunk size).  but you should
probably ask on the linux-ext4 mailing list.

> Is the chunk size of an array equal to the stripe size? Or is it
> (n-1)*chunk size for RAID5 and (n/2)*chunk size for a plain near=2
> RAID10?

> Also, I understand that it makes no sense to use stride for RAID1 as
> there are no stripes in that sense. But for RAID10 it makes sense,
> right?

yep.

-dean
