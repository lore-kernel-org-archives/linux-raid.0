From: "Muskiewicz, Stephen C" <Stephen_Muskiewicz@uml.edu>
Subject: RE: Need help recovering RAID5 array
Date: Mon, 8 Aug 2011 17:41:34 +0000
Message-ID: <D32562736F94C445958A7CC900A95568265503@PORSCHE.fs.uml.edu>
References: <4E3C0BCA.9000407@uml.edu>
 <20110806112910.332d450a@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110806112910.332d450a@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

> -----Original Message-----
> From: NeilBrown [mailto:neilb@suse.de]
> Sent: Friday, August 05, 2011 9:29 PM
> To: Muskiewicz, Stephen C
> Cc: linux-raid@vger.kernel.org
> Subject: Re: Need help recovering RAID5 array
> 
> On Fri, 5 Aug 2011 11:27:06 -0400 Stephen Muskiewicz
> <stephen_muskiewicz@uml.edu> wrote:
> 
> > Hello,
> >
> > I'm hoping to figure out how I can recover a RAID5 array that
> suddenly
> > won't start after one of our servers took a power hit.
> > I'm fairly confident that all the individual disks of the RAID are OK
> > and that I can recover my data (without having to resort to asking my
> > sysadmin to fetch the backup tapes), but despite my extensive
> Googling
> > and reviewing the list archives and mdadm manpage, so far nothing
> I've
> > tried has worked.  Hopefully I am just missing something simple.
> >
> > Background: The server is a Sun X4500 (thumper) running CentOS 5.5.
> I
> > have confirmed using the (Sun provided) "hd" utilities that all of
> the
> > individual disks are online and none of the device names appear to
> have
> > changed from before the power outage.  There are also two other RAID5
> > arrays as well as the /dev/md0 RAID1 OS mirror on the same box that
> did
> > come back cleanly (these have ext3 filesystems on them, the one that
> > failed to come up is just a raw partition used via iSCSI if that
> makes
> > any difference.)  The array that didn't come back is /dev/md/51, the
> > ones that did are /dev/md/52 and /dev/md/53.  I have confirmed that
> all
> > three device files do exist in /dev/md.  (/dev/md51 is also a symlink
> to
> > /dev/md/51, as are /dev/md52 and /dev/md53 for the working arrays).
> We
> > also did quite a bit of testing on the box before we deployed the
> arrays
> > and haven't seen this problem before now, previously all of the
> arrays
> > came back online as expected.  Of course it has also been about 7
> months
> > since the box has gone down but I don't think there were any major
> > changes since then.
> >
> > When I boot the system (tried this twice including a hard power down
> > just to be sure), I see "mdadm: No suitable drives found for
> /dev/md51".
> >   Again the other 2 arrays come up just fine.  I have checked that
> the
> > array is listed in /etc/mdadm.conf
> >
> > (I will apologize for a lack of specific mdadm output in my details
> > below, the network people have conveniently (?) picked this weekend
> to
> > upgrade the network in our campus building and I am currently unable
> to
> > access the server until they are done!)
> >
> > "mdadm --detail /dev/md/51" does (as expected?) display: "mdadm: md
> > device /dev/md51 does not appear to be active"
> >
> > I have done an "mdadm --examine" on each of the drives in the array
> and
> > each one shows a state of "clean" with a status of "U" (and all of
> the
> > other drives in the sequence shown as "u").  The array name and UUID
> > value look good and the "update time" appears to be about when the
> > server lost power.  All the checksums read "correct" as well.  So I'm
> > confident all the individual drives are there and OK.
> >
> > I do have the original mdadm command used to construct the array.
> > (There are 8 active disks in the array plus 2 spares.)  I am using
> > version 1.0 metadata with the -N arg to provide a name for each
> array.
> > So I used this command with the assemble option (but without the -N
> or
> > -u) options:
> >
> > mdadm -A /dev/md/51 /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1
> > /dev/sdf1 /dev/sdg1 /dev/sdh1 /dev/sdi1 /dev/sdj1
> >
> > But this just gave the "no suitable drives found" message.
> >
> > I retried the mdadm command using -N <name> and -u <UUID> options but
> in
> > both cases saw the same result.
> >
> > One odd thing that I noticed was that when I ran an:
> > mdadm --detail --scan
> >
> > The output *does* display all three arrays, but the name of the
> arrays
> > shows up as "ARRAY /dev/md/<arrayname>" rather than the "ARRAY
> > /dev/md/NN" that I would expect (and that is in my /etc/mdadm.conf
> > file).  Not sure if this has anything to do with the problem or not.
> > There are no /dev/md/<arrayname> device files or symlinks on the
> system.
> 
> So maybe the only problem is that the names are missing from /dev/md/
> ???

I tried creating a symlink /dev/md/tsongas_archive to /dev/md/51 but still got the "no suitable drives" error when trying to assemble (using both /dev/md/51 or /dev/md/tsongas_archive)

> 
> When you can access the server again, could you report:
> 
>   cat /proc/mdstat
>   grep md /proc/partitions
>   ls -l /dev/md*
> 
> and maybe
>   mdadm -Ds
>   mdadm -Es
>   cat /etc/mdadm.conf
> 
> just for completeness.
> 
> 
> It certainly looks like your data is all there but maybe not appearing
> exactly where you expect it.
> 

Here is all is:

[root@libthumper1 ~]# cat /proc/mdstat 
Personalities : [raid1] [raid6] [raid5] [raid4] 
md53 : active raid5 sdae1[0] sds1[8](S) sdai1[9](S) sdk1[10] sdam1[6] sdo1[5] sdau1[4] sdaq1[3] sdw1[2] sdaa1[1]
      3418686208 blocks super 1.0 level 5, 128k chunk, algorithm 2 [8/8] [UUUUUUUU]
      
md52 : active raid5 sdad1[0] sdf1[11](S) sdz1[10](S) sdb1[12] sdn1[8] sdj1[7] sdal1[6] sdah1[5] sdat1[4] sdap1[3] sdv1[2] sdr1[1]
      4395453696 blocks super 1.0 level 5, 128k chunk, algorithm 2 [10/10] [UUUUUUUUUU]
      
md0 : active raid1 sdac2[0] sdy2[1]
      480375552 blocks [2/2] [UU]
      
unused devices: <none>

[root@libthumper1 ~]# grep md /proc/partitions 
   9     0  480375552 md0
   9    52 4395453696 md52
   9    53 3418686208 md53


[root@libthumper1 ~]# ls -l /dev/md*
brw-r----- 1 root disk 9, 0 Aug  4 15:25 /dev/md0
lrwxrwxrwx 1 root root    5 Aug  4 15:25 /dev/md51 -> md/51

lrwxrwxrwx 1 root root    5 Aug  4 15:25 /dev/md52 -> md/52

lrwxrwxrwx 1 root root    5 Aug  4 15:25 /dev/md53 -> md/53


/dev/md:
total 0
brw-r----- 1 root disk 9, 51 Aug  4 15:25 51
brw-r----- 1 root disk 9, 52 Aug  4 15:25 52
brw-r----- 1 root disk 9, 53 Aug  4 15:25 53

[root@libthumper1 ~]# mdadm -Ds
ARRAY /dev/md0 level=raid1 num-devices=2 metadata=0.90 UUID=e30f5b25:6dc28a02:1b03ab94:da5913ed
ARRAY /dev/md52 level=raid5 num-devices=10 metadata=1.00 spares=2 name=vmware_storage UUID=c436b591:01a4be5f:2736d7dd:3b97d872
ARRAY /dev/md53 level=raid5 num-devices=8 metadata=1.00 spares=2 name=backup_mirror UUID=9bb89570:675f47be:2fe2f481:ebc33388

[root@libthumper1 ~]# mdadm -Es
ARRAY /dev/md2 level=raid1 num-devices=6 UUID=d08b45a4:169e4351:02cff74a:c70fcb00
ARRAY /dev/md0 level=raid1 num-devices=2 UUID=e30f5b25:6dc28a02:1b03ab94:da5913ed
ARRAY /dev/md/tsongas_archive level=raid5 metadata=1.0 num-devices=8 UUID=41aa414e:cfe1a5ae:3768e4ef:0084904e name=tsongas_archive
ARRAY /dev/md/vmware_storage level=raid5 metadata=1.0 num-devices=10 UUID=c436b591:01a4be5f:2736d7dd:3b97d872 name=vmware_storage
ARRAY /dev/md/backup_mirror level=raid5 metadata=1.0 num-devices=8 UUID=9bb89570:675f47be:2fe2f481:ebc33388 name=backup_mirror

[root@libthumper1 ~]# cat /etc/mdadm.conf

# mdadm.conf written out by anaconda
DEVICE partitions
MAILADDR sysadmins
MAILFROM root@libthumper1.uml.edu
ARRAY /dev/md0 level=raid1 num-devices=2 uuid=e30f5b25:6dc28a02:1b03ab94:da5913ed
ARRAY /dev/md/51 level=raid5 num-devices=8 spares=2 name=tsongas_archive uuid=41aa414e:cfe1a5ae:3768e4ef:0084904e
ARRAY /dev/md/52 level=raid5 num-devices=10 spares=2 name=vmware_storage uuid=c436b591:01a4be5f:2736d7dd:3b97d872
ARRAY /dev/md/53 level=raid5 num-devices=8 spares=2 name=backup_mirror uuid=9bb89570:675f47be:2fe2f481:ebc33388

It looks like the md51 device isn't appearing in /proc/partitions, not sure why that is?

I also just noticed the /dev/md2 that appears in the mdadm -Es output, not sure what that is but I don't recognize it as anything that was previously on that box.  (There is no /dev/md2 device file).  Not sure if that is related at all or just a red herring...

For good measure, here's some actual mdadm -E output for the specific drives (I won't include all as they all seem to be about the same):

[root@libthumper1 ~]# mdadm -E /dev/sd[qui]1
/dev/sdi1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x0
     Array UUID : 41aa414e:cfe1a5ae:3768e4ef:0084904e
           Name : tsongas_archive
  Creation Time : Thu Feb 24 11:43:37 2011
     Raid Level : raid5
   Raid Devices : 8

 Avail Dev Size : 976767728 (465.76 GiB 500.11 GB)
     Array Size : 6837372416 (3260.31 GiB 3500.73 GB)
  Used Dev Size : 976767488 (465.76 GiB 500.10 GB)
   Super Offset : 976767984 sectors
          State : clean
    Device UUID : 750e6410:661d4838:0a5f7581:7c110cf1

    Update Time : Thu Aug  4 06:41:23 2011
       Checksum : 20bb0567 - correct
         Events : 18446744073709551615

         Layout : left-symmetric
     Chunk Size : 128K
    Array Slot : 5 (0, 1, 2, 3, 4, 5, 6, 7)
   Array State : uuuuuUuu

/dev/sdq1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x0
     Array UUID : 41aa414e:cfe1a5ae:3768e4ef:0084904e
           Name : tsongas_archive
  Creation Time : Thu Feb 24 11:43:37 2011
     Raid Level : raid5
   Raid Devices : 8

 Avail Dev Size : 976767728 (465.76 GiB 500.11 GB)
     Array Size : 6837372416 (3260.31 GiB 3500.73 GB)
  Used Dev Size : 976767488 (465.76 GiB 500.10 GB)
   Super Offset : 976767984 sectors
          State : clean
    Device UUID : 3a1b81cc:8b03dec1:ce27abeb:33598b7b

    Update Time : Thu Aug  4 06:41:23 2011
       Checksum : 5b2308c8 - correct
         Events : 18446744073709551615
         Layout : left-symmetric
     Chunk Size : 128K

    Array Slot : 0 (0, 1, 2, 3, 4, 5, 6, 7)
   Array State : Uuuuuuuu

/dev/sdu1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x0
     Array UUID : 41aa414e:cfe1a5ae:3768e4ef:0084904e
           Name : tsongas_archive
  Creation Time : Thu Feb 24 11:43:37 2011
     Raid Level : raid5
   Raid Devices : 8

 Avail Dev Size : 976767728 (465.76 GiB 500.11 GB)
     Array Size : 6837372416 (3260.31 GiB 3500.73 GB)
  Used Dev Size : 976767488 (465.76 GiB 500.10 GB)
   Super Offset : 976767984 sectors
          State : clean
    Device UUID : df0c9e89:bb801e58:c17c0adf:57625ef7

    Update Time : Thu Aug  4 06:41:23 2011
       Checksum : 1db2d5b5 - correct
         Events : 18446744073709551615

         Layout : left-symmetric
     Chunk Size : 128K

    Array Slot : 1 (0, 1, 2, 3, 4, 5, 6, 7)
   Array State : uUuuuuuu

Is that huge number for the event count perhaps a problem? 

> 
> 
> >
> > I *think* my next step based on the various posts I've read would be
> to
> > try the same mdadm -A command with --force, but I'm a little wary of
> > that and want to make sure I actually understand what I'm doing so I
> > don't screw up the array entirely and lose all my data!  I'm not sure
> if
> > I should be giving it *all* of the drives as an arg, including the
> > spares or should I just pass it the active drives?  Should I use the
> > --raid-devices and/or --spare-devices options?  Anything else I
> should
> > include or not include?
> 
> When you do a "-A --force" you do give it all they drives that might be
> part
> of the array so it has maximum information.
> --spare-devices and --raid-devices are not meaningful with --assemble.
> 
> 

OK so I tried with the --force and here's what I got (BTW the device names are different from my original email since I didn't have access to the server before, but I used the real device names exactly as when I originally created the array, sorry for any confusion)

mdadm -A /dev/md/51 --force /dev/sdq1 /dev/sdu1 /dev/sdao1 /dev/sdas1 /dev/sdag1 /dev/sdi1 /dev/sdm1 /dev/sda1 /dev/sdak1 /dev/sde1

mdadm: forcing event count in /dev/sdq1(0) from -1 upto -1
mdadm: forcing event count in /dev/sdu1(1) from -1 upto -1
mdadm: forcing event count in /dev/sdao1(2) from -1 upto -1
mdadm: forcing event count in /dev/sdas1(3) from -1 upto -1
mdadm: forcing event count in /dev/sdag1(4) from -1 upto -1
mdadm: forcing event count in /dev/sdi1(5) from -1 upto -1
mdadm: forcing event count in /dev/sdm1(6) from -1 upto -1
mdadm: forcing event count in /dev/sda1(7) from -1 upto -1
mdadm: failed to RUN_ARRAY /dev/md/51: Input/output error

Additionally I got a bunch of messages on the console, first was:

Kicking non-fresh sdak1 from array

This was repeated for each device, *except* the first drive (/dev/sdq1) and the last spare (/dev/sde1).  

After those messages was (sorry if not exact, had to retype as cut/paste from KVM console wasn't working):

raid5: not enough operational devices for md51 (7/8 failed)
RAID5 conf printout:
--- rd:8 wd:1 fd:7
disk 0, o11, dev:sdq1

After this, here's the output of mdadm --detail /dev/md/51:

/dev/md/51:
        Version : 1.00
  Creation Time : Thu Feb 24 11:43:37 2011
     Raid Level : raid5
  Used Dev Size : 488383744 (465.76 GiB 500.10 GB)
   Raid Devices : 8
  Total Devices : 1
Preferred Minor : 51
    Persistence : Superblock is persistent

    Update Time : Thu Aug  4 06:41:23 2011
          State : active, degraded, Not Started
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 128K

           Name : tsongas_archive
           UUID : 41aa414e:cfe1a5ae:3768e4ef:0084904e
         Events : 18446744073709551615

    Number   Major   Minor   RaidDevice State
       0      65        1        0      active sync   /dev/sdq1
       1       0        0        1      removed
       2       0        0        2      removed
       3       0        0        3      removed
       4       0        0        4      removed
       5       0        0        5      removed
       6       0        0        6      removed
       7       0        0        7      removed


So even with --force, the results don't look very promising.  Could it have something to do with the "non-fresh" or the really large event?

Anything further I can try, aside from going to fetch the tape backups? :-0

Thanks much!
-steve
 

