From: Karel Zak <kzak@redhat.com>
Subject: MD and rotational attribute
Date: Mon, 20 Feb 2012 13:20:22 +0100
Message-ID: <20120220122022.GA7466@x2.net.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi Neil,

I guess that something is wrong with MD. If you create a RAID on ssd
(or scsi_debug in my example) than MD device is reported as rotational.
Simple example:

 modprobe scsi_debug dev_size_mb=500
 fdisk /dev/sdb
 ...
 mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sdb{1,2}

 # cat /sys/block/sdb/queue/rotational
 0
 # cat /sys/block/md0/queue/rotational
 1

It seems like a bug.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
