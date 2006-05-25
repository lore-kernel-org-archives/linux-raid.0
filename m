From: Ste <ste@phx6a.ath.cx>
Subject: mdadm and 2.4 kernel?
Date: Thu, 25 May 2006 20:43:47 +0200
Message-ID: <4475FAE3.6080309@phx6a.ath.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi, for various reasons i'll need to run mdadm on a 2.4 kernel.
Now I have 2.4.32 kernel.

Take a look:

root@data:~# mdadm --create --verbose /dev/md0 --level=1 
--bitmap=/root/md0bitmap -n 2 /dev/nda /dev/ndb --force --assume-clean
mdadm: /dev/nda appears to be part of a raid array:
    level=raid1 devices=2 ctime=Thu May 25 20:10:47 2006
mdadm: /dev/ndb appears to be part of a raid array:
    level=raid1 devices=2 ctime=Thu May 25 20:10:47 2006
mdadm: size set to 39118144K
Continue creating array? y
mdadm: Warning - bitmaps created on this kernel are not portable
  between different architectured.  Consider upgrading the Linux kernel.
mdadm: Cannot set bitmap file for /dev/md0: No such device


root@data:~# mdadm --create --verbose /dev/md0 --level=1  -n 2 /dev/nda 
/dev/ndb --force --assume-clean
mdadm: /dev/nda appears to be part of a raid array:
    level=raid1 devices=2 ctime=Thu May 25 20:10:47 2006
mdadm: /dev/ndb appears to be part of a raid array:
    level=raid1 devices=2 ctime=Thu May 25 20:10:47 2006
mdadm: size set to 39118144K
Continue creating array? y
mdadm: SET_ARRAY_INFO failed for /dev/md0: File exists
root@data:~# 

Obviously the devices "/dev/nda" and "/dev/ndb" exists (i can make fdisk 
on them).

Can someone help me?
Thanks.
Stefano.

            



