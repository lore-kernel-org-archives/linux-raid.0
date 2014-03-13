From: "Samer, Michael (I/ET-83, extern)" <extern.michael.samer@audi.de>
Subject: AW: QNAP 8 port RAID5 md0 recovery of missing MBR and md superblocks
Date: Thu, 13 Mar 2014 10:43:22 +0000
Message-ID: <A2EC67620EC7424F9EC3DD49243E9060466FB311@AUDIINSX0328.audi.vwg>
References: <52CBF747.7020505@epos-cat.de>
 <A2EC67620EC7424F9EC3DD49243E9060466DC09B@AUDIINSX0328.audi.vwg>
 <A2EC67620EC7424F9EC3DD49243E9060466EC018@AUDIINSX0328.audi.vwg>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A2EC67620EC7424F9EC3DD49243E9060466EC018@AUDIINSX0328.audi.vwg>
Content-Language: de-DE
Sender: linux-raid-owner@vger.kernel.org
To: "Samer, Michael (I/ET-83, extern)" <extern.michael.samer@audi.de>, "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
Cc: "'philip@turmel.org'" <philip@turmel.org>
List-Id: linux-raid.ids

Greetings to all

Phil solved my problem with his help

A bit diffusing was the problem of my partedMagic different /dev/sdx sorting:

QNAP Original: 
sda=ZXT
sdb=S13
sdc=P3E
sdd=ZB6
sde=GJN
sdf=PSN
sdg=WD
sdh=1NH


Parted Order=rebuildversion:
sda=ZB6
sdb=P3E
sdc=S13
sdd=ZXT
sde=GJN
sdf=PSN
sdg=WD
sdh=1NH

so:
mdadm --create --assume-clean --verbose /dev/md0 --chunk=64 --metadata=0.9 --level=5 --raid-devices=8 /dev/sdd3 missing /dev/sd{b,a,e,f,g,h}3

mdadm --assemble /dev/md0 --uuid=30358eff:ac9e6122:004291dc:e0ebbc5e

mdadm --detail --scan >> /etc/mdadm.conf

dd /dev/md0 /BACKUP/Pallmert.bin

worked and did the job and is currently saving the image for further inspection.

Thanks a lot!

Michael
