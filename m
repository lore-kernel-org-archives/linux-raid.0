From: scar <scar-47zfDnpWZoPQT0dZR+AlfA@public.gmane.org>
Subject: help with degraded raid1 array
Date: Mon, 04 Mar 2013 13:02:28 -0700
Message-ID: <kh2ukl$o1s$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-raid-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-raid.ids

i need some help troubleshooting a degraded raid1 array

in /proc/mdstat i have:
Personalities : [raid1] [linear] [multipath] [raid0] [raid6] [raid5]
[raid4] [ra
id10]
md0 : active raid1 sdc1[2](F) sdb1[1]
      976759936 blocks [2/1] [_U]

and this seems to be some relevant stuff from dmesg:
http://pastebin.com/njXt4LuK
looks like there are problems with both my disks? (ata3 and ata4)

after restarting the array, it looks like it's being rebuilt, now
/proc/mdstat is showing:

Personalities : [raid1] [linear] [multipath] [raid0] [raid6] [raid5]
[raid4] [raid10]
md0 : active raid1 sdd1[2] sdc1[1]
      976759936 blocks [2/1] [_U]
      [>....................]  recovery =  1.1% (11347200/976759936)
finish=222.7min speed=72230K/sec

unused devices: <none>

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
