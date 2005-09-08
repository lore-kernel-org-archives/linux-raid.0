From: Jay Marsh <gerdalti@gmail.com>
Subject: Issue with MDADM raid 5
Date: Thu, 08 Sep 2005 00:39:17 -0400
Message-ID: <431FC075.1030805@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I recently put together a large Raid 5 file server.
Computer is running Fedora Core 3. Raid 5 is software raid using mdadm. 
Because the network here at my house is used by a bunch of semi-literate 
(just enough to fuck things up) people, I run a chown script against the 
root of the samba share every so often. This has been working fine, but 
has brought some things to my attention. I am loosing files slowly.
The Raid itself is 5 WD 320gig SATA drives. Using a supermicro enclosure 
and 2 crappy little PCI SATA controller cards. /dev/md1 is formatted as 
an ext3 file system. I will be getting a nicer controller card in the 
next few months (moving to a PCI-X architechture, but for now this is 
all I have).

The errors I'm getting are:

code:
------------------------------------------------------------------------

Message 72:
From root@RIAA.tekkiehaus.com <mailto:root@RIAA.tekkiehaus.com>  Fri Sep  2 10:30:32 2005
Date: Fri, 2 Sep 2005 10:30:25 -0400
From: root@RIAA.tekkiehaus.com <mailto:root@RIAA.tekkiehaus.com> (Cron Daemon)
To: root@RIAA.tekkiehaus.com <mailto:root@RIAA.tekkiehaus.com>
Subject: Cron <root@RIAA> chown -R nobody.nobody /fileserv


chown: cannot access `/fileserv/Audio/Jay's Shit/Rap Hip-Hop/Talib Kweli/Talib Kweli & Hi-tek - Reflection Eternal/010-reflection_eternal-name_of_the_game-ego.mp3': 
Input/output error
------------------------------------------------------------------------



This file is now GONE. It will show up in an ls, but i can not access 
said file at all. The only thing I can do with it is rm -f it or run an 
fsck (on the md device) and it just disappears after the fsck is complete.

/proc/mdstat seems to show everything as ok

code:
------------------------------------------------------------------------

[root@RIAA ~]# cat /proc/mdstat
Personalities : [raid5]
md1 : active raid5 sde1[4] sdd1[1] sdc1[0] sdb1[3] sda1[2]
      1250274304 blocks level 5, 64k chunk, algorithm 2 [5/5] [UUUUU]

unused devices: <none>
------------------------------------------------------------------------



Do I have a bad drive? Or is something else going on here? Need more 
info? Just ask, I'll provide what I can.
