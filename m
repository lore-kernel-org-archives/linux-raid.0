From: Albert Pauw <albert.pauw@gmail.com>
Subject: Still problems with ddf stuff
Date: Sat, 18 Aug 2012 11:29:16 +0200
Message-ID: <CAGkViCE=y1ccgSubB-mewSiHMyCHtwbc98G65euc2066covssw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

looks like the layered raidsets problem is fixed, but still find
problems in the ddf code, here is the story below  how to reproduce
the behaviour.

Hope you've got some time to look into this.

Kind regards,

Albert

---

Created a container with 5 disks two raid sets,
md0 /dev/loop[1-3]
md1 /dev/loop[4-5]

 Physical Disks : 5
      Number    RefNo      Size       Device      Type/State
         0    f104844b    479232K /dev/loop1      active/Online
         1    6c6570f4    479232K /dev/loop2      active/Online
         2    b811fafe    479232K /dev/loop3      active/Online
         3    80f7c2da    479232K /dev/loop4      active/Online
         4    997126a7    479232K /dev/loop5      active/Online


Fail /dev/loop1 in md0
Remove /dev/loop1 from md127

 Physical Disks : 5
      Number    RefNo      Size       Device      Type/State
         0    f104844b    479232K                 active/Offline,
Failed, Missing
         1    6c6570f4    479232K /dev/loop2      active/Online
         2    b811fafe    479232K /dev/loop3      active/Online
         3    80f7c2da    479232K /dev/loop4      active/Online
         4    997126a7    479232K /dev/loop5      active/Online


Add /dev/loop1 back to md127

 Physical Disks : 5
      Number    RefNo      Size       Device      Type/State
         0    6c6570f4    479232K /dev/loop2      active/Online
         1    b811fafe    479232K /dev/loop3      active/Online
         2    80f7c2da    479232K /dev/loop4      active/Online
         3    997126a7    479232K /dev/loop5      active/Online
         4    131e04ea    479232K /dev/loop1      active/Online, Rebuilding


Status ok again

 Physical Disks : 5
      Number    RefNo      Size       Device      Type/State
         0    6c6570f4    479232K /dev/loop2      active/Online
         1    b811fafe    479232K /dev/loop3      active/Online
         2    80f7c2da    479232K /dev/loop4      active/Online
         3    997126a7    479232K /dev/loop5      active/Online
         4    131e04ea    479232K /dev/loop1      active/Online


Add spare /dev/loop6

 Physical Disks : 6
      Number    RefNo      Size       Device      Type/State
         0    6c6570f4    479232K /dev/loop2      active/Online
         1    b811fafe    479232K /dev/loop3      active/Online
         2    80f7c2da    479232K /dev/loop4      active/Online
         3    997126a7    479232K /dev/loop5      active/Online
         4    131e04ea    479232K /dev/loop1      active/Online
         5    d6f2c7b4    479232K /dev/loop6      Global-Spare/Online


Fail /dev/loop2 in /dev/md0, rebuild is with /dev/loop6 as expected,
but /dev/loop2 is gone now from the list

 Physical Disks : 5
      Number    RefNo      Size       Device      Type/State
         0    b811fafe    479232K /dev/loop3      active/Online
         1    80f7c2da    479232K /dev/loop4      active/Online
         2    997126a7    479232K /dev/loop5      active/Online
         3    131e04ea    479232K /dev/loop1      active/Online
         4    d6f2c7b4    479232K /dev/loop6      active/Online, Rebuilding


Fail /dev/loop5, rebuild is done with /dev/loop2, which had been
marked failed, and
disappeared at the previous action from the table. It is not visible here, but

      Number    RefNo      Size       Device      Type/State
         0    b811fafe    479232K /dev/loop3      active/Online, Rebuilding
         1    80f7c2da    479232K /dev/loop4      active/Online
         2    131e04ea    479232K /dev/loop1      active/Online
         3    d6f2c7b4    479232K /dev/loop6      active/Online, Rebuilding


cat /proc/mdstat shows that /dev/loop2 is used again.

Personalities : [raid6] [raid5] [raid4] [raid1]
md1 : active raid1 loop2[2] loop4[0]
      479232 blocks super external:/md127/1 [2/1] [U_]
      [======>..............]  recovery = 34.4% (165568/479232)
finish=0.8min speed=5913K/sec

md0 : active raid5 loop6[4] loop1[3] loop3[2]
      958464 blocks super external:/md127/0 level 5, 512k chunk,
algorithm 2 [3/2] [U_U]
      [===================>.]  recovery = 97.3% (467180/479232)
finish=0.0min speed=3407K/sec

md127 : inactive loop6[5](S) loop1[0](S) loop5[4](S) loop4[3](S)
loop3[2](S) loop2[1](S)
      196608 blocks super external:ddf
