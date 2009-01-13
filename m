From: Wolfgang Denk <wd@denx.de>
Subject: Re: Strange array state
Date: Wed, 14 Jan 2009 00:25:35 +0100
Message-ID: <20090113232535.34E5B832E425@gemini.denx.de>
References: <20090112120517.D4653832E425@gemini.denx.de> <496BD77B.508@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <496BD77B.508@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Bill,

thanks for the help.

In message <496BD77B.508@tmr.com> you wrote:
...
> > I see somewhat strange reports for a RAID6 array of 6 disks:
> >
> > # cat /proc/mdstat 
> > Personalities : [raid1] [raid6] [raid5] [raid4] 
> > md2 : active raid6 sdc[0] sdh[6] sdg[4] sdf[3] sde[2] sdd[1]
> >       1953545792 blocks super 1.0 level 6, 16k chunk, algorithm 2 [6/6] [UUUUUU]
> > ...
> >
> > Oops? I see disks 0, 1, 2, 3, 4, and 6 - why 6 and not 5 ?
> >
> > If I check the devices, I see for example this:
> >
> > # mdadm -Q --examine /dev/sdc
> > mdadm: metadata format 1.00 unknown, ignored.
> > /dev/sdc:
> >           Magic : a92b4efc
> >         Version : 1.0
> >     Feature Map : 0x0
> >      Array UUID : ed815df1:a9df9e8e:a65e948f:17ef5557
> >            Name : 1
> >   Creation Time : Sat Apr 12 00:02:52 2008
> >      Raid Level : raid6
> >    Raid Devices : 6
> >
> >  Avail Dev Size : 976772896 (465.76 GiB 500.11 GB)
> >      Array Size : 3907091584 (1863.05 GiB 2000.43 GB)
> >    Super Offset : 976773152 sectors
> >           State : clean
> >     Device UUID : bc286549:0267dd3b:ce683a7c:66341111
> >
> >     Update Time : Mon Jan 12 13:02:52 2009
> >        Checksum : 62b5e607 - correct
> >          Events : 35060
> >
> >      Chunk Size : 16K
> >
> >     Array Slot : 0 (0, 1, 2, 3, 4, failed, 5)
> >    Array State : Uuuuuu 1 failed
> >
> > What does the "metadata format 1.00 unknown, ignored." mean, and how
> > can I fix it?  And why does it report "Array State ... 1 failed"?
> >
> >
> > [This is on a standard Fedora 10 system.]
> >
> > Any help welcome - thanks in advance.
> >   
> 
> I have seen similar on a system which has a drive fail and which rebuilt 
> on a spare. Also, check you /etc/mdadm.conf file and be sure it uses 
> PARTITIONS and UUID to build the array, and isn't looking for some 
> missing device.

Well, we did have a failure on this array before:

| A Fail event had been detected on md device /dev/md2.
| 
| It could be related to component device /dev/sdh.
| 
| Faithfully yours, etc.
| 
| P.S. The /proc/mdstat file currently contains the following:
| 
| Personalities : [raid1] [raid6] [raid5] [raid4] 
| md2 : active raid6 sdh[5](F) sdc[0] sdg[4] sdf[3] sde[2] sdd[1]
|       1953545792 blocks super 1.0 level 6, 16k chunk, algorithm 2 [6/5] [UUUUU_]
|       [>....................]  recovery =  0.0% (358048/488386448) finish=1339.8min speed=6069K/sec

And the failed device was # 5 which is now skipped. 

> Report back, if none of that helps someone else will have ideas by 
> then.  ;-)

Here is some additional information:

# mdadm -Q --detail --scan /dev/md2
mdadm: metadata format 1.00 unknown, ignored.
/dev/md2:
        Version : 1.00
  Creation Time : Sat Apr 12 00:02:52 2008
     Raid Level : raid6
     Array Size : 1953545792 (1863.05 GiB 2000.43 GB)
  Used Dev Size : 976772896 (931.52 GiB 1000.22 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 2
    Persistence : Superblock is persistent

    Update Time : Tue Jan 13 23:08:07 2009
          State : clean
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0

     Chunk Size : 16K

           Name : 1
           UUID : ed815df1:a9df9e8e:a65e948f:17ef5557
         Events : 35060

    Number   Major   Minor   RaidDevice State
       0       8       32        0      active sync   /dev/sdc
       1       8       48        1      active sync   /dev/sdd
       2       8       64        2      active sync   /dev/sde
       3       8       80        3      active sync   /dev/sdf
       4       8       96        4      active sync   /dev/sdg
       6       8      112        5      active sync   /dev/sdh
# cat /etc/mdadm.conf 
...
ARRAY /dev/md2 level=raid6 num-devices=6 metadata=1.00 name=1 UUID=ed815df1:a9df9e8e:a65e948f:17ef5557


Questions:

1) Should I be worried bout the gap in the numbering? If yes, how to fix that?

2) Should I be worried about the "mdadm: metadata format 1.00 unknown, ignored."
   messages? If yes, how to fix that?

Thanks in advance.

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
I have made mistakes, but have never made the mistake of  claiming  I
never made one.                                     - James G. Bennet
