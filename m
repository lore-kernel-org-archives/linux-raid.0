From: Craig Emery <craig.emery@trigenix.com>
Subject: Five powercuts in one day has me *almost* "fried"
Date: Wed, 28 Jul 2004 22:14:39 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4108173F.5070403@trigenix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear All,

( forgive me if this is a FAQ, I'm a RAID newbie )

a dodgy power company has left my Fedora (FC2Test3) machine on the brink 
of failure.

I've got all of my partitions as RAID-1 (/, /boot, /home, /usr, /var, 
/tmp and swap)

All I want is a machine that'll stay up!

Anyway, *all* of my md's have only one active partition.

/dev/hda and /dev/hdc are the same model/size of disk.

/      md2    1GB     hda5 removed     hdc5 active
/boot  md0    100MB   hda1 removed     hdc1 active
/home  md6    12GB    hda8 removed     hdc8 active
/tmp   md4    512MB   hda6 removed     hdc6 active
/usr   md3    4GB     hda2 removed     hdc2 active
/var   md5    1GB     hda3 removed     hdc3 active
swap   md1    512MB   hda7 removed     hdc7 active

All my file systems are EXT3.

So the question is this. How do I fix the removed partitions?

I do have a spare disk (same as the two that are "live").

Oh yeah, and occasionally I hear a clunking noise from the machine! :'(

TIA

Craig.
