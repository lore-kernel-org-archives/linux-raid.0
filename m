From: bernd@rhm.de
Subject: sparegroups + sparemove
Date: Mon, 26 Jul 2004 14:06:07 +0200 (MESZ)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200407261206.OAA28774@node130.rhm.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
Cc: Roger Diller <roger@rhm.de>
List-Id: linux-raid.ids

Hi mirror freaks,

we are using sw-raid and its a pretty fine thing. After a while playing 
around with sparegroups and mdadm -f/-r/-a and watching how fine the
sparedisks are moved within the sparegroups the system stops moving 
sparedisks from one array to another.

It is caused by wrong counters for sparedisks. The counters become wrong
as already mentioned in a former thread by Guy. This is no problem if the
counters are only showed in outputs but in this case the functionality
isn't given any more!

My question: is there a secure way to adjust the counters in case they are
wrong? Ok, it's easy to write a small programm reading the superblock and
writing it back with corrected numbers but can I do that on a working array?

For us it isn't possible to upgrade to kernel 2.6 which should fix the 
problem at this time for many reasons....

Greetings Bernd Rieke

--------------------------------------------------------------------------

Here our investigations, the two arrays are:

/dev/md2:
        Version : 00.90.00
  Creation Time : Thu May 20 22:55:59 2004
     Raid Level : raid1
     Array Size : 143653120 (136.100 GiB 147.10 GB)
    Device Size : 143653120 (136.100 GiB 147.10 GB)
   Raid Devices : 2
  Total Devices : 1
Preferred Minor : 2
    Persistence : Superblock is persistent
                                          
    Update Time : Sat Jul 10 16:15:21 2004
          State : dirty, no-errors
 Active Devices : 1
Working Devices : 2
 Failed Devices : -1
  Spare Devices : 1          <<<<<<<<<<<<<<<<<< wrong !!!!!!!!!!!!!!!
    Number   Major   Minor   RaidDevice State
       0       8       81        0      active sync   /dev/sda
       1       8       17        1      faulty removed
           UUID : 666644bc:fd696534:33349994:a71194a3
         Events : 0.211

/dev/md3:
        Version : 00.90.00
  Creation Time : Thu May 20 23:40:25 2004
     Raid Level : raid1
     Array Size : 143653120 (136.100 GiB 147.10 GB)
    Device Size : 143653120 (136.100 GiB 147.10 GB)
   Raid Devices : 2
  Total Devices : 3
Preferred Minor : 3
    Persistence : Superblock is persistent
                                          
    Update Time : Sun Jul 11 01:13:31 2004
          State : dirty, no-errors
 Active Devices : 2
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 5      <<<<<<<<<<<<<<<<<<<<<<<< even wrong !!!!
    Number   Major   Minor   RaidDevice State
       0       8       33        0      active sync   /dev/sdc
       1       8       97        1      active sync   /dev/sdd
       2       8      113        2      spare   /dev/sde
           UUID : 9fb3650a:0a054f9e:00f14fde:8fd31b65
         Events : 0.137

As one can see in the code of mdadm-1.5.0/Monitor.c the move between the
group is only initiated if the sparecount in the degrated array is zero
(which makes sense:-)). In our case it's 1 so no sparemove will take place.

./mdadm-1.5.0/Monitor.c line 364 ff
-----------------------------------
....
....
/* If an array has active < raid && spare == 0 && spare_group != NULL
 * Look for another array with spare > 0 and active == raid and same spare_group
 *  if found, choose a device and hotremove/hotadd
 */
 for (st = statelist; st; st=st->next)
     if (st->active < st->raid &&
         st->spare == 0 &&           <<<<<<<< md2 isn't zero, but has no spare
         st->spare_group != NULL) {
         struct state *st2;
         for (st2=statelist ; st2 ; st2=st2->next)
             if (st2 != st &&
                 st2->spare > 0 &&
                 st2->active == st2->raid &&
                 st2->spare_group != NULL &&
                 strcmp(st->spare_group, st2->spare_group) == 0) {
                 /* try to remove and add */
                 .....
