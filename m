From: MITSUNARI Shigeo <herumi@nifty.com>
Subject: Re: [PATCH 2/2] How about moving a code bdev->bd_invalidated = 0; into check_disk_size_change() instead of putting the code every time after check_disk_size_change().
Date: Mon, 15 Oct 2012 18:38:04 +0900 (JST)
Message-ID: <26220921.459141350293884468.herumi@nifty.com>
References: <1350293228-3602-2-git-send-email-herumi@nifty.com>
 <1350293228-3602-1-git-send-email-herumi@nifty.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1350293228-3602-2-git-send-email-herumi@nifty.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,
mdadm monitor will clear file cache every 1000 seconds after mdadm resize is e
xecuted. 

We verified the problem occurred at kernel 3.6.2 and mdadm v3.2.5 on ubuntu 12
.04LTS x86_64
and the patch worked well.
--- 
The following steps will reproduce the problem. 

1. prepair a block device(ex. /dev/sdb) 
2 create two partitions. 

sudo parted /dev/sdb 
mklabel gpt 
mkpart primary 0% 50% 
mkpart primary 50% 100% 

3. create a md device 

sudo mdadm -C /dev/md/hoge -l 1 -n 2 -e 1.2 --assume-clean --auto=md --symlink
=no /dev/sdb1 /dev/sdb2 

4. create file system and mount it 

sudo mkfs.ext3 /dev/md/hoge 
sudo mkdir /mnt/test 
sudo mount /dev/md/hoge /mnt/test 

5. try to resize the device 

sudo mdadm -G /dev/md/hoge --size=max 

6. create a file to fill file cache. 

sudo dd if=/dev/urandom of=/mnt/test/data bs=1M count=10 
and verity the current status of file by free command. 

7. mdadm monitor will open the md device every 1000 seconds 
and you will find file cache is cleared. 

The timing can be reduced by the following steps. 

a) kill mdadm and restart it with --delay option 
/sbin/mdadm --monitor --delay=30 --pid-file /var/run/mdadm/monitor.pid --daemo
nise --scan --syslog 

or open the md device directly. 

sudo dd if=/dev/md/hoge of=/dev/null bs=4096 count=1 
---
Yours,
  Shigeo

