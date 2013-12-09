From: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Subject: Re: Raid1 where Event Count off my 1 cannot assemble --force
Date: Sun, 08 Dec 2013 18:38:58 -0600
Message-ID: <52A51122.3030604@suddenlinkmail.com>
References: <52A44778.8040502@suddenlinkmail.com> <alpine.DEB.2.02.1312081157100.24602@uplift.swm.pp.se> <52A4B311.6040204@suddenlinkmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52A4B311.6040204@suddenlinkmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/08/2013 11:57 AM, David C. Rankin wrote:
> On 12/08/2013 04:57 AM, Mikael Abrahamsson wrote:
>> On Sun, 8 Dec 2013, David C. Rankin wrote:
>>
>>> Guys,
>>>
>>>  I have an older box that is a fax server where the Event Count for /dev/md1 is
>>> off by 1, but the array cannot be reassembled with --assemble --force /dev/dm1
>>> /dev/sda5 /dev/sdb5.
>>
>> What are the messages displayed in "dmesg" when you try to use this command?
>>
> 
> Mikael,
> 
>   Following the commands:
> 
> # mdadm --stop /dev/md1
> # mdadm --assemble --force /dev/dm1 /dev/sd[ab]5
> 
>   The messages captured in the logs are:
> 
> Rescue Kernel: md: md1: stopped.
> Rescue Kernel: md: unbind<sda5>
> Rescue Kernel: md: export_rdev(sda5)
> Rescue Kernel: md: unbind<sdb5>
> Rescue Kernel: md: export_rdev(sdb5)
> Rescue Kernel: md: md1: stopped.
> Rescue Kernel: md: md1 raid array is not clean -- starting background reconstruction
> Rescue Kernel: md: raid1: raid set md1 active with 2 out of 2 mirrors
> Rescue Kernel: md1: bitmap file is out of date (148 < 149) -- forcing full recovery
> Rescue Kernel: md1: bitmap file is out of date, doing full recovery
> Rescue Kernel: md1: bitmap initialisation failed: -5
> Rescue Kernel: md1: failed to create bitmap (-5)
> 
> 
>   That's it for the log, then on the command line I have:
> 
> mdadm: failed to RUN_ARRAY /dev/md1: Input/Output error
> 
>   What should I try next? Don't hesitate to ask if you need any additional
> information, I'll provide whatever is necessary. Thanks.
> 

Here is additional information with --verbose given:

nemtemp:~ # cat /proc/mdstat
Personalities : [raid1]
md2 : active raid1 sda7[0] sdb7[1]
      221929772 blocks super 1.0 [2/2] [UU]
      bitmap: 0/424 pages [0KB], 256KB chunk

md1 : inactive sda5[0] sdb5[1]
      41945504 blocks super 1.0

md0 : active raid1 sda1[0] sdb1[1]
      104376 blocks super 1.0 [2/2] [UU]
      bitmap: 0/7 pages [0KB], 8KB chunk

unused devices: <none>

nemtemp:~ # mdadm --stop /dev/md1
mdadm: stopped /dev/md1

nemtemp:~ # cat /proc/mdstat
Personalities : [raid1]
md2 : active raid1 sda7[0] sdb7[1]
      221929772 blocks super 1.0 [2/2] [UU]
      bitmap: 0/424 pages [0KB], 256KB chunk

md0 : active raid1 sda1[0] sdb1[1]
      104376 blocks super 1.0 [2/2] [UU]
      bitmap: 0/7 pages [0KB], 8KB chunk

unused devices: <none>

nemtemp:~ # mdadm --verbose --assemble --force /dev/md1 /dev/sd[ab]5
mdadm: looking for devices for /dev/md1
mdadm: /dev/sda5 is identified as a member of /dev/md1, slot 0.
mdadm: /dev/sdb5 is identified as a member of /dev/md1, slot 1.
mdadm: added /dev/sdb5 to /dev/md1 as 1
mdadm: added /dev/sda5 to /dev/md1 as 0
mdadm: failed to RUN_ARRAY /dev/md1: Input/output error

  The log from the start attempt:

Dec  9 00:16:11 Rescue kernel: md: md1 stopped.
Dec  9 00:16:11 Rescue kernel: md: bind<sdb5>
Dec  9 00:16:11 Rescue kernel: md: bind<sda5>
Dec  9 00:16:11 Rescue kernel: md: md1: raid array is not clean -- starting
background reconstruction
Dec  9 00:16:11 Rescue kernel: raid1: raid set md1 active with 2 out of 2 mirrors
Dec  9 00:16:11 Rescue kernel: md1: bitmap file is out of date (148 < 149) --
forcing full recovery
Dec  9 00:16:11 Rescue kernel: md1: bitmap file is out of date, doing full recovery
Dec  9 00:16:12 Rescue kernel: md1: bitmap initialisation failed: -5
Dec  9 00:16:12 Rescue kernel: md1: failed to create bitmap (-5)
Dec  9 00:16:12 Rescue kernel: md: pers->run() failed ...

nemtemp:~ # cat /proc/mdstat
Personalities : [raid1]
md2 : active raid1 sda7[0] sdb7[1]
      221929772 blocks super 1.0 [2/2] [UU]
      bitmap: 0/424 pages [0KB], 256KB chunk

md1 : inactive sda5[0] sdb5[1]
      41945504 blocks super 1.0

md0 : active raid1 sda1[0] sdb1[1]
      104376 blocks super 1.0 [2/2] [UU]
      bitmap: 0/7 pages [0KB], 8KB chunk

unused devices: <none>

  I'm not sure how to proceed safely from here. Is there anything else I should
try before attempting to --create the array again? If we do create the array
with 1 drive and "missing", should I then use --add or --re-add to add the other
drive? Also, since /dev/sda5 shows Events: 148 and /dev/sdb5 shows Events: 149,
should I choose /dev/sdb5 as the one to preserve and let "missing" take the
place of /dev/sda5? If so, then does the following create statement look correct:

mdadm --create --verbose --level=1 --metadata=1.0 --raid-devices=2 \
/dev/md1 /dev/sdb5 missing

  Should I also use --force?

  If attempting to assemble with "missing" and the create command gives problems
due to the unused device still having the same minor-number, is it better to
--zero-superblock the on the device not included as "missing" or is it better to
just unplug it and preserve the superblock data in case it is needed?

  Sorry for all the questions, but I just want to make sure I don't do something
to compromise the data. With the information for both drives looking good with
--examine, the (Update Time : Tue Nov 19 15:28:38 2013) being identical, and the
Events being off by only 1, I can't see a reason the drives should not just
assemble and run as it is. What say the experts?

  Here is the --detail and --examine information for the drives for completeness:

nemtemp:~ # mdadm --detail /dev/md1
/dev/md1:
        Version : 01.00.03
  Creation Time : Thu Aug 21 06:43:22 2008
     Raid Level : raid1
  Used Dev Size : 20972752 (20.00 GiB 21.48 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 1
    Persistence : Superblock is persistent

    Update Time : Tue Nov 19 15:28:38 2013
          State : active, Not Started
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           Name : 1
           UUID : e45cfbeb:77c2b93b:43d3d214:390d0f25
         Events : 148

    Number   Major   Minor   RaidDevice State
       0       8        5        0      active sync   /dev/sda5
       1       8       21        1      active sync   /dev/sdb5

nemtemp:/ # mdadm -E /dev/sda5
/dev/sda5:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x1
     Array UUID : e45cfbeb:77c2b93b:43d3d214:390d0f25
           Name : 1
  Creation Time : Thu Aug 21 06:43:22 2008
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 41945504 (20.00 GiB 21.48 GB)
     Array Size : 41945504 (20.00 GiB 21.48 GB)
   Super Offset : 41945632 sectors
          State : clean
    Device UUID : e0c1c580:db4d853e:6fac1c8f:fb5399d7

Internal Bitmap : -81 sectors from superblock
    Update Time : Tue Nov 19 15:28:38 2013
       Checksum : d37d1086 - correct
         Events : 148


    Array Slot : 0 (0, 1)
   Array State : Uu

nemtemp:/ # mdadm -E /dev/sdb5
/dev/sdb5:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x1
     Array UUID : e45cfbeb:77c2b93b:43d3d214:390d0f25
           Name : 1
  Creation Time : Thu Aug 21 06:43:22 2008
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 41945504 (20.00 GiB 21.48 GB)
     Array Size : 41945504 (20.00 GiB 21.48 GB)
   Super Offset : 41945632 sectors
          State : active
    Device UUID : 6edfa3f8:c8c4316d:66c19315:5eda0911

Internal Bitmap : -81 sectors from superblock
    Update Time : Tue Nov 19 15:28:38 2013
       Checksum : 39ef40a5 - correct
         Events : 149


    Array Slot : 1 (0, 1)
   Array State : uU



-- 
David C. Rankin, J.D.,P.E.
