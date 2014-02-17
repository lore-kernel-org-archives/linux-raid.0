From: "Samer, Michael (I/ET-83, extern)" <extern.michael.samer@audi.de>
Subject: AW: QNAP 8 port RAID5 md0 recovery of missing MBR and md superblocks
Date: Mon, 17 Feb 2014 13:33:57 +0000
Message-ID: <A2EC67620EC7424F9EC3DD49243E9060466EC018@AUDIINSX0328.audi.vwg>
References: <52CBF747.7020505@epos-cat.de>
 <A2EC67620EC7424F9EC3DD49243E9060466DC09B@AUDIINSX0328.audi.vwg>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A2EC67620EC7424F9EC3DD49243E9060466DC09B@AUDIINSX0328.audi.vwg>
Content-Language: de-DE
Sender: linux-raid-owner@vger.kernel.org
To: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
Cc: "Samer, Michael (I/ET-83, extern)" <extern.michael.samer@audi.de>, "'philip@turmel.org'" <philip@turmel.org>
List-Id: linux-raid.ids

Greetings to all

As my thread from the 6.2.2014 didn't bring any hint or any reply or way out, I need advise if my way is approved:

I reconstructed the part table (testdisk import from a working disk) and now I'm only missing the md superblock on three disks (sdb3/sdf3/sdg3) for my md0 integrity.

I'd do the following:

a) "mdadm --stop /dev/md0"

b) "mdadm --create --assume-clean --verbose --force --run /dev/md0 --level=5 --raid-devices=8 /dev/sda3 missing /dev/sdc3 /dev/sdd3 /dev/sde3 /dev/sdf3 /dev/sdg3 /dev/sdh3"

or to include the "most datas available" version
c) "mdadm --create --verbose --assume-clean /dev/md0 --level=5 --raid-devices=8 /dev/sd{a,b,c,d,e,f,g,h}3"
to gather at least the older layout & data

d) "fsck.ext4 /dev/md0" on the array afterwards

Does anyone has something better in mind?

Cheers
Michael

