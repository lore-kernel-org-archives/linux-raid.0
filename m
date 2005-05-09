From: Glatzel Tino <tino.glatzel@badenIT.de>
Subject: swap with raid1
Date: Mon, 9 May 2005 18:32:03 +0200
Message-ID: <23ADBF4236843B469BE57F05F135897602E744E2@srvntexc2.swfr>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello list,


my Debian GNU Linux Sarge is working with a static kernel with the following
/etc/fstab:

proc            /proc           proc    defaults        0       0
/dev/md2       /               ext3    defaults,errors=remount-ro 0       1
/dev/md1       /boot           ext3    defaults        0       2
/dev/md7       /home           ext3
rw,nosuid,nodev,noexec,auto,nouser,async        0       2
/dev/md8       /opt            ext3    defaults        0       2
/dev/md5       /tmp            ext3
rw,nosuid,nodev,noexec,auto,nouser,async        0       2
/dev/md6       /var            ext3    defaults,nodev        0       2
/dev/hda10       none            swap    sw              0       0



I have tried to setup the swap-partition to /dev/md3, but after this change
the system comes up with a lot of errormessages. Some daemons cant create
files and so on. 
I have created the swap partition like this:


mdadm --create /dev/md3 --level 1 --raid-device=2 /dev/hda3 /dev/hdc3

mkswap /dev/md3

/dev/hda1               1         124       62464+  fd  Linux raid
autodetect
/dev/hda2             125        2062      976752   fd  Linux raid
autodetect
/dev/hda3            2063        5937     1953000   fd  Linux raid
autodetect
/dev/hda4            5938      155061    75158496    5  Extended
/dev/hda5            5938        6930      500440+  fd  Linux raid
autodetect
/dev/hda6            6931       10899     2000344+  fd  Linux raid
autodetect
/dev/hda7           10900       12884     1000408+  fd  Linux raid
autodetect
/dev/hda8           12885       16853     2000344+  fd  Linux raid
autodetect
/dev/hda9           16854       24791     4000720+  83  Linux
/dev/hda10          24792       28760     2000344+  82  Linux swap / Solaris



/dev/hdc1               1         125       62968+  fd  Linux raid
autodetect
/dev/hdc2             126        2110     1000440   fd  Linux raid
autodetect
/dev/hdc3            2111        6079     2000376   fd  Linux raid
autodetect
/dev/hdc4            6080       28902    11502792    5  Extended
/dev/hdc5            6080        7072      500440+  fd  Linux raid
autodetect
/dev/hdc6            7073       11041     2000344+  fd  Linux raid
autodetect
/dev/hdc7           11042       13026     1000408+  fd  Linux raid
autodetect
/dev/hdc8           13027       16995     2000344+  fd  Linux raid
autodetect
/dev/hdc9           16996       24933     4000720+  83  Linux
/dev/hdc10          24934       28902     2000344+  82  Linux swap / Solaris





It does not work. Can anyone help me ??


Tino
