From: Pavel Hofman <pavel.hofman@ivitera.com>
Subject: How to update homehost of an existing raid component
Date: Mon, 19 Mar 2012 10:58:57 +0100
Message-ID: <4F670361.6090902@ivitera.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

Please is there a way to update a homehost value for a specific raid
component?

md7 is raid1 composed of md5 and md6. UUID of md7 is listed in mdadm.conf:

ARRAY /dev/md7 level=raid1 num-devices=2 metadata=01.00
UUID=dde16cd5:2e17c743:fcc7926c:fcf5081e


Every time I reboot, md7 is auto assembled only from md5. When running
manually, I get

mdadm  --verbose -A /dev/md7  --scan
...
mdadm: /dev/md6 misses out due to wrong homehost
...


Indeed, all the raid components (there are many more belonging to
different raids on my machine) list the "local to host orfeus" homehost,
such as:

orfeus:~# mdadm --examine /dev/md5
/dev/md5:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x0
     Array UUID : dde16cd5:2e17c743:fcc7926c:fcf5081e
           Name : orfeus:7  (local to host orfeus)
  Creation Time : Wed Jan 19 21:36:19 2011
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 4356361184 (2077.27 GiB 2230.46 GB)
     Array Size : 4356361184 (2077.27 GiB 2230.46 GB)
   Super Offset : 4356361440 sectors
          State : clean
    Device UUID : a4973bb6:2cd83805:ba441193:56321f9b

    Update Time : Mon Mar 19 02:36:33 2012
       Checksum : 7b8eeffd - correct
         Events : 11853346


   Device Role : Active device 1
   Array State : AA ('A' == active, '.' == missing)


While the md6 has the homehost different:
orfeus:~# mdadm --examine /dev/md6
/dev/md6:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x0
     Array UUID : dde16cd5:2e17c743:fcc7926c:fcf5081e
           Name : 'orfeus':7
  Creation Time : Thu Jun 17 22:51:47 2010
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 4356361184 (2077.27 GiB 2230.46 GB)
     Array Size : 4356361184 (2077.27 GiB 2230.46 GB)
   Super Offset : 4356361440 sectors
          State : clean
    Device UUID : 9144c9ad:8ee3ed37:69b53956:03bebdd6

    Update Time : Mon Mar 19 02:36:33 2012
       Checksum : 94c11ff3 - correct
         Events : 11853346


   Device Role : Active device 0
   Array State : AA ('A' == active, '.' == missing)


There is no "local to host orfeus" in homehost of md6. Otherwise, the
array UUID fits that of md7. It was added after last reboot when the
array failed to assemble automatically.

Following the man page, I tried running

mdadm --verbose -A /dev/md7 --update=homehost --scan

with no difference. Unfortunately I was not able to find how to change
the homehost of md6 to be local to orfeus. I do not want to force adding
md6 to the array and go through the whole rebuild since the data
themselves are OK.


Thanks a lot for any hints and help.

Best regards,


Pavel.
