From: "John Reeves" <john.reeves@mailc.net>
Subject: Ubuntu - RAID Array not "assembling" on boot.
Date: Tue, 21 Nov 2006 20:06:32 +0000
Message-ID: <1164139592.12278.276853539@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hey,

Having a great deal of difficulty getting my 3 disk RAID 5 array to
reappear on restart, Ubuntu 6.10.  Here's the contents of my
/etc/mdadm/mdadm.conf file:

ARRAY /dev/md0 level=raid5 num-devices=3
UUID=6a9a102a:101addd2:f95758f6:11ac6d3c 

Obviously /dev/md0 does not "appear" on restart, the only way I can get
the RAID Array to assemble is to issue the following:

mknod -m 0660 /dev/md0 b 9 0
mdadm --assemble /dev/md0 /dev/sda1 /dev/sdb1 /dev/sdc1

I can add these lines to my /etc/init.d/bootmisc.sh which does work, but
seeing as I'm not 100% sure what the mknod command is doing, and the
fact that I'm pretty sure that this is not the way it's mean to be... 
(the mknod is required, or mdadm complains that /dev/md0 does not
exist).  

I'm nearly tearing my hair out over this one, so if someone could be of
assistance I would be greatly appreciative.

Regards
J. Reeves.
