From: "Cristian Banciu" <Cristian.Banciu@eea.eu.int>
Subject: raidreconf eror
Date: Thu, 11 Sep 2003 11:39:09 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <6B238F130041BF46AF3592E6700E7E14770634@panda.eea.eu.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have done a software raid5 with 5 scci disks. Now I want to add one more disk to the current configuration without loosing data. But for some unkown reason the operation fails. Has anyone any idea why could I make this thing working ?

Thank you very much!


#raidreconf -o /etc/raidtab -n /etc/raidtab.new -m /dev/md0
Working with device /dev/md0
Parsing /etc/raidtab
Parsing /etc/raidtab.new
Your on-disk array MUST be clean first.
reconfiguration failed

This is how raidtab looks liks
#cat /etc/raidtab
raiddev /dev/md0
        raid-level              5
        nr-raid-disks           5
        nr-spare-disks          0
        persistent-superblock   1
        parity-algorithm        left-symmetric
        chunk-size              32
        device                  /dev/sdb1
        raid-disk               0
        device                  /dev/sdc1
        raid-disk               1
        device                  /dev/sdd1
        raid-disk               2
        device                  /dev/sde1
        raid-disk               3
        device                  /dev/sdf1
        raid-disk               4

And this is how the new raidtab looks like
#cat /etc/raidtab.new
raiddev /dev/md0
        raid-level              5
        nr-raid-disks           6
        nr-spare-disks          0
        persistent-superblock   1
        parity-algorithm        left-symmetric
        chunk-size              32
        device                  /dev/sdb1
        raid-disk               0
        device                  /dev/sdc1
        raid-disk               1
        device                  /dev/sdd1
        raid-disk               2
        device                  /dev/sde1
        raid-disk               3
        device                  /dev/sdf1
        raid-disk               4
        device                  /dev/sdh1
        raid-disk               5

