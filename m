From: Mitchell Laks <mlaks@verizon.net>
Subject: mdadm --run required to start raid1 device /dev/md0 after removal of
 one drive. why?
Date: Sun, 26 Jun 2005 02:50:24 -0400
Message-ID: <200506260250.24186.mlaks@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

My system has 4 250GB hard drives:

/dev/md0  /dev/hdb1, /dev/hdg1
/dev/md1  /dev/hdc1,  /dev/hde1

My data is static, so 
I decided to take a single device from each raid off line and keep it safe.

This was the content of the /etc/mdadm/mdadm.conf file at that moment.

# cat mdadm.conf.6.25.2005
DEVICE /dev/hdb1 /dev/hdc1  /dev/hdg1 /dev/hde1

ARRAY /dev/md1 level=raid1 num-devices=2 
UUID=19def19e:3995fe1e:5470d62a:c44b06c
   devices=/dev/hdc1,/dev/hde1
ARRAY /dev/md0 level=raid1 num-devices=2 
UUID=ca17eac7:01b4ccb7:c768ca76:7b9febd
   devices=/dev/hdb1,/dev/hdg1


So I edited mdadm.conf to  changing  num-devices=2 to num-devices=1:

A1:~# cat /etc/mdadm/mdadm.conf
DEVICE /dev/hdb1 /dev/hdc1

ARRAY /dev/md1 level=raid1 num-devices=1 
UUID=19def19e:3995fe1e:5470d62a:c44b06c
   devices=/dev/hdc1
ARRAY /dev/md0 level=raid1 num-devices=1 
UUID=ca17eac7:01b4ccb7:c768ca76:7b9febd
   devices=/dev/hdb1


And then I turned off the system, and pulled out both of  the drives /dev/hdg1 
and /dev/hde1.

Then I rebooted the sytem, and the system stopped during the standard boot 
point where it runs fsck.ext3 on the mounted drives. 
because the system was unable to start the devices /dev/md0 or /dev/md1

It refused to boot until I removed the mount points /dev/md0 and /dev/md1 from 
/etc/fstab.

Now I naively thought that /dev/md0 and /dev/md1  would both start naturally,
with the new mdadm.conf and simply indicate a failed device in 
cat /proc/mdstat?

That is what hardware raid does ... I think ...
  
Well after I commented out /dev/md* from /etc/fstab
I  got the system to boot, and  I ran

mdadm -A /dev/md0 /dev/hdb1

and the system said to me:

mdadm: /dev/md0 assembled from 1 drive, need all 2 to start it.
use --run to insist.

Now if I do 
mmdadm -A --run /dev/md0 /dev/hdb1 then it starts.

similarly with /dev/md1.

But what can I do to restore the previous situation with the old /etc/fstab
so that I can reboot and have the system 
remount itself without doing this --run by hand each time? 

and also what is rhe --run needed here for??

this is the current content of 
mdadm --detail --scan

ARRAY /dev/md0 level=raid1 num-devices=2 
UUID=ca17eac7:01b4ccb7:c768ca76:7b9febd
   devices=/dev/hdb1
ARRAY /dev/md1 level=raid1 num-devices=2 
UUID=19def19e:3995fe1e:5470d62a:c44b06c
   devices=/dev/hdc1

while i had put num-devices=1 in the new mdadm.conf . Is this the problem?

I am running debian sarge 
A1:~# uname -a
Linux A1 2.6.8-1-386 #1 Thu Nov 25 04:24:08 UTC 2004 i686 GNU/Linux
A1:~# mdadm -V
mdadm - v1.9.0 - 04 February 2005

also here is the output of 

A1:~# mdadm -E /dev/hdb1
/dev/hdb1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : ca17eac7:01b4ccb7:c768ca76:7b9febad
  Creation Time : Mon Jan 10 13:55:58 2005
     Raid Level : raid1
   Raid Devices : 2
  Total Devices : 1
Preferred Minor : 0

    Update Time : Sun Jun 26 01:15:21 2005
          State : clean
 Active Devices : 1
Working Devices : 1
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 4b3c0cec - correct
         Events : 0.364978


      Number   Major   Minor   RaidDevice State
this     0       3       65        0      active sync   /dev/hdb1

   0     0       3       65        0      active sync   /dev/hdb1
   1     1       0        0        1      faulty removed



Thanks!!!

Mitchell Laks
