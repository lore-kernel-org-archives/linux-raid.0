From: Hendrik Visage <hvisage@envisage.co.za>
Subject: mdadm --assemble --scan hassles....
Date: Wed, 8 Oct 2003 13:17:09 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031008111709.GV1277@hvs.envisage.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Right, now if md would do auto detecting on mds then my
problem would have disappeared, but alas....

Anycase, I'm trying to make use of mdadm (I've tried different options etc.
inside mdadm.conf from what I could see on the mailing list), but I'm still
stuck with the following issue:
(right after boot):

root@hvstress ~ # mdadm --assemble --scan
mdadm: no devices found for /dev/md/1
root@hvstress ~ # mdadm --examine --scan   
ARRAY /dev/md1 level=linear num-devices=2 UUID=8eb3a6c0:02e58fd9:a662938a:56f87147
   devices=/dev/md/0,/dev/md/0
root@hvstress ~ # mdadm --examine --scan --config=partitions
ARRAY /dev/md0 level=raid0 num-devices=2 UUID=832ab839:9920da12:97991965:f9af96e2
   devices=/dev/scsi/host0/bus0/target1/lun0/part1,/dev/scsi/host0/bus0/target2/lun0/part1
ARRAY /dev/md1 level=linear num-devices=2 UUID=8eb3a6c0:02e58fd9:a662938a:56f87147
   devices=/dev/md/0,/dev/scsi/host0/bus0/target1/lun0/part2

root@hvstress ~ # mdadm --assemble --scan   
mdadm: no devices found for /dev/md/1
root@hvstress ~ # cat /etc/mdadm.conf 
DEVICE /dev/md/* /dev/sd*
DEVICE /dev/sd[ab]
DEVICE /dev/md0 
DEVICE /dev/md/0

ARRAY /dev/md/0 level=raid0 num-devices=2 UUID=832ab839:9920da12:97991965:f9af96e2
   devices=/dev/scsi/host0/bus0/target1/lun0/part1,/dev/scsi/host0/bus0/target2/lun0/part1
ARRAY /dev/md/1 level=linear num-devices=2 UUID=c2a91233:5ffd5398:eac27773:e12945dd


