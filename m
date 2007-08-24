From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: recovery starts from 0 after reboot - normal?
Date: Fri, 24 Aug 2007 13:20:13 +0200
Message-ID: <46CEBEED.1060209@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I built RAID-5 on a Debian Etch machine running 2.6.22.5 with this command:

mdadm --create /dev/md0 --chunk=64 --level=raid5 --raid-devices=5 
/dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1


After some time, it was synchronized just fine.


I removed one drive, put it back again, readded the drive to the array.

It started rebuilding.
However, if the rebuilding is not 100% done, and I reboot the machine, 
rebuilding starts from 0.

Is it normal?


-- 
Tomasz Chmielewski
http://wpkg.org

