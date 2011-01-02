From: Carlos Mennens <carloswill@gmail.com>
Subject: How To Remove Rogue RAID
Date: Sun, 2 Jan 2011 14:42:48 -0500
Message-ID: <AANLkTi=95GkF4QqW7s1tOsYT0oZ0WrruD_Ggrx+q6FLp@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I added two new physical drives to my Linux server and for some reason
I now see '/dev/md127' when I run 'cat /proc/mdstat':

root ~ # cat /proc/mdstat
Personalities : [raid1]
md127 : active (auto-read-only) raid1 sdc2[1] sdd2[0]
      243199936 blocks [2/2] [UU]
      	resync=PENDING

I never create /dev/md127 what so ever and I'm fairly sure it just
popped up. I can tell you the two new disks I added above (/dev/sdc &
/dev/sdd) did have 'fd' RAID partition tables on the disk so I don't
know if that is why it (/dev/md127) shows up when I run 'cat
/proc/mdstat'.

I tried to remove the drives too but they failed:

root ~ # mdadm --manage /dev/md127 --remove /dev/sdc2
mdadm: hot remove failed for /dev/sdc2: Device or resource busy
root ~ # mdadm --manage /dev/md127 --remove /dev/sdd2
mdadm: hot remove failed for /dev/sdd2: Device or resource busy


Can someone please tell me how I can stop the RAID, remove /dev/md127
so that I can create a separate mirror with /dev/sdc & /dev/sdd.
