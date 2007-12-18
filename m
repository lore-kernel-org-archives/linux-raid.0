From: "Glatzel Tino" <tino.glatzel@badenIT.de>
Subject: Raid does not start automatically
Date: Tue, 18 Dec 2007 18:19:06 +0100
Message-ID: <763363C6C69C5A4B9735E3907164812A01148F3B@bit123.badenit.intern>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Hello,


my debian 4.0 box works fine with linux software-raid. today, I have
tested the possibilities of the mdadm tool.
I have removed a disc, I have added a disc and finaly I have stoped a
RAID-device.

After the reboot, I have created a RAID-device with the previously used
partion.

mdadm --create /dev/md8 --raid-devices=2 --level=1 /dev/sda10 missing

mdadm: /dev/sda10 appears to be part of a raid array:
    level=raid1 devices=2 ctime=Tue Dec 18 17:42:58 2007
Continue creating array? y
mdadm: array /dev/md8 started.



After the next reboot, the  device does not start. why ?

can anyone help me ?


Tino
