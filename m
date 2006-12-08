From: Jacob Schmidt Madsen <jacob@mungo.dk>
Subject: Re: Trouble when growing a raid5 array
Date: Fri, 8 Dec 2006 22:08:25 +0100
Message-ID: <200612082208.25614.jacob@mungo.dk>
References: <200611300804.15031.jacob@mungo.dk> <200612011218.29088.jacob@mungo.dk> <200612082029.38316.jacob@mungo.dk>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200612082029.38316.jacob@mungo.dk>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Okay, I had an overflow in my brain instead.

I wasnt aware of the large block device support in the kernel. Its enabled now 
and everything is working!

Sorry about the spam :-)

On Friday 08 December 2006 20:29, you wrote:
> I think I've found an overflow.
>
> After thinking about this for a while I decided to create a new array of
> all 8 partitions and overwrite the old one.
> I was counting on almost all data would be intact, if the partitions in the
> new raid5 array were in the order as in the overwritten array - the reshape
> process got 98.1% done after all.
>
> So I executed:
> #
> mdadm --create --verbose /dev/md5 --level=5 --raid-devices=8 /dev/sdb1
> /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdg1 /dev/sdh1 /dev/sdi1
> mdadm: layout defaults to left-symmetric
> mdadm: chunk size defaults to 64K
> mdadm: /dev/sdb1 appears to be part of a raid array:
>     level=raid5 devices=8 ctime=Fri Dec  8 18:08:42 2006
> mdadm: /dev/sdc1 appears to be part of a raid array:
>     level=raid5 devices=8 ctime=Fri Dec  8 18:08:42 2006
> mdadm: /dev/sdd1 appears to be part of a raid array:
>     level=raid5 devices=8 ctime=Fri Dec  8 18:08:42 2006
> mdadm: /dev/sde1 appears to be part of a raid array:
>     level=raid5 devices=8 ctime=Fri Dec  8 18:08:42 2006
> mdadm: /dev/sdf1 appears to be part of a raid array:
>     level=raid5 devices=8 ctime=Fri Dec  8 18:08:42 2006
> mdadm: /dev/sdg1 appears to be part of a raid array:
>     level=raid5 devices=8 ctime=Fri Dec  8 18:08:42 2006
> mdadm: /dev/sdh1 appears to be part of a raid array:
>     level=raid5 devices=8 ctime=Fri Dec  8 18:08:42 2006
> mdadm: /dev/sdi1 appears to be part of a raid array:
>     level=raid5 devices=8 ctime=Fri Dec  8 18:08:42 2006
> mdadm: size set to 312568576K
> Continue creating array? y
> mdadm: array /dev/md5 started.
>
> From what I could tell all the data was still there, so I guessed right and
> got the same data structure.
>
> BUT the new array is ONLY 42gb and there is 8 partitions of 320gb each, so
> it does look like a overflow or similar.
>
> Here's the detailed information of the newly created array (check the array
> and device size):
> # mdadm -D /dev/md5
> /dev/md5:
>         Version : 00.90.03
>   Creation Time : Fri Dec  8 19:07:26 2006
>      Raid Level : raid5
>      Array Size : 40496384 (38.62 GiB 41.47 GB)
>     Device Size : 312568576 (298.09 GiB 320.07 GB)
>    Raid Devices : 8
>   Total Devices : 8
> Preferred Minor : 5
>     Persistence : Superblock is persistent
>
>     Update Time : Fri Dec  8 19:07:26 2006
>           State : clean, degraded, recovering
>  Active Devices : 7
> Working Devices : 8
>  Failed Devices : 0
>   Spare Devices : 1
>
>          Layout : left-symmetric
>      Chunk Size : 64K
>
>  Rebuild Status : 0% complete
>
>            UUID : a24c9a1d:6ff2910a:9e2ad3b1:f5e7c6a5
>          Events : 0.1
>
>     Number   Major   Minor   RaidDevice State
>        0       8       81        0      active sync   /dev/sdf1
>        1       8       97        1      active sync   /dev/sdg1
>        2       8      113        2      active sync   /dev/sdh1
>        3       8      129        3      active sync   /dev/sdi1
>        4       8       65        4      active sync   /dev/sde1
>        5       8       49        5      active sync   /dev/sdd1
>        6       8       33        6      active sync   /dev/sdc1
>        8       8       17        7      spare rebuilding   /dev/sdb1
>
> On Friday 01 December 2006 12:18, you wrote:
> > Hey again :-)
> >
> > I'm starting to suspect that its a bug, since all I did was straight
> > forward and it worked many times before.
> >
> > When I try to stop the array by executing "mdadm -S /dev/md5", then mdadm
> > stall (i'm suspecting it hit an error - maybe the same one).
> >
> > I also tryed to restart the computer and made sure the array didnt
> > auto-start. I then manually started it and the reshape process it shown
> > when
> > executing "cat /proc/mdstat", but it doesnt proceed (it seems stalled
> > right away). When I try to stop it as shown above, it then stall mdadm
> > like before. So I'm able to reproduce the error.
> >
> > I've tryed with kernel 2.6.18.3, 2.6.18.4 and 2.6.19 - with the same
> > results as described above.
> >
> > In case its a bug, then I would really like to help out, so its fixed and
> > noone else will experience it (and I get my array fixed). What can I do
> > to make sure its a bug and if it is, then what kind of information will
> > be helpfull and where should I submit it?
> >
> > I've checked the source code (raid5.c), but there's no comment included
> > in the code, so I cant do much myself since my code experience with C is
> > very small when it comes to kernel programming.
> >
> > On Thursday 30 November 2006 08:04, Jacob Schmidt Madsen wrote:
> > > Hey
> > >
> > > I bought 2 new disks to be included in a big raid5 array.
> > >
> > > I executed:
> > > # mdadm /dev/md5 -a /dev/sdh1
> > > # mdadm /dev/md5 -a /dev/sdi1
> > > # mdadm --grow /dev/md5 --raid-disks=8
> > >
> > > After 12 hours it stalled:
> > > # cat /proc/mdstat
> > > md5 : active raid5 sdc1[6] sdb1[7] sdi1[3] sdh1[2] sdg1[1] sdf1[0]
> > > sde1[4] sdd1[5]
> > >       1562842880 blocks super 0.91 level 5, 64k chunk, algorithm 2
> > > [8/8] [UUUUUUUU]
> > >       [===================>.]  reshape = 98.1% (306783360/312568576)
> > > finish=668.7min speed=144K/sec
> > >
> > > Its been stuck at 306783360/312568576 for hours now.
> > >
> > > When i check the kernel log it is full of "compute_blocknr: map not
> > > correct".
> > >
> > > I guess something went really bad? If someone know what is going on or
> > > if someone know what i can do to fix this.
> > > I would really be sad if all the data was gone.
> > >
> > > Thanks!
> > > -
> > > To unsubscribe from this list: send the line "unsubscribe linux-raid"
> > > in the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
