From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: Re: recovery from multiple failures
Date: Sun, 08 Jan 2012 17:43:11 -0800
Message-ID: <fatpt8x1so.ln2@goaway.wombat.san-francisco.ca.us>
References: <eu9pt8xa4l.ln2@goaway.wombat.san-francisco.ca.us>
 <4F0A30CD.60904@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2012-01-09, Phil Turmel <philip@turmel.org> wrote:
>
> On 01/08/2012 03:12 PM, Keith Keller wrote:
>> 
>> I'm going to include the entire mdadm --examine output below, but as I
>> was looking at it, I was wondering if the analogous scenario to the wiki
>> situation is to look at the array slots:
>> 
>> $ grep Slot raid.status |cut -f1 -d '('
>>     Array Slot : 0 
>>     Array Slot : 0 
>>     Array Slot : 13 
>>     Array Slot : 4 
>>     Array Slot : 10 
>>     Array Slot : 6 
>>     Array Slot : 7 
>>     Array Slot : 9 
>>     Array Slot : 8 
>>     Array Slot : 11 
>>     Array Slot : 2 
>>     Array Slot : 4 
>>     Array Slot : 12 
>
> You are confusing "Slot" with "Role", aka "Raid Device".  All of your devices
> report their own role between 0 and 8, except for slot #12, which is "empty".

That brings up another question, then: how did you determine the role?
Is it the capital U in the Array State line, or is it something obvious
I'm missing, or something unobvious that I should look at?  I mostly
just want to know what to look for in the future.

> - From what I can see, you should use "--assemble --force".  The wiki does
> not recommend this, but is wrong.  There is no advantage to "--create
> - --assume-clean" in this situation, and opportunities for catastrophic
> destruction.  Only if "--assemble --force" fails, and not from "device in use"
> reports, should you move to "--create".

So, if a rebuild already started with new disks, will --force get
confused by the array's state?  Or is md smart enough to look at the
last update times to assemble the disks that are most up to date, or are
otherwise smart enough not to assemble disks in a really bad way?

> Another word of warning:  Your --examine output reports Data Offset == 264
> on all of your devices.  You cannot use "--create --assume-clean" with a
> new version of mdadm, as it will create with the new default Data Offset of
> 2048.

Great, thanks for the pointer.  I currently have version 2.6.9 of mdadm,
which IIRC is fairly old.

> This is very good.  And clearly shows that "--assemble --force" should
> succeed.  You will probably want to run an fsck to deal with the ten minutes
> of inconsistent data, but that should be the only losses.  A "check" or
> "repair" pass should also be run.

Okay: here's what happened when I made the attempt:

#  mdadm  --assemble --scan --uuid=24363b01:90deb9b5:4b51e5df:68b8b6ea
#  --config=mdadm.conf  --force
/dev/md0: File exists
mdadm: forcing event count in /dev/sdb1(0) from 106059 upto 106120
mdadm: forcing event count in /dev/sdg1(3) from 106059 upto 106120
mdadm: forcing event count in /dev/sdf1(6) from 106059 upto 106120
mdadm: forcing event count in /dev/sdh1(7) from 106059 upto 106120
mdadm: forcing event count in /dev/sdj1(8) from 106059 upto 106120
mdadm: failed to RUN_ARRAY /dev/md/0: Input/output error

Here's what appeared in dmesg:

md/raid:md0: not clean -- starting background reconstruction
md/raid:md0: device sdb1 operational as raid disk 0
md/raid:md0: device sdj1 operational as raid disk 8
md/raid:md0: device sdh1 operational as raid disk 7
md/raid:md0: device sdf1 operational as raid disk 6
md/raid:md0: device sdi1 operational as raid disk 5
md/raid:md0: device sde1 operational as raid disk 4
md/raid:md0: device sdk1 operational as raid disk 2
md/raid:md0: device sdc1 operational as raid disk 1
md/raid:md0: allocated 9522kB
md/raid:md0: cannot start dirty degraded array.
RAID conf printout:
 --- level:6 rd:9 wd:8
 disk 0, o:1, dev:sdb1
 disk 1, o:1, dev:sdc1
 disk 2, o:1, dev:sdk1
 disk 3, o:1, dev:sdg1
 disk 4, o:1, dev:sde1
 disk 5, o:1, dev:sdi1
 disk 6, o:1, dev:sdf1
 disk 7, o:1, dev:sdh1
 disk 8, o:1, dev:sdj1
md/raid:md0: failed to run raid set.
md: pers->run() failed ...

And finally, mdadm -D:

# mdadm -D /dev/md0
/dev/md0:
        Version : 1.01
  Creation Time : Thu Sep 29 21:26:35 2011
     Raid Level : raid6
  Used Dev Size : 1953113920 (1862.63 GiB 1999.99 GB)
   Raid Devices : 9
  Total Devices : 10
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Sat Jan  7 22:50:29 2012
          State : active, degraded, Not Started
 Active Devices : 8
Working Devices : 10
 Failed Devices : 0
  Spare Devices : 2

     Chunk Size : 64K

           Name : 0
           UUID : 24363b01:90deb9b5:4b51e5df:68b8b6ea
         Events : 106120

    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
      13       8       33        1      active sync   /dev/sdc1
      11       8      161        2      active sync   /dev/sdk1
       6       8       97        3      spare rebuilding   /dev/sdg1
       4       8       65        4      active sync   /dev/sde1
       9       8      129        5      active sync   /dev/sdi1
      10       8       81        6      active sync   /dev/sdf1
       7       8      113        7      active sync   /dev/sdh1
       8       8      145        8      active sync   /dev/sdj1

      12       8      177        -      spare   /dev/sdl1

Now I really don't know where to go from here.  Any thoughts?  Will
doing a check help at this point, or just make things worse?

--keith

-- 
kkeller@wombat.san-francisco.ca.us


