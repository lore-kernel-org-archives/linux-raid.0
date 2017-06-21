From: "r23@anchordrop.net" <r23@anchordrop.net>
Subject: Re: raid-1  starting with 1 drive after brief hiatus with cruddy
 controller.
Date: Wed, 21 Jun 2017 14:29:35 -0400
Message-ID: <20170621142935.6480a42c@e20>
References: <20170618001410.6fa96469@e20>
        <871sqh57x5.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <871sqh57x5.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi All,

mdadm --assemble /dev/md/debian:0 --update=name -v /dev/sdb2 --run

started the container with the 1 drive and I was able to mount it !!

Thank you all very much. Happy day :)

root@mars:~/raid/bin/util#  mdadm --assemble /dev/md/debian:0 --update=name -v /dev/sdb2 --run
mdadm: looking for devices for /dev/md/debian:0
mdadm: /dev/sdb2 is identified as a member of /dev/md/debian:0, slot 1.
mdadm: no uptodate device for slot 0 of /dev/md/debian:0
mdadm: added /dev/sdb2 to /dev/md/debian:0 as 1
mdadm: /dev/md/debian:0 has been started with 1 drive (out of 2).
root@mars:~/raid/bin/util# mkdir /mnt/thanks
root@mars:~/raid/bin/util# mount -o ro /dev/md/debian:0 /mnt/thanks
root@mars:~/raid/bin/util# cd /mnt/thanks
root@mars:/mnt/thanks# ls -l
total 63900
drwxr-xr-x 19 root   userme     4096 Nov  7....
::
::
::
----------------

On Mon, 19 Jun 2017 06:59:18 +1000
NeilBrown <neilb@suse.com> wrote:

> On Sun, Jun 18 2017, r23@anchordrop.net wrote:
> >
> > root@mars:~/raid/bin# mdadm --misc --examine /dev/sdb2
> > /dev/sdb2:
> >           Magic : a92b4efc
> >         Version : 1.2
> >     Feature Map : 0x1
> >      Array UUID : 2a3489a6:b430c744:2c89a792:98521913
> >            Name : debian:0
> >   Creation Time : Sat May  9 17:44:25 2015
> >      Raid Level : raid1
> >    Raid Devices : 2
> >
> >  Avail Dev Size : 9765179392 (4656.40 GiB 4999.77 GB)
> >      Array Size : 4882589696 (4656.40 GiB 4999.77 GB)
> >     Data Offset : 262144 sectors
> >    Super Offset : 8 sectors
> >    Unused Space : before=262056 sectors, after=0 sectors
> >           State : clean
> >     Device UUID : 4697b088:5d3b1ae5:55d30f65:516df63d
> >
> > Internal Bitmap : 8 sectors from superblock
> >     Update Time : Wed Jun 14 23:53:27 2017
> >   Bad Block Log : 512 entries available at offset 72 sectors
> >        Checksum : 1f245410 - expected 1f249410
> 
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> checksum is wrong.
> 
> > root@mars:~/raid/bin/util/lsdrv#  mdadm
> > --assemble /dev/md/debian:0  -v /dev/sdb2 --run mdadm: looking for
> > devices for /dev/md/debian:0 mdadm: /dev/sdb2 is identified as a
> > member of /dev/md/debian:0, slot 1. mdadm: no uptodate device for
> > slot 0 of /dev/md/debian:0 mdadm: failed to add /dev/sdb2
> > to /dev/md/debian:0: Invalid argument
> 
> Bad checksum caused kernel to reject the device.
> 
> There is no obvious way to correct the checksum, but I think you can
> force it by using the --update option to --assemble
> e.g.
> 
>   mdadm --assemble /dev/md/debian:0 --update=name -v /dev/sdb2
> 
> When doing that, you should check that other fields all look correct
> first, because something must have changed to affect the bitmap.
> (I cannot see anything that looks wrong)
> 
> NeilBrown

