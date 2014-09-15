From: Andy Smith <andy@strugglers.net>
Subject: Re: grub-probe: "found two disks with the index 3 for RAID md2"
 after changing superblock 0.9 to 1.0
Date: Mon, 15 Sep 2014 17:12:52 +0000
Message-ID: <20140915171252.GI11855@bitfolk.com>
References: <20140915064741.GH11855@bitfolk.com>
 <20140915170037.16f93daa@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140915170037.16f93daa@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

On Mon, Sep 15, 2014 at 05:00:37PM +1000, NeilBrown wrote:
> On Mon, 15 Sep 2014 06:47:41 +0000 Andy Smith <andy@strugglers.net> wrote:
> > The thing is, that bug report is quite old and is marked closed, and
> > also states:
> > 
> >     "The problem is that 0.9x metadata block doesn't have enough
> >     info to check it. With 1.x we have no such problem."
> > 
> > Of course, it *is* 1.x superblock. Did the poster actually mean to
> > say that they have no problem with v1.1 and v1.2 (because they are
> > located at or near the beginning of the device, not at the end)?
> 
> 0.90 has the problem, 1.x doesn't.

Right.

> Maybe there is an old 0.90 superblock confusing things.  It lives in a
> different location than the others and so there is room for confusion.

I think that must be it.

>   mdadm --examine --metadata=0.90 /dev/sda3
> 
> which show you the 0.90 metadata if there is any.

/dev/sda3:
          Magic : a92b4efc
        Version : 0.90.01
           UUID : 3905b303:ca604b72:be5949c4:ab051b7a
  Creation Time : Sun Jun  4 08:18:58 2006
     Raid Level : raid10
  Used Dev Size : 309363264 (295.03 GiB 316.79 GB)
     Array Size : 928089792 (885.10 GiB 950.36 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 2

    Update Time : Sun Aug 24 14:26:50 2014
          State : clean
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0
       Checksum : e613d577 - correct
         Events : 312149996

         Layout : near=2
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     5       8        3        5      active sync   /dev/sda3

   0     0       8       51        0      active sync   /dev/sdd3
   1     1       8       67        1      active sync
   2     2       8       83        2      active sync
   3     3       8       19        3      active sync   /dev/sdb3
   4     4       8       35        4      active sync   /dev/sdc3
   5     5       8        3        5      active sync   /dev/sda3

This shows the array when it had 6 devices as well, so clearly from
before the metadata update and shrink to 4 devices.

>   mdadm --zero-super --metadata=0.90 /dev/sda3
> 
> will remove any 0.90 metadata.

Trying that whole the array is running:

mdadm: Couldn't open /dev/sda3 for write - not zeroing

This needs to be done with the array stopped, presumably?

Thanks for the explanation!

Cheers,
Andy
