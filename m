From: Norman Schmidt <schmidt@naa.net>
Subject: Re: split RAID1 during backups?
Date: Tue, 25 Oct 2005 10:35:53 +0200
Message-ID: <435DEE69.8030605@naa.net>
References: <E1EUFcV-0005s3-00@toko.jab.org>
Reply-To: schmidt@naa.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E1EUFcV-0005s3-00@toko.jab.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jeff Breidenbach schrieb:
> Ok... thanks everyone!

Something from me:

What you should be able to do with software raid1 is the following:
Stop the raid, mount both underlying devices instead of the raid device, 
but of course READ ONLY. Both contain the complete data and filesystem, 
and in addition to that the md superblock at the end. Both should be 
identical copies of that.
Thus, you do not have to resync afterwards. You then can backup the one 
disk while serving the web server from the other. When you are done, 
unmount, assemble the raid, mount it and go on.

Eg. /dev/md1 consists of /dev/hda5 and /dev/hdc5 and has a working fs on it.

/dev/md1 is mounted on /data.

umount /dev/md1
mdadm -S /dev/md1

mount -r /dev/hda5 /data
mount -r /dev/hdc5 /backup

do your backup

umount /dev/hda5
umount /dev/hdc5

mdadm -A /dev/md1

mount /dev/md1 /data


Please could somebody double-check or confirm this first?

Hope this helps, Norman.

-- 
Norman Schmidt          Institut fuer Physikal. u. Theoret. Chemie
Dipl.-Chem. Univ.       Friedrich-Alexander-Universitaet
schmidt@naa.net         Erlangen-Nuernberg
+49 9131 852 7321       IT-Systembetreuer Physikalische Chemie
