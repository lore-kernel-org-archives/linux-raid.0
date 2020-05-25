From: Thomas Grawert <thomasgrawert0282@gmail.com>
Subject: Re: help requested for mdadm grow error
Date: Mon, 25 May 2020 22:30:23 +0200
Message-ID: <103b80fa-029f-ecdc-d470-5cc591dc8dd0@gmail.com>
References: <7d95da49-33d8-cd4d-fa3f-0f3d3074cb30@gmail.com>
 <5ECC09D6.1010300@youngman.org.uk>
 <ff4ea9cd-ab35-0990-5946-4a72d4021658@gmail.com>
 <5ECC1488.3010804@youngman.org.uk>
 <4891e1e8-aaee-b36b-4131-ca7deb34defd@gmail.com>
 <alpine.DEB.2.20.2005252132080.7596@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.20.2005252132080.7596@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Am 25.05.2020 um 21:33 schrieb Mikael Abrahamsson:
> On Mon, 25 May 2020, Thomas Grawert wrote:
>
>> The Debian 10 is the most recent one. Kernel version is 
>> 4.9.0-12-amd64. mdadm-version is v3.4 from 28th Jan 2016 - seems to 
>> be the latest, because I can´t upgrade to any newer one using apt 
>> upgrade.
>
> Are you sure about this? From what I can see debian 10 ships with 
> mdadm v4.1 and newer kernels than 4.9.
>
Thanks to Mikael to hit my nose :)

System is now at Debian 10 with Kernel 5.5.0.0.bpo.2-amd64. mdadm is at 4.1:

root@nas:~# cat /etc/os-release
PRETTY_NAME="Debian GNU/Linux 10 (buster)"
NAME="Debian GNU/Linux"
VERSION_ID="10"
VERSION="10 (buster)"
VERSION_CODENAME=buster
ID=debian
HOME_URL="https://www.debian.org/"
SUPPORT_URL="https://www.debian.org/support"
BUG_REPORT_URL="https://bugs.debian.org/"

root@nas:~# uname -r
5.5.0-0.bpo.2-amd64

root@nas:~# mdadm -V
mdadm - v4.1 - 2018-10-01

root@nas:~# mdadm -D /dev/md0
/dev/md0:
            Version : 1.2
      Creation Time : Sun May 17 00:23:42 2020
         Raid Level : raid5
      Used Dev Size : 18446744073709551615
       Raid Devices : 5
      Total Devices : 5
        Persistence : Superblock is persistent

        Update Time : Mon May 25 16:05:38 2020
              State : active, FAILED, Not Started
     Active Devices : 5
    Working Devices : 5
     Failed Devices : 0
      Spare Devices : 0

             Layout : left-symmetric
         Chunk Size : 512K

Consistency Policy : unknown

      Delta Devices : 1, (4->5)

               Name : nas:0  (local to host nas)
               UUID : d7d800b3:d203ff93:9cc2149a:804a1b97
             Events : 38602

     Number   Major   Minor   RaidDevice State
        -       0        0        0      removed
        -       0        0        1      removed
        -       0        0        2      removed
        -       0        0        3      removed
        -       0        0        4      removed

        -       8        1        0      sync   /dev/sda1
        -       8       81        4      sync   /dev/sdf1
        -       8       65        3      sync   /dev/sde1
        -       8       49        2      sync   /dev/sdd1
        -       8       33        1      sync   /dev/sdc1

root@nas:~#


It seems, mdadm.conf or anything else is broken?
