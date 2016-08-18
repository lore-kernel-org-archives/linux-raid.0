From: Yi Zhang <yizhan@redhat.com>
Subject: OOM/panic observed durintg creating RAID4 with DIF/DIX enabled disk
Date: Thu, 18 Aug 2016 05:44:02 -0400 (EDT)
Message-ID: <2137210845.2497446.1471513442879.JavaMail.zimbra@redhat.com>
References: <2062708428.2492143.1471511559011.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2062708428.2492143.1471511559011.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, jmoyer@redhat.com, Jes Sorensen <jes.sorensen@redhat.com>, Xiao Ni <xni@redhat.com>
List-Id: linux-raid.ids

hello 

I observed OOM/panic during create RAID4 with DIF/DIX enabled disk, here I used scsi-debug to created the DIF/DIX disk.

Full log:
http://pastebin.com/uP3rJcHX

Environment:
4.8.0-rc2
32Gb phycial memory

Reproduced at Iteration:19

Reproduce steps:

#!/bin/bash
modprobe scsi_debug dev_size_mb=16384  num_parts=4 dif=1 dix=1
sleep 5
num=0
while [ $num -lt 100 ]; do
	echo "********************Iteration:$num****************"
	mdadm --create --run /dev/md0 --level 4 --metadata 1.2 --raid-devices 4  /dev/sdc[1-4]  --bitmap=internal --bitmap-chunk=64M --chunk 512
	mdadm --wait /dev/md0
	cat /proc/mdstat
	mdadm -Ss
	mdadm --zero-superblock /dev/sdc[1-4]
	sleep 1
       ((num++))
done

Best Regards,
  Yi Zhang


