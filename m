From: Dexter Filmore <Dexter.Filmore@gmx.de>
Subject: Re: slackware -current softraid5 boot problem - additional info
Date: Tue, 9 May 2006 12:35:58 +0200
Message-ID: <200605091235.58939.Dexter.Filmore@gmx.de>
References: <200605090006.32615.Dexter.Filmore@gmx.de> <20060509055048.GA22085@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060509055048.GA22085@percy.comedia.it>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am Dienstag, 9. Mai 2006 07:50 schrieb Luca Berra:
> you don't give a lot of information about your setup,

You're sure right here, I was a bit off track yesterday from tinkering till 
night - info below.

> in any case it could be something like udev and the /dev/sdd device node
> not being available at boot?

Ok: 
Slackware-current with kernel 2.6.14.6, *no* udev, plain old hotplug
I had to put the raid start script in a reasonable place myself (not preconfed 
in Slack) so I have to figure yet if sees /etc/mdadm.conf  when the script is 
called. (If presence of mdadm.conf is totally uninteresting, let me know, I 
just started on raid.)
The other disks are seen fine, and since they are all the same type on the 
same controller there's no reason why it is not seen then.
(Unless for some reason mdadm talks to the *last* disk first and then stops - 
else it should complain about sda rather.)


***** mdadm -E info *****


# mdadm -E /dev/sdd
/dev/sdd:
          Magic : a92b4efc
        Version : 00.90.02
           UUID : db7e5b65:e35c69dc:7c267a5a:e676c929
  Creation Time : Mon May  8 00:05:16 2006
     Raid Level : raid5
    Device Size : 244198464 (232.89 GiB 250.06 GB)
     Array Size : 732595392 (698.66 GiB 750.18 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Tue May  9 00:43:46 2006
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 61f0ffd6 - correct
         Events : 0.24796

         Layout : left-symmetric
     Chunk Size : 32K

      Number   Major   Minor   RaidDevice State
this     3       8       48        3      active sync   /dev/sdd

   0     0       8        0        0      active sync   /dev/sda
   1     1       8       16        1      active sync   /dev/sdb
   2     2       8       32        2      active sync   /dev/sdc
   3     3       8       48        3      active sync   /dev/sdd

***** mdstat *****

Once I started the array manually (which works fine) mdstats look like:

# cat /proc/mdstat
Personalities : [raid5]
md0 : active raid5 sda1[0] sdd1[3] sdc1[2] sdb1[1]
      732563712 blocks level 5, 32k chunk, algorithm 2 [4/4] [UUUU]

unused devices: <none>

-- 
-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GCS d--(+)@ s-:+ a- C+++(++++) UL+>++++ P+>++ L+++>++++ E-- W++ N o? K-
w--(---) !O M+ V- PS++(+) PE(-) Y++ PGP t++(---)@ 5 X+(++) R+(++) tv--(+)@ 
b++(+++) DI+++ D G++ e* h>++ r%>* y?
------END GEEK CODE BLOCK------

http://www.stop1984.com
http://www.againsttcpa.com
