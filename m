From: Jean Jordaan <jean@upfrontsystems.co.za>
Subject: Re: Recovering RAID5 array
Date: Tue, 20 Jan 2004 10:08:53 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <400CE215.2050502@upfrontsystems.co.za>
References: <400CD0BF.2010808@upfrontsystems.co.za> <16396.53737.911347.812076@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16396.53737.911347.812076@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> mdadm --assemble /dev/md0 --force /dev/hd[abc]3
> 
> should put it back together for you.

No luck ..

cdimage root # mdadm --verbose --assemble /dev/md0 --force /dev/hda3 /dev/hdb3 
/dev/hdc3
mdadm: looking for devices for /dev/md0
mdadm: /dev/hda3 is identified as a member of /dev/md0, slot 3.
mdadm: /dev/hdb3 is identified as a member of /dev/md0, slot 4.
mdadm: /dev/hdc3 is identified as a member of /dev/md0, slot 2.
mdadm: no uptodate device for slot 0 of /dev/md0
mdadm: no uptodate device for slot 1 of /dev/md0
mdadm: added /dev/hda3 to /dev/md0 as 3
mdadm: added /dev/hdb3 to /dev/md0 as 4
mdadm: added /dev/hdc3 to /dev/md0 as 2
mdadm: /dev/md0 assembled from 1 drive - not enough to start it (use --run to 
insist).

cdimage root # cat /proc/mdstat
Personalities : [raid5]
read_ahead not set
md0 : inactive ide/host0/bus1/target0/lun0/part3[2] 
ide/host0/bus0/target1/lun0/part3[4] ide/host0/bus0/target0/lun0/part3[3]
       0 blocks
unused devices: <none>
cdimage root # mdadm --verbose --examine /dev/hda3
/dev/hda3:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : dd5156aa:9157bc3c:9500db42:445b91fe
   Creation Time : Wed Dec 17 11:44:50 2003
      Raid Level : raid5
     Device Size : 38001664 (36.24 GiB 38.91 GB)
    Raid Devices : 3
   Total Devices : 4
Preferred Minor : 0

     Update Time : Mon Jan 19 07:41:21 2004
           State : dirty, no-errors
  Active Devices : 1
Working Devices : 3
  Failed Devices : 1
   Spare Devices : 2
        Checksum : 736178ae - correct
          Events : 0.82

          Layout : left-symmetric
      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     3       3        3        3        /dev/ide/host0/bus0/target0/lun0/part3
    0     0       0        0        0      faulty removed
    1     1       0        0        1      faulty removed
    2     2      22        3        2      active sync 
/dev/ide/host0/bus1/target0/lun0/part3
    3     3       3        3        3        /dev/ide/host0/bus0/target0/lun0/part3
    4     4       3       67        4        /dev/ide/host0/bus0/target1/lun0/part3

I think /dev/hdb3 was the one originally marked faulty,
and I wrongly --set-faulty /dev/hda3 ..

-- 
Jean Jordaan
http://www.upfrontsystems.co.za

