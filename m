From: Ovidio Borrero <ovidioborrero@gmail.com>
Subject: Mdadm Live data conversion
Date: Mon, 14 Jul 2008 11:19:14 -0700
Message-ID: <487B98A2.7080904@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Greetings,

I posted this on linux forums and was hoping to see what kind of 
responce i could get but they recommended emailing you guys. I apologize 
if i shouldnt be emailing you, but here's my question:

"Well i know in windows i can convert the live drive to a dynamic drive, 
and then create the raid in just a few simple steps, but how can i do 
this in linux? is it possible to convert the hard drive fs type to to 
fd? how can i make sda2 and sdb2 into md0? is this possible? heres my 
current fdisk output:

Disk /dev/sda: 33.5 GB, 33554497536 bytes
255 heads, 63 sectors/track, 4079 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x0005816c

Device Boot Start End Blocks Id System
/dev/sda1 * 1 25 200781 83 Linux
/dev/sda2 26 4079 32563755 8e Linux LVM

Disk /dev/sdb: 33.5 GB, 33554497536 bytes
255 heads, 63 sectors/track, 4079 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0xf3fa89fb

Device Boot Start End Blocks Id System
/dev/sdb1 1 25 200781 fd Linux raid autodetect
/dev/sdb2 26 4079 32563755 fd Linux raid autodetect"
