From: Paul <paul@7digital.co.uk>
Subject: MDADM restart at system boot time
Date: Tue, 04 Sep 2007 22:15:06 +0100
Message-ID: <8f2c1194b4839dee2ea49eedfeaf783a@7digital.co.uk>
Reply-To: Paul <paul@7digital.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
 
I hope someone can help.
 
I have manually installed mdadm and now have a working array. I installed mdadm from the tarball, then did 'make install'
 
My problem is after system reboot the array will not start as the daemon is not running, I guess.
 
In order to access my files I have to re-create the array, which it complains about and then re-mount the disks, via the usual 'mount /dev/md0 /data', I know this 'mount' can be done via fstab, but I need the first part to work first.
 
I have the following info in my mdadm.conf file:

DEVICE /dev/hdb1 /dev/hdc1
ARRAY /dev/md0 level=raid1 num-devices=2 UUID=0f0e3d1f:52580ad4:2ef6a2e7:f760e130
        devices=/dev/hdb1,/dev/hdc1
 
I am running Debian 3.1.
 
Thanks
 
Regards 
  
---------------------
Paul Roberts
Systems Manager 
  
7digital
Unit 1G
Zetland House
5-25 Scrutton Street
London
EC2A 4HJ 
Direct Dial: (020) 7099 0816 
Main Switchboard: (020) 7099 7777
Fax Number: (020) 7504 8020
www.7digital.com
www.indiestore.com
 
