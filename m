From: dean gaudet <dean@arctic.org>
Subject: Re: RAID5/10 chunk size and ext2/3 stride parameter
Date: Sat, 4 Nov 2006 18:59:36 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0611041852030.13706@twinlark.arctic.org>
References: <20061024160306.GA15393@lapse.madduck.net>
 <Pine.LNX.4.64.0611031103520.26057@twinlark.arctic.org>
 <20061104120049.GA16979@piper.madduck.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20061104120049.GA16979@piper.madduck.net>
Sender: linux-raid-owner@vger.kernel.org
To: martin f krafft <madduck@madduck.net>
Cc: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, 4 Nov 2006, martin f krafft wrote:

> also sprach dean gaudet <dean@arctic.org> [2006.11.03.2019 +0100]:
> > > I cannot find authoritative information about the relation between
> > > the RAID chunk size and the correct stride parameter to use when
> > > creating an ext2/3 filesystem.
> > 
> > you know, it's interesting -- mkfs.xfs somehow gets the right sunit/swidth 
> > automatically from the underlying md device.
> 
> i don't know enough about xfs to be able to agree or disagree with
> you on that.
> 
> > # mdadm --create --level=5 --raid-devices=4 --assume-clean --auto=yes /dev/md0 /dev/sd[abcd]1
> > mdadm: array /dev/md0 started.
> 
> with 64k chunks i assume...

yup.


> > # mkfs.xfs /dev/md0
> > meta-data=/dev/md0               isize=256    agcount=32, agsize=9157232 
> > blks
> >          =                       sectsz=4096  attr=0
> > data     =                       bsize=4096   blocks=293031424, imaxpct=25
> >          =                       sunit=16     swidth=48 blks, unwritten=1
> 
> sunit seems like the stride width i determined (64k chunks / 4k
> bzise), but what is swidth? Is it 64 * 3/4 because of the four
> device RAID5?

yup.

and for a raid6 mkfs.xfs correctly gets sunit=16 swidth=32.


> > # mdadm --create --level=10 --layout=f2 --raid-devices=4 --assume-clean --auto=yes /dev/md0 /dev/sd[abcd]1
> > mdadm: array /dev/md0 started.
> > # mkfs.xfs -f /dev/md0
> > meta-data=/dev/md0               isize=256    agcount=32, agsize=6104816 blks
> >          =                       sectsz=512   attr=0
> > data     =                       bsize=4096   blocks=195354112, imaxpct=25
> >          =                       sunit=16     swidth=64 blks, unwritten=1
> 
> okay, so as before, 16 stride size and 64 stripe width, because
> we're now dealing with mirrors.
> 
> > # mdadm --create --level=10 --layout=n2 --raid-devices=4 --assume-clean --auto=yes /dev/md0 /dev/sd[abcd]1
> > mdadm: array /dev/md0 started.
> > # mkfs.xfs -f /dev/md0
> > meta-data=/dev/md0               isize=256    agcount=32, agsize=6104816 blks
> >          =                       sectsz=512   attr=0
> > data     =                       bsize=4096   blocks=195354112, imaxpct=25
> >          =                       sunit=16     swidth=64 blks, unwritten=1
> 
> why not? in this case, -n2 and -f2 aren't any different, are they?

they're different in that with f2 you get essentially 4 disk raid0 read 
performance because the copies of each byte are half a disk away... so it 
looks like a raid0 on the first half of the disks, and another raid0 on 
the second half.

in n2 the two copies are at the same offset... so it looks more like a 2 
disk raid0 for reading and writing.

i'm not 100% certain what xfs uses them for -- you can actually change the 
values at mount time.  so it probably uses them for either read scheduling 
or write layout or both.

-dean
