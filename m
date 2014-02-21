From: Christian Iversen <ci@meebox.net>
Subject: Cannot assemble DDF raid
Date: Fri, 21 Feb 2014 05:26:15 +0100
Message-ID: <5306D567.2010304@meebox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>, "[meebox] Anders Eiler" <ace@meebox.net>
List-Id: linux-raid.ids

(please CC, not on the list currently)

I'm trying to recover from a 2-disk RAID5 failure on a Dell PERC 
controller running:

   2 x 146GB RAID1 (system)
   6 x 2TB RAID5 (data1)
   6 x 3TB RAID5 (data2)

Normally, data1 and data2 are then striped with mdadm on Linux, to 
increase performance over a JBOD-style usage. This has worked nicely for 
a while.. until we lost 2 disks in data2 within a few hours of each 
other. Murphy's law, and all that.


I've made a raw disk copy (using ddrescue) from one of the dead disks, 
onto a new disk. I tried putting this disk in the server, but it would 
not accept it. (It said it was recognized as foreign, but import failed)

If I try to assemble the raid, I get this error:

[root@rescue]~ #mdadm -A /dev/md10 /dev/sd[abcde]
mdadm: superblock on /dev/sde doesn't match others - assembly aborted

Now, this does seem to be true. All the GUIDs on sda-sdd:

Controller GUID : 44656C6C:20202020:32374730:32524100:00743D30:00000021
  Container GUID : 44656C6C:20202020:1000005B:10281F34:40371E8C:E9A398EA
       VD GUID[0] : 44656C6C:20202020:1000005B:10281F34:3DB931F1:D8857F5D
       VD GUID[1] : 44656C6C:20202020:1000005B:10281F34:3DB9326E:61E7B2D7
       VD GUID[2] : 44656C6C:20202020:1000005B:10281F34:3F6ADA39:99DCAA67

While on the last 2 disks, we have this:

Controller GUID : 44656C6C:20202020:32374730:32524100:00743D30:00000021
  Container GUID : 44656C6C:20202020:1000005B:10281F34:3DB931F1:40FC2989
       VD GUID[0] : 44656C6C:20202020:1000005B:10281F34:3DB931F1:D8857F5D
       VD GUID[1] : 44656C6C:20202020:1000005B:10281F34:3DB9326E:61E7B2D7
       VD GUID[2] : 44656C6C:20202020:1000005B:10281F34:3F6ADA39:99DCAA67

Notice how the last 8 bytes of the Container is different.

I'm not quite sure how this happened, but I have a strong suspicion the 
PERC controller did something less than clever, and now I can't start 
the raid with mdadm OR perc.



I've tried to simply update the container GUID using a hex editor, but 
this of course causes the CRCs to fail. (I reverted this change)

I have the following questions:

   1) If I could manage to change the Container GUID, would that
      be a viable way to force the array to start, for further rescue?

   2) Is there any other way to force the array to start? (--force does 
not help)

   3) Any other suggestions?

-- 
De bedste hilsner,

Christian Iversen
Systemadministrator, Meebox.net

-------
Denne e-mail kan indeholde fortrolige
oplysninger. Er du ikke den rette modtager,
bedes du returnere og slette denne e-mail.
-------
