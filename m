From: Gavin Flower <gavinflower@yahoo.com>
Subject: Re: physical size of the device inconsistent with superblock, after RAID problems
Date: Thu, 17 Feb 2011 19:50:48 -0800 (PST)
Message-ID: <546229.64645.qm@web65111.mail.ac2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: ext3-users@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--- On Fri, 18/2/11, NeilBrown <neilb@suse.de> wrote:

> From: NeilBrown <neilb@suse.de>
> Subject: Re: physical size of the device inconsistent with superblock, after RAID problems
> To: "Gavin Flower" <gavinflower@yahoo.com>
> Cc: ext3-users@redhat.com, linux-raid@vger.kernel.org
> Date: Friday, 18 February, 2011, 14:51
> On Thu, 17 Feb 2011 15:53:11 -0800
> (PST) Gavin Flower <gavinflower@yahoo.com>
> wrote:
>
> > Hi Neil,
> >
> > My attempted post to ext3-users@redhat.com,
> had not been published there (even though I had emailed it 4
> days ago!), as at a minute ago.
> >
> > I finally bit the bullet and went ahead.
> >
> > I accepted the fixes put forward by fsck associated
> with bitmap differences, and rebooted.
> >
> > Still problems.
> >
> > Still had the discrepancy in the file size.  So I ran
> the command:
> >
> > resize2fs -p /dev/md1 76799616
> >
> > I used the smaller of the 2 block counts, as:
> > (a) I needed to reduce the file system size, because I
> had already reduced the RAID size (I _SHOULD_ have done this
> first, before resizing the RAID), and
> > (b) it is reported as the 'physical' size of the
> device, so it is likely to be the correct value IMHO
> >
> > The system the came up successfully after a reboot,
> and I was able to log in as normal.
> >
> > There appeared to be no apparent loss of data, not
> that I did an exhaustive systematic check. However, several
> users have logged on successfully, and it is playing its
> part as gateway to the Internet, and squid appears to be
> providing its normal functionality.
> >
> > Neil, your help and encouragement was/is greatly
> appreciated!
> >
>
> Excellent!  I'm glad you found a way through.
> As you didn't really trim very much from your device it is
> certainly possible
> that no critical data was there.  Quite possibly
> resize2fs would have told
> you if there was (I certainly hope it would have done).
>
> NeilBrown
>
Hi Neil,

Having about 26% spare capacity (see output of the df) md1 (the problematic RAID 6), probably (?) meant that nothing was likely to be lost by trimming a tiny fraction of a percent from the end.

However, since the md1 device actually resides on 5 real physical drives, reality is almost certainly more complicated! - possibly, hence the bit map discrepancies (now I'm firmly outside my area of expertise!).

# df
Filesystem  1K-blocks       Used    Available   Use%   Mounted on
/dev/md2   1097254408   27547660   1013969456     3%   /
tmpfs         4097108        772      4096336     1%   /dev/shm
/dev/sda1     1032088     129800       849860    14%   /boot
/dev/md1    302377920  212244524     74773476    74%   /data
# mdadm --detail /dev/md1
/dev/md1:
        Version : 0.90
  Creation Time : Thu Dec  3 13:05:02 2009
     Raid Level : raid6
     Array Size : 307198464 (292.97 GiB 314.57 GB)
  Used Dev Size : 102399488 (97.66 GiB 104.86 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 1
    Persistence : Superblock is persistent

    Update Time : Fri Feb 18 15:09:50 2011
          State : clean
Active Devices : 5
Working Devices : 5
Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 512K

           UUID : 6f1176ae:a0ad6cac:bfe78010:bc810f04
         Events : 0.3389728

    Number   Major   Minor   RaidDevice State
       0       8        2        0      active sync   /dev/sda2
       1       8       18        1      active sync   /dev/sdb2
       2       8       66        2      active sync   /dev/sde2
       3       8       50        3      active sync   /dev/sdd2
       4       8       34        4      active sync   /dev/sdc2
#


Cheers,
Gavin






      
