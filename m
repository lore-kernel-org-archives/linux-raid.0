From: Santiago DIEZ <santiago.diez@caoba.fr>
Subject: Fail to assemble raid4 with replaced disk
Date: Tue, 25 Oct 2016 19:08:49 +0200
Message-ID: <CAJh8RqUjr7L_Of0fbW_mAXshmmgcPdXvhtsvhFXKF+XxjOTrFw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux Raid LIST <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Raiders,

I had a raid5 array md10 with sd[abcd]10.
Eventually, sdd10 failed.

I did NOT do any mdadm --fail NOR mdadm --remove command.
What I did is comment out the line "ARRAY /dev/md10 ..." in
/etc/mdadm/mdadm.conf.

Then I powered off the server, replaced the disk sdd with a new one
and booted the system.

I examined the status with:
# cat /proc/mdstat
md10 : inactive sdb10[1]
      1926247296 blocks

I stopped the array with:
# mdadm --stop /dev/md10

I tried to assemble the array with the 3 original disks like this
# mdadm --assemble /dev/md10 --verbose /dev/sda10 /dev/sdb10 /dev/sdc10
mdadm: looking for devices for /dev/md10
mdadm: /dev/sda10 is identified as a member of /dev/md10, slot 0.
mdadm: /dev/sdb10 is identified as a member of /dev/md10, slot 1.
mdadm: /dev/sdc10 is identified as a member of /dev/md10, slot 2.
mdadm: added /dev/sda10 to /dev/md10 as 0 (possibly out of date)
mdadm: added /dev/sdc10 to /dev/md10 as 2 (possibly out of date)
mdadm: no uptodate device for slot 3 of /dev/md10
mdadm: added /dev/sdb10 to /dev/md10 as 1
mdadm: /dev/md10 assembled from 1 drive - not enough to start the array.

I examined the status again with:
# cat /proc/mdstat
md10 : inactive sdb10[1](S) sdc10[2](S) sda10[0](S)
      5778741888 blocks

Now I'm SCARED!
What does the (S) mean?
How do I reassemble my array and add the new sdd10 partition?

Thanks for your help

Regards
-------------------------
Santiago DIEZ
Quark Systems & CAOBA
23 rue du Buisson Saint-Louis, 75010 Paris
-------------------------
